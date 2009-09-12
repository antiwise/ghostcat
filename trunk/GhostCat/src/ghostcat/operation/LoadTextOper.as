package ghostcat.operation
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import ghostcat.text.ANSI;

	/**
	 * 这个类在提供读取ANSI编码文件的功能，文件无需是UTF8也可以正常读取
	 * 附带解压功能，使用ByteArray里的压缩方式。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class LoadTextOper extends LoadOper
	{
		/**
		 * 是否载入经过压缩的数据（压缩的数据可使用GhostCatTool打开及编辑），压缩文本数据可以使得体积大大减少。
		 * 这并不是为了加密（傻子才会被这种小伎俩骗到）
		 * 
		 * 也可以一直设为true，未压缩的数据并不会被再次解压而是跳过。
		 */
		public var compress:Boolean;
		
		/**
		 * 文件编码是否是ANSI
		 */		
		public var isANSI:Boolean = false;
		
		/**
		 * 
		 * @param url	数据地址
		 * @param embedClass	嵌入数据
		 * @param compress	是否是已压缩的数据
		 * @param rhandler	载入成功函数
		 * @param fhandler	载入失败函数
		 * 
		 */
		public function LoadTextOper(url:String,embedClass:Class=null,compress:Boolean=false,rhandler:Function=null,fhandler:Function=null)
		{
			super(url,embedClass,rhandler,fhandler)
		
			this.type = LoadOper.URLLOADER;
			this.dataFormat = URLLoaderDataFormat.BINARY;
		}
		
		public override function get data() : *
		{
			var bytes:ByteArray = super.data as ByteArray;
			if (compress)
			{
				try
				{
					bytes.uncompress();
				}
				catch(e:Error)
				{
				}
			}
			return isANSI ? ANSI.readTextFromByteArray(bytes) : bytes.toString();
		}
		
	}
}