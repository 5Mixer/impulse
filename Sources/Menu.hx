package;

import kha.math.Vector2;
import kha.Scheduler;
import kha.input.Mouse;
import kha.Assets;
import kha.graphics2.Graphics;

class Button {
	public var text:String;
	public var secondaryText = "";
	public var callback:() -> Void;
	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;

	public function new(text, callback) {
		this.text = text;
		this.callback = callback;
	}

	public function render(g:Graphics, x:Float, y:Float, width:Float, height:Float) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;

		g.font = Assets.fonts.OpenSansCondensed_Bold;
		g.fontSize = 60;
		g.color = kha.Color.fromValue(0xff72a17e); // Green
		g.fillRect(x, y, width, height);
		g.color = kha.Color.fromValue(0xff3e3640); // Black
		g.drawString(text, x + 20, y + 10);

		g.color = kha.Color.fromValue(0xcc3e3640); // Black
		g.font = Assets.fonts.OpenSansCondensed_Bold;
		g.drawString(secondaryText, x + 20 + Assets.fonts.OpenSansCondensed_Bold.width(g.fontSize, text), y + 10);

		g.color = kha.Color.White;
	}
}

class Menu {
	var padding = 50;
	var offset:Float = 0;
	var scroll:Float = 0;
	var endOffset:Float = 0;
	var scrollVelocity:Float = 0;
	var downTime = 0.;
	var downPos = new Vector2();

	var buttons:Array<Button> = [];

	public var levelSelectCallback:(level:Int) -> Void;

	public function new() {
		Assets.images.logo.generateMipmaps(1);

		for (level in 0...21) {
			buttons.push(new Button('Level $level', () -> {
				levelSelectCallback(level);
			}));
		}

		Mouse.get(0).notify(mouseDown, mouseUp, mouseMove, null);
	}

	var mouseGrabbing = false;

	function mouseDown(b, x, y) {
		if (!Main.inMenu)
			return;

		mouseGrabbing = true;
		downTime = Scheduler.realTime();
		downPos.x = x;
		downPos.y = y;
	}

	function mouseUp(b, x, y) {
		if (!Main.inMenu)
			return;

		mouseGrabbing = false;
		if (Scheduler.realTime() - downTime < .5 && downPos.sub(new Vector2(x, y)).length < 20) {
			for (button in buttons) {
				if (x > button.x && x < button.x + button.width && y > button.y && y < button.y + button.height) {
					scrollVelocity = 0;
					button.callback();
				}
			}
		}
	}

	function mouseMove(x, y, dx, dy) {
		if (!Main.inMenu)
			return;

		if (mouseGrabbing) {
			scroll += dy;
			scrollVelocity = dy;
		}
		limitScroll();
	}

	function limitScroll() {
		var hardMax = 0;
		var hardMin = -endOffset - padding + kha.Window.get(0).height;
		scroll = Math.min(hardMax, scroll);
		scroll = Math.max(hardMin, scroll);
	}

	public function render(g:Graphics) {
		for (level in 0...21) {
			if (Main.bestTimes.exists(level)) {
				var timeSeconds = Main.bestTimes.get(level);
				buttons[level].text = 'Level $level';
				buttons[level].secondaryText = ' (${Math.round(timeSeconds * 10) / 10}s)';
			}
		}

		if (!mouseGrabbing) {
			scroll += scrollVelocity;
		}
		scrollVelocity *= .9;

		limitScroll();

		var image = Assets.images.logo;
		var width = Math.min(kha.Window.get(0).width - (padding * 2), 500);
		var height = width * (image.height / image.width);
		g.imageScaleQuality = High;
		g.mipmapScaleQuality = High;

		offset = padding + height + padding + scroll;

		for (button in buttons) {
			offset += 40;
			var buttonWidth = Math.min(kha.Window.get(0).width - padding * 2, 500);
			var buttonHeight = 80;
			var buttonX = kha.Window.get(0).width / 2 - buttonWidth / 2;

			button.render(g, buttonX, offset, buttonWidth, buttonHeight);

			offset += buttonHeight;

			g.color = kha.Color.White;
		}

		g.color = kha.Color.fromValue(0xffead2a1); // Yellow
		g.fillRect(0, 0, kha.Window.get(0).width, padding);

		g.color = kha.Color.White;
		g.drawScaledImage(image, kha.Window.get(0).width / 2 - width / 2, padding, width, height);

		endOffset = offset - scroll;

		g.imageScaleQuality = Low;
		g.mipmapScaleQuality = Low;
	}

	public function button(button:Button, g:Graphics) {}
}
