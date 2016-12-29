
package com.nri.rui.core.utils
{
	import mx.collections.ArrayCollection;
	import mx.formatters.NumberBase;
	import mx.utils.ObjectUtil;
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.XenosStringUtils;
	import mx.controls.AdvancedDataGrid;
	import mx.collections.SortField;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import com.nri.rui.core.controls.XenosAdvancedDataGrid;
	
	/** This class is a Util class for processing the result data in
	 * 	the summary screens. Required for sorting the columns in the datagrid
	 * 	by clicking the column headers.	 	
	 */ 
	
	public class ProcessResultUtil
	{
		public var clickedColumn:Object;  //The datagridcolumn or advanceddatagridcolumn 
		
		public var dataGridRef:Object;
		
		public function ProcessResultUtil()
		{
			super();
		}
		
		
		/**
	   	 * This method is used to check if all the object properties exist in the Datagrid rows
	   	 * If a property does not exist ,creates it and sets it to null.
	   	 */
		public static function process(result:ArrayCollection,columns:Array):ArrayCollection {
			var processedResult:ArrayCollection = new ArrayCollection();
			try {
			for (var count:int ;count<result.length;count++)
			{
				var obj:Object=result.getItemAt(count);
				for each(var column:Object in columns)
				{
						if (column.dataField != null){
							if(!obj.hasOwnProperty(column.dataField))
    						{
    							obj[column.dataField]=XenosStringUtils.EMPTY_STR; //null;//not ""							
    						}
						}
						
				}				
				processedResult.addItem(obj);
			}
			} catch(e:Error){
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error("Error :: " + e.getStackTrace());
			}
			return processedResult;			
		}
		
		/**
	   	 * This method is used to check if all the object properties exist in the Datagrid rows
	   	 * If a property does not exist ,creates it and sets it to null.
	   	 */
		public static function processUsingDataField(result:ArrayCollection,dataFields:Array):ArrayCollection {
			var processedResult:ArrayCollection = new ArrayCollection();
			
			for (var count:int ;count<result.length;count++)
			{
				var obj:Object=result.getItemAt(count);
				
				for each(var dataField:Object in dataFields)
				{
					 
						if(!obj.hasOwnProperty(dataField))
						{
							obj[dataField]=null; //not ""							
						}
						
				}				
				processedResult.addItem(obj);
			}
			return processedResult;			
		}
		
		/**
	   	 * Comparator method for sorting Numeric fields.
	   	 */
		 public  function sortNumeric(obj1:Object,obj2:Object):int {		    	
	  		var dataFormatter:NumberBase = new NumberBase(".",",",".",",");
	  		
	  		//~ This section is for Xenos AdvancedData Grid multi-column sort, where numeric field is involved.
	  		// ===START====
    		
    		if(dataGridRef != null){
    			var col:ArrayCollection = XenosAdvancedDataGrid(dataGridRef).dataProvider as ArrayCollection;
    			var advDataGridCol:AdvancedDataGridColumn = AdvancedDataGridColumn(clickedColumn);
    			if(col.sort.fields.length > 0){
					col.sort.fields.pop();
				}
				var srtFld:SortField = new SortField(advDataGridCol.dataField,false,advDataGridCol.sortDescending,true);
				col.sort.fields.push(srtFld);
				col.refresh();
    		}
    		
    		// ===END===
    		
    		//sorting should be based on labelFunction if any 
    		
    		var text1:String=clickedColumn.itemToLabel(obj1); 
    		var text2:String=clickedColumn.itemToLabel(obj2);
    		
	  		if(text1==null && text2==null)
	  			return 0;
	  		else if(text1==null && text2!=null)
	  			return -1;
	  		else if(text1!=null && text2==null)
	  			return 1;
	  		else
	  		{		  			
	    		var valueA:Number = Number(dataFormatter.parseNumberString(text1));
	    		var valueB:Number = Number(dataFormatter.parseNumberString(text2));	    		
	    		return ObjectUtil.numericCompare(valueA, valueB);   
    		}			
    	 }
    	
    	/**
	   	 * Comparator method for sorting String fields.
	   	 */	
    	public function sortString(obj1:Object, obj2:Object):int {
    		//sorting should be based on labelFunction if any 
    		var text1:String=clickedColumn.itemToLabel(obj1); 
    		var text2:String=clickedColumn.itemToLabel(obj2);
    		//trace(clickedColumn.dataField+":  "+text1+"  : "+text2); 
    		if(text1==null && text2==null)
	  			return 0;
	  		else if(text1==null && text2!=null)
	  			return -1;
	  		else if(text1!=null && text2==null)
	  			return 1;
	  		else	  			    		
    			return ObjectUtil.stringCompare(text1,text2);
    				 	
		} 

	}
}