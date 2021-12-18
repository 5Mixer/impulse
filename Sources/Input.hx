package;

import kha.input.Mouse;

class Input {
	static var leftButton = false;
	static var rightButton = false;

	public static function init() {
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
	}

	public static function isLeftDown() {
		return leftButton;
	}

	public static function isRightDown() {
		return rightButton;
	}
}
