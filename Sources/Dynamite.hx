package ;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;

class Dynamite {
    var body:Body;
    public function new(x:Float, y:Float, space:Space) {
        body = new Body(BodyType.DYNAMIC);

        body.shapes.add(new Polygon(Polygon.box(10,20)));
        body.position.setxy(x, y);
        body.setShapeMaterials(nape.phys.Material.glass());
        body.angularVel = Math.random()-.5;
        body.space = space;
    }
    public function render(g:Graphics) {
        g.drawImage(kha.Assets.images.dynamite, body.position.x-5, body.position.y-10, 10, 20, body.rotation);
    }
}