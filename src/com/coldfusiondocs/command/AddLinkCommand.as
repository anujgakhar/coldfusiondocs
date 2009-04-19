/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.coldfusiondocs.business.LinkDelegate;
	import com.coldfusiondocs.event.AddLinkEvent;
	import com.coldfusiondocs.event.GetLinkEvent;
	import com.coldfusiondocs.model.LinkLocator;
	import com.coldfusiondocs.model.ModelLocator;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;

	public class AddLinkCommand implements Command, IResponder
	{
		public function AddLinkCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			// first change the state to 'loading'
			LinkLocator.getInstance().data_state = LinkLocator.STATE_LOADING;
			
			// now lets get the event data
			var _data:Object = AddLinkEvent(event).link_data;
			
			// call the webservice addLink()
			getDelegate().addLink(_data);
		}
		
		public function result(data:Object):void
		{
			var event:ResultEvent = data as ResultEvent;
			var _str:String = event.result as String;

			// if successful response
			if (_str.toString() == 'Link Added!') {
				// link has been added, fire off a getLink event now to refresh
				CairngormEventDispatcher.getInstance().dispatchEvent( new GetLinkEvent(GetLinkEvent.GET_LINK, ModelLocator.getInstance().currentItem  ) );
			} else {
				// put the state back to how it was
				LinkLocator.getInstance().data_state = LinkLocator.STATE_READY;
			}
			
		}
		
		public function fault(info:Object):void
		{
		}
		
		protected function getDelegate():LinkDelegate
		{
			return new LinkDelegate(this);
		}		
		
	}
}