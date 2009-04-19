/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.coldfusiondocs.event.GetLinkEvent;
	import com.coldfusiondocs.event.ItemClickEvent;
	import com.coldfusiondocs.model.ModelLocator;
	import com.coldfusiondocs.vo.ObjectVO;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;

	public class ItemClickCommand implements ICommand, IResponder
	{
		
		public function ItemClickCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			var sourceData:ArrayCollection;
			var prependURL:String;
			
			switch(event.type){
				case ItemClickEvent.ITEM_CLICK_ADOBE:
					sourceData = ModelLocator.getInstance().all_adobe_cfml_tags;
					prependURL = "http://www.coldfusiondocs.com/htmldocs/load.cfm?object=";
					break;
				case ItemClickEvent.ITEM_CLICK_RAILO:
					sourceData = ModelLocator.getInstance().all_railo_cfml_tags;
					prependURL = "http://www.coldfusiondocs.com/railohtml/load.cfm?object=";
					break;	
			}
			
			// get the selected Item Name from the Event
			var _str:String = ItemClickEvent(event)._item.toString();
			var selectedItem:ObjectVO ;
			
			// find the item from the model
			for each(var obj:ObjectVO in sourceData){
				if (obj.objectName == _str){
					selectedItem = obj;
					break;
				}
			}
			
			// get the docURL for the item
			var urlBreak:Array = selectedItem.docURL.toString().split("/");
			var fileName:Array = urlBreak[urlBreak.length-1].split("#");
			var frameSource:String = prependURL + fileName[0].toString();
			
			//update the Model
			if(ModelLocator.getInstance().iframeURL.toString() != frameSource)
			{
				ModelLocator.getInstance().iframeURL = frameSource;  
			}

			// make the iframe visible if its not already
			ModelLocator.getInstance().isIframeVisible = true;
			
			// update the Model currentItem
			ModelLocator.getInstance().currentItem = selectedItem.objectName.toString();
			
			// fire the GetLink Event so the 'useful urls' gets updated as well
			CairngormEventDispatcher.getInstance().dispatchEvent(new GetLinkEvent(GetLinkEvent.GET_LINK, selectedItem.objectName.toString()));
		}
		
		public function result(data:Object):void
		{
		}
		
		public function fault(info:Object):void
		{
		}
		
	}
}