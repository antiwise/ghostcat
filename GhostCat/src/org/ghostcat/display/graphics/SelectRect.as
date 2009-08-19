package org.ghostcat.display.graphics
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.ghostcat.core.GSprite;
	import org.ghostcat.events.SelectEvent;
	import org.ghostcat.parse.graphics.GraphicsFill;
	import org.ghostcat.parse.graphics.GraphicsLineStyle;
	import org.ghostcat.util.Util;

	/**
	 * 选择框
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SelectRect extends GSprite
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
		
		public function begin():void
		{
			start = new Point(mouseX,mouseY);
			end = start.clone();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			
			refresh();
		}
		
		protected function mouseMoveHandler(event:MouseEvent):void
		{
			end = new Point(mouseX,mouseY);
			refresh();
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			
			var minX:Number = Math.min(start.x,end.x);
			var minY:Number = Math.min(start.y,end.y);
			var maxX:Number = Math.max(start.x,end.x);
			var maxY:Number = Math.max(start.y,end.y);
			var rect:Rectangle = new Rectangle(minX,minY,maxX - minX,maxY - minY);
			
			dispatchEvent(Util.createObject(new SelectEvent(SelectEvent.SELECT),{rect:rect}))
			
			start = end = null;
			
			refresh();
		}
		
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
		
		override public function destory():void
		{
			super.destory();
			
			removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}
	}
}