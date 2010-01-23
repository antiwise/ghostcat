package ghostcat.operation
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import ghostcat.ui.PopupManager;

	/**
	 * 弹出窗口操作
	 * @author flashyiyi
	 * 
	 */
	public class PopupOper extends Oper
	{
		public var popup:DisplayObject;
		public var owner:DisplayObject;
		public var modal:Boolean;
		public var centerMode:String;
		public var offest:Point;
		
		public function PopupOper(popup:DisplayObject=null,owner:DisplayObject=null,modal:Boolean = true,centerMode:String = "rect",offest:Point = null)
		{
			super();
			
			this.popup = popup;
			this.owner = owner;
			this.modal = modal;
			this.centerMode = centerMode;
			this.offest = offest;
		}
		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();
			
			popup.addEventListener(Event.REMOVED_FROM_STAGE,result);
			PopupManager.instance.showPopup(popup,owner,modal,centerMode,offest);
		}
		/** @inheritDoc*/
		protected override function end(event:* = null) : void
		{
			super.end(event);
			
			popup.removeEventListener(Event.REMOVED_FROM_STAGE,result);
		}
	}
}