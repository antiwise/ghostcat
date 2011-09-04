package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	import ghostcat.events.TickEvent;
	import ghostcat.skin.NumberStepperSkin;
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.core.EventHandler;
	import ghostcat.util.easing.TweenUtil;
	
	/**
	 * 数字选择框
	 * 
	 * 标签规则：子对象的upArrow,downArrow将被转化为向上和向下的按钮
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GNumbericStepper extends GNumberic
	{
		public static var defaultSkin:* = NumberStepperSkin;
		
		/**
		 * 内部按钮类型（只能在重写时在super子句前面设置）
		 */
		protected var buttonRef:Class;
		
		public var upArrow:GButtonBase;
		public var downArrow:GButtonBase;
		
		public var fields:Object = {upArrowField:"upArrow",downArrowField:"downArrow"}
		
		public var maxValue:Number;
		public var minValue:Number;
		public var detra:int = 1;
		
		/**
		 * 是否激活鼠标拖动快速改变数值
		 */
		public var enabeldDragChange:Boolean = false;
		private var mouseDownPoint:Point;//鼠标按下时的坐标
		
		public function GNumbericStepper(skin:*=null, replace:Boolean=true, enabledAdjustContextSize:Boolean=false, textPadding:Padding=null, fields:Object=null)
		{
			if (!skin)
				skin = defaultSkin;
			
			if (fields)
				this.fields = fields;
			
			super(skin, replace, enabledAdjustContextSize, textPadding);
				
			this.enabledTick = true;
		}
		/** @inheritDoc*/
		protected override function getTextFieldFromSkin(skin:DisplayObject) : void
		{
			super.getTextFieldFromSkin(skin);
			
			this.multiline = false;
			this.restrict = "0-9\\-";
			this.editable = true;
		}
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			createButtons(buttonRef);
		}
		
		public function createButtons(ref:Class):void
		{
			if (!ref)
				ref = GButton;
			
			var upArrowField:String = fields.upArrowField;
			var downArrowField:String = fields.downArrowField;
			
			if (content.hasOwnProperty(upArrowField))
			{
				upArrow = new ref(content[upArrowField]);
				upArrow.addEventListener(MouseEvent.CLICK,upArrowHandler);
				upArrow.addEventListener(MouseEvent.MOUSE_DOWN,arrowDownHandler);
				upArrow.incessancyClick = true;
			}
			if (content.hasOwnProperty(downArrowField))
			{
				downArrow = new ref(content[downArrowField]);
				downArrow.addEventListener(MouseEvent.CLICK,downArrowHandler);
				downArrow.addEventListener(MouseEvent.MOUSE_DOWN,arrowDownHandler);
				downArrow.incessancyClick = true;
			}
		}
		/** @inheritDoc*/
		public override function getValue():*
		{
			accaptText();
			return super.getValue();
		}
		
		protected function upArrowHandler(event:MouseEvent):void
		{
			data -= detra;
			if (!isNaN(minValue))
				data = Math.max(data,minValue);
		}
		
		protected function downArrowHandler(event:MouseEvent):void
		{
			data += detra;
			if (!isNaN(maxValue))
				data = Math.min(data,maxValue);
		}
		
		protected function arrowDownHandler(event:MouseEvent):void
		{
			if (enabeldDragChange && stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE,arrowMoveHandler,false,0,true);
				stage.addEventListener(MouseEvent.MOUSE_UP,arrowUpHandler,false,0,true);
				
				mouseDownPoint = new Point(mouseX,mouseY);
			}
		}
		
		protected function arrowMoveHandler(event:MouseEvent):void
		{
			if (enabeldDragChange)
			{
				data += (mouseX - mouseDownPoint.x + mouseDownPoint.y - mouseY) * detra;
				
				if (!isNaN(minValue))
					data = Math.max(data,minValue);
				
				if (!isNaN(maxValue))
					data = Math.min(data,maxValue);
				
				mouseDownPoint = new Point(mouseX,mouseY);
			}
		}
		
		protected function arrowUpHandler(event:MouseEvent):void
		{
			var stage:IEventDispatcher = event.currentTarget as IEventDispatcher;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,arrowMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,arrowUpHandler);
			
			mouseDownPoint = null;
		}
		
		/**
		 * 时基事件 
		 * @param event
		 * 
		 */
		protected override function tickHandler(event:TickEvent):void
		{
			if (upArrow)
				upArrow.enabled = isNaN(minValue) || data > minValue;
			
			if (downArrow)
				downArrow.enabled = isNaN(maxValue) ||  data < maxValue;
		}
		/** @inheritDoc*/
		protected override function textFocusInHandler(event:Event) : void
		{
			TweenUtil.removeTween(this);
			textField.text = data.toString();
		
			super.textFocusInHandler(event);
		}
		
		/** @inheritDoc*/
		protected override function textKeyDownHandler(event:KeyboardEvent):void
		{
			super.textKeyDownHandler(event);
			if (event.keyCode == Keyboard.ENTER)
				stage.focus = null;
		}
		
		/** @inheritDoc*/
		public override function set data(v : *):void
		{
			setValue(v,false);
		}
		
		/**
		 * 确认文本的数据
		 * 
		 */
		public override function accaptText():void
		{
			var v:Number = Number(textField.text);
			if (isNaN(v))
				v = minValue;
			
			if (isNaN(v))
				v = 0;
				
			v = Number(v.toFixed(fix));
			
			if (!isNaN(maxValue) && v > maxValue)
				v = maxValue;
			
			if (!isNaN(minValue) && v < minValue)
				v = minValue;
			
			setValue(v,false);
			
			textField.scrollH = 0;
			textField.scrollV = 0;
		}
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			if (upArrow) 
				upArrow.destory();
			
			if (downArrow) 
				downArrow.destory();
			
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,arrowMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP,arrowUpHandler);
			}
		
			super.destory();
		}
	}
}