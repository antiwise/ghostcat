package org.ghostcat.display.viewport
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.ghostcat.util.CallLater;
	import org.ghostcat.util.Geom;

	/**
	 * 场景灯光类
	 * 
	 * 能够对物品生成投影，而且投影还可以在Wall对象上偏转
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Light extends Sprite
	{
		private var _radius:Number = 0;
		private var _color:uint = 0xFFFFFF;
		
		private var items:Array = [];
		private var walls:Array = [];
		
		private var lightSprite:Shape;
		private var maskSprite:Sprite;
		
		public function Light(radius:Number,color:uint=0xFFFFFF,alpha:Number=0.5)
		{
			this.lightSprite = new Shape();
			this.lightSprite.blendMode = BlendMode.LIGHTEN;
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
			CallLater.callLater(render,null,true);
		}

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(v:Number):void
		{
			_radius = v;
			CallLater.callLater(render,null,true);
		}
		
		protected function render():void
		{
			var m:Matrix = new Matrix();
			m.createGradientBox(_radius*2,_radius*2,0,-_radius,-_radius);
			
			lightSprite.graphics.clear();
			lightSprite.graphics.beginGradientFill(GradientType.RADIAL,[_color,_color],[1,0],[200,255],m);
			lightSprite.graphics.drawCircle(0,0,_radius);
			lightSprite.graphics.endFill();
		}
		
		public function refresh():void
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
			var item:ShadowItem = new ShadowItem(v,maskSprite);
			
			items.push(item);
			maskSprite.addChild(item.shadow);
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

class ShadowItem
{
	public var item:DisplayObject;
	public var shadow:Sprite;
	public var shadowBitmap:Bitmap;
	public var parent:DisplayObjectContainer;
	public function ShadowItem(item:DisplayObject,parent:DisplayObjectContainer):void
	{
		this.item = item;
		this.parent = parent;
		this.shadow = new Sprite();
		this.shadowBitmap = new Bitmap();
		this.shadow.addChild(this.shadowBitmap);
		
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
	}
}