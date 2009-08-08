package 
{
	import flash.display.Sprite;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import org.ghostcat.debug.Debug;
	import org.ghostcat.events.OperationEvent;
	import org.ghostcat.fileformat.swf.SWFDecoder;
	import org.ghostcat.fileformat.swf.tag.DoABCTag;
	import org.ghostcat.fileformat.swf.tag.SetBackgroundColorTag;
	import org.ghostcat.fileformat.swf.tag.SymbolClassTag;
	import org.ghostcat.operation.LoadOper;
	import org.ghostcat.util.ReflectUtil;
	
	/**
	 * SWF二进制代码解析
	 * 
	 * @author Administrator
	 * 
	 */
	public class SWFDecoderExample extends Sprite
	{
		public var swfDecoder:SWFDecoder;
		public function SWFDecoderExample()
		{
			var loader:LoadOper = new LoadOper("Test.swf",null,rhandler);
			loader.type = LoadOper.URLLOADER;
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.commit();
		}
		
		private function rhandler(event:OperationEvent):void
		{
			var bytes:ByteArray = (event.target as LoadOper).data as ByteArray;
			swfDecoder = new SWFDecoder();
			swfDecoder.read(bytes);
			
			Debug.traceObject(null,ReflectUtil.getPropertyList(swfDecoder))
			
			trace(swfDecoder.getTags(SymbolClassTag)[0].symbolClasses);
			
			var arr:Array = swfDecoder.getTags(DoABCTag);
			for (var i:int = 0;i < arr.length;i++)
				trace((arr[i] as DoABCTag).name)
		}
	}
}