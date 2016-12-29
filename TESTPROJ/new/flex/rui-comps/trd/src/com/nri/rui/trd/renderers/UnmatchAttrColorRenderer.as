
package com.nri.rui.trd.renderers
{
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.utils.StringUtil;

	public class UnmatchAttrColorRenderer extends Label
	{
		public function UnmatchAttrColorRenderer()
		{
			super();
		}
		/**
         * This method overrides the updateDisplayList method to set the label 
         * of the DataGrid column's element to "NORMAL" in black if it is NORMAL else
         * set the label to "CANCEL" in red if it is CANCEL.
         */
         override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
             
            setStyle("color", 0x000000);
            var colName : String ;
			if(listData){
				var dg : DataGrid = DataGrid(listData.owner);
				var column : DataGridColumn = dg.columns[listData.columnIndex];
				if(data.unmatchColName != null && data.unmatchColName != ""){
					if(data.unmatchColName == column.dataField){
						setStyle("color", 0xFF0000);
					}
	            }
			}
			 super.updateDisplayList(unscaledWidth, unscaledHeight);
        }
        
	 } 
}