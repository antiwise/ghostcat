package ghostcat.operation
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import ghostcat.display.transition.TransitionLayerBase;

	/**
	 * 过渡操作
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TransitionOper extends Oper
	{
		/**
		 * 过渡对象 
		 */
		public var transition:TransitionLayerBase;
		/**
		 * 过渡对象容器
		 */
		public var container:DisplayObjectContainer;
		public function TransitionOper(transition:TransitionLayerBase = null,container:DisplayObjectContainer = null)
		{
			super();
			this.transition = transition;
			this.container = container;
		}
		
		public override function execute() : void
		{
			super.execute();
			
			transition.createTo(container);
			transition.addEventListener(Event.COMPLETE,result);
		}
		
		protected override function end(event:*=null) : void
		{
			super.end(event);
			
			transition.removeEventListener(Event.COMPLETE,result);
		}
	}
}