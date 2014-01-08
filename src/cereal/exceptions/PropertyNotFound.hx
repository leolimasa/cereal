package cereal.exceptions;

class PropertyNotFound extends Exception {
    public function new(propName:String) {
        message = "Could not find property: " + propName;
        print();
    }
}