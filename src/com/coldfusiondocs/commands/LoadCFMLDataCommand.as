package com.coldfusiondocs.commands
{
	import com.coldfusiondocs.utils.AppFactory;
	import com.coldfusiondocs.messages.LoadCFMLDataMessage;
	import com.coldfusiondocs.model.AppData;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	

	public class LoadCFMLDataCommand
	{
		[Inject(id="adobeCFMLService")]
		public var service:HTTPService;
		
		[Inject]
		public var model:AppData;
		
		public function execute(event:LoadCFMLDataMessage):AsyncToken
		{
			return service.send();
		}
		
		public function result(event:ResultEvent):void
		{
			var xml:XML = event.result as XML;
			
			var items:Array = AppFactory.buildArrayofObjectsFromXML(xml);
			model.all_acf_tags = new ArrayCollection(items);
			
			var categories:Array = AppFactory.buildArrayofCategoriesfromXML(xml);
			model.all_acf_categories = new ArrayCollection(categories);
		}
		
		public function error(fault:Fault):void
		{
			//dispatcher(MobiusErrorMessage.createFromFault(fault));
		}
	}
}