package
{
	import ghostcat.display.GBase;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.DelayOper;
	import ghostcat.operation.SoundOper;
	import ghostcat.operation.TweenOper;
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
			
			var oper:SoundOper = new SoundOper("f8i746.MP3");
			oper.immediately = true;//让播放声音后面的Oper立即执行
			oper.commit();
			
			new TweenOper(oper,1000,{volume:0},true).commit();
			new DelayOper(2000).commit();
			new TweenOper(oper,1000,{volume:0,pan:1}).commit();
			
			GAlert.show("音乐结束");
		}
	}
}