package ghostcat.game.layer
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import ghostcat.community.sort.DepthSortUtil;
	import ghostcat.display.bitmap.IBitmapDataDrawer;
	import ghostcat.events.TickEvent;
	import ghostcat.game.layer.camera.ICamera;
	import ghostcat.game.layer.collision.ICollisionManager;
	import ghostcat.game.layer.position.IPositionManager;
	import ghostcat.game.layer.sort.ISortManager;
	import ghostcat.game.layer.sort.SortPriorityManager;
	import ghostcat.game.layer.sort.SortYManager;
	import ghostcat.util.Tick;
	import ghostcat.util.Util;
	
	public class GameLayer extends Sprite implements IBitmapDataDrawer
	{
		public var isBitmapEngine:Boolean;
		
		public var children:Array = [];
		public var childrenDict:Dictionary = new Dictionary(true);
		public var childrenInScreen:Array = [];
		public var childrenInScreenDict:Dictionary = new Dictionary(true);
		
		public var camera:ICamera;
		public var collision:ICollisionManager;
		public var position:IPositionManager;
		public var sort:ISortManager;
		public function GameLayer()
		{
			super();
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
		}
		
		public function destory():void
		{
			Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
		}
		
		public function addObject(v:*):void
		{
			if (!isBitmapEngine && v is DisplayObject)
				this.addChild(DisplayObject(v));
			
			children.push(v);
			childrenDict[v] = true;
			childrenInScreen.push(v);
			childrenInScreenDict[v] = true;
		}
		
		public function removeObject(v:*):void
		{
			if (!isBitmapEngine && v is DisplayObject)
				this.removeChild(DisplayObject(v));
			
			var index:int = children.indexOf(v);
			if (index != -1)
				children.splice(index, 1);
			delete childrenDict[v];
			
			index = childrenInScreen.indexOf(v);
			if (index != -1)
				childrenInScreen.splice(index, 1);
			delete childrenInScreenDict[v];
		}
		
		public function setObjectPosition(obj:DisplayObject,p:Point):void
		{
			if (position)
				p = position.transform(p);
			
			obj.x = p.x;
			obj.y = p.y;
		}
		
		public function getObjectPosition(obj:DisplayObject):Point
		{
			var p:Point = new Point(obj.x,obj.y);
			if (position)
				p = position.untransform(p);
			
			return p;
		}
		
		public function drawToBitmapData(target:BitmapData,offest:Point):void
		{
			if (isBitmapEngine)
			{
				for each (var child:IBitmapDataDrawer in this.childrenInScreen)
				{
					if (child)
						child.drawToBitmapData(target,new Point(this.x + offest.x,this.y + offest.y));
				}
			}
		}
		
		public function getBitmapUnderMouse(mouseX:Number,mouseY:Number):Array
		{
			var result:Array = [];
			if (isBitmapEngine)
			{
				for each (var child:IBitmapDataDrawer in this.childrenInScreen)
				{
					if (child)
					{
						var list:Array = child.getBitmapUnderMouse(mouseX,mouseY);
						if (list)
							result.push.apply(null,list);
					}
				}
			}
			return result;
		}
		
		protected function tickHandler(event:TickEvent):void
		{
			if (camera)
				camera.render();
			
			if (sort)
				sort.sortAll();
			
			if (collision)
				collision.collideAll();
		}
		
		
	}
}