package org.ghostcat.manager
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.ghostcat.events.DragEvent;
	import org.ghostcat.util.Geom;
	import org.ghostcat.util.Util;
	
	/**
	 * FLASH自带的拖动功能缺乏扩展性，因此必要时只能重新实现。
	 * 
	 * 这个类可以实现对Bitmap,TextField的拖动，支持多物品拖动,
	 * 并且会自动向外发布DragOver,DragOut事件。
	 * 
	 * 这个类的DragStart和DragStop事件都是可中断的，若指定中断就可以中止原来的操作。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class DragManager
	{
		private static var list:Dictionary = new Dictionary();
		
		/**
		 * 开始拖动
		 * 
		 * @param obj	要拖动的物品
		 * @param bounds	拖动的范围，坐标系为父对象
		 * @param stopHandler	停止拖动后执行的事件
		 * @param onHandler	拖动时每帧执行的事件
		 * @param lockCenter	是否以物体中心点为拖动的点
		 * @param upWhenLeave	当移出拖动范围时，是否停止拖动
		 * @param collideByRect	判断范围是否以物品的边缘而不是注册点为标准
		 * 
		 */
		public static function startDrag(obj:DisplayObject,bounds:Rectangle=null,stopHandler:Function=null,onHandler:Function=null,
									lockCenter:Boolean = false,upWhenLeave:Boolean = false,collideByRect:Boolean = false):void
		{
			if (list[o]!=null)
				return;
				
			var o:DragManager = new DragManager();
			
			o.obj = obj;
			o.bounds = bounds;
			o.lockCenter = lockCenter;
			o.upWhenLeave = upWhenLeave;
			o.collideByRect = collideByRect;
			o.stopHandler = stopHandler;
			o.onHandler = onHandler;
			o.startDrag();
		}
		
		public static function stopDrag(obj:DisplayObject):void
		{
			if (list[obj])
				(list[obj] as DragManager).stopDrag();
		}
		
		protected var obj:DisplayObject;
		protected var lockCenter:Boolean;
		protected var upWhenLeave:Boolean;
		protected var collideByRect:Boolean;
		protected var bounds:Rectangle;
		protected var onHandler:Function;
		protected var stopHandler:Function;
		
		protected var dragMousePos:Point;
		protected var dragPos:Point;
	
		protected function startDrag():void
		{
			var evt:DragEvent = Util.createObject(new DragEvent(DragEvent.DRAG_START,false,true),{dragObj:obj});
			obj.dispatchEvent(evt)
			
			if (evt.isDefaultPrevented())
				return;
			
			list[obj] = this;
			if (lockCenter)
				dragMousePos = Geom.center(obj);
			else
				dragMousePos = Geom.localToContent(new Point(obj.mouseX,obj.mouseY),obj,obj.parent);;
				
			dragPos = new Point(obj.x,obj.y);
			
			obj.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			obj.stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			obj.stage.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			obj.stage.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			if (stopHandler!=null)
				obj.addEventListener(DragEvent.DRAG_STOP,stopHandler);
			if (onHandler!=null)
				obj.addEventListener(DragEvent.DRAG_ON,onHandler);
		}
		
		protected function stopDrag():void
		{
			var evt:DragEvent = Util.createObject(new DragEvent(DragEvent.DRAG_STOP,false,true),{dragObj:obj});
			obj.dispatchEvent(evt)
			
			if (evt.isDefaultPrevented())
				return;
			
			obj.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			obj.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			obj.stage.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			obj.stage.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			if (stopHandler!=null)
				obj.removeEventListener(DragEvent.DRAG_STOP,stopHandler);
			if (onHandler!=null)
				obj.removeEventListener(DragEvent.DRAG_ON,onHandler);
			
			dragPos = null;
			dragMousePos = null;
			
			delete list[obj];
		}
		
		private function enterFrameHandler(event:Event):void
		{
			var	parentOffest:Point = Geom.localToContent(new Point(obj.mouseX,obj.mouseY),obj,obj.parent).subtract(dragMousePos);
			
			obj.x = dragPos.x + parentOffest.x;
			obj.y = dragPos.y + parentOffest.y;
			
			if (bounds)
			{
				var out:Boolean;
				if (collideByRect)
					out = Geom.forceRectInside(obj,bounds);
				else
					out = Geom.forcePointInside(obj,bounds);
			}
			obj.dispatchEvent(Util.createObject(new DragEvent(DragEvent.DRAG_ON,false,false),{dragObj:obj}));
			
			if (out && upWhenLeave)
				stopDrag();
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			stopDrag();
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			event.target.dispatchEvent(Util.createObject(new DragEvent(DragEvent.DRAG_OVER,true,false),{dragObj:obj}));
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			event.target.dispatchEvent(Util.createObject(new DragEvent(DragEvent.DRAG_OUT,true,false),{dragObj:obj}));
		}
	}
}
