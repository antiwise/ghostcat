package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.text.TextFormat;
	
	import ghostcat.debug.Debug;
	import ghostcat.debug.FPS;
	import ghostcat.events.TickEvent;
	import ghostcat.game.BitmapGameViewport;
	import ghostcat.game.GameViewport;
	import ghostcat.game.layer.GameLayer;
	import ghostcat.game.layer.camera.BoxsGridCamera;
	import ghostcat.game.layer.camera.SimpleCamera;
	import ghostcat.game.layer.position.Tile45PositionManager;
	import ghostcat.game.layer.sort.SortYManager;
	import ghostcat.game.util.GameMoveByPathOper;
	import ghostcat.manager.RootManager;
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.controls.GCheckBox;
	import ghostcat.ui.controls.GText;
	import ghostcat.util.Tick;
	import ghostcat.util.Util;
	import ghostcat.util.display.BitmapSeparateUtil;
	
	[SWF(width="800",height="600",frameRate="60",backgroundColor="0xFFFFFF")]
	public class GhostCatGameExample extends Sprite
	{
		static public var instanse:GhostCatGameExample;
		
		public const RUNX:Array = [ 0,-1, 1, 0,-1, 1,-1, 1];
		public const RUNY:Array = [ 1, 0, 0,-1, 1, 1,-1,-1];
		
		public var STAGE_W:int;
		public var STAGE_H:int;
		public var viewportRect:Rectangle;
		public var MAX_RUNNER:int;
		
		[Embed(source="walk.png")]
		public var walk:Class;

		public var source:Array;
		public var layer:GameLayer;
		public var viewport:GameViewport;
		
		//UI
		
		public var renderBN:GCheckBox;
		public var boxsGridBN:GCheckBox;
		public var sortBN:GCheckBox;
		public var positionBN:GCheckBox;
		public var stageWText:GText;
		public var stageHText:GText;
		public var runnerNumText:GText;
		public var confirmBN:GButton;
		
		
		public function GhostCatGameExample()
		{
			RootManager.register(this);
			this.scrollRect = new Rectangle(0,0,800,600);
			stage.addChildAt(new Bitmap(new BitmapData(800,600,false,0xFFFFFF)),0);
			
			instanse = this;
			source = BitmapSeparateUtil.separateBitmapData(new walk().bitmapData,67,91);
			
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
			
			this.createUI();
			this.init(false,true,true,false,5000,4000,2000);
		}
		
		protected function createUI():void
		{
			addChild(new Bitmap(new BitmapData(80,180,false,0xFFFFFF)));
			addChild(new FPS());
			
			this.renderBN = Util.createObject(GCheckBox,{label:"单位图",y:20});
			addChild(this.renderBN);
			
			this.boxsGridBN = Util.createObject(GCheckBox,{label:"剔除对象",y:35,selected:true});
			addChild(this.boxsGridBN);
			
			this.sortBN = Util.createObject(GCheckBox,{label:"景深排序",y:50,selected:true});
			addChild(this.sortBN);
			
			this.positionBN = Util.createObject(GCheckBox,{label:"45度坐标",y:65});
			addChild(this.positionBN);
			
			addChild(Util.createObject(GText,{text:"场景宽度：",y:80}));
			addChild(Util.createObject(GText,{text:"场景高度：",y:110}));
			addChild(Util.createObject(GText,{text:"人物数量：",y:140}))
			
			this.stageWText = Util.createObject(GText,{text:"5000",editable:true,y:95});
			this.stageWText.applyTextFormat({underline : true},true);
			addChild(stageWText);
			
			this.stageHText = Util.createObject(GText,{text:"4000",editable:true,y:125});
			this.stageHText.applyTextFormat({underline : true},true);
			addChild(stageHText);
			
			this.runnerNumText = Util.createObject(GText,{text:"2000",editable:true,y:155});
			this.runnerNumText.applyTextFormat({underline : true},true);
			addChild(runnerNumText);
			
			this.confirmBN = Util.createObject(GButton,{label:"确认",width:80,y:175});
			this.confirmBN.addEventListener(MouseEvent.CLICK,confirmBNHandler);
			addChild(confirmBN);
			
		}
		
		private function confirmBNHandler(event:MouseEvent):void
		{
			var n1:int = int(stageWText.text)
			var n2:int = int(stageHText.text)
			var n3:int = int(runnerNumText.text)
				
			if (n1 && n2 && n3)
				this.init(renderBN.selected,sortBN.selected,boxsGridBN.selected,positionBN.selected,n1,n2,n3);
		}
		
		
		public function init(isBitmapEngine:Boolean,isSort:Boolean,isBoxsGrid:Boolean,is45:Boolean,stageW:int,stageH:int,runnerNum:int):void
		{
			if (viewport)
			{
				viewport.destory();
				removeChild(viewport);
			}
			
			this.STAGE_W = stageW;
			this.STAGE_H = stageH;
			this.viewportRect = new Rectangle(-33,-80,STAGE_W + 67 * 2,STAGE_H + 91 * 2);
			this.MAX_RUNNER = runnerNum;
			
			viewport = isBitmapEngine ? new BitmapGameViewport(800,600) : new GameViewport();
			addChildAt(viewport,0);
			
			layer = new GameLayer();
			layer.sort = isSort ? new SortYManager(layer) : null;
			layer.position = is45 ? new Tile45PositionManager(1,0.5) : null;
			layer.camera = isBoxsGrid ? new BoxsGridCamera(layer,new Rectangle(-100,-100,1000,800),viewportRect,400,300) : new SimpleCamera(layer);
			viewport.addLayer(layer);
			
			for (var i:int = 0;i < MAX_RUNNER;i++)
			{
				var item:Runner = new Runner(int(Math.random() * 8));
				item.camera = layer.camera;
				item.position = new Point(Math.random() * viewportRect.width  + viewportRect.x,
										Math.random() * viewportRect.height + viewportRect.y);
				layer.addObject(item);
				layer.setObjectPosition(item,item.position);
			}
		}
		
		protected function tickHandler(event:TickEvent):void
		{	
			for each (var item:Runner in layer.children)
			{
				var position:Point = item.position;
				
				position.x += RUNX[item.type] * event.interval / 20;
				position.y += RUNY[item.type] * event.interval / 20;
				
				if (position.x < viewportRect.x)
					position.x = viewportRect.right;
				
				if (position.y < viewportRect.y)
					position.y = viewportRect.bottom;
				
				if (position.x > viewportRect.right)
					position.x = viewportRect.x;
				
				if (position.y > viewportRect.bottom)
					position.y = viewportRect.y;
				
				this.layer.setObjectPosition(item,position);
				
				if (this.layer.childrenInScreenDict[item])
				{
					item.tick(event.interval);
				}
			}
			
			this.layer.camera.setPosition(mouseX / 800 * (STAGE_W - 800),mouseY / 600 * (STAGE_H - 600));
		}
	}
}

import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.media.Sound;
import flash.utils.ByteArray;

import ghostcat.events.TickEvent;
import ghostcat.game.item.BitmapMovieGameItem;
import ghostcat.game.layer.position.IPositionManager;
import ghostcat.util.Tick;

class Runner extends BitmapMovieGameItem
{
	public var type:int;
	public var position:Point;
	public function Runner(type:int)
	{
		super(null, 10);
		
		this.regX = 33;
		this.regY = 80;
		this.setType(type);
		this.randomFrameTimer();
		this.enabledTick = false;
	}
	
	public function setType(type:int):void
	{
		this.type = type;
		this.bitmapDatas = GhostCatGameExample.instanse.source.slice(type * 8,type * 8 + 8);
		this.currentFrame = 0;
	}
}