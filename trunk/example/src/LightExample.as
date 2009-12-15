package 
{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.display.GBase;
	import ghostcat.display.graphics.DragPoint;
	import ghostcat.display.game.Light;
	import ghostcat.display.game.Wall;
	import ghostcat.events.MoveEvent;
	import ghostcat.manager.DragManager;
	import ghostcat.skin.cursor.CursorDrag;
	import ghostcat.ui.CursorSprite;
	import ghostcat.ui.controls.GImage;
	import ghostcat.util.Util;
	
	[SWF(width="500",height="400")]
	/**
	 * 费了老大劲做的一个效果
	 * 
	 * 主体是灯光类，这个灯光可以加载到任何地方，并用灯光的遮罩表现阴影，善加利用可以大大增加体验
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class LightExample extends Sprite
	{
		public var w:Wall;
		public var l1:Light;
		public var l2:Light;
		public var r:GBase;
		public function LightExample()
		{
			new EnabledSWFScreen(stage);
			
			//创建墙壁和控制点
			var p1:DragPoint = new DragPoint(null,new Point(100,200));
			var p2:DragPoint = new DragPoint(null,new Point(200,100));
			p1.addEventListener(MoveEvent.MOVE,moveHanlder);
			p2.addEventListener(MoveEvent.MOVE,moveHanlder);
			
			w = new Wall(new TestRepeater(),p1.position,p2.position,100);
			w.transform.colorTransform = new ColorTransform(0,0,0);
			addChild(w);
			
			addChild(p1);
			addChild(p2);
			
			//创建灯光
			l1 = Util.createObject(new Light(250),{x:300,y:120});
			addChild(l1);
			l2 = Util.createObject(new Light(250),{x:420,y:300});
			addChild(l2);
			
			//创建人物
			r = Util.createObject(new GBase(new TestHuman()),{cursor:CursorDrag,x:200,y:130});
			addChild(r);
			
			//将物品加入灯光中
			l1.addItem(r);
			l2.addItem(r);
			l1.addWall(w);
			l2.addWall(w);
			
			DragManager.register(r);
			
			stage.addChild(new CursorSprite())
		}
		private function moveHanlder(event:MoveEvent):void
		{
			w.invalidateDisplayList();
		}
	}
}