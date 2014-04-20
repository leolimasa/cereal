package cereal;

import haxe.unit.TestCase;

class RegularObj {
    public var attr:String = "";
    public function new() {

    }
}

class MockSerializer extends Serializer {
    public function new() {
        super();
        types = new Map<String, String>();
    }
}

class DummyClass {
    public var someObjs:Array<RegularObj>;
    public var children:Array<DummyClass>;
    public var intNumber:Int = 0;
    public var floatNumber:Float = 0;
    public var negativeFloat:Float = 0;
    public var dummyAttr:DummyClass = null;
    public var boolAttr:Bool = false;

    public function new() {
        someObjs = new Array();
        children = new Array();
    }
}

class SerializerTest extends TestCase {

    public function testNodeToObj() {

        var node = new Node();
        var regobj1 = new Node();
        var regobj2 = new Node();
        var child1 = new Node();
        var child2 = new Node();
        var dummy = new Node();

        dummy.name = "dummy";
        dummy.attributes.set("floatNumber", "55.66");


        regobj1.name = "regularobj";
        regobj1.attributes.set("attr", "someattr1");
        regobj2.name = "regularobj";
        regobj2.attributes.set("attr", "someattr2");

        child1.name = "dummy";
        child1.attributes.set("intNumber", "42");
        child1.attributes.set("floatNumber", "3.14");
        child1.attributes.set("negativeFloat", "-3.14");
        child1.collections.set("someobjs", [regobj1]);
        child1.collections.set("dummyAttr", [dummy]);

        child2.name = "dummy";
        child2.collections.set("someobjs", [regobj2]);

        node.name = "dummy";
        node.collections.set("someObjs", [regobj1, regobj2]);
        node.collections.set("children", [child1, child2]);
        node.attributes.set("boolAttr", "true");

        var ser = new MockSerializer();
        ser.types.set("regularobj", "cereal.RegularObj");
        ser.types.set("dummy", "cereal.DummyClass");

        var root:DummyClass = ser.nodeToObj(node);

        assertEquals(2, root.children.length);
        assertEquals(2, root.someObjs.length);
        assertEquals("someattr1", root.someObjs[0].attr);
        assertEquals("someattr2", root.someObjs[1].attr);
        assertEquals(1, root.children[0].someObjs.length);
        assertEquals("someattr1", root.children[0].someObjs[0].attr);
        assertEquals(42, root.children[0].intNumber);
        assertEquals(3.14, root.children[0].floatNumber);
        assertEquals(-3.14, root.children[0].negativeFloat);
        assertEquals(55.66, root.children[0].dummyAttr.floatNumber);
        assertEquals(true, root.boolAttr);

    }

    public function testObjToNode() {
        var r1 = new RegularObj();
        var r2 = new RegularObj();
        r1.attr = "attr1";
        r2.attr = "attr2";

        var dclass2 = new DummyClass();
        dclass2.intNumber = 44;

        var dclass = new DummyClass();
        dclass.dummyAttr = new DummyClass();
        dclass.floatNumber = 0.32;
        dclass.someObjs = [r1,r2];
        dclass.intNumber = 42;
        dclass.dummyAttr = dclass2;
        dclass.boolAttr = true;

        var ser = new MockSerializer();
        ser.types.set("regularobj", "cereal.RegularObj");
        ser.types.set("dummy", "cereal.DummyClass");

        var root:Node = ser.objToNode(dclass);

        assertEquals("dummy", root.name);
        assertEquals("42", root.attributes.get("intNumber"));
        assertEquals("0.32", root.attributes.get("floatNumber"));
        assertEquals("regularobj", root.collections.get("someObjs")[0].name);
        assertEquals("dummy", root.collections.get("dummyAttr")[0].name);
        assertEquals("attr1", root.collections.get("someObjs")[0].attributes.get
        ("attr"));
        assertEquals("attr2", root.collections.get("someObjs")[1].attributes.get
        ("attr"));
    }
}