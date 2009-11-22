package ghostcat.display.transfer
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import ghostcat.community.physics.BombManager;

	public class Cataclasm extends GTransfer
	{
		private var tris:Array = []; 
		
		public var w:int;
		public var h:int;
		
		public var physics:BombManager;
		
		public function Cataclasm(target:DisplayObject=null,w:int = 10,h:int = 10)
		{
			this.w = w;
			this.h = h;
			this.physics = new BombManager();
			
			super(target);
		}
		
		public function createTris():void
		{
			removeTris();
			
			var dx:Number = bitmapData.width / w;
			var dy:Number = bitmapData.height / h;
			
			var points:Array = [];
			for (var j:int = 0; j < h; j++)
			{
				points[j] = [];
				for (var i:int = 0; i < w; i++)
				{
					var x:Number = (i == 0) ? 0 : (i == w - 1) ? bitmapData.width - 1 : dx * (i + Math.random());
					var y:Number = (j == 0) ? 0 : (j == h - 1) ? bitmapData.height - 1 : dy * (j + Math.random());
					points[j][i] = new Point(x,y);
				}
			}
			
			tris = [];
			for (j = 0; j < points.length - 1; j++)
			{
				for (i = 0; i < points[j].length - 1; i++)
				{
					var t1:Tri = new Tri(points[j][i],points[j][i + 1],points[j + 1][i],bitmapData)
					addChild(t1);
					var t2:Tri = new Tri(points[j][i + 1],points[j + 1][i],points[j + 1][i + 1],bitmapData);
					addChild(t2);
					tris.push(t1,t2);
				}
			}
		}
		
		public function removeTris():void
		{
			for each (var tri:Tri in tris)
				removeChild(tri);
			
			tris = [];
			physics.removeAll();
		}
		
		public function bomb(p:Point = null):void
		{
			if (!p)
				p = new Point(bitmapData.width / 2,bitmapData.height / 2);
			
			physics.addAll(tris);
			physics.gravity = new Point(0,1000);
			physics.bomb(p);	
		}
		
		protected override function showBitmapData() : void
		{
			createTris();
		}
		
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			removeTris();
			
			super.destory();
		}
	}
}
import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.display.Sprite;

class Tri extends Sprite
{
	public var p1:Point;
	public var p2:Point;
	public var p3:Point;
	public var texture:BitmapData
	public function Tri(p1:Point,p2:Point,p3:Point,texture:BitmapData):void
	{
		var center:Point = new Point((p1.x + p2.x + p3.x)/3,(p1.y + p2.y + p3.y)/3);
		this.p1 = p1.subtract(center);
		this.p2 = p2.subtract(center);
		this.p3 = p3.subtract(center);
		this.texture = texture;
		this.x = center.x;
		this.y = center.y;
		render();
	}
	
	public function render():void
	{
		var m:Matrix = transform.matrix;
		m.invert();
		graphics.beginBitmapFill(texture,m);
		graphics.moveTo(p1.x,p1.y);
		graphics.lineTo(p2.x,p2.y);
		graphics.lineTo(p3.x,p3.y);
		graphics.endFill();
	}
}