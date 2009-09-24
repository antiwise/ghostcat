package ghostcat.operation
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
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
		public function PopupOper(popup:DisplayObject,owner:DisplayObject,modal:Boolean = true)
		{
			super();
			
			this.popup = popup;
			this.owner = owner;
			this.modal = modal;
		}
		/** @inheritDoc*/
		public override function execute() : void
		{
			PopupManager.instance.showPopup(popup,owner,modal).addEventListener(Event.REMOVED_FROM_STAGE,result);;
		}
		/** @inheritDoc*/
		public override function result(event:* = null) : void
		{
			super.result(event);
			popup.removeEventListener(Event.REMOVED_FROM_STAGE,result);
		}
	}
}