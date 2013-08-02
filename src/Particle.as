package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Connor Clark aka Hoten
	 */
	public class Particle extends Sprite
	{			
		public var life:int;
		public var color:uint;
		public var numRings:int;
		
		//multipliers
		public var growth:Number;
		public var drag:Number;
		
		//accumulators
		public var xVel:Number;
		public var yVel:Number;
		public var fade:Number;
		public var gravity:Number;
		
		public function Particle() {
			init();
		}
		
		public function init():void {
			life = 100;
			color = 0;
			numRings = 10;
			growth = 1;
			drag = 1;
			xVel = 0;
			yVel = 0;
			fade = 0;
			gravity = 0;
			alpha = 1;
		}
		
		public function setSize(size:Number):void {
			scaleX = scaleY = size;
		}
		
		public function stillValid():Boolean {
			return alpha > 0;
		}
		
		public function update():void {
			if (life-- <= 0) fade = 0.1;
			
			//apply multipliers
			xVel *= drag;
			yVel *= drag;
			scaleX *= growth;
			scaleY *= growth;
			
			//apply accumulators
			yVel += gravity;
			x += xVel;
			y += yVel;
			alpha -= fade;
		}
		
		public function render():void {
			graphics.clear();
			graphics.lineStyle();			
			
			for (var i:int = 0; i < numRings; i++) {
				graphics.beginFill(color, (i + 1) / numRings);
				graphics.drawCircle(0, 0, (numRings - i) / numRings);
			}
			graphics.endFill();
		}
	}
}