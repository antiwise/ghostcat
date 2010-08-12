package ghostcat.community.sort
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import ghostcat.algorithm.Point3D;
	import ghostcat.community.GroupManager;
	import ghostcat.util.Util;
	
	/**
	 * 3D景深排序 
	 * @author flashyiyi
	 * 
	 */
	public class Sort3DManager extends GroupManager
	{
		public function Sort3DManager(cotainer:DisplayObjectContainer = null)
		{
			this.container = cotainer;
			super();
		}
		
		/**
		 * 排序
		 * @param sortFields	排序依据
		 * 
		 */
		public override function calculateAll(onlyFilter:Boolean = true) : void
		{
			if (!container)
				throw new Error("未设置container属性")
			
			if (onlyFilter && Util.isEmpty(dirtys))
				return;
			
			var i:int;
			var distArray:Array = [];
			var data:Array = [];
			
			for (i = 0; i < container.numChildren; i++)
			{
				var child:DisplayObject = container.getChildAt(i);
				data[i] = child;
				distArray[i] = child.transform.getRelativeMatrix3D(container.root).position.z;
			}
			
			var result:Array = distArray.sort(Array.NUMERIC|Array.RETURNINDEXEDARRAY|Array.DESCENDING);
			
			for (i = 0; i < result.length; i++)
			{
				var v:DisplayObject = data[result[i]] as DisplayObject;
				if (v.parent == container && container.getChildIndex(v) != i)
					container.setChildIndex(v,i);
			}
			
			dirtys = new Dictionary();
		}
	}
}