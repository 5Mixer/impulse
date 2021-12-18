package;

import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.callbacks.CbType;

class Level {
	public var colliders:Array<Polygon> = [];
	public var tiled:Tiled;

	public static var callbackType = new CbType();

	public function new(levelNumber) {
		tiled = new Tiled(switch levelNumber {
			case 1: kha.Assets.blobs.level1_tmx.toString();
			case 2: kha.Assets.blobs.level2_tmx.toString();
			case 3: kha.Assets.blobs.level3_tmx.toString();
			case 4: kha.Assets.blobs.level4_tmx.toString();
			case 5: kha.Assets.blobs.level5_tmx.toString();
			default: "";
		});
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
