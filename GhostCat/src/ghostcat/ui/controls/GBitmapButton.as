package ghostcat.ui.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.display.bitmap.BitmapMouseChecker;
	import ghostcat.display.bitmap.IBitmapDataDrawer;
	import ghostcat.display.movieclip.GBitmapMovieClip;
	import ghostcat.parse.graphics.GraphicsBitmapFill;
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.display.GraphicsUtil;
	
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * 位图按钮
	 * 
	 * 标签规则：为一整动画，up,over,down,disabled,selectedUp,selectedOver,selectedDown,selectedDisabled是按钮的八个状态，
	 * 状态间的过滤为两个标签中间加-，末尾加:start。比如up和over的过滤即为up-over:start
	 * 
	 * 皮肤同时也会当作文本框再次处理一次
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GBitmapButton extends GButtonBase implements IBitmapDataDrawer
	{
		public function GBitmapButton(bitmaps:Array=null,labels:Array=null,textPadding:Padding=null)
		{
			movie = new GBitmapMovieClip(bitmaps,labels);
			
			super(movie.content, true, true,textPadding);
			
			this.mouseEnabled = false;
		}
		
		/** @inheritDoc*/
		protected override function init() : void
		{
			(movie as GBitmapMovieClip).bitmapMouseChecker = new BitmapMouseChecker(content as Bitmap);
			super.init();
		}
		
		/**
		 * 从一个MovieClip生成
		 * 注意这个缓存是需要时间的，如果要在完全生成GBitmapButton对象后进行一些操作，可监听GBitmapButton的complete事件
		 * 
		 * @param mc	要转换的电影剪辑
		 * @param rect	绘制范围
		 * @param start	起始帧
		 * @param len	长度
		 * @return 
		 * 
		 */
		public function createFromMovieClip(mc:MovieClip,rect:Rectangle=null,start:int = 1,len:int = -1):void
		{
			movie.addEventListener(Event.COMPLETE,renderCompleteHandler);
			(movie as GBitmapMovieClip).createFromMovieClip(mc,rect,start,len);
		}
		
		private function renderCompleteHandler(event:Event):void
		{
			movie.removeEventListener(Event.COMPLETE,renderCompleteHandler);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/** @inheritDoc*/
		protected override function addEvents():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			addEventListener(MouseEvent.MOUSE_OVER,rollOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT,rollOutHandler);
			addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		/** @inheritDoc*/
		protected override function removeEvents():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			removeEventListener(MouseEvent.MOUSE_OVER,rollOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT,rollOutHandler);
			removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		
		/** @inheritDoc*/
		public function drawToBitmapData(target:BitmapData,offest:Point):void
		{
			var bitmapData:BitmapData = (content as Bitmap).bitmapData;
			if (bitmapData)
				target.copyPixels(bitmapData,bitmapData.rect,position.add(offest));
		}
		
		/** @inheritDoc*/
		public function drawToShape(target:Graphics,offest:Point):void
		{
			var p:Point = new Point(x,y).add(offest);
			GraphicsBitmapFill.drawBitmpData(target,(content as Bitmap).bitmapData,p.x,p.y);
		}
		
		/** @inheritDoc*/
		public function getBitmapUnderMouse(mouseX:Number,mouseY:Number):Array
		{
			var bitmapData:BitmapData = (content as Bitmap).bitmapData;
			if (uint(bitmapData.getPixel32(mouseX - x,mouseY - y) >> 24) > 0)
				return [this];
			else
				return null;
		}
	}
}