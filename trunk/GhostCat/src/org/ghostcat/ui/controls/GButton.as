package org.ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.ghostcat.display.movieclip.GMovieClip;
	import org.ghostcat.events.ActionEvent;
	import org.ghostcat.util.Util;
	
	[Event(name="change",type="flash.events.Event")]
	
	/**
	 * 按钮
	 * 
	 * 标签规则：up,over,down,disabled,selectedUp,selectedOver,selectedDown,selectedDisabled是按钮的八个状态，
	 * 状态间的过滤为两个标签中间加-，末尾加:start。比如up和over的过滤即为up-over:start
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GButton extends GMovieClip
	{
		public static const LABEL_UP:String = "up";
		public static const LABEL_OVER:String = "over";
		public static const LABEL_DOWN:String = "down";
		public static const LABEL_DISABLED:String = "disabled";
		public static const LABEL_SELECTED_UP:String = "selectedUp";
		public static const LABEL_SELECTED_OVER:String = "selectedOver";
		public static const LABEL_SELECTED_DOWN:String = "selectedDown";
		public static const LABEL_SELECTED_DISABLED:String = "selectedDisabled";
		
		public static const LABELS:Array = [[LABEL_UP,LABEL_SELECTED_UP],
										[LABEL_OVER,LABEL_SELECTED_OVER],
										[LABEL_DOWN,LABEL_SELECTED_DOWN],
										[LABEL_DISABLED,LABEL_SELECTED_DISABLED]];
		private const UP:int = 0;
		private const OVER:int = 1;
		private const DOWN:int = 2;
		private const DISABLED:int = 3;
		
		private var defaultSkin:DisplayObject;//默认skin
		
		private var _toggle:Boolean;
		
		private var _selected:Boolean;
		
		private var _mouseDown:Boolean = false;
		
		private var _mouseOver:Boolean = false;
		
		/**
		 * 自动创建的TextField的初始位置（如果是从skin中创建，此属性无效）
		 */
		public var textPos:Point;
		
		/**
		 * 执行的指令名称
		 */		
		public var action:String;
		
		/**
		 * 鼠标按下时移过是否转换焦点
		 */		
		public var trackAsMenu:Boolean;
		
		/**
		 * 鼠标状态对应的colorTransform变化
		 */		
		public var colorTransforms:Object;
		
		/**
		 * 鼠标状态对应的matrix变化
		 */	
		public var matrixs:Object;
		
		/**
		 * 鼠标状态对应的filters变化
		 */		
		public var filterses:Object;
		
		/**
		 * 鼠标状态对应的skin变化
		 */		
		public var skins:Object;
		
		
		
		private var _label:String;
		private var labelField:GText;
		
		
		public function GButton(skin:MovieClip, replace:Boolean=true, paused:Boolean=false,textPos:Point=null)
		{
			if (textPos)
				this.textPos = textPos;
			
			super(skin, replace, paused);
		}
		
		public function get label():String
		{
			return _label;
		}

		public function set label(v:String):void
		{
			_label = v;
			if (labelField)
				labelField.text = _label;
			else
				refreshLabelField();
		}
		
		public override function set enabled(v:Boolean) : void
		{
			this.mouseChildren = this.mouseEnabled = super.enabled = v;
			tweenTo(v ? UP : DISABLED);
		}
		
		public function refreshLabelField():void
		{
			if (!_label)
				return;
			
			if (labelField)
				labelField.destory();
			
			labelField = new GText(content,false,false,textPos);
			labelField.text = _label;
			addChild(labelField)
		}

		public override function setContent(skin:DisplayObject, replace:Boolean=true):void
		{
			defaultSkin = skin;
			setPartConetent(skin,replace);
		}
		
		public function setPartConetent(skin:DisplayObject, replace:Boolean=true):void
		{
			super.setContent(skin,replace);
			refreshLabelField();
		}
		
		public function set toggle(v:Boolean):void
		{
			_toggle = v;
			if (v)
				addEventListener(MouseEvent.CLICK,toggleClickHandler);
			else
				removeEventListener(MouseEvent.CLICK,toggleClickHandler);
		}
		
		public function get toggle():Boolean
		{
			return _toggle;
		}
		
		public function set selected(v:Boolean):void
		{
			if (_selected == v)
				return;
			
			_selected = v;
			tweenTo(UP);
			
			dispatchEvent(new Event(Event.CHANGE))
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		protected override function init():void
		{
			super.init();
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			addEventListener(MouseEvent.CLICK,clickHandler);
		
			tweenTo(UP);
		}
		
		private function tweenTo(n:int):void
		{
			var next:String = LABELS[n][int(selected)];
			
			if (replace && skins)
			{
				if (skins[next]){
					setPartConetent(skin[next],replace);
				}else{
					setPartConetent(defaultSkin,replace);
				}
			}
			
			if (replace && matrixs) 
			{
				if (matrixs[next]){
					content.transform.matrix = matrixs[next];
				}else{
					content.transform.matrix = new Matrix();
				}
			}
			
			if (colorTransforms)
			{
				if (colorTransforms[next]){
					content.transform.colorTransform = colorTransforms[next];
				}else{
					content.transform.colorTransform = new ColorTransform();
				}
			}
			
			if (filterses)
			{
				if (filterses[next]){
					content.filters = filterses[next];
				}else{
					content.filters = [];
				}
			}
			
			if (content)
			{
				var trans:String = curLabelName+"-"+next+":start";
				if (hasLabel(trans))
				{
					setLabel(curLabelName+"-"+next+":start",1);
					queueLabel(next,-1);
				}
				else
					setLabel(next,-1);
			}
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			tweenTo(DOWN);
			_mouseDown = true;
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			tweenTo(_mouseOver ? OVER : UP);
			_mouseDown = false;
			
			if (trackAsMenu)
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		protected function rollOverHandler(event:MouseEvent):void
		{	
			if (event.buttonDown)
			{
				if (trackAsMenu || _mouseDown)
					tweenTo(DOWN);
			}
			else
			{
				tweenTo(OVER);
			}
			
			_mouseOver = true;
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			tweenTo(UP);
			_mouseOver = false;
		}
		
		protected function toggleClickHandler(event:MouseEvent):void
		{
			selected = !selected;
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			if (this.action)
				dispatchEvent(Util.createObject(new ActionEvent(ActionEvent.ACTION),{action:this.action}))
		}
		
		public override function destory() : void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			removeEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			removeEventListener(MouseEvent.CLICK,toggleClickHandler);
			removeEventListener(MouseEvent.CLICK,clickHandler);
			
			if (labelField)
				labelField.destory();
			
			super.destory();
		}
	}
}