package ghostcat.operation.effect
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import ghostcat.operation.TweenOper;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.util.display.Geom;
	
	/**
	 * 缓存位图并从一个固定位置缩放，类似操作系统任务栏的展开效果 
	 * @author flashyiyi
	 * 
	 */
	public class ZoomFromRectEffect extends TweenOper
	{
		public var asBitmap:Boolean;
		
		private var sourceTarget:*;
		private var bitmap:Bitmap;
		
		public override function get target() : *
		{
			return sourceTarget;
		}
		
		public override function set target(v:*) : void
		{
			sourceTarget = v;
		}
		
		public function ZoomFromRectEffect(target:*=null, rect:Rectangle=null, duration:int=100, easing:Function = null, invert:Boolean=true,asBitmap:Boolean = true,clearTarget:int = 0)
		{
			this.asBitmap = asBitmap;
			this.target = target;
			
			if (!rect)
			{
				rect = Geom.getRect(target);
				var sw:Number = rect.width / 10;
				var sh:Number = rect.height / 10;
				rect = new Rectangle(rect.x + (rect.width - sw) / 2,rect.y + (rect.height - sh) / 2,sw,sh)
			}
			
			var para:Object;
			if (asBitmap)
			{
				this.bitmap = new Bitmap();
				para = {x:rect.x,y:rect.y,scaleX:rect.width / target.width,scaleY:rect.height / target.height,ease:easing};
			}
			else
			{
				var targetRect:Rectangle = Geom.getRect(target,target);
				var sx:Number = targetRect.x / targetRect.width;
				var sy:Number = targetRect.y / targetRect.height;
				para = {x:rect.x - sx * rect.width,y:rect.y - sy * rect.height,scaleX:rect.width / target.width,scaleY:rect.height / target.height,ease:easing};
			}
			super(asBitmap ? bitmap : target, duration, para, invert,clearTarget);
		}
		
		public override function execute() : void
		{
			if (asBitmap)
			{
				//缩放时缓存位图
				var temp:Bitmap = new DrawParse(sourceTarget).createBitmap();
				this.bitmap.x = temp.x;
				this.bitmap.y = temp.y;
				this.bitmap.bitmapData = temp.bitmapData;
				this.sourceTarget.visible = false;
				(this.sourceTarget as DisplayObject).parent.addChild(bitmap);
			}
			
			super.execute();
			
		}
		
		public override function result(event:*=null) : void
		{
			if (asBitmap)
			{
				if (bitmap.parent)
					bitmap.parent.removeChild(bitmap);
				
				if (bitmap.bitmapData)
					this.bitmap.bitmapData.dispose();
				
				this.bitmap.bitmapData = null;
				this.sourceTarget.visible = true;
			}
			
			super.result(event);
		}
	}
}