/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.control
{
	import com.adobe.cairngorm.control.FrontController;
	import com.coldfusiondocs.event.*;
	import com.coldfusiondocs.command.*;

	public class AppController extends FrontController
	{
		public function AppController()
		{
			initialiseCommands();
		}
		
		public function initialiseCommands() : void
		{
			// data loading
			addCommand( LoadDataEvent.LOAD_CFML_ADOBE, LoadAdobeCFMLDataCommand );	
			addCommand( LoadDataEvent.LOAD_CFML_RAILO, LoadRailoCFMLDataCommand ); 
			
			// click handlers
			addCommand( ItemClickEvent.ITEM_CLICK_ADOBE, ItemClickCommand );
			addCommand( ItemClickEvent.ITEM_CLICK_RAILO, ItemClickCommand );
			
			// iframe handler
			addCommand( TypeChangeEvent.TYPE_CHANGE, TypeChangeCommand );
			
			// link handlers
			addCommand( GetLinkEvent.GET_LINK, GetLinkCommand );
			addCommand( AddLinkEvent.ADD_LINK, AddLinkCommand );
	    }

	}
}