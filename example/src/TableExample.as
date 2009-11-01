package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ghostcat.manager.RootManager;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.ui.html.TableCreater;
	
	[SWF(width="600",height="600")]
	
	/**
	 * 表格示例
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TableExample extends Sprite
	{
		public function TableExample()
		{	
			RootManager.register(this);
			
			var xml:XML = <table backgroundColor="#FFFFFF">
								<tr backgroundColor="#FFCCCC">
									<td width="50">
										123sdaf
									</td>
									<td width="50">
										1231232
									</td>
									<td width="50">
										1231232
									</td>
								</tr>
								<tr height="50">
									<td width="100">
										123sdaf
									</td>
									<td width="50">
										1231232
									</td>
								</tr>
								<tr >
									<td width="50" borderColor="#FF0000" backgroundColor="#FF0000">
										123sdaf
									</td>
									<td width="100">
										1231232
									</td>
								</tr>
							</table>
			
			addChild(new TableCreater().createObject(xml));
		
			new TextFieldParse(xml.toXMLString(),new Point(0,100)).parse(this);
		}
	}
}