package org.ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	
	import org.ghostcat.util.ClassFactory;
	
	/**
	 * 横向滚动条
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GHScrollBar extends GScrollBar
	{
		[Embed(skinClass="org.ghostcat.skin.HScrollBarSkin")]
		private static const CursorGroupClass:Class;//这里不直接导入CursorGroup而用Embed中转只是为了正常生成ASDoc
		public static var defaultSkin:ClassFactory = new ClassFactory(CursorGroupClass);
		
		public function GHScrollBar(skin:DisplayObject=null, replace:Boolean=true)
		{
			if (!skin)
				skin = defaultSkin.newInstance();
			
			this.direction = 0;
			
			super(skin, replace);
			
		}
	}
}