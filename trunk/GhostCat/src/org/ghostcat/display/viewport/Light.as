package org.ghostcat.display.viewport
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.ghostcat.display.GBase;
	import org.ghostcat.util.Geom;

	/**
	 * 场景灯光类
	 * 
	 * 能够对物品生成投影，而且投影还可以在Wall对象上偏转
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Light extends GBase
	{
		private var _radius:Number = 0;
		private var _color:uint = 0xFFFFFF;
		
		private var items:Array = [];
		private var walls:Array = [];
		
		public var lightSprite:Shape;
		public var maskSprite:Sprite;
		
		public function Light(radius:Number,color:uint=0xFFFFFF,alpha:Number=0.5)
		{
			this.lightSprite = new Shape();
			this.lightSprite.blendMode = BlendMode.SCREEN;
			this.addChild(lightSprite);
		
			this.maskSprite = new Sprite();
			this.maskSprite.blendMode = BlendMode.ERASE;
			this.addChild(maskSprite);
			
			this.blendMode = BlendMode.LAYER;
		
			this.radius = radius;
			this.color = color;
			this.alpha = alpha;
			
			this.mouseEnabled = this.mouseChildren = false;
		}
		
		
		public function get color():uint
		{
			return _color;
		}

		public function set color(v:uint):void
		{
			_color = v;
			invalidateSize();
		}

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(v:Number):void
		{
			_radius = v;
			invalidateSize();
		}
		
		protected override function updateSize():void
		{
			super.updateSize();
			var m:Matrix = new Matrix();
			m.createGradientBox(_radius*2,_radius*2,0,-_radius,-_radius);
			
			lightSprite.graphics.clear();
			lightSprite.graphics.beginGradientFill(GradientType.RADIAL,[_color,_color],[1,0],[122,255],m);
			lightSprite.graphics.drawCircle(0,0,_radius);
			lightSprite.graphics.endFill();
		}
		
		protected override function updateDisplayList() : void
		{
			var i:int;
			for (i = 0;i < items.length;i++)
			{
				var d:ShadowItem = items[i] as ShadowItem;
				d.pointTo(Geom.localToContent(new Point(),d.item,this));
			} 
		}
		
		public function addWall(v:Wall):void
		{
			walls.push(v);
		}
		
		public function addItem(v:DisplayObject):void
		{
			var item:ShadowItem = new ShadowItem(v,this);
			
			items.push(item);
			maskSprite.addChild(item.shadow);
		}
		
		public override function destory() : void
		{
			super.destory();
			
			for (var i:int = 0;i<items.length;i++)
			{
				var item:ShadowItem = items[i] as ShadowItem;
				item.destory();
			}
		}

	}
}
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Bitmap;
import org.ghostcat.bitmap.BitmapUtil;
import flash.geom.Point;
import org.ghostcat.util.Geom;
import flash.display.DisplayObjectContainer;
import flash.geom.Matrix;
import flash.display.Sprite;
import flash.geom.Rectangle;
import org.ghostcat.display.viewport.Light;
import flash.filters.BlurFilter;
import org.ghostcat.events.GEvent;

class ShadowItem
{
	public var item:DisplayObject;
	public var shadow:Sprite;
	public var shadowBitmap:Bitmap;
	public var parent:Light;
	public function ShadowItem(item:DisplayObject,parent:Light):void
	{
		this.item = item;
		this.parent = parent;
		this.shadow = new Sprite();
		this.shadowBitmap = new Bitmap();
		this.shadow.addChild(this.shadowBitmap);
		
		render();
		
		item.addEventListener(GEvent.UPDATE_COMPLETE,renderHandler);
		
	}
	private function renderHandler(event:GEvent):void
	{
		render();
	}
	public function render():void
	{
		if (this.shadowBitmap.bitmapData)
			this.shadowBitmap.bitmapData.dispose();
	
		var rect:Rectangle = item.getBounds(item);
		this.shadowBitmap.bitmapData = BitmapUtil.drawToBitmap(item);
		this.shadowBitmap.x = rect.x;
		this.shadowBitmap.y = rect.y;
		
		updateShape();
	}
	public function updateShape():void
	{
		var p:Point = Geom.localToContent(new Point(),item,parent);
		shadow.scaleX = item.scaleX;
		shadow.scaleY = item.scaleY;
		shadow.x = p.x;
		shadow.y = p.y;
	}
	public function pointTo(p:Point):void
	{
		updateShape();
		
		var angle:Number = Math.atan2(p.y,p.x);
		var len:Number = p.length;
		shadow.rotation = angle / Math.PI * 180 + 90;
		shadow.scaleY = len / item.height;
		shadow.alpha = 1 - len / parent.radius;
		shadow.filters = [new BlurFilter(shadow.alpha*10,shadow.alpha*10)]
	}
	
	public function destory():void
	{
		if (shadowBitmap)
		{
			shadowBitmap.parent.removeChild(shadowBitmap);
			shadowBitmap.bitmapData.dispose();
			shadowBitmap = null;
		}
		parent.maskSprite.removeChild(this.shadow);
		
		item.removeEventListener(GEvent.UPDATE_COMPLETE,renderHandler);
	}
}