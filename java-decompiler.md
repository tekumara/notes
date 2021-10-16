# java decompiler

To create a `output_dir/input.jar` containing decompiled `.java` files from `input.jar` using Intellij's [fernflower decompiler](https://github.com/fesh0r/fernflower):

```
java -cp /Applications/IntelliJ\ IDEA.app/Contents/plugins/java-decompiler/lib/java-decompiler.jar org.jetbrains.java.decompiler.main.decompiler.ConsoleDecompiler -hdc=0 -dgs=1 -rsy=1 -lit=1 input.jar output_dir/
```
