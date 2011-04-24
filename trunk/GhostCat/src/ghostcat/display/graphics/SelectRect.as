package ghostcat.display.graphics
{
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.events.SelectEvent;
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.parse.graphics.GraphicsLineStyle;
	import ghostcat.parse.graphics.IGraphicsFill;
	import ghostcat.parse.graphics.IGraphicsLineStyle;

	/**
	 * 用鼠标拖出一个框来选择
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SelectRect extends GBase
	{
		/**
		 * 线型
		 */
		public var lineStyle:IGraphicsLineStyle;
		/**
		 * 填充
		 */
		public var fill:IGraphicsFill;
		
		private var start:Point;
		private var end:Point;
		
		/**
		 * 选择的矩形
		 */
		public var rect:Rectangle;
		
		/**
		 * 完成回调函数（参数是选择的矩形）
		 */
		public var rHandler:Function;
		
		public function SelectRect(rHandler:Function = null,lineStyle:IGraphicsLineStyle = null,fill:IGraphicsFill = null,blendMode:String = "normal")
		{
			mouseEnabled = mouseChildren = false;
			
			if (!fill)
				fill = new GraphicsFill(0);
			
			if (!lineStyle)
				lineStyle = new GraphicsLineStyle(0);
			
			this.fill = fill;
			this.lineStyle = lineStyle;
			this.blendMode = blendMode;
			
			this.rHandler = rHandler;
		}
		
		/**
		 * 创建 
		 * @param v
		 * 
		 */
		public function createTo(v:DisplayObjectContainer):void
		{
			v.addChild(this);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			show();
		}
		
		public function show():void
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
			
			this.rect = new Rectangle(minX,minY,maxX - minX,maxY - minY);
			
			var e:SelectEvent = new SelectEvent(SelectEvent.SELECT);
			e.rect = rect;
			dispatchEvent(e);
			
			if (rHandler != null)
				rHandler(rect);
			
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
			if (destoryed)
				return;
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		
			super.destory();
		}
	}
}