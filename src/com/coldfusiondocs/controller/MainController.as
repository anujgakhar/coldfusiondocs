package com.coldfusiondocs.controller
{
	import com.coldfusiondocs.messages.LoadCFMLDataMessage;
	import com.coldfusiondocs.messages.LoadRailoDataMessage;
	import com.coldfusiondocs.model.AppData;

	public class MainController
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		[Inject]
		[Bindable]
		public var model:AppData;
		
		[Init]
		public function init():void
		{
			dispatcher(new LoadCFMLDataMessage());
			dispatcher(new LoadRailoDataMessage());
		}
		
		[Bindable]
		public var acfFilterCriteria:String;
	}
}