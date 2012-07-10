package {
import net.flashpunk.*;
import net.flashpunk.utils.*;
import net.flashpunk.graphics.*;
import net.flashpunk.tweens.misc.*;

public class Game extends World {
[Embed(source = 'media/vibe-ace.mp3')]
	private const BgMusicClass:Class;
	public var music:Sfx = new Sfx(BgMusicClass);
	
	public static var dataFile:String = "philh-bounce-data";
	public var player:Player;
	public var shadows:Shadows;
	public var background:Entity;
	public var frame:int = 0;
	public var targetShinyCount : int = 1;
	public var timeTween : NumTween;
	public var timer : Entity;
	public var cameraVel : vec = new vec(0, 0);
	public var gameOver : Boolean = false;

	public function Game () {
		background = new Entity;
		background.graphic = Image.createRect(400, 400, 0x000000);
		background.x = 40;
		background.y = 40;
		add(background);

		timer = new Entity;
		timer.x = 450;
		timer.y = 40;
		add(timer);

		add(new Score);
		
		player = new Player;
		add(player);
		shadows = new Shadows;
		add(shadows);

		add(new Shiny(100, 100));

		timeTween = new NumTween();
		timeTween.tween(400, 0, 60*60);

		music.play(1);
	}
	
	override public function update () : void {
		super.update();

		if (Input.pressed(Key.F5))
			FP.console.enable();

		cameraVel.x -= FP.camera.x;
		cameraVel.y -= FP.camera.y;
		cameraVel.setmul(0.3);
		FP.camera.x += cameraVel.x;
		FP.camera.y += cameraVel.y;

		frame++;
		timeTween.update();
		if (timeTween.value == 0)
			gameOver = true;
		timer.graphic = timeTween.value
			? Image.createRect(20, timeTween.value||1, 0xFF0000)
			: null;
	}

	public function playerFlung () : void {
		shadows.hide();
	}

	public function updateShinies () : void {
		var shinies:Array = [];
		getClass(Shiny, shinies);
		var shinyCount:int = 0;
		var shinyTimedOut:Boolean = false;

		for each (var s:Shiny in shinies) {
			s.wasntHit();
			if (s.alive)
				shinyCount++;
			if (s.diedPeacefully)
				shinyTimedOut = true;
		}

		if (shinyCount == 0 && !shinyTimedOut)
			targetShinyCount++;

		for (var i:int = 0; i < targetShinyCount - shinyCount; i++)
			add(new Shiny(FP.rand(394)+43, FP.rand(394)+43));
	}

	public function bounceWalls () : void {
		cameraVel.setadd(player.vel.mul(5));
	}
}
}
