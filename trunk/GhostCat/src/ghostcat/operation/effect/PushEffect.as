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
	import ghostcat.util.display.DisplayUtil;
	import ghostcat.util.display.Geom;
	import ghostcat.util.easing.TweenEvent;
	import ghostcat.util.easing.TweenUtil;
	
	/**
	 * 用自己将缓存的原对象推开的效果，用来处理单元件的内容切换
	 * 需要先执行效果再修改目标状态
	 * @author flashyiyi
	 * 
	 */
	public class PushEffect extends TweenOper
	{
		public var ease:Function;
		public var direct:String;
		public var applyScrollRect:Boolean;
		
		private var cacheBitmap:Bitmap;
		public function PushEffect(target:*=null,duration:int=1000,direct:String = "left", ease:Function=null,applyScrollRect:Boolean = false)
		{
			super(target,duration);
			
			this._target = target;
			this.duration = duration;
			this.ease = ease;
			this.direct = direct;
			this.applyScrollRect = applyScrollRect;
		}
		
		/**
		 * 预先缓存屏幕，执行它后可以先修改状态，然后调用execute
		 * 
		 */
		public function cacheTarget():void
		{
			cacheBitmap = new DrawParse(this.target).createBitmap();
			DisplayUtil.addChildBefore(cacheBitmap,this.target);
		}
		
		/** @inheritDoc*/
		public override function execute() : void
		{
			if (!params)
				params = new Object();
			params.ease = ease;
			
			if (!cacheBitmap)
				cacheTarget();
			
			if (applyScrollRect)
				target.parent.scrollRect = Geom.getRect(target);
			
			//设置target当前的位置和缓动的坐标
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
			//让缓存图片同步移动
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