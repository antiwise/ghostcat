package ghostcat.ui.containers
{
	import ghostcat.ui.scroll.GScrollPanel;
	
	/**
	 * 兼容性保留
	 * 
	 */
	public class GScrollPanel extends ghostcat.ui.scroll.GScrollPanel
	{
		public function GScrollPanel(skin:*,replace:Boolean = true,width:Number = NaN,height:Number = NaN,fields:Object = null)
		{
			super(skin,replace,width,height,fields);
		}
	}
}