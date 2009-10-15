package ghostcat.display.viewport
{
    import flash.display.*;
    import flash.geom.Matrix;
    import flash.geom.Point;
    
    import ghostcat.display.GBase;
    import ghostcat.events.TickEvent;
    import ghostcat.parse.display.DrawParse;

	/**
	 * 错位分层并自动Tile内容，实时更新，适用于无差异的循环背景
	 *  
	 * @author flashyiyi
	 * 
	 */
    public class BackgroundLayer extends GBase
	{
        private var items:Array = [];
		
		private var _width:Number;
		private var _height:Number;
		
		private var _positionX:Number = 0;
		private var _positionY:Number = 0;

		/**
		 * 是否激活X轴的复制
		 */
		public var enabledTileX:Boolean;
		
		/**
		 * 是否激活Y轴的复制
		 */
		public var enabledTileY:Boolean;
		
		private var _autoMove:Point;
		
        public function BackgroundLayer(width:Number,height:Number,enabledTileX:Boolean = true,enabledTileY:Boolean = true)
		{
			this._width = width;
			this._height = height;
			this.enabledTileX = enabledTileX;
			this.enabledTileY = enabledTileY;
        }

		/**
		 * 自动移动
		 */
		public function get autoMove():Point
		{
			return _autoMove;
		}

		public function set autoMove(value:Point):void
		{
			_autoMove = value;
			if (value)
			{
				enabledTick = true;
			}
			else
			{
				enabledTick = false;
			}
		}
		/** @inheritDoc*/
		protected override function tickHandler(event:TickEvent) : void
		{
			if (_autoMove)
			{
				contentX += _autoMove.x * event.interval / 1000;
				contentY += _autoMove.y * event.interval / 1000;
			}
		}

		public function get contentX():Number
		{
			return _positionX;
		}
		
		public function set contentX(value:Number):void
		{
			_positionX = value;
			for (var i:int = 0;i < items.length;i++)
			{
				var item:Item = items[i] as Item;
				item.skin.x = (value / item.divider) % item.contentSize.x;
			};
		}
		
		public function get contentY():Number
		{
			return _positionY;
		}
		
		public function set contentY(value:Number):void
		{
			_positionY = value;
			for (var i:int = 0;i < items.length;i++)
			{
				var item:Item = items[i] as Item;
				item.skin.y = (value / item.divider) % item.contentSize.y;
			};
		}
		/** @inheritDoc*/
		public override function get width():Number
		{
			return _width;
		}
		
		public override function get height():Number
		{
			return _height;
		}
		
		 /**
		  * 添加层
		  * 
		  * @param skin	皮肤
		  * @param divider	移动速度比
		  * @param bitmap	是否缓存为位图
		  * 
		  */
		public function addLayer(skin:Class, divider:Number = 1.0,bitmap:Boolean = false):void
		{
			var layer:Sprite = new Sprite();
            var child:DisplayObject = new skin() as DisplayObject;
			var contentSize:Point = new Point(child.width,child.height);
			var lw:int = Math.ceil(width / child.width) + 2;
			var lh:int = Math.ceil(height / child.height) + 2;
			if (!enabledTileX)
				lw = 1;
			if (!enabledTileY)
				lh = 1;
			
			var item:Item = new Item(layer,contentSize,divider);
			items.push(item);
			
			if (bitmap)
			{
				item.bitmap = new DrawParse(child).createBitmapData();
				layer.graphics.beginBitmapFill(item.bitmap);
				layer.graphics.drawRect(-child.width,-child.height,child.width * lw,child.height * lh);
				layer.graphics.endFill();
			}
			else
			{
				for (var j:int = 0;j < lh;j++)
				{
					for (var i:int = 0;i < lw;i++)
					{
						child = new skin() as DisplayObject;
						child.x = i * child.width - child.width;
						child.y = j * child.height - child.height;
						layer.addChild(child);
					}
				}
			}
            addChild(layer);
        }
		/** @inheritDoc*/
		public override function destory() : void
		{
			for each (var i:Item in items)
			{
				if (i.bitmap)
					i.bitmap.dispose();
			}
		}

    }
}
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.geom.Point;

class Item
{
	public var skin:DisplayObject;
	public var contentSize:Point;
	public var divider:Number;
	public var bitmap:BitmapData;
	public function Item(skin:DisplayObject,contentSize:Point,divider:Number):void
	{
		this.skin = skin;
		this.contentSize = contentSize;
		this.divider = divider;
	}
}