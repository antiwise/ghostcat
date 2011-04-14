package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.display.graphics.DragPoint;
	
	/**
	 * 调整相对位置控件
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class GRule extends DragPoint
	{
		public var leftPanel:DisplayObject;
		public var rightPanel:DisplayObject;
		public var topPanel:DisplayObject;
		public var bottomPanel:DisplayObject;
		
		public function GRule(skin:*=null,point:Point=null,replace:Boolean=true,
							  leftPane:DisplayObject = null,rightPanel:DisplayObject = null,
							  topPanel:DisplayObject = null,bottomPanel:DisplayObject = null)
		{
			super(skin,point,replace);
			
			this.leftPanel = leftPane;
			this.rightPanel = rightPanel;
			this.topPanel = topPanel;
			this.bottomPanel = bottomPanel;
		}
		
		protected override function updatePosition() : void
		{
			super.updatePosition();
			
			var rect:Rectangle = this.getRect(parent);
			
			if (this.leftPanel)
			{
				this.leftPanel.width = rect.x - this.leftPanel.x;
			}
				
			if (this.rightPanel)
			{
				this.rightPanel.width += this.rightPanel.x - rect.right;
				this.rightPanel.x = rect.right;
			}
			
			if (this.topPanel)
			{
				this.topPanel.height = rect.y - this.topPanel.y;
			}
			
			if (this.bottomPanel)
			{
				this.bottomPanel.height += this.bottomPanel.y - rect.bottom;
				this.bottomPanel.y = rect.bottom;
			}
		}
	}
}