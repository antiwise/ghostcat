package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.Oper;
	import ghostcat.operation.effect.AlphaClipEffect;
	import ghostcat.operation.effect.TweenEffect;
	import ghostcat.skin.ComboBoxSkin;
	import ghostcat.ui.UIConst;
	import ghostcat.util.ClassFactory;
	import ghostcat.util.Geom;
	import ghostcat.util.easing.Circ;
	
	/**
	 * 下拉框
	 * 
	 * 标签规则：子对象openButton被转化为展开的按钮，list被转换为列表项，列表项按列表项的方法处理。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GComboBox extends GButton
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(ComboBoxSkin);
		
		public var fields:Object = {listField:"list",openButtonField:"openButton"};
		
		/**
		 * 列表实例
		 */
		public var list:GList;
		
		/**
		 * 展开按钮
		 */
		public var openButton:GButton;
		
		/**
		 * 列表属性
		 */
		public var listData:Array;
		
		/**
		 * 承载List的容器
		 */
		public var listContainer:DisplayObjectContainer;
		
		/**
		 * List展开特效
		 */
		public var listOpenEffect:TweenEffect;
		
		private var _maxLine:int = 6;

		/**
		 * 最大显示List条目
		 * @return 
		 * 
		 */
		public function get maxLine():int
		{
			return _maxLine;
		}

		public function set maxLine(v:int):void
		{
			_maxLine = v;
			if (list)
				list.height = list.rowHeight * maxLine;
		}
		
		public function GComboBox(skin:*=null, replace:Boolean=true, separateTextField:Boolean = false, textPos:Point=null,fields:Object=null)
		{
			if (!skin)
				skin = defaultSkin;
			
			if (fields)
				this.fields = fields;
				
			super(skin, replace, separateTextField, textPos);
		}
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean=true) : void
		{
			super.setContent(skin,replace);
			
			var listField:String = fields.listField;
			var openButtonField:String = fields.openButtonField;
			
			openButton = new GButton(content[openButtonField]);
			
			list = new GList(content[listField],true,UIConst.VERTICAL);
			list.width = this.width;
			list.height = list.rowHeight * maxLine;
			
			if (list.parent)
				list.parent.removeChild(list);
			
			if (!listOpenEffect)
				listOpenEffect = new AlphaClipEffect(list,300,AlphaClipEffect.UP,Circ.easeOut);
			else
				listOpenEffect.target = list;
		}
		/** @inheritDoc*/
		protected override function mouseDownHandler(event:MouseEvent) : void
		{
			super.mouseDownHandler(event);
		
			var listPos:Point = Geom.localToContent(new Point(),this,listContainer)
			list.x = listPos.x;
			list.y = listPos.y + content.height;
			list.data = listData;
			list.addEventListener(Event.CHANGE,listChangeHandler);
			
			this.listContainer.addChild(list);
			
			if (listData.length > maxLine)
				list.addVScrollBar();
			
			
			if (listOpenEffect.step == Oper.RUN)
				listOpenEffect.result();
				
			listOpenEffect.invert = true;
			listOpenEffect.execute();
		}
		/** @inheritDoc*/
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
				if (s == list || (list && s == list.vScrollBar) || s == this)
					return;
				s = s.parent;
			}
			
			hideList();
		}
		
		private function listChangeHandler(event:Event):void
		{
			this.data = list.selectedData;
			
//			hideList();
		}
		
		private function hideList():void
		{
			if (list.parent == listContainer)
			{
				listOpenEffect.invert = false;
				listOpenEffect.addEventListener(OperationEvent.OPERATION_COMPLETE,hideListCompleteHandler);
				listOpenEffect.execute();
			}
		}
		
		private function hideListCompleteHandler(event:OperationEvent):void
		{
			(event.currentTarget as AlphaClipEffect).removeEventListener(OperationEvent.OPERATION_COMPLETE,hideListCompleteHandler);
			if (list.parent == listContainer)
			{
				list.removeVScrollBar();
				this.listContainer.removeChild(list);
			}
		}
		/** @inheritDoc*/
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