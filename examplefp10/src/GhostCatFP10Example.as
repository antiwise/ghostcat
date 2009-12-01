package 
{
	import ghostcat.display.GBase;
	import ghostcat.parse.graphics.GraphicsLineFill;
	import ghostcat.util.encrypt.AES;
	
	[SWF(width="200",height="200",backgroundColor="0x0")]
	
	public class GhostCatFP10Example extends GBase
	{
		public function GhostCatFP10Example()
		{
			new GraphicsLineFill(45,10,2,0xFF0000,1,0,0).parse(this);
			graphics.drawCircle(100,100,100);
			
			var s:String = AES.encrypt("asdfasdf","abc",AES.BIT_KEY_256);
			trace(s);
			trace(AES.decrypt(s,"abc",AES.BIT_KEY_256));
		}
	}
}