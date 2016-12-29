package com.nri.rui.gle.renderers
{
	
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.renderers.ImgSummaryRenderer;
	
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.utils.StringUtil;
	public class GleLedgerSummaryRenderer extends ImgSummaryRenderer
	{	
		private const SPACE : String = ' ';
		public function GleLedgerSummaryRenderer()
		{
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
				var dg :DataGrid = DataGrid(listData.owner);
				for(var col:int=1;col< dg.columns.length;col++){
					var dgc : DataGridColumn = DataGridColumn(dg.columns[col]);
										
					var str : String = StringUtil.trim(dgc.headerText);
						keys.push(str);
						if(maxLen <= str.length) {
							maxLen = str.length;
						}
					var val : String = "";
					//Modified Portion starts --------					
					if(dgc.dataField != "status"){ // If the dataField is null it means it is Balance Column.
						val = StringUtil.trim(data[dgc.dataField]);
					}else{
						val = getStatus(String(data[dgc.dataField]));
					}
					//Modified Portion ends   --------
					values.push(val);
				}
				for( var i:int =0;i<keys.length;i++){
				  	var keyValue:String = "";
				  	var value:String = "";
				  	keyValue = keys[i].toString();
				  	
				  	for(var j:int = String(keys[i]).length-1; j < maxLen;j++){
				  		keyValue += SPACE;
				  	}
				  	
				  	keyValue += ":"+SPACE;
				  	if(String(values[i]).indexOf("object")>0){
						value += Globals.EMPTY_STRING;
					}else {
						value += values[i];
					}
					
					if(value != Globals.EMPTY_STRING && value.charAt(0)=="F"){				  		
						if(value.length > 1)
						{
							value = value.substring(1);
							if(!isNaN(Number(value)))
								value = values[i].toString().substring(1);
							else
								value = values[i];
						}
						else
							value = "";
					}
					
					keyValue += value;
					
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
		 
	   private function getStatus(item:String):String{
	   	if(item =="CANCEL"){
	   		return "CXL"
	   	}
	   	return " ";
	   	
	   }
	}
}