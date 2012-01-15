/*
Author: Anuj Gakhar
Web: www.anujgakhar.com
*/

package com.coldfusiondocs.utils
{
	import com.coldfusiondocs.model.Category;
	import com.coldfusiondocs.model.Item;
	
	public class AppFactory
	{

		public static function buildArrayofObjectsFromXML(xml:XML):Array{
			var _items:Array = new Array();
			for each(var obj:XML in xml.category.object){
				var objVO:Item = buildObjectFromXML(obj);
				_items.push(objVO);
			}		
			return _items;	
		}
		
		public static function buildObjectFromXML(xml:XML):Item
		{
			var objVO:Item = new Item();
			objVO.addedIn = xml.addedIn;
			objVO.docURL = xml.docURL;
			objVO.description = xml.description;
			objVO.categoryType = xml.categoryType;
			objVO.objectType = xml.@type;
			objVO.objectName = xml.@name;
			return objVO;
		}
		
		public static function buildArrayofCategoriesfromXML(xml:XML):Array
		{
			var _items:Array = new Array();
			var allVO:Category = new Category();
			allVO.categoryName = "All";
			allVO.categoryType = "All";
			_items.push(allVO);
			for each(var obj:XML in xml.category){
				var categoryVO:Category = buildCategoryFromXML(obj);
				_items.push(categoryVO);
			}
			return _items;
		}	
		
		public static function buildCategoryFromXML(xml:XML):Category
		{
			var cat:Category = new Category();
			cat.categoryName = xml.@name;
			cat.categoryType = xml.@type;
			return cat;
		}			

	}
}