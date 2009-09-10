package org.ghostcat.display
{
	import flash.display.DisplayObject;
	
	import org.ghostcat.util.CallLater;
	
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
		
		public function GNoScale(skin:DisplayObject=null,replace:Boolean=true)
		{
			super(skin,replace);
			
			invalidateSize();
		}
		
		public override function get width():Number
		{
			return _width ? _width:super.width;
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
			return _height ? _height:super.height;
		}
		
		public override function set height(v:Number):void
		{
			if (_height == v)
				return;
				
			_height = v;
			invalidateSize();
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