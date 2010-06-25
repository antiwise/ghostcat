package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	
	import ghostcat.algorithm.QuadTree;
	import ghostcat.community.physics.PhysicsItem;
	import ghostcat.community.physics.PhysicsManager;
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.debug.FPS;
	import ghostcat.display.GBase;
	import ghostcat.display.GNoScale;
	import ghostcat.display.bitmap.BitmapScreen;
	import ghostcat.display.bitmap.GBitmap;
	import ghostcat.events.TickEvent;
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
	 * 四叉数筛选演示
	 * @author flashyiyi
	 * 
	 */
	public class QuadExample extends GBase
	{
		public const COUNT:int = 1000;
		
		public var p:PhysicsManager;
		public var q:QuadTree;
		
		protected override function init():void
		{
			RootManager.register(this);
			
			q = new QuadTree(new Rectangle(0,0,400,400));
			q.createChildren(3);
			
			//创建100个物品
			for (var i:int = 0;i < COUNT;i++)
			{
				var m:Item = new Item(new DrawParse(new TestHuman()).createBitmapData())
				m.x = Math.random() * stage.stageWidth;
				m.y = Math.random() * stage.stageHeight;
				this.addChild(m); 
				
				m.quad = q.add(m,m.x,m.y);
			}
			
			//创建物理
			p = new PhysicsManager(physicsTickHandler);
			for (i = 0;i < COUNT;i++)
			{
				p.add(this.getChildAt(i));
				p.setVelocity(this.getChildAt(i),new Point(Math.random()*50 - 25,Math.random()*50 - 25))
			}
			
			this.enabledTick = true;
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			super.tickHandler(event);
			
			for (var i:int = 0;i < this.numChildren;i++)
				(getChildAt(i) as DisplayObject).transform.colorTransform = new ColorTransform()
			
			var list:Array = q.getDataInRect(new Rectangle(50,50,100,100));
			for each (var m:Item in list)
			{
				m.transform.colorTransform = new ColorTransform(1,1,1,1,0,100,100)
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
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;

import ghostcat.algorithm.QuadTree;
import ghostcat.display.bitmap.GBitmap;

class Item extends Bitmap
{
	public var quad:QuadTree;
	public function Item(bitmap:BitmapData):void
	{
		super(bitmap);
		addEventListener(Event.ENTER_FRAME,enterFrameHandler);
	}
	
	private function enterFrameHandler(event:Event):void
	{
		quad = quad.reinsert(this,x,y);
	}
}