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
	public class TransitionFadeToLayer extends TransitionDisplayLayer
	{
		public function TransitionFadeToLayer(switchHandler:Handler,target:DisplayObject,fadeOut:int = 1000, wait:Boolean=false,easeIn:Function = null, easeOut:Function = null)
		{
			var bitmap:Bitmap = new DrawParse(target).createBitmap();
			
			super(switchHandler,bitmap,0,fadeOut,wait,easeIn,easeOut);
			bitmap.alpha = 1.0;
		}
	}
}