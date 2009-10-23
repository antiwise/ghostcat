package ghostcat.display.transition
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	import ghostcat.parse.display.DrawParse;

	/**
	 * 两个场景透明度直接渐变
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TransitionFadeToLayer extends TransitionDisplayLayer
	{
		public function TransitionFadeToLayer(switchHandler:Function,target:DisplayObject,fadeOut:String = null,fadeOutDuration:int = 1000, wait:Boolean=false,easeIn:Function = null, easeOut:Function = null)
		{
			var bitmap:Bitmap = new DrawParse(target).createBitmap();
			
			super(switchHandler,bitmap,null,0,fadeOut,fadeOutDuration,wait,easeIn,easeOut);
			bitmap.alpha = 1.0;
		}
	}
}