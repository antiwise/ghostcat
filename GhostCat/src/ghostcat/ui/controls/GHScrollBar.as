package ghostcat.ui.controls
{
	import ghostcat.skin.HScrollBarSkin;
	import ghostcat.ui.UIConst;
	import ghostcat.util.core.ClassFactory;
	
	/**
	 * 横向滚动条
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GHScrollBar extends GScrollBar
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(HScrollBarSkin);
		
		public function GHScrollBar(skin:*=null, replace:Boolean=true)
		{
			if (!skin)
				skin = defaultSkin;
			
			super(skin, replace);
		
			this.direction = UIConst.HORIZONTAL;
		}
	}
}