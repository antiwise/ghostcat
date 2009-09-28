package ghostcat.ui.layout
{
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.util.AbstractUtil;

	/**
	 * 封装部分关于padding的属性。此类为抽象类。 
	 * 
	 */
	public class PaddingLayout extends Layout
	{
		private var _paddingLeft:Number = 0;
		private var _paddingTop:Number = 0;
		private var _paddingRight:Number = 0;
		private var _paddingBottom:Number = 0;
		
		public function PaddingLayout(target:DisplayObjectContainer,isRoot:Boolean = false)
		{
			AbstractUtil.preventConstructor(this,PaddingLayout);
			super(target,isRoot);
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

	}
}