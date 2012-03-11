package ghostcat.ui.containers
{
	import ghostcat.display.GBase;
	import ghostcat.operation.effect.PushEffect;
	import ghostcat.ui.UIConst;
	import ghostcat.util.easing.Circ;
	
	/**
	 * 推挤自身实现切换的容器
	 * @author flashyiyi
	 * 
	 */
	public class GPushPanel extends GBase
	{
		public var ease:Function = Circ.easeInOut;
		public var duration:int = 500;
		
		private var effect:PushEffect;
		public var posX:int;
		public var posY:int;
		
		public var applyScrollRect:Boolean = true;
		
		public function GPushPanel(skin:*=null, replace:Boolean=true)
		{
			super(skin, replace);
		}
		
		public function push(direct:String):void
		{
			if (effect)
				effect.submit();
			
			effect = new PushEffect(content,duration,direct,ease,applyScrollRect);
			effect.execute();
		}
		
		public function pushByPostion(x:int,y:int):void
		{
			if (x > posX)
				push(UIConst.LEFT);
			else if (x < posX)
				push(UIConst.RIGHT);
			else if (y > posY)
				push(UIConst.UP)
			else if (y < posY)
				push(UIConst.DOWN);
			else
				return;	
			
			posX = x;
			posY = y;
		}
	}
}