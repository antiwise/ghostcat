package ghostcat.ui.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import ghostcat.display.GBase;
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.display.movieclip.GMovieClipBase;
	import ghostcat.events.ActionEvent;
	import ghostcat.skin.ButtonSkin;
	import ghostcat.util.Util;
	import ghostcat.util.core.AbstractUtil;
	import ghostcat.util.core.ClassFactory;
	
	[Event(name="change",type="flash.events.Event")]
	
	/**
	 * 按钮
	 * 
	 * 标签规则：为一整动画，up,over,down,disabled,selectedUp,selectedOver,selectedDown,selectedDisabled是按钮的八个状态，
	 * 状态间的过滤为两个标签中间加-，末尾加:start。比如up和over的过滤即为up-over:start
	 * 
	 * 皮肤同时也会当作文本框再次处理一次
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GButtonBase extends GBase
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
		
		/**
		 * 动画控制对象
		 */
		protected var movie:GMovieClipBase;
		
		private var defaultSkin:*;//保存默认skin
		
		private var _toggle:Boolean;
		
		private var _mouseDown:Boolean = false;
		
		private var _mouseOver:Boolean = false;
		
		private var labelTextField:GText;
		
		/**
		 * data中显示成label的字段
		 */
		public var labelField:String;
		
		/**
		 * 自动创建的TextField的初始位置（如果是从skin中创建，此属性无效）
		 */
		public var textPos:Point;
		
		/**
		 * 是否将文本从Skin中剥离。剥离后Skin缩放才不会影响到文本的正常显示
		 */
		public var separateTextField:Boolean = false;
		
		/**
		 * 是否自动根据文本调整Skin体积。当separateTextField为false时，此属性无效。
		 */
		public var enabledAdjustContextSize:Boolean = false;
		
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
		
		/**
		 * 是否可以点击选择 
		 */
		public var toggle:Boolean;
		
		/**
		 * 鼠标是否按下
		 */
		public function get mouseDown():Boolean
		{
			return _mouseDown;
		}
		
		/**
		 * 鼠标是否触发
		 */
		public function get mouseOver():Boolean
		{
			return _mouseOver;
		}
		
		public function GButtonBase(skin:*=null, replace:Boolean=true, separateTextField:Boolean = false, textPos:Point=null)
		{
			AbstractUtil.preventConstructor(this,GButtonBase);
			
			if (textPos)
				this.textPos = textPos;
			
			this.separateTextField = separateTextField;
			
			super(skin, replace);
		}
		
		/**
		 * Label文字 
		 * @return 
		 * 
		 */
		public function get label():String
		{
			return labelField ? data[labelField] : data;
		}

		public function set label(v:String):void
		{
			if (labelField)
			{
				if (super.data == null)
					super.data = new Object();
					
				super.data[labelField] = v;
			}
			else
				data = v;
		}
		/** @inheritDoc*/
		public override function set data(v:*) : void
		{
			super.data = v;
			
			if (labelTextField)
				labelTextField.text = label;
			else
				refreshLabelField();
		} 
		/** @inheritDoc*/
		public override function set enabled(v:Boolean) : void
		{
			if (super.enabled == v)
				return;
			
			this.mouseChildren = this.mouseEnabled = super.enabled = v;
			tweenTo(v ? UP : DISABLED);
		}
		
		/**
		 * 更新label
		 * 
		 */
		public function refreshLabelField():void
		{
			if (!label)
				return;
			
			if (labelTextField)
				labelTextField.destory();
			
			labelTextField = new GText(content,false,separateTextField,textPos);
			labelTextField.enabledAdjustContextSize = enabledAdjustContextSize;
			addChild(labelTextField)
			
			labelTextField.text = label;
		}
		/** @inheritDoc*/
		public override function setContent(skin:*, replace:Boolean=true):void
		{
			defaultSkin = skin;
			setPartConetent(skin,replace);
		}
		
		/**
		 * 设置单个状态 
		 * @param skin
		 * @param replace
		 * 
		 */
		public function setPartConetent(skin:*, replace:Boolean=true):void
		{
			super.setContent(skin,replace);
			
			refreshLabelField();
			
			createMovieClip();
			
			if (!movie.frameRate && stage)
				movie.frameRate = stage.frameRate;
		}
		
		/**
		 * 创建动画 
		 * 
		 */
		protected function createMovieClip():void
		{
			//请补充事件，并设置movie属性
		}
		
		/** @inheritDoc*/
		public override function set selected(v:Boolean):void
		{
			if (super.selected == v)
				return;
			
			super.selected = v;
			tweenTo(UP);
			
			dispatchEvent(new Event(Event.CHANGE))
		}
		
		/**
		 * 增加事件
		 * 
		 */
		protected function addEvents():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		/**
		 * 删除事件
		 * 
		 */
		protected function removeEvents():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			removeEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		/** @inheritDoc*/
		protected override function init():void
		{
			super.init();
			
			if (!movie.frameRate)
				movie.frameRate = stage.frameRate;
			
			addEvents();
		
			tweenTo(UP);
		}
		
		private function tweenTo(n:int):void
		{
			var next:String = LABELS[n][int(selected)];
			
			if (replace && skins)
			{
				if (skins[next])
					setPartConetent(skin[next],replace);
				else
					setPartConetent(defaultSkin,replace);
			}
			
			if (replace && matrixs) 
			{
				if (matrixs[next])
					content.transform.matrix = matrixs[next];
				else
					content.transform.matrix = new Matrix();
			}
			
			if (colorTransforms)
			{
				if (colorTransforms[next])
					content.transform.colorTransform = colorTransforms[next];
				else
					content.transform.colorTransform = new ColorTransform();
			}
			
			if (filterses)
			{
				if (filterses[next])
					content.filters = filterses[next];
				else
					content.filters = [];
			}
			
			if (content && movie.labels)
			{
				var trans:String = movie.curLabelName+"-"+next+":start";
				if (movie.hasLabel(trans))
				{
					movie.setLabel(movie.curLabelName+"-"+next+":start",1);
					movie.queueLabel(next,-1);
				}
				else
					movie.setLabel(next,-1);
			}
		}
		
		/**
		 * 鼠标按下事件
		 * @param event
		 * 
		 */
		protected function mouseDownHandler(event:MouseEvent):void
		{
			tweenTo(DOWN);
			_mouseDown = true;
		}
		
		/**
		 * 鼠标松开事件 
		 * @param event
		 * 
		 */
		protected function mouseUpHandler(event:MouseEvent):void
		{
			tweenTo(_mouseOver ? OVER : UP);
			_mouseDown = false;
			
			if (trackAsMenu)
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		/**
		 * 鼠标移入事件
		 * @param event
		 * 
		 */
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
		
		/**
		 * 鼠标移出事件 
		 * @param event
		 * 
		 */
		protected function rollOutHandler(event:MouseEvent):void
		{
			tweenTo(UP);
			_mouseOver = false;
		}
		
		/**
		 * 点击事件
		 * @param event
		 * 
		 */
		protected function clickHandler(event:MouseEvent):void
		{
			if (toggle)
				selected = !selected;
		
			if (this.action)
				dispatchEvent(Util.createObject(new ActionEvent(ActionEvent.ACTION),{action:this.action}))
		}
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			removeEvents();
			
			if (labelTextField)
				labelTextField.destory();
			
			if (movie)
				movie.destory();
			
			super.destory();
		}
	}
}