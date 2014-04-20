cereal
======

Haxe serialization library for XML, which aims to read and produce a readable
XML without all that technobabble.

Installation
============

haxelib install cereal

Quick Start
===========

Consider the following class:

```haxe
class MyClass {
    public var attribute1:Float;
    public var attribute2:String;
    public var attribute3:MyClass;

}
```

If you run this:

```haxe

var xml = new XMLSerializer();
xml.types.set("mycls", "MyClass");

var c1 = new MyClass();
c1.attribute1 = 10;

var c2 = new MyClass();
c.attribute1 = 5.5;
c.attribute2 = "hello";
c.attribute3 = c1;

var output = xml.deflate(c2);
```

The result of the *output* variable will be:

```xml
<mycls attribute1="5.5" attribute2="hello">
    <attribute3>
        <mycls attribute1="10"></mycls>
    </attribute3>
</mycls>
```

Of course, you can also do the opposite:

```haxe

var c3:MyClass = cast xml.inflate(output);

trace(c3.attribute1); // will output 5.5
trace(c3.attribute2); // will output "hello"
trace(c3.attribute3.attribute1); // will output 10

// and so on...
```

Conversion standard
===================

As you can (hopefully) tell from the example above, the rules are as follows:

* primitive class properties are converted to XML tag attributes
* object class properties are converted to a child tag with another tag representing the new instance
* array class properties will follow the same convention as object properties, except that you can put more than one tag inside the property tag
* classes are mapped to tags by doing "whatever.types.set("yourtagname", "thepathtoyourclass")
* there still isn't a good way to represent arrays of primitives - wrappers need to be written for that. Volunteers are welcome!

If you dive deep enough into the code, you will see that there is an
intermediary Node class that does all the object/string conversion. Feel free
 to use it to create your own serializers (like JSON, YAML, you know it.)

Would you like to know more?
============================

Take a look at the test/ folder, which contains the unit tests,
so you can get a feel of how it is used.

Or, feel free to raise an "issue" on the github menu,
and select the "question" label, and I will answer as soon as I can.

Make sure you assign it to submain.
