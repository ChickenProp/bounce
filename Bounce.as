package {
import net.flashpunk.*;
import net.flashpunk.utils.*;
import net.flashpunk.debug.*;
import flash.events.*;

[SWF(width = "480", height = "480")]

public class Bounce extends Engine {
        public function Bounce () {
                super(480, 480, 60, true);
                Data.load(Game.dataFile);
        }

        override public function init():void {
                FP.world = new Game;
        }

	override public function update () : void {
		super.update();

		if (Input.pressed(Key.P)) {
			var game:Game = FP.world as Game;
			game.active = !game.active;
			if (game.gameStarted) {
				if (game.active)
					game.music.resume();
				else
					game.music.stop();
			}
		}
	}
}
}
