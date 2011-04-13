package ghostcat.display.residual
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.util.Util;
	import ghostcat.util.display.MatrixUtil;
	
	/**
	 * 残影物体生成容器，将被应用在Sprite而不是Bitmap上
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class ResidualShapeScreen extends GBase
	{
		/**
		 * 需要应用的物品 
		 */
		public var children:Array = [];
		
		/**
		 * 渐隐速度 
		 */
		public var fadeSpeed:Number = 0.8;
		
		/**
		 * 位移速度 
		 */
		public var offest:Point;
		
		/**
		 * 全屏附加的颜色
		 */
		public var colorTransform:ColorTransform;
		
		public function ResidualShapeScreen()
		{
			this.enabledTick = true;
		}
		
		/**
		 * 增加一个应用的物品 
		 * @param v
		 * 
		 */
		public function addItem(v:DisplayObject):void
		{
			children.push(v);
		}
		
		/**
		 * 减少一个应用的物品 
		 * @param v
		 * 
		 */
		public function removeItem(v:DisplayObject):void
		{
			Util.remove(children,v);
		}
		
		protected override function updateDisplayList() : void
		{
			for each (var child:DisplayObject in children)
			{
				var bitmap:Bitmap = new DrawParse(child).createBitmap();
				addChild(bitmap);
				
				if (this.colorTransform)
					bitmap.transform.colorTransform = this.colorTransform;
				
				var m:Matrix = MatrixUtil.getMatrixAt(child,this);
				var rect:Rectangle = child.getBounds(child);
				m.translate(rect.x,rect.y);
				bitmap.transform.matrix = m;
			}
			
			for (var i:int = 0;i < numChildren;i++)
				fadeChild(getChildAt(i));
		
		}
		
		/**
		 * 渐消已经存在的屏幕对象
		 * @param child
		 * 
		 */
		protected function fadeChild(child:DisplayObject):void
		{
			child.alpha *= fadeSpeed;
			
			if (offest)
			{
				child.x += offest.x;
				child.y += offest.y;
			}
			
			if (child.alpha < 0.01)
				removeChild(child);
		}
	}
} 