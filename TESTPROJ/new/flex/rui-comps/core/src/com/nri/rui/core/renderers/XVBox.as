package com.nri.rui.core.renderers
{
	import mx.containers.VBox;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.BaseListData;

	public class XVBox extends VBox implements IDropInListItemRenderer
	{
		
		/**
	     *  @private
	     *  Storage for the listData property.
	     */
	    private var _listData:BaseListData;
		
		public function XVBox()
		{
			super();
		}
		
		public function get listData():BaseListData
		{
			return _listData;
		}
		
		public function set listData(value:BaseListData):void
		{
			_listData = value;
		}
		
	}
}