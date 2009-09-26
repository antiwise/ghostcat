package
{
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	
	import ghostcat.display.GSprite;
	import ghostcat.filter.FilterProxy;
	import ghostcat.gxml.GXMLManager;
	import ghostcat.gxml.spec.ItemSpec;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.DelayOper;
	import ghostcat.operation.Queue;
	import ghostcat.operation.RepeatOper;
	import ghostcat.operation.TweenOper;
	import ghostcat.parse.display.RectParse;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.util.easing.Elastic;
	
	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	[SWF(width="800",height="400")]
	/**
	 * 在这里演示如何利用GXML和Oper系统创建自定义Tween
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GXMLExample2 extends GSprite
	{
		public var queue:Queue;
		public var s:Sprite;
		public var f:FilterProxy;
		RectParse;
		BlurFilter;
		TweenOper;
		DelayOper;
		RepeatOper;
		Elastic;
		
		protected override function init():void
		{
			RootManager.register(this);
			
			var sxml:XML =
				<p:RectParse xmlns:p="ghostcat.parse.display" xmlns:g="ghostcat.parse.graphics">
					<!-- 图形定义 -->
					<constructor>
						<g:GraphicsRect>
							<constructor>
								0,0,100,100,10
							</constructor>
						</g:GraphicsRect>
						{null}
						<g:GraphicsFill>
							<constructor>
								0xFFFFFF
							</constructor>
						</g:GraphicsFill>
					</constructor>
				</p:RectParse>
			
			var xml:XMLList = 
			<>
				<!-- 滤镜代理 -->
				<f:FilterProxy id="f" xmlns:f="ghostcat.filter" xmlns:b="flash.filters">
					<constructor>
						<b:BlurFilter>
							<constructor>
								0,0
							</constructor>
						</b:BlurFilter>
					</constructor>
				</f:FilterProxy>
				<!-- 移动 -->
				<o:Queue id="queue" xmlns:o="ghostcat.operation">
					<data>
						<o:TweenOper target="{s}" duration="1000">
							<!-- 因为XML无法判断是字符串还是数字，所以这里的都将是相对坐标 -->
							<params>
								<Object x="100" tint="0xFF0000" ease="{ghostcat.util.easing::Elastic.easeOut}"/>
							</params>
						</o:TweenOper>
						<o:TweenOper target="{s}" duration="1000">
							<params>
								<Object x="-100" tint="0x0000FF" ease="{ghostcat.util.easing::Elastic.easeOut}"/>
							</params>
						</o:TweenOper>
						<o:RepeatOper>
							<list>
								<o:TweenOper target="{f}" duration="1000">
									<params>
										<Object blurX="20" blurY="20"/>
									</params>
								</o:TweenOper>
								<o:TweenOper target="{f}" duration="1000">
									<params>
										<Object blurX="-20" blurY="-20"/>
									</params>
								</o:TweenOper>
							</list>
						</o:RepeatOper>
					</data>
				</o:Queue>
			</>
			
			new TextFieldParse(xml.toXMLString()).parse(this);
			
			s = GXMLManager.instance.create(sxml,new ItemSpec(this)).createSprite();
			addChild(s);
			
			GXMLManager.instance.exec(xml,new ItemSpec(this));
			f.applyFilter(s);
			queue.execute();
		}
	}
}