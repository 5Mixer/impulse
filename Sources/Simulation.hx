package;

import kha.Scheduler;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import kha.graphics2.Graphics;

class Simulation {
	var space:Space;
	var plane:Plane;
	var camera:Camera;

	var width = 10000;
	var height = 2000;

	public function new() {
		var gravity = Vec2.weak(0, 800);
		space = new Space(gravity);

		initialise();
		camera = new Camera(width);
	}

	public function initialise() {
		space.clear();

		plane = new Plane(100, 100, space);

		var boundary = new Body(BodyType.STATIC);
		boundary.shapes.add(new Polygon(Polygon.rect(0, 0, -1, height)));
		boundary.shapes.add(new Polygon(Polygon.rect(width, 0, 1, height)));
		boundary.shapes.add(new Polygon(Polygon.rect(0, height, width, 1)));
		boundary.space = space;
	}

	public function update() {
		plane.update();
		space.step(1 / 60);
	}

	public function render(g:Graphics) {
		camera.follow(plane.body.position.x, plane.body.position.y);
		camera.transform(g);
		g.color = kha.Color.Black;
		g.fillRect(0, 0, 1, height);
		g.fillRect(0, height, width, 1);
		g.fillRect(width, 0, 1, height);

		for (x in 0...40) {
			for (y in 0...40) {
				g.fillRect(x * 150, y * 150, 6, 6);
			}
		}

		plane.render(g);
		camera.reset(g);
	}
}
