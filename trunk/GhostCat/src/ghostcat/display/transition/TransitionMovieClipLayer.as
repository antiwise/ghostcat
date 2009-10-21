package ghostcat.display.transition
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.operation.MovieOper;
	import ghostcat.operation.Oper;

	/**
	 * 过渡动画类，根据帧标签播放动画决定过渡形态
	 * 
	 * 当设置了wait属性后，将会一直重复播放这段动画，此时只能用continueFadeOut方法继续
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TransitionMovieClipLayer extends TransitionLayer
	{
		/**
		 * 动画对象
		 */
		public var mc:GMovieClip;
		
		/** @inheritDoc*/
		public override function createTo(container:DisplayObjectContainer):TransitionLayer
		{
			container.addChild(mc);
			return super.createTo(container);
		}
		
		public function TransitionMovieClipLayer(switchHandler:Function,skin:MovieClip,fadeIn:String = null,fadeOut:String = null,wait:String=null)
		{
			mc = new GMovieClip(skin);
			
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