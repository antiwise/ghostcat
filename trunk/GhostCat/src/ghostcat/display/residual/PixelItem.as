package ghostcat.display.residual
{
	/**
	 * 像素对象
	 * @author flashyiyi
	 * 
	 */
	public class PixelItem
	{
		public var x:Number;
		public var y:Number;
		public var color:uint;
		
		public function PixelItem(x:Number,y:Number,color:uint)
		{
			this.x = x;
			this.y = y;
			this.color = color;
		}
	}
}