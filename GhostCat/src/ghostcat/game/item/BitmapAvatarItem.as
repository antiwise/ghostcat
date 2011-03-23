package ghostcat.game.item
{
	/**
	 * 8方向人物
	 * @author flashyiyi
	 * 
	 */
	public class BitmapAvatarItem extends BitmapMovieGameItem
	{
		/**
		 * 保存站立时的动画序列，一共9个数组，按顺序分别是左上，上，右上，左，中，右，左下，下，右下
		 */
		public var standAnims:Array;
		/**
		 * 保存跑动时的动画序列，一共9个数组，按顺序分别是左上，上，右上，左，中，右，左下，下，右下
		 */
		public var runAnims:Array;
		
		/**
		 * 方向值 
		 */
		public var direct:int;
		
		public function isRunning():Boolean
		{
			return oldX != x || oldY != y;
		}
		
		public function BitmapAvatarItem(standAnims:Array,runAnims:Array,frameRate:Number)
		{
			this.standAnims = standAnims;
			this.runAnims = runAnims;
			
			super(null, frameRate);
		}
		
		protected override function updatePosition():void
		{
			super.updatePosition();
			this.updateDirect();
		}
		
		protected function updateDirect():void
		{
			if (isRunning())
			{
				var dx:Number = x - oldX;
				var dy:Number = y - oldY;
			
				this.direct = (dx < -Math.abs(dy / 2) ? 0 : dx >  Math.abs(dy / 2) ? 2 : 1) + 
								(dy <  -Math.abs(dx / 2)  ? 0 : dy >  Math.abs(dy / 2) ? 6 : 3)
			}
		}
		
		public override function tick(t:int):void
		{
			this.bitmapDatas = isRunning() ? runAnims[direct] : standAnims[direct];
			super.tick(t);
		}		
	}
}