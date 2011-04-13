package ghostcat.display.media
{
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * 视频播放类 
	 * @author flashyiyi
	 * 
	 */
	public class GVideo extends Video
	{
		public var ns:NetStream;
		public var nc:NetConnection;
		
		private var _vol:Number = 1.0;
		private var _panning:Number = 0.0;
		
		public var duration:Number;
		public var frameRate:Number;
		public var filepositions:Array;
        public var times:Array;
        public var currentCuePoint:Object
        
		
		/**
		 * 音量 
		 * @return 
		 * 
		 */
		public function get vol():Number
		{
			return _vol;
		}
		
		public function set vol(v:Number):void
		{
			_vol = v;
			ns.soundTransform = new SoundTransform(_vol,_panning);
		}
		
		/**
		 * 左右声道平衡 
		 * @return 
		 * 
		 */
		public function get panning():Number
		{
			return _panning;
		}
		
		public function set panning(v:Number):void
		{
			_panning = v;
			ns.soundTransform = new SoundTransform(_vol,_panning);
		}
		
		public function GVideo(width:int=320, height:int=240)
		{
			super(width, height);
		}
		
		/**
		 * 加载 
		 * @param url
		 * 
		 */
		public function load(url:String):void
		{
			nc = new NetConnection();
			nc.connect(url);
			
			ns = new NetStream(nc);
			ns.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler,false,0,true);
			ns.client = this;
			
			this.attachNetStream(ns);
		}
		
        protected function onMetaData(info:Object):void
        {
            duration = info.duration;
            frameRate = info.framerate;
            if (info.keyframes != null)
            {
                filepositions = info.keyframes.filepositions;
                times = info.keyframes.times;
            }
            
        }
        
        protected function onCuePoint(info:Object):void
        {
        	currentCuePoint = info;
        }
 
		
		protected function netStatusHandler(event:NetStatusEvent):void
		{
			if (event.info.code == "NetStream.Play.Stop")
				dispatchEvent(new Event(Event.COMPLETE))
		}
		
		/**
		 * 播放 
		 * 
		 */
		public function play():void
		{
			ns.play();
		}
		
		public function destory():void
		{
			if (nc)
				nc.close();
			
			if (ns)
			{
				ns.removeEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
				ns.client = null;
				ns.close();
			}	
			this.clear();
		}
	}
}