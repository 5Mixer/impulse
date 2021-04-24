package ;

import kha.math.FastMatrix3;
using kha.graphics2.GraphicsExtension;

class Graphics {
    var g:kha.graphics2.Graphics;
    public function new() {

    }
    public function setG2(g:kha.graphics2.Graphics) {
        this.g = g;
    }
    public function drawImage(image, x:Float,y:Float, width, height, angle=0.) {
        if (angle != 0) g.pushTransformation(g.transformation.multmat(FastMatrix3.translation(x + width/2, y + height/2)).multmat(FastMatrix3.rotation(angle)).multmat(FastMatrix3.translation(-x - width/2, -y - height/2)));
        g.drawScaledImage(image, x, y, width, height);
        if (angle != 0) g.popTransformation();
    }
}