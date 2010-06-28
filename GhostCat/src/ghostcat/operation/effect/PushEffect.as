package ghostcat.operation.effect
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	import ghostcat.operation.Oper;
	import ghostcat.operation.TweenOper;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.ui.UIConst;
	import ghostcat.util.ReflectUtil;
	import ghostcat.util.easing.TweenEvent;
	import ghostcat.util.easing.TweenUtil;
	
	/**
	 * 用改变状态的新对象推挤缓存的原对象的效果，用来处理单元件的内容切换
	 * @author flashyiyi
	 * 
	 */
	public class PushEffect extends Oper implements IEffect
	{
		protected var _target:*;
		
		/**
		 * 目标
		 * @return 
		 * 
		 */
		public function get target():*
		{
			return _target;
		}
		
		public function set target(v:*):void
		{
			_target = v;
		}
		
		/**
		 * 持续时间
		 */
		public var duration:int;
		public var ease:Function;
		public var direct:String;
		
		private var cacheBitmap:Bitmap;
		public function PushEffect(target:*=null,duration:int=100,direct:String = "left", ease:Function=null,clearTarget:* = 0,immediately:Boolean = false)
		{
			super();
			
			this._target = target;
			this.duration = duration;
			this.immediately = immediately;
			this.ease = ease;
			this.direct = direct;
		}
		
		/** @inheritDoc*/
		public override function execute() : void
		{
			var target:DisplayObject;
			if (_target is String)
				target = ReflectUtil.eval(_target) as DisplayObject;
			else
				target = _target as DisplayObject;
			
			var params:Object = new Object();
			params.ease = ease;
			
			cacheBitmap = new DrawParse(this.target).createBitmap()
			target.parent.addChild(cacheBitmap);
			
			switch (direct)
			{
				case UIConst.LEFT:
					target.x += target.width;
					params.x = (-target.width).toString();
					break;
				case UIConst.RIGHT:
					target.x -= target.width;
					params.x = target.width.toString();
					break;
				case UIConst.UP:
					target.y += target.height;
					params.y = (-target.width).toString();
					break;
				case UIConst.DOWN:
					target.y -= target.height;
					params.y = target.width.toString();
					break;
			}
			
			TweenUtil.removeTween(target,true);
			
			var tween:TweenUtil = new TweenUtil(target,duration,params);
			tween.addEventListener(TweenEvent.TWEEN_END,result);
			tween.update();
			
			var tween2:TweenUtil = new TweenUtil(cacheBitmap,duration,params);
			tween2.update();
			
			super.execute();
		}
		
		protected override function end(event:*=null):void
		{
			if (cacheBitmap)
			{
				cacheBitmap.bitmapData.dispose();
				cacheBitmap.bitmapData = null;
				cacheBitmap.parent.removeChild(cacheBitmap);
			}
			super.end();
		}
	}
}