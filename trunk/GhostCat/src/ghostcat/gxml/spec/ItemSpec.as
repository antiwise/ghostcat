package ghostcat.gxml.spec
{
	import flash.events.IEventDispatcher;

	/**
	 * 这个解析器在Spec的基础上增加了设置外部ID和自动监听事件的功能（事件都是弱引用）
	 * 初始化的时候需要将作为反射依据的对象写入构造函数
	 * 
	 * <f:Sprite xmlns:f="flash.display" id="skin" on_click="clickHandler"/>
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ItemSpec extends Spec
	{
		public function ItemSpec(root:*=null)
		{
			super(root);
		}
		
		public override function createObject(xml:XML):*
		{
			var id:String;
			var handlers:Object = {};
			for each (var item:XML in xml.attributes())
			{
				var name:String = item.name().toString();
				if (name == "id")
				{
					id = item.toString();
					delete xml["@"+name];
				}
				else if (name.substr(0,3)=="on_")
				{
					handlers[name.substr(3)] = item.toString();
					delete xml["@"+name];
				}
				
			}
			
			var obj:* = super.createObject(xml);
			
			if (root && id)
				root[id] = obj;//如果设置了ID属性，创建的对象将会创建指定的外部引用
			
			if (root is IEventDispatcher)
			{
				for (var key:String in handlers)
					(root as IEventDispatcher).addEventListener(key,root[handlers[key]],false,0,true); 
			}
			
			return obj;
		}
	}
}