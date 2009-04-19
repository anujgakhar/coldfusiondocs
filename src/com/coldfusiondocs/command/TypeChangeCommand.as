/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.command
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import mx.rpc.IResponder;
	import com.adobe.cairngorm.commands.ICommand;
	
	import com.coldfusiondocs.model.ModelLocator;

	public class TypeChangeCommand implements IResponder, ICommand
	{
		public function TypeChangeCommand()
		{
		}

		public function result(data:Object):void
		{
		}
		
		public function fault(info:Object):void
		{
		}
		
		public function execute(event:CairngormEvent):void
		{
			// we need to hide the right content when tabs change from railo>cfml and cfml->railo 
			// otherwise the right content is out of sync 
			
			// we could have updated the Model from the View itself but trying to follow a good practice here :)
			ModelLocator.getInstance().isIframeVisible = false;
		}
		
	}
}