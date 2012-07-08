package {
import net.flashpunk.*;
import net.flashpunk.graphics.*;

public class Shiny extends Movable {
	public var value:int = 10;
	public var alive:Boolean = true;
	public var diedPeacefully:Boolean = false;
	
	public function Shiny (x:Number, y:Number) {
		pos = new vec(x, y);
		image = Image.createCircle(5, 0x00FF00);
		image.centerOrigin();
		centerOrigin();
	}

	public function wasntHit () : void {
		if (value == 10) {
			value = 5;
			image = Image.createCircle(5, 0x0000FF);
		}
		else if (value == 5) {
			value = 2;
			image = Image.createCircle(5, 0xFF0000);
		}
		else {
			value = 0;
			alive = false;
			diedPeacefully = true;
			world.remove(this);
		}
		image.centerOrigin();
	}

	public function hit () : void {
		alive = false;
		diedPeacefully = false;
		world.remove(this);
	}
}
}
