package ;

import kha.Scheduler;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import nape.util.Debug;

class Simulation {
    var space:Space;
    var debug:Debug;
    var dynamite:Array<Dynamite> = [];
    var tiles:Array<Tile> = [];
 
    public function new() {
        var gravity = Vec2.weak(0, 600);
        space = new Space(gravity);
 
        initialise();
    }
 
    public function initialise() {
        var w = 6000;
        var h = 900;

        dynamite = [];
        tiles = [];
        space.clear();

        for (i in 0...60)
            tiles.push(new Tile(Math.floor(50*Math.random())*20,Math.floor(30*Math.random())*20,space));
               
 
        // Create the floor for the simulation.
        //   We use a STATIC type object, and give it a single
        //   Polygon with vertices defined by Polygon.rect utility
        //   whose arguments are (x, y) of top-left corner and the
        //   width and height.
        //
        //   A static object does not rotate, so we don't need to
        //   care that the origin of the Body (0, 0) is not in the
        //   centre of the Body's shapes.
        var floor = new Body(BodyType.STATIC);
        floor.shapes.add(new Polygon(Polygon.rect(50, (h - 50), (w - 100), 1)));
        floor.space = space;
 
        for (i in 0...500) {
            dynamite.push(new Dynamite(i%70*20,Math.floor(i/70)*20, space));
        }
    }

    public function update() {
        space.step(1/60);
    }
    public function render(g:Graphics) {
        for (dynamite in dynamite) {
            dynamite.render(g);
        }
        for (tile in tiles) {
            tile.render(g);
        }
    }
}