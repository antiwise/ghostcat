package ghostcat.ui.tooltip
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.skin.ArowSkin;
	import ghostcat.ui.ToolTipSprite;
	import ghostcat.ui.controls.GText;
	import ghostcat.util.ClassFactory;
	import ghostcat.util.TweenUtil;
	import ghostcat.util.easing.Back;
	import ghostcat.util.easing.Circ;

	/**
	 * 根据位置弹出不同方向的ToolTip
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ArowToolTipSkin extends GText implements IToolTipSkin
	{
		public function ArowToolTipSkin()
		{
			super(new ArowSkin(),true,true,new Point(2,2));
			
			this.enabledAdjustContextSize = true;
		}
		
		public function show(target:DisplayObject):void
		{
			
		}
		
		public function positionTo(target:DisplayObject):void
		{
			var toolTipSprite:ToolTipSprite = this.parent as ToolTipSprite;
			toolTipSprite.blendMode = BlendMode.LAYER;
			
			var gRect:Rectangle = target.getRect(toolTipSprite.parent);
			
			if (gRect.x - toolTipSprite.width/2 < 0)//向右
			{
				toolTipSprite.x = gRect.right + 5;
				toolTipSprite.y = gRect.y;
				(content as ArowSkin).point = new Point(-5,0)
			}
			else if (gRect.right + toolTipSprite.width/2 > target.stage.stageWidth)//向左
			{
				toolTipSprite.x = gRect.x - toolTipSprite.width - 5;
				toolTipSprite.y = gRect.y;
				(content as ArowSkin).point = new Point(0,toolTipSprite.width)
			}
			else if (gRect.y - toolTipSprite.height < 0)//向下
			{
				toolTipSprite.x = gRect.x;
				toolTipSprite.y = gRect.bottom + 5;
				(content as ArowSkin).point = new Point(0,-5)
			}
			else //向上
			{
				toolTipSprite.x = gRect.x;
				toolTipSprite.y = gRect.y - toolTipSprite.height - 5;
				(content as ArowSkin).point = new Point(0,toolTipSprite.height)
			}
			
//			TweenUtil.removeTween(toolTipSprite);
//			TweenUtil.from(toolTipSprite,100,{alpha:0.0,y:"10"}).update();
		}
	}
}