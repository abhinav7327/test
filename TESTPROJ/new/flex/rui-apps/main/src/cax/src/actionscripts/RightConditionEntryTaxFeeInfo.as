




import com.nri.rui.core.controls.*;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

[Bindable]public var addedTaxFeeSummaryResult : ArrayCollection = new ArrayCollection(); 
[Bindable]public var taxFeeSummaryConfResult : ArrayCollection = new ArrayCollection(); 
[Bindable]public var taxObj : Object = null; 
		  private var rowIndex:int = -1;	
		  private var prevTaxObj:Object = null;	
[Bindable]public var dataVisible : Boolean = true;		
[Bindable]public var taxMode : String;
[Bindable]public var taxFeeList : ArrayCollection = new ArrayCollection(); 
[Bindable]public var rateTypeList : ArrayCollection = new ArrayCollection(); 





    /**
    * To add tax on cash events
    */
    private function addTaxFeeInfo():void{
    	if(validateTaxFeeEntry()){
    		if(XenosStringUtils.equals(taxMode,"amend")) {
        		addTaxFeeService.url="cax/RightsConditionAmendDispatch.action?method=addConditionTaxFee";        			
    		} else {
        		addTaxFeeService.url="cax/rightsEventEntryConditionDispatch.action?method=addConditionTaxFee";        			
    		}        		
        	addTaxFeeService.request=populateTaxFeeInfo();
        	addTaxFeeService.send();
        	initializeFileds();
    	} 
    	    
    	dataVisible = true; 	     	
    }
    
    /**
    * To remove tax on cash event
    */
     public function removeTaxFeeInfo(data:Object):void{
    	rowIndex = addedTaxFeeSummaryResult.getItemIndex(data);
		if(XenosStringUtils.equals(taxMode,"amend")) {
    		removeTaxFeeService.url="cax/RightsConditionAmendDispatch.action?method=deleteConditionTaxFee";        			
		} else {
    		removeTaxFeeService.url="cax/rightsEventEntryConditionDispatch.action?method=deleteConditionTaxFee";        			
		}        	
        var req : Object = new Object();
        req['editIndexTaxFeeNo'] = rowIndex;	          	
    	removeTaxFeeService.request=req;
    	removeTaxFeeService.send();   
    	dataVisible = true;      	
		    	
    }  
    
    /**
    * To edit Stocks on merger event
    */
     public function editTaxFeeInfo(data:Object):void{
		data.isVisible = false;
		dataVisible = false; 
		rowIndex = addedTaxFeeSummaryResult.getItemIndex(data);
		if(XenosStringUtils.equals(taxMode,"amend")) {
    		editTaxFeeService.url="cax/RightsConditionAmendDispatch.action?method=editConditionTaxFee";        			
		} else {
    		editTaxFeeService.url="cax/rightsEventEntryConditionDispatch.action?method=editConditionTaxFee";        			
		}			  
        var req : Object = new Object();
        req['editIndexTaxFeeNo'] = rowIndex;				      			       		
		editTaxFeeService.request=req;
		editTaxFeeService.send();
							
										 					     	
    }              
    /**
    * To initialize
    */        
    private function initializeFileds():void{
		this.taxFeeId.selectedItem = "";
		this.rateType.selectedItem = "";
		this.rate.text = "";
    }
    
    /**
    * To save edit tax fee on cash div event
    */
    private function saveTaxFeeInfo():void{        	        	     
    	if(validateTaxFeeEntry()){
    		if(XenosStringUtils.equals(taxMode,"amend")) {
        		updateTaxFeeService.url="cax/RightsConditionAmendDispatch.action?method=updateConditionTaxFee";        			
    		} else {
        		updateTaxFeeService.url="cax/rightsEventEntryConditionDispatch.action?method=updateConditionTaxFee";        			
    		}          			        	
            var req : Object = populateTaxFeeInfo();
            req['editIndexTaxFeeNo'] = rowIndex;	        	
        	updateTaxFeeService.request=req;
        	updateTaxFeeService.send();
    	} 
    	initializeFileds();        	     
    }  
    
    /**
    * To cancel tax fee entry 
    */
    private function cancelTaxFeeInfo():void{ 
    	dataVisible = true;  
		if(XenosStringUtils.equals(taxMode,"amend")) {
    		cancelEditedTaxFeeService.url="cax/RightsConditionAmendDispatch.action?method=cancelConditionTaxFee";        			
		} else {
    		cancelEditedTaxFeeService.url="cax/rightsEventEntryConditionDispatch.action?method=cancelConditionTaxFee";
  		}
            var req : Object = new Object();
            req['editIndexTaxFeeNo'] = rowIndex;	        	
        	cancelEditedTaxFeeService.request=req;
        	cancelEditedTaxFeeService.send();        		        			   		       	   	
    }    
    
    /**
    * To popuate tax fee  Request 
    */
    private function populateTaxFeeInfo():Object{        	
    	var reqObj:Object = new Object();
    	if(XenosStringUtils.equals(eventType,"CASH_DIVIDEND")) {
    		reqObj.instrumentCode = this.cash1.security.instrumentId.text;
    	} else if (XenosStringUtils.equals(eventType,"COUPON_PAYMENT")) {
    		reqObj.instrumentCode = this.couponPayment1.security.instrumentId.text;
    	}
    	
    	reqObj.taxFeeId = this.taxFeeId.selectedItem;        	
    	reqObj.rateType = this.rateType.selectedItem.value;
    	reqObj.rate = this.rate.text;
		
		return reqObj;
		    	
    }                 
    
    /**
    * This method works as the result handler of the add tax fee info services.
    * 
    */
    public function taxAddResult(event:ResultEvent):void {
        var rs:XML = XML(event.result);
		dataVisible = true; 
		if (null != event) {
			 if(rs.child("conditionTaxFeeList").length()>0) {
				errPage.clearError(event);
	            addedTaxFeeSummaryResult.removeAll(); 		            	
				try {

				    for each ( var rec:XML in rs.conditionTaxFeeList.conditionTaxFeeList) {
				    	rec.isVisible = true;
	 				    addedTaxFeeSummaryResult.addItem(rec);
				    }					    

	            	addedTaxFeeSummaryResult.refresh();
	            	taxFeeEntrySummary.visible = true;
	            	taxFeeEntrySummary.includeInLayout = true;
	         
		         	addTaxFeeBtn.visible= true;
		         	addTaxFeeBtn.includeInLayout = true;
		         	cancelBtn.visible = false;
		         	cancelBtn.includeInLayout= false;
		         	saveBtn.visible=false;
		         	cancelBtn.includeInLayout= false;        	
		        	initializeFileds();       	
		        	taxFeeEntrySummary.enabled=true;
		        	dataVisible = true; 		            	
	            		            	
				}catch(e:Error){
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    }
			 } else if(rs.child("Errors").length()>0) {
			 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cax.error.adding.tax.fee.info'));
                //some error found
			 	addedTaxFeeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
			 	for each ( var error:XML in rs.Errors.error ) {
	 			   errorInfoList.addItem(error.toString());
				}
			 	errPage.showError(errorInfoList);//Display the error
			 } else {
			 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	addedTaxFeeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 }
        }
        
        
    }
    
    /**
    * This method works as the result handler of the add tax fee info services.
    * 
    */
    public function showEditTaxFeeResult(event:ResultEvent):void {
        var rs:XML = XML(event.result);
		dataVisible = false; 
		if (null != event) {
			 if(rs.child("conditionTaxFeeList").length()>0) {
				errPage.clearError(event);
	            addedTaxFeeSummaryResult.removeAll(); 		            	
				try {
				    for each ( var rec:XML in rs.conditionTaxFeeList.conditionTaxFeeList) {
				    	rec.isVisible = true;
	 				    addedTaxFeeSummaryResult.addItem(rec);
				    }	
			    	if(XenosStringUtils.equals(taxMode,"amend")) {
		    			//Initilizing tax fee list type
				    	var initcol:ArrayCollection = new ArrayCollection();		    	
				    	initcol.addItem(" ");    	    			
				        for each (rec in rs.taxFeeIdList.taxFeeIdDropdownList) {
						        	initcol.addItem(rec);
						        }	    		
			    		this.taxFeeId.dataProvider = initcol;				    			
			    		this.taxFeeList = initcol;				    		
			    	}
	            	addedTaxFeeSummaryResult.refresh();
	            	taxFeeEntrySummary.visible = true;
	            	taxFeeEntrySummary.includeInLayout = true;

	            	// Setting tax fee values
	            	var index:int = -1;
					var taxFeeIdObj:String;
	            	taxFeeIdObj = rs.taxFeeId;
			    	for each(var itemTax:Object in (taxFeeList as ArrayCollection)){
		    			if(itemTax == taxFeeIdObj){
		    			index = (taxFeeList as ArrayCollection).getItemIndex(itemTax);
		    		  	}								
			    	}		            	
	            	this.taxFeeId.selectedIndex = index;
	            	//setting rate type value
					var rateTypeObj:String;
	            	rateTypeObj = rs.rateType;
			    	for each(var itemRate:Object in (rateTypeList as ArrayCollection)){
			    			if(itemRate.value == rateTypeObj){
			    			index = (rateTypeList as ArrayCollection).getItemIndex(itemRate);
			    		  	}								
			    	}		            	
	            	this.rateType.selectedIndex = index;	
	            	//setting rate           	
	            	this.rate.text = rs.rate;
	            	
	            	//visibility enable/disable
		         	addTaxFeeBtn.visible= false;
		         	addTaxFeeBtn.includeInLayout = false;
		         	cancelBtn.visible = true;
		         	cancelBtn.includeInLayout= true;
		         	saveBtn.visible=true;
		         	saveBtn.includeInLayout=true; 
		         	taxFeeEntrySummary.enabled=false;		            		            	
				}catch(e:Error)	{
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    }
			 } else if(rs.child("Errors").length()>0) {
                //some error found
			 	addedTaxFeeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
			 	for each ( var error:XML in rs.Errors.error ) {
	 			   errorInfoList.addItem(error.toString());
				}
			 	errPage.showError(errorInfoList);//Display the error
			 } else {
			 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	addedTaxFeeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 }
        }
        
        
    }	    	    
    
    
    /**
    * This method works as the result handler of the save edited tax fee result handeler.
    * 
    */
    public function saveEditedTaxFeeResult(event:ResultEvent):void {
        var rs:XML = XML(event.result);
		
		if (null != event) {
			if(rs.child("conditionTaxFeeList").length()>0){
				errPage.clearError(event);
	            addedTaxFeeSummaryResult.removeAll(); 		            	
				try {
				    for each ( var rec:XML in rs.conditionTaxFeeList.conditionTaxFeeList) {
				    	rec.isVisible = true;
	 				    addedTaxFeeSummaryResult.addItem(rec);
				    }	
												   	        	
		        	addedTaxFeeSummaryResult.refresh();
		         	addTaxFeeBtn.visible= true;
		         	addTaxFeeBtn.includeInLayout = true;
		         	cancelBtn.visible = false;
		         	cancelBtn.includeInLayout= false;
		         	saveBtn.visible=false;
		         	cancelBtn.includeInLayout= false;        	
		        	initializeFileds();       	
		        	taxFeeEntrySummary.enabled=true;
		        	dataVisible = true; 
				}catch(e:Error){
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    }
    	
			} else if(rs.child("Errors").length()>0) {
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cax.error.saving.tax.fee.info'));
                //some error found
			 	addedTaxFeeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
			 	for each ( var error:XML in rs.Errors.error ) {
	 			   errorInfoList.addItem(error.toString());
				}
			 	errPage.showError(errorInfoList);//Display the error
			 } else {
			 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	addedTaxFeeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 }
        }
        
    }
        
    /**
    * This method works as the result handler of the cancel edited tax fee .
    * 
    */
    public function cancelEditedTaxFeeResult(event:ResultEvent):void {
        var rs:XML = XML(event.result);

		if (null != event) {
			if(rs != null){
				errPage.clearError(event);	
				addedTaxFeeSummaryResult.removeAll();					
				try {						
				    for each ( var rec:XML in rs.conditionTaxFeeList.conditionTaxFeeList) {					    	
				    	rec.isVisible = true;					    	
	 				    addedTaxFeeSummaryResult.addItem(rec);
				    }	
												   	        	
				//visibility enable/disable        	        	
	        	addedTaxFeeSummaryResult.refresh();
	         	addTaxFeeBtn.visible= true;
	         	addTaxFeeBtn.includeInLayout = true;
	         	cancelBtn.visible = false;
	         	cancelBtn.includeInLayout= false;
	         	saveBtn.visible=false;
	         	cancelBtn.includeInLayout= false;        	
	        	initializeFileds();  
	        	taxFeeEntrySummary.enabled=true;  
	        	taxFeeEntrySummary.visible = true;
	        	taxFeeEntrySummary.includeInLayout = true; 		 
	        	dataVisible = true; 
				}catch(e:Error){
				    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult')+e.message);
			    }					      	
			} else if(rs.child("Errors").length()>0) {
                //some error found
			 	addedTaxFeeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
			 	for each ( var error:XML in rs.Errors.error ) {
	 			   errorInfoList.addItem(error.toString());
				}
			 	errPage.showError(errorInfoList);//Display the error
			 } else {
			 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	addedTaxFeeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 }
        }
        
    }	
    
    
    /**
     * Validation of Entry of tax fee attributes 
     * @return true or false
     * 
     */
    private function validateTaxFeeEntry():Boolean{
    	var errMsg:String="";
    	var instrumentCodeStr:String = "";
    	if(XenosStringUtils.equals(eventType,"CASH_DIVIDEND")) {
    		instrumentCodeStr = this.cash1.security.instrumentId.text;
    	} else if (XenosStringUtils.equals(eventType,"COUPON_PAYMENT")) {
    		instrumentCodeStr = this.couponPayment1.security.instrumentId.text;
    	}       	
    	var taxFeeId:Object=this.taxFeeId.selectedItem;
    	
    	var rateType:String=StringUtil.trim(this.rateType.selectedItem != null ? this.rateType.selectedItem.value : "");
    	var rateStr:String=StringUtil.trim(this.rate.text);        	
    	if(XenosStringUtils.isBlank(instrumentCodeStr))
    		errMsg+="Please Enter Security Code.\n";      	
    	if(taxFeeId == null)
    		errMsg+="Please Select Tax Fee Id.\n";
    	if(XenosStringUtils.isBlank(rateStr))
    		errMsg+="Please Enter Rate.\n";        		
    	if(XenosStringUtils.isBlank(rateType))
    		errMsg+="Please Select Rate Type.";
    	
    	if(!XenosStringUtils.isBlank(errMsg)){
    		XenosAlert.error(errMsg);
    		return false;
    	}
    	else
    		return true;
    }	            
	        
	        
	    	 
	 