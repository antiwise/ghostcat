/**
 * Copyright (C) 2007 Flashlizi (flashlizi@gmail.com, www.riaidea.com)
 *
 * ZipArchive是一个Zip档案处理类，可读写各种zip格式文件。
 * 功能：1)轻松创建或加载一个zip档案；2)多种方式读取和删除zip档案中的文件；3)支持中文文件名；
 * 4)非常容易序列化一个zip档案，如有AIR、PHP等的支持下就可以把生成的zip档案保存在本地或服务器上。
 *
 * 如有任何意见或建议，可联系我：MSN:flashlizi@hotmail.com
 *
 * @version 0.1
 */

package org.ghostcat.fileformat.zip{
	import flash.events.Event;
	/**
	 * ZipEvent类定义与ZipArchive类相关的事件。
	 */
	public class ZipEvent extends Event {
		/**
		 * 定义zip_init事件的type属性值，在使用load方法加载zip档案完成后调度此事件，ZipEvent对象的content属性为空。
		 */
		public static var ZIP_INIT:String = "zip_init";
		/**
		 * 定义zip_content_loaded事件的type属性值，在使用getBitmapByName方法读取zip档案中图片的Bitmap数据完成后调度此事件，ZipEvent对象的content属性包含获取的Bitmap对象。
		 */
		public static var ZIP_CONTENT_LOADED:String = "zip_content_loaded";
		/**
		 * 定义zip_failed事件的type属性值，在使用load方法加载zip档案时出错时调度此事件，ZipEvent对象的content属性包含错误信息。
		 */
		public static var ZIP_FAILED:String = "zip_failed";
		/**
		 * @private
		 */
		internal static var ZIP_PARSE_COMPLETED:String = "zip_parse_completed";
		/**
		 * @private
		 */
		internal static var ZIP_PARSE_ERROR:String = "zip_parse_error";
		/**
		 * @private
		 */
		private var _content: * ;
		/**
		 * 构造函数，使用指定的参数创建新的ZipEvent对象。
		 * @param	type 事件类型
		 * @param	content 事件相关内容
		 * @param	bubbles 确定ZipEvent对象是否参与事件流的冒泡阶段。 默认值为false。
		 * @param	cancelable 确定是否可以取消ZipEvent对象。 默认值为false。
		 */
		public function ZipEvent(type:String, content:*= null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this._content = content;
		}
		/**
		 * ZipEvent对象的相关信息。
		 */
		public function get content():* {
			return _content;
		}
	}
}
