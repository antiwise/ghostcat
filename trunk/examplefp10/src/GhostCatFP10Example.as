package 
{
	import ghostcat.display.GBase;
	import ghostcat.text.UBB;
	
	[SWF(width="200",height="200",backgroundColor="0x0")]
	
	public class GhostCatFP10Example extends GBase
	{
		public function GhostCatFP10Example()
		{
			trace(UBB.decode("[color=#FF0000][size=16][i]123213[/i][/size][/color]"));
		}
	}
}