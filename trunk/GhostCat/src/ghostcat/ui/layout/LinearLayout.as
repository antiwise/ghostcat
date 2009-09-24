package ghostcat.ui.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.ui.UIConst;

	/**
	 * 线性布局
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class LinearLayout extends Layout
	{
		private var _type:String = UIConst.HORIZONTAL
		
		private var _horizontalGap:Number = 0;
		private var _verticalGap:Number = 0;
		
		private var _paddingLeft:Number = 0;
		private var _paddingTop:Number = 0;
		private var _paddingRight:Number = 0;
		private var _paddingBottom:Number = 0;
		
		
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
		/**
		 * 左边距
		 * @return 
		 * 
		 */
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}

		public function set paddingLeft(v:Number):void
		{
			_paddingLeft = v;
			invalidateLayout();
		}

		/**
		 * 上边距
		 * @return 
		 * 
		 */
		public function get paddingTop():Number
		{
			return _paddingTop;
		}

		public function set paddingTop(v:Number):void
		{
			_paddingTop = v;
			invalidateLayout();
		}

		/**
		 * 右边距
		 * @return 
		 * 
		 */
		public function get paddingRight():Number
		{
			return _paddingRight;
		}

		public function set paddingRight(v:Number):void
		{
			_paddingRight = v;
			invalidateLayout();
		}

		/**
		 * 下边距
		 * @return 
		 * 
		 */
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}

		public function set paddingBottom(v:Number):void
		{
			_paddingBottom = v;
			invalidateLayout();
		}
		
		public function LinearLayout(target:DisplayObjectContainer,isRoot:Boolean = false)
		{
			super(target,isRoot);
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
					LayoutUtil.metrics(obj,target,NaN,paddingTop,NaN,paddingBottom);
					if (prev)
						LayoutUtil.horizontal(obj,prev,target,horizontalGap);
					else
						LayoutUtil.metrics(obj,target,paddingLeft);
				}
				else if (type == UIConst.VERTICAL)
				{
					LayoutUtil.metrics(obj,target,paddingLeft,NaN,paddingRight,NaN);
					if (prev)
						LayoutUtil.vertical(obj,prev,target,verticalGap);
					else
						LayoutUtil.metrics(obj,target,NaN,paddingTop);
					
				}
				prev = obj;
			}
		}
	}
}