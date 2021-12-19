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

	var touchpad:Touchpad;
	var level:Level;
	var target:Target;

	var levelNumber = 1;

	public function new() {
		var gravity = Vec2.weak(0, 500);
		space = new Space(gravity);

		touchpad = new Touchpad();

		initialise();
		camera = new Camera();
	}

	function getCollisionListener() {
		return new InteractionListener(CbEvent.BEGIN, InteractionType.ANY, Plane.callbackType, Level.callbackType, function(callback:InteractionCallback) {
			initialise();
		});
	}

	function getTargetListener() {
		return new InteractionListener(CbEvent.BEGIN, InteractionType.ANY, Plane.callbackType, Target.callbackType, function(callback:InteractionCallback) {
			nextLevel();
		});
	}

	function nextLevel() {
		if (levelNumber == 10)
			return;
		levelNumber++;
		initialise();
	}

	public function initialise() {
		space.clear();
		space.listeners.add(getCollisionListener());
		space.listeners.add(getTargetListener());

		level = new Level(levelNumber);
		var boundary = new Body(BodyType.STATIC);
		for (shape in level.colliders)
			boundary.shapes.add(shape);
		boundary.space = space;

		for (entity in level.tiled.entities) {
			if (entity.type == "Target") {
				target = new Target(entity.position.x, entity.position.y, space);
			}
		}

		plane = new Plane(0, 0, space);
	}

	public function update() {
		touchpad.screenPosition.x = 160;
		touchpad.screenPosition.y = Window.get(0).height - 160;
		plane.update(touchpad);
		space.step(1 / 60);
	}

	public function render(g:Graphics) {
		g.color = kha.Color.fromValue(0xffffedc9);

		camera.follow(plane.body.position.x, plane.body.position.y);
		camera.transform(g);

		g.color = kha.Color.White;

		level.render(g);
		target.render(g);

		plane.render(g, touchpad.angle);
		camera.reset(g);
		touchpad.render(g);
	}
}
