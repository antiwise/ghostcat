package ghostcat.ui.controls
{
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.skin.ButtonSkin;
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.core.ClassFactory;
	
	/**
	 * 动画按钮
	 * 
	 * 标签规则：为一整动画，up,over,down,disabled,selectedUp,selectedOver,selectedDown,selectedDisabled是按钮的八个状态，
	 * 状态间的过滤为两个标签中间加-。比如up和over的过滤即为up-over
	 * 
	 * 皮肤同时也会当作文本框再次处理一次
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GButton extends GButtonBase
	{
		public static var defaultSkin:* = ButtonSkin
		
		public function GButton(skin:*=null, replace:Boolean=true, separateTextField:Boolean = false, textPadding:Padding=null,autoRefreshLabelField:Boolean = true)
		{
			if (!skin)
				skin = GButton.defaultSkin;
			
			super(skin, replace,separateTextField,textPadding,autoRefreshLabelField);
		}
		/** @inheritDoc*/
		protected override function createMovieClip() : void
		{
			movie = new GMovieClip(content,false);
		}
	}
}