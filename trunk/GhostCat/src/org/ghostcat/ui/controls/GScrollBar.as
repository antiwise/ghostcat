package org.ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	
	import org.ghostcat.display.GNoScale;
	
	/**
	 * 滚动条 
	 * @author flashyiyi
	 * 
	 */
	public class GScrollBar extends GNoScale
	{
		public var upArrow:GButton;
		public var downArrow:GButton;
		public var thumb:GButton;
		public var background:DisplayObject;
		
		/**
		 * 滚动缓动效果
		 */
		public var tweenFunction:Function;
		
		/**
		 * 滚动模糊效果
		 */
		public var blur:Number;
		
		public var fields:Object = {upArrowField:"upArrow",downArrowField:"downArrow",
			thumbField:"thumb",backgroundField:"background"}
		
		public function GScrollBar(skin:DisplayObject=null, replace:Boolean=true,fields:Object=null)
		{
			if (fields)
				this.fields = fields;
			
			super(skin, replace);
		}
		
		public override function setContent(skin:DisplayObject, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			var upArrowField:String = fields.upArrowField;
			var downArrowField:String = fields.downArrowField;
			var thumbField:String = fields.thumbField;
			var backgroundField:String =  fields.backgroundField;
			
			if (content.hasOwnProperty(upArrowField))
				this.upArrow = new GButton(content[upArrowField]);
				
			if (content.hasOwnProperty(downArrowField))
				this.downArrow = new GButton(content[downArrowField]);
				
			if (content.hasOwnProperty(thumbField))
				this.thumb = new GButton(content[thumbField]);
				
			if (content.hasOwnProperty(backgroundField))
				this.background = content[backgroundField];
		}
		
		protected override function updateSize() : void
		{
			super.updateSize();
		} 
		
		public override function destory() : void
		{
			super.destory();
			
			if (upArrow) 
				upArrow.destory();
			if (downArrow) 
				downArrow.destory();
			if (thumb) 
				thumb.destory();
		}
	}
}