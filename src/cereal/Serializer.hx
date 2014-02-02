package cereal;

import cereal.exceptions.ClassNotRegistered;
import String;
import cereal.exceptions.PropertyNotInitialized;
import cereal.exceptions.ClassInstantiationFail;
using cereal.StringHelp;


/**
* Abstract class that converts Strings to Objects and Objects to Strings. The format of
* the string will be dependent on how the nodeToString() and stringToNode() methods are
* overriden.
**/
class Serializer {
    public var types:Map<String,String>;

    private function new() {
        types = new Map<String,String>();
    }

    public function inflate(contents:String) : Dynamic {
        return nodeToObj(stringToNode(contents));
    }

    public function deflate(obj:Dynamic) : String {
        return nodeToString(objToNode(obj));
    }

    public function nodeToString(node:Node) : String {
        throw "nodeToString is abstract";
	return "";
    }

    public function stringToNode(str:String) : Node {
        throw "stringToNode is abstract";
	return null;
    }

    public function convert(contents:String, serializer:Serializer) : String {
        serializer.types = types;
        return serializer.nodeToString(stringToNode(contents));
    }

    // ..................................................................................

    /**
    * Converts an object into a Node
    **/
    public function objToNode(obj:Dynamic) : Node {
        var node = new Node();
        node.name = getTypeName(obj);

        for (f in Reflect.fields(obj)) {
            var fieldValue:Dynamic = Reflect.getProperty(obj, f);

            // is a primitive
            if (Std.is(fieldValue, Float)
            || Std.is(fieldValue, Int)
            || Std.is(fieldValue, String)) {
                node.attributes.set(f, Std.string(fieldValue));
	        } else if (Std.is(fieldValue, Bool)) {
                node.attributes.set(f, fieldValue ? "true" : "false");
            }

            // is array
            else if (Std.is(fieldValue, Array)) {
                var collection = new Array<Node>();
                var arr:Array<Dynamic> = fieldValue;
                for (i in arr) {
                    collection.push(objToNode(i));
                }
                node.collections.set(f, collection);
            }

            // is something else, other than null
            else if (fieldValue != null) {
                node.collections.set(f, [objToNode(fieldValue)]);
            }

        }
        return node;
    }

    // ..................................................................................

    /**
    * Converts a node structure into an object structure
    **/
    public function nodeToObj(node:Node) : Dynamic {

        // instantiates the node class
        var root = createInstance(node.name);

        // Sets attribute values for root
        for (attribute in node.attributes.keys()) {
            var attr:String = node.attributes[attribute];
            var fieldName = getFieldNameIgnoreCase(root, attribute);
            var currentVal = Reflect.getProperty(root, fieldName);

            if (attr.isFloat()) {
                Reflect.setProperty(root, fieldName, Std.parseFloat(attr));
            } else if (attr.isInt()) {
                Reflect.setProperty(root, fieldName, Std.parseInt(attr));
            } else if (Std.is(currentVal, Bool)) {
                Reflect.setProperty(root, fieldName, attr.toBool());
            } else {
                Reflect.setProperty(root, fieldName, attr);
            }
        }

        // Recurse into the collections
        for (collectionAttr in node.collections.keys()) {
            var fieldName = getFieldNameIgnoreCase(root, collectionAttr);
            var rootAttr = Reflect.getProperty(root, fieldName);

            // If the attribute is not an array, we get the first child of
            // the collection and pass it as an instance
            if (!Std.is(rootAttr, Array)) {
                var inst = nodeToObj(node.collections[collectionAttr][0]);
                Reflect.setProperty(root, fieldName, inst);
                continue;
            }

            // Ensure that the array has been initialized. If not,
            // just keep going.
            if (rootAttr == null) {
                continue;
            }

            // If the attribute is an array, then we inflate each child and add
            // the inflation results as an array
            var resultArr = new Array();
            for (child in node.collections[collectionAttr]) {
                var inst = nodeToObj(child);
                resultArr.push(inst);
            }
            Reflect.setProperty(root, fieldName, resultArr);
        }

        return root;
    }

    // ..................................................................................

    /**
    * Returns a new instance of a class given the class name. The class name
    * has to be mapped to a class object on the "classes" map, or, in its
    * absence, in the static "defaultClasses" map.
    **/

    private function createInstance(name:String):Dynamic {

        var clazz;
        try {
            clazz = types[name.toLowerCase()];
        } catch(e:Dynamic) {
            throw new ClassNotRegistered(name.toLowerCase());
        }


        // tries to resolve the class
        var cls = Type.resolveClass(clazz);
        if (cls == null) {
            throw new ClassInstantiationFail(clazz);
        }

        // tries to create a new instance of the class
        var instance = Type.createInstance(cls, []);
        if (instance == null) {
            throw new ClassInstantiationFail(clazz);
        }

        return instance;
    }

    // ..................................................................................

    private function getTypeName(obj:Dynamic) {
        var type:String = Type.getClassName(Type.getClass(obj));

        for (k in types.keys()) {
            if (types.get(k).toLowerCase() == type.toLowerCase()) {
                return k;
            }
        }
        throw new ClassNotRegistered(type);
    }

    // ..................................................................................

    private function getFieldNameIgnoreCase(obj:Dynamic, prop:String) : Dynamic {

        for (f in Type.getInstanceFields(Type.getClass(obj))) {
            if (f.toLowerCase() == prop.toLowerCase()) {
                return f;
            }
        }

        throw new PropertyNotInitialized(prop);
    }
}
