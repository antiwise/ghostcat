package org.ghostcat.core
{
	/**
	 *  The IDisplayObjectContainerInterface defines the basic set of APIs
	 *  for web version of flash.display.DisplayObjectContainer
	 */
	import flash.text.TextSnapshot;
	import flash.geom.Point;
	import flash.display.DisplayObject;

	public interface IDisplayObjectContainer extends IDisplayObject
	{

    /**
     *  @copy flash.display.DisplayObjectContainer#addChild()
     */
    function addChild(child:DisplayObject):DisplayObject;
   
    /**
     *  @copy flash.display.DisplayObjectContainer#addChildAt()
     */
    function addChildAt(child:DisplayObject, index:int):DisplayObject;
    
    /**
     *  @copy flash.display.DisplayObjectContainer#removeChild()
     */
    function removeChild(child:DisplayObject):DisplayObject;
    
    /**
     *  @copy flash.display.DisplayObjectContainer#removeChildAt()
     */
    function removeChildAt(index:int):DisplayObject;

    /**
     *  @copy flash.display.DisplayObjectContainer#getChildIndex()
     */
    function getChildIndex(child:DisplayObject):int;
    
    /**
     *  @copy flash.display.DisplayObjectContainer#setChildIndex()
     */
    function setChildIndex(child:DisplayObject, index:int):void;

    /**
     *  @copy flash.display.DisplayObjectContainer#getChildAt()
     */
    function getChildAt(index:int):DisplayObject;
    
    /**
     *  @copy flash.display.DisplayObjectContainer#getChildByName()
     */
    function getChildByName(name:String):DisplayObject;

    /**
     *  @copy flash.display.DisplayObjectContainer#numChildren
     */
    function get numChildren():int;

    /**
     *  @copy flash.display.DisplayObjectContainer#textSnapshot
     */
    function get textSnapshot():TextSnapshot;
    
    /**
     *  @copy flash.display.DisplayObjectContainer#getObjectsUnderPoint()
     */
    function getObjectsUnderPoint(point:Point):Array;

    /**
     *  @copy flash.display.DisplayObjectContainer#areInaccessibleObjectsUnderPoint()
     */
    function areInaccessibleObjectsUnderPoint(point:Point):Boolean;

    /**
     *  @copy flash.display.DisplayObjectContainer#tabChildren
     */
    function get tabChildren():Boolean;
    function set tabChildren(enable:Boolean):void;
    
    /**
     *  @copy flash.display.DisplayObjectContainer#mouseChildren
     */
    function get mouseChildren():Boolean;
    function set mouseChildren(enable:Boolean):void;

    /**
     *  @copy flash.display.DisplayObjectContainer#contains()
     */
    function contains(child:DisplayObject):Boolean;

    /**
     *  @copy flash.display.DisplayObjectContainer#swapChildrenAt()
     */
    function swapChildrenAt(index1:int, index2:int):void;

    /**
     *  @copy flash.display.DisplayObjectContainer#swapChildren()
     */
    function swapChildren(child1:DisplayObject, child2:DisplayObject):void;
	}
}