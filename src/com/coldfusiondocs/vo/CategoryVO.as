/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.vo
{
	import com.adobe.cairngorm.vo.ValueObject;
	
	[Bindable]
	public class CategoryVO implements ValueObject
	{
		public var categoryName:String;
		public var categoryType:String;
	}
}