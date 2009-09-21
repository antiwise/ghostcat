package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.ui.UIConst;
	import ghostcat.util.Geom;
	
	public class GComboBox extends GButton
	{
		public var fields:Object = {listField:"list"}
		
		public var list:GList;
		
		/**
		 * 承载List的容器
		 */
		public var listContainer:DisplayObjectContainer;
		
		private var _selectedData:*;
		
		public override function get label():String
		{
			return _selectedData;
		}
		
		public override function set label(v:String):void
		{
			_selectedData = v;
		}
		
		public function get selectedData():*
		{
			return _selectedData;
		}

		public function set selectedData(v:*):void
		{
			_selectedData = v;
		}

		public function GComboBox(skin:*, replace:Boolean=true, separateTextField:Boolean = false, textPos:Point=null,fields:Object=null)
		{
			if (fields)
				this.fields = fields;
			
			super(skin, replace, separateTextField, textPos);
		}
		
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			var listField:String = fields.listField;
			
			if (content.hasOwnProperty(listField))
			{
				list = new GList(content[listField],true,UIConst.VERTICAL);
				list.width = this.width;
				list.height = list.rowHeight * 6;
				
				list.parent.removeChild(list);
			}
		}
		
		protected override function mouseDownHandler(event:MouseEvent) : void
		{
			super.mouseDownHandler(event);
		
			var listPos:Point = Geom.localToContent(new Point(),list,listContainer)
			list.x = listPos.x;
			list.y = listPos.y;
			list.data = data;
			list.addEventListener(Event.CHANGE,listChangeHandler);
			
			this.listContainer.addChild(list);	
		}
		
		protected override function init():void
		{
			super.init();
			
			if (!this.listContainer)
				this.listContainer = this.root as DisplayObjectContainer;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,stageMouseDownHandler);
		}
		
		private function stageMouseDownHandler(event:Event):void
		{
			var s:DisplayObject = event.target as DisplayObject;
			while (s.parent && s.parent != s.stage)
			{
				if (s == list)
					break;
				s = s.parent;
			}
			
			if (s == list && list.parent == listContainer)
				this.listContainer.removeChild(list)
		}
		
		private function listChangeHandler(event:Event):void
		{
			this.selectedData = list.selectedData;
			
			if (list.parent == listContainer)
				this.listContainer.removeChild(list)
		}
		
		public override function destory() : void
		{
			if (stage)
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,stageMouseDownHandler);
			
			super.destory();
			
			if (list)
			{
				list.removeEventListener(Event.CHANGE,listChangeHandler);
				list.destory();
			}
		}
	}
}