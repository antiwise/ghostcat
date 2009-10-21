package ghostcat.display.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import ghostcat.community.sort.SortAllManager;
	import ghostcat.display.GNoScale;
	import ghostcat.util.Util;
	import ghostcat.util.display.MatrixUtil;
	
	/**
	 * 位图高速缓存，适用于同屏大量活动对象的情景
	 * 
	 * MODE_SRPITE 普通渲染方式，作为对比组，
	 * 当物体不动时效率很高，但大量物体运动时渲染速度较慢
	 * 
	 * MODE_BITMAP 采用copyPixels像素的方式将位图复制到一个Bitmap上，
	 * 无论物体是否运动速度都一样，因此在大量物体运动时效率较高，但只有少量物品运动则相对较低
	 * 
	 * MODE_SHAPE 采用beginBitmapFill方法将位图绘制到一个Shape上，
	 * 这种方法在FP9时很慢，但在FP10内，渲染数据源为同一个位图时，比同等情况的copyPixels快很多，而且支持Matrix缩放
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapScreen extends GNoScale
	{
		/**
		 * FLASH默认渲染，对比组
		 */
		public static const MODE_SPRITE:String = "sprite";
		/**
		 * 采用copyPixel处理
		 */
		public static const MODE_BITMAP:String = "bitmap";
		/**
		 * 采用beginBitmapFill处理
		 */
		public static const MODE_SHAPE:String = "shape";
		
		private var _mode:String = MODE_BITMAP;
		
		private var sort:SortAllManager;//用于Sprite的排序器
		
		/**
		 * 绘制全局偏移量
		 */
		public var drawOffest:Point = new Point(0,0);
		
		/**
		 * 是否激活模拟鼠标事件
		 */
		public var enabledMouseCheck:Boolean = true;
		
		private var mouseDown:Boolean = false;//鼠标是否按下 
		private var isMouseOver:Dictionary = new Dictionary();//记录子对象的鼠标触发状态
		private var isMouseDown:Dictionary = new Dictionary();//记录子对象的鼠标按下状态
		private var mouseOverList:Array;//位于鼠标上的对象
		
		public function get mode():String
		{
			return _mode;
		}
		
		public function set mode(value:String):void
		{
			if (content is Bitmap)
				(content as Bitmap).bitmapData.dispose();
			
			_mode = value;
			switch (value)
			{
				case MODE_SPRITE:
					setContent(new Sprite());
					break;
				case MODE_BITMAP:
					setContent(new Bitmap(new BitmapData(width,height,transparent,backgroundColor)));
					break;
				case MODE_SHAPE:
					setContent(new Shape());
					break;
			}
			
			if (value == MODE_SPRITE)
			{
				sort = new SortAllManager(SortAllManager.SORT_Y,content as Sprite);
				sort.addAll(children);
			}
			else
			{
				if (sort)
				{
					sort.removeAll();
					sort.container = null;
					sort = null;
				}
			}
		}
		
		/**
		 * 背景色
		 */
		public var backgroundColor:uint;
		
		/**
		 * 是否使用透明通道
		 */
		public var transparent:Boolean;
		
		/**
		 * 是否每次重绘（每次重绘将会忽略所有特效）
		 */
		public var redraw:Boolean = true;
		
		/**
		 * 需要应用的物品
		 */
		public var children:Array = [];
		
		/**
		 * 物品绘制时附加的颜色
		 */
		public var itemColorTransform:ColorTransform;
		
		/**
		 * 排序依据字段（数组或者函数）
		 */
		public var sortFields:*;
		
		/**
		 * 激活Y轴排序
		 * 
		 */
		public function enabledSortY():void
		{
			sortFields = SortAllManager.SORT_Y;
		}
		
		/**
		 * 激活45度排序 
		 * 
		 */
		public function enabledSort45():void
		{
			sortFields = SortAllManager.SORT_45;
		}
		
		/**
		 * 
		 * @param width	宽度
		 * @param height	高度
		 * @param transparent	是否使用透明通道
		 * @param backgroundColor	背景色
		 * 
		 */

		public function BitmapScreen(width:Number,height:Number,transparent:Boolean = true,backgroundColor:uint = 0xFFFFFF):void
		{
			super();
			
			this.backgroundColor = backgroundColor;
			this.transparent = transparent;
			this.width = width;
			this.height = height;
			
			this.enabledTick = true;
			this.enabledAutoSize = false;
			
			this.mode = MODE_BITMAP;
		}
		
		protected override function init() : void
		{
			super.init();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}
		
		/**
		 * 添加
		 * @param obj
		 * 
		 */
		public function addObject(obj:*):*
		{
			children.push(obj);
			if (mode == MODE_SPRITE && obj is DisplayObject)
				(content as Sprite).addChild(obj as DisplayObject)
			return obj;
		}
		
		/**
		 * 添加到某索引
		 * @param obj
		 * 
		 */
		public function addObjectAt(obj:*,index:int):*
		{
			children.splice(index,0,obj);
			if (mode == MODE_SPRITE && obj is DisplayObject)
				(content as Sprite).addChild(obj as DisplayObject)
			return obj;
		}
		
		/**
		 * 删除 
		 * @param obj
		 * 
		 */
		public function removeObject(obj:*):*
		{
			Util.remove(children,obj);
			
			delete isMouseOver[obj];
			
			if (mode == MODE_SPRITE && obj is DisplayObject)
				(content as Sprite).removeChild(obj as DisplayObject)
					
			return obj;
		}
		
		/** @inheritDoc*/
		public override function addChild(child:DisplayObject) : DisplayObject
		{
			return addObject(child);
		}
		
		/** @inheritDoc*/
		public override function addChildAt(child:DisplayObject,index:int) : DisplayObject
		{
			return addObjectAt(child,index);
		}
		
		/** @inheritDoc*/
		public override function removeChild(child:DisplayObject) : DisplayObject
		{
			return removeObject(child);
		}
		
		/** @inheritDoc*/
		protected override function updateSize() : void
		{
			super.updateSize();
			if (mode == MODE_BITMAP)
			{
				var newBitmapData:BitmapData = new BitmapData(width,height,transparent,backgroundColor);
				var bitmapData:BitmapData = (content as Bitmap).bitmapData;
				if (bitmapData)
				{
					newBitmapData.copyPixels(bitmapData,bitmapData.rect,new Point());
					bitmapData.dispose();
				}
				(content as Bitmap).bitmapData = newBitmapData;
			}
		}
		
		/** @inheritDoc*/
		protected override function updateDisplayList() : void
		{
			if (sortFields)
			{
				if (mode == MODE_SPRITE)
					sort.calculateAll(false);
				else
					children.sortOn(sortFields, [Array.NUMERIC]);
			}
			
			mouseOverList = [];
			
			if (mode == MODE_BITMAP)
			{
				var bitmapData:BitmapData = (content as Bitmap).bitmapData;
				
				if (redraw)
					bitmapData.fillRect(bitmapData.rect,backgroundColor)
				
				bitmapData.lock();
				for each (var obj:* in children)
					drawChild(obj);
				
				bitmapData.unlock();
			}
			else if (mode == MODE_SHAPE)
			{
				if (redraw)
					(content as Shape).graphics.clear();
				
				for each (obj in children)
					drawChild(obj);		
			}
			else if (mode == MODE_SPRITE)
			{
				for each (obj in children)
					drawChild(obj);	
			}
			
			//处理鼠标事件
			if (enabledMouseCheck)
			{
				for each (obj in mouseOverList)
				{
					if (isMouseOver[obj]!=true)
					{
						isMouseOver[obj] = true;
						obj.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
						obj.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
					}
					
					if (mouseDown && isMouseDown[obj]!=true)
					{
						isMouseDown[obj] = true;
						obj.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
					}
				}
				
				for (obj in isMouseOver)
				{
					if (mouseOverList.indexOf(obj) == -1)
					{
						delete isMouseOver[obj];
						obj.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
						obj.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
					}
				}
				if (!mouseDown)
				{
					for (obj in isMouseDown)
					{
						delete isMouseDown[obj];
						obj.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
					}
				}
			}
			
			super.updateDisplayList();
		}
		
		/**
		 * 绘制物品
		 * @param obj
		 * 
		 */
		protected function drawChild(obj:*):void
		{
			var source:BitmapData;
			//绘制
			var m:Matrix;
			if (mode == MODE_BITMAP)
			{
				var bitmapData:BitmapData = (content as Bitmap).bitmapData;
				if (obj is IBitmapDataDrawer)
				{
					(obj as IBitmapDataDrawer).drawToBitmapData(bitmapData,drawOffest);
				}
				else if (obj is DisplayObject)
				{
					m = MatrixUtil.getMatrixBetween(obj as DisplayObject,this,this.parent);
					if (drawOffest)
						m.translate(drawOffest.x,drawOffest.y);
					bitmapData.draw(obj as DisplayObject,m,itemColorTransform);
				}
			}
			else if (mode == MODE_SHAPE)
			{
				if (obj is IBitmapDataDrawer)
					(obj as IBitmapDataDrawer).drawToShape((content as Shape).graphics,drawOffest);
			}
			else if (mode == MODE_SPRITE)
			{
				if (obj is DisplayObject && (obj as DisplayObject).parent != content)
					(content as Sprite).addChild(obj as DisplayObject);
			}
			
			//判断是否在鼠标下
			if (enabledMouseCheck)
			{
				if (obj is IBitmapDataDrawer)
				{
					var mouseObjs:Array = (obj as IBitmapDataDrawer).getBitmapUnderMouse(mouseX + drawOffest.x,mouseY + drawOffest.y);
					if (mouseObjs)
						mouseOverList = mouseOverList.concat(mouseObjs);
				}
			}
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			this.mouseDown = true;
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			this.mouseDown = false;
		}
		
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			
			if (content is Bitmap)
			{
				(content as Bitmap).bitmapData.dispose();
				removeChild(content);
			}
			super.destory();
		}
	}
}