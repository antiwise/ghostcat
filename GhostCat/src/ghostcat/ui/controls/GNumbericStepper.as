package ghostcat.ui.controls
{
	import flash.geom.Point;
	
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
	
	/**
	 * 数字选择框
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GNumbericStepper extends GNumberic
	{
		public var upArrow:GButton;
		public var downArrow:GButton;
		
		public var fields:Object = {upArrowField:"upArrow",downArrowField:"downArrow"}
		
		public var maxValue:Number;
		public var minValue:Number;
		public var detra:int = 1;
		
		public function GNumbericStepper(skin:*=null, replace:Boolean=true, enabledAdjustContextSize:Boolean=false, textPos:Point=null, fields:Object=null)
		{
			if (fields)
				this.fields = fields;
			
			super(skin, replace, enabledAdjustContextSize, textPos);
				
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
		}
		
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