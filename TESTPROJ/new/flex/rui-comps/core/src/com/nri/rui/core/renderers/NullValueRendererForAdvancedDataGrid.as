
package com.nri.rui.core.renderers
{
	import mx.controls.Label;
	//import mx.controls.dataGridClasses.DataGridColumn;
	//import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridListData;
	import mx.utils.StringUtil;

	public class NullValueRendererForAdvancedDataGrid extends Label
	{
		public function NullValueRendererForAdvancedDataGrid()
		{
			super();
		}
		 private var _data:AdvancedDataGridColumn;
	
		override public function get data():Object
		{
			return _data;
		}
	
		override public function set data(value:Object):void {
			_data = value as AdvancedDataGridColumn;
			
			if(listData) {
            	var str:String = StringUtil.trim(AdvancedDataGridListData(listData).label);
            	if(str.indexOf("object")>0)
            		text = ""
            	else
                	text = str;
            }
		} 
		 /**
         * This method overrides the updateDisplayList method to set the value 
         * of the AdvancedDataGrid column's element to an empty string if the value is null
         * otherwise show the actual value
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
        }
	}
}