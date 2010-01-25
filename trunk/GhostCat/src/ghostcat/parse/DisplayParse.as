package ghostcat.parse
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * 其实这东西就类似flash10的graphicData，将绘图操作对象化了。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class DisplayParse extends Parse
	{
		/** @inheritDoc*/
		public override function parse(target:*):void
		{
			super.parse(target);
			
			if (target is DisplayObject)
				parseDisplay(target as DisplayObject);
			if (target is DisplayObjectContainer)
				parseContainer(target as DisplayObjectContainer);
			if (target is Graphics)
				parseGraphics(target as Graphics);
			if (target is BitmapData)
				parseBitmapData(target as BitmapData);
			
			var graphics:Graphics = (target && target.hasOwnProperty("graphics"))?target["graphics"] as Graphics : null;
			if (graphics)
				parseGraphics(graphics);
		}
		
		/**
		 * 更新Graphics
		 * @param target
		 * 
		 */
		public function parseGraphics(target:Graphics):void
		{
			
		}
		
		/**
		 * 更新位图
		 * @param target
		 * 
		 */
		public function parseBitmapData(target:BitmapData):void
		{
			
		}
		
		/**
		 * 更新容器属性
		 * @param target
		 * 
		 */
		public function parseContainer(target:DisplayObjectContainer):void
		{
			
		}
		
		/**
		 * 更新显示
		 * @param target
		 * 
		 */
		public function parseDisplay(target:DisplayObject):void
		{
			
		}
		
		/**
		 * 创建Sprite
		 * 
		 * @param para
		 * @return 
		 * 
		 */
		public function createSprite():Sprite
		{
			var s:Sprite = new Sprite();
			parse(s);
			return s;
		}
		
		/**
		 * 创建Shape
		 * 
		 * @param para
		 * @return 
		 * 
		 */
		public function createShape():Shape
		{
			var s:Shape = new Shape();
			parse(s);
			return s;
		}
		
		/**
		 * 创建组
		 * 
		 * @param para
		 * @return 
		 * 
		 */
		public static function create(para:Array):DisplayParse
		{
			var p:DisplayParse = new DisplayParse();
			p.children = para;
			return p;
		}
		
		/**
		 * 创建Sprite
		 * 
		 * @param para
		 * @return 
		 * 
		 */
		public static function createSprite(para:Array):Sprite
		{
			var s:Sprite = new Sprite();
			create(para).parse(s);
			return s;
		}
		
		/**
		 * 创建Shape
		 * 
		 * @param para
		 * @return 
		 * 
		 */
		public static function createShape(para:Array):Shape
		{
			var s:Shape = new Shape();
			create(para).parse(s);
			return s;
		}
	}
}