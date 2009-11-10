package ghostcat.display.transition
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import ghostcat.display.GBase;
	import ghostcat.display.movieclip.GScriptMovieClip;
	import ghostcat.display.transfer.GBitmapEffect;
	import ghostcat.display.transfer.effect.DissolveHandler;
	import ghostcat.display.transfer.effect.MosaicHandler;
	import ghostcat.display.transfer.effect.SegmentHandler;
	import ghostcat.display.transfer.effect.ThresholdHandler;
	import ghostcat.display.transition.maskmovie.DissolveMaskHandler;
	import ghostcat.display.transition.maskmovie.GradientAlphaMaskHandler;
	import ghostcat.display.transition.maskmovie.ShutterDirectMaskHandler;
	import ghostcat.display.transition.maskmovie.ShutterMaskHandler;
	import ghostcat.display.viewport.BackgroundLayer;
	import ghostcat.ui.controls.GImage;
	import ghostcat.util.RandomUtil;
	import ghostcat.util.easing.Circ;
	
	/**
	 * 创建几个模板Transition对象，执行createTo方法便可应用到舞台上
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class TransitionManager
	{
		/**差异值渐变 */
		public static function threshold(switchHandler:*,target:DisplayObject):TransitionTransferLayer
		{
			return new TransitionTransferLayer(switchHandler,new GBitmapEffect(target,new ThresholdHandler()));
		}
		/**溶解渐变 */
		public static function dissolve(switchHandler:*,target:DisplayObject):TransitionTransferLayer
		{
			return new TransitionTransferLayer(switchHandler,new GBitmapEffect(target,new DissolveHandler(getTimer())));
		}
		/**切割渐变 */
		public static function segment(switchHandler:*,target:DisplayObject,type:int = 0):TransitionTransferLayer
		{
			return new TransitionTransferLayer(switchHandler,new GBitmapEffect(target,new SegmentHandler(type)))
		}
		/**马赛克渐变 */
		public static function mosaic(switchHandler:*,target:DisplayObject):TransitionObjectLayer
		{
			return new TransitionObjectLayer(switchHandler,new GBitmapEffect(target,new MosaicHandler()),target,500,500);
		}
		/**过渡渐变 */
		public static function fade(switchHandler:*,target:DisplayObject):TransitionCacheLayer
		{
			return new TransitionCacheLayer(switchHandler,target);
		}
		/**滑动渐变 */
		public static function move(switchHandler:*,target:DisplayObject,direction:int = 0):TransitionCacheLayer
		{
			return new TransitionCacheLayer(switchHandler,target,1000,{x:600 * ((direction % 2 == 0)? 1 : -1),y:450 * ((int(direction / 2) == 0)? 1 : -1),ease:Circ.easeIn});
		}
		/**方格渐变 */
		public static function dissolveMask(switchHandler:*,target:DisplayObject):TransitionMaskLayer
		{
			return new TransitionMaskLayer(switchHandler,target,new GScriptMovieClip(new DissolveMaskHandler(20),target.getBounds(target.parent)));
		}
		/**百叶窗渐变 */
		public static function shutterMask(switchHandler:*,target:DisplayObject):TransitionMaskLayer
		{
			return new TransitionMaskLayer(switchHandler,target,new GScriptMovieClip(new ShutterMaskHandler(),target.getBounds(target.parent)));
		}
		/**百叶窗打开渐变 */
		public static function shutterMask2(switchHandler:*,target:DisplayObject,direction:int = 0):TransitionMaskLayer
		{
			return new TransitionMaskLayer(switchHandler,target,new GScriptMovieClip(new ShutterDirectMaskHandler(50,direction),target.getBounds(target.parent)));
		}
		/**方向性过度渐变 */
		public static function gradientAlphaMask(switchHandler:*,target:DisplayObject,angle:Number = 0):TransitionMaskLayer
		{
			return new TransitionMaskLayer(switchHandler,target,new GScriptMovieClip(new GradientAlphaMaskHandler(angle),target.getBounds(target.parent)));
		}
		/**白屏过渡渐变 */
		public static function simple(switchHandler:*,target:DisplayObject):TransitionSimpleLayer
		{
			return new TransitionSimpleLayer(switchHandler,target.width,target.height,0xFFFFFF,BlendMode.NORMAL);
		}
		/**变亮过渡渐变 */
		public static function add(switchHandler:*,target:DisplayObject):TransitionSimpleLayer
		{
			return new TransitionSimpleLayer(switchHandler,target.width,target.height,0xFFFFFF,BlendMode.ADD);
		}
		/**变暗过渡渐变 */
		public static function subtract(switchHandler:*,target:DisplayObject):TransitionSimpleLayer
		{
			return new TransitionSimpleLayer(switchHandler,target.width,target.height,0xFFFFFF,BlendMode.SUBTRACT);
		}
	}
}