package ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.Oper;
	import ghostcat.operation.effect.AlphaClipEffect;
	import ghostcat.operation.effect.TweenEffect;
	import ghostcat.skin.ComboBoxSkin;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.display.Geom;
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
		
		private var _direction:String = UIConst.DOWN;
		
		/**
		 * 承载List的容器
		 */
		public var listContainer:DisplayObjectContainer;
		
		/**
		 * List展开特效（下）
		 */
		public var listOpenDownEffect:TweenEffect;
		
		/**
		 * List展开特效（上）
		 */
		public var listOpenUpEffect:TweenEffect;
		
		private var listOpenEffect:TweenEffect;//当前打开特效
		
		private var _maxLine:int = 6;

		/**
		 * 弹出下拉框的方向（"up","down"）
		 */
		public function get direction():String
		{
			return _direction;
		}

		public function set direction(value:String):void
		{
			_direction = value;
			listOpenEffect = (value == UIConst.UP) ? listOpenUpEffect : listOpenDownEffect;
		}

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
		
		public function GComboBox(skin:*=null, replace:Boolean=true, separateTextField:Boolean = false, textPadding:Padding=null, fields:Object=null)
		{
			if (!skin)
				skin = defaultSkin;
			
			if (fields)
				this.fields = fields;
				
			super(skin, replace, separateTextField, textPadding);
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
			
			if (!listOpenUpEffect)
				listOpenUpEffect = new AlphaClipEffect(list,300,AlphaClipEffect.DOWN,Circ.easeOut);
			else
				listOpenUpEffect.target = list;
			
			if (!listOpenDownEffect)
				listOpenDownEffect = new AlphaClipEffect(list,300,AlphaClipEffect.UP,Circ.easeOut);
			else
				listOpenDownEffect.target = list;	
		}
		/** @inheritDoc*/
		protected override function mouseDownHandler(event:MouseEvent) : void
		{
			super.mouseDownHandler(event);
		
			var listPos:Point = Geom.localToContent(new Point(),this,listContainer)
			list.data = listData;
			list.addEventListener(Event.CHANGE,listChangeHandler);
			list.x = listPos.x;
			list.y = listPos.y + ((direction == UIConst.UP) ? -list.height : content.height);
			
			this.listContainer.addChild(list);
			
			if (listData.length > maxLine || listData.length == 0)//listData有时候会莫名其妙length = 0，暂时这样处理
				list.addVScrollBar();
			
			listOpenEffect = (direction == UIConst.UP) ? listOpenUpEffect : listOpenDownEffect;
			
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
			(event.currentTarget as EventDispatcher).removeEventListener(OperationEvent.OPERATION_COMPLETE,hideListCompleteHandler);
			if (list.parent == listContainer)
			{
				list.removeVScrollBar();
				this.listContainer.removeChild(list);
			}
		}
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
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