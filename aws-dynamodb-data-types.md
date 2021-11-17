# DynamoDB data types

DynamoDB types include String, Number, Boolean,StringSet, NumberSet, List, Map, and [binary types](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/JavaDocumentAPIBinaryTypeExample.html)

The SDK has a [withJSON](https://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/com/amazonaws/services/dynamodbv2/document/Item.html#withJSON-java.lang.String-java.lang.String-) method that can convert from a JSON string into a DynamoDB Map type.

See

* https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/AppendixSampleTables.html
* https://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/com/amazonaws/services/dynamodbv2/document/Item.html

## Examples

```scala

import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder
import java.util

import com.amazonaws.services.dynamodbv2.document.{DynamoDB, Item}

val client = AmazonDynamoDBClientBuilder.standard.build
val dynamoDB = new DynamoDB(client)

val table = dynamoDB.getTable("ProductCatalog")

// Build a list of related items
val relatedItems = new util.ArrayList[Number]
relatedItems.add(341)
relatedItems.add(472)
relatedItems.add(649)

//Build a map of product pictures
val pictures = new util.HashMap[String, String]
pictures.put("FrontView", "http://example.com/products/123_front.jpg")
pictures.put("RearView", "http://example.com/products/123_rear.jpg")
pictures.put("SideView", "http://example.com/products/123_left_side.jpg")

//Build a map of product reviews
val reviews = new util.HashMap[String, util.List[String]]

val fiveStarReviews = new util.ArrayList[String]
fiveStarReviews.add("Excellent! Can't recommend it highly enough!  Buy it!")
fiveStarReviews.add("Do yourself a favor and buy this")
reviews.put("FiveStar", fiveStarReviews)

val oneStarReviews = new util.ArrayList[String]
oneStarReviews.add("Terrible product!  Do not buy this.")
reviews.put("OneStar", oneStarReviews)

// Build the item
val item = new Item().withPrimaryKey("Id", 123).withString("Title", "Bicycle 123").withString("Description", "123 description").withString("BicycleType", "Hybrid").withString("Brand", "Brand-Company C").withNumber("Price", 500).withStringSet("Color", new util.HashSet[String](util.Arrays.asList("Red", "Black"))).withString("ProductCategory", "Bicycle").withBoolean("InStock", true).withNull("QuantityOnHand").withList("RelatedItems", relatedItems).withMap("Pictures", pictures).withMap("Reviews", reviews)

// Write the item to the table
val outcome = table.putItem(item)

// Convert the document into a String.  Must escape all double-quotes.

val vendorDocument = "{" + "    \"V01\": {" + "        \"Name\": \"Acme Books\"," + "        \"Offices\": [ \"Seattle\" ]" + "    }," + "    \"V02\": {" + "        \"Name\": \"New Publishers, Inc.\"," + "        \"Offices\": [ \"London\", \"New York\"" + "]" + "}," + "    \"V03\": {" + "        \"Name\": \"Better Buy Books\"," + "\"Offices\": [ \"Tokyo\", \"Los Angeles\", \"Sydney\"" + "            ]" + "        }" + "    }"

val item2 = new Item().withPrimaryKey("Id", 210).withString("Title", "Book 210 Title").withString("ISBN", "210-2102102102").withNumber("Price", 30).withJSON("VendorInfo", vendorDocument)

val outcome2 = table.putItem(item2)
```