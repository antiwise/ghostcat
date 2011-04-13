package ghostcat.display.graphics
{
	import ghostcat.display.GBase;
	import ghostcat.parse.DisplayParse;
	
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

		/**
		 * 图像数据，是一个Parse类组成的数组 
		 * @return 
		 * 
		 */
		public function get graphicsData():Array
		{
			return _parse.children;
		}

		public function set graphicsData(v:Array):void
		{
			_parse.children = v;
			invalidateDisplayList();
		}
		
		/** @inheritDoc*/
		override protected function updateDisplayList() : void
		{
			graphics.clear();
			_parse.parse(this);
			
			super.updateDisplayList();
		}

	}
}