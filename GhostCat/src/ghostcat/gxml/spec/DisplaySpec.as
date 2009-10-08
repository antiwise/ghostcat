package ghostcat.gxml.spec
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.ui.containers.GView;

	/**
	 * 显示对象解析器
	 * 
	 * 只增加了addChild子对象的功能
	 * <f:Sprite xmlns:f="flash.display"><f:Shape/></f:Sprite>
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class DisplaySpec extends ItemSpec
	{
		public function DisplaySpec(root:*=null)
		{
			super(root);
		}
		/** @inheritDoc */
		public override function addChild(source:*,child:*,xml:XML):void
		{
			if (source is DisplayObjectContainer && isClass(xml))
			{
				if (source is GView)
					(source as GView).addObject(child as DisplayObject);	
				else
					(source as DisplayObjectContainer).addChild(child as DisplayObject);
			}
			else
				super.addChild(source,child,xml);
			
		}
	}
}