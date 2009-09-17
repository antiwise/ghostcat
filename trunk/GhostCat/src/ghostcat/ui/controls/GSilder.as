package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GNoScale;
	import ghostcat.events.TickEvent;
	import ghostcat.manager.DragManager;
	import ghostcat.ui.UIConst;
	import ghostcat.util.Tick;
	
	public class GSilder extends GNoScale
	{
		public var upArrow:GButton;
		public var downArrow:GButton;
		public var thumb:GButton;
		public var background:DisplayObject;
		
		protected var thumbAreaStart:Number;
		protected var thumbAreaLength:Number;
		
		
		private var _target:DisplayObject;
		
		private var _minValue:Number;
		private var _maxValue:Number;
		private var _value:Number;
		
		/**
		 * 旧值 
		 */
		protected var oldValue:Number;
		
		/**
		 * 方向
		 */
		private var _direction:String = UIConst.HORIZONTAL;
		
		public var fields:Object = {upArrowField:"upArrow",downArrowField:"downArrow",
			thumbField:"thumb",backgroundField:"background"}
		
		public function GSilder(skin:*=null,replace:Boolean=true,fields:Object=null)
		{
			if (fields)
				this.fields = fields;
			
			super(skin, replace);
			
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
		}
		
		/**
		 * 滚动速度
		 */
		public var detra:int = 5;
		
		/**
		 * 快速滚动速度
		 */
		public var pageDetra:int = 25;
		
		/**
		 * 当前值 
		 * @return 
		 * 
		 */
		public function get value():Number
		{
			return _value;
		}

		public function set value(v:Number):void
		{
			oldValue = value;
			_value = v;
		}

		/**
		 * 最大值
		 * @return 
		 * 
		 */
		public function get maxValue():Number
		{
			return _maxValue;
		}

		public function set maxValue(v:Number):void
		{
			_maxValue = v;
		}

		/**
		 * 最小值
		 * @return 
		 * 
		 */
		public function get minValue():Number
		{
			return _minValue;
		}

		public function set minValue(v:Number):void
		{
			_minValue = v;
		}
		
		/**
		 * 百分比 
		 * @return 
		 * 
		 */
		public function get percent():Number
		{
			return (_value - _minValue) / (_maxValue - _minValue);
		}
		
		public function set percent(v:Number):void
		{
			_value = (_maxValue - _minValue) * v + _minValue;
		}

		/**
		 * 方向 
		 * @return 
		 * 
		 */
		public function get direction():String
		{
			return _direction;
		}

		public function set direction(v:String):void
		{
			_direction = v;
			invalidateSize();
		}
		
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			var upArrowField:String = fields.upArrowField;
			var downArrowField:String = fields.downArrowField;
			var thumbField:String = fields.thumbField;
			var backgroundField:String =  fields.backgroundField;
			
			if (content.hasOwnProperty(upArrowField))
				this.upArrow = new GButton(content[upArrowField]);
			else
				this.upArrow = new GButton(new Shape())
				
			if (content.hasOwnProperty(downArrowField))
				this.downArrow = new GButton(content[downArrowField]);
			else
				this.downArrow = new GButton(new Shape())
				
			if (content.hasOwnProperty(thumbField))
			{
				this.thumb = new GButton(content[thumbField]);
				thumb.addEventListener(MouseEvent.MOUSE_DOWN,thumbMouseDownHandler);
			}
				
			if (content.hasOwnProperty(backgroundField))
			{
				this.background = content[backgroundField];
				this.background.addEventListener(MouseEvent.MOUSE_DOWN,backgroundHandler);
			}
				
			invalidateSize();
		}
		
		protected override function updateSize() : void
		{
			super.updateSize();
			
			if (this.downArrow)
			{
				this.downArrow.x = this.width - this.downArrow.width;
				this.downArrow.y = this.height - this.downArrow.height;
			}
			
			if (direction == UIConst.HORIZONTAL)
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
			
			updateThumb();
		}
		
		/**
		 * 更新滚动条的位置
		 * 
		 */
		public function updateThumb():void
		{
			if (!thumb)
				return;
			
			var v:Number = thumbAreaStart + thumbAreaLength * percent;
			if (direction == UIConst.HORIZONTAL)
				thumb.x = v;
			else
				thumb.y = v;
		}
		
		protected function thumbMouseDownHandler(event:MouseEvent):void
		{
			var rect:Rectangle;
			if (direction == UIConst.HORIZONTAL)
				rect = new Rectangle(thumbAreaStart,thumb.y,thumbAreaLength,thumb.y);
			else
				rect = new Rectangle(thumb.x,thumbAreaStart,thumb.x,thumbAreaLength);
				
			DragManager.startDrag(thumb,rect,null,thumbMouseMoveHandler);
		}
		
		protected function thumbMouseMoveHandler(event:Event=null):void
		{
			if (thumb.position.equals(thumb.oldPosition))
				return;
			
			var currentPos:Number = (direction == UIConst.HORIZONTAL) ? thumb.x : thumb.y;
			percent = (currentPos - thumbAreaStart) / thumbAreaLength;
		}
		
		protected function tickHandler(event:TickEvent):void
		{
			if (upArrow)
			{
				upArrow.enabled = percent > 0;
				if (upArrow.mouseDown)
				{
					value -= detra;
					updateThumb();
				}
			}
			
			if (downArrow)
			{
				downArrow.enabled = percent < 1;
				if (downArrow.mouseDown)
				{
					value += detra;
					updateThumb();
				}
			}
		}
		
		protected function backgroundHandler(event:MouseEvent):void
		{
			if (direction == UIConst.HORIZONTAL)
			{
				if (thumb.mouseX > pageDetra + thumb.width)
					thumb.x += pageDetra;
				else if (thumb.mouseX < -pageDetra)
					thumb.x -= pageDetra;
				else
					thumb.x += thumb.mouseX;
					
				thumb.x = Math.max(Math.min(downArrow.x - thumb.width,thumb.x),upArrow.x + upArrow.width)
			}
			else
			{
				if (thumb.mouseY > pageDetra + thumb.height)
					thumb.y += pageDetra;
				else if (thumb.mouseY < -pageDetra)
					thumb.y -= pageDetra;
				else
					thumb.y += thumb.mouseY;
					
				thumb.y = Math.max(Math.min(downArrow.y - thumb.height,thumb.y),upArrow.y + upArrow.height)
			}
			thumbMouseMoveHandler();
		}
		
		public override function destory() : void
		{
			super.destory();
			
			Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
			
			if (upArrow) 
				upArrow.destory();
			
			if (downArrow) 
				downArrow.destory();
			
			if (thumb) 
			{
				thumb.destory();
				thumb.removeEventListener(MouseEvent.MOUSE_DOWN,thumbMouseDownHandler);
			}
			
			if (background)
				background.removeEventListener(MouseEvent.MOUSE_DOWN,backgroundHandler);
		}
		
		
	}
}