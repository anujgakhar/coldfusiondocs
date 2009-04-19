/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.coldfusiondocs.factories.AppFactory;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	
	public class LoadDataDelegate
	{
		public function LoadDataDelegate(p_responder:IResponder){
			responder = p_responder;
		}
		
		public function loadAdobeCFMLData():void{
			var service:HTTPService = ServiceLocator.getInstance().getHTTPService("adobeCFMLService");
			var token:AsyncToken = service.send();
			token.addResponder(responder);
		}

		public function loadRailoCFMLData():void{
			var service:HTTPService = ServiceLocator.getInstance().getHTTPService("railoCFMLService");
			var token:AsyncToken = service.send();
			token.addResponder(responder);
		}		
		protected var responder:IResponder;
	}
}