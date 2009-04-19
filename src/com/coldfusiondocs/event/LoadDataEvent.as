/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.event
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class LoadDataEvent extends CairngormEvent
	{
		
		public static var LOAD_CFML_ADOBE:String = "com.coldfusiondocs.event.LoadDataEvent.LOAD_CFML_ADOBE";
		public static var LOAD_CFML_RAILO:String = "com.condfusiondocs.event.LoadDataEvent.LOAD_CFML_RAILO";
		
		public function LoadDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}