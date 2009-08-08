package org.ghostcat.display
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import org.ghostcat.events.GEvent;
	import org.ghostcat.events.ResizeEvent;
	import org.ghostcat.util.Util;
	
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
		
		public override function updateSize() : void
		{
			super.updateSize();
			updateDisplayList();
		}  
	}
}