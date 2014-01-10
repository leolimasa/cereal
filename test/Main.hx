import cereal.XMLSerializerTest;
import cereal.SerializerTest;
import haxe.unit.TestRunner;
class Main {
    public static function main() {
        var r = new TestRunner();
        r.add(new SerializerTest());
        r.add(new XMLSerializerTest());
        r.run();
    }
}