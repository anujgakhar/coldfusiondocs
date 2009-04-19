/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.factories
{
	import com.coldfusiondocs.vo.CategoryVO;
	import com.coldfusiondocs.vo.ObjectVO;
	
	public class AppFactory
	{

		public static function buildArrayofObjectsFromXML(xml:XML):Array{
			var _items:Array = new Array();
			for each(var obj:XML in xml.category.object){
				var objVO:ObjectVO = buildObjectFromXML(obj);
				_items.push(objVO);
			}		
			return _items;	
		}
		
		public static function buildObjectFromXML(xml:XML):ObjectVO{
			var objVO:ObjectVO = new ObjectVO();
			objVO.addedIn = xml.addedIn;
			objVO.docURL = xml.docURL;
			objVO.description = xml.description;
			objVO.categoryType = xml.categoryType;
			objVO.objectType = xml.@type;
			objVO.objectName = xml.@name;
			return objVO;
		}
		
		public static function buildArrayofCategoriesfromXML(xml:XML):Array{
			var _items:Array = new Array();
			var allVO:CategoryVO = new CategoryVO();
			allVO.categoryName = "All";
			allVO.categoryType = "All";
			_items.push(allVO);
			for each(var obj:XML in xml.category){
				var categoryVO:CategoryVO = buildCategoryFromXML(obj);
				_items.push(categoryVO);
			}
			return _items;
		}	
		
		public static function buildCategoryFromXML(xml:XML):CategoryVO{
			var catVO:CategoryVO = new CategoryVO();
			catVO.categoryName = xml.@name;
			catVO.categoryType = xml.@type;
			return catVO;
		}			

	}
}