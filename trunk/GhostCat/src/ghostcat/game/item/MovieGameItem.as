package ghostcat.game.item
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import ghostcat.events.MovieEvent;
	import ghostcat.events.TickEvent;
	import ghostcat.game.util.GameTick;
	import ghostcat.game.layer.GameLayer;

	[Event(name="label_end", type="ghostcat.events.MovieEvent")]
	/**
	 * 动画对象 
	 * @author flashyiyi
	 * 
	 */
	public class MovieGameItem extends GameItem
	{
		public var movieClip:MovieClip
		public var frameRate:Number;
		
		private var _enabledTick:Boolean;
		private var _currentFrame:int;
		private var frameTimer:int;
		public var loops:int = -1;
		public function MovieGameItem(movieClip:MovieClip,frameRate:Number)
		{
			super();
			
			this.movieClip = movieClip;
			addChild(this.movieClip);
			this.frameRate = frameRate;
			this.currentFrame = 0;
			
			this.enabledTick = true;
		}
		
		/**
		 * 随机设置时间初值，可以错开图片更新时机增加性能 
		 * 
		 */
		public function randomFrameTimer():void
		{
			this.frameTimer += Math.random() * 1000 / frameRate;
		}
		
		public function get currentFrame():int
		{
			return _currentFrame;
		}

		public function set currentFrame(value:int):void
		{
			if (!movieClip)
				return;
			
			var totalFrame:int = movieClip.totalFrames;
			if (value >= totalFrame)
				value = totalFrame - 1;
			
			_currentFrame = value;
			
			var mcFrame:int = movieClip.currentFrame - 1;
			if (_currentFrame != mcFrame)
			{
				if (_currentFrame == mcFrame + 1)
					movieClip.nextFrame();
				else if (_currentFrame == mcFrame - 1)
					movieClip.prevFrame();
				else	
					movieClip.gotoAndStop(_currentFrame + 1);
			}
		}
		
		public function get totalFrame():int
		{
			return movieClip ? movieClip.totalFrames : 0;
		}

		/** @inheritDoc */	
		public function get enabledTick():Boolean
		{
			return _enabledTick;
		}
		
		public function set enabledTick(v:Boolean):void
		{
			if (_enabledTick == v)
				return;
			
			_enabledTick = v;
			
			if (_enabledTick)
				GameTick.instance.addEventListener(TickEvent.TICK,tickHandler);
			else
				GameTick.instance.removeEventListener(TickEvent.TICK,tickHandler);
		}
		
		protected function tickHandler(event:TickEvent):void
		{
			tick(event.interval);
		}
		
		public function tick(t:int):void
		{
			if (!movieClip || loops == 0)
				return;
			
			frameTimer -= t;
			while (frameTimer < 0) 
			{
				if (currentFrame == totalFrame - 1)
				{
					if (loops > 0)
						loops--;
					
					if (loops == 0)
					{
						this.frameTimer = 0;
						this.dispatchEvent(new MovieEvent(MovieEvent.MOVIE_END))
						return;
					}
					else
					{
						this.currentFrame = 0;
					}
				}
				else
				{
					currentFrame++;
				}
				
				frameTimer += 1000 / frameRate;
			}
		}
		
		public function destory():void
		{
			this.enabledTick = false;
		}
		
	}
}