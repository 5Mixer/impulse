package;

import kha.Assets;
import kha.math.Vector2;
import kha.input.Surface;
import kha.graphics2.Graphics;

using kha.graphics2.GraphicsExtension;

class Touchpad {
	public var screenPosition:Vector2 = new Vector2(); // Define the centre of the touchpad
	public var radius:Float = 150;

	var visualFingerRadius = 60;

	public var angle:Float = 0;
	public var length:Float = 0; // Normalised such that the touchpad at the extreme radius gives length 1

	var activeFingerID:Int = -1; // -1 means not controlled by a finger currently. (static platforms disallow null integers)

	public function new() {
		Surface.get().notify(touchStart, touchEnd, touchMove);
	}

	function isPositionInside(x, y) {
		return screenPosition.sub(new Vector2(x, y)).length < radius;
	}

	function touchStart(id:Int, x:Float, y:Float) {
		if (!isPositionInside(x, y) || activeFingerID != -1)
			return;

		activeFingerID = id;
		touchMove(id, x, y);
	}

	function touchEnd(id:Int, x:Float, y:Float) {
		if (id == activeFingerID) {
			activeFingerID = -1;
			angle = 0;
			length = 0;
		}
	}

	function touchMove(id:Int, x:Float, y:Float) {
		if (id == activeFingerID) {
			angle = Math.atan2(y - screenPosition.y, x - screenPosition.x);
			length = Math.min(radius, screenPosition.sub(new Vector2(x, y)).length) / radius;
		}
	}

	public function isDown() {
		return activeFingerID != -1;
	}

	public function getVector() {
		return new Vector2(Math.cos(angle) * length, Math.sin(angle) * length);
	}

	public function render(g:Graphics) {
		g.color = kha.Color.fromFloats(1, 1, 1, .2);
		g.drawScaledImage(Assets.images.circle, screenPosition.x - radius, screenPosition.y - radius, radius * 2, radius * 2);

		var touchPoint = screenPosition.add(new Vector2(Math.cos(angle) * length * radius, Math.sin(angle) * length * radius));
		g.drawScaledImage(Assets.images.circle, touchPoint.x - visualFingerRadius, touchPoint.y - visualFingerRadius, visualFingerRadius * 2,
			visualFingerRadius * 2);
	}
}
