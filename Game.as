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
	public var instructions : Entity;
	public var cameraVel : vec = new vec(0, 0);
	public var gameStarted : Boolean = false;
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
		timer.graphic = Image.createRect(20, 400, 0xFF0000);
		add(timer);

		instructions = new Entity;
		var txt:String = "click and drag to collect baubles";
		instructions.graphic = new Text(txt, 0, 0, { align: "center" });
		(instructions.graphic as Image).centerOO();
		instructions.x = 240;
		instructions.y = 460;
		add(instructions);

		add(new Score);
		
		player = new Player;
		add(player);
		shadows = new Shadows;
		add(shadows);

		add(new Shiny(100, 100));

		timeTween = new NumTween();
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

		if (gameStarted)
			(timer.graphic as Image).scaleY = timeTween.value/400;
	}

	public function playerFlung () : void {
		if (!gameStarted)
			start();

		shadows.hide();
	}

	public function start () : void {
		music.play(1);
		music.volume = 0;
		FP.tween(music, { volume: 1 }, 12);
		timeTween.tween(400, 0, 60*60);
		remove(instructions);
		gameStarted = true;
	}

	public function updateShinies () : void {
		var shinies:Array = [];
		getClass(Shiny, shinies);
		var shinyCount:int = 0;

		for each (var s:Shiny in shinies) {
			s.wasntHit();
			if (s.alive)
				shinyCount++;
		}

		if (shinyCount == 0)
			targetShinyCount++;

		for (var i:int = 0; i < targetShinyCount - shinyCount; i++) {
			var x:int, y:int;
			var distToShiny:Number, distToPlayer:Number;
			do {
				x = FP.rand(394) + 43;
				y = FP.rand(394) + 43;
			} while (isNearSomething(x, y));
			add(new Shiny(x, y));
		}
	}

	public function isNearSomething (x:Number, y:Number) : Boolean{
		var near:Entity = nearestToPoint("shiny",x,y);
		if (near && near.distanceToPoint(x, y) < 20)
			return true;

		return player.distanceToPoint(x, y) < 100;
	}

	public function bounceWalls () : void {
		cameraVel.setadd(player.vel.mul(5));
	}
}
}
