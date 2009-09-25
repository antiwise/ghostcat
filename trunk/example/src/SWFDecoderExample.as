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
	import ghostcat.manager.RootManager;
	import ghostcat.operation.LoadOper;
	import ghostcat.ui.containers.GAlert;
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
			RootManager.register(this);
			
			var loader:LoadOper = new LoadOper("Test.swf",null,rhandler);
			loader.type = LoadOper.URLLOADER;
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.commit();
			
			GAlert.show("加载进Text.swf并开始解析");
		}
		
		private function rhandler(event:OperationEvent):void
		{
			var bytes:ByteArray = (event.target as LoadOper).data as ByteArray;
			swfDecoder = new SWFDecoder(bytes);
			
			Debug.traceObject(null,ReflectUtil.getPropertyList(swfDecoder))
			
			GAlert.show((swfDecoder.getTags(SymbolClassTag)[0].symbolClasses).toString(),"SymbolClassTag");
			
			var arr:Array = swfDecoder.getTags(DoABCTag);
			for (var i:int = 0;i < arr.length;i++)
				GAlert.show((arr[i] as DoABCTag).name,"DoABCTag["+i+"]");
		}
	}
}