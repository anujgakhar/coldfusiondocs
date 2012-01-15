package com.coldfusiondocs.model
{
	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
	import mx.collections.Sort;
	import mx.collections.SortField;

	public class AppData
	{
		private var sort:Sort;
		
		private var _all_acf_tags:ArrayCollection;
		
		[Bindable]
		public var all_acf_categories:ArrayCollection;
		
		[Bindable]
		public var filtered_acf_tags:ListCollectionView;
		
		[Init]
		public function init():void
		{
			_all_acf_tags = new ArrayCollection();
			sort = new Sort();
			var sortOrderField:SortField = new SortField("objectName", true, false);
			sort.fields = [ sortOrderField ];
		}
		
		[Bindable]
		public function get all_acf_tags():ArrayCollection
		{
			return _all_acf_tags;
		}
		
		public function set all_acf_tags(value:ArrayCollection):void
		{
			if(!value)
				return;
			
			_all_acf_tags = value;
			_all_acf_tags.sort = sort;
			_all_acf_tags.refresh();
			
			filtered_acf_tags = new ListCollectionView(value);
			filtered_acf_tags.filterFunction = acfFilter;
			filtered_acf_tags.sort = sort;
			filtered_acf_tags.refresh();
		}
		
		private function acfFilter(acfItem:Item):Boolean
		{
			return true;
		}
	}
}