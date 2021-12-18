package;

import kha.input.Sensor;
import kha.Window;
import kha.input.Surface;
import kha.input.Mouse;

class Input {
	static var leftButton = false;
	static var rightButton = false;

	static var leftTouches = [];
	static var rightTouches = [];

	public static function init() {
		#if kha_android
		Surface.get().notify(function touchStart(id, x, y) {
			var midpoint = Window.get(0).width / 2;
			if (x < midpoint) {
				leftTouches.push(id);
			} else {
				rightTouches.push(id);
			}
		}, function touchEnd(id, x, y) {
			leftTouches.remove(id);
			rightTouches.remove(id);
		}, null);
		#else
		Mouse.get(0).notify(function mouseDown(button, x, y) {
			if (button == 0)
				leftButton = true;
			if (button == 1)
				rightButton = true;
		}, function mouseUp(button, x, y) {
			if (button == 0)
				leftButton = false;
			if (button == 1)
				rightButton = false;
		}, null, null, function mouseLeave() {
			leftButton = rightButton = false;
		});
		#end
	}

	public static function isLeftDown() {
		#if kha_android
		return leftTouches.length != 0;
		#else
		return leftButton;
		#end
	}

	public static function isRightDown() {
		#if kha_android
		return rightTouches.length != 0;
		#else
		return rightButton;
		#end
	}
}
