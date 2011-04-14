package ghostcat.gxml.jsonspec
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.ui.containers.GView;

	/**
	 * 显示对象解析器
	 * 
	 * 只增加了addChild子对象的功能
	 * {classRef:"flash.display::Sprite",children:[{classRef:"flash.display::Shape"}]}
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class JSONDisplaySpec extends JSONItemSpec
	{
		public function JSONDisplaySpec(root:*=null)
		{
			super(root);
		}
		/** @inheritDoc */
		public override function addChild(source:*,child:*,value:*):void
		{
			if (child is Array && source is DisplayObjectContainer && value == "children")
			{
				var container:DisplayObjectContainer = source as DisplayObjectContainer;
				for (var i:int = 0;i < child.length;i++) 
					container.addChild(child[i]);
			}
			else
				super.addChild(source,child,value);
			
		}
	}
}