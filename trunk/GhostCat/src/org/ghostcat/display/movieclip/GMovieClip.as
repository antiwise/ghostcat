package org.ghostcat.display.movieclip
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import org.ghostcat.events.MoveEvent;
	import org.ghostcat.events.MovieEvent;
	import org.ghostcat.events.TickEvent;
	import org.ghostcat.util.Handler;
	import org.ghostcat.util.Util;
	
	/**
	 * 动画控制类，可以通过setLabel, queueLabel将动画推入列表，实现动画的灵活控制。这种方法可以非常简单地实现多方向行走，表情动作系统。
	 * frameRate可以设置播放速度。采用了getTimer的机制，播放速度不会受到浏览器和机器配置的影响。
	 * 
	 * 由于MovieClip播放的异步以及播放速度的不稳定特性，不断执行gotoAndStop等方法时将会造成子动画播放不正常，
	 * 请尽可能避免在动画内再放置“影片剪辑”，而以“图形”代替。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	
	public class GMovieClip extends GMovieClipBase
	{
		public var timeLine:TimeLine;
		
		/**
		 * 
		 * @param mc	目标动画
		 * @param replace	是否替换
		 * @param paused	是否暂停
		 * 
		 */
		public function GMovieClip(mc:MovieClip=null, replace:Boolean=true, paused:Boolean=false)
		{
			super(mc, replace, paused);
		}
		
		public function get mc():MovieClip
		{
			return content as MovieClip;
		}
		
		public override function setContent(skin:DisplayObject, replace:Boolean=true):void
		{
			super.setContent(skin,replace);
			
			if (skin is MovieClip)
			{
				timeLine = new TimeLine(mc);
				//最开始的初始化，当设置了Label后，将首先在第一个Label内循环
				mc.stop();
				clearQueue();
				if (labels)
					setLabel(labels[0],-1);
			}
		}
		
		public override function get curLabelName():String
		{
			return timeLine.curLabelName;
		}
		
		public override function getLabelIndex(labelName:String):int
        {
        	return timeLine.getLabelIndex(labelName);
        }
		
		public override function get labels():Array
		{
			return timeLine.labels;
		}
		
		public override function get currentFrame():int
        {
        	return mc.currentFrame;
        }
        
        public override function set currentFrame(frame:int):void
        {
        	mc.gotoAndStop(frame);
        }
        
        public override function get totalFrames():int
        {
        	return mc.totalFrames;
        }
        
        public override function nextFrame():void
        {
        	mc.nextFrame();
        }
	}
}