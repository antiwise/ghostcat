package
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import ghostcat.community.physics.PhysicsItem;
	import ghostcat.community.physics.PhysicsManager;
	import ghostcat.debug.FPS;
	import ghostcat.display.GBase;
	import ghostcat.display.GNoScale;
	import ghostcat.display.bitmap.BitmapScreen;
	import ghostcat.display.bitmap.GBitmap;
	import ghostcat.manager.RootManager;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.ui.containers.GVBox;
	import ghostcat.ui.controls.GCheckBox;
	import ghostcat.ui.controls.GRadioButton;
	import ghostcat.ui.controls.GRadioButtonGroup;
	
	
	[SWF(width="400",height="400",frameRate="120",backgroundColor="0xFFFFFF")]
	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapScreenExample extends GBase
	{
		public var s:BitmapScreen;
		public var p:PhysicsManager;
		
		protected override function init():void
		{
			RootManager.register(this);
			
			s = new BitmapScreen(400,400,false);
			s.mode = BitmapScreen.MODE_BITMAP;
			addChild(s);
			
			//创建100个物品
			for (var i:int = 0;i < 300;i++)
			{
				var m:GBitmap = new GBitmap(new DrawParse(new TestHuman()).createBitmapData())
				m.setPosition(Math.random() * stage.stageWidth,Math.random() * stage.stageHeight,true);
				m.enabledDelayUpdate = false;
				m.enableMouseEvent = false;
				s.addObject(m); 
			}
			
			//创建物理
			p = new PhysicsManager(physicsTickHandler);
			for (i = 0;i < 300;i++)
			{
				p.add(s.children[i]);
				p.setVelocity(s.children[i],new Point(Math.random()*500 - 250,Math.random()*500 - 250))
			}
			
			addChild(new FPS());
			
			var vbox:GVBox = new GVBox();
			vbox.y = 30;
			addChild(vbox);
			var checkBox:GCheckBox = new GCheckBox();
			checkBox.label = "暂停";
			vbox.addChild(checkBox);
			checkBox.addEventListener(Event.CHANGE,checkChangeHandler);
			
			var space:GNoScale = new GNoScale();
			space.setSize(100,10);
			vbox.addChild(space);
			
			var radioButton:GRadioButton = new GRadioButton();
			radioButton.label = "普通";
			radioButton.groupName = "a";
			vbox.addChild(radioButton);
			radioButton = new GRadioButton();
			radioButton.label = "copyPixel";
			radioButton.groupName = "a";
			radioButton.selected = true;
			vbox.addChild(radioButton);
			radioButton = new GRadioButton();
			radioButton.label = "beginBitmapFill";
			radioButton.groupName = "a";
			vbox.addChild(radioButton);
			var group:GRadioButtonGroup = GRadioButtonGroup.getGroupByName("a");
			group.addEventListener(Event.CHANGE,radioChangeHandler);
		}
		
		private function checkChangeHandler(event:Event):void
		{
			p.paused = !p.paused;
			s.enabledTick = !s.enabledTick;
		}
		
		private function radioChangeHandler(event:Event):void
		{
			var group:GRadioButtonGroup = event.currentTarget as GRadioButtonGroup;
			switch (group.selectedItem.label)
			{
				case "普通":
					s.mode = BitmapScreen.MODE_SPRITE
					break;
				case "copyPixel":
					s.mode = BitmapScreen.MODE_BITMAP;
					break;
				case "beginBitmapFill":
					s.mode = BitmapScreen.MODE_SHAPE;
					break;
				
			}
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
	}
}