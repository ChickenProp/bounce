package {
import net.flashpunk.*;
import net.flashpunk.graphics.*;

public class GameOver extends World {
	public function GameOver () {
		addGraphic(new Text("Score: " + Score.score, 200, 220));
		addGraphic(new Text("Best: " + Score.highScore, 200, 260));
	}
}

}
