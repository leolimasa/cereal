package cereal;

import cereal.XMLSerializer;
import haxe.unit.TestCase;

class Cls1 {
    public var children:Array<Cls1>;
    public var attr1:String;
    public var attr2:Int;
    public var attr3:Cls1;

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

    public function testNodeToXml() {
        var cls1 = new Cls1();
        cls1.attr1 = "hola";
        cls1.attr2 = 42;
        cls1.attr3 = new Cls1();
        cls1.children = [
            new Cls1(),
            new Cls1()
        ];
        cls1.attr3.attr1 = "hehe";
        cls1.attr3.attr2 = 24;

        var expect = "<cls1 attr1=\"hola\" attr2=\"42\"><children><cls1><children/>"
        + "</cls1><cls1><children/></cls1></children><attr3><cls1 attr1=\"hehe\""
        + " attr2=\"24\"><children/></cls1></attr3></cls1>";
        var ser = new XMLSerializer();

        ser.types.set("cls1", "cereal.Cls1");
        assertEquals(expect, ser.deflate(cls1));
    }
}