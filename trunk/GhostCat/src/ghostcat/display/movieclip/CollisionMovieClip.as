package ghostcat.display.movieclip
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import ghostcat.display.viewport.Collision;
	import ghostcat.display.viewport.ICollisionClient;
	
	/**
	 * 支持不规则碰撞的动画显示对象
	 * 
	 * @author Administrator
	 * 
	 */
	public class CollisionMovieClip extends GMovieClip implements ICollisionClient
	{
		/**
		 * 碰撞检测块。这个属性指示的是图形的实体。
		 */		
		private var _collision:Collision
		
		public function CollisionMovieClip(skin:*=null, replace:Boolean=true)
		{
			super(skin,replace);
		
			_collision = new Collision(this);
		}
		/** @inheritDoc*/
		public function get collision():Collision
		{
			return _collision;
		}
		/** @inheritDoc*/
		public override function setContent(skin:*,replace:Boolean=true):void
		{
			super.setContent(skin,replace);
			collision.refresh();
		}
		/** @inheritDoc*/
		protected override function init():void
		{
			super.init();
			collision.refresh();
		}

	}
}