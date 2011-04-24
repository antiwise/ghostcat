package ghostcat.display.bitmap
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.display.GNoScale;
	import ghostcat.util.display.BitmapGrid9Util;
	
	/**
	 * 将位图切割为9片使位图Grid-9生效 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapGrid9Shape extends GNoScale
	{
		private var _bitmapData:BitmapData;
		private var _scale9Grid:Rectangle;
		
		public var isTileGrid9:Boolean;
		
		/**
		 * 是否在销毁时回收位图
		 */
		public var disposeWhenDestory:Boolean = true;
		
		public function BitmapGrid9Shape(bitmapData:BitmapData)
		{
			super();
			this.enabledAutoSize = false;
			if (bitmapData)
				this.bitmapData = bitmapData;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
			this.setSize(value.width,value.height);
		}
		
		public override function get scale9Grid():Rectangle
		{
			return _scale9Grid;
		}

		public override function set scale9Grid(innerRectangle:Rectangle):void
		{
			_scale9Grid = innerRectangle;
			renderGrid9();
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
			this.scrollRect = new Rectangle(0,0,width,height);
			renderGrid9();
		}
		
		public function renderGrid9():void
		{
			if (bitmapData)
				BitmapGrid9Util.renderGrid9Shape(this.graphics,bitmapData,width,height,_scale9Grid,isTileGrid9);
		}
		
		public override function destory():void
		{
			if (destoryed)
				return;
			
			if (disposeWhenDestory)
				this.dispose();
			
			super.destory();
		}
		
		public function dispose():void
		{
			if (bitmapData)
				bitmapData.dispose();
		}
	}
}