package ghostcat.display.viewport
{
    import flash.display.*;
    import flash.geom.Point;
    
    import ghostcat.display.GNoScale;
    import ghostcat.events.TickEvent;
    import ghostcat.parse.display.DrawParse;
    import ghostcat.util.display.DisplayUtil;

	/**
	 * 错位分层并自动Tile内容，实时更新，适用于无差异的循环背景
	 *  
	 * @author flashyiyi
	 * 
	 */
    public class BackgroundLayer extends GNoScale
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
			this.setSize(width,height);
			
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
			enabledTick = (value != null);
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
				item.layer.x = (value * item.divider) % item.contentSize.x;
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
				item.layer.y = (value / item.divider) % item.contentSize.y;
			};
		}
		/** @inheritDoc*/
		protected override function updateSize() : void
		{
			super.updateSize();
			
			for each (var i:Item in items)
				render(i);
		}
		
		/**
		 * 添加层
		 * 
		 * @param skin	皮肤
		 * @param divider	移动速度比
		 * @param asBitmap	是否缓存为位图
		 * 
		 */
		public function addLayer(skin:Class, divider:Number = 1.0,asBitmap:Boolean = false):void
		{
			var layer:Sprite = new Sprite();
            var child:DisplayObject = new skin() as DisplayObject;
			var contentSize:Point = new Point(child.width,child.height);
			var item:Item = new Item(skin,layer,contentSize,divider,asBitmap);
			items.push(item);
			addChild(layer);
			
			render(item);
		};
		
		/**
		 * 渲染
		 * @param item
		 * 
		 */
		protected function render(item:Item):void
		{
			var lw:int = Math.ceil(width / item.contentSize.x) + 2;
			var lh:int = Math.ceil(height / item.contentSize.y) + 2;
			
			if (!enabledTileX)
				lw = 1;
			if (!enabledTileY)
				lh = 1;
			
			if (item.asBitmap)
			{
				if (item.bitmapData)
					item.bitmapData.dispose();
				
				var child:DisplayObject = new (item.skin)() as DisplayObject;
				item.bitmapData = new DrawParse(child).createBitmapData();
				item.layer.graphics.beginBitmapFill(item.bitmapData);
				item.layer.graphics.drawRect(-child.width,-child.height,child.width * lw,child.height * lh);
				item.layer.graphics.endFill();
			}
			else
			{
				DisplayUtil.removeAllChildren(item.layer);
				for (var j:int = 0;j < lh;j++)
				{
					for (var i:int = 0;i < lw;i++)
					{
						child = new (item.skin)() as DisplayObject;
						child.x = i * child.width - child.width;
						child.y = j * child.height - child.height;
						item.layer.addChild(child);
					}
				}
			}
        }
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			for each (var i:Item in items)
			{
				if (i.bitmapData)
					i.bitmapData.dispose();
			}
			super.destory();
		}

    }
}
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;

class Item
{
	public var skin:Class
	public var layer:Sprite;
	public var contentSize:Point;
	public var divider:Number;
	public var asBitmap:Boolean;
	public var bitmapData:BitmapData;
	public function Item(skin:Class,layer:Sprite,contentSize:Point,divider:Number,asBitmap:Boolean):void
	{
		this.skin = skin;
		this.layer = layer;
		this.contentSize = contentSize;
		this.divider = divider;
		this.asBitmap = asBitmap;
	}
}