package ghostcat.ui.containers
{
	import ghostcat.display.GSprite;
	import ghostcat.events.ItemClickEvent;
	import ghostcat.manager.DragManager;
	import ghostcat.skin.AlertSkin;
	import ghostcat.ui.PopupManager;
	import ghostcat.ui.UIBuilder;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.controls.GText;
	import ghostcat.ui.layout.LayoutUtil;
	import ghostcat.util.ClassFactory;
	
	/**
	 * 警示框
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GAlert extends GMovieClipPanel
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(AlertSkin);
		/**
		 * 默认按钮 
		 */
		public static var defaultButtons:Array = ["确认"];

		/**
		 * 文字
		 * @return 
		 * 
		 */
		public function get text():String
		{
			return textTextField.text;
		}

		public function set text(v:String):void
		{
			textTextField.text = v;
		}

		/**
		 * 标题 
		 * @return 
		 * 
		 */
		public function get title():String
		{
			return titleTextField.text;
		}

		public function set title(v:String):void
		{
			titleTextField.text = v;
		}
		
		public var closeHandler:Function;
		
		/**
		 * 显示 
		 * @param text	文字
		 * @param title	标题
		 * @param buttons	按钮
		 * @param icon	图标
		 * @param closeHandler	关闭事件
		 * @return 
		 * 
		 */
		public static function show(text:String,title:String = null,buttons:Array = null,closeHandler:Function = null):GAlert
		{
			if (!buttons)
				buttons = defaultButtons;
			
			var alert:GAlert = new GAlert();
			alert.title = title;
			alert.text = text;
			alert.data = buttons;
			alert.centerLayout = true;
			
			alert.closeHandler = closeHandler;
			
			PopupManager.instance.queuePopup(alert);
			
			return alert;
		}
		
		private var _title:String;
		private var _text:String;
		
		public var titleTextField:GText;
		public var textTextField:GText;
		public var buttonBar:GButtonBar;
		public var dragShape:GSprite;
		
		public function GAlert(skin:*=null, replace:Boolean=true, paused:Boolean=false, fields:Object=null)
		{
			if (!skin)
				skin = defaultSkin;
				
			super(skin, replace, paused);
			
			buttonBar.addEventListener(ItemClickEvent.ITEM_CLICK,itemClickHandler);
		}
		
		private function itemClickHandler(event:ItemClickEvent):void
		{
			if (this.closeHandler!=null)
				this.closeHandler(event);
			
			close();
		}
		
		/** @inheritDoc*/
		public override function set data(v:*) : void
		{
			super.data = v;
			
			if (buttonBar)
			{
				this.buttonBar.data = v;
				this.buttonBar.layout.vaildLayout();
				this.buttonBar.autoSize();
				LayoutUtil.silder(buttonBar,this,UIConst.CENTER);
			}
		}
		
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			UIBuilder.buildAll(this);
			
			DragManager.register(dragShape,this);
		}
		
		public override function destory() : void
		{
			buttonBar.removeEventListener(ItemClickEvent.ITEM_CLICK,itemClickHandler);
			DragManager.unregister(dragShape);
			super.destory();
		}
	}
}