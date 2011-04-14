package ghostcat.operation.load
{
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import ghostcat.fileformat.gif.GIFDecoder;

	/**
	 * 这个类在提供读取GIF动画为位图数组的功能
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class LoadGIFOper extends LoadOper
	{
		private var _result:Array;
		/**
		 * 
		 * @param url	数据地址
		 * @param embedClass	嵌入数据
		 * @param rhandler	载入成功函数
		 * @param fhandler	载入失败函数
		 * 
		 */
		public function LoadGIFOper(url:String=null,embedClass:Class=null,rhandler:Function=null,fhandler:Function=null)
		{
			super(url,embedClass,rhandler,fhandler)
		
			this.type = LoadOper.URLLOADER;
			this.dataFormat = URLLoaderDataFormat.BINARY;
		}
		
		/**
		 * 获取此属性时会进行解码，速度很慢
		 * @return 
		 * 
		 */
		public override function get data() : *
		{
			if (_result != null)
				return _result;
			
			var bytes:ByteArray = super.data as ByteArray;
			var gif:GIFDecoder = new GIFDecoder();
			gif.read(bytes);
			
			_result = [];
			var len:int = gif.getFrameCount();
			for (var i:int = 0;i < len;i++)
				_result.push(gif.getFrame(i))
				
			return _result;
		}
	}
}