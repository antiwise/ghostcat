package 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import ghostcat.algorithm.traversal.AStar;
	import ghostcat.algorithm.traversal.MapModel;
	import ghostcat.algorithm.traversal.Traversal;
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.display.bitmap.GBitmap;
	import ghostcat.manager.RootManager;
	import ghostcat.parse.display.TextFieldParse;
	
	/**
	 * A* 算法演示
	 * 
	 * 这个只实现了算法，并没有专门去选择速度快的类型，也没有刻意减少函数嵌套，因此它的效率很一般。
	 * 但算法本身并没有问题，可以考虑将其解封装，选择数组而不是对象来进行运算，应该能够增加不少速度。
	 * 
	 * 当然，满足需求的话，就不需要了。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	
	[SWF(width="500",height="550")]
	public class AStarExample extends Sprite
	{
		private const MAP_WIDTH : int = 100;
		private const MAP_HEIGHT : int = 100;
		
		private var screen : GBitmap;
		private var playPoint : Point;
		private var map : Array;
		
		private var aStar : Traversal;
		private var mapModel : MapModel;
		
		private var path : Array;
		private var debugText:TextField;
		
		public function AStarExample()
		{
			RootManager.register(this,1,1);
			
			screen = new GBitmap(new BitmapData(MAP_WIDTH,MAP_HEIGHT));
			screen.enableMouseEvent = true;
			screen.enabledScale = true;
			screen.scaleX = screen.scaleY = 5;
			
			addChild(screen);
			
			debugText = new TextFieldParse(null,new Point(0,500)).createTextField();
			addChild(debugText);
			
			this.mapModel = new MapModel();
			this.reset();
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(Event.ENTER_FRAME, enterframeHandler);
		}
		
		private function reset() : void
		{
			this.map = [];
			
			for (var j : int = 0; j < MAP_HEIGHT; j++)
			{
				map[j] = [];
				for (var i : int = 0; i < MAP_WIDTH; i++)
				{
					var isBlock : Boolean = Math.random() < 0.3;
					map[j][i] = isBlock;
					
					screen.bitmapData.setPixel(i,j,isBlock ? 0x000000 : 0xFFFFFF);
				}
			}
			
			this.playPoint = new Point();
			screen.bitmapData.setPixel(0,0,0xFF0000);
			
			this.mapModel.map = this.map;//创建地图数据
			this.aStar = new AStar(this.mapModel);//根据数据生成A*类
		}
		
		private function clickHandler(event : MouseEvent) : void
		{
			var t:int = getTimer();
			this.path = this.aStar.find(playPoint.clone(), new Point(int(screen.mouseX),int(screen.mouseY)));//获得行走路径
			
			if (!this.path)
				debugText.text = "无法到达";
			else
				debugText.text = "本次用时:"+ (getTimer() - t)+"ms";
		}
		
		private function enterframeHandler(event : Event) : void
		{
			if (this.path == null || this.path.length == 0)
				return;
			
			screen.bitmapData.setPixel(playPoint.x,playPoint.y,0xFFFFFF);
			playPoint = this.path.shift() as Point;
			screen.bitmapData.setPixel(playPoint.x,playPoint.y,0xFF0000);
			
		}
	}
}