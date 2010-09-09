package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	[SWF(width="1000",height="500",backgroundColor="0xFFFFFF",frameRate="60")]
	public class FP10Test extends Sprite
	{
		public static const MAX:int = 5000;
		public var list:Vector.<Bitmap>;
		public var speedListX:Vector.<Number>;
		public var speedListY:Vector.<Number>;
		public var dragList:Dictionary;
		public function createMap():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
			list = new Vector.<Bitmap>(MAX,true);
			speedListX = new Vector.<Number>(MAX,true);
			speedListY = new Vector.<Number>(MAX,true);
			dragList = new Dictionary();
			for (var i:int = 0;i < MAX;i++)
			{
				var bitmap:Bitmap = new Bitmap(new BitmapData(10,10,false,Math.random() * 0xFF));
				bitmap.x = (i % 100) * 10;
				bitmap.y = (i / 100) * 10;
				addChild(bitmap);
				list[i] = bitmap;
				speedListX[i] = Math.random() - 0.5;
				speedListY[i] = Math.random() - 0.5;
			}
		}
		public function FP10Test()
		{
			var t:TextField = new TextField();
			t.text = "Bitmap";
			t.autoSize = "left";
			t.opaqueBackground = 0xFFFFFF;
			t.y = 20;
			stage.addChild(t);
			
			stage.addChild(new FPS());
			createMap();
			
			stage.addEventListener(MouseEvent.CLICK,clickHandler);
			stage.addEventListener(Event.ENTER_FRAME,tickHandler);
		}
		
		private function tickHandler(event:Event):void
		{
			var len:int = list.length;
			var mw:Number = stage.stageWidth;
			var mh:Number = stage.stageHeight;
			for (var i:int = 0;i < len;i++)
			{
				var p:Bitmap = list[i] as Bitmap;
				if (dragList[p])
				{
					p.x += (mouseX - 5 - p.x) / 5;
					p.y += (mouseY - 5 - p.y) / 5;
				}
				else
				{
					p.x += speedListX[i];
					p.y += speedListY[i];
					if (p.x > mw)
						p.x = 0;
					else if (p.x < 0)
						p.x = mw;
					
					if (p.y > mh)
						p.y = 0;
					else if (p.y < 0)
						p.y = mh;
				}
			}
			
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			for (var i:int = 0;i < MAX;i++)
			{
				var p:Bitmap = list[i];
				if (mouseX >= p.x && mouseX <= p.x + 10 && mouseY >= p.y && mouseY <= p.y + 10)
				{
					if (!dragList.hasOwnProperty(p))
					{
						p.bitmapData.fillRect(p.bitmapData.rect,0xFF0000);
						dragList[p] = true;
					}
				}
			}
		}
	}
}