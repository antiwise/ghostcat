package 
{
	import flash.display.Sprite;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import ghostcat.debug.Debug;
	import ghostcat.events.OperationEvent;
	import ghostcat.fileformat.swf.SWFDecoder;
	import ghostcat.fileformat.swf.tag.DoABCTag;
	import ghostcat.fileformat.swf.tag.ProductInfoTag;
	import ghostcat.fileformat.swf.tag.SymbolClassTag;
	import ghostcat.operation.LoadOper;
	import ghostcat.util.ReflectUtil;
	
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
			swfDecoder = new SWFDecoder(bytes);
			
			Debug.traceObject(null,ReflectUtil.getPropertyList(swfDecoder))
			
			trace(swfDecoder.getTags(SymbolClassTag)[0].symbolClasses);
			
			var arr:Array = swfDecoder.getTags(DoABCTag);
			for (var i:int = 0;i < arr.length;i++)
				trace((arr[i] as DoABCTag).name)
		}
	}
}