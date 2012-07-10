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
		image = Image.createCircle(radius, 0xFFFFFF);
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
			pos = realPos.add(dragDir().mul(dragLen()));
		}

		doMotion();

		doCollisions();

		doSound();
	}

	public function maybeBounce (e:String, min:Number, max:Number) : void {
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
			}
		}
		else {
			bouncing[e + '+'] = false;
			bouncing[e + '-'] = false;
		}
			
	}

	public function doMotion () : void {
		motionCount++;
		
		maybeBounce('x', 40, 440);
		maybeBounce('y', 40, 440);

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

	public function dragLen () : Number {
		var len:Number = Math.log(dragStart.sub(mousePos).length + 1);
		return len;
	}

	public function dragDir () : vec {
		return mousePos.sub(dragStart).normalize();
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

		FP.log(stretch.playing);

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
