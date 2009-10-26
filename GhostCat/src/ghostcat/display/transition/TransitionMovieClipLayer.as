package ghostcat.display.transition
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import ghostcat.debug.Debug;
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.display.movieclip.GMovieClipBase;
	import ghostcat.operation.MovieOper;
	import ghostcat.operation.Oper;
	import ghostcat.util.core.Handler;

	/**
	 * 过渡动画类，根据帧标签播放动画决定过渡形态
	 * 
	 * 当设置了wait属性后，将会一直重复播放这段动画，此时只能用continueFadeOut方法继续
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TransitionMovieClipLayer extends TransitionLayerBase
	{
		/**
		 * 动画对象
		 */
		public var mc:GMovieClipBase;
		
		/** @inheritDoc*/
		public override function createTo(container:DisplayObjectContainer):TransitionLayerBase
		{
			container.addChild(mc);
			return super.createTo(container);
		}
		
		/**
		 * 
		 * @param switchHandler	切换函数
		 * @param skin	动画
		 * @param fadeIn	进入时的帧标签
		 * @param fadeOut	退出时的帧标签
		 * @param wait	等待时的帧标签
		 * 
		 */
		public function TransitionMovieClipLayer(switchHandler:*,skin:*,fadeIn:String = null,fadeOut:String = null,wait:String=null)
		{
			if (skin is MovieClip)
				this.mc = new GMovieClip(skin);
			else if (skin is GMovieClipBase)
				this.mc = skin as GMovieClipBase;
			else
				Debug.error("skin参数必须是MovieClip,GMovieClipBase之一")
			
			var fadeInOper:Oper;
			var fadeOutOper:Oper;
			var waitOper:Oper;
			
			if (fadeIn)
				fadeInOper = new MovieOper(mc,fadeIn,1);
			if (fadeOut)
				fadeOutOper = new MovieOper(mc,fadeOut,1);
			if (wait)
				waitOper = new MovieOper(mc,wait,-1);
			
			super(switchHandler,fadeInOper,fadeOutOper,waitOper);
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (mc)
				mc.destory();
			
			super.destory();
		}
	}
}