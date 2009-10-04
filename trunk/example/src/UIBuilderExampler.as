package 
{
	import ghostcat.display.GSprite;
	import ghostcat.display.other.BubbleCreater;
	import ghostcat.display.other.CircleLight;
	import ghostcat.manager.RootManager;
	import ghostcat.ui.PopupManager;
	import ghostcat.ui.containers.GAlert;
	
	[SWF(width="500",height="400")]
	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	public class UIBuilderExampler extends GSprite
	{
		protected override function init():void
		{
			RootManager.register(this);
			
			addChild(new BubbleCreater(500,400));
			addChild(new CircleLight(250));
			
			PopupManager.instance.applicationDisabledOper = null;
			
			GAlert.show("UIBuilder是GhostCat非常重要的一个创新点。具体用法可参照系统里的GAlert和GDebugPanel组件，这里不再提供示例。","创新点")
			GAlert.show("您只需要在自定义组件里按约定的名称写上子组件的属性，大部分时候只需要执行UIBuilder.buildAll就可以自动完成所有组件转化工作，之后你只需要设置事件和处理组件逻辑就可以了。不需要XML定义，也不需要设置大小和位置。","使用反射进行简化");
			GAlert.show("GhostCat的推荐皮肤方案就是直接将图元转化为组件，Builder所做的只是这个操作的自动化：\n自动查询皮肤，自动查询可实例化的组件，自动实例化。","自动");
			GAlert.show("这种方案需要美工在设计FLA时按一定约束进行分层和命名，这个难点是可以克服的。之后美工只需要提供组件的名字和类型，然后程序员简单的写成属性就可以了（有些复杂组件需要设置参数），之后程序基本不需要再调整。程序不再需要关心位置，大小，层次和具体的显示效果。","约定");
			GAlert.show("这一切现在全部由美工自己控制。如果皮肤采用SWF载入，他们甚至可以实时调整。操作仅仅是输出皮肤SWF，然后运行。\n他们不再需要瞎着眼睛设计，所有的修改都能立即得到回馈，这会让他们更愿意修改和调整界面，使之变得更漂亮，用户体验更好。","积极性");
			GAlert.show("<html><font color='#FF0000'>更重要的是，现在时间线动画可以保留了！</font>\n这个Alert的显示和消失就是使用的动画。\n动画可以充分发挥FLASH的优势，并且让那些“JS也能做，银光也很好”的支持者们永远地闭上他们的嘴。</html>","支持动画");
			GAlert.show("组件内使用动画应注意两个限制：\n1.组件本身不能在动画帧上，只能在动画帧上变化的电影剪辑的内部\n2.内部存在组件的动画帧必须在时间线上一直存在","组件动画的限制");
			
			
		}
	}
}