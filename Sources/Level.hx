package;

import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.callbacks.CbType;

class Level {
	public var colliders:Array<Polygon> = [];
	public var tiled:Tiled;

	public static var callbackType = new CbType();

	public function new(levelNumber) {
		if (levelNumber < 1 || levelNumber > 10)
			return;
		tiled = new Tiled(kha.Assets.blobs.get('level${levelNumber}_tmx').toString());

		for (polygon in tiled.polygons) {
			for (triangle in polygon.triangles) {
				var vertices = [];
				for (point in triangle.points)
					vertices.push(Vec2.weak(point.x, point.y));

				var polygon = new Polygon(vertices);
				polygon.cbTypes.add(callbackType);
				colliders.push(polygon);
			}
		}
	}

	public function render(g:kha.graphics2.Graphics) {
		for (polygon in tiled.polygons) {
			polygon.render(g);
		}
	}
}
