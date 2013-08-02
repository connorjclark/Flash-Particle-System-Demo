package  
{
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	/**
	 * ...
	 * @author Connor Clark aka Hoten
	 */
	public class ParticleDisplay extends Sprite
	{
		
		private var particleSources:Vector.<ParticleSource> = new Vector.<ParticleSource>();
		private var particles:Vector.<Particle> = new Vector.<Particle>();
		private var pool:Vector.<Particle> = new Vector.<Particle>();
		
		public function ParticleDisplay() {
			filters.push(new BlurFilter(8, 8, 1));
		}
		
		public function getNumberOfActiveParticles():int {
			return particles.length;
		}
		
		public function getNumberOfPooledParticles():int {
			return pool.length;
		}
		
		public function update():void {
			//loops thru all the sources, and make some new particles
			for (var j:int = 0; j < particleSources.length; j++) {
				var source:ParticleSource = particleSources[j];
				if (source.stillValid()) {
					var mold:Particle = pool.length > 0 ? pool.pop() : null;
					addParticle(source.getNewParticle(mold));
				}else particleSources.splice(j, 1);
			}
			
			//step thur all the particles
			for (var i:int = 0; i < particles.length; i++) {
				var p:Particle = particles[i];
				if (p.stillValid()) {
					p.update();
				}else {
					removeChild(p);
					particles.splice(i, 1);
					
					//reset particle and add to pool
					p.init();
					pool.push(p);
				}
			}
			
			//basic pool management
			if (pool.length > 1000 && particles.length < 250) pool.splice(0, 750);
		}
		
		public function clearSources():void {
			particleSources.splice(0, particleSources.length);
		}
		
		public function addParticleSource(src:ParticleSource):void {
			particleSources.push(src);
		}
		
		private function addParticle(p:Particle):void {
			addChild(p);
			particles.push(p);
		}
	}
}