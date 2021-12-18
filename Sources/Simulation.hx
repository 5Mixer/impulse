package;

import nape.callbacks.InteractionType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionListener;
import kha.Window;
import Touchpad;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.space.Space;
import kha.graphics2.Graphics;

class Simulation {
	var space:Space;
	var plane:Plane;
	var camera:Camera;

	var width = 10000;
	var height = 2000;

	var touchpad:Touchpad;
	var level:Level;

	public function new() {
		var gravity = Vec2.weak(0, 500);
		space = new Space(gravity);

		touchpad = new Touchpad();

		initialise();
		camera = new Camera(width);
	}

	function getCollisionListener() {
		return new InteractionListener(CbEvent.BEGIN, InteractionType.ANY, Plane.callbackType, Level.callbackType, function(callback:InteractionCallback) {
			initialise();
		});
	}

	public function initialise() {
		space.clear();
		space.listeners.add(getCollisionListener());

		level = new Level(1);
		var boundary = new Body(BodyType.STATIC);
		for (shape in level.colliders)
			boundary.shapes.add(shape);
		boundary.space = space;

		plane = new Plane(200, 0, space);

		// var boundary = new Body(BodyType.STATIC);
		// boundary.shapes.add(new Polygon(Polygon.rect(0, 0, -1, height)));
		// boundary.shapes.add(new Polygon(Polygon.rect(width, 0, 1, height)));
		// boundary.shapes.add(new Polygon(Polygon.rect(0, height, width, 1)));
		// boundary.space = space;
	}

	public function update() {
		touchpad.screenPosition.x = 160;
		touchpad.screenPosition.y = Window.get(0).height - 160;
		plane.update(touchpad);
		space.step(1 / 60);
	}

	public function render(g:Graphics) {
		g.color = kha.Color.fromValue(0xffffedc9);
		// var interval = 100;
		// for (x in 0...Math.ceil(Window.get(0).width / interval)) {
		// 	for (y in 0...Math.ceil(Window.get(0).height / interval)) {
		// 		g.fillRect((x * interval - camera.position.x) % Window.get(0).width, (y * interval - camera.position.y) % Window.get(0).height, 5, 5);
		// 	}
		// }

		camera.follow(plane.body.position.x, plane.body.position.y);
		camera.transform(g);

		g.color = kha.Color.White;

		level.render(g);

		plane.render(g);
		camera.reset(g);
		touchpad.render(g);
	}
}
