
package com.nri.rui.core.renderers
{
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.utils.StringUtil;

	public class NullValueRenderer extends Label
	{
		public function NullValueRenderer()
		{
			super();
		}
		 private var _data:DataGridColumn;
	
		override public function get data():Object
		{
			return _data;
		}
	
		override public function set data(value:Object):void {
			_data = value as DataGridColumn;
			
			if(listData) {
            	var str:String = StringUtil.trim(DataGridListData(listData).label);
            	
            	if(str.indexOf("object")>0)
            		text = ""
            	else
                	text = str;
            }
		} 
		 /**
         * This method overrides the updateDisplayList method to set the value 
         * of the DataGrid column's element to an empty string if the value is null
         * otherwise show the actual value
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
        }
	}
}