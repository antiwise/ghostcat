package org.ghostcat.display.graphics
{
	import org.ghostcat.display.GBase;
	import org.ghostcat.parse.DisplayParse;
	
	/**
	 * 方便更新图像的Sprite
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GraphicsSprite extends GBase
	{
		private var _parse:DisplayParse;
		
		public function GraphicsSprite(data:Array = null)
		{
			_parse = new DisplayParse();
			graphicsData = data;
		}

		public function get graphicsData():Array
		{
			return _parse.children;
		}

		public function set graphicsData(v:Array):void
		{
			_parse.children = v;
			invalidateDisplayList();
		}
		
		override public function updateDisplayList() : void
		{
			graphics.clear();
			_parse.parse(this);
			
			super.updateDisplayList();
		}

	}
}