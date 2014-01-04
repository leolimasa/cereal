class Inflator {
    public var classes:Map<String, Class>;
    public static var defaultClasses:Map<String, Class>;

    public function inflate(root:Dynamic, node:Node) {

        // Sets attribute values for root
        for (attribute in node.attributes.keys) {
            Reflect.setProperty(root, attribute, node.attributes[attribute]);
        }
    }

    // ________________________________________________________________________

    /**
    * Returns a new instance of a class given the class name. The class name
    * has to be mapped to a class object on the "classes" map, or, in its
    * absence, in the static "defaultClasses" map.
    **/
    public function createInstance(name:String) : Dynamic {
        var classMap = classes;
        if (classMap == null) {
            classMap = Inflator.defaultClasses;
        }

        var clazz = classMap[name];
        return Type.createInstance(clazz, []);
    }

    private function isFloat(value:String): Bool {
        var r:EReg = ~/^[0-9]+\.+[0-9]+$/;
        return r.match(value);
    }

    private function isInt(value:String): Bool {
        var r:EReg = ~/^[0-9]+$/;
        return r.match(value);
    }
}