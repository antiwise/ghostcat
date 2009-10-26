package ghostcat.display.transition
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	import ghostcat.parse.display.DrawParse;
	import ghostcat.util.core.Handler;

	/**
	 * 两个场景透明度直接渐变
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TransitionFadeLayer extends TransitionObjectLayer
	{
		public function TransitionFadeLayer(switchHandler:*,target:DisplayObject,fadeOut:int = 1000, wait:Boolean=false,easeOut:Function = null)
		{
			var bitmap:Bitmap = new DrawParse(target).createBitmap();
			
			super(switchHandler,bitmap,null,0,fadeOut,wait,null,easeOut);
			bitmap.alpha = 1.0;
		}
	}
}