package org.ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import org.ghostcat.display.GNoScale;
	import org.ghostcat.manager.DragManager;
	import org.ghostcat.ui.containers.ScrollPanel;
	import org.ghostcat.ui.controls.scrollClasses.IScrollContent;
	import org.ghostcat.ui.controls.scrollClasses.ScrollTextContent;
	
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
		private var _scrollContent:IScrollContent;
		
		private var thumbAreaStart:Number;
		private var thumbAreaLength:Number;
		
		/**
		 * 方向
		 */
		private var _direction:int = 1;
		
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
			
			if (v is IScrollContent)
				_scrollContent = v as IScrollContent;
			else if (_target is TextField)
				_scrollContent = new ScrollTextContent(_target as TextField);
			else
				_scrollContent = new ScrollPanel(_target);
		}
		
		public function get scrollContent():IScrollContent
		{
			return _scrollContent;
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
		
		public function setTargetScrollRect(rect:Rectangle):void
		{
			if (_scrollContent && _scrollContent is DisplayObject)
				(_scrollContent as DisplayObject).scrollRect = rect;
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
				background.width = width;
			}
			else
			{
				thumbAreaStart = upArrow.height;
				thumbAreaLength = this.height - downArrow.height - thumb.height - thumbAreaStart;
				background.height = height;
			}
			
			updateThumb()
		}
		
		protected function updateThumb():void
		{
			if (!_scrollContent || !thumb)
				return;
			
			var p:Number;
			if (direction == 0)
			{
				p = _scrollContent.scrollH / _scrollContent.maxScrollH;
				thumb.x = thumbAreaStart + thumbAreaLength * p;
			}
			else
			{
				p = _scrollContent.scrollV / _scrollContent.maxScrollV;
				thumb.y = thumbAreaStart + thumbAreaLength * p;
			}
		}
		
		protected function thumbMouseDownHandler(event:MouseEvent):void
		{
			var rect:Rectangle;
			if (direction == 0)
				rect = new Rectangle(thumbAreaStart,thumb.y,thumbAreaLength,thumb.y);
			else
				rect = new Rectangle(thumb.x,thumbAreaStart,thumb.x,thumbAreaLength);
				
			DragManager.startDrag(thumb,rect,null,thumbMouseMoveHandler);
		}
		
		protected function thumbMouseMoveHandler(event:Event):void
		{
			if (!_scrollContent)
				return;
			
			if (direction == 0)
				_scrollContent.scrollH = _scrollContent.maxScrollH * (thumb.x - thumbAreaStart) / thumbAreaLength;
			else
				_scrollContent.scrollV = _scrollContent.maxScrollV * (thumb.y - thumbAreaStart) / thumbAreaLength;
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
			}
		}
	}
}