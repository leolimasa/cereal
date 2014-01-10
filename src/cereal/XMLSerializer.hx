package cereal;

/**
*
*
**/
class XMLSerializer extends Serializer {

    public function new() {
        super();
    }

    public override function nodeToString(node:Node) : String {
        return nodeToXml(node).toString();
    }

    public override function stringToNode(str:String) : Node {
        return xmlToNode(Xml.parse(str).firstElement());
    }

    private function xmlToNode(xml:Xml) : Node {
        var n = new Node();
        n.name = xml.nodeName;

        for (a in xml.attributes()) {
            n.attributes.set(a, xml.get(a));
        }

        for (el in xml.elements()) {
            var subels = new Array<Node>();
            for (subel in el.elements()) {
                subels.push(xmlToNode(subel));
            }
            n.collections.set(el.nodeName, subels);
        }
        return n;
    }

    private function nodeToXml(node:Node) : Xml {
        var el = Xml.createElement(node.name);
        for (a in node.attributes.keys()) {
            el.set(a, node.attributes.get(a));
        }

        for (c in node.collections.keys()) {
            var xmlcol = Xml.createElement(c);
            for (v in node.collections.get(c)) {
                xmlcol.addChild(nodeToXml(v));
            }
            el.addChild(xmlcol);
        }
        return el;
    }

}