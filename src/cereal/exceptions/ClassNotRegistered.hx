package cereal.exceptions;

class ClassNotRegistered extends Exception {
    public function new(className:String) {
        message = "Could not map the following string to a class: " +
        className;
        print();
    }
}