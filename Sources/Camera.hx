package;

import kha.math.FastMatrix3;
import kha.math.Vector2;
import kha.graphics2.Graphics;

class Camera {
	public var position:Vector2;
	public var scale:Float;

	var zoomSpeed = 1.09;
	var maximumVisibleX:Int;

	var shakeVector = new Vector2();
	var maximumShakeVectorLength = 100;

	public function new(maximumVisibleX) {
		position = new Vector2();
		scale = 1;
		this.maximumVisibleX = maximumVisibleX;
	}

	public function zoomOn(screenPoint:Vector2, amount:Float) {
		var oldWorldPos = viewToWorld(screenPoint);
		if (amount < 0) {
			scale *= -amount * zoomSpeed;
		} else {
			scale /= amount * zoomSpeed;
		}
		scale = Math.max(0.5, scale);
		scale = Math.min(2, scale);

		scale = Math.max(scale, kha.Window.get(0).width / maximumVisibleX);
		var newWorldPos = viewToWorld(screenPoint);
		position = position.add(worldToView(oldWorldPos).sub(worldToView(newWorldPos)));
	}

	public function follow(x:Float, y:Float) {
		scale = Math.max(scale, kha.Window.get(0).width / maximumVisibleX);
		position.x = scale * x - kha.Window.get(0).width / 2;
		position.y = scale * y - kha.Window.get(0).height / 2;
		position.x = Math.max(0, Math.min(position.x, scale * maximumVisibleX - kha.Window.get(0).width));
	}

	public function worldToView(point:Vector2) {
		var fast = getTransformation().multvec(point.fast());
		return new Vector2(fast.x, fast.y);
	}

	public function viewToWorld(point:Vector2) {
		var fast = getTransformation().inverse().multvec(point.fast());
		return new Vector2(fast.x, fast.y);
	}

	public function getTransformation() {
		return FastMatrix3.translation(-Math.round(position.x + shakeVector.x), -Math.round(position.y + shakeVector.y))
			.multmat(FastMatrix3.scale(Math.round(scale * 100) / 100, Math.round(scale * 100) / 100));
	}

	public function applyShake(vector:Vector2) {
		shakeVector.x += vector.x;
		shakeVector.y += vector.y;
	}

	public function transform(g:Graphics) {
		shakeVector.length *= .97;
		if (shakeVector.length != 0) {
			if (shakeVector.length > maximumShakeVectorLength) {
				shakeVector.length = maximumShakeVectorLength;
			}
		}
		g.pushTransformation(getTransformation());
	}

	public function reset(g:Graphics) {
		g.popTransformation();
	}
}
