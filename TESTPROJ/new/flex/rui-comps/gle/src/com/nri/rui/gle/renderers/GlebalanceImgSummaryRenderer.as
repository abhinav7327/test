
package com.nri.rui.gle.renderers {
	
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.renderers.ImgSummaryRendererForAdvancedDataGrid;
	
	import mx.controls.AdvancedDataGrid;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.utils.StringUtil;
	
	/**
	 * This is child class of the ImgSummaryRenderer to override a method for 
	 * displaying the "Balance" column, which doesn't have a dataField for the
	 * DataGrid Column, has been used as a identifier for the column.
	 * 
	 * NOTE:: There should be dataField present for all the DataGrid Columns 
	 * except Summery and the Balance Column.
	 */ 
	public class GlebalanceImgSummaryRenderer extends ImgSummaryRendererForAdvancedDataGrid{		
		private const SPACE : String = ' ';
		public function GlebalanceImgSummaryRenderer() {
			super();	
		}
		/**
		 * Overridden the showDetails method of the Super Class
		 * 
		 */
		override protected function showDetails():String {
			var totalContent:String = "";  		
    		var keys:Array = new Array();
			var values:Array = new Array();	
			var maxLen : int = 0;		
			//New code
			if(listData){
				//var dg :DataGrid = DataGrid(listData.owner);
				var dg : AdvancedDataGrid = AdvancedDataGrid(listData.owner);
				for(var col:int=1;col< dg.columns.length;col++){
					//var dgc : DataGridColumn = DataGridColumn(dg.columns[col]);
					var dgc : AdvancedDataGridColumn = AdvancedDataGridColumn(dg.columns[col]);
					//var column : DataGridColumn = dg.columns[listData.columnIndex];
					var column : AdvancedDataGridColumn = dg.columns[listData.columnIndex];
					//var text:String = data[column.dataField];
		           /*  if(text=="Sub Total:" || text=="Grand Total:")
	            			this.sView.visible=false;
	            		else
	            			this.sView.visible=true; */
										
					var str : String = StringUtil.trim(dgc.headerText);
						keys.push(str);
						if(maxLen <= str.length) {
							maxLen = str.length;
						}
					var val : String = "";
					//Modified Portion starts --------					
					//if(dgc.dataField != null){ // If the dataField is null it means it is Balance Column.
						val = StringUtil.trim(dgc.itemToLabel(data));
					/* }else{
						val = getDataForBalanceColumn();
					} */
					//Modified Portion ends   --------
					values.push(val);
				}
				for( var i:int =0;i<keys.length;i++){
					var keyValue:String = "";
				  	keyValue = keys[i].toString();
				  	
				  	for(var j:int = String(keys[i]).length-1; j < maxLen;j++){
				  		keyValue += SPACE;
				  	}
				  	
				  	keyValue += ":"+SPACE;
				  	if(String(values[i]).indexOf("object")>0){
						keyValue += Globals.EMPTY_STRING;
					}else {
						keyValue += values[i];
					}
				  	if((keyValue.length * defaultCharSize) > maxToolTipWidth)
						keyValue += "\n";
					
					if(keyValue.length > maxKeyValueLen)
							maxKeyValueLen = keyValue.length;
					
					totalContent += keyValue + "\n";
					keyValue = "";			
				 }
			}
			return totalContent;
		}
		/**
		 * Returns the value for a specific column depending on some conditions.
		 * 
		 */
		private function getDataForBalanceColumn():String {
			var str:String = "";
			if(listData) {                               
                    if(data.subTotalDebitCreditFlag == "DR"){                    
                        str = data.balanceTBStr;
                        if(data.balanceTBStr != 0)
                            str = str + "[DR]"; 
                    }else{                    
                        str = data.balanceTBStr;
                        if(data.balanceTBStr != 0)
                            str = str + "[CR]";
                    }
            }
            return str;
		}
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
        	if(listData){
		            if(data.shortName=="Sub Total:" || data.shortName=="Grand Total:"){
            			this.sView.visible=false;
            		}
            		else
            			this.sView.visible=true;
				}
        }
		
		
	}
}