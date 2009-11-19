package ghostcat.algorithm.bezier
{
	import flash.geom.Point;
	
	/**
	 * 具有物理表现的平滑曲线
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Roupe extends SmoothCurve
	{
		/**
		 * 物理对象
		 */
		public var physics:RoupeLink;
		
		public function Roupe(startPoint:Point=null, endPoint:Point=null, seqNum:int=0)
		{
			super(false);
			createFromSeqNum(startPoint, endPoint, seqNum);
		
			physics = new RoupeLink(path)
		}
		
		/**
		 * 应用物理 
		 * 
		 */
		public function applyPhysics():void
		{
			physics.applyPhysics();
		}
	}
}
