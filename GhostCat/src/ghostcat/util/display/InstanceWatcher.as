package ghostcat.util.display
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import ghostcat.events.InstanceEvent;

	[Event(name="instance_create",type="ghostcat.events.InstanceEvent")]
	[Event(name="instance_destory",type="ghostcat.events.InstanceEvent")]
	/**
	 * 管理动态显示对象自动创建取消事件
	 * @author flashyiyi
	 * 
	 */
	public class InstanceWatcher extends EventDispatcher
	{
		public var mc:DisplayObjectContainer;
		public var objects:Array;
		
		public var clearWhenLabelChange:Boolean = false;
		
		private var ins:Object = {};
		private var insStates:Object = {};
		
		private var prevLabel:String;
		
		
		public function InstanceWatcher(mc:DisplayObjectContainer,objects:Array = null)
		{
			this.mc = mc;
			this.mc.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			
			this.objects = objects;
		}
		
		private function enterFrameHandler(event:Event):void
		{
			var evt:InstanceEvent;
			if (objects && mc)
			{
				if (clearWhenLabelChange && mc is MovieClip && (mc as MovieClip).currentLabel != prevLabel)
				{
					prevLabel = (mc as MovieClip).currentLabel;
					clear();
				}
				
				for each (var s:String in objects)
				{
					if (!insStates[s])
					{
						ins[s] = SearchUtil.findChildByProperty(mc,"name",s);
						if (ins[s])
						{
							insStates[s] = true;
						
							evt = new InstanceEvent(InstanceEvent.INSTANCE_CREATE);
							evt.instance = ins[s];
							evt.instanceName = s;						
							this.dispatchEvent(evt);
						}
					}
					else if (insStates[s])
					{
						if (!ins[s] || !ins[s].parent || !ins[s].parent[s])
						{
							delete insStates[s];
						
							evt = new InstanceEvent(InstanceEvent.INSTANCE_DESTORY);
							evt.instanceName = s;						
							this.dispatchEvent(evt);
						}
					}
				}
			}
		}
		
		public function clear():void
		{
			ins = {};
		}
		
		public function destory():void
		{
			if (this.mc)
				this.mc.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
	}
}