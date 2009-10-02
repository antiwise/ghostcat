package ghostcat.ui.containers
{
	import flash.geom.Rectangle;
	
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.events.MovieEvent;
	import ghostcat.util.display.Geom;
	
	/**
	 * 动画窗口
	 * 
	 * 标签规则：窗口创建关闭显示隐藏时会跳到相应的动画标签内
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class GMovieClipPanel extends GMovieClip
	{
		public var fields:Object = {create:"create",normal:"normal",close:"close",show:"show",hide:"hide"};
		
		public function GMovieClipPanel(mc:*=null, replace:Boolean=true, fields:Object=null)
		{
			if (fields)
				this.fields = fields;
			
			super(mc, replace);
		}
		/** @inheritDoc*/
		protected override function init():void
		{
			super.init();
			setLabel(fields.create,1);
			queueLabel(fields.normal,-1);
		}
		
		public override function set enabled(v:Boolean) : void
		{
			this.mouseChildren = this.mouseEnabled = super.enabled = v;
		}
		
		/** @inheritDoc*/
		public override function set visible(v:Boolean):void
		{
			if (super.visible == v)
				return;
			
			if (v)
			{
				this.enabled = super.visible = true;
				setLabel(fields.show,1);
				queueLabel(fields.normal,-1);
			}
			else
			{
				setLabel(fields.hide,1);
				this.enabled = false;
				addEventListener(MovieEvent.MOVIE_END,hideMovieEndHandler);
			}
		}
		
		/**
		 * 关闭窗口 
		 * 
		 */
		public function close() : void
		{
			setLabel(fields.close,1);
			this.enabled = false;
			
			addEventListener(MovieEvent.MOVIE_END,closeMovieEndHandler);
		}
		
		private function closeMovieEndHandler(event:MovieEvent):void
		{
			removeEventListener(MovieEvent.MOVIE_END,closeMovieEndHandler);
			
			destory();
		}
		
		private function hideMovieEndHandler(event:MovieEvent):void
		{
			removeEventListener(MovieEvent.MOVIE_END,hideMovieEndHandler);
			
			super.visible = false;
		}
	}
}