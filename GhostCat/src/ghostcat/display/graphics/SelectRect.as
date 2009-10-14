package ghostcat.display.graphics
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GSprite;
	import ghostcat.events.SelectEvent;
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.parse.graphics.GraphicsLineStyle;
	import ghostcat.util.Util;

	/**
	 * 选择框
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SelectRect extends ghostcat.display.GSprite
	{
		/**
		 * 线型
		 */
		public var lineStyle:GraphicsLineStyle = new GraphicsLineStyle(0);
		/**
		 * 填充
		 */
		public var fill:GraphicsFill = new GraphicsFill(0,0);
		
		private var start:Point;
		private var end:Point;
		
		public function SelectRect()
		{
			mouseEnabled = mouseChildren = false;
		}
		
		/**
		 * 开始选择
		 * 
		 */
		public function begin():void
		{
			start = new Point(mouseX,mouseY);
			end = start.clone();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			
			refresh();
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			end = new Point(mouseX,mouseY);
			refresh();
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			
			var minX:Number = Math.min(start.x,end.x);
			var minY:Number = Math.min(start.y,end.y);
			var maxX:Number = Math.max(start.x,end.x);
			var maxY:Number = Math.max(start.y,end.y);
			var rect:Rectangle = new Rectangle(minX,minY,maxX - minX,maxY - minY);
			
			var e:SelectEvent = new SelectEvent(SelectEvent.SELECT);
			e.rect = rect;
			dispatchEvent(e);
			
			start = end = null;
			
			refresh();
		}
		
		/**
		 * 更新图形 
		 * 
		 */
		public function refresh():void
		{
			graphics.clear();
			if (start && end)
			{
				lineStyle.parse(this);
				fill.parse(this);
				graphics.drawRect(start.x,start.y,end.x - start.x,end.y - start.y);
			}
		}
		/** @inheritDoc*/
		override public function destory():void
		{
			super.destory();
			
			removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}
	}
}