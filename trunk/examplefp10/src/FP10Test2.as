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
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	[SWF(width="1000",height="500",backgroundColor="0xFFFFFF",frameRate="60")]
	public class FP10Test2 extends Sprite
	{
		public static const MAX:int = 5000;
		public var bitmapData:BitmapData;
		public var list:Vector.<BitmapData>;
		public var listX:Vector.<Number>;
		public var listY:Vector.<Number>;
		public var speedListX:Vector.<Number>;
		public var speedListY:Vector.<Number>;
		public var dragList:Dictionary;
		public function createMap():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
			
			list = new Vector.<BitmapData>(MAX,true);
			listX = new Vector.<Number>(MAX,true);
			listY = new Vector.<Number>(MAX,true);
			speedListX = new Vector.<Number>(MAX,true);
			speedListY = new Vector.<Number>(MAX,true);
			dragList = new Dictionary();
			for (var i:int = 0;i < MAX;i++)
			{
				var bitmap:BitmapData = new BitmapData(10,10,false,Math.random() * 0xFF);
				listX[i] = (i % 100) * 10;
				listY[i] = (i / 100) * 10;
				list[i] = bitmap;
				speedListX[i] = Math.random() - 0.5;
				speedListY[i] = Math.random() - 0.5;
			}
		}
		public function FP10Test2()
		{
			stage.addChild(new FPS());
			
			bitmapData = new BitmapData(stage.stageWidth,stage.stageHeight,false,0xFFFFFF);
			var bitmap:Bitmap = new Bitmap(bitmapData);
			addChild(bitmap);
			
			createMap();
			
			stage.addEventListener(MouseEvent.CLICK,clickHandler);
			stage.addEventListener(Event.ENTER_FRAME,tickHandler);
		}
		
		private function tickHandler(event:Event):void
		{
			bitmapData.lock();
			bitmapData.fillRect(bitmapData.rect,0xFFFFFF);
			
			var len:int = list.length;
			var mw:Number = stage.stageWidth;
			var mh:Number = stage.stageHeight;
			for (var i:int = 0;i < len;i++)
			{
				var p:BitmapData = list[i] as BitmapData;
				var px:Number = listX[i];
				var py:Number = listY[i];
				if (dragList[p])
				{
					px += (mouseX - 5 - px) / 5;
					py += (mouseY - 5 - py) / 5;
				}
				else
				{
					px += speedListX[i];
					py += speedListY[i];
					if (px > mw)
						px = 0;
					else if (px < 0)
						px = mw;
					
					if (py > mh)
						py = 0;
					else if (py < 0)
						py = mh;
				}
				listX[i] = px;
				listY[i] = py;
				
				bitmapData.copyPixels(p,p.rect,new Point(px,py));
			}
			bitmapData.unlock();
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			for (var i:int = 0;i < MAX;i++)
			{
				var p:BitmapData = list[i];
				var px:Number = listX[i];
				var py:Number = listY[i];
				if (mouseX >= px && mouseX <= px + 10 && mouseY >= py && mouseY <= py + 10)
				{
					if (!dragList.hasOwnProperty(p))
					{
						p.fillRect(p.rect,0xFF0000);
						dragList[p] = true;
					}
				}
			}
		}
	}
}