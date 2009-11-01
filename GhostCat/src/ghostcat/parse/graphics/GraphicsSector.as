package ghostcat.parse.graphics
{
	import flash.display.Graphics;
	
	import ghostcat.parse.DisplayParse;
	import ghostcat.util.display.GraphicsUtil;
	
	/**
	 * 绘制扇形或环
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GraphicsSector extends DisplayParse
	{
		/**
		 * x坐标
		 */
		public var x:Number;
		/**
		 * y坐标
		 */
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
		
		/**
		 * 内环比例 
		 */
		public var inner:Number;
		
		public function GraphicsSector(x:Number,y:Number,wradius:Number,hradius:Number,fromAngle:Number = 0,toAngle:Number = 360,inner:Number = NaN)
		{
			this.x = x;
			this.y = y;
			this.wradius = wradius;
			this.hradius = hradius;
			this.fromAngle = fromAngle;
			this.toAngle = toAngle;
			this.inner = inner;
		}
		
		/** @inheritDoc*/
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			
			if (isNaN(inner))
				GraphicsUtil.drawSector(target,x,y,wradius,hradius,fromAngle,toAngle);
			else
				GraphicsUtil.drawRing(target,x,y,wradius,hradius,fromAngle,toAngle,inner);
		}
	}
}