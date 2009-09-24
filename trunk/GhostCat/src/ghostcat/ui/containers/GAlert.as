package ghostcat.ui.containers
{
	import ghostcat.events.ItemClickEvent;
	import ghostcat.ui.PopupManager;
	import ghostcat.ui.controls.GImage;
	import ghostcat.ui.controls.GText;
	import ghostcat.util.Util;
	
	/**
	 * 警示框
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GAlert extends GMovieClipPanel
	{
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
			return textSprite.text;
		}

		public function set text(v:String):void
		{
			textSprite.text = v;
		}

		/**
		 * 标题 
		 * @return 
		 * 
		 */
		public function get title():String
		{
			return titleSprite.text;
		}

		public function set title(v:String):void
		{
			titleSprite.text = v;
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
		
		public var titleSprite:GText;
		public var textSprite:GText;
		public var iconSprite:GImage;
		public var buttonBar:GButtonBar;
		
		public const panelFields:Object = {titleField:"title",textField:"text",iconField:"icon",buttonBarField:"buttonBar"};
		
		public function GAlert(mc:*=null, replace:Boolean=true, paused:Boolean=false, fields:Object=null)
		{
			Util.copy(panelFields,this.fields);
			
			if (fields)
				Util.copy(fields,this.fields);
			
			super(mc, replace, paused, fields);
		}
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			var titleField:String = fields.titleField;
			var textField:String = fields.textField;
			var iconField:String = fields.iconField;
			var buttonBarField:String = fields.buttonBarField;
			
			if (content.hasOwnProperty(titleField))
				titleSprite = new GText(content[titleField])
			
			if (content.hasOwnProperty(textField))
				textSprite = new GText(content[textField])
				
			if (content.hasOwnProperty(iconField))
				iconSprite = new GImage(content[iconField])
			
			if (content.hasOwnProperty(buttonBarField))
			{
				buttonBar = new GButtonBar(content[buttonBarField])
				buttonBar.addEventListener(ItemClickEvent.ITEM_CLICK,closeHandler,false,0,true);
			}
		}
		
		private function closeHandler(event:ItemClickEvent):void
		{
			close();
		}
	}
}