package {
import net.flashpunk.*;
import net.flashpunk.graphics.*;
import net.flashpunk.utils.*;

public class GameOver extends World {
	public function GameOver () {
		addGraphic(new Text("Score: " + Score.score, 200, 220));
		addGraphic(new Text("Best: " + Score.highScore, 200, 260));
		addGraphic(new Text("Click to play again", 160, 320));
	}

	override public function update () : void {
		if (Input.mousePressed)
			FP.world = new Game();
	}
}

}
