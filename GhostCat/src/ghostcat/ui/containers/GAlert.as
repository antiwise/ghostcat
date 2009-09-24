package ghostcat.ui.containers
{
	import ghostcat.events.ItemClickEvent;
	import ghostcat.skin.AlertSkin;
	import ghostcat.ui.PopupManager;
	import ghostcat.ui.UIBuilder;
	import ghostcat.ui.controls.GImage;
	import ghostcat.ui.controls.GText;
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
		public static var defaultButtons:Array = ["确认","取消"];

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
		public static function show(text:String,title:String = null,buttons:Array = null,icon:*=null,closeHandler:Function = null):GAlert
		{
			if (!buttons)
				buttons = defaultButtons;
			
			var alert:GAlert = new GAlert();
			alert.title = title;
			alert.text = text;
			alert.iconSprite.source = icon;
			alert.buttonBar.data = buttons;
			
			if (closeHandler!=null)
				alert.buttonBar.addEventListener(ItemClickEvent.ITEM_CLICK,closeHandler,false,0,true);
			
			PopupManager.instance.showPopup(alert);
			
			return alert;
		}
		
		private var _title:String;
		private var _text:String;
		
		public var titleTextField:GText;
		public var textTextField:GText;
		public var iconSprite:GImage;
		public var buttonBar:GButtonBar;
		
		public function GAlert(skin:*=null, replace:Boolean=true, paused:Boolean=false, fields:Object=null)
		{
			if (!skin)
				skin = defaultSkin;
				
			super(skin, replace, paused);
		}
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
//			var titleField:String = panelFields.titleField;
//			var textField:String = panelFields.textField;
//			var iconField:String = panelFields.iconField;
//			var buttonBarField:String = panelFields.buttonBarField;
//			
//			if (content.hasOwnProperty(titleField))
//				titleSprite = new GText(content[titleField])
//			
//			if (content.hasOwnProperty(textField))
//				textSprite = new GText(content[textField])
//				
//			if (content.hasOwnProperty(iconField))
//				iconSprite = new GImage(content[iconField])
//			
//			if (content.hasOwnProperty(buttonBarField))
//			{
//				buttonBar = new GButtonBar(content[buttonBarField])
//				buttonBar.addEventListener(ItemClickEvent.ITEM_CLICK,closeHandler,false,0,true);
//			}
			UIBuilder.buildAll(this);
		}
		
		private function closeHandler(event:ItemClickEvent):void
		{
			close();
		}
	}
}