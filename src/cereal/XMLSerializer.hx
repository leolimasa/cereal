package engine;

import engine.exceptions.ClassInstantiationFail;
import engine.exceptions.ClassNotRegistered;
using cereal.StringHelp;

/**
* Abstract class responsible for converting a series of nodes into an object structure. For example:

Given the following node structure (pseudocode - not syntatically correct):

root = new Node();
root.name = "house";
root.attributes = {"color": "red", "grass": "green", "size":"30"};
root.collections = [{
		"construction":
			new Node("name": "window", "attributes": {"type":"glass"}),
			new Node("name": "door", "attributes": {"type": "wood"})
	}
]

Calling inflator.inflate(house, root) would be equivalent to this:

house.color = "red";
house.grass = "green";
house.size = 30;

var child1 = new Window();
child1.type = "glass";

var child2 = new Door();
child2.type = "wood";

house.construction = [child1, child2];

**/
class XMLSerializer {
    public var classes:Map<String, String>;
    public static var defaultClasses:Map<String, String>;

    /* ............................................................................... */

    static function __init__() {
        defaultClasses = new Map<String, String>();
    }

    /* ............................................................................... */

    public function new() {
        classes = new Map<String, String>();
    }

    /* ............................................................................... */



    /* ............................................................................... */

    /**
    * Converts an object into a node
    **/
    public function serialize(root:Dynamic) {

    }

    /* ............................................................................... */



}