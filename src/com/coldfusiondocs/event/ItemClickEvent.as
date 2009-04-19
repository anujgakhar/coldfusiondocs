/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.event
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class ItemClickEvent extends CairngormEvent
	{
		
		public static var ITEM_CLICK_ADOBE:String = "com.coldfusiondocs.event.ItemClickEvent.ITEM_CLICK_ADOBE";
		public static var ITEM_CLICK_RAILO:String = "com.condfusiondocs.event.ItemClickEvent.ITEM_CLICK_RAILO";
		
		public var _item:String;
		
		public function ItemClickEvent(type:String, item:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_item = item;
		}
		
	}
}