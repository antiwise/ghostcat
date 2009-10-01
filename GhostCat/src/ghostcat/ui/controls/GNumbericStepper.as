package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import ghostcat.events.TickEvent;
	import ghostcat.skin.NumberStepperSkin;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.Tick;
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
		public static var defaultSkin:ClassFactory = new ClassFactory(NumberStepperSkin);
		
		public var upArrow:GButton;
		public var downArrow:GButton;
		
		public var fields:Object = {upArrowField:"upArrow",downArrowField:"downArrow"}
		
		public var maxValue:Number;
		public var minValue:Number;
		public var detra:int = 1;
		
		public function GNumbericStepper(skin:*=null, replace:Boolean=true, enabledAdjustContextSize:Boolean=false, textPos:Point=null, fields:Object=null)
		{
			if (!skin)
				skin = defaultSkin;
			
			if (fields)
				this.fields = fields;
			
			super(skin, replace, enabledAdjustContextSize, textPos);
				
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
		}
		/** @inheritDoc*/
		protected override function getTextFieldFromSkin(skin:DisplayObject) : void
		{
			super.getTextFieldFromSkin(skin);
			textField.multiline = false;
		}
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			var upArrowField:String = fields.upArrowField;
			var downArrowField:String = fields.downArrowField;
			
			if (content.hasOwnProperty(upArrowField))
				upArrow = new GButton(content[upArrowField])
			
			if (content.hasOwnProperty(downArrowField))
				downArrow = new GButton(content[downArrowField])
		}
		/** @inheritDoc*/
		public override function getValue():*
		{
			accaptText();
			
			return super.getValue();
		}
		
		/**
		 * 时基事件 
		 * @param event
		 * 
		 */
		protected function tickHandler(event:TickEvent):void
		{
			if (upArrow)
			{
				upArrow.enabled = isNaN(minValue) || data > minValue;
				if (upArrow.mouseDown)
					data -= detra;
			}
			
			if (downArrow)
			{
				downArrow.enabled = isNaN(maxValue) ||  data < maxValue;
				if (downArrow.mouseDown)
					data += detra;
			}
		}
		/** @inheritDoc*/
		protected override function textFocusInHandler(event:Event) : void
		{
			TweenUtil.removeTween(this);
			textField.text = data.toString();
		
			super.textFocusInHandler(event);
		}
		/** @inheritDoc*/
		protected override function textFocusOutHandler(event:Event) : void
		{
			super.textFocusOutHandler(event);
			accaptText();
		}
		/** @inheritDoc*/
		protected override function textKeyDownHandler(event:KeyboardEvent):void
		{
			super.textKeyDownHandler(event);
			if (event.keyCode == Keyboard.ENTER)
				stage.focus = null;
		}
		
		/**
		 * 确认文本的数据
		 * 
		 */
		public function accaptText():void
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
		}
		/** @inheritDoc*/
		public override function destory() : void
		{
			super.destory();
			
			Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
			
			if (upArrow) 
				upArrow.destory();
			
			if (downArrow) 
				downArrow.destory();
			
		}
	}
}