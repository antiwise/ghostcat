package ghostcat.ui.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.UIConst;
	import ghostcat.util.display.Geom;

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
		
		private var _horizontalAlign:String = "";
		private var _verticalAlign:String = "";
		
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
		protected override function measureChildren(width:Number = NaN,height:Number = NaN):void
		{
			var width:Number = 0;
			var height:Number = 0;
			for (var i:int = 0;i < target.numChildren;i++)
			{
				var obj:DisplayObject = target.getChildAt(i);
				var rect:Rectangle = Geom.getRect(obj);
				if (type == UIConst.HORIZONTAL)
				{
					if (i != 0)
						width += horizontalGap;
					width += rect.width;
					height = Math.max(height,rect.height);
				}
				else if (type == UIConst.VERTICAL)
				{
					if (i != 0)
						height += verticalGap;
					height += rect.height;
					width = Math.max(width,rect.width);
				}
				else if (type == UIConst.TILE)
				{
					//暂定
					width = Math.max(width,rect.right);
					height = Math.max(height,rect.bottom);
				}
			}
			
			super.measureChildren(width,height);
		}
		
		/** @inheritDoc*/
		protected override function layoutChildren(x:Number, y:Number, w:Number, h:Number) : void
		{
			var curY:Number = 0;
			var maxH:Number = 0;
			var prev:DisplayObject;
			for (var i:int = 0;i < target.numChildren;i++)
			{
				var obj:DisplayObject = target.getChildAt(i);
				
				if (type == UIConst.HORIZONTAL)
				{
					LayoutUtil.silder(obj,target,null,verticalAlign);
					if (i == 0)
						LayoutUtil.silder(obj,target,UIConst.LEFT);
					else
						LayoutUtil.horizontal(obj,prev,target,horizontalGap);
				}
				else if (type == UIConst.VERTICAL)
				{
					LayoutUtil.silder(obj,target,horizontalAlign);
					if (i == 0)
						LayoutUtil.silder(obj,target,null,UIConst.TOP);
					else
						LayoutUtil.vertical(obj,prev,target,verticalGap);
					
				}
				else if (type == UIConst.TILE)
				{
					maxH = Math.max(maxH,obj.height);
					if (i == 0)
						Geom.moveTopLeftTo(obj,new Point());
					else
					{
						LayoutUtil.horizontal(obj,prev,target,horizontalGap);
						var rect:Rectangle = Geom.getRect(obj);
						if (rect.right > x + w)
						{
							curY += maxH + verticalGap;
							maxH = 0;
							Geom.moveTopLeftTo(obj,new Point(0,curY));
						}
						else
						{
							Geom.moveTopLeftTo(obj,new Point(rect.x,curY));
						}
					}
				}
				prev = obj;
			}
		}
	}
}