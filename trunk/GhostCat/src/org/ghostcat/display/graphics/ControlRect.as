package org.ghostcat.display.graphics
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.ghostcat.display.GBase;
	import org.ghostcat.events.MoveEvent;

	/**
	 * 图像变形控制器，点击自动选中，并可调整大小和变形
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ControlRect extends GBase
	{
		private static var selectedRects:Array = [];
		private static function unSelectAll():void
		{
			for each (var rect:ControlRect in selectedRects)
				rect.selected = false;
			
			selectedRects = [];
		}
		
		public var controlCotainer:Sprite;
		
		private var _selected:Boolean = false;
		
		public var topLeftControl:DragPoint;
		public var topRightControl:DragPoint;
		public var bottomLeftControl:DragPoint;
		public var bottomRightControl:DragPoint;
		public var topLineControl:DragPoint;
		public var bottomLineControl:DragPoint;
		public var leftLineControl:DragPoint;
		public var rightLineControl:DragPoint;
		
		public function ControlRect(skin:DisplayObject=null,replace:Boolean=true)
		{
			createControl();
			
			super(skin,replace)
			
			addEventListener(MouseEvent.ROLL_OVER,showControlHandler);
			addEventListener(MouseEvent.ROLL_OUT,hideControlHandler);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(v:Boolean):void
		{
			_selected = v;
			
			this.controlCotainer.visible = _selected;
		}

		override public function setContent(skin:DisplayObject, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			var rect:Rectangle = content.getBounds(content);
			
			topLeftControl.point = new Point(rect.x,rect.y);
			topRightControl.point = new Point(rect.right,rect.y);
			bottomLeftControl.point = new Point(rect.x,rect.bottom);
			bottomRightControl.point = new Point(rect.right,rect.bottom);
		}
		
		private function createControl():void
		{
			controlCotainer = new Sprite();
			
			topLeftControl = new DragPoint();
			topLeftControl.addEventListener(MoveEvent.MOVE,topLeftControlHandler,false,0,true);
			controlCotainer.addChild(topLeftControl);
			
			topRightControl = new DragPoint();	
			topRightControl.addEventListener(MoveEvent.MOVE,topRightControlHandler,false,0,true);
			controlCotainer.addChild(topRightControl);
			
			bottomLeftControl = new DragPoint();	
			bottomLeftControl.addEventListener(MoveEvent.MOVE,bottomLeftControlHandler,false,0,true);
			controlCotainer.addChild(bottomLeftControl);
			
			bottomRightControl = new DragPoint();	
			bottomRightControl.addEventListener(MoveEvent.MOVE,bottomRightControlHandler,false,0,true);
			controlCotainer.addChild(bottomRightControl);
			
			topLineControl = new DragPoint();	
			topLineControl.addEventListener(MoveEvent.MOVE,topLineControlHandler,false,0,true);
			controlCotainer.addChild(topLineControl);
			
			bottomLineControl = new DragPoint();	
			bottomLineControl.addEventListener(MoveEvent.MOVE,bottomLineControlHandler,false,0,true);
			controlCotainer.addChild(bottomLineControl);
			
			leftLineControl = new DragPoint();	
			leftLineControl.addEventListener(MoveEvent.MOVE,leftLineControlHandler,false,0,true);
			controlCotainer.addChild(leftLineControl);
			
			rightLineControl = new DragPoint();	
			rightLineControl.addEventListener(MoveEvent.MOVE,rightLineControlHandler,false,0,true);
			controlCotainer.addChild(rightLineControl);
		}
		
		protected function topLeftControlHandler(event:MoveEvent):void
		{
			
		}
		
		protected function topRightControlHandler(event:MoveEvent):void
		{
			
		}
		
		protected function bottomLeftControlHandler(event:MoveEvent):void
		{
			
		}
		
		protected function bottomRightControlHandler(event:MoveEvent):void
		{
			
		}
		
		protected function topLineControlHandler(event:MoveEvent):void
		{
			
		}
		
		protected function bottomLineControlHandler(event:MoveEvent):void
		{
			
		}
		
		protected function leftLineControlHandler(event:MoveEvent):void
		{
			
		}
		
		protected function rightLineControlHandler(event:MoveEvent):void
		{
			
		}
		
		protected function showControlHandler(event:MouseEvent):void
		{
			addChild(controlCotainer);
		}
		
		protected function hideControlHandler(event:MouseEvent):void
		{
			removeChild(controlCotainer);
		}
		
		override public function destory():void
		{
			removeEventListener(MouseEvent.ROLL_OVER,showControlHandler);
			removeEventListener(MouseEvent.ROLL_OUT,hideControlHandler);
			super.destory();
		}
	}
}