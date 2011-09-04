package ghostcat.ui.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.display.bitmap.BitmapMouseChecker;
	import ghostcat.display.bitmap.IBitmapDataDrawer;
	import ghostcat.display.movieclip.GBitmapMovieClip;
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.display.BitmapSeparateUtil;
	
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * 位图按钮，skin可以传入BitmapData数组，也可以传入专门的BitmapButtonSkin对象，以便用于替换
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
		public function GBitmapButton(skin:*=null,labels:Array=null,textPadding:Padding=null,enabledAdjustContextSize:Boolean = false)
		{
			var bitmaps:Array;
			var currentLabels:Array;
			if (skin is BitmapButtonSkin)
			{
				bitmaps = BitmapButtonSkin(skin).bitmapDatas;
				currentLabels = BitmapButtonSkin(skin).labels;
				this.replaceTarget(BitmapButtonSkin(skin));
			}
			else if (skin is Array)
			{
				bitmaps = skin as Array;
			}
			
			if (labels)
				currentLabels = labels.concat();
			
			if (useDefaultLabels && (bitmaps && bitmaps.length > 1) && !(currentLabels && currentLabels.length))
				currentLabels = defaultLabels;
			
			movie = new GBitmapMovieClip(bitmaps,currentLabels);
			
			super(movie.content, true, true,textPadding,enabledAdjustContextSize);
		}
		
		/** @inheritDoc*/
		protected override function init() : void
		{
			(movie as GBitmapMovieClip).bitmapMouseChecker = new BitmapMouseChecker(content as Bitmap);
			super.init();
		}
		
		/**
		 * 是否在销毁的时候自动回收位图
		 */
		public function set disposeWhenDestory(v:Boolean):void
		{
			(movie as GBitmapMovieClip).disposeWhenDestory = v;
		}
		
		public function get disposeWhenDestory():Boolean
		{
			return (movie as GBitmapMovieClip).disposeWhenDestory;
		}
		
		/**
		 * 设置一张整图来并切分到多个状态来设置皮肤
		 * 
		 * @param source	源图
		 * @param width	横向图片数量
		 * @param height	纵向图片数量
		 * 
		 */
		public function setWholeBitmapDataSkin(source:BitmapData,width:int = 1,height:int = 4):void
		{
			GBitmapMovieClip(this.movie).bitmaps = BitmapSeparateUtil.separateBitmapData(source,width,height);
			GBitmapMovieClip(this.movie).labels = defaultLabels;
		}
		
		/**
		 * 从一个MovieClip生成
		 * 注意这个缓存是需要时间的，如果要在完全生成GBitmapButton对象后进行一些操作，可监听GBitmapButton的complete事件
		 * 
		 * @param mc	要转换的电影剪辑
		 * @param rect	绘制范围
		 * @param start	起始帧
		 * @param len	长度
		 * @param readWhenPlaying 	是否在播放时顺便缓存
		 * @param readWhenPlaying	每次缓存允许占用的时间
		 * @return 
		 * 
		 */
		public function createFromMovieClip(mc:MovieClip,rect:Rectangle=null,start:int = 1,len:int = -1,readWhenPlaying:Boolean = false,limitTimeInFrame:int = 10):void
		{
			movie.addEventListener(Event.COMPLETE,renderCompleteHandler);
			(movie as GBitmapMovieClip).createFromMovieClip(mc,rect,start,len,readWhenPlaying,limitTimeInFrame);
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
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,false,0,true);
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
				target.copyPixels(bitmapData,bitmapData.rect,position.add(offest),null,null,target.transparent);
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