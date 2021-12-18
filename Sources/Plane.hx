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

	var maximumSpeed:Float = 3000;

	public function new(x:Float, y:Float, space:Space) {
		body = new Body(BodyType.DYNAMIC);

		body.shapes.add(new Polygon(Polygon.box(width, height)));
		body.position.setxy(x, y);
		body.allowRotation = false;
		body.setShapeMaterials(nape.phys.Material.glass());
		body.space = space;

		image = kha.Assets.images.plane;
	}

	public function update() {
		var forceAngle = body.rotation;
		if (Input.isLeftDown()) {
			body.rotation -= Math.PI / 2 * (body.velocity.length / 1000);
		}
		if (Input.isRightDown()) {
			body.rotation += Math.PI / 2 * (body.velocity.length / 1000);
		}

		var forceMultiplier = (Input.isLeftDown() || Input.isRightDown()) ? 40 : 0;
		var forceVector = Vec2.weak(Math.cos(body.rotation) * forceMultiplier, Math.sin(body.rotation) * forceMultiplier);
		body.applyImpulse(forceVector);
		body.rotation = Math.atan2(body.velocity.y, body.velocity.x);

		var airResistance = .001;
		body.applyImpulse(Vec2.weak(-body.velocity.x * airResistance, -body.velocity.y * airResistance));

		if (body.velocity.length > maximumSpeed) {
			body.velocity.length = maximumSpeed;
		}
	}

	function accelerateFlight() {
		// var currentDirection = body.rotation;
		// var forceDirection = currentDirection - 0.2;
		body.rotation -= .05;
		var forceMultiplier = 100.;
		var forceVector = Vec2.weak(Math.cos(body.rotation) * forceMultiplier, Math.sin(body.rotation) * forceMultiplier);
		body.applyImpulse(forceVector);
	}

	public function render(g:Graphics) {
		g.pushTransformation(g.transformation.multmat(FastMatrix3.translation(body.position.x + width / 2, body.position.y + height / 2))
			.multmat(FastMatrix3.rotation(body.rotation))
			.multmat(FastMatrix3.translation(-body.position.x - width / 2, -body.position.y - height / 2)));

		g.drawScaledImage(image, body.position.x, body.position.y, width, height);

		g.popTransformation();
	}
}
