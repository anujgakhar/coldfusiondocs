/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.coldfusiondocs.business.LinkDelegate;
	import com.coldfusiondocs.event.GetLinkEvent;
	import com.coldfusiondocs.factories.LinkFactory;
	import com.coldfusiondocs.model.LinkLocator;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ArrayUtil;
	import mx.utils.ObjectUtil;
	import mx.controls.Alert;
	
	public class GetLinkCommand implements IResponder, ICommand
	{
		public function GetLinkCommand()
		{
		}

		public function result(data:Object):void
		{
			var event:ResultEvent = data as ResultEvent;

			// get the data
			var tmpLinks:ArrayCollection = new ArrayCollection();
			if (event.result is ArrayCollection)
			{
				tmpLinks = ArrayCollection(event.result);
			} else {
				tmpLinks =  new ArrayCollection(mx.utils.ArrayUtil.toArray(event.result));
			}
			
			// parse the data
			var links:Array = LinkFactory.buildArrayofLinksFromResult(tmpLinks);
			
			// set the model
			LinkLocator.getInstance().all_links = new ArrayCollection(links);
			
			// update state
			LinkLocator.getInstance().data_state = LinkLocator.STATE_READY;
		}
		
		public function fault(info:Object):void
		{
		}
		
		public function execute(event:CairngormEvent):void
		{
			LinkLocator.getInstance().data_state = LinkLocator.STATE_LOADING;
			var item:String = GetLinkEvent(event)._item;
			getDelegate().getLinksByObject(item);
		}
		
		protected function getDelegate():LinkDelegate
		{
			return new LinkDelegate(this);
		}		
		
	}
}