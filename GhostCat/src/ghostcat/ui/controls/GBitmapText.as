package ghostcat.ui.controls
{
	import flash.geom.Point;
	
	/**
	 * 位图文字，能够拥有更多特效方法
	 * @author flashyiyi
	 * 
	 */
	public class GBitmapText extends GText
	{
		public function GBitmapText(skin:*=null, replace:Boolean=true, separateTextField:Boolean=false, textPos:Point=null)
		{
			super(skin, replace, separateTextField, textPos);
			
			asBitmap = true;
		}
	}
}