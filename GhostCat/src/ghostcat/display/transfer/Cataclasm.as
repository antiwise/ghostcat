package ghostcat.display.transfer
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class Cataclasm extends GTransfer
	{
		private var tris:Array; 
		
		public var w:int;
		public var h:int;
		
		public function Cataclasm(target:DisplayObject=null,w:int = 10,h:int = 10)
		{
			this.w = w;
			this.h = h;
			
			super(target);
		}
		
		
		public function createPoints():void
		{
			var dx:Number = target.width / w;
			var dy:Number = target.height / h;
			
			var points:Array = [];
			for (var j:int = 0; j < h; j++)
			{
				points[j] = [];
				for (var i:int = 0; i < w; i++)
				{
					var x:Number = (i == 0) ? 0 : (i == w - 1) ? target.width - 1 : dx * (i + Math.random());
					var y:Number = (j == 0) ? 0 : (j == h - 1) ? target.height - 1 : dy * (j + Math.random());
					points[j][i] = new Point(x,y);
				}
			}
			
			tris = [];
			for (var j:int = 0; j < points.length - 1; j++)
			{
				for (var i:int = 0; i < points[j].length - 1; i++)
				{
					var t1:Tri = new Tri(points[j][i],points[j][i + 1],points[j + 1][i])
					var t2:Tri = new Tri(points[j][i + 1],points[j + 1][i],points[j + 1][i + 1]);
					tris.push(t1,t2);
				}
			}
		}
		
		protected override function renderTarget() : void
		{
			createPoints();
			super.renderTarget();
		}
		
		protected override function showBitmapData() : void
		{
			graphics.clear();
		
			for each (var t:Tri in tris)
				t.parse(graphics);
		}
	}
}
import flash.display.Graphics;
import flash.geom.Point;

class Tri
{
	public var p1:Point;
	public var p2:Point;
	public var p3:Point;
	public function Tri(p1:Point,p2:Point,p3:Point):void
	{
		this.p1 = p1.clone();
		this.p2 = p2.clone();
		this.p3 = p3.clone();
	}
	
	public function parse(graphics:Graphics):void
	{
		graphics.beginFill(Math.random() * 0xFFFFFF);
		graphics.moveTo(p1.x,p1.y);
		graphics.lineTo(p2.x,p2.y);
		graphics.lineTo(p3.x,p3.y);
		graphics.endFill();
	}
}