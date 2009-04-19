/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.event
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class GetLinkEvent extends CairngormEvent
	{
		public static var GET_LINK:String = "com.coldfusiondocs.event.GetLinkEvent.GET_LINK";
		
		public var _item:String;
		
		public function GetLinkEvent(type:String, item:String,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_item = item;
		}
		
	}
}