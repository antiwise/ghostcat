package
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.display.GBase;
	import ghostcat.display.movieclip.FrameLabelUtil;
	import ghostcat.display.movieclip.GBitmapMovieClip;
	import ghostcat.display.movieclip.GMovieClipBase;
	import ghostcat.events.TickEvent;
	import ghostcat.manager.RootManager;
	import ghostcat.util.display.BitmapSeparateUtil;

	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	[SWF(width="600",height="450")]
	/**
	 * 行走
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class WalkExample extends GBase
	{
		//九宫格帧标签
		private const labelNames:Array = [
			"leftup","up","rightup",
			"left",null,"right",
			"leftdown","down","rightdown",
		];
		
		//鼠标偏移量
		private const mouseOffest:Point = new Point(-30,-80);
		
		[Embed(source="stand.png")]
		public var stand:Class;
		[Embed(source="walk.png")]
		public var walk:Class;
		
		public var man:GMovieClipBase;//人物对象
		public var mouseDown:Boolean = false;//鼠标是否按下
		
		protected override function init():void
		{
			new EnabledSWFScreen(stage);
			
			RootManager.register(this);//注册舞台（非必须）
			
			//切割图形
			var source:Array = BitmapSeparateUtil.separateBitmapData(new stand().bitmapData,56,91).concat(BitmapSeparateUtil.separateBitmapData(new walk().bitmapData,67,91));
			//动画分段
			var labels:Array = FrameLabelUtil.createFromObject({
				"down":1,"left":9,"right":17,"up":25,
				"leftdown":33,"rightdown":41,"leftup":49,"rightup":57,
				"walkdown":65,"walkleft":73,"walkright":81,"walkup":89,
				"walkleftdown":97,"walkrightdown":105,"walkleftup":113,"walkrightup":121
			});
			
			//创建动画对象
			man = new GBitmapMovieClip(source,labels);
			man.frameRate = 10;
			addChild(man);
			
			this.enabledTick = true;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			this.mouseDown = true;
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			this.mouseDown = false;
			var name:String = man.curLabelName;
			//去掉状态的walk前缀，切换到相应的停止状态
			if (name.indexOf("walk") == 0)
				changeState(name.substr(4));
		}
		
		protected override function tickHandler(event:TickEvent) : void
		{
			if (!mouseDown)
				return;
			
			var cur:Point = man.position;//当前坐标
			var tar:Point = new Point(mouseX,mouseY).add(mouseOffest);//目标坐标
			var p:Point = tar.subtract(cur);//坐标差值
			
			//在原来的方向上走一段距离
			var step:Number = event.interval / 5;
			if (p.length > step)
				p.normalize(step);
			man.position = man.position.add(p);
			
			//根据差值计算朝向状态
			var newState:String = labelNames[
				(p.x < -Math.abs(p.y / 2) ? 0 : p.x >  Math.abs(p.y / 2) ? 2 : 1) + 
				(p.y <  -Math.abs(p.x / 2)  ? 0 : p.y >  Math.abs(p.y / 2) ? 6 : 3)
			];
			if (newState)
			{
				newState = "walk" + newState;
				changeState(newState);
			}
		}
		
		private function changeState(state:String):void
		{
			if (man.curLabelName == state)
				return;
			
			var oldFrame:int = man.frameInLabel;
			man.setLabel(state);//切换动画状态
			man.frameInLabel = oldFrame;//拷贝上一次的动画位置
		}
	}
}