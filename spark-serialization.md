# Spark Serialization

Spark serializes data between nodes, between memory and disk, as RDDs or broadcast variables, via either a Java or Kyro serializer, see [Data serialization](https://spark.apache.org/docs/latest/tuning.html#data-serialization). When the Java serializer can't serialize something it will fail with a `java.io.NotSerializableException` and reveal a serialization stack.

The [KyroSerializer](https://spark.apache.org/docs/latest/tuning.html#data-serialization) is faster and doesn't require classes implement `java.io.Serializable` but doesn't work with all classes and requires class registration for best performance. When the KyroSerializer fails it will throw a `com.esotericsoftware.kryo.KryoException` and reveal a serialization trace.

## Task serialization

Spark also serialises UDFs (aka task serialization) as closures using the  JavaSerializer (see [here](https://stackoverflow.com/a/40261550/149412)).

When UDFs are serialized any outer context that is referenced is also serialized. eg: if a function references a field in a class, then the whole class is serialized as well. 

Members of singletons (ie: static members) are available on all executors, don't require serialization, and can be referenced from a UDF. If you have a member of a singleton that you want to vary between test and production code, you can place your UDF in a Trait and mix it into a prod object and a test object.

Anything in the UDF will be executed for each row. In this example, `s3Factory()` will be called for every row this udf is executed on: 

```
udf((link: String) => extract(s3Factory(), bucket)(link))
```

### Task not serializable

When task serialization fails you'll get a stack trace like:

```
Exception in thread "main" org.apache.spark.SparkException: Task not serializable
  at org.apache.spark.util.ClosureCleaner$.ensureSerializable(ClosureCleaner.scala:340)
  at org.apache.spark.util.ClosureCleaner$.org$apache$spark$util$ClosureCleaner$$clean(ClosureCleaner.scala:330)
  at org.apache.spark.util.ClosureCleaner$.clean(ClosureCleaner.scala:156)
  at org.apache.spark.SparkContext.clean(SparkContext.scala:2294)
...
Caused by: java.io.NotSerializableException: com.amazonaws.services.s3.AmazonS3Client
Serialization stack:
  - object not serializable (class: com.amazonaws.services.s3.AmazonS3Client, value: com.amazonaws.services.s3.AmazonS3Client@4cddc3d9)
```

If an object can't be serialized by the JavaSerializer, you can either
* remove the unserializable object from the object graph being serialized if it is not actually needed
* enable the Kyro serializer and try broadcasting it
* make it a `lazy val` so it is created once per task/partition by an executor, as per here [Using Transient Lazy Val's To Avoid Spark Serialisation Issues](https://nathankleyn.com/2017/12/29/using-transient-and-lazy-vals-to-avoid-spark-serialisation-issues/) - note `@transient` isn't strictly necessary. In effect, the `lazy val` creates a function that creates the unserializable object on first access. This function can't contain an already created version of the object because serialization of it will be attempted.
* make the object a member of a singleton object
* if your UDF calls a class function or uses a class instance variable, it will try and serialize the whole class, see [Task not serializable: java.io.NotSerializableException when calling function outside closure only on classes not objects](https://stackoverflow.com/questions/22592811/task-not-serializable-java-io-notserializableexception-when-calling-function-ou/23053760#23053760). One solution is to make the function a member of a singleton object.
* move the creation of the unserializable object into a generator/iterator, which doesn't need to be serialized, and use mapPartitions eg:

  ```scala 
      uniqueLinks.mapPartitions { rowIterator =>
        new AbstractIterator[Row] {

          // s3 is not serializable, but we can create one here
          // it will be created once per task/partition
          val s3 = {
            val s3Config = new ClientConfiguration().withMaxConnections(200)
            val s3 = AmazonS3ClientBuilder.standard().withClientConfiguration(s3Config).withRegion(config.awsRegion).build()
            logger.info(s"Created AmazonS3 $s3")
            s3
          }

          def hasNext: Boolean = {
            rowIterator.hasNext
          }

          def next(): Row = {
            val row = rowIterator.next()

            val key = row.getAs[String]("s3Key")
            val object = s3.getObject("bucket, key)
            val data = ....

            Row(link,data.orNull)
          }
        }
      }(RowEncoder(dataSchema))
  ```

  This is equivalent to using map with a `lavy val s3` outside the map.

### A note on using lazy vals in Scala 2.11

In Scala 2.11, an anonymous function (eg: UDF) that closes over a local lazy val, defined in the method of a trait, will maintain a reference to the object it is mixed into, which then needs to be serializable. In this example, `udf` will contain an `$outer` reference to an ObjectA instance:

```scala
trait TraitA {

  def traitFoo(s: String): () => String = {
    lazy val lazys = s

    val udf = () => {
      lazys
    }
    udf
  }
  
}

object ObjectA extends TraitA { ... }
```

To avoid this either:

* don't use a lazy val
* define the method as a static method on an `object`
* use Scala 2.12

The same problem will occur if the udf closes over a lazy val and is defined on a class as an instance method.

For more examples see [scala-anonfun-debug](https://github.com/tekumara/scala-anonfun-debug)

## Kryo serialization errors

If Kryo has trouble serializing it doesn't always give helpful errors, eg:
```
java.lang.NoClassDefFoundError: Could not initialize class org.tensorflow.Graph
    at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method)
    at sun.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:62)
    at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45)
    at java.lang.reflect.Constructor.newInstance(Constructor.java:423)
    at com.twitter.chill.Instantiators$$anonfun$normalJava$1.apply(KryoBase.scala:170)
    at com.twitter.chill.Instantiators$$anon$1.newInstance(KryoBase.scala:133)
    at com.esotericsoftware.kryo.Kryo.newInstance(Kryo.java:1090)
    at com.esotericsoftware.kryo.serializers.FieldSerializer.create(FieldSerializer.java:570)
    at com.esotericsoftware.kryo.serializers.FieldSerializer.read(FieldSerializer.java:546)
    at com.esotericsoftware.kryo.Kryo.readObjectOrNull(Kryo.java:759)
    at com.esotericsoftware.kryo.serializers.ObjectField.read(ObjectField.java:132)
    at com.esotericsoftware.kryo.serializers.FieldSerializer.read(FieldSerializer.java:551)
    at com.esotericsoftware.kryo.Kryo.readClassAndObject(Kryo.java:790)
    at org.apache.spark.serializer.KryoDeserializationStream.readObject(KryoSerializer.scala:278)
    at org.apache.spark.broadcast.TorrentBroadcast$$anonfun$8.apply(TorrentBroadcast.scala:308)
    at org.apache.spark.util.Utils$.tryWithSafeFinally(Utils.scala:1380)
    at org.apache.spark.broadcast.TorrentBroadcast$.unBlockifyObject(TorrentBroadcast.scala:309)
    at org.apache.spark.broadcast.TorrentBroadcast$$anonfun$readBroadcastBlock$1$$anonfun$apply$2.apply(TorrentBroadcast.scala:235)
    at scala.Option.getOrElse(Option.scala:121)
    at org.apache.spark.broadcast.TorrentBroadcast$$anonfun$readBroadcastBlock$1.apply(TorrentBroadcast.scala:211)
    at org.apache.spark.util.Utils$.tryOrIOException(Utils.scala:1346)
    at org.apache.spark.broadcast.TorrentBroadcast.readBroadcastBlock(TorrentBroadcast.scala:207)
    at org.apache.spark.broadcast.TorrentBroadcast._value$lzycompute(TorrentBroadcast.scala:66)
    at org.apache.spark.broadcast.TorrentBroadcast._value(TorrentBroadcast.scala:66)
    at org.apache.spark.broadcast.TorrentBroadcast.getValue(TorrentBroadcast.scala:96)
    at org.apache.spark.broadcast.Broadcast.value(Broadcast.scala:70)
```

This isn't a classpath issue. You may be able to work around it by broadcasting an object's dependencies, and creating the object from its dependencies on the executor. 