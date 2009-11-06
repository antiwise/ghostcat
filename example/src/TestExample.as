package
{
	import flash.net.URLLoaderDataFormat;
	
	import ghostcat.display.GBase;
	import ghostcat.events.OperationEvent;
	import ghostcat.fileformat.mp3.MP3Decoder;
	import ghostcat.operation.LoadOper;

	[SWF(width="600",height="450")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		public function TestExample()
		{
			var oper:LoadOper = new LoadOper("f8i746.MP3",null,rhandler);
			oper.dataFormat = URLLoaderDataFormat.BINARY;
			oper.commit();
		}
		
		private function rhandler(event:OperationEvent):void
		{
			var v:MP3Decoder = new MP3Decoder();
			v.play((event.currentTarget as LoadOper).data,0,int.MAX_VALUE);
		}
		
		
	}
}