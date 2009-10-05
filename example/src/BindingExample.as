package
{
	import flash.display.Sprite;
	
	import ghostcat.manager.RootManager;
	import ghostcat.ui.containers.GAlert;
	
	import mx.binding.utils.BindingUtils;
	
	/**
	 * FlexLite是将FLEX部分类抽取出来的产物，加载这个库只会增加4.7K的体积，
	 * 就可以启用FLEX的绑定机制。
	 * 
	 * 但如果就是在FLEX环境下，就不要加载这个库了，可能会出现冲突。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BindingExample extends Sprite
	{
		[Bindable]public var a:Array;
		
		private var _b:Array;
		
		public function get b():Array
		{
			return _b;
		}

		public function set b(v:Array):void
		{
			GAlert.show("属性b的setter被触发了："+v,"结果");
			_b = v;
		}
		
		public function BindingExample()
		{
			RootManager.register(this);
			
			GAlert.show("使用数据绑定功能必须引入flexlite.swc，它会给你的SWF增加3K的体积");
			GAlert.show("BindingUtils.bindProperty(this,'b',this,'a')","开始");
			GAlert.show("第一次绑定会首先更新一次值");
			
			BindingUtils.bindProperty(this,"b",this,"a");
			//以后会给属性a赋值，并查看b的同步情况
			
			GAlert.show("a = [1]","设置");
			
			a = [1];
			
			GAlert.show("a = [2]","设置");
			
			a = [2];
			
			GAlert.show("a = [1,2]","设置");
			
			a = [1,2];
			
			GAlert.show("a.push(3)","设置");
			
			a.push(3);
			
			GAlert.show("什么也没有发生","结果");
			GAlert.show("由于只是数组内部改变，需要手动触发\nBindingUtils.dispatchChangeEvent(this,'a')","设置");
			
			BindingUtils.dispatchChangeEvent(this,"a");
		}

	}
}