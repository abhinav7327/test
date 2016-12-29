package com.nri.rui.core.controls
{
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.collections.ArrayCollection;
    import mx.controls.ComboBox;
    
	public class CustomizeSortOrder
	{
			
	    protected var sortFieldArray:Array =new Array();
	    protected var sortFieldDataSet:Array =new Array();
	    protected var sortFieldSelectedItem:Array =new Array();
	    
		public function CustomizeSortOrder(sf:Array,sd:Array,si:Array)
		{
			sortFieldArray=sf;
			sortFieldDataSet=sd;
			sortFieldSelectedItem=si;
		}
		
    public function init():void{
    	var i:int=0;
    	for(i=0;i<sortFieldArray.length;i++ ){
           var sortDataSet:ArrayCollection=new ArrayCollection((sortFieldDataSet[i]as ArrayCollection).toArray());
    		if(i>0){
    			for(var j:int=0;j<i;j++){
    				var selectedItem:Object=(sortFieldSelectedItem[j] as Object);
    				if(selectedItem!=null && selectedItem.value!=" "){
    					for(var k:int=0;k<sortDataSet.length;k++){
    						if(sortDataSet[k].value !=" " && XenosStringUtils.equals(selectedItem.value,sortDataSet[k].value)){
    							sortDataSet.removeItemAt(k);
    						}
    					}
    				}
    			}
    		}
    		(sortFieldArray[i] as ComboBox).dataProvider=sortDataSet;
    		(sortFieldArray[i] as ComboBox).selectedItem=sortFieldSelectedItem[i];
    	}
    }
    
    
     public function update(selectedItem:Object,index:int):void{
     	
     	for(var i:int=index+1;i<sortFieldArray.length;i++){
     		var control:ComboBox=(sortFieldArray[i] as ComboBox);
     		var sortDataSet:ArrayCollection=new ArrayCollection((sortFieldDataSet[i] as ArrayCollection).toArray());
     		var selObj:Object=null;
     		if(selectedItem.value!=" " && XenosStringUtils.equals(control.selectedItem.value,selectedItem.value)){
     			selObj=sortDataSet.getItemAt(0);
     		}else{
     			selObj=control.selectedItem;
     		}
     		var curSelectedItem:Object=null;
			for(var k:int=0;k<i;k++){
				if(k!=index){
				curSelectedItem=(sortFieldSelectedItem[k] as Object);
				}else{
				curSelectedItem=selectedItem;
				}
				
	     		for(var j:int=0;j<sortDataSet.length;j++){
	     			if(curSelectedItem.value!=" " && XenosStringUtils.equals(curSelectedItem.value,sortDataSet[j].value)){
	     				//XenosAlert.info("curSelectedItem.value :"+curSelectedItem.value+" j : "+j+" k : "+k+" i : "+i);
	     				sortDataSet.removeItemAt(j);
	     				break;
	     			}
	     		}
				
			}
     		
     		(sortFieldArray[i] as ComboBox).dataProvider=sortDataSet;     		
     		(sortFieldArray[i] as ComboBox).selectedItem=selObj;  
     		if(!XenosStringUtils.equals(selObj.value,sortFieldSelectedItem[i].value)){
     			sortFieldSelectedItem[i]=selObj;
     		}   		  
     		
     	}
     	sortFieldSelectedItem[index]=selectedItem;
     	
     }
     

	}
}