package 
{
	import ghostcat.display.GBase;
	import ghostcat.display.viewport.Tile45;
	import ghostcat.parse.graphics.GraphicsLineFill;
	
	[SWF(width="200",height="200",backgroundColor="0x0")]
	
	public class GhostCatFP10Example extends GBase
	{
		public function GhostCatFP10Example()
		{
			new GraphicsLineFill(45,10,2,0xFF0000,1,0,0).parse(this);
			graphics.drawCircle(100,100,100);
		}
	}
}