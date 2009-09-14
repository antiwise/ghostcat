package
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import ghostcat.ui.containers.ScrollPanel;
	import ghostcat.util.easing.Back;
	import ghostcat.util.easing.Elastic;
	
	[SWF(width="400",height="400")]
	public class UIScrollExample extends Sprite
	{
		public function UIScrollExample()
		{	
			var t:Sprite = new TestCollision();
			addChild(t);
			
			var s:ScrollPanel = new ScrollPanel(t,new Rectangle(0,0,100,100));
			addChild(s);
			s.addHScrollBar();
			s.hScrollBar.easing = Back.easeOut;
			s.addVScrollBar();
			s.vScrollBar.easing = Elastic.easeOut;
			s.vScrollBar.blur = 4;
			//也可以直接创建GScrollBar并设置target实现，但这个滚动条将不会随着容器移动
			//如果target是普通Sprite也是可以的，它会被自动包装成ScrollPanel。但如果你连续对一个Sprite多次设置滚动条的话，
			//会不断的包装ScrollPanel，虽然显示还是正常的。。。
		}
	}
}