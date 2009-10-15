package elex.game.g2d
{
    import elex.game.extend.RSLManager;
    
    import flash.display.*;
    import flash.geom.Point;
    import flash.utils.getDefinitionByName;

	/**
	 * 错位分层并自动Tile内容，实时更新，适用于无差异的循环背景
	 *  
	 * @author flashyiyi
	 * 
	 */
    public class BackgroundLayer extends Sprite
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

        public function BackgroundLayer(width:Number,height:Number,enabledTileX:Boolean = true,enabledTileY:Boolean = false):void
		{
			this._width = width;
			this._height = height;
			this.enabledTileX = enabledTileX;
			this.enabledTileY = enabledTileY;
        }

		public function get positionX():Number
		{
			return _positionX;
		}
		
		public function set positionX(value:Number):void
		{
			_positionX = value;
			for (var i:int = 0;i < items.length;i++)
			{
				var item:Item = items[i] as Item;
				item.skin.x = (x / item.divider.x) % item.contentSize.x;
			};
		}
		
		public function get positionY():Number
		{
			return _positionY;
		}
		
		public function set positionY(value:Number):void
		{
			_positionY = value;
			for (var i:int = 0;i < items.length;i++)
			{
				var item:Item = items[i] as Item;
				item.skin.y = (y / item.divider.y) % item.contentSize.y;
			};
		}
		
		public override function get width():Number
		{
			return _width;
		}
		
		public override function get height():Number
		{
			return _height;
		}
		
		/**
		 * 
		 * @param skin
		 * @param y
		 * @param divider
		 * 
		 */
        public function addLayer(skin:Class, position:Point = null, divider:Point = null):void
		{
			if (!position)
				position = new Point();
			
			if (!divider)
				divider = new Point(1,1);
			
            var layer:Sprite = new Sprite();
			layer.x = position.x;
			layer.y = position.y;
            var child:DisplayObject = new skin() as DisplayObject;
            var len:int = Math.ceil(width / child.width) + 1;
            for (var i:int = 0;i < len;i++)
			{
                child = new skin() as DisplayObject;
                child.x = i * child.width;
				layer.addChild(child);
            }
;			
            items.push(new Item(layer,position,divider));
            addChild(layer);
        }
		
		public function setPosition(x:Number = NaN,y:Number = NaN):void
		{
			if (!isNaN(x))
				positionX = x;
			
			if (!isNaN(y))
				positionY = y;
        }

    }
}
import flash.display.DisplayObject;
import flash.geom.Point;

class Item
{
	public var skin:DisplayObject;
	public var contentSize:Point;
	public var divider:Point;
	public function Item(skin:DisplayObject,contentSize:Point,divider:Point):void
	{
		this.skin = skin;
		this.contentSize = contentSize;
		this.divider = divider;
	}
}