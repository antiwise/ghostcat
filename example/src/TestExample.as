package
{
	import ghostcat.display.GBase;
	import ghostcat.extend.RadioPlayer;
	
	[SWF(width="600",height="600")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		public function TestExample()
		{
			RadioPlayer.play("mms://live.hitfm.cn/fm887");
		}
	}
}