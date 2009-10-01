package
{
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import ghostcat.community.DisplayCommunityManager;
	import ghostcat.community.SortYManager;
	import ghostcat.community.physics.PhysicsItem;
	import ghostcat.community.physics.PhysicsManager;
	import ghostcat.display.GBase;
	import ghostcat.display.GTickBase;
	import ghostcat.events.TickEvent;
	import ghostcat.manager.RootManager;
	import ghostcat.ui.containers.GAlert;
	
	
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
		public var c:DisplayCommunityManager;
		public var p:PhysicsManager;
		public var debugTextField:TextField;
			
		protected override function init():void
		{
			RootManager.register(this);
			
			for (var i:int = 0;i < 100;i++)
			{
				var m:GBase = new GBase(new TestHuman())
				m.setPosition(Math.random() * stage.stageWidth,Math.random() * stage.stageHeight,true);
				addChild(m);
			}
			
			c = new SortYManager();
			c.addAllChildren(this);
			
			p = new PhysicsManager();
			p.addAllChildren(this);
			p.onTick = physicsTickHandler;
		
			debugTextField = new TextField();
			debugTextField.mouseEnabled = false;
			addChild(debugTextField);
			
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		
			GAlert.show("点击人物激活移动")
		}
		
		private function physicsTickHandler(item:PhysicsItem,interval:int):void
		{
			if (item.x < 0 && item.velocity.x < 0)
				item.velocity.x = -item.velocity.x;
		
			if (item.x > stage.stageWidth && item.velocity.x > 0)
				item.velocity.x = -item.velocity.x;
		
			if (item.y < 0 && item.velocity.y < 0)
				item.velocity.y = -item.velocity.y;
			
			if (item.y > stage.stageHeight && item.velocity.y > 0)
				item.velocity.y = -item.velocity.y;
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			if (event.target.parent is GBase)
			{
				var obj:GBase = event.target.parent as GBase;
				obj.transform.colorTransform = new ColorTransform(1,1,1,1,0,255);
				p.setVelocity(obj,new Point(Math.random()*500 - 250,Math.random()*500 - 250))
			}
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			var t:int = getTimer();
			c.calculateAll();
			debugTextField.text = (getTimer() - t).toString();
		}
	}
}