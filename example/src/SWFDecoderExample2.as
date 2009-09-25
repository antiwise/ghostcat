package 
{
	import flash.display.Sprite;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.fileformat.swf.SWFDecoder;
	import ghostcat.fileformat.swf.SWFSelf;
	import ghostcat.fileformat.swf.tag.DebugIDTag;
	import ghostcat.fileformat.swf.tag.ProductInfoTag;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.LoadOper;
	import ghostcat.ui.containers.GAlert;
	
	/**
	 * SWF二进制代码解析（这几个Tag只有FLEX编译的文件才有）
	 * 顺带演示如何用SWFSelf加载自身数据
	 * 
	 * @author Administrator
	 * 
	 */
	public class SWFDecoderExample2 extends Sprite
	{
		public var swfDecoder:SWFDecoder;
		public function SWFDecoderExample2()
		{
			RootManager.register(this);
			
			new SWFSelf(this,rhandler);
			
			GAlert.show("开始解析自身");
		}
		
		private function rhandler(bytes:ByteArray):void
		{
			swfDecoder = new SWFDecoder(bytes);
			
			GAlert.show(swfDecoder.getTags(ProductInfoTag)[0].toString(),"ProductInfoTag");
			GAlert.show(swfDecoder.getTags(DebugIDTag)[0].toString(),"DebugIDTag");
		}
	}
}