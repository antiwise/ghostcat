package org.ghostcat.parse.display
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import org.ghostcat.parse.DisplayParse;
	
	public class Grid9Parse extends DisplayParse
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		
		public function Grid9Parse(x:Number,y:Number,width:Number,height:Number)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public override function parseDisplay(target:DisplayObject) : void
		{
			super.parseDisplay(target);
			
			target.scale9Grid = new Rectangle(x,y,width,height);
		}

	}
}