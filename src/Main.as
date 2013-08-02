package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Connor Clark aka Hoten
	 */
	public class Main extends Sprite
	{
		private static const SPACE:int = 32;
		private static const DOWN:int = 40;
		
		private var particleDisplay:ParticleDisplay;
		private var particleCountTF:TextField;
		private var newSource:int;
		
		public function Main() 
		{
			stage.quality = "medium";
			init();
		}
		
		private function init():void {
			graphics.beginFill(0);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			graphics.lineStyle(1, 0xFFFFFF);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			particleDisplay = new ParticleDisplay();
			
			particleCountTF = new TextField();
			particleCountTF.textColor = 0xFFFFFF;
			particleCountTF.selectable = false;
			particleCountTF.width = 200;
			
			addChild(particleDisplay);
			addChild(particleCountTF);
		}
		
		private function updateTF():void {
			particleCountTF.text = "Active: " + particleDisplay.getNumberOfActiveParticles();
			particleCountTF.appendText("\nPooled : " + particleDisplay.getNumberOfPooledParticles() + "\n");
			switch(newSource) {
				case 0: particleCountTF.appendText("Fire"); break;
				case 1: particleCountTF.appendText("Smoke"); break;
				case 2: particleCountTF.appendText("Colorful"); break;
				case 3: particleCountTF.appendText("Water"); break;
			}
			particleCountTF.appendText("\nPress down to clear, space to toggle");
			particleCountTF.appendText("\nHold ctrl to make an infinite source");
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			if (e.keyCode == DOWN) particleDisplay.clearSources();
			if (e.keyCode == SPACE) newSource = (newSource + 1) % 4;
		}
		
		private function onMouseUp(e:MouseEvent):void {
			createSource(e.stageX, e.stageY, e.ctrlKey);
		}
		
		private function onFrame(e:Event):void {
			particleDisplay.update();
			updateTF();
		}
		
		private function createSource(x:int, y:int ,makeUnlimited:Boolean):void {
			var factory:Function;
			switch(newSource) {
				case 0: factory = fireParticle; break;
				case 1: factory = smokeParticle; break;
				case 2: factory = particle1; break;
				case 3: factory = waterParticle; break;
			}
			if (makeUnlimited)
				particleDisplay.addParticleSource(new ParticleSource(x, y, factory, -1));
			else
				particleDisplay.addParticleSource(new ParticleSource(x, y, factory, 200));
		}
		
		//particle factories. a 'Factory' takes a mold parameter (recycled from the object pool)
		//and applies certain properties to it. if the mold is null, then we need to create a new
		//particle object
		
		private function range(min:Number, max:Number):Number {
			return Math.random() * (max - min) + min;
		}
		
		private function waterParticle(mold:Particle):Particle {
			var p:Particle = mold == null ? new Particle() : mold;
			p.numRings = 4;
			p.yVel = -range(10, 15);
			p.xVel = range( -1, 1);
			p.color = 0x0000FF;
			p.gravity = 0.4;
			p.growth = .98;
			p.setSize(range(5, 8));
			return p;
		}
		
		private function fireParticle(mold:Particle):Particle {
			var p:Particle = mold == null ? new Particle() : mold;
			p.color = 0xFF0000;
			p.numRings = 5;
			p.gravity = 0.4;
			p.yVel = range( -10, -5);
			p.growth = 0.95;
			p.fade = 0.05;
			p.xVel = range( -2, 2);
			p.drag = 0.97;
			p.setSize(range(8, 12));
			p.scaleY *= 1.5;
			return p;
		}
		
		private function smokeParticle(mold:Particle):Particle {
			var p:Particle = mold == null ? new Particle() : mold;
			p.alpha = 0.6;
			p.numRings = 1;
			p.gravity = -0.3;
			p.color = 0xFFFFFF;
			p.growth = 1.05;
			p.fade = 0.01;
			p.xVel = range( -1, 1);
			p.drag = 0.97;
			p.setSize(range(1, 2));
			return p;
		}
		
		//crazy colors
		private function particle1(mold:Particle):Particle {
			var p:Particle = mold == null ? new Particle() : mold;
			p.xVel = range( -5, 5);
			p.yVel = range( -35, -10);
			p.fade = range(-.02, 0.06);
			p.gravity = .4;
			p.drag = range(0.9, 0.99);
			p.setSize(range(2, 10));
			p.growth = range(0.95, 0.99);
			p.color = range(0, 0xFFFFFF);
			return p;
		}
	}
}