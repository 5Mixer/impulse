package;

import nape.geom.Vec2;
import nape.shape.Polygon;
import kha.math.FastMatrix3;
import nape.phys.BodyType;
import kha.graphics2.Graphics;
import nape.phys.Body;
import nape.space.Space;

class Plane {
	public var body:Body;

	var width = 30;
	var height = 10;
	var image:kha.Image;

	public function new(x:Float, y:Float, space:Space) {
		body = new Body(BodyType.DYNAMIC);

		body.shapes.add(new Polygon(Polygon.box(width, height)));
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

	public function render(g:Graphics) {
		g.pushTransformation(g.transformation.multmat(FastMatrix3.translation(body.position.x + width / 2, body.position.y + height / 2))
			.multmat(FastMatrix3.rotation(body.rotation))
			.multmat(FastMatrix3.translation(-body.position.x - width / 2, -body.position.y - height / 2)));

		g.drawScaledImage(image, body.position.x, body.position.y, width, height);

		g.popTransformation();
	}
}
