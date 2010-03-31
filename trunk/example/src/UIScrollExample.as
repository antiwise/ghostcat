package
{
	import flash.display.Sprite;
	
	import ghostcat.display.GBase;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.controls.GList;
	import ghostcat.ui.controls.GText;
	import ghostcat.util.easing.Circ;
	
	[SWF(width="400",height="400")]
	/**
	 * 此类用于演示List，所以加入了一个百万条的数据源。单单生成它就需要耗费数秒时间。
	 * 这个List拥有完美的缓动效果
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class UIScrollExample extends Sprite
	{
		public function UIScrollExample()
		{	
			var list:GList = new GList();
			list.type = UIConst.TILE;
			list.itemRender = GButton;
			list.width = 300;
			list.height = 150;
			
//			var arr:ObjectProxy = new ObjectProxy([]);
			var arr:Array = [];//这里用ObjectProxy可以实现动态修改数据
			for (var i:int = 0;i < 1000001;i++)
				arr.push(i);
			
			list.data = arr;
			
			addChild(list);
			//加入滚动条
			list.addVScrollBar();
			list.vScrollBar.blur = 2;
			list.vScrollBar.easing = Circ.easeOut;
			
//			arr[2] = "动态修改数据";
			
			//也可以直接创建GScrollBar并设置target实现，但这种滚动条将不会随着容器移动
			//如果target是普通Sprite也是可以的，它会被自动包装成ScrollPanel。
		}
	}
}