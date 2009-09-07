package
{
	import flash.display.Sprite;
	
	import org.ghostcat.events.OperationEvent;
	import org.ghostcat.extend.JSBridge;
	import org.ghostcat.manager.LanguageManager;
	import org.ghostcat.manager.RootManager;
	import org.ghostcat.ui.controls.GText;
	
	public class LangageExample extends Sprite
	{
		public static function get randomSex():String
		{
			return Math.random() < 0.5 ? "男" : "女";
		}
		
		public function LangageExample()
		{
			RootManager.register(this,1,1);
			LanguageManager.instance.register(this);
			LanguageManager.instance.load("ui.lang").addEventListener(OperationEvent.OPERATION_COMPLETE,init);
			LanguageManager.instance.customConversion = {"sex":"#LangageExample.randomSex"}
		}
		
		private function init(event:OperationEvent):void
		{
			//自动替换文本
			var t:GText = new GText();
			addChild(t);
			t.text = "@ui.ok";
			var t2:GText = new GText();
			addChild(t2);
			t2.y = 26;
			t2.text = "@canel";//不写文件名则取第一个满足条件的
			
			//手动设置需要参数的文本
			var t3:GText = new GText();
			addChild(t3);
			t3.y = 52;
			t3.text = LanguageManager.getString("@ui.tipText",["一段文本"]);
			
			//自动替换参数
			var t4:GText = new GText();
			addChild(t4);
			t4.y = 78;
			t4.vertical = true;
			t4.text = "@ui.sex";
		}
	}
}