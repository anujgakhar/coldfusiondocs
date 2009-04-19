/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.model
{
	import com.adobe.cairngorm.model.ModelLocator;
	
	import mx.collections.ArrayCollection;

	public class ModelLocator implements com.adobe.cairngorm.model.ModelLocator
	{
        public static const STATE_READY:String = "ready";
        public static const STATE_LOADING:String = "loading";
        
        [Bindable]
        public var data_state:String;
		
		[Bindable]
		public var isIframeVisible:Boolean = false;
		
		[Bindable]
		public var iframeURL:String = "";
		
		[Bindable]
		public var currentItem:String = "";
		
		[Bindable]
		[ArrayElementType("com.coldfusiondocs.vo.ObjectVO")]
		public var all_adobe_cfml_tags:ArrayCollection
		
		[Bindable]
		[ArrayElementType("com.coldfusiondocs.vo.CategoryVO")]
		public var all_adobe_cfml_categories:ArrayCollection		
		
		[Bindable]
		[ArrayElementType("com.coldfusiondocs.vo.ObjectVO")]
		public var all_railo_cfml_tags:ArrayCollection
		
		public function ModelLocator()
		{
		}
		
		public static function getInstance():com.coldfusiondocs.model.ModelLocator{
			if(_instance == null){
				_instance = new com.coldfusiondocs.model.ModelLocator();
			}
			return _instance;
		}
		
		protected static var _instance:com.coldfusiondocs.model.ModelLocator;

	}
}