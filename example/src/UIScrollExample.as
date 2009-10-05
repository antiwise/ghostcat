package
{
	import flash.display.Sprite;
	
	import ghostcat.ui.UIConst;
	import ghostcat.ui.controls.GList;
	import ghostcat.util.data.ObjectProxy;
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
			list.width = 150;
			list.height = 150;
			
			list.type = UIConst.TILE;//设置为平铺
			
			var arr:ObjectProxy = new ObjectProxy([]);//这里用普通Array也可以，但必须用这个才能实现动态修改数据
			for (var i:int = 0;i < 1000000;i++)
				arr.push(i.toString());
			 
			list.data = arr;
			
			addChild(list);
			//加入滚动条
			list.addVScrollBar();
			list.vScrollBar.blur = 2;
			list.vScrollBar.easing = Circ.easeOut;
			
			arr[2] = "动态修改数据";
			
			//也可以直接创建GScrollBar并设置target实现，但这种滚动条将不会随着容器移动
			//如果target是普通Sprite也是可以的，它会被自动包装成ScrollPanel。
		}
	}
}