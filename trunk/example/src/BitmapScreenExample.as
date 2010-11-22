package
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.net.URLLoader;
	
	import ghostcat.algorithm.QuadTree;
	import ghostcat.community.physics.PhysicsItem;
	import ghostcat.community.physics.PhysicsManager;
	import ghostcat.debug.EnabledSWFScreen;
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
	import ghostcat.util.Util;
	
	[SWF(width="400",height="400",frameRate="60",backgroundColor="0xFFFFFF")]
	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapScreenExample extends GBase
	{
		public const COUNT:int = 1000;
		
		public var s:BitmapScreen;
		public var p:PhysicsManager;
		
		protected override function init():void
		{
			RootManager.register(this);
			
			s = new BitmapScreen(400,400,false);
			s.mode = BitmapScreen.MODE_BITMAP;
			s.enabledMouseCheck = false;
			addChild(s);
			
			//创建100个物品
			for (var i:int = 0;i < COUNT;i++)
			{
				var m:GBitmap = new GBitmap(new DrawParse(new TestHuman()).createBitmapData())
				m.x = Math.random() * stage.stageWidth;
				m.y = Math.random() * stage.stageHeight;
				m.enabledDelayUpdate = false;
				m.enableMouseEvent = false;
				s.addObject(m); 
			}
			s.enabledTick = false;
			
			//创建物理
			p = new PhysicsManager(physicsTickHandler);
			for (i = 0;i < COUNT;i++)
			{
				p.add(s.children[i]);
				p.setVelocity(s.children[i],new Point(Math.random()*50 - 25,Math.random()*50 - 25))
			}
			p.paused = true;
			
			//创建UI
			var vbox:GVBox = new GVBox();
			vbox.y = 30;
			addChild(vbox);
			
			var checkBox:GCheckBox = Util.createObject(GCheckBox,{label:"暂停",selected:true});
			vbox.addChild(checkBox);
			checkBox.addEventListener(Event.CHANGE,checkChangeHandler);
			
			var checkBox2:GCheckBox = Util.createObject(GCheckBox,{label:"排序",selected:false});
			vbox.addChild(checkBox2);
			checkBox2.addEventListener(Event.CHANGE,check2ChangeHandler);
			
			var space:GNoScale = new GNoScale();
			space.setSize(100,10);
			vbox.addChild(space);
			 
			vbox.addChild(Util.createObject(GRadioButton,{label:"普通",groupName:"a"}));
			vbox.addChild(Util.createObject(GRadioButton,{label:"copyPixel",groupName:"a",selected:true}));
			vbox.addChild(Util.createObject(GRadioButton,{label:"setPixles",groupName:"a"}));
			
			var group:GRadioButtonGroup = GRadioButtonGroup.getGroupByName("a");
			group.addEventListener(Event.CHANGE,radioChangeHandler);
			
			addChild(new FPS());
			new EnabledSWFScreen(stage)
		}
		
		private function checkChangeHandler(event:Event):void
		{
			p.paused = !p.paused;
			s.enabledTick = !s.enabledTick;
		}
		
		private function check2ChangeHandler(event:Event):void
		{
			var b:Boolean = (event.currentTarget as GCheckBox).selected;
			s.sortFields = b? ["y"]:null;
		}
		
		private function radioChangeHandler(event:Event):void
		{
			var group:GRadioButtonGroup = event.currentTarget as GRadioButtonGroup;
			switch (group.selectedItem.label)
			{
				case "普通":
					s.mode = BitmapScreen.MODE_SPRITE;
					break;
				case "copyPixel":
					s.mode = BitmapScreen.MODE_BITMAP;
					for each (var bitmap:GBitmap in s.children)
						bitmap.uncache();
					break;
				case "setPixles":
					s.mode = BitmapScreen.MODE_BITMAP;
					for each (bitmap in s.children)
						bitmap.cache();
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