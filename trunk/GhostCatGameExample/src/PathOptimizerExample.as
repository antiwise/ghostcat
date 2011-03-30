package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import ghostcat.algorithm.maze.BlockUtil;
	import ghostcat.algorithm.traversal.AStar;
	import ghostcat.algorithm.traversal.MapModel;
	import ghostcat.algorithm.traversal.PathOptimizer;
	import ghostcat.algorithm.traversal.Traversal;
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.display.bitmap.GBitmap;
	import ghostcat.manager.RootManager;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.ui.controls.GCheckBox;
	import ghostcat.util.Util;
	
	/**
	 * A* 算法演示
	 * 
	 * @author flashyiyi
	 * 
	 */	
	
	[SWF(width="500",height="525")]
	public class PathOptimizerExample extends Sprite
	{
		private const MAP_WIDTH : int = 20;
		private const MAP_HEIGHT : int = 20;
		
		private var screen : Bitmap;
		private var wayScreen: Bitmap;
		private var wayShape:Shape;
		private var gridShape:Shape;
		private var playPoint : Point;
		private var map : Array;
		
		private var bn1:GCheckBox;
		private var bn2:GCheckBox;
		
		private var aStar : Traversal;
		private var mapModel : MapModel;
		
		private var path : Array;
		
		public function PathOptimizerExample()
		{
			RootManager.register(this,1,1);
			
			screen = new Bitmap(new BitmapData(MAP_WIDTH,MAP_HEIGHT,false));
			screen.scaleX = screen.scaleY = 25;
			screen.y = 25;
			addChild(screen);
			
			wayScreen = new Bitmap(new BitmapData(MAP_WIDTH,MAP_HEIGHT,true,0x0));
			wayScreen.scaleX = wayScreen.scaleY = 25;
			wayScreen.y = 25;
			addChild(wayScreen);
			
			gridShape = BlockUtil.createGridShape(MAP_WIDTH,MAP_HEIGHT,25,0x808080)
			gridShape.y = 25;
			addChild(gridShape)
			
			wayShape = new Shape();
			wayShape.y = 25;
			addChild(wayShape);
			
			bn1 = Util.createObject(GCheckBox,{x:5,y:5,label:"减少节点"});
			addChild(bn1);
			
			bn2 = Util.createObject(GCheckBox,{x:110,y:5,label:"防止贴墙"});
			bn2.selected = true;
			addChild(bn2);
			
			this.mapModel = new MapModel();
			this.reset();
			
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function reset() : void
		{
			this.map = [];
			
			for (var j : int = 0; j < MAP_HEIGHT; j++)
			{
				map[j] = [];
				for (var i : int = 0; i < MAP_WIDTH; i++)
				{
					var isBlock : Boolean = Math.random() < 0.1;
					map[j][i] = isBlock;
					
					this.screen.bitmapData.setPixel(i,j,isBlock ? 0x000000 : 0xFFFFFF);
				}
			}
			
			this.playPoint = new Point();
			
			this.mapModel.map = this.map;//创建地图数据
			this.mapModel.diagonal = false;
			this.aStar = new AStar(this.mapModel);//根据数据生成A*类
		}
		
		private function clickHandler(event : MouseEvent) : void
		{
			if (!screen.getRect(this).contains(event.stageX,event.stageY))
				return;
			
			wayShape.graphics.clear();
			wayShape.graphics.lineStyle(0,0xFF0000);
			wayScreen.bitmapData.fillRect(wayScreen.bitmapData.rect,0);
			
			var start:Point = new Point(int(playPoint.x),int(playPoint.y));
			var end:Point = new Point(int(screen.mouseX),int(screen.mouseY));
			if (start.equals(end))
			{
				wayShape.graphics.moveTo(playPoint.x * 25,playPoint.y * 25);
				wayShape.graphics.lineTo(screen.mouseX * 25,screen.mouseY * 25);
				playPoint = new Point(screen.mouseX,screen.mouseY);
			}
			else
			{
				this.path = this.aStar.find(start, end);//获得行走路径
				if (path && path.length)
				{
					var newpath:Array = PathOptimizer.optimize(path,playPoint,new Point(screen.mouseX,screen.mouseY),bn1.selected,bn2.selected ? 0.2 : 0.0);
					
					p = newpath.shift();
					
					wayShape.graphics.moveTo(p.x * 25,p.y * 25);
					while (newpath.length)
					{
						p = newpath.shift();
						wayShape.graphics.lineTo(p.x * 25,p.y * 25);
					}
					
					while (this.path.length)
					{
						var p:Point = this.path.shift();
						wayScreen.bitmapData.setPixel32(p.x,p.y,0xFFC0C0C0);
					}
					
					playPoint = new Point(screen.mouseX,screen.mouseY);
					
				}
			}
		}
		
		
	}
}