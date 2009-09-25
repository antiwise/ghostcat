package
{
	
	import ghostcat.skin.ScrollUpButtonSkin;ScrollUpButtonSkin;
	import ghostcat.skin.cursor.CursorGroup;CursorGroup;
	TestHuman;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import ghostcat.gxml.spec.DisplaySpec;
		
	import ghostcat.gxml.GXMLManager;
	import flash.events.MouseEvent;
	import ghostcat.manager.DragManager;
	import ghostcat.debug.Debug;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.manager.RootManager;
	import ghostcat.ui.containers.GAlert;

	[SWF(width="800",height="400")]
	/**
	 * 反序列化XML例子
	 * 
	 * 使用命名空间以及自定义解析器，可以用XML轻松表示出任何一种类型的对象结构。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GXMLExample extends Sprite
	{
		public var button:DisplayObject;
		public function GXMLExample()
		{
			RootManager.register(this);
			
			var rotation:Number = 90;
			var xml:XML = <skin:ScrollUpButtonSkin xmlns:skin="ghostcat.skin" xmlns:fi="flash.filters"
							id="button" x="50" y="50" on_mouseDown="mouseDownHandler">
								<filters>
									<fi:BlurFilter blurX="4" blurY="4"/>
									<fi:DropShadowFilter color="0x0000FF"/>
								</filters>
								<TestHuman rotation={rotation}/>
								<cursor:CursorGroup xmlns:cursor="ghostcat.skin.cursor"/>
							</skin:ScrollUpButtonSkin>;
			
			GAlert.show("使用命名空间以及自定义解析器，可以用XML轻松表示出任何一种类型的对象结构","由XML创建");
			new TextFieldParse(xml.toXMLString()).parse(this);
			GXMLManager.instance.create(xml,new DisplaySpec(this));
			
			addChild(button);//由于指定了id，这个时候button已经被自动实例化了
		}
		
		public function mouseDownHandler(event:MouseEvent):void
		{
			DragManager.startDrag(button);
		}
	}
}