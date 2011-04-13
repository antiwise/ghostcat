package ghostcat.util.encrypt
{
	import flash.utils.ByteArray;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import ghostcat.util.Util;

	/**
	 * 数据加密储存VO。可以有效防止内存修改。
	 * 
	 * @author flashyiyi
	 * 
	 */
	dynamic public class ProtectedVO extends Proxy
	{
		/**
		 * 加密算法
		 */
		public var encrypt:IEncrypt;
		/**
		 * 出错时的回调函数
		 */
		public var errorHandler:Function;
		
		public var data:Object;//伪值
		private var _data:Object;//真值
		
		public function ProtectedVO(encrypt:IEncrypt)
		{
			this.encrypt = encrypt;
			
			data = new Object();
			_data = new Object();
			
			this.errorHandler = defaultErrorHandler;
		}
		
		/**
		 * 默认错误方法
		 * 
		 */
		protected function defaultErrorHandler():void
		{
			throw new Error("数据验证失败！")
		}
		
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			var metrod:* = data[methodName];
			return (metrod as Function).apply(null,args);
		}
		
		flash_proxy override function getProperty(property:*):* 
		{
			var v:* = encrypt.decode(_data[property]);
			if (v is Number || v is String)
			{
				if (v != data[property])
					errorHandler();
			}
			else
			{
				if (!Util.equal(v,data[property]))
					errorHandler();
			}
			
			return v;
		}
		
		flash_proxy override function setProperty(property:*,value:*):void 
		{
			if (value is Number || value is String)
			{
				data[property] = value;
			}
			else
			{
				var bytes:ByteArray = new ByteArray();
				bytes.writeObject(value);
				bytes.position = 0;
				data[property] = bytes.readObject();
			}
			_data[property] = encrypt.encode(value);
		}
	}
}