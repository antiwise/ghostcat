package ghostcat.media
{
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.utils.Dictionary;
	
	public class NetStatusEventHelper
	{
		public static const NS_BUFFER_EMPTY:String = "NetStream.Buffer.Empty";//数据的接收速度不足以填充缓冲区。 数据流将在缓冲区重新填充前中断，此时将发送 NetStream.Buffer.Full 消息，并且该流将重新开始播放。 
		public static const NS_BUFFER_FULL:String = "NetStream.Buffer.Full";//缓冲区已满并且流将开始播放。 
		public static const NS_BUFFER_FLUSH:String = "NetStream.Buffer.Flush";// 数据已完成流式处理，剩余的缓冲区将被清空。 
		public static const NS_PUBLIST_START:String = "NetStream.Publish.Start";// 已经成功发布。 
		public static const NS_PUBLISH_BADNAME:String = "NetStream.Publish.BadName";// 试图发布已经被他人发布的流。 
		public static const NS_PUBLIST_IDLE:String = "NetStream.Publish.Idle";//流的发布者已经空闲太长时间。 
		public static const NS_UNPUBLISH_SUCCESS:String = "NetStream.Unpublish.Success";//已成功执行取消发布操作。 
		public static const NS_PLAY_START:String = "NetStream.Play.Start";//播放已开始。 
		public static const NS_PLAY_STOP:String = "NetStream.Play.Stop";//播放已结束。 
		public static const NS_PLAY_FAILED:String = "NetStream.Play.Failed";//出于此表中列出的原因之外的某一原因（例如订阅者没有读取权限），播放发生了错误。 
		public static const NS_PLAY_STREAMNOTFOUND:String = "NetStream.Play.StreamNotFound";//无法找到传递给 play() 方法的 FLV。 
		public static const NS_PLAY_RESET:String = "NetStream.Play.Reset";//由播放列表重置导致。 
		public static const NS_PLAY_PUBLISHNOTIFY:String = "NetStream.Play.PublishNotify";//到流的初始发布被发送到所有的订阅者。 
		public static const NS_PLAY_UNPUBLISHNOTIFY:String = "NetStream.Play.UnpublishNotify";//从流取消的发布被发送到所有的订阅者。 
		public static const NS_PAUSE_NOTIFY:String = "NetStream.Pause.Notify";//流已暂停。 
		public static const NS_UNPAUSE_NOTIFY:String = "NetStream.Unpause.Notify";//流已恢复。 
		public static const NS_RECORD_START:String = "NetStream.Record.Start";//录制已开始。 
		public static const NS_RECORD_NOACCESS:String = "NetStream.Record.NoAccess";//试图录制仍处于播放状态的流或客户端没有访问权限的流。 
		public static const NS_RECORD_STOP:String = "NetStream.Record.Stop";//录制已停止。 
		public static const NS_RECORD_FAILED:String = "NetStream.Record.Failed";//尝试录制流失败。 
		public static const NS_SEEK_FAILED:String = "NetStream.Seek.Failed";//搜索失败，如果流处于不可搜索状态，则会发生搜索失败。 
		public static const NS_SEEK_INVALIDTIME:String = "NetStream.Seek.InvalidTime";//对于使用渐进式下载方式下载的视频，用户已尝试跳过到目前为止已下载的视频数据的结尾或在整个文件已下载后跳过视频的结尾进行搜寻或播放。 message.details 属性包含一个时间代码，该代码指出用户可以搜寻的最后一个有效位置。 
		public static const NS_SEEK_NOTIFY:String = "NetStream.Seek.Notify";//搜寻操作完成。 
		public static const NC_CALL_BADVERSION:String = "NetConnection.Call.BadVersion";//以不能识别的格式编码的数据包。 
		public static const NC_CALL_FAILED:String = "NetConnection.Call.Failed";//NetConnection.call 方法无法调用服务器端的方法或命令。 
		public static const NC_CALL_PROHIBITED:String = "NetConnection.Call.Prohibited";//Action Message Format (AMF) 操作因安全原因而被阻止。 或者是 AMF URL 与 SWF 不在同一个域，或者是 AMF 服务器没有信任 SWF 文件的域的策略文件。  
		public static const NC_CONNECT_CLOSED:String = "NetConnection.Connect.Closed";//成功关闭连接。 
		public static const NC_CONNECT_FAILED:String = "NetConnection.Connect.Failed";//连接尝试失败。 
		public static const NS_CONNECT_SUCCESS:String = "NetConnection.Connect.Success";//连接尝试成功。 
		public static const NS_CONNECT_REJECTED:String = "NetConnection.Connect.Rejected";//连接尝试没有访问应用程序的权限。 
		public static const NS_CONNECT_APPSHUTDOWN:String = "NetConnection.Connect.AppShutdown";//正在关闭指定的应用程序。 
		public static const NS_CONNECT_INVAILDAPP:String = "NetConnection.Connect.InvalidApp";// 连接时指定的应用程序名无效。 
		public static const SO_FLUSH_SUCCESS:String = "SharedObject.Flush.Success";//“待定”状态已解析并且 SharedObject.flush() 调用成功。 
		public static const SO_FLUSH_FAILED:String = "SharedObject.Flush.Failed";//“待定”状态已解析，但 SharedObject.flush() 失败。 
		public static const SO_BADPERSISTENCE:String = "SharedObject.BadPersistence";//使用永久性标志对共享对象进行了请求，但请求无法被批准，因为已经使用其它标记创建了该对象。 
		public static const SO_URIMISMATCH:String = "SharedObject.UriMismatch";//试图连接到拥有与共享对象不同的 URI (URL) 的 NetConnection 对象。 
	
		private static var handlerCache:Dictionary = new Dictionary();
		
		public static function addEventListener(target:IEventDispatcher,types:*,h:Function,useCaptrue:Boolean = false,priority:int = 0,useWeakReference:Boolean = false):void
		{
			target.addEventListener(NetStatusEvent.NET_STATUS,handler,useCaptrue,priority,useWeakReference)
			if (!(types is Array))
				types = [types];
			
			if (handlerCache[h])
				(handlerCache[h] as Array).push(handler);
			else
				handlerCache[h] = [handler];
				
			function handler(event:NetStatusEvent):void
			{
				var info:Object = event.info;
				
				if (event.info.code.indexOf(types) != -1)
				{
					handler(event);
				}
			}
		}
		
		public static function removeEventListener(target:IEventDispatcher,h:Function):void
		{
			if (handlerCache[h])
			{
				for each (var f:Function in handlerCache[h])
				{
					target.removeEventListener(NetStatusEvent.NET_STATUS,h);
				}
			}
		}
	}
}