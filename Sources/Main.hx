package;

import kha.Storage;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	var simulation:Simulation;
	var menu:Menu;

	public static var inMenu = true;

	public static var bestTimes = new Map<Int, Float>();

	public static function saveBestTimes() {
		Storage.namedFile("bestTimes").writeObject(bestTimes);
	}

	function new() {
		System.start({title: "Impulse", width: 360, height: 740}, function(_) {
			if (Storage.namedFile("bestTimes") != null) {
				var saves = Storage.namedFile("bestTimes").readObject();
				if (saves != null)
					bestTimes = saves;
			}

			Input.init();
			Assets.loadEverything(function() {
				init();
				Scheduler.addTimeTask(function() {
					update();
				}, 0, 1 / 60);
				System.notifyOnFrames(function(framebuffers) {
					render(framebuffers[0]);
				});
			});
		});
	}

	function init() {
		menu = new Menu();
		simulation = new Simulation();
		simulation.initialise();

		menu.levelSelectCallback = (level:Int) -> {
			simulation.openLevel(level);
			inMenu = false;
		}

		simulation.menuCallback = () -> {
			inMenu = true;
		}
	}

	function update() {
		simulation.update();
	}

	function render(framebuffer:Framebuffer) {
		var g = framebuffer.g2;
		g.begin(true, kha.Color.fromValue(0xead2a1));
		if (inMenu) {
			menu.render(g);
		} else {
			simulation.render(g);
		}

		g.end();
	}

	public static function main() {
		new Main();
	}
}
