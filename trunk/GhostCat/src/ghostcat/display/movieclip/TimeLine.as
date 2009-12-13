package ghostcat.display.movieclip
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import ghostcat.events.TimeLineEvent;
	import ghostcat.util.Util;
	
	[Event(name="label_changed",type="ghostcat.events.TimeLineEvent")]
	[Event(name="timeline_end",type="ghostcat.events.TimeLineEvent")]
	
	/**
	 * 这个类用于包装MovieClip的时间线，实现一些扩展功能。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class TimeLine extends EventDispatcher
	{
		/**
		 * 对应的动画对象
		 */
		public var mc:MovieClip;
		
		/**
		 * 帧方法字典
		 */
		public var metords:Dictionary = new Dictionary();
		
		/**
		 * 上一帧
		 */
		public var prevFrame:int = -1;
		
		/**
		 * 上一个帧标签
		 */
		public var prevLabel:String;
		
		public function TimeLine(mc:MovieClip)
		{
			this.mc = mc;
			mc.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			
			_labels = mc.currentLabels.concat();//currentLabels取值很慢，必须缓存
		}
		
		/**
		 * 当进行到某帧时执行方法
		 * 
		 * @param frame	帧，也可以是Label标签名
		 * @param metord	要执行的方法
		 * 
		 */	
		public function insertMetord(frame:*,metord:Function):void
		{
			if (frame is String)
				frame = getLabelStart(frame);
				
			var mList:Array;
			if (!metords[frame])
			{
				mList = [];
				metords[frame] = mList;
			}
			else
				mList = metords[frame];
			mList.push(metord);
		}
		
		/**
		 * 删除方法
		 * 
		 * @param frame	帧，也可以是Label标签名
		 * @param metord	方法
		 * 
		 */
		public function removeMetord(frame:*,metord:Function=null):void
		{
			if (frame is String)
				frame = getLabelStart(frame);
			
			if (metords[frame])
			{
				var mList:Array = metords[frame];
				if (metord!=null)
				{
					var index:int = mList.indexOf(metord);
					if (index!= -1)
						mList.splice(index,1);
						
					if (mList.length == 0)
						delete metords[frame];
				}
				else
					delete metords[frame];
			}
		}
		
		/**
		 * 当前标签名称
		 * @return 
		 * 
		 */
		 		
		public function get curLabelName():String
		{
			return mc.currentLabel;
		}
		
		private var _labels:Array;
		
		/**
		 * 标签列表，是一个数组，数组元素包括
		 * 
		 * name - 标签名称
		 * frame - 标签的起始帧
		 * 
		 * @return 
		 * 
		 */		
		
		public function get labels():Array
		{
			return _labels;
		}
		
		/**
		 * 取得某个标签的长度
		 * @param labelName		标签名称
		 * @return 
		 */
		 		
		public function getLabelLength(labelName:*):int
        {
            var index:int = getLabelIndex(labelName);
            if (index + 1 < labels.length)
                return labels[index + 1].frame - labels[index].frame;
            return mc.totalFrames - labels[index].frame;
        }
        
        /**
		 * 取得某个标签的起始帧
		 * @param labelName		标签名称
		 * @return 
		 */
		 		
		public function getLabelStart(frame:*):int
        {
            var index:int = getLabelIndex(frame);
            if (index + 1 < labels.length)
                return labels[index].frame;
            return 1;
        }
        
        /**
         * 获取某个标签的序号 
         * @param labelName		标签名称
         * @return 
         */
                 
        public function getLabelIndex(frame:*):int
        {
        	for (var index:int = labels.length - 1;index >= 0;index--) 
            {
            	if (frame is String)
        		{
            		if (labels[index].name == frame)
            	        return index;
         		}
         		else
         		{
            		if (labels[index].frame < frame)
            	        return index;
            	}
            }
            return -1;
        }
        
        /**
         * 跳转到某帧
         * @param frame
         * 
         */
        public function gotoAndStop(frame:Object):void
        {
        	if (frame is String)
        	{
        		var index:int = getLabelIndex(frame.toString());
				if (index != -1)
					mc.gotoAndStop(labels[index].frame);
        	}
        	else if (frame is Number)
        		mc.gotoAndStop(frame);
        }
        
        /**
         * 跳转到某帧播放 
         * @param frame
         * 
         */
        public function gotoAndPlay(frame:Object):void
        {
        	if (frame is String)
        	{
        		var index:int = getLabelIndex(frame.toString());
				if (index != -1)
					mc.gotoAndPlay(labels[index].frame);
        	}
        	else if (frame is Number)
        		mc.gotoAndPlay(frame);
        }
		
		private function enterFrameHandler(event:Event):void
		{
			if (prevFrame == mc.currentFrame)
				return;
				
			if (metords[mc.currentFrame])
			{
				var mList:Array = metords[mc.currentFrame];
				for (var i:int=0;i<mList.length;i++)
					(mList[i] as Function).call(this.mc);
			}
			
			var e:TimeLineEvent;
			
			if (mc.currentLabel != prevLabel)
			{
				e = new TimeLineEvent(TimeLineEvent.LABEL_CHANGED);
				e.prevLabel = prevLabel;
				e.label = mc.currentLabel;
				e.prevFrame = prevFrame;
				e.frame = mc.currentFrame;
				dispatchEvent(e);
			}
			
			if (mc.currentFrame == mc.totalFrames)
			{
				e = new TimeLineEvent(TimeLineEvent.TIMELINE_END);
				e.prevLabel = prevLabel;
				e.label = mc.currentLabel;
				e.prevFrame = prevFrame;
				e.frame = mc.currentFrame;
				dispatchEvent(e);
			}
			
			if (mc.currentFrame == 1)
			{
				e = new TimeLineEvent(TimeLineEvent.TIMELINE_START);
				e.prevLabel = prevLabel;
				e.label = mc.currentLabel;
				e.prevFrame = prevFrame;
				e.frame = mc.currentFrame;
				dispatchEvent(e);
			}
				
			prevFrame = mc.currentFrame;
			prevLabel = mc.currentLabel;
		}
	}
}