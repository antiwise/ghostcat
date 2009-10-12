package ghostcat.ui.containers
{
	import flash.display.Shape;
	import flash.geom.Point;
	
	import ghostcat.display.graphics.DragPoint;
	import ghostcat.events.MoveEvent;
	import ghostcat.parse.display.RectParse;
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.parse.graphics.GraphicsRect;
	import ghostcat.ui.CursorSprite;
	
	/**
	 * 可拖动边缘缩放的窗口
	 * @author flashyiyi
	 * 
	 */
	public class GResizePanel extends GView
	{
		/**
		 * 最小高度
		 */
		public var minHeight:Number = 0;
		/**
		 * 最大高度
		 */
		public var minWidth:Number = 0;
		
		private var leftEdge:DragPoint;
		private var rightEdge:DragPoint;
		private var topEdge:DragPoint;
		private var bottomEdge:DragPoint;
		
		public function GResizePanel(skin:* = null, replace:Boolean=true)
		{
			super(skin, replace);
			createContorl();
		}
			
		/**
		 * 创建控制区域
		 * 
		 */
		protected function createContorl():void
		{
			leftEdge = new DragPoint(null,new Shape());
			leftEdge.cursor = CursorSprite.CURSOR_H_DRAG;
			leftEdge.lockY = true;
			leftEdge.addEventListener(MoveEvent.MOVE,leftEdgeHandler);
			$addChild(leftEdge);
			rightEdge = new DragPoint(null,new Shape());
			rightEdge.cursor = CursorSprite.CURSOR_H_DRAG;
			rightEdge.lockY = true;
			rightEdge.addEventListener(MoveEvent.MOVE,rightEdgeHandler);
			$addChild(rightEdge);
			topEdge = new DragPoint(null,new Shape());
			topEdge.cursor = CursorSprite.CURSOR_V_DRAG;
			topEdge.lockX = true;
			topEdge.addEventListener(MoveEvent.MOVE,topEdgeHandler);
			$addChild(topEdge);
			bottomEdge = new DragPoint(null,new Shape());
			bottomEdge.cursor = CursorSprite.CURSOR_V_DRAG;
			bottomEdge.lockX = true;
			bottomEdge.addEventListener(MoveEvent.MOVE,bottomEdgeHandler);
			$addChild(bottomEdge);
		}
		/** @inheritDoc*/
		protected override function updateSize() : void
		{
			super.updateSize();
			
			var fill:GraphicsFill = new GraphicsFill(0,0);
			
			var leftRect:GraphicsRect = new GraphicsRect(0,5,5,height - 10);
			var topRect:GraphicsRect = new GraphicsRect(5,0,width - 10,5);
			var rightRect:GraphicsRect = new GraphicsRect(-5,5,5,height - 10);
			var bottomRect:GraphicsRect = new GraphicsRect(5, -5,width - 10,5);
			
			leftEdge.setPoint(new Point(0,0),true);
			topEdge.setPoint(new Point(0,0),true);
			rightEdge.setPoint(new Point(width,0),true);
			bottomEdge.setPoint(new Point(0,height),true);
			
			new RectParse(leftRect,null,fill,null,true).parse(leftEdge.content);
			new RectParse(topRect,null,fill,null,true).parse(topEdge.content);
			new RectParse(rightRect,null,fill,null,true).parse(rightEdge.content);
			new RectParse(bottomRect,null,fill,null,true).parse(bottomEdge.content);
		}
		
		private function topEdgeHandler(event:MoveEvent):void
		{
			if (height - topEdge.y > minHeight)
			{
				y += topEdge.y;
				height -= topEdge.y;
			}
		}
		
		private function bottomEdgeHandler(event:MoveEvent):void
		{
			if (bottomEdge.y > minHeight)
			{
				height = bottomEdge.y;
			}
		}
		
		private function leftEdgeHandler(event:MoveEvent):void
		{
			if (width - leftEdge.x > minWidth)
			{
				x += leftEdge.x;
				width -= leftEdge.x;
			}
		}
		
		private function rightEdgeHandler(event:MoveEvent):void
		{
			if (rightEdge.x > minWidth)
				width = rightEdge.x;
		}
	}
}