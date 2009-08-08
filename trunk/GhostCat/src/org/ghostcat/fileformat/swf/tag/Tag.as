package org.ghostcat.fileformat.swf.tag
{
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * Tag基类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Tag
	{
		/**
		 * 数据源 
		 */
		public var bytes:ByteArray;
		
		/**
		 * 在数据源中的起点位置
		 */
		public var position:int;
		
		/**
		 * 数据长度
		 */
		public var length:int;
		
		/**
		 * 数据类型
		 */
		public function get type():int
		{
			return getDefinitionByName(getQualifiedClassName(this))["type"];
		}
		
		/**
		 * 读取数据 
		 * 
		 */
		public function read():void
		{
			bytes.position = position;
		}
		/**
		 * 修改数据 
		 * 
		 */
		public function write():void
		{
			bytes.position = position;
		}
	}
}