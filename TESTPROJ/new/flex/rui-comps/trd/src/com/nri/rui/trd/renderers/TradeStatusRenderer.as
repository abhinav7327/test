
package com.nri.rui.trd.renderers
{
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.utils.StringUtil;

	public class TradeStatusRenderer extends Label
	{
		public function TradeStatusRenderer()
		{
			super();
		}
		override public function set data(value:Object):void{
			super.data = value;
			if(listData){
                text = DataGridListData(listData).label ;                
            }
		}
		/**
         * This method overrides the updateDisplayList method to set the label 
         * of the DataGrid column's element to "NORMAL" in black if it is NORMAL else
         * set the label to "CANCEL" in red if it is CANCEL.
         */
         override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);             
            if(StringUtil.trim(text) == "CANCEL"){
                setStyle("color", 0xFF0000);
            } else if(StringUtil.trim(text) == "NORMAL"){
            	setStyle("color", 0x000000);
            }                        
        }
	 } 
        
}