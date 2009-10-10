package
{
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import ghostcat.community.SortYManager;
	import ghostcat.community.physics.PhysicsItem;
	import ghostcat.community.physics.PhysicsManager;
	import ghostcat.debug.FPS;
	import ghostcat.display.GBase;
	import ghostcat.display.viewport.Light;
	import ghostcat.display.viewport.Wall;
	import ghostcat.events.TickEvent;
	import ghostcat.manager.RootManager;
	import ghostcat.ui.containers.GAlert;
	import ghostcat.util.Util;
	
	
	[SWF(width="400",height="400",frameRate="60")]
	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	/**
	 * 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SortExample extends GBase
	{
		public var c:SortYManager;
		public var p:PhysicsManager;
		public var debugTextField:TextField;
			
		protected override function init():void
		{
			RootManager.register(this);
			
//			var w:Wall = new Wall(new TestRepeater(),new Point(100,100),new Point(300,80),100);
//			addChild(w);
//			
//			var l:Light = Util.createObject(new Light(250),{x:300,y:120,color:0xFF0000});
//			addChild(l);
//			l.addWall(w);
			
			
			//创建100个物品
			for (var i:int = 0;i < 100;i++)
			{
				var m:GBase = new GBase(new TestHuman())
				m.setPosition(Math.random() * stage.stageWidth,Math.random() * stage.stageHeight,true);
				addChild(m);
				
//				l.addItem(m);
			}
			
			//创建排序器
			c = new SortYManager();
			c.addAllChildren(this);
			
			//创建物理
			p = new PhysicsManager(physicsTickHandler);
			p.addAllChildren(this);
			
			//创建文本显示计算时间
			debugTextField = new TextField();
			debugTextField.mouseEnabled = false;
			addChild(debugTextField);
			
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		
			GAlert.show("点击人物激活移动")
			
			this.enabledTick = true;
			
			addChild(new FPS())
		}
		
		private function physicsTickHandler(item:PhysicsItem,interval:int):void
		{
			//撞墙则反弹
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
			//点击图元时
			if (event.target.parent is GBase)
			{
				var obj:GBase = event.target.parent as GBase;
				//修改颜色
				obj.transform.colorTransform = new ColorTransform(1,1,1,1,0,255);
				//给予速度
				p.setVelocity(obj,new Point(Math.random()*500 - 250,Math.random()*500 - 250))
			}
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			var t:int = getTimer();
			c.calculateAll();//排序全部
			debugTextField.text = (getTimer() - t).toString();
		}
	}
}