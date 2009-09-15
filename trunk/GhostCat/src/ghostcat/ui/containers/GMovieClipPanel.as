package ghostcat.ui.containers
{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.events.MovieEvent;
	import ghostcat.util.Geom;
	
	public class GMovieClipPanel extends GMovieClip
	{
		public var fields:Object = {create:"create",close:"close",show:"show",hide:"hide"};
		
		/**
		 * 是否将注册点移动到屏幕中央
		 */
		public var centerLayout:Boolean = true;
		
		public function GMovieClipPanel(mc:MovieClip=null, replace:Boolean=true, centerLayout:Boolean = true, fields:Object=null)
		{
			this.centerLayout = centerLayout;
			
			if (fields)
				this.fields = fields;
			
			super(mc, replace);
		}
		
		protected override function init():void
		{
			super.init();
			setLabel(fields.create,1);
		
			if (centerLayout)
			{
				var pRect:Rectangle = Geom.getRect(parent,parent);
				this.x = pRect.x + pRect.width / 2;
				this.y = pRect.y + pRect.height / 2;
			}
		}
		
		public override function set visible(v:Boolean):void
		{
			if (super.visible == v)
				return;
			
			super.visible = v;
			
			if (v)
				setLabel(fields.show,1);
			else
				setLabel(fields.hide,1);
		}
		
		public function close() : void
		{
			setLabel(fields.close,1);
			
			addEventListener(MovieEvent.MOVIE_END,closeMovieEndHandler);
			addEventListener(MovieEvent.MOVIE_ERROR,closeMovieEndHandler);
		}
		
		private function closeMovieEndHandler(event:MovieEvent):void
		{
			removeEventListener(MovieEvent.MOVIE_END,closeMovieEndHandler);
			removeEventListener(MovieEvent.MOVIE_ERROR,closeMovieEndHandler);
			
			destory();
		}
	}
}