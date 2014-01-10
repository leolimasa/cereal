package cereal;

import cereal.XMLSerializer;
import haxe.unit.TestCase;

class Cls1 {
    public var children:Array<Cls1>;
    public var attr1:String;
    public var attr2:Int = 0;
    public var attr3:Cls1 = null;

    public function new() {
        children = new Array<Cls1>();
    }

}

class XMLSerializerTest extends TestCase {

    public function testXmlToNode() {
        var testcase = "<cls1 attr1='a1' attr2='3'>
            <children>
                <cls1 attr1='c1' />
                <cls1 attr2='5' />
            </children>
            <attr3>
                <cls1 attr1='aaa' />
            </attr3>
         </cls1>";

        var ser = new XMLSerializer();
        ser.types.set("cls1","cereal.Cls1");
        var obj:Cls1 = ser.inflate(testcase);
        assertEquals("a1", obj.attr1);
        assertEquals(3, obj.attr2);
        assertEquals("c1", obj.children[0].attr1);
        assertEquals(5, obj.children[1].attr2);
        assertEquals("aaa", obj.attr3.attr1);
    }
}