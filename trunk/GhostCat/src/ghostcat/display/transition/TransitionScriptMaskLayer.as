package ghostcat.display.transition
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import ghostcat.display.movieclip.GScriptMovieClip;
	
	/**
	 * 使用代码动画作为遮罩实现的过渡
	 * 
	 * 当设置了wait属性后，将会暂停，此时只能用continueFadeOut方法继续
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TransitionScriptMaskLayer extends TransitionMaskLayer
	{
		public function TransitionScriptMaskLayer(switchHandler:*, target:DisplayObject, handler:*, rect:Rectangle = null, fadeOut:int=1000, wait:Boolean=false)
		{
			super(switchHandler, target, new GScriptMovieClip(handler,rect ? rect : target.getBounds(target.parent)), null, fadeOut, wait);
		}
	}
}