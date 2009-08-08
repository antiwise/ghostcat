package
{
	import flash.display.Sprite;
	
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
			trace("属性b的setter被触发了：",v);
			_b = v;
		}
		
		public function BindingExample()
		{
			BindingUtils.bindProperty(this,"b",this,"a");
			a = [1];
			a = [2];
			a = [1,2];
			
			a.push(2);
			trace("由于只是数组内部改变，需要手动触发");
			a.push(2);
			BindingUtils.dispatchChangeEvent(this,"a");
		}

	}
}