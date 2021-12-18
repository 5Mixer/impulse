package;

import kha.Assets;
import nape.shape.Circle;
import nape.callbacks.CbType;
import nape.phys.BodyType;
import kha.graphics2.Graphics;
import nape.phys.Body;
import nape.space.Space;

class Target {
	public var body:Body;

	var radius = 100;

	public static var callbackType = new CbType();

	public function new(x:Float, y:Float, space:Space) {
		body = new Body(BodyType.STATIC);

		body.shapes.add(new Circle(radius));
		body.cbTypes.add(callbackType);
		body.position.setxy(x, y);
		body.space = space;
	}

	public function render(g:Graphics) {
		// g.color = kha.Color.fromBytes(255, 193, 66);
		g.color = kha.Color.fromBytes(255, 0, 106);
		g.drawScaledImage(Assets.images.circle, body.position.x - radius, body.position.y - radius, radius * 2, radius * 2);
	}
}
