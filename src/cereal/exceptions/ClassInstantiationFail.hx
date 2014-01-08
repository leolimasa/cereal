package cereal.exceptions;

class ClassInstantiationFail extends Exception {
    public function new(className:String) {
        message = "Could not instantiate class: " + className;
        print();
    }
}