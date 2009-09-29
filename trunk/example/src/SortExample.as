package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import ghostcat.community.DisplayCommunityManager;
	import ghostcat.community.command.DrawPriorityCommand;
	import ghostcat.debug.DebugScreen;
	import ghostcat.display.DisplayUtil;
	import ghostcat.display.GBase;
	import ghostcat.display.GTickBase;
	import ghostcat.display.viewport.CollisionSprite;
	import ghostcat.events.TickEvent;
	import ghostcat.manager.RootManager;
	import ghostcat.parse.display.EllipseParse;
	import ghostcat.parse.display.ShapeParse;
	import ghostcat.parse.graphics.GraphicsEllipse;
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.ui.containers.GAlert;
	import ghostcat.util.Geom;
	
	
	[SWF(width="520",height="400",frameRate="30")]
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
			
			for (var i:int = 0;i < 1000;i++)
			{
				var m:GBase = new GBase(new TestHuman())
				m.x = Math.random() * stage.stageWidth;
				m.y = Math.random() * stage.stageHeight;
				addChild(m);
			}
			
			point = new GBase(new TestHuman());
			point.transform.colorTransform = new ColorTransform(1,1,1,1,0,255);
			addChild(point);
			
			c = new DisplayCommunityManager(DrawPriorityCommand.SORTY);
			c.addAllChildren(this);
		
			debugTextField = new TextField();
			addChild(debugTextField);
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			point.x = mouseX;
			point.y = mouseY;
			
			var t:int = getTimer();
			c.calculateAll(true);
			debugTextField.text = (getTimer() - t).toString();
		}
	}
}