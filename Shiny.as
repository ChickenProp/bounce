package {
import net.flashpunk.*;
import net.flashpunk.graphics.*;

public class Shiny extends Movable {
[ Embed(source='media/shiny.png') ] public static const SHINY:Class;
[ Embed(source='media/pickup.mp3') ] public static const PICKUP:Class;
	public var pickup:Sfx = new Sfx(PICKUP);
	public var value:int = 10;
	public var alive:Boolean = true;
	
	public function Shiny (x:Number, y:Number) {
		pos = new vec(x, y);
		image = new Image(SHINY);
		image.color = 0x00FF00;
		image.scale = 20 / image.width;
		image.centerOrigin();
		centerOrigin();
	}

	override public function update () : void {
		image.angle -= 0.25;
	}

	public function wasntHit () : void {
		if (value == 10) {
			value = 5;
			image.color = 0x5555FF;
		}
		else if (value == 5) {
			value = 2;
			image.color = 0xFF2222;
		}
	}

	public function hit () : void {
		alive = false;
		world.remove(this);
		pickup.play();
	}
}
}
