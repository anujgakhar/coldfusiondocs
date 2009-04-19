/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.model
{
	import com.adobe.cairngorm.model.ModelLocator;
	
	import mx.collections.ArrayCollection;

	public class LinkLocator implements com.adobe.cairngorm.model.ModelLocator
	{
        public static const STATE_READY:String = "ready";
        public static const STATE_LOADING:String = "loading";
        
        [Bindable]
        public var data_state:String;		
		
		[Bindable]
		[ArrayElementType("com.coldfusiondocs.vo.LinkVO")]
		public var all_links:ArrayCollection
		
		public function LinkLocator()
		{
		}
		
		public static function getInstance():com.coldfusiondocs.model.LinkLocator{
			if(_instance == null){
				_instance = new com.coldfusiondocs.model.LinkLocator();
			}
			return _instance;
		}
		
		protected static var _instance:com.coldfusiondocs.model.LinkLocator;

	}
}