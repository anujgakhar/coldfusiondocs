/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.factories
{
	import com.coldfusiondocs.vo.LinkVO;
	
	import mx.collections.ArrayCollection;
	
	public class LinkFactory
	{
		public static function buildArrayofLinksFromResult(_items:ArrayCollection):Array{
			var _links:Array = new Array();
			
			for(var i:int=0; i<_items.length; i++){
				var linkVO:LinkVO = new LinkVO();
				linkVO.AddedBy = _items[i].ADDEDBY;
				linkVO.Email = _items[i].EMAIL;
				linkVO.LinkTitle = _items[i].LINKTITLE;
				linkVO.Link = _items[i].LINK;
				_links.push(linkVO);
			}
			return _links;			
		}
		
	}
}