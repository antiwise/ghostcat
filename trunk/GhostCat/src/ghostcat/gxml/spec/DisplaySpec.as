package ghostcat.gxml.spec
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.util.ReflectXMLUtil;

	/**
	 * 显示对象解析器
	 * 
	 * 和FLEX一样，包名需要用namespace定义
	 * 
	 * 这个类对子对象的处理方式是根据首字母大小来判断是增加子对象还是设置属性。
	 *
	 * 诸如：
	 * <f:Sprite xmlns:f="flash.display"><visible>false</visible></f:Sprite>
	 * 最终结果是生成一个visible=false的Sprite，下面这个也是等效的
	 * <f:Sprite xmlns:f="flash.display" visible="false"/>
	 * 
	 * 这样就能添加子对象
	 * <f:Sprite xmlns:f="flash.display"><f:Shape/></f:Sprite>
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class DisplaySpec extends ItemSpec
	{
		public override function createObject(xml:XML,root:*=null):*
		{
			var obj:*;
			if (xml.nodeKind()=="text")
			{
				obj = xml.toString();
			}
			else if (isClass(xml))
			{
				obj = ReflectXMLUtil.XMLToObject(xml,root) as DisplayObject;
				createChildren(obj,xml,root);
			}
			else
			{
				obj = createObject(xml.children()[0],root);
			}
			return obj;
		}
		
		public override function addChild(source:*,child:*,xml:XML,root:*=null):void
		{
			if (isClass(xml) && source is DisplayObjectContainer)
				(source as DisplayObjectContainer).addChild(child as DisplayObject);
			else
				ReflectXMLUtil.setProperty(source,xml.localName().toString(),child);
			
		}
		
		private function isClass(xml:XML):Boolean
		{
			var name:String = xml.localName().toString();
			var firstCode:String = name.charAt(0);
			return firstCode > "A" && firstCode < "Z";
		}
	}
}