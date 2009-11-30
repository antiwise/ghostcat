package 
{
	import flash.media.Sound;
	
	import ghostcat.display.GBase;
	import ghostcat.media.BeepMusic;
	import ghostcat.media.SoundDisplayer;
	
	[SWF(width="200",height="200",backgroundColor="0x0")]
	public class BeepExample extends GBase
	{
		public var p:Class;
		public var s:Sound;
		public function BeepExample()
		{
			new BeepMusic("B5--C1----------C1--C1----C1B5--B6B7C1------C1------00--C3--C1--C2C3C5----C5C5------" +
				"C3----C3C1----C3C5----C3C2------C2--------------C6------C5------C2------C3------C5--C3------C5--C3--C2C3C1----C2C3------00------" +
				"B5----B6C1--C1--C3----C3C5----C5C2--C2--C2--B6----B6C2----------B5--C1----------C1--C3----------C3--C5------------------------------" +
				"C1----C3C5----C5C6------C5------C3----C1C5--C5--C5--C3--00--C1--00--B5------C1------" +
				"C3----C1C5--C5--C5--C3--00--C1--00--B5------C1------B5------C1------B5------C1------C1------00------"
			).play(int.MAX_VALUE);
			addChild(new SoundDisplayer(200,200));
		}
	}
}