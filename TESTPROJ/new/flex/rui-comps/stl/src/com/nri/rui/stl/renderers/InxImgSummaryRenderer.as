
package com.nri.rui.stl.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.renderers.ImgSummaryRenderer;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.utils.StringUtil;
	
	/**
	 * This is child class of the ImgSummaryRenderer to override a method for 
	 * teh columns which dont have a "dataField" property. On the other hand, it 
	 * has a labelfield to define what should the text in the cell of the
	 * DataGrid.
	 * 
	 * NOTE:: There should be dataField present for all the DataGrid Columns 
	 * except those which have a labelField property set.
	 */
	public class InxImgSummaryRenderer extends ImgSummaryRenderer
	{
		public function InxImgSummaryRenderer()
		{
			
			super();
		}
		
		 /**
		 * Overridden the showDetails method of the Super Class
		 * 
		 */
		override protected function showDetails():String {
			
			var totalContent:String = XenosStringUtils.EMPTY_STR;  		
    		var keys:Array = new Array();
			var values:Array = new Array();	
			var maxLen : int = 0;
			//New code
			if(listData){
				var dg :DataGrid = DataGrid(listData.owner);
				var op : String = parentDocument.opObj;
				
				
				var colStart:int=0;
				var colEnd:int=0;
				
				if(XenosStringUtils.equals(op,'QUERY') || XenosStringUtils.equals(op,'SEND_NEW')){					
					colStart = 2;
				}else if(XenosStringUtils.equals(op,'INX_REPORT_QUERY')){
					colStart=1;
				}else {
					colStart=3;
				}
				if(XenosStringUtils.equals(op,'SEND_NEW')||XenosStringUtils.equals(op,'INX_REPORT_QUERY')){
					colEnd = dg.columns.length -1;
				}else {
					colEnd = dg.columns.length;
				}
				trace("renderer.. : "+op+" "+colStart+":"+colEnd);
				for(var col:int=colStart;col<colEnd ;col++){
					var dgc : DataGridColumn = DataGridColumn(dg.columns[col]);
										
					var str : String = StringUtil.trim(dgc.headerText);
						keys.push(str);
						if(maxLen <= str.length) {
							maxLen = str.length;
						}
					//var val : String = StringUtil.trim(data[dgc.dataField]);
					var val : String = StringUtil.trim(dgc.itemToLabel(data));
						values.push(val);
				}

				for( var i:int =0;i<keys.length;i++){
				  	var keyValue:String = "";
				  	var value:String = "";
				  	keyValue = keys[i].toString();
				  	for(var j:int = String(keys[i]).length-1; j < maxLen;j++){
				  		keyValue += XenosStringUtils.EMPTY_STR;
				  	}
				  	
				  	keyValue += ":"+XenosStringUtils.EMPTY_STR;
				  	
				  	if(String(values[i]).indexOf("object")>0){
						value = Globals.EMPTY_STRING;
					}else {
						value = values[i];
					}
				  	
				  	/* if(value != Globals.EMPTY_STRING && value.charAt(0)=="F"){				  		
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
					} */
					
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
		}
}