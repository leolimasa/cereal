package cereal;

class StringHelp {

    /* ............................................................................... */

    /**
    * Checks if a string is a float or not - contains all numbers with a dot
    **/
    public static function isFloat(value:String): Bool {
        var r:EReg = ~/^[0-9]+\.+[0-9]+$/;
        return r.match(value);
    }

    /* ............................................................................... */

    /**
    * Checks if a string is an int or not - contains all numbers
    **/
    public static function isInt(value:String): Bool {
        var r:EReg = ~/^[0-9]+$/;
        return r.match(value);
    }

    /* ............................................................................... */

    public static function toBool(value:String): Bool {
        return value == "true";
    }

}