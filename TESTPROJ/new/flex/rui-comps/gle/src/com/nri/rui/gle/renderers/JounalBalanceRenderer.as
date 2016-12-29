
package com.nri.rui.gle.renderers {
    import com.nri.rui.core.controls.XenosAlert;
    
    import mx.controls.Label;
    import mx.controls.dataGridClasses.DataGridListData;
    import mx.controls.listClasses.BaseListData;
    import mx.controls.dataGridClasses.DataGridColumn;

	/**
	 * This is an ItemRenderer to display the calculated value of a column 
	 * based on some conditions.
	 */
    public class JounalBalanceRenderer extends Label {
        public function JounalBalanceRenderer() {
            super();
        }
    
    override public function set data(value:Object):void
        {
            super.data = value;
            if(listData) {
                var str:String = data.type;
               // XenosAlert.info("Type :: " + str);
                if(data.type == "JOURNAL"){
                    if(data.aggrDrCrFlag == "DR"){                    
                        text = data.aggrStr;
                        if(data.aggrStr != 0)
                            text = text + "[DR]"; 
                    }else{                    
                        text = data.aggrStr;
                        if(data.aggrStr != 0)
                            text = text + "[CR]";
                    }
                }else if(data.type == "FORWARD" || data.type == "CLOSING"){
                    if(data.debitCreditFlag == "D"){
                        text = data.debitAmountStr;
                        if(data.debitAmountStr != "0")
                            text = text + "[DR]";
                    }else if(data.debitCreditFlag == "C"){
                        text = data.creditAmountStr;
                        if(data.creditAmountStr != "0")
                            text = text + "[CR]";
                    }
                }
                
                DataGridListData(listData).label = text;
            }
        }
        /**
         * This method overrides the updateDisplayList method to set the value 
         * of the DataGrid column's element to an empty string if the value is null
         * otherwise show the calculated value based on some conditions.
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
           
        }
    }
}