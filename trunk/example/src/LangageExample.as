package
{
	import ghostcat.display.GSprite;
	import ghostcat.manager.LanguageManager;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.FunctionOper;
	import ghostcat.operation.effect.LightOnceEffect;
	import ghostcat.ui.PopupManager;
	import ghostcat.ui.containers.GAlert;
	import ghostcat.ui.controls.GText;

	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	
	/**
	 * 下面是几个多语言的例子
	 * 
	 * 固定动态文本的多语言有个最简单的办法，就是在原来的文本框上写上文本标示，
	 * 那么在被转换为GText之后会自动转换为相应语言版本
	 * 
	 * 顺便演示下队列系统
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class LangageExample extends GSprite
	{
		public static function get roll():String
		{
			return int(Math.random() * 100).toString();
		}
		
		protected override function init():void
		{
			RootManager.register(this,1,1);
			PopupManager.instance.applicationDisabledFilters = [];
			
			LanguageManager.instance.register(this);
			LanguageManager.instance.load("ui.lang");
			LanguageManager.instance.customConversion = {"roll":"#LangageExample.roll"}
		
			//语言包载入也是使用的默认queue，因此下面的方法会在加载完语言包后再执行
			new FunctionOper(step1).commit();
		}
		
		private function step1():void
		{
			//自动替换文本
			var t:GText = new GText();
			addChild(t);
			t.text = "@ui.ok";
			
			new LightOnceEffect(t,1000).commit();
			GAlert.show("text = '@ui.ok'","自动替换文本");
			//Alert一样是默认使用默认queue的，下面的方法会在Alert结束后再执行
			new FunctionOper(step2).commit();
		}	
	
		private function step2():void
		{
			var t2:GText = new GText();
			addChild(t2);
			t2.y = 26;
			t2.text = "@canel";//不写文件名则取第一个满足条件的
			
			new LightOnceEffect(t2,1000).commit();
			GAlert.show("text = '@canel'","不写文件名则取第一个满足条件的");
			new FunctionOper(step3).commit();
		}	
	
		private function step3():void
		{
			var t3:GText = new GText();
			addChild(t3);
			t3.y = 52;
			t3.vertical = true;//顺带看看竖行显示
			t3.text = LanguageManager.getString("@ui.tipText",["一段文本"]);
			
			new LightOnceEffect(t3,1000).commit();
			GAlert.show("text = LanguageManager.getString('@ui.tipText',['一段文本']);","手动设置需要参数的文本");
			new FunctionOper(step4).commit();
		}	
	
		private function step4():void
		{
			var t4:GText = new GText();
			addChild(t4);
			t4.x = 50
			t4.y = 50;
			t4.text = "@ui.roll";
			
			new LightOnceEffect(t4,1000).commit();
			GAlert.show("text = '@ui.roll'\n文本里的参数会从最开始注册的静态方法里取","自动替换参数");
		}
	}
}