package
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import ghostcat.debug.DebugRect;
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.debug.FPS;
	import ghostcat.display.GBase;
	import ghostcat.display.bitmap.BitmapScreen;
	import ghostcat.display.bitmap.GBitmap;
	import ghostcat.display.viewport.Tile45;
	import ghostcat.display.viewport.TileGameLayer;
	import ghostcat.manager.DragManager;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.ui.CursorSprite;
	import ghostcat.util.Util;
	
	
	
	[SWF(width="600",height="600",frameRate="60")]
	
	/**
	 * 45度场景
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapTile45Example extends GBase
	{
		public const MAX_SIZE:int = 1000;
		public var mapData:Array;
		public var man:GBitmap;
		public var game:TileGameLayer;
		public var debugText:TextField;
		
		public function BitmapTile45Example()
		{
			new EnabledSWFScreen(stage)
			
			stage.addChild(new FPS())
			
			debugText = TextFieldParse.createTextField("",new Point(0,20));
			stage.addChild(debugText);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,moveMoveHandler);
			
			mapData = [];
			for (var i:int = 0;i < MAX_SIZE;i++)
			{
				mapData.push([]);
				for (var j:int = 0;j < MAX_SIZE;j++)
					mapData[i].push((Math.random() < 0.5) ? 0 : 1)
			}
			
			game = new TileGameLayer(mapData,Util.createObject(new Tile45(),{contentRect:new Rectangle(0,0,200,100)}),createTileItemHandler,new BitmapScreen(600,600,false));
			addChild(game);
			game.tileLayer.cursor = CursorSprite.CURSOR_DRAG;
			
			var v:DebugRect = new DebugRect(600,600,0);
			v.alpha = 0;
			addChild(v);
			DragManager.register(v,game.tileLayer);
			
			man = new GBitmap(new TestHuman())
			game.addItem(man);
			man.x = 50;
			man.y = 50;
			man.cursor = CursorSprite.CURSOR_DRAG;
			DragManager.register(man);
			
			man = new GBitmap(new TestHuman())
			game.addItem(man);
			man.x = 100;
			man.y = 100;
			man.cursor = CursorSprite.CURSOR_DRAG;
			DragManager.register(man);
			
			stage.addChild(new CursorSprite())//加入鼠标
		}
		
		protected function createTileItemHandler(d:*):GBitmap
		{
			if (d)
			{
				var v:GBitmap = new GBitmap(new TileObj());
				return v;
			}
			else
				return null
		}
		
		protected function moveMoveHandler(event:MouseEvent):void
		{
			var v:DisplayObject = event.target as DisplayObject;
			debugText.text = game.tileLayer.getItemPointAtPoint(new Point(game.mouseX,game.mouseY)).toString();
			debugText.appendText("\n目前实例数:"+game.sortEngine.data.length)
		}
		
	}
}