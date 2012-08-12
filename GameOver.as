package {
import net.flashpunk.*;
import net.flashpunk.graphics.*;
import net.flashpunk.utils.*;

public class GameOver extends World {
	public function GameOver () {
		addText("Score: " + Score.score, 220);
		addText("Best: " + Score.highScore, 260);
		addText("Click to play again", 320);
	}

	public function addText(str:String, y:Number) : void {
		var t:Text = new Text(str, 240, y, { align: "center" });
		t.centerOO();
		addGraphic(t);
	}

	override public function update () : void {
		if (Input.mousePressed)
			FP.world = new Game();
	}
}

}
