package ghostcat.ui.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ghostcat.util.display.Geom;

	/**
	 * 圆形布局
	 * @author flashyiyi
	 * 
	 */
	public class EllipseLayout extends PaddingLayout
	{
		private var _centerChild:Boolean = true;
		private var _rotation:Number = 0;
		public function EllipseLayout(target:DisplayObjectContainer,isRoot:Boolean = false)
		{
			super(target,isRoot);
		}
		
		/**
		 * 是否以子对象的中心点为布局基准
		 * @return 
		 * 
		 */
		public function get centerChild():Boolean
		{
			return _centerChild;
		}

		public function set centerChild(v:Boolean):void
		{
			_centerChild = v;
		}

		/**
		 * 旋转角度（0-360）
		 * @return 
		 * 
		 */
		public function get rotation():Number
		{
			return _rotation;
		}

		public function set rotation(v:Number):void
		{
			_rotation = v;
		}

		/** @inheritDoc*/
		protected override function layoutChildren(x:Number, y:Number, w:Number, h:Number) : void
		{
			var rx:Number = (w - paddingLeft - paddingRight) / 2; 
			var ry:Number = (h - paddingTop - paddingBottom) / 2;
			var sx:Number = x + paddingLeft + rx;
			var sy:Number = y + paddingTop + ry;
			var len:int = target.numChildren;
			var br:Number = this.rotation / 180 * Math.PI;
			for (var i:int = 0;i < len;i++)
			{
				var obj:DisplayObject = target.getChildAt(i);
				var r:Number = i / len * Math.PI * 2 + br;
				var p:Point = new Point(sx + rx * Math.cos(r),sy + ry * Math.sin(r));
				if (centerChild)
				{
					Geom.moveCenterTo(obj,p);
				}
				else
				{
					obj.x = p.x;
					obj.y = p.y;
				}
			}
		}
	}
}