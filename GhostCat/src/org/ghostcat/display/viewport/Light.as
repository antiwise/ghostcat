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
				d.pointTo();
			}
			for (i = 0;i < walls.length;i++)
			{
				var w:WallShadowItem = walls[i] as WallShadowItem;
				w.pointTo();
			} 
		}
		
		public function addWall(v:Wall):void
		{
			var item:WallShadowItem = new WallShadowItem(v,this);
			walls.push(item);
		}
		
		public function addItem(v:DisplayObject):void
		{
			var item:ShadowItem = new ShadowItem(v,this);
			items.push(item);
		}
		
		public override function destory() : void
		{
			super.destory();
			
			var i:int;
			for (i = 0;i<items.length;i++)
				items[i].destory();
			for (i = 0;i<walls.length;i++)
				walls[i].destory();
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
import org.ghostcat.display.viewport.Wall;
import org.ghostcat.parse.graphics.GraphicsPath;
import flash.display.Graphics;
import org.ghostcat.algorithm.bezier.Line;

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
		this.parent.maskSprite.addChild(this.shadow);
		
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
	public function pointTo():void
	{
		updateShape();
		
		var p:Point = Geom.localToContent(new Point(),this.item,parent);
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

class WallShadowItem
{
	public var item:Wall;
	public var shadow:Shape;
	public var parent:Light;
	public function WallShadowItem(item:Wall,parent:Light):void
	{
		this.item = item;
		this.parent = parent;
		this.shadow = new Shape();
		this.parent.maskSprite.addChild(this.shadow);
	}
	public function pointTo():void
	{
		shadow.graphics.clear();
		shadow.graphics.beginFill(0);
		var p1:Point = Geom.localToContent(item.startPoint,this.item.parent,parent);
		var p2:Point = Geom.localToContent(item.endPoint,this.item.parent,parent);
		
		var p1h:Point = p1.clone();
		p1h.y -= item.wallHeight;
		var p2h:Point = p2.clone();
		p2h.y -= item.wallHeight;
		var p1o:Point = p1.clone();
		p1o.normalize(parent.radius);
		var p2o:Point = p2.clone();
		p2o.normalize(parent.radius);
		var p1d:Point = p1.clone();
		p1d.normalize(int.MAX_VALUE);
		var p2d:Point = p2.clone();
		p2d.normalize(int.MAX_VALUE);
		
		var r1:Number = Math.atan2(p1.y,p1.x);
		var r2:Number = Math.atan2(p2.y,p2.x)
		var l:Number = parent.radius / Math.cos((r1 - r2)/2);
		var pr:Point = Point.polar(l,(r1+r2)/2);
		
		var pi:Point;
		pi = new Line(p2,p2d).intersectionLine(new Line(p1h,p2h));//根据光线和墙壁的交线分辨判断
		if (pi)
			new GraphicsPath([p1,p1o,pr,p2o,pi,p1h]).parse(shadow);
		else
		{
			pi = new Line(p2,p2d).intersectionLine(new Line(p1,p1h));
			if (pi)
				new GraphicsPath([p1,p1o,pr,p2o,pi,p1h]).parse(shadow);
			else
			{
				pi = new Line(p1,p1d).intersectionLine(new Line(p2h,p1h));
				if (pi)
					new GraphicsPath([p2,p2o,pr,p1o,pi,p2h]).parse(shadow);
				else
				{
					pi = new Line(p1,p1d).intersectionLine(new Line(p2,p2h));
					if (pi)
						new GraphicsPath([p2,p2o,pr,p1o,pi,p2h]).parse(shadow);
					else
					{
						new GraphicsPath([p1,p1o,pr,p2o,p2,p2h,p1h]).parse(shadow);//没有交线的情况
					}
				}
			}
		}
			
		shadow.graphics.endFill();
	}
	
	public function destory():void
	{
		parent.maskSprite.removeChild(this.shadow);
	}
}