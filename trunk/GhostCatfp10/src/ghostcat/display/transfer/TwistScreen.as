package ghostcat.display.transfer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
    import ghostcat.display.filter.FilterProxy;
    import ghostcat.events.TickEvent;
    import ghostcat.operation.FunctionOper;
    import ghostcat.operation.Queue;
    import ghostcat.operation.SetPropertyOper;
    import ghostcat.operation.TweenOper;
    import ghostcat.util.Tick;
    import ghostcat.util.easing.Cubic;
    import ghostcat.util.easing.TweenUtil;
    
    public class TwistScreen extends Bitmap
    {
		[Embed(source="twist.pbj",mimeType="application/octet-stream")]
		private static var shaderClass:Class;
		private static var shaderData:ByteArray = new shaderClass() as ByteArray;
		
		private var shaderFilter:ShaderFilter;
		private var shader:Shader;
		private var tween:Object;
		
		public var size:Number;
		public var waveSize:Number;
		public var angle:Number;
		public var interval:Number;
		
		public var targets:Array;
		
		private var _enabledTick:Boolean;

		public function get enabledTick():Boolean
		{
			return _enabledTick;
		}

		public function set enabledTick(value:Boolean):void
		{
			if (_enabledTick == value)
				return;
			
			_enabledTick = value;
			if (value)
				Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
			else
				Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
		}

		
        public function TwistScreen(targets:Array,size:int,waveSize:int = 30,angle:int = 120,interval:Number = 0.2)
        {
			this.targets = targets;
			this.size = size;
			this.waveSize = waveSize;
			this.angle = angle;
			this.interval = interval;
			
			var w:Number = Math.floor(Math.sqrt(size * size + size * size) * 4);
			super(new BitmapData(w,w,true,0))
			
			this.shader = new Shader(shaderData);
			this.shader.data.radius.value = [0];
			this.shader.data.angle.value = [0];
			this.shader.data.wave.value = [this.waveSize];
			this.shader.data.waveInterval.value = [0];
			this.shader.data.center.value = [this.bitmapData.width / 2, this.bitmapData.height / 2];
			this.shaderFilter = new ShaderFilter(this.shader);
		}
		
		public function setCenterPosition(x:Number,y:Number):void
		{
			this.x = x - this.bitmapData.width / 2;
			this.y = y - this.bitmapData.height / 2;
		}

       	public function show():void
        {
			this.tween = {angle:0, radius:0, wave:this.waveSize, waveInterval:0, waveMotion:0};
			
			new Queue([
				new SetPropertyOper(this,{enabledTick:true}),
				new TweenOper(this.tween,500,{waveInterval:this.interval, radius:this.size,ease:Cubic.easeOut}),
				new TweenOper(this.tween,650,{angle:this.angle,ease:Cubic.easeInOut})
			]).execute();
		}

        public function hide(destoryed:Boolean = true):void
        {
			var list:Array = [
				new TweenOper(this.tween,1000,{angle:0,ease:Cubic.easeInOut}),
				new TweenOper(this.tween,300,{waveInterval:0, radius:0,ease:Cubic.easeIn})
			];
			if (destoryed)
				list.push(new FunctionOper(destory))
			else
				list.push(new SetPropertyOper(this,{enabledTick:false}))
			
			new Queue(list).execute();
        }
		
		public function destory():void
		{
			this.enabledTick = false;
			this.parent.removeChild(this);
		}
		
		protected function tickHandler(e:TickEvent):void
		{
			if (!stage)
				return;
			
		    this.tween.waveMotion++;
			
			
			this.shader.data.angle.value = [this.tween.angle];
            this.shader.data.radius.value = [this.tween.radius];
            this.shader.data.wave.value = [this.tween.wave];
            this.shader.data.waveInterval.value = [this.tween.waveInterval];
            this.shader.data.waveMotion.value = [this.tween.waveMotion];
			
			this.bitmapData.fillRect(this.bitmapData.rect,0xFF000000);
			for each (var target:DisplayObject in targets)
			{
				var m:Matrix = this.transform.concatenatedMatrix;
				m.invert();
				m.concat(target.transform.concatenatedMatrix);
				this.bitmapData.draw(target,m,null,null,this.bitmapData.rect);
			}
			this.filters = [shaderFilter];
		}
	}
}


