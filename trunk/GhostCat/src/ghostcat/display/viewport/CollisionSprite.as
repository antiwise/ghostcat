package ghostcat.display.viewport
{
	import flash.display.DisplayObject;
	
	import ghostcat.display.GBase;
	
	/**
	 * 支持不规则碰撞的显示对象
	 * 
	 * @author Administrator
	 * 
	 */
	public class CollisionSprite extends GBase implements ICollisionClient
	{
		/**
		 * 碰撞检测块。这个属性指示的是图形的实体。
		 */		
		private var _collision:Collision;
		
		public function CollisionSprite(skin:*=null, replace:Boolean=true)
		{
			_collision = new Collision(this);
			super(skin,replace);
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