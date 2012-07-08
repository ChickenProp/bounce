package {
import net.flashpunk.*;
import net.flashpunk.graphics.*;

public class Shadows extends Player {
	public var player : Player;
	public var gl:Graphiclist;
	public function Shadows () {
		gl = new Graphiclist;
		graphic = gl;
		graphic.relative = false;
	}

	override public function update () : void {
		FP.console.log("shadows update");
		player = game.player;
		gl.removeAll();

		x = player.x;
		y = player.y;

		if (player.dragging)
			display();
	}

	public function display () : void {
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

	override public function doMotion () : void {
		FP.console.log(pos + ', ' + vel);
		super.doMotion();
	}

	public function addShadow(_x:Number, _y:Number) : void {
		var i:Image = Image.createCircle(1, 0xFF0000);
		i.centerOrigin();
		i.x = _x;
		i.y = _y;
		gl.add(i);
	}

	override public function set scoremult (m:int) : void {}
}
}
