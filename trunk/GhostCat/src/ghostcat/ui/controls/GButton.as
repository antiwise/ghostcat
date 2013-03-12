package ghostcat.ui.controls
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	
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
		static public var defaultSkin:* = ButtonSkin;
		
		/**
		 * 
		 * @param skin	皮肤
		 * @param replace	是否替换
		 * @param separateTextField	是否将原本的文本框内容提出到contant外（历史原因一般保持默认值）
		 * @param textPadding	设置文本自适应位置（历史原因一般保持默认值）
		 * @param autoRefreshLabelField	是否创建Label的TextField，为真时有可能会影响皮肤内部的GText对象。
		 * 
		 */
		public function GButton(skin:*=null, replace:Boolean=true, separateTextField:Boolean = false, textPadding:Padding=null,autoRefreshLabelField:Boolean = true)
		{
			if (!skin)
				skin = GButton.defaultSkin;
			
			super(skin, replace,separateTextField,textPadding,autoRefreshLabelField);
		}
		/** @inheritDoc*/
		protected override function createMovieClip() : void
		{
			if (movie)
				movie.destory();
			
			movie = new GMovieClip(content,false,!enabledLabelMovie);
			
			if (useDefaultLabels && (content is MovieClip && (content as MovieClip).totalFrames > 1) && !(movie.labels && movie.labels.length))
			{
				if ((content as MovieClip).totalFrames == 3)
					movie.labels = defaultLabels_3frame;
				else
					movie.labels = defaultLabels;
			}
		}
	}
}