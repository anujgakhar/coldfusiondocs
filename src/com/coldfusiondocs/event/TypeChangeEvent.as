/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.event
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class TypeChangeEvent extends CairngormEvent
	{
		public static var TYPE_CHANGE:String = "com.coldfusiondocs.event.TypeChangeEvent.TYPE_CHANGE";
		
		public function TypeChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}