class Node {
    public var attributes:Map<String, String>;
    public var collections:Map<String, Array<Node>>;
    public var name:String;

    public function new() {
        attributes = new Map<String, String>();
        collections = new Map<String, Array<Node>>();
    }
}