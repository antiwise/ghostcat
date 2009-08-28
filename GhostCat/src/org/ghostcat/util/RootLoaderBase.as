package org.ghostcat.util
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;

	[Event(name="init",type="flash.events.Event")]
	
	[Event(name="complete",type="flash.events.Event")]
	
	[Event(name="progress",type="flash.events.ProgressEvent")]
	
	/**
	 * 和FLEX类似的二帧自加载方法，可以自行实现立即显示的Loading进度条，即使是在一个全部由代码组成的SWF中。
	 * 这是一个原型类，并没有提供进度条相关代码。请继承此类，并在构造函数里添加进度条，并监听progress事件修改进度，在complete事件里删除进度条。
	 * 
	 * 此类必须在支持元标签的环境内使用。在入口类上加上元标签[Frame(factoryClass="org.ghostcat.ui.RootLoader")]即可。你也可以自己继承此类定义进度条。
	 * 
	 * 由于层次的变化，原来的主类已经无法在构造函数内引用到stage了，这点要注意。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class RootLoaderBase extends MovieClip
	{
		public function RootLoaderBase()
		{	
			this.stop();
			
			root.loaderInfo.addEventListener(Event.INIT, rootInitHandler);
			root.loaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
		
		private function rootInitHandler(event:Event):void
		{
			dispatchEvent(event);
			
			root.loaderInfo.removeEventListener(Event.INIT, rootInitHandler);
			
			this.addEventListener(Event.ENTER_FRAME,frameEnterHandler);
		}
		
		
		private function frameEnterHandler(event:Event = null):void
		{
			if(this.currentFrame == 2)
			{
				this.removeEventListener(Event.ENTER_FRAME,this.frameEnterHandler);
				root.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		
				dispatchEvent(new Event(Event.COMPLETE));
				
				loadComplete();
			}
			else
			{
				if (currentFrame < this.framesLoaded)
				{
					this.nextFrame();
				}
			}
		}
		
		private function progressHandler(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
		
		/**
		 * 完成载入，实例化主场景时执行的方法。可以重写这个方法以显示一段进入主场景的动画。
		 * 
		 */		
		protected function loadComplete():void 
		{
			var name:String = this.loaderInfo.loaderURL.match(/[^\/]*\.swf/i)[0];
			var urlArr:Array = name.split(/\/+|\\+|\.|\?/ig);
        	name = decodeURI(urlArr[urlArr.length - 2]);
			
			stage.removeChild(this);
			stage.addChild(new (getDefinitionByName(name) as Class));
		}
	}
}


