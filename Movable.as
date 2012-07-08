package {
import net.flashpunk.*;
import net.flashpunk.graphics.*;

public class Movable extends Entity {
        public var vel:vec = new vec(0,0);
	public var friction:Number = 0;

        public function Movable() { 
        }

        public function accel(x2:Number, y2:Number) : void {
                vel.x += x2;
                vel.y += y2;
        }

        public function applyFriction() : void {
                accel(-vel.x*friction, -vel.y*friction);
        }

        public function move() : void {
		applyFriction();
		moveBy(vel.x, vel.y);
        }

        override public function update() : void {
                move();
        }

	public function get game () : Game {
		return world as Game;
	}

	internal var _pos:vec = new vec(0, 0);
	public function get pos () : vec {
		_pos.set(x, y);
		return _pos;
	}
	public function set pos (v:vec) : void {
		_pos = v;
		x = v.x;
		y = v.y;
	}

        public function get image() : Image {
                return _image;
        }
        public function set image(i:Image) : void {
                _image = i;
                graphic = i;
        }
        internal var _image:Image;
}
}
