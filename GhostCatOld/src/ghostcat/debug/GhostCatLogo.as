package ghostcat.debug
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Shape;
	
	public class GhostCatLogo extends Shape
	{
		public function GhostCatLogo()
		{
			graphics.lineStyle(4,0,1,false,"normal",CapsStyle.SQUARE,JointStyle.MITER);
			graphics.moveTo(25,25);
			graphics.lineTo(45,25);
			graphics.lineTo(45,50);
			graphics.lineTo(0,50);
			graphics.lineTo(0,0);
			graphics.lineTo(100,0);
			graphics.lineTo(100,10);
			graphics.lineTo(55,10);
			graphics.lineTo(55,50);
			graphics.lineTo(100,50);
		}
	}
}