/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.vo
{
	import com.adobe.cairngorm.vo.ValueObject;
	
	[Bindable]
	public class ObjectVO implements ValueObject
	{
		public var objectName:String;
		public var objectType:String;
		public var docURL:String;
		public var description:String;
		public var addedIn:String;
		public var categoryType:String;
	}
}