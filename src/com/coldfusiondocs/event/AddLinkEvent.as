/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.event
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class AddLinkEvent extends CairngormEvent
	{
		public static var ADD_LINK:String = "com.coldfusiondocs.event.AddLinkEvent.ADD_LINK";
		public var link_data:Object;
		
		public function AddLinkEvent(type:String, _data:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			link_data = _data;
		}
		
	}
}