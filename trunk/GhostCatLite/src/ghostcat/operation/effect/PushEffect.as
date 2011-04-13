package ghostcat.operation.effect
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import ghostcat.operation.Oper;
	import ghostcat.operation.TweenOper;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.ui.UIConst;
	import ghostcat.util.ReflectUtil;
	import ghostcat.util.display.Geom;
	import ghostcat.util.easing.TweenEvent;
	import ghostcat.util.easing.TweenUtil;
	
	/**
	 * 用自己将缓存的原对象推开的效果，用来处理单元件的内容切换
	 * @author flashyiyi
	 * 
	 */
	public class PushEffect extends TweenOper
	{
		public var ease:Function;
		public var direct:String;
		public var applyScrollRect:Boolean;
		
		private var cacheBitmap:Bitmap;
		public function PushEffect(target:*=null,duration:int=100,direct:String = "left", ease:Function=null,applyScrollRect:Boolean = false)
		{
			super(target,duration);
			
			this._target = target;
			this.duration = duration;
			this.ease = ease;
			this.direct = direct;
			this.applyScrollRect = applyScrollRect;
		}
		
		/** @inheritDoc*/
		public override function execute() : void
		{
			if (!params)
				params = new Object();
			params.ease = ease;
			
			cacheBitmap = new DrawParse(this.target).createBitmap()
			target.parent.addChild(cacheBitmap);
			
			if (applyScrollRect)
				target.parent.scrollRect = Geom.getRect(target);
			
			switch (direct)
			{
				case UIConst.LEFT:
					params.x = target.x;
					target.x += target.width;
					break;
				case UIConst.RIGHT:
					params.x = target.x;
					target.x -= target.width;
					break;
				case UIConst.UP:
					params.y = target.y;
					target.y += target.height;
					break;
				case UIConst.DOWN:
					params.y = target.y;
					target.y -= target.height;
					break;
			}
			
			super.execute();
			
			tween.addEventListener(TweenEvent.TWEEN_UPDATE,tweenUpdate);
		}
		
		private function tweenUpdate(event:TweenEvent):void
		{
			var rect:Rectangle = Geom.getRect(tween.target);
			switch (direct)
			{
				case UIConst.LEFT:
					cacheBitmap.x = rect.x - rect.width;
					break;
				case UIConst.RIGHT:
					cacheBitmap.x = rect.x + rect.width;
					break;
				case UIConst.UP:
					cacheBitmap.y = rect.y - rect.height;
					break;
				case UIConst.DOWN:
					cacheBitmap.y = rect.y + rect.height;
					break;
			}
		}
		
		protected override function end(event:*=null):void
		{
			if (cacheBitmap)
			{
				cacheBitmap.bitmapData.dispose();
				cacheBitmap.bitmapData = null;
				cacheBitmap.parent.removeChild(cacheBitmap);
				
			}
			if (tween)
			{
				tween.removeEventListener(TweenEvent.TWEEN_UPDATE,tweenUpdate);
				if (applyScrollRect)
					(tween.target as DisplayObject).parent.scrollRect = null;
			}
			super.end();
		}
	}
}