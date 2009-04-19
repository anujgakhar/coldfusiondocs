/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.coldfusiondocs.business.LoadDataDelegate;
	import com.coldfusiondocs.factories.AppFactory;
	import com.coldfusiondocs.model.ModelLocator;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class LoadAdobeCFMLDataCommand implements ICommand, IResponder
	{
		
		public function execute(event:CairngormEvent):void{
			ModelLocator.getInstance().data_state = ModelLocator.STATE_LOADING;
			getDelegate().loadAdobeCFMLData();
		}
		
		public function result( data:Object ):void{
			var event:ResultEvent = data as ResultEvent;
			var xml:XML = event.result as XML;

			// parse the XML
			var _items:Array = AppFactory.buildArrayofObjectsFromXML(xml);
			
			//sort the data alphabetically
			var _sortedItems:ArrayCollection = new ArrayCollection(_items);
			var sort:Sort = new Sort();
			sort.fields =[ new SortField("objectName", true, false)];
			_sortedItems.sort = sort;
			_sortedItems.refresh();
			
			//update the Model
			ModelLocator.getInstance().all_adobe_cfml_tags = _sortedItems;

			// assign the list of categories 
			var _categories:Array = AppFactory.buildArrayofCategoriesfromXML(xml);
			ModelLocator.getInstance().all_adobe_cfml_categories = new ArrayCollection(_categories);
			
			// finally, change the state
			ModelLocator.getInstance().data_state = ModelLocator.STATE_READY;
		}
		
		public function fault(info:Object):void{
			var event:FaultEvent = info as FaultEvent;
		}
		
		protected function getDelegate():LoadDataDelegate
		{
			return new LoadDataDelegate(this);
		}

		
		public function LoadAdobeCFMLDataCommand():void
		{
		}

	}
}