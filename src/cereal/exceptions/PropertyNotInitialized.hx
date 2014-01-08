package cereal.exceptions;

class PropertyNotInitialized extends Exception {
    public function new(propName:String) {
        message = "Property has not been initialized or does not exist: " +
        propName;
        print();
    }
}