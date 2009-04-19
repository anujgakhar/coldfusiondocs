/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.vo
{
	import com.adobe.cairngorm.vo.ValueObject;
	
	[Bindable]
	public class LinkVO implements ValueObject
	{
		public var LinkTitle:String;
		public var AddedBy:String;
		public var Link:String;
		public var Email:String;
	}
}