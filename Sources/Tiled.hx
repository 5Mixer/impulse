package;

import haxe.xml.*;
import org.poly2tri.*;
import kha.math.Vector2;
import kha.graphics2.Graphics;

class Triangle {
	public var points = new Array<Vector2>();

	public function new() {}
}

class TiledPolygon {
	public var properties:Map<String, String>;
	public var triangles:Array<Triangle>;

	public function new() {}

	public function render(g:Graphics) {
		g.color = kha.Color.fromBytes(114, 161, 126);
		for (triangle in triangles) {
			for (j in 0...3) {
				g.fillTriangle(triangle.points[0].x, triangle.points[0].y, triangle.points[1].x, triangle.points[1].y, triangle.points[2].x,
					triangle.points[2].y);
			}
		}
		g.color = kha.Color.White;
	}
}

class TiledEntity {
	public var position:Vector2;
	public var type:String;

	public function new(x:Int, y:Int, type:String) {
		this.position = new Vector2(x, y);
		this.type = type;
	}
}

class Tiled {
	public var polygons:Array<TiledPolygon> = [];
	public var entities:Array<TiledEntity> = [];

	public function new(data:String) {
		loadRawData(data);
	}

	function loadRawData(raw) {
		var data = Parser.parse(raw);

		var map = data.elementsNamed("map").next();

		for (objectLayer in map.elementsNamed("objectgroup")) {
			if (objectLayer.get("name") == "Colliders")
				loadPolygonLayer(objectLayer);
			if (objectLayer.get("name") == "Entities")
				loadEntityLayer(objectLayer);
		}
	}

	function loadPolygonLayer(objectLayer:Xml) {
		for (object in objectLayer.elements()) {
			var x = Std.parseInt(object.get("x"));
			var y = Std.parseInt(object.get("y"));
			for (element in object.elements()) {
				var entity = new TiledPolygon();
				if (element.nodeName == "properties") {
					entity.properties = new Map<String, String>();
					for (property in element.elements()) {
						entity.properties.set(property.get("name"), property.get("value"));
					}
				}
				if (element.nodeName == "polygon") {
					var points = new Array<Point>();
					for (point in element.get("points").split(" ")) {
						var point_array = point.split(",");
						points.push(new Point(x + Std.parseFloat(point_array[0]), y + Std.parseFloat(point_array[1])));
					}
					entity.triangles = triangulate(points);
				}
				polygons.push(entity);
			}
		}
	}

	function loadEntityLayer(objectLayer:Xml) {
		for (object in objectLayer.elements()) {
			var x = Std.parseInt(object.get("x"));
			var y = Std.parseInt(object.get("y"));
			var type = object.get("type");

			entities.push(new TiledEntity(x, y, type));
		}
	}

	function triangulate(points:Array<Point>):Array<Triangle> {
		var vp = new VisiblePolygon();
		vp.addPolyline(points);
		vp.performTriangulationOnce();
		return compute_attributes(vp);
	}

	function compute_attributes(vp:VisiblePolygon):Array<Triangle> {
		var data = vp.getVerticesAndTriangles();
		var triangle_indices = data.triangles;
		var vertices = data.vertices;
		var n_vertices = Math.floor(vertices.length / 3);
		var n_triangles = vp.getNumTriangles();
		var triangles = new Array<Triangle>();

		var vertex_map_2d = [
			for (i in 0...n_vertices)
				i => new Vector2(vertices[3 * i], vertices[(3 * i) + 1])
		];

		for (i in 0...n_triangles) {
			triangles[i] = new Triangle();
			for (id in triangle_indices.slice(3 * i, 3 * i + 3)) {
				triangles[i].points.push(vertex_map_2d[id]);
			}
		}

		return triangles;
	}
}
