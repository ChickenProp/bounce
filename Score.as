package {
import net.flashpunk.*;
import net.flashpunk.utils.*;
import net.flashpunk.graphics.*;

public class Score extends Entity {
	public static var multiplier : int = 1;
	static public var scoreG : Text = new Text("               ");
        static public var highScoreG : Text = new Text("               ");

        public function Score () {
                var label1:* = new Text("Score", 0, 0);
                var label2:* = new Text("High score", 150, 0);
		scoreG.x = 60;
                highScoreG.x = 250;
                graphic = new Graphiclist(scoreG, label1, highScoreG, label2);
                x = 10;

		score = 0;
		multiplier = 1;
        }

        override public function update () : void {
                scoreG.text = score.toString();
                highScoreG.text = highScore.toString();
        }

	static public function gain (points:int, x:Number, y:Number) : void {
		score += points*multiplier;
		FP.world.add(new TextParticle(x, y, (points*multiplier)+""));
	}

	public static function get score() : int { return _score; }
        public static function set score(s:int) : void {
                _score = s;
		var m:int = Math.max(highScore, s);
                highScore = m;
        }
        internal static var _score:int;

        public static function get highScore() : int {
                return Data.readInt("highScore");
        }
        public static function set highScore(s:int) : void {
                Data.writeInt("highScore", s);
		Data.save(Game.dataFile);
        }

}
}
