package cereal;

using StringHelp;

class Serializer {
    public var types:Map<String,String>;

    public function inflate(contents:String) : Dynamic {
        return nodeToObj(stringToNode(contents));
    }

    public function deflate(obj:Dynamic) : String {
        return nodeToString(objToNode(obj));
    }

    public function nodeToString(node:Node) : String {
        throw "nodeToString is abstract";
    }

    public function stringToNode(str:String) : Node {
        throw "stringToNode is abstract";
    }

    /**
    * Converts an object into a Node
    **/
    public function objToNode(obj:Dynamic) : Node {
        var root = new Node();
        root.name = getTypeName(obj);


    }

    /**
    * Converts a node structure into an object structure
    **/
    public function nodeToObj(node:Node) : Dynamic {

        // instantiates the node class
        var root = createInstance(node.name);

        // Sets attribute values for root
        for (attribute in node.attributes.keys()) {
            var attr:String = node.attributes[attribute];
            var currentVal = Reflect.getProperty(root, attribute);

            if (attr.isFloat()) {
                Reflect.setProperty(root, attribute, Std.parseFloat(attr));
            } else if (attr.isInt()) {
                Reflect.setProperty(root, attribute, Std.parseInt(attr));
            } else if (Std.is(currentVal, Bool)) {
                Reflect.setProperty(root, attribute, attr.toBool());
            } else {
                Reflect.setProperty(root, attribute, attr);
            }
        }

        // Recurse into the collections
        for (collectionAttr in node.collections.keys()) {
            var rootAttr = Reflect.getProperty(root, collectionAttr);

            // If the attribute is not an array, we get the first child of
            // the collection and pass it as an instance
            if (!Std.is(rootAttr, Array)) {
                var inst = nodeToObj(node.collections[collectionAttr][0]);
                Reflect.setProperty(root, collectionAttr, inst);
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
            Reflect.setProperty(root, collectionAttr, resultArr);
        }
    }

    /**
    * Returns a new instance of a class given the class name. The class name
    * has to be mapped to a class object on the "classes" map, or, in its
    * absence, in the static "defaultClasses" map.
    **/

    private function createInstance(name:String):Dynamic {
        var clazz = types[name.toLowerCase()];
        var instance = Type.createInstance(Type.resolveClass(clazz), []);

        if (instance == null) {
            throw new ClassInstantiationFail(clazz);
        }

        return instance;
    }

    private function getTypeName(obj:Dynamic) {
        var type = Type.getClassName(obj);
        for (k in types.keys()) {
            if (types.get(k) == type.toLowerCase()) {
                return k;
            }
        }
        return null;
    }

}