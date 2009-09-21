package ghostcat.display
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import ghostcat.util.CallLater;
	import ghostcat.util.Geom;
	
	/**
	 * Scale保持为固定值的显示对象
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GNoScale extends GBase
	{
		private var _height:Number;
		private var _width:Number;
		
		public function GNoScale(skin:*=null,replace:Boolean=true)
		{
			super(skin,replace);
			
			invalidateSize();
		}
		
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			autoSize();
		}
		
		/**
		 * 根据内容调整大小
		 * 
		 */
		public function autoSize():void
		{
			_width = content.width;
			_height = content.height;
		}
		
		public override function get width():Number
		{
			return _width;
		}
		
		public override function set width(v:Number):void
		{
			if (_width == v)
				return;
			
			_width = v;
			invalidateSize();
		}
		
		public override function get height():Number
		{
			return _height;
		}
		
		public override function set height(v:Number):void
		{
			if (_height == v)
				return;
				
			_height = v;
			invalidateSize();
		}
		
		public override function getRect(targetCoordinateSpace:DisplayObject) : Rectangle
		{
			return Geom.localRectToContent(new Rectangle(0,0,width,height),this,targetCoordinateSpace);
		}
		
		override public function invalidateSize() : void
		{
			CallLater.callLater(updateSize,null,true);
		}
		
		override protected function updateSize() : void
		{
			super.updateSize();
			updateDisplayList();
		}  
	}
}