package cereal.exceptions;

class Exception {
    public var message:String;
    public static var ENABLE_EXCEPTION_PRINT = true;

    public function print() {
        if (!ENABLE_EXCEPTION_PRINT) {
            return;
        }
        trace(message);
    }
}