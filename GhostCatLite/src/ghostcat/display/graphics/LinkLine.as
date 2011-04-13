package ghostcat.display.graphics
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import ghostcat.display.GBase;
	import ghostcat.parse.graphics.GraphicsLineStyle;
	import ghostcat.util.display.Geom;
	
	/**
	 * 连接线
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class LinkLine extends GBase
	{
		private var _startContent:DisplayObject
		private var _start:Point;
		
		private var _endContent:DisplayObject
		private var _end:Point;
		
		/**
		 * 线型
		 */
		public var lineStyle:GraphicsLineStyle = new GraphicsLineStyle(0);
		
		public function LinkLine()
		{
			super();
		}
		
		/**
		 * 起始对象
		 */
		public function get startContent():DisplayObject
		{
			return _startContent;
		}

		public function set startContent(v:DisplayObject):void
		{
			_startContent = v;
			invalidateDisplayList();
		}

		/**
		 * 起始对象坐标系中的点
		 */
		public function get start():Point
		{
			return _start;
		}

		public function set start(v:Point):void
		{
			_start = v;
			invalidateDisplayList();
		}

		/**
		 * 结束对象
		 */
		public function get endContent():DisplayObject
		{
			return _endContent;
		}

		public function set endContent(v:DisplayObject):void
		{
			_endContent = v;
			invalidateDisplayList();
		}

		/**
		 * 结束对象坐标系中的点 
		 */
		public function get end():Point
		{
			return _end;
		}

		public function set end(v:Point):void
		{
			_end = v;
			invalidateDisplayList();
		}
		/** @inheritDoc*/
		override protected function updateDisplayList() : void
		{
			if (start == null || end ==  null)
				return;
			
			graphics.clear();
			
			var localStart:Point = Geom.localToContent(start, startContent ? startContent : stage, this);
			var localEnd:Point = Geom.localToContent(end,endContent ? endContent : stage, this);
			
			lineStyle.parse(this);
			
			graphics.moveTo(localStart.x,localStart.y);
			graphics.lineTo(localEnd.x,localEnd.y);
		
			super.updateDisplayList();
		}
	}
}