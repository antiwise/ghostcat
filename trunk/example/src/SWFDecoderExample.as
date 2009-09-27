package 
{
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import ghostcat.debug.Debug;
	import ghostcat.display.GSprite;
	import ghostcat.events.OperationEvent;
	import ghostcat.fileformat.swf.SWFDecoder;
	import ghostcat.fileformat.swf.SWFSelf;
	import ghostcat.fileformat.swf.tag.DebugIDTag;
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
	 * @author flashyiyi
	 * 
	 */
	public class SWFDecoderExample extends GSprite
	{
		public var swfDecoder:SWFDecoder;
		protected override function init():void
		{
			RootManager.register(this); 
			
			var loader:LoadOper = new LoadOper("test.swf",null,rhandler);
			loader.type = LoadOper.URLLOADER;
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.commit();
			
			GAlert.show("加载进test.swf并开始解析");
		}
		
		private function rhandler(event:OperationEvent):void
		{
			var bytes:ByteArray = (event.target as LoadOper).data as ByteArray;
			swfDecoder = new SWFDecoder(bytes);
			
			Debug.traceObject(null,ReflectUtil.getPropertyList(swfDecoder))
			
			GAlert.show((swfDecoder.getTags(SymbolClassTag)[0].symbolClasses).toString(),"SymbolClassTag");
			
			GAlert.show("下面是找到的类名");
			
			var arr:Array = swfDecoder.getTags(DoABCTag);
			for (var i:int = 0;i < arr.length;i++)
				GAlert.show((arr[i] as DoABCTag).name,"DoABCTag["+i+"]");
				
			new SWFSelf(this,rhandler2);
			GAlert.show("开始解析自身"); 
		}
		
		private function rhandler2(bytes:ByteArray):void
		{
			swfDecoder = new SWFDecoder(bytes);
			
			GAlert.show(swfDecoder.getTags(ProductInfoTag)[0].toString(),"ProductInfoTag");
//			GAlert.show(swfDecoder.getTags(DebugIDTag)[0].toString(),"DebugIDTag");
		}
	}
}