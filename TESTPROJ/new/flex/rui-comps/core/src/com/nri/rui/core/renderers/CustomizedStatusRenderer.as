
package com.nri.rui.core.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridListData;

	public class CustomizedStatusRenderer extends Label
	{
		private const CXL_COLOR:uint = 0xFF0000; // Red
		
		public function CustomizedStatusRenderer()
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
            	text = DataGridListData(listData).label;
            	
            	if(XenosStringUtils.equals(text, Globals.STATUS_CANCEL) || XenosStringUtils.equals(text, "CXL")) {
                	text = "CXL";
                }
            }    
		}
		
		/**
         * This method overrides the updateDisplayList method to set the label 
         * of the DataGrid column's element to do the following:
         * 
         * 1. If it is NORMAL then show NORMAL, or
         * 2. If it is CANCEL then set the label to CXL in red.
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
                              	
            if(XenosStringUtils.equals(text, Globals.STATUS_CANCEL) || XenosStringUtils.equals(text, "CXL")) {
                setStyle("color", CXL_COLOR);
            }
        }
	}
}