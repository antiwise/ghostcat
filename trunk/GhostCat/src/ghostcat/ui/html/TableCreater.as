package ghostcat.ui.html
{
	import ghostcat.debug.Debug;
	import ghostcat.gxml.spec.DisplaySpec;
	import ghostcat.ui.controls.GText;
	import ghostcat.util.ReflectUtil;
	
	/**
	 * Table构建器。增加了名称转换和将文本直接转化为GText
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TableCreater extends DisplaySpec
	{
		public function TableCreater(root:* = null)
		{
			super(root);
		}
		/** @inheritDoc */
		public override function createObject(xml:XML) : *
		{
			if (xml.nodeKind()!="text")
			{
				var name:String = xml.localName().toString().toLowerCase();
				switch (name)
				{
					case "td":
						xml.setName(ReflectUtil.getQName(TdTag));
						break;
					case "tr":
						xml.setName(ReflectUtil.getQName(TrTag));
						break;
					case "table":
						xml.setName(ReflectUtil.getQName(TableTag));
						break;
				}
			}
			
			return super.createObject(xml);
		}
		/** @inheritDoc */
		public override function addChild(source:*, child:*, xml:XML) : void
		{
			if (xml.nodeKind()=="text" && source is TdTag)//如果父标签是TD则转换为GText
			{
				var ui:GText = new GText();
				ui.enabledAdjustTextFieldWidth = true;
				ui.text = child;
				super.addChild(source,ui,<GText/>);
			}
			else
			{
				super.addChild(source,child,xml);
			}
		}
	}
}