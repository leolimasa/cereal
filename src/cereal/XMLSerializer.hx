package cereal;

/**
*
*
**/
class XMLSerializer extends Serializer {

    public function nodeToString(node:Node) : String {
        var root = Xml.createDocument();
        return nodeToXml(node, root).toString();
    }

    public function stringToNode(str:String) : Node {
        return xmlToNode(Xml.parse(str));
    }

    private function xmlToNode(xml:Xml) : Node {
        var n = new Node();
        n.name = xml.nodeName;

        for (a in xml.attributes) {
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

    private function nodeToXml(node:Node, root:Xml) : Xml {
        var el = root.createElement(node.name);
        for (a in node.attributes.keys()) {
            el.set(a, node.attributes.get(a));
        }

        for (c in node.collections.keys()) {
            var xmlcol = root.createElement(c);
            for (v in node.collections.get(c)) {
                xmlcol.addChild(nodeToXml(v, root));
            }
            el.addChild(xmlcol);
        }
        return el;
    }

}