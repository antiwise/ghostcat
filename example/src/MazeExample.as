package 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import ghostcat.algorithm.maze.MazeCreater;
	import ghostcat.algorithm.traversal.AStar;
	import ghostcat.algorithm.traversal.BFS;
	import ghostcat.algorithm.traversal.MapModel;
	import ghostcat.algorithm.traversal.Traversal;
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.display.bitmap.GBitmap;
	import ghostcat.manager.RootManager;
	import ghostcat.parse.display.TextFieldParse;
	
	/**
	 * 随机地图生成
	 * 
	 * @author flashyiyi
	 * 
	 */	
	
	[SWF(width="500",height="500")]
	public class MazeExample extends Sprite
	{
		private const MAP_WIDTH : int = 50;
		private const MAP_HEIGHT : int = 50;
		
		private var screen : GBitmap;
		private var playPoint : Point;
		private var map : Array;
		
		private var aStar : Traversal;
		private var mapModel : MapModel;
		
		private var path : Array;
		private var debugText:TextField;
		
		public function MazeExample()
		{
			new EnabledSWFScreen(stage)
			
			RootManager.register(this,1,1);
			
			screen = new GBitmap(new BitmapData(MAP_WIDTH,MAP_HEIGHT));
			screen.enabledScale = true;
			screen.scaleX = screen.scaleY = 4;
			addChild(screen);
			
			debugText = new TextFieldParse(null,new Point(0,410)).createTextField();
			addChild(debugText);
			
			this.mapModel = new MapModel();
			this.reset();
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(Event.ENTER_FRAME, enterframeHandler);
		}
		
		private function reset() : void
		{
			this.map = [];
			
			var maze:MazeCreater = new MazeCreater(MAP_WIDTH,MAP_HEIGHT);
			maze.find(new Point(0,0),new Point(MAP_WIDTH - 1,MAP_HEIGHT - 1));
			this.map = maze.boolMap;
			
			this.playPoint = new Point(1,1);
			this.mapModel.map = this.map;//创建地图数据
			
			screen.bitmapData = this.mapModel.toBitmap().bitmapData;
			screen.bitmapData.setPixel(1,1,0xFF0000);

			//在复杂迷宫内A*未必总是比BFS快，因为朝向终点方向前进是最短路径的几率不高，而A*的启发式遍历本身具有消耗
			this.aStar = new AStar(this.mapModel);//根据数据生成A*类
//			this.aStar = new BFS(this.mapModel);//根据数据生成BFS类
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