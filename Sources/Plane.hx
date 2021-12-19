package;

import kha.math.Vector2;
import nape.callbacks.CbType;
import nape.geom.Vec2;
import nape.shape.Polygon;
import kha.math.FastMatrix3;
import nape.phys.BodyType;
import kha.graphics2.Graphics;
import nape.phys.Body;
import nape.space.Space;

class Plane {
	public var body:Body;

	var width = 60;
	var height = 20;
	var image:kha.Image;

	var locations = [];
	var trailLength = 10;

	public static var callbackType = new CbType();

	public function new(x:Float, y:Float, space:Space) {
		body = new Body(BodyType.DYNAMIC);

		body.shapes.add(new Polygon([
			Vec2.weak(-width / 2, -height / 2),
			Vec2.weak(-width / 2, height / 2),
			Vec2.weak(width / 2, 0)
		]));
		body.cbTypes.add(callbackType);
		body.position.setxy(x, y);
		body.allowRotation = false;
		body.setShapeMaterials(nape.phys.Material.glass());
		body.space = space;
		body.mass = 1;

		image = kha.Assets.images.plane;
	}

	public function update(touchpad:Touchpad) {
		if (Input.isRightDown()) {
			body.applyImpulse(Vec2.weak(touchpad.getVector().x, touchpad.getVector().y).mul(40, true));
		}
		body.rotation = touchpad.angle;

		var airResistance = .01;
		body.applyImpulse(Vec2.weak(-body.velocity.x * airResistance, -body.velocity.y * airResistance));
	}

	public function render(g:Graphics, touchpadAngle:Float) {
		g.color = kha.Color.fromBytes(250, 231, 192);

		if (locations.length > trailLength)
			locations.shift();
		locations.push(new Vector2(body.position.x - Math.cos(body.rotation) * (width / 2 - 6), body.position.y - Math.sin(body.rotation) * (width / 2 - 6)));

		for (locationIndex in 1...locations.length) {
			g.drawLine(locations[locationIndex - 1].x, locations[locationIndex - 1].y, locations[locationIndex].x, locations[locationIndex].y,
				(locationIndex / trailLength) * 12);
		}

		g.color = kha.Color.fromBytes(62, 54, 64);
		g.pushTransformation(g.transformation.multmat(FastMatrix3.translation(body.position.x, body.position.y))
			.multmat(FastMatrix3.rotation(touchpadAngle)) // body.rotation is the real rotation, but can lag a frame.
			.multmat(FastMatrix3.translation(-body.position.x, -body.position.y)));

		g.drawScaledImage(image, body.position.x - width / 2, body.position.y - height / 2, width, height);
		g.popTransformation();
		g.color = kha.Color.White;
	}
}
