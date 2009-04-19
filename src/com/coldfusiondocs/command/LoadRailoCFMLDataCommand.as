/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.coldfusiondocs.business.LoadDataDelegate;
	import com.coldfusiondocs.event.LoadDataEvent;
	import com.coldfusiondocs.model.ModelLocator;
	import com.coldfusiondocs.factories.AppFactory;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	public class LoadRailoCFMLDataCommand implements ICommand, IResponder
	{
		
		public function execute(event:CairngormEvent):void{
			getDelegate().loadRailoCFMLData();
		}
		
		public function result( data:Object ):void{
			var event:ResultEvent = data as ResultEvent;
			var xml:XML = event.result as XML;
			var _items:Array = AppFactory.buildArrayofObjectsFromXML(xml);
			
			//sort the data
			var _sortedItems:ArrayCollection = new ArrayCollection(_items);
			var sort:Sort = new Sort();
			sort.fields =[ new SortField("objectName", true, false)];
			_sortedItems.sort = sort;
			_sortedItems.refresh();
			
			//update the Model
			ModelLocator.getInstance().all_railo_cfml_tags = new ArrayCollection(_items);
		}
		
		public function fault(info:Object):void{
			var event:FaultEvent = info as FaultEvent;
		}
		
		protected function getDelegate():LoadDataDelegate
        {
            return new LoadDataDelegate(this);
        }

		
		public function LoadRailoCFMLDataCommand():void
		{
		}

	}
}