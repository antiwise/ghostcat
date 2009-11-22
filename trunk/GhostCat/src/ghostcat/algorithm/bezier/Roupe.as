package ghostcat.algorithm.bezier
{
	import flash.geom.Point;
	
	import ghostcat.community.physics.RoupeLink;
	
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
		
		public function Roupe(startPoint:Point=null, endPoint:Point=null, seqNum:int=0,elasticity:Number = 0.3,friction:Number = 0.85,gravity:Point = null,hasEnd:Boolean = false)
		{
			super(false);
			createFromSeqNum(startPoint, endPoint, seqNum);
		
			physics = new RoupeLink(elasticity,friction,gravity,hasEnd);
			physics.addAll(path);
		}
	}
}
