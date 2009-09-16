package
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import ghostcat.ui.containers.GScrollPanel;
	import ghostcat.ui.controls.GList;
	import ghostcat.util.ObjectProxy;
	
	[SWF(width="400",height="400")]
	public class UIScrollExample extends Sprite
	{
		public function UIScrollExample()
		{	
			var list:GList = new GList();
			list.type = GList.TILE;
			list.width = 100;
			list.columnWidth = 50;
			list.rowHeight = 30;
			
			var arr:ObjectProxy = new ObjectProxy(new Array());
			for (var i:int = 0;i < 1000000;i++)
				arr.push(i.toString());
			 
			list.data = arr;
			
			var s:GScrollPanel = new GScrollPanel(list,new Rectangle(0,0,80,100));
			addChild(s);
			
			s.addVScrollBar();
			s.vScrollBar.blur = 2;
			
			arr[2] = "动态修改数据源";
			
			//也可以直接创建GScrollBar并设置target实现，但这个滚动条将不会随着容器移动
			//如果target是普通Sprite也是可以的，它会被自动包装成ScrollPanel。但如果你连续对一个Sprite多次设置滚动条的话，
			//会不断的包装ScrollPanel，虽然显示还是正常的。。。
		}
	}
}