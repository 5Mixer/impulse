package;

import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	var simulation:Simulation;

	function new() {
		System.start({title: "Impulse", width: 800, height: 600}, function(_) {
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
		simulation = new Simulation();
		simulation.initialise();
		kha.input.Keyboard.get().notify(function(k) {
			simulation.initialise();
		}, null);
	}

	function update() {
		simulation.update();
	}

	function render(framebuffer:Framebuffer) {
		var g = framebuffer.g2;
		g.begin(true, kha.Color.fromValue(0xead2a1));
		simulation.render(g);
		g.end();
	}

	public static function main() {
		new Main();
	}
}
