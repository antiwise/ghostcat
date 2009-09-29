package
{
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import ghostcat.community.DisplayCommunityManager;
	import ghostcat.community.SortManager;
	import ghostcat.community.command.DrawPriorityCommand;
	import ghostcat.display.GBase;
	import ghostcat.display.GTickBase;
	import ghostcat.events.TickEvent;
	import ghostcat.manager.RootManager;
	
	
	[SWF(width="400",height="400")]
	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	/**
	 * 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SortExample extends GTickBase
	{
		public var point:GBase;
		public var c:DisplayCommunityManager;
		public var debugTextField:TextField;
			
		protected override function init():void
		{
			RootManager.register(this);
			
			for (var i:int = 0;i < 500;i++)
			{
				var m:GBase = new GBase(new TestHuman())
				m.setPosition(Math.random() * stage.stageWidth,Math.random() * stage.stageHeight,true);
				addChild(m);
			}
			
			point = new GBase(new TestHuman());
			point.transform.colorTransform = new ColorTransform(1,1,1,1,0,255);
			addChild(point);
			
			c = new SortManager(DrawPriorityCommand.SORTY);
			c.addAllChildren(this);
		
			debugTextField = new TextField();
			addChild(debugTextField);
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			point.x = mouseX;
			point.y = mouseY;
			
			var t:int = getTimer();
			c.calculateAll();
			debugTextField.text = (getTimer() - t).toString();
		}
	}
}