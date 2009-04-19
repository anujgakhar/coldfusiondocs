/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.soap.WebService;

	
	public class LinkDelegate
	{
		public function LinkDelegate(p_responder:IResponder){
			responder = p_responder;
		}
		
		public function getLinksByObject(_item:String):void{
			// get the service
			var service:WebService = ServiceLocator.getInstance().getWebService("linkService");
			
			//send the request
			var token:AsyncToken = service.getLinksByObject(_item);
			token.addResponder(responder);
		}
		
		public function addLink(_data:Object):void{
			// get the service
			var service:WebService = ServiceLocator.getInstance().getWebService("linkService");
			
			//get the vars
			var _addedBy:String = _data.addedBy;
			var _link:String = _data.link;
			var _linktitle:String = _data.linktitle;
			var _object:String = _data.object;
			var _email:String = _data.email;
			
			// send the request
			var token:AsyncToken = service.addLink(_addedBy, _email, _link, _object, _linktitle);
			token.addResponder(responder);
		}		
		
		protected var responder:IResponder;
	}
}