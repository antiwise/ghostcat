package ghostcat.ui.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.containers.GView;

	/**
	 * 线性布局
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class LinearLayout extends PaddingLayout
	{
		private var _type:String = UIConst.HORIZONTAL
		
		private var _horizontalGap:Number = 0;
		private var _verticalGap:Number = 0;
		
		private var _horizontalAlign:String = UIConst.LEFT;
		private var _verticalAlign:String = UIConst.TOP;
		
		/**
		 * 横向对齐方式
		 * @return 
		 * 
		 */
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}

		public function set horizontalAlign(v:String):void
		{
			_horizontalAlign = v;
			invalidateLayout();
		}
		
		/**
		 * 纵向对齐方式
		 * @return 
		 * 
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}

		public function set verticalAlign(v:String):void
		{
			_verticalAlign = v;
			invalidateLayout();
		}

		/**
		 * 方向 
		 * @return 
		 * 
		 */
		public function get type():String
		{
			return _type;
		}

		public function set type(v:String):void
		{
			_type = v;
			invalidateLayout();
		}

		/**
		 * 横向间距 
		 * @return 
		 * 
		 */
		public function get horizontalGap():Number
		{
			return _horizontalGap;
		}

		public function set horizontalGap(v:Number):void
		{
			_horizontalGap = v;
			invalidateLayout();
		}

		/**
		 * 纵向间距
		 * @return 
		 * 
		 */
		public function get verticalGap():Number
		{
			return _verticalGap;
		}

		public function set verticalGap(v:Number):void
		{
			_verticalGap = v;
			invalidateLayout();
		}
		
		public function LinearLayout(target:DisplayObjectContainer=null,isRoot:Boolean = false)
		{
			super(target,isRoot);
		}
		
		/** @inheritDoc*/
		protected override function measureChildren():void
		{
			var width:Number = 0;
			var height:Number = 0;
			for (var i:int = 0;i < target.numChildren;i++)
			{
				var obj:DisplayObject = target.getChildAt(i);
				
				if (type == UIConst.HORIZONTAL)
				{
					width += obj.width;
					height = Math.max(height,obj.height);
				}
				else if (type == UIConst.VERTICAL)
				{
					height += obj.height;
					width = Math.max(width,obj.width);
				}
			}
			
			if (target.parent is GBase)
				(target.parent as GBase).setSize(width,height);//不知道为何设置大小并没有重新触发本身的layout
		}
		
		/** @inheritDoc*/
		protected override function layoutChildren(x:Number, y:Number, w:Number, h:Number) : void
		{
			var prev:DisplayObject;
			for (var i:int = 0;i < target.numChildren;i++)
			{
				var obj:DisplayObject = target.getChildAt(i);
				
				if (type == UIConst.HORIZONTAL)
				{
					LayoutUtil.silder(obj,target,horizontalAlign,verticalAlign);
					if (prev)
						LayoutUtil.horizontal(obj,prev,target,horizontalGap);
				}
				else if (type == UIConst.VERTICAL)
				{
					LayoutUtil.silder(obj,target,horizontalAlign,verticalAlign);
					if (prev)
						LayoutUtil.vertical(obj,prev,target,verticalGap);
					
				}
				prev = obj;
			}
		}
	}
}