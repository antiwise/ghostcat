package ghostcat.util
{
	/**
	 * 文件路径解析类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class FilePath
	{
		public const regex:RegExp = /^((\w)?:)?([^.]+)?(\.(\w+)?)?/; 
 		
 		/**
 		 * 分隔符
 		 */
 		public var separator:String;
 		
 		/**
 		 * 驱动器名
 		 */
 		public var drive:String;
 		
 		/**
 		 * 目录数组
 		 */
 		public var paths:Array;
 		
 		/**
 		 * 文件名
 		 */
 		public var filename:String;
 		
 		/**
 		 * 扩展名
 		 */
 		public var extension:String;
 		
		public function FilePath(v:String)
		{
			separator = (v.indexOf("\\")!=-1) ? "\\" : "/";
			
			var data:Array = regex.exec(v);
			drive = data[2];
			paths = (data[3] as String).split(separator);
			if (paths[0]=="")
				paths.shift();
			filename = paths.pop();
			
			extension = data[5];
		}
		
		public function toString():String
		{
			var result:String = "";
			if (drive)
				result += drive + ":" + separator;
				
			if (paths && paths.length > 0)
				result += paths.join(separator) + separator;
			
			if (filename)
				result += filename;
			
			if (extension)
				result += "." + extension;	
				
			return result;
		}
	}
}