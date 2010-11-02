package ghostcat.manager
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import ghostcat.operation.SoundOper;
	import ghostcat.util.Tick;
	import ghostcat.util.core.Singleton;
	import ghostcat.util.easing.TweenUtil;
	
	/**
	 * 声音管理类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SoundManager extends Singleton
	{
		static public function get instance():SoundManager
		{
			return Singleton.getInstanceOrCreate(SoundManager) as SoundManager;
		}
		
		/**
		 * 声音类的默认包名
		 */		
		public var basePath:String ="";
		
		/**
		 * 默认声音大小
		 */		
		public var defaultVolume:Number=1.0;
		
		private var activeSound:Dictionary;
    	
    	public function SoundManager():void
    	{
    		activeSound = new Dictionary();
    	}
		
		/**
         * 设置全局声音的大小
         *  
         * @param volume	声音
         * @param pan	声音位置，范围由-1到1
         * @param len	变化需要的时间
         */	
	    public function setGlobalVolume(volume:Number,len:Number=0):void
        {
        	if (len==0)
        		SoundMixer.soundTransform = new SoundTransform(volume);
        	else
        		TweenUtil.to(SoundMixer,len,{volume:volume})
        }
		/**
         * 设置声音的大小
         *  
         * @param name	名称
         * @param volume	声音
		 * @param len	变化需要的时间
         */	
        public function setVolume(name:String, volume:Number,len:Number = 0):void
        {
            var sc:SoundChannel = getActiveChannel(name);
            if (sc)
            {
            	if (len==0)
            		sc.soundTransform = new SoundTransform(volume);
            	else
            		TweenUtil.to(sc,len,{volume:volume});
            }
        }
        
        /**
         * 设置声音位置
         * 
         * @param name	名称
         * @param pan	声音位置，范围由-1到1
         * @param len	过渡时间
         */
        public function setPan(name:String, pan:Number,len:Number):void
        {
            var sc:SoundChannel = getActiveChannel(name);
            if (sc)
            {
            	if (len==0)
            		sc.soundTransform = new SoundTransform(sc.soundTransform.volume,pan);
            	else
            		TweenUtil.to(sc,len,{pan:pan});
            }
        }
        
		/**
         * 声音是否正在播放
         *  
         * @param name	名称
         * 
         */	
        public function isPlaying(name:String):Boolean
        {
            return activeSound[transName(name)]!=null;
        }
        
		/**
         * 停止播放
         *  
         * @param name	名称
         * @param len	渐隐需要的时间
         */	
        public function stop(name:String,len:Number=0):void
        {
        	name = transName(name);
        	
            var sc:SoundChannel = activeSound[name];
            delete activeSound[name];
            
            if (sc)
            {
            	if (len==0)
            		sc.stop();
            	else	
            		TweenUtil.to(sc,len,{volume:0.0,onComplete:sc.stop});
            }
        }
		
		public function stopAll(len:Number = 0):void
		{
			for (var name:String in activeSound)
			{
				stop(name,len)
			}
		}

        public function getActiveChannel(name:String):SoundChannel
        {
            return activeSound[name];
        }
        /**
         * 播放
         *  
         * @param name	名称
         * @param loop	循环次数，-1为无限循环
         * @param volume	声音
         * @param len	渐显需要的时间
         */		
        public function play(name:String, loop:int=1, volume:Number=-1,len:Number=0):void
        {
			try
			{
				var ref:Class = getDefinitionByName(transName(name)) as Class;
			}
			catch(e:Error){};
			
			var sound:Sound;
			if (ref)
			{
				sound = (new ref()) as Sound;
			}
			else
			{
				sound  = new Sound();
				sound.load(new URLRequest(name),new SoundLoaderContext(1000,true));
				sound.addEventListener(IOErrorEvent.IO_ERROR,soundCompleteListener);
			}
			
			var channel:SoundChannel = sound.play(0, loop != -1 ? loop : int.MAX_VALUE);
			if (!channel)
				return;
			
			if (loop != 0 && loop != -1)
				channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
			
			activeSound[name] = channel;
			
			if (len == 0)
			{
				channel.soundTransform = new SoundTransform((volume != -1) ? volume : defaultVolume);
			}
			else
			{
				channel.soundTransform = new SoundTransform(0);
				TweenUtil.to(channel,len,{volume:(volume != -1) ? volume : defaultVolume}) 
			}
			
			function soundCompleteListener(evt:Event):void
			{
				channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
				sound.removeEventListener(IOErrorEvent.IO_ERROR, soundCompleteListener);
				
				delete activeSound[name];
			}
	    }
        
        private function transName(name:String):String
        {
        	if (basePath == "" || name.indexOf(".")!= -1)
        		return name;
        	else
        		return basePath + "." + name;
        }
	}
}