package {
import net.flashpunk.*;
import net.flashpunk.graphics.*;
import net.flashpunk.utils.*;

public class Shadows extends Player {
	public var player : Player;
	public var gl:Graphiclist;
	public var positions:Vector.<vec>;
	public function Shadows () {
		gl = new Graphiclist;
		graphic = gl;
		graphic.relative = false;
	}

	override public function update () : void {
		player = game.player;
		gl.removeAll();

		x = player.x;
		y = player.y;

		if (player.dragging)
			display();
	}

	public function display () : void {
		positions = new Vector.<vec>();
		fling2(player.dragLen(), player.dragDir());

		var i:int = 0;
		while (moving) {
			doMotion();
			i++;

			if (i % 5 == 0)
				addShadow(x, y);
		}
	}

	override public function stoppedMoving () : void {
		moving = false; // don't update shinies like in parent.
	}

	override public function bounceEffects () : void {}

	public function addShadow(_x:Number, _y:Number) : void {
		positions.push(new vec(x, y));
	}

	public function hide () : void {
		positions = new Vector.<vec>();
	}

	override public function render () : void {
		for each (var v:vec in positions)
			Draw.rect(v.x, v.y, 1, 1, 0xFF0000);
	}

	override public function set scoremult (m:int) : void {}
}
}
