package
{
	import ghostcat.display.GBase;
	import ghostcat.display.other.SoundDisplayer;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.SoundOper;
	import ghostcat.ui.containers.GAlert;
	
	[SWF(width="600",height="600")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SoundExample extends GBase
	{
		public function SoundExample()
		{
			RootManager.register(this);
			
			GAlert.show("音乐开始");
			
			var oper:SoundOper = new SoundOper("f8i746.MP3",true,0,1,0,0);
			oper.addTween(2000,1,0.5);
			oper.addTween(1000,1);
			oper.addTween(2000,0,1);
			oper.commit();
			
			GAlert.show("音乐结束");
			
			addChild(new SoundDisplayer(100,50));
		}
	}
}