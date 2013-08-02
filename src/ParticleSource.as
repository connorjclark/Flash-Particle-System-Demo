package  
{
	/**
	 * ...
	 * @author Connor Clark aka Hoten
	 */
	public class ParticleSource 
	{
		private var particleFactory:Function;
		private var x:int, y:int;
		private var numCreated:int;
		private var creationLimit:int;
		
		public function ParticleSource(x:int, y:int, particleFactory:Function, creationLimit:int = -1) {
			this.particleFactory = particleFactory;
			this.creationLimit = creationLimit;
			this.x = x;
			this.y = y;
		}
		
		public function stillValid():Boolean {
			return creationLimit == -1 || numCreated < creationLimit;
		}
		
		public function getNewParticle(mold:Particle = null):Particle {
			numCreated++;
			var p:Particle = particleFactory(mold);
			p.x = x;
			p.y = y;
			p.render();
			return p;
		}
	}
}