package ghostcat.display
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import ghostcat.util.display.Geom;
	
	/**
	 * 重写了width,height使得scale保持为1的显示对象，大部分组件类的基类
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GNoScale extends GBase
	{
		private var _height:Number;
		private var _width:Number;
		
		public var enabledAutoSize:Boolean = true;
		
		public function GNoScale(skin:*=null,replace:Boolean=true)
		{
			super(skin,replace);
			
			this.sizeCall.frame = false;
			invalidateSize();
		}
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			if (enabledAutoSize)
				autoSize();
		}
		
		/**
		 * 根据内容调整大小
		 * 
		 */
		public function autoSize():void
		{
			if (content)
			{
				_width = content.width;
				_height = content.height;
			}
		}
		/** @inheritDoc*/
		public override function get width():Number
		{
			return _width ? _width : super.width;
		}
		
		public override function set width(v:Number):void
		{
			if (_width == v)
				return;
			
			_width = v;
			invalidateSize();
		}
		/** @inheritDoc*/
		public override function get height():Number
		{
			return _height ? _height : super.height;
		}
		
		public override function set height(v:Number):void
		{
			if (_height == v)
				return;
				
			_height = v;
			invalidateSize();
		}
		
		public override function setSize(width:Number, height:Number, noEvent:Boolean=false) : void
		{
			if (_width == width && _height == height)
				return;
			
			_width = width;
			_height = height;
			
			vaildSize(noEvent);
		}
		
		/** @inheritDoc*/
		public override function getRect(targetCoordinateSpace:DisplayObject) : Rectangle
		{
			return Geom.localRectToContent(new Rectangle(0,0,width,height),this,targetCoordinateSpace);
		}
		/** @inheritDoc*/
		override protected function updateSize() : void
		{
			super.updateSize();
			updateDisplayList();
		}  
	}
}