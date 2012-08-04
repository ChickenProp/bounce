package {
import net.flashpunk.*;
import net.flashpunk.graphics.*;
import net.flashpunk.utils.*;
import net.flashpunk.tweens.misc.*;
import flash.utils.getTimer;

public class Player extends Movable {
[ Embed(source='media/stretch.mp3') ] public static const STRETCH:Class;
	public var stretch : Sfx = new Sfx(STRETCH);
[ Embed(source='media/twang.mp3') ] public static const TWANG:Class;
	public var twang : Sfx = new Sfx(TWANG);
[ Embed(source='media/bounce.mp3') ] public static const BOUNCE:Class;
	public var bounce : Sfx = new Sfx(BOUNCE);
[ Embed(source='media/player.png') ] public static const PLAYER:Class;
	public var stretchStopTime : uint = 0;
	public var dragStart : vec;
	public var realPos : vec;
	public var dragging : Boolean = false;
	public var moving : Boolean = false;
	public var radius : Number = 10;
	public var flingtime:int;
	public var flingspeed : Number;
	public var motionCount : int = 0;
	public var bouncing : Object = new Object();
	
	public function Player () {
		image = new Image(PLAYER);
		image.scale = 0.2;
		x = 240;
		y = 240;
		centerOrigin();
		image.centerOrigin();

		bouncing['x-'] = false;
		bouncing['x+'] = false;
		bouncing['y-'] = false;
		bouncing['y+'] = false;
	}

	override public function update () : void {
		if (Input.mousePressed && !moving)
			startDrag();
		if (Input.mouseReleased && dragging)
			fling();

		if (dragging) {
			pos = realPos.add(dragVec());
			image.scaleY = Math.max(dragLen(), 1);
			image.angle = -dragDir().angleD - 90;
		}
		else {
			doMotion();
			doCollisions();
		}

		doSound();

		if (!moving && (world as Game).gameOver)
			FP.world = new GameOver;
	}

	public function maybeBounceDir (e:String,
	                                min:Number, max:Number) : Boolean
	{
		var dir:String = '';
		
		if (pos[e] - radius < min) {
			vel[e] = Math.abs(vel[e]);
			dir = '+';
		}
		else if (pos[e] + radius > max) {
			vel[e] = -Math.abs(vel[e]);
			dir = '-';
		}

		if (dir) {
			if (!bouncing[e + dir]) {
				bouncing[e + dir] = true;
				scoremult++;
				return true;
			}
		}
		else {
			bouncing[e + '+'] = false;
			bouncing[e + '-'] = false;
		}
		return false;
	}

	public function maybeBounce(xmin:Number, xmax:Number,
	                            ymin:Number, ymax:Number) : Boolean
	{
		var bx:Boolean = maybeBounceDir('x', xmin, xmax);
		var by:Boolean = maybeBounceDir('y', ymin, ymax);

		return bx || by;
	}

	public function doMotion () : void {
		motionCount++;

		if (maybeBounce(40, 440, 40, 440))
			bounceEffects();

		var flingtaper:Number = - flingspeed*30 + motionCount - flingtime;

		if (moving && flingtaper > 0) {
			var ns2:Number = Math.max(flingspeed * flingspeed - (flingtaper * flingtaper)/100, 0);
			vel = vel.normalize(Math.sqrt(ns2));

			if (ns2 == 0)
				stoppedMoving();
		}

		// Calling move() here doesn't work due to how Entity.moveBy()
		// does bookkeeping. (The shadow copies the player's x and y,
		// but not the bookkeeping information, and that causes
		// noticeable jiggling in the shadow's motion.)
		x += vel.x;
		y += vel.y;
	}

	public function bounceEffects () : void {
		(world as Game).bounceWalls();
		bounce.play();
		image.angle = -vel.angleD + 90;
	}

	public function dragLen () : Number {
		var len:Number = Math.log(dragStart.sub(mousePos).length + 1);
		return len;
	}

	public function dragDir () : vec {
		return mousePos.sub(dragStart).normalize();
	}

	public function dragVec () : vec {
		return dragDir().mul(dragLen());
	}

	public function startDrag () : void {
		dragStart = new vec(Input.mouseX, Input.mouseY);
		realPos = pos;
		vel.set(0, 0);
		dragging = true;
		playStretch();
	}

	public function fling () : void {
		fling2(dragLen(), dragDir());
		(world as Game).playerFlung();
		stretch.stop();
		stretch.play(); // These two lines reset to position 0, I think.
		stretch.stop();
		twang.play();
		FP.tween(image, {scaleY: 1}, 0.1);
	}

	public function fling2 (len:Number, dir:vec) : void {
		flingspeed = len;
		flingtime = motionCount;
		moving = true;
		dragging = false;

		vel = dir.mul(-flingspeed);
	}

	public function stoppedMoving () : void {
		moving = false;
		game.updateShinies();
		scoremult = 1;
	}

	public function doCollisions() : void {
		var shinies:Array = [];
		world.getClass(Shiny, shinies);

		var shiniesHit:int = 0;

		for each (var s:Shiny in shinies) {
			if (pos.sub(s.pos).length < radius + 10) {
				Score.gain(s.value, s.x, s.y);
				scoremult++;
				shiniesHit++;
				s.hit();
			}
		}
	}

	private var lastMousePos : vec = new vec(-1, -1);
	public function doSound () : void {
		if (dragging && !mousePos.eq(lastMousePos))
			playStretch();

		if (stretch.playing && getTimer() > stretchStopTime)
			stretch.stop();

		lastMousePos = mousePos;
	}

	public function playStretch () : void {
		if (! stretch.playing)
			stretch.resume();
		stretchStopTime = getTimer() + 30;
	}

	public function get mousePos () : vec {
		return new vec(Input.mouseX, Input.mouseY);
	}

	public function get scoremult () : int {
		return Score.multiplier;
	}
	public function set scoremult (m:int) : void {
		Score.multiplier = m;
	}
}
}
