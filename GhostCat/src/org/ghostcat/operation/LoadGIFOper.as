package org.ghostcat.operation
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.ghostcat.fileformat.gif.GIFDecoder;

	/**
	 * 这个类在提供读取GIF动画为位图数组的功能
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class LoadGIFOper extends LoadOper
	{
		/**
		 * 
		 * @param url	数据地址
		 * @param embedClass	嵌入数据
		 * @param rhandler	载入成功函数
		 * @param fhandler	载入失败函数
		 * 
		 */
		public function LoadGIFOper(url:String,embedClass:Class=null,rhandler:Function=null,fhandler:Function=null)
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
			var bytes:ByteArray = super.data as ByteArray;
			var gif:GIFDecoder = new GIFDecoder();
			gif.read(bytes);
			return gif.getBitmapDatas();
		}
	}
}