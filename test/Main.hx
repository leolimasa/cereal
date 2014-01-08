import cereal.SerializerTest;
import haxe.unit.TestRunner;
class Main {
    public static function main() {
        var r = new TestRunner();
        r.add(new SerializerTest());
        r.run();
    }
}