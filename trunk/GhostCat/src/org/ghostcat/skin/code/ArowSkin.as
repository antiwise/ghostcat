package org.ghostcat.skin.code
{
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.media.Sound;
	
	import org.ghostcat.display.GNoScale;
	import org.ghostcat.parse.DisplayParse;
	import org.ghostcat.parse.graphics.GraphicsFill;
	import org.ghostcat.parse.graphics.GraphicsLineStyle;
	import org.ghostcat.parse.graphics.GraphicsRect;
	
	/**
	 * 箭头不能单纯使用GRID-9缩放，必须用别的办法
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class ArowSkin extends GNoScale
	{
		private var _point:Point;
		
		private var radius:Number;
		private var borderColor:uint;
		private var borderThickness:Number;
		private var fillColor:uint;
		
		public function ArowSkin(width:Number=100,height:Number=20,point:Point=null,radius:Number = 5,borderColor:uint = 0,borderThickness:Number=1,fillColor:uint = 0xFFFFFF)
		{
			if (!point)
				point = new Point(0,-5);
			
			DisplayParse.create([new GraphicsLineStyle(borderThickness,borderColor),
								new GraphicsFill(fillColor)]).parse(this);
			this.filters = [new DropShadowFilter(4,45,0,0.5)];
			
			this.radius = radius;
			this.borderColor = borderColor;
			this.borderThickness = borderColor;
			this.fillColor = fillColor;
			
			this._point = point;
			
			super();
			
			this.width = width;
			this.height = height;
		}
		
		public function get point():Point
		{
			return _point;
		}
		
		public function set point(v:Point):void
		{
			if (_point.equals(v))
				return;
			
			_point = v;
			invalidateSize();
		}
		
		protected override function updateDisplayList():void
		{
			graphics.clear();
			DisplayParse.create([new GraphicsLineStyle(borderThickness,borderColor),
								new GraphicsFill(fillColor),
								new GraphicsRect(0,0,width,height,radius,radius,radius,radius,point)]).parse(this);
		
			super.updateDisplayList();
		}
	}
}