package org.ghostcat.display.graphics
{
	import flash.display.Sprite;
	
	import org.ghostcat.parse.DisplayParse;
	
	/**
	 * 方便更新图像的Sprite
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GraphicsSprite extends Sprite
	{
		private var _parse:DisplayParse;
		
		public function GraphicsSprite(data:Array = null)
		{
			_parse = DisplayParse.create(data);
		}

		public function get graphicsData():Array
		{
			return _parse.children;
		}

		public function set graphicsData(v:Array):void
		{
			_parse.children = v;
			refresh();
		}
		
		public function refresh():void
		{
			graphics.clear();
			_parse.parse(this);
		}

	}
}