package ghostcat.display.movieclip
{
	import flash.display.FrameLabel;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	import ghostcat.display.GBase;
	import ghostcat.events.MovieEvent;
	import ghostcat.events.TickEvent;
	import ghostcat.util.Tick;
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
		protected var _labels:Array;
		protected var _currentFrame:int = 1;
		protected var _totalFrames:int = 1;
		
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

		/**
		 * 连接到自己的MovieClip对象
		 */
		public var linkMovieClips:Array;
		
		/**
		 * 是否在动画结束后暂停 
		 */
		public var playOnce:Boolean = true;
		
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
			else if (!isNaN(Tick.frameRate))
				return Tick.frameRate;
			else if (stage)
				return stage.frameRate;
			else
				return NaN;
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
		 * 设置循环次数 
		 * @param loop
		 * 
		 */
		public function setLoop(loop:int):void
		{
			this.numLoops = loop;
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
				
				var e:MovieEvent = new MovieEvent(MovieEvent.MOVIE_START);
				e.labelName = labelName;
				dispatchEvent(e);
				
				if (GMovieClipBase.labelHandlers[labelName])
					(GMovieClipBase.labelHandlers[labelName] as Handler).call();
        	}
        	else
        	{
				e = new MovieEvent(MovieEvent.MOVIE_END);
				e.labelName = labelName;
				dispatchEvent(e);
				
				e = new MovieEvent(MovieEvent.MOVIE_ERROR);
				e.labelName = labelName;
				dispatchEvent(e);
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
			if (labels && labels.length > 0)
				setLabel(labels[0].name,-1);
        }
        
        protected override function tickHandler(event:TickEvent):void
		{
			if (frameRate == 0 || totalFrames <= 1)
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
						var e:MovieEvent = new MovieEvent(MovieEvent.MOVIE_END);
						e.labelName = curLabelName;
						dispatchEvent(e);
						
						if (nextLabels.length > 0)
						{
							setLabel(nextLabels[0][0], nextLabels[0][1]);
							nextLabels.splice(0, 1);
						}
						else 
						{
							e = new MovieEvent(MovieEvent.MOVIE_EMPTY);
							e.labelName = curLabelName;
							dispatchEvent(e);
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
		 * 当前帧标签内的位置
		 * @return 
		 * 
		 */
		public function get frameInLabel():int
		{
			return currentFrame - getLabelStart(curLabelIndex) + 1;
		}
		
		public function set frameInLabel(v:int):void
		{
			currentFrame = getLabelStart(curLabelIndex) + v - 1;
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
		 * 是否有帧标签 
		 * @return 
		 * 
		 */
		public function hasLabels():Boolean
		{
			return labels && labels.length > 0;
		}
		
        /**
		 * 所有标签，类型为FrameLabel
		 * @return 
		 * 
		 */
		public function get labels():Array
		{
			return _labels;
		}
		
		/**
		 * 当前动画名称
		 * @return 
		 * 
		 */	
		public function get curLabelName():String
		{
			for (var i:int = labels.length - 1;i>=0;i--)
			{
				if ((labels[i] as FrameLabel).frame <= currentFrame)
					return (labels[i] as FrameLabel).name;
			}
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
        	return _currentFrame;
        }
        
        public function set currentFrame(frame:int):void
        {
			if (linkMovieClips)
			{
				for each (var mc:GMovieClipBase in linkMovieClips)
					mc.currentFrame = frame;
			}
        }
        
        /**
         * 总帧数
         * 
         * @return 
         * 
         */
        public function get totalFrames():int
        {
        	return _totalFrames;
        }
        
        /**
         * 下一帧（倒放时则是上一帧）
         * 
         */
        public function nextFrame():void
        {
			(frameRate >= 0) ? currentFrame ++ : currentFrame --;
		}
		
		/**
		 * 连接到另一个动画，由目标动画控制自己的帧跳转
		 * @param target
		 * 
		 */
		public function linkTo(target:GMovieClipBase):void
		{
			this.paused = true;
			if (!target.linkMovieClips)
				target.linkMovieClips = [];
			
			target.linkMovieClips.push(this);
		}
		
		/**
		 * 解除动画连接 
		 * @param target
		 * 
		 */
		public function removeLinkFrom(target:GMovieClipBase):void
		{
			this.paused = false;
			Util.remove(target.linkMovieClips,this);
			
			if (target.linkMovieClips.length == 0)
				target.linkMovieClips = null;
		}
	}
}