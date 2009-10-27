package ghostcat.parse.graphics
{
	import flash.display.Graphics;
	
	import ghostcat.parse.DisplayParse;
	import ghostcat.util.display.GraphicsUtil;
	
	/**
	 * 扇形
	 * @author flashyiyi
	 * 
	 */
	public class GraphicsSector extends DisplayParse
	{
		public var x:Number;
		public var y:Number;
		/**
		 * x轴半径 
		 */
		public var wradius:Number;
		/**
		 * y轴半径 
		 */
		public var hradius:Number;
		/**
		 * 起始角度(0-360)
		 */
		public var fromAngle:Number;
		/**
		 * 结束角度(0-360)
		 */
		public var toAngle:Number;
		
		public function GraphicsSector(x:Number,y:Number,wradius:Number,hradius:Number,fromAngle:Number = 0,toAngle:Number = 360)
		{
			this.x = x;
			this.y = y;
			this.wradius = wradius;
			this.hradius = hradius;
			this.fromAngle = fromAngle;
			this.toAngle = toAngle;
		}
		
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			
			GraphicsUtil.drawSector(target,x,y,wradius,hradius,fromAngle,toAngle);
		}
	}
}