package ghostcat.ui.html
{
	import ghostcat.gxml.spec.DisplaySpec;
	import ghostcat.ui.controls.GText;
	import ghostcat.ui.layout.Padding;
	
	/**
	 * Table构建器。增加了名称转换和将文本直接转化为GText的功能
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TableCreater extends DisplaySpec
	{
		public function TableCreater(root:* = null)
		{
			super(root);
			
			this.classNames = {
				td:TdTag,
				tr:TrTag,
				table:TableTag
			}
		}
		
		/** @inheritDoc */
		public override function addChild(source:*, child:*, xml:XML) : void
		{
			if (xml.nodeKind()=="text" && source is TdTag)//如果父标签是TD则转换为GText
			{
				var ui:GText = new GText(null,true,true,new Padding(2,2,2,2));
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