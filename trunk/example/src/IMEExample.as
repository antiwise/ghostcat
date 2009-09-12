package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import ghostcat.manager.RootManager;
	import ghostcat.text.IME;
	import ghostcat.ui.ToolTipSkin;
	import ghostcat.ui.controls.GText;
	import ghostcat.util.Geom;
	import ghostcat.util.Util;

	[SWF(width="500",height="400")]
	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	public class IMEExample extends Sprite
	{
		[Embed(source = "pinyin.txt",mimeType="application/octet-stream")]
		public var pinyin:Class;
		public var ime:IME;
		
		public var textInput1:TextField;
		public var textInput2:TextField;
		public function IMEExample()
		{
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(event:Event):void
		{
			RootManager.register(this,1,1);
			
			textInput1 = Util.createObject(TextField,{type:TextFieldType.INPUT,width:300,height:50,background:true,border:true,wordWrap:true,multiline:true}) as TextField;
			addChild(textInput1);
			Geom.centerIn(textInput1,stage);
			textInput2 = Util.createObject(TextField,{type:TextFieldType.INPUT,width:300,height:50,background:true,border:true,wordWrap:true,multiline:true}) as TextField;
			addChild(textInput2);
			
			var skin:GText = new ToolTipSkin();
			addChild(skin);
			
			ime = new IME(new pinyin().toString(),skin);
			ime.register(textInput1);
			ime.register(textInput2);
		}
	}
}
