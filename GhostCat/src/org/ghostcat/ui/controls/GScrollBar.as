package org.ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.ghostcat.display.GNoScale;
	
	/**
	 * 滚动条 
	 * @author flashyiyi
	 * 
	 */
	public class GScrollBar extends GNoScale
	{
		public var upArrow:GButton;
		public var downArrow:GButton;
		public var thumb:GButton;
		public var background:DisplayObject;
		
		private var _target:DisplayObject;
		
		private var thumbAreaStart:Number;
		private var thumbAreaLength:Number;
		
		/**
		 * 方向
		 */
		private var _direction:int;
		
		/**
		 * 滚动缓动效果
		 */

		public var tweenFunction:Function;
		
		/**
		 * 滚动模糊效果
		 */
		public var blur:Number;
		
		public var fields:Object = {upArrowField:"upArrow",downArrowField:"downArrow",
			thumbField:"thumb",backgroundField:"background"}
		
		public function GScrollBar(skin:DisplayObject=null, replace:Boolean=true,fields:Object=null)
		{
			if (fields)
				this.fields = fields;
			
			super(skin, replace);
		}
		
		public function get target():DisplayObject
		{
			return _target;
		}

		public function set target(v:DisplayObject):void
		{
			_target = v;
			
			if (!v.scrollRect)
				v.scrollRect = v.getBounds(v.parent);
		}
		
		public function get direction():int
		{
			return _direction;
		}

		public function set direction(v:int):void
		{
			_direction = v;
			invalidateSize();
		}
		
		public function get targetMaxHScrollPostion():int
		{
			var rect:Rectangle = _target.getBounds(_target);
			return rect.width - _target.scrollRect.width;
		}
		
		public function get targetMaxVScrollPostion():int
		{
			var rect:Rectangle = _target.getBounds(_target);
			return rect.height - _target.scrollRect.height;
		}
		
		public function get targetHScrollPostion():int
		{
			var rect:Rectangle = _target.getBounds(_target);
			return	rect.x;
		}
		
		public function get targetVScrollPostion():int
		{
			var rect:Rectangle = _target.getBounds(_target);
			return rect.y;
		}

		public override function setContent(skin:DisplayObject, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			var upArrowField:String = fields.upArrowField;
			var downArrowField:String = fields.downArrowField;
			var thumbField:String = fields.thumbField;
			var backgroundField:String =  fields.backgroundField;
			
			if (content.hasOwnProperty(upArrowField))
				this.upArrow = new GButton(content[upArrowField]);
				
			if (content.hasOwnProperty(downArrowField))
				this.downArrow = new GButton(content[downArrowField]);
				
			if (content.hasOwnProperty(thumbField))
			{
				this.thumb = new GButton(content[thumbField]);
				thumb.addEventListener(MouseEvent.MOUSE_DOWN,thumbMouseDownHandler);
			}
				
			if (content.hasOwnProperty(backgroundField))
				this.background = content[backgroundField];
				
			invalidateSize();
		}
		
		protected override function updateSize() : void
		{
			super.updateSize();
			
			this.downArrow.x = this.width - this.downArrow.width;
			this.downArrow.y = this.height - this.downArrow.height;
			
			if (direction == 0)
			{
				thumbAreaStart = upArrow.width;
				thumbAreaLength = this.width - downArrow.width - thumb.width - thumbAreaStart;
			}
			else
			{
				thumbAreaStart = upArrow.height;
				thumbAreaLength = this.height - downArrow.height - thumb.height - thumbAreaStart;
			}
			
			updateThumb()
		}
		
		protected function updateThumb():void
		{
			var p:Number;
			if (direction == 0)
			{
				p = targetHScrollPostion / targetMaxHScrollPostion;
				thumb.x = thumbAreaStart + thumbAreaLength * p;
			}
			else
			{
				p = targetVScrollPostion / targetMaxVScrollPostion;
				thumb.y = thumbAreaStart + thumbAreaLength * p;
			}
		}
		
		protected function thumbMouseDownHandler(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP,thumbMouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,thumbMouseMoveHandler);
			if (direction == 0)
				thumb.startDrag(false,new Rectangle(thumbAreaStart,thumb.y,thumbAreaLength,thumb.y));
			else
				thumb.startDrag(false,new Rectangle(thumb.x,thumbAreaStart,thumb.x,thumbAreaLength));
		}
		
		protected function thumbMouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,thumbMouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,thumbMouseMoveHandler);
			thumb.stopDrag();
		}
		
		protected function thumbMouseMoveHandler(event:MouseEvent):void
		{
			var rect:Rectangle = target.scrollRect;
			if (direction == 0)
				rect.x = targetMaxHScrollPostion * (thumb.x - thumbAreaStart) / thumbAreaLength;
			else
				rect.y = targetMaxVScrollPostion * (thumb.y - thumbAreaStart) / thumbAreaLength;
				
			target.scrollRect = rect;
		}
		
		public override function destory() : void
		{
			super.destory();
			
			if (upArrow) 
				upArrow.destory();
			if (downArrow) 
				downArrow.destory();
			if (thumb) 
			{
				thumb.destory();
			
				thumb.removeEventListener(MouseEvent.MOUSE_DOWN,thumbMouseDownHandler);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,thumbMouseMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP,thumbMouseUpHandler);
			}
		}
	}
}