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
		
		public var items:Array = [];
		public var walls:Array = [];
		
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
import org.ghostcat.display.bitmap.BitmapUtil;
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
import flash.display.BitmapData;
import flash.display.BlendMode;
import org.ghostcat.util.ColorUtil;
import flash.geom.ColorTransform;
import org.ghostcat.display.bitmap.BitmapUtil;

class ShadowItem
{
	public var item:DisplayObject;
	public var light:Light;
	
	public var shadow:Bitmap;
	private var shadowMask:Shape;
	
	public var shadow2:Bitmap;
	private var shadowMask2:Shape;
	
	public function ShadowItem(item:DisplayObject,light:Light):void
	{
		this.item = item;
		this.light = light;
		
		this.shadow =  new Bitmap();
		this.shadowMask = new Shape();
		this.light.maskSprite.addChild(this.shadow);
		this.light.maskSprite.addChild(this.shadowMask);
		
		this.shadow2 = new Bitmap(shadow.bitmapData);
		this.shadowMask2 = new Shape();
		this.light.maskSprite.addChild(this.shadow2);
		this.light.maskSprite.addChild(this.shadowMask2)
		
		render();
		
		item.addEventListener(GEvent.UPDATE_COMPLETE,renderHandler);
		
	}
	private function renderHandler(event:GEvent):void
	{
		render();
	}
	public function render():void
	{
		if (this.shadow.bitmapData)
		{
			this.shadow.bitmapData.dispose();
			this.shadow2.bitmapData.dispose();
		}
		
		this.shadow.bitmapData = this.shadow2.bitmapData = BitmapUtil.drawToBitmap(item);
		this.shadow2.visible = this.shadowMask2.visible = false;
	}
	public function pointTo():void
	{
		var p:Point = Geom.localToContent(new Point(),this.item,light);
		var angle:Number = Math.atan2(p.y,p.x);
		var len:Number = p.length;
		
//		if (len <= light.radius)
//			this.item.transform.colorTransform = ColorUtil.getColorTransform2(light.color,1 - len / light.radius);
		
		var rect:Rectangle = item.getBounds(item);
		var m:Matrix = new Matrix();
		m.translate(rect.x,rect.y);
		m.scale(item.scaleX,item.scaleY * len / item.height);
		m.rotate(angle + Math.PI/2);
		m.translate(p.x,p.y);
		shadow.transform.matrix = m;
		shadow.alpha = 1 - len / light.radius;
		shadow.filters = [new BlurFilter(shadow.alpha*10,shadow.alpha*10)]
		
		var shadowLine:Line = new Line(p,p.add(p));
		for each (var wall:WallShadowItem in light.walls)
		{
			//将坐标换算成基于光的坐标
			var p1:Point = Geom.localToContent(wall.item.startPoint,wall.item.parent,light);
			var p2:Point = Geom.localToContent(wall.item.endPoint,wall.item.parent,light);
			
			var pi:Point = shadowLine.intersectionLine(new Line(p1,p2))
			if (pi && pi.length <= light.radius)
			{
				updateMaskShape(p1,p2,wall.item.wallHeight);
				this.shadow.mask = this.shadowMask;
				
				m = new Matrix();
				m.translate(rect.x,rect.y);
				m.scale(item.scaleX,item.scaleY);
				m.translate(pi.x,pi.y + Point.distance(pi,p) / len * item.height);
				shadow2.transform.matrix = m;
				shadow2.alpha = 1 - len / light.radius;
				shadow2.filters = [new BlurFilter(shadow.alpha*10,shadow.alpha*10)]
						
				this.shadow2.mask = this.shadowMask2;
				this.shadow2.visible = this.shadowMask2.visible = true;
				return;
			}
			else
			{
				var p1h:Point = p1.clone();
				p1h.y -= wall.item.wallHeight; 
				var p2h:Point = p2.clone();
				p2h.y -= wall.item.wallHeight;
				
				pi = shadowLine.intersectionLine(new Line(p1,p1h));
				if (pi && pi.length <= light.radius)
				{
					updateMaskShape(p1,p2,wall.item.wallHeight);
					this.shadow.mask = this.shadowMask;
					this.shadow2.visible = this.shadowMask2.visible = false;
					return;
				}
				else
				{
					pi = shadowLine.intersectionLine(new Line(p2,p2h));
					if (pi && pi.length <= light.radius)
					{
						updateMaskShape(p1,p2,wall.item.wallHeight);
						this.shadow.mask = this.shadowMask;
						this.shadow2.visible = this.shadowMask2.visible = false;
						return;
					}
				}
			}
		}
		
		this.shadowMask.graphics.clear();
		this.shadowMask2.graphics.clear();
		this.shadow.mask = null;
		this.shadow2.mask = null;
		this.shadow2.visible = this.shadowMask2.visible = false;
	}
	
	private function updateMaskShape(p1:Point,p2:Point,wallHeight:Number):void
	{
		if (p1.x < p2.x)
		{
			var t:Point = p1;
			p1 = p2;
			p2 = t;
		}
		shadowMask.graphics.clear();
		shadowMask.graphics.beginFill(0);
		shadowMask.graphics.moveTo(light.radius,-light.radius);
		shadowMask.graphics.lineTo(p1.x,-light.radius);
		shadowMask.graphics.lineTo(p1.x,p1.y);
		shadowMask.graphics.lineTo(p2.x,p2.y);
		shadowMask.graphics.lineTo(p2.x,p2.y - wallHeight);
		shadowMask.graphics.lineTo(p1.x,p1.y - wallHeight);
		shadowMask.graphics.lineTo(p1.x,-light.radius);
		shadowMask.graphics.lineTo(p2.x,-light.radius);
		shadowMask.graphics.lineTo(-light.radius,-light.radius);
		shadowMask.graphics.lineTo(-light.radius,light.radius);
		shadowMask.graphics.lineTo(light.radius,light.radius);
		shadowMask.graphics.endFill();
		
		shadowMask2.graphics.clear();
		shadowMask2.graphics.beginFill(0);
		shadowMask2.graphics.moveTo(p1.x,p1.y);
		shadowMask2.graphics.lineTo(p1.x,p1.y - wallHeight);
		shadowMask2.graphics.lineTo(p2.x,p2.y - wallHeight);
		shadowMask2.graphics.lineTo(p2.x,p2.y);
		shadowMask2.graphics.endFill();
	}
		
	public function destory():void
	{
		if (shadow)
		{
			shadow.parent.removeChild(shadow);
			shadow2.parent.removeChild(shadow2);
			shadow.bitmapData.dispose();
			shadow2.bitmapData.dispose();
			shadow = null;
			shadow2 = null;
		}
		light.maskSprite.removeChild(this.shadow);
		light.maskSprite.removeChild(this.shadowMask);
		light.maskSprite.removeChild(this.shadow2);
		light.maskSprite.removeChild(this.shadowMask2);
		
		item.removeEventListener(GEvent.UPDATE_COMPLETE,renderHandler);
	}
}

class WallShadowItem
{
	public var item:Wall;
	public var shadow:Shape;
	public var light:Light;
	public function WallShadowItem(item:Wall,light:Light):void
	{
		this.item = item;
		this.light = light;
		this.shadow = new Shape();
		this.light.maskSprite.addChild(this.shadow);
	}
	public function pointTo():void
	{
		shadow.graphics.clear();
		shadow.graphics.beginFill(0);
		//将坐标换算成基于光球的坐标
		var p1:Point = Geom.localToContent(item.startPoint,this.item.parent,light);
		var p2:Point = Geom.localToContent(item.endPoint,this.item.parent,light);
		
		var p1h:Point = p1.clone();
		p1h.y -= item.wallHeight;
		var p2h:Point = p2.clone();
		p2h.y -= item.wallHeight;
		var p1o:Point = p1.clone();
		p1o.normalize(light.radius);
		var p2o:Point = p2.clone();
		p2o.normalize(light.radius);
		var p1d:Point = p1.clone();
		p1d.normalize(int.MAX_VALUE);
		var p2d:Point = p2.clone();
		p2d.normalize(int.MAX_VALUE);
		
		var r1:Number = Math.atan2(p1.y,p1.x);
		var r2:Number = Math.atan2(p2.y,p2.x)
		var l:Number = light.radius / Math.cos((r1 - r2)/2);
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
		light.maskSprite.removeChild(this.shadow);
	}
}