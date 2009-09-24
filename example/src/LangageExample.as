package
{
	import flash.display.Sprite;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.extend.JSBridge;
	import ghostcat.manager.LanguageManager;
	import ghostcat.manager.RootManager;
	import ghostcat.ui.controls.GText;
	
	/**
	 * 下面是几个多语言的例子
	 * 
	 * 固定动态文本的多语言有个最简单的办法，就是在原来的文本框上写上文本标示，
	 * 那么在被转换为GText之后会自动转换为相应语言版本
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class LangageExample extends Sprite
	{
		public static function get roll():String
		{
			return int(Math.random() * 100).toString();
		}
		
		public function LangageExample()
		{
			RootManager.register(this,1,1);
			LanguageManager.instance.register(this);
			LanguageManager.instance.load("ui.lang").addEventListener(OperationEvent.OPERATION_COMPLETE,init);
			LanguageManager.instance.customConversion = {"roll":"#LangageExample.roll"}
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
			t3.vertical = true;//顺带看看竖行显示
			t3.text = LanguageManager.getString("@ui.tipText",["一段文本"]);
			
			//自动替换参数
			var t4:GText = new GText();
			addChild(t4);
			t4.x = 50
			t4.y = 50;
			t4.text = "@ui.roll";
		}
	}
}