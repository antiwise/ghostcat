package ghostcat.display.graphics
{
	import flash.display.DisplayObject;
	
	import ghostcat.display.GBase;
	
	/**
	 * 网格移动对象
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GridItem extends GBase
	{
		/**
		 * 单位网格宽度
		 */
		public var gridWidth:Number;
		
		/**
		 * 单位网格高度
		 */
		public var gridHeight:Number;
		
		private var _enabledGrid:Boolean;
		
		public function GridItem(skin:DisplayObject=null, replace:Boolean=true, enabledGrid:Boolean=true)
		{
			super(skin, replace);
			
			this._enabledGrid = enabledGrid;
		}
		
		/**
		 * 是否贴近网格
		 * @return 
		 * 
		 */
		public function get enabledGrid():Boolean
		{
			return _enabledGrid;
		}
		
		public function set enabledGrid(v:Boolean):void
		{
			_enabledGrid = v;
			x = x;
			y = y;
		}
		/** @inheritDoc*/
		public override function set x(value:Number) : void
		{
			super.x = _enabledGrid ? Math.round(value / gridWidth) * gridWidth : value;
		}
		/** @inheritDoc*/
		public override function set y(value:Number) : void
		{
			super.y = _enabledGrid ? Math.round(value / gridHeight) * gridHeight : value;
		}
	}
}