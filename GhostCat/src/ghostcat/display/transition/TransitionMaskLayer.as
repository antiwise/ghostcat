package ghostcat.display.transition
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import ghostcat.debug.Debug;
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.display.movieclip.GMovieClipBase;
	import ghostcat.operation.DelayOper;
	import ghostcat.operation.MovieOper;
	import ghostcat.operation.Oper;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.util.core.Handler;

	/**
	 * 显示一个动画对象作为Mask的过渡
	 * 
	 * 当设置了wait属性后，将会暂停，此时只能用continueFadeOut方法继续
	 *
	 * @author flashyiyi
	 * 
	 */
	public class TransitionMaskLayer extends TransitionLayerBase
	{
		/**
		 * 缓存对象
		 */
		public var bitmap:Bitmap;
		
		/**
		 * Mask动画
		 */
		public var maskMovieClip:GMovieClipBase;
		
		private var displayObj:Sprite;
		
		
		/** @inheritDoc*/
		public override function createTo(container:DisplayObjectContainer):TransitionLayerBase
		{
			displayObj = new Sprite();
			displayObj.blendMode = BlendMode.LAYER;
			displayObj.addChild(bitmap);
			
			maskMovieClip.blendMode = BlendMode.ALPHA;
			displayObj.addChild(maskMovieClip);
			
			container.addChild(displayObj);
			
			return super.createTo(container);
		}
		
		public function TransitionMaskLayer(switchHandler:*,target:DisplayObject,maskMovieClip:*,maskLabel:String = null, fadeOut:int = 1000, wait:Boolean=false)
		{
			this.bitmap = new DrawParse(target).createBitmap();
			
			var fadeOutOper:Oper;
			var waitOper:Oper;
			
			if (maskMovieClip is MovieClip)
				this.maskMovieClip = new GMovieClip(maskMovieClip);
			else if (maskMovieClip is GMovieClipBase)
				this.maskMovieClip = maskMovieClip as GMovieClipBase;
			else
				Debug.error("maskMovieClip参数必须是MovieClip,GMovieClipBase之一")
					
			this.maskMovieClip.setLoop(1);//只播放一次
			
			if (fadeOut)
				fadeOutOper = new MovieOper(maskMovieClip,maskLabel);
			if (wait)
				waitOper = new DelayOper(-1);
			
			super(switchHandler,null,fadeOutOper,waitOper);
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (bitmap)
			{
				bitmap.parent.removeChild(bitmap);
				bitmap.bitmapData.dispose();
			}
			
			if (maskMovieClip)
				maskMovieClip.destory();
			
			if (displayObj)
				displayObj.parent.removeChild(displayObj);
			
			super.destory();
		}
	}
}