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
		
		/**
		 * 是否将注册点移动到屏幕中央
		 */
		public var centerLayout:Boolean = true;
		
		public function GMovieClipPanel(mc:*=null, replace:Boolean=true, centerLayout:Boolean = true, fields:Object=null)
		{
			this.centerLayout = centerLayout;
			
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
		
			if (centerLayout)
			{
				var pRect:Rectangle = Geom.getRect(parent,parent);
				this.x = pRect.x + pRect.width / 2;
				this.y = pRect.y + pRect.height / 2;
			}
		}
		/** @inheritDoc*/
		public override function set visible(v:Boolean):void
		{
			if (super.visible == v)
				return;
			
			if (v)
			{
				super.visible = true;
			
				setLabel(fields.show,1);
				queueLabel(fields.normal,-1);
			}
			else
			{
				setLabel(fields.hide,1);
				
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