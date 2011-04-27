package ghostcattools.util
{
	import mx.collections.ArrayList;
	import mx.events.PropertyChangeEvent;
	
	public class AutoLengthArrayList extends ArrayList
	{
		public var emptyClass:Class = null;
		public var labelField:String = null;
		public function AutoLengthArrayList(source:Array=null,exmptyClass:Class=null,labelField:String = null)
		{
			super(source);
			
			this.emptyClass = exmptyClass;
			this.labelField = labelField;
			
			if (this.length <= 1)
				this.createEmptyObject()
			else
				this.checkLength(this.length - 2);
		}
		
		protected override function itemUpdateHandler(event:PropertyChangeEvent):void
		{
			super.itemUpdateHandler(event);
			var index:uint = getItemIndex(event.target);
			checkLength(index);
		}
		
		public override function setItemAt(item:Object, index:int):Object
		{
			var o:Object = super.setItemAt(item,index);
			checkLength(index);
			return o;
		}
		
		public function checkLength(index:int):void
		{
			var item:Object = getItemAt(index);
			if (!isEmptyObject(item))
			{
				if (index == this.length - 1)
					createEmptyObject();
			}
			else
			{
				while (index < this.length - 1 && isEmptyObject(getItemAt(index)))
					removeItemAt(index);
			}
		}
		
		public function createEmptyObject():void
		{
			addItem(emptyClass ? new emptyClass() : null);
		}
		
		protected function isEmptyObject(item:Object):Boolean
		{
			return !item || (labelField && !item[labelField])
		}
	}
}