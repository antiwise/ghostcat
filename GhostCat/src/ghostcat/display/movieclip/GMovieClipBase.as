package ghostcat.display.movieclip
{
	import flash.display.FrameLabel;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	import ghostcat.display.GBase;
	import ghostcat.events.MovieEvent;
	import ghostcat.events.TickEvent;
	import ghostcat.util.Util;
	import ghostcat.util.core.AbstractUtil;
	import ghostcat.util.core.Handler;

	[Event(name="movie_start",type="org.gameui.events.MovieEvent")]
	
	[Event(name="movie_end",type="org.gameui.events.MovieEvent")]
	
	[Event(name="movie_empty",type="org.gameui.events.MovieEvent")]
	
	
	/**
	 * 作为GMovieClip和BitmapMovieClip共同的基类。此类不允许实例化。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GMovieClipBase extends GBase
	{
		/**
		 * 全局默认帧频，为NaN时则取舞台帧频
		 */
		public static var defaultFrameRate:Number = NaN;
		
		/**
		 * 保存着所有的帧上函数
		 */
		public static var labelHandlers:Dictionary = new Dictionary();
		
		/**
		 * 注册一个根据特定帧标签执行的函数
		 * 
		 * @param name
		 * @param h
		 * 
		 */		
		public static function registerHandler(name:String,h:Handler):void
		{
			labelHandlers[name] = h;
		}
		
		/**
		 * 注册一个根据特定帧标签播放的声音
		 * 
		 * @param name
		 * @param h
		 * 
		 */		
		public static function registerSound(name:String,s:Sound,loop:int = 1,volume:Number = 1.0,pan:Number = 0):void
		{
			registerHandler(name,new Handler(s.play,[0,loop,new SoundTransform(volume,pan)]));
		}
		
		private var _frameRate:Number = NaN;
		
		private var numLoops:int = -1;//循环次数，-1为无限循环
		
		private var nextLabels:Array = [];//Labels列表
        
        protected var curLabelIndex:int=0;//缓存LabelIndex的序号，避免重复遍历
        
        private var frameTimer:int=0;//记时器，小于0则需要播放，直到大于0

		public function GMovieClipBase(skin:*=null, replace:Boolean=true, paused:Boolean=false)
		{
			AbstractUtil.preventConstructor(this,GMovieClipBase);
			super(skin, replace);
			
			this.enabledTick = true;
			this.paused = paused;
		}
		
		/**
		 * 设置帧频，设为NaN表示使用默认帧频，负值则为倒放。
		 */		
		public function get frameRate():Number
		{
			if (!isNaN(_frameRate))
				return 	_frameRate;
			else if (!isNaN(defaultFrameRate))
				return defaultFrameRate;
			else if (stage)
				return stage.frameRate;
			else
				return 0;
		}

		public function set frameRate(v:Number):void
		{
			_frameRate = v;
		}
		
		/**
         * 获得标签的序号
         *  
         * @param labelName
         * @return 
         * 
         */
        public function getLabelIndex(labelName:String):int
        {
        	for (var i:int = 0;i<labels.length;i++)
        	{
        		if ((labels[i] as FrameLabel).name == labelName)
        			return i;
        	}
        	return -1;
        }
        
        /**
         * 是否存在某个标签
         * 
         * @param labelName
         * @return 
         * 
         */
        public function hasLabel(labelName:String):Boolean
        {
        	return getLabelIndex(labelName) != -1;
        }
		
		/**
		 * 设置当前动画 
		 * @param labelName		动画名称
		 * @param repeat		动画循环次数，设为-1为无限循环
		 * 
		 */
		 		
		public function setLabel(labelName:String, repeat:int=-1):void
        {
        	nextLabels = [];
        	
            var index:int = getLabelIndex(labelName);
			if (index != -1)
			{
				numLoops = repeat;
				currentFrame  = (frameRate >= 0) ? getLabelStart(index) : getLabelEnd(index);
				curLabelIndex = index;
				
				dispatchEvent(Util.createObject(new MovieEvent(MovieEvent.MOVIE_START),{labelName:curLabelName}))
				
				if (GMovieClipBase.labelHandlers[labelName])
					(GMovieClipBase.labelHandlers[labelName] as Handler).call();
        	}
        	else
        	{
        		dispatchEvent(Util.createObject(new MovieEvent(MovieEvent.MOVIE_END),{labelName:labelName}));
        		dispatchEvent(Util.createObject(new MovieEvent(MovieEvent.MOVIE_ERROR),{labelName:labelName}));
//				if (nextLabels.length > 0)
//				{
//					setLabel(nextLabels[0][0], nextLabels[0][1]);
//					nextLabels.splice(0, 1);
//				}
//				else 
//				{
//					dispatchEvent(Util.createObject(new MovieEvent(MovieEvent.MOVIE_EMPTY),{labelName:curLabelName}));
//				}
        	}
        }
        
        /**
         *
         * 将动画推入列表，延迟播放
         * @param labelName		动画名称
         * @param repeat		动画循环次数，设为-1为无限循环
         * 
         */
                 
        public function queueLabel(labelName:String, repeat:int=-1):void
        {
            nextLabels.push([labelName, repeat]);
        }
        
        /**
         * 清除动画队列 
         */
         		
        public function clearQueue():void
        {
            nextLabels = [];
        }
        
        /**
         * 初始化动画
         * 
         */
        public function reset():void
        {
			clearQueue();
			if (labels && labels.length>0)
				setLabel(labels[0].name,-1);
        }
        
        /**
         * 在暂停状态下，仍然可以手动使用此方法激活tick。利用它可以处理区域调速等功能。
         * @param v
         * 
         */
        public function tick(v:int):void
        {
        	var evt:TickEvent = new TickEvent(TickEvent.TICK);
        	evt.interval = v;
        	tickHandler(evt);
        }
		
		protected override function tickHandler(event:TickEvent):void
		{
			if (frameRate == 0)
				return;
			
			frameTimer -= event.interval;
            while (numLoops != 0 && frameTimer < 0) 
			{
				if (hasReachedLabelEnd())
				{
					if (numLoops > 0)
						numLoops--;
					
					if (numLoops == 0)
					{
						dispatchEvent(Util.createObject(new MovieEvent(MovieEvent.MOVIE_END),{labelName:curLabelName}));
						if (nextLabels.length > 0)
						{
							setLabel(nextLabels[0][0], nextLabels[0][1]);
							nextLabels.splice(0, 1);
						}
						else 
						{
							dispatchEvent(Util.createObject(new MovieEvent(MovieEvent.MOVIE_EMPTY),{labelName:curLabelName}));
						}
					}
					else 
					{
						loopBackToStart();
					}
				}
				else
				{
					nextFrame()
				}
				
				frameTimer += 1000/ Math.abs(frameRate);
			}
		}
		
		/**
         * 回到当前动画的第一帧（反向播放则是最后一帧）
         */
        public function loopBackToStart():void
        {
            currentFrame = (frameRate >= 0) ? getLabelStart(curLabelIndex) : getLabelEnd(curLabelIndex);
        }
		
		//检测是否已经到达当前区段的尾端（倒放则相反）
		private function hasReachedLabelEnd():Boolean
        {
        	if (frameRate >= 0)
        		return currentFrame >= getLabelEnd(curLabelIndex);
        	else
        		return currentFrame <= getLabelStart(curLabelIndex);
        }
        
        //取得Label的头部
        private function getLabelStart(labelIndex:int):int
        {
        	return (labels && labels.length > 0) ? labels[labelIndex].frame : 1;
        }
        
        //取得Label的尾端
        private function getLabelEnd(labelIndex:int):int
        {
        	if (labels && labelIndex + 1 < labels.length)
                return labels[labelIndex + 1].frame - 1;
            else
            	return totalFrames;
        }
        
        /** @inheritDoc*/
		public override function destory():void
		{
			paused = false;
			super.destory();
		}
		
        /**
		 * 所有标签，类型为FrameLabel
		 * @return 
		 * 
		 */
		public function get labels():Array
		{
			return null;
		}
		
		/**
		 * 当前动画名称
		 * @return 
		 * 
		 */	
		public function get curLabelName():String
		{
			return null;
		}
		
		/**
		 * 当前帧
		 * 
		 * @return 
		 * 
		 */
		public function get currentFrame():int
        {
        	return -1;
        }
        
        public function set currentFrame(frame:int):void
        {
        }
        
        /**
         * 总帧数
         * 
         * @return 
         * 
         */
        public function get totalFrames():int
        {
        	return -1;
        }
        
        /**
         * 下一帧（倒放时则是上一帧）
         * 
         */
        public function nextFrame():void
        {
        }
	}
}