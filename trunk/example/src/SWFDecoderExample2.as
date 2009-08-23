package 
{
	import flash.display.Sprite;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import org.ghostcat.events.OperationEvent;
	import org.ghostcat.fileformat.swf.SWFDecoder;
	import org.ghostcat.fileformat.swf.tag.DebugIDTag;
	import org.ghostcat.fileformat.swf.tag.ProductInfoTag;
	import org.ghostcat.operation.LoadOper;
	
	/**
	 * SWF二进制代码解析（这几个Tag只有FLEX编译的文件才有）
	 * 
	 * @author Administrator
	 * 
	 */
	public class SWFDecoderExample2 extends Sprite
	{
		public var swfDecoder:SWFDecoder;
		public function SWFDecoderExample2()
		{
			var loader:LoadOper = new LoadOper("Paper3DExample.swf",null,rhandler);
			loader.type = LoadOper.URLLOADER;
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.commit();
		}
		
		private function rhandler(event:OperationEvent):void
		{
			var bytes:ByteArray = (event.target as LoadOper).data as ByteArray;
			swfDecoder = new SWFDecoder();
			swfDecoder.read(bytes);
			
			trace(swfDecoder.getTags(ProductInfoTag)[0].toString());
			trace(swfDecoder.getTags(DebugIDTag)[0].toString());
		}
	}
}