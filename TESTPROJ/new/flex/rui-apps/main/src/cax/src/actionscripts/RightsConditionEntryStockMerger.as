




import com.nri.rui.core.controls.*;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

[Bindable]public var addedStockSummaryResult : ArrayCollection = new ArrayCollection(); 
[Bindable]public var stockObj : Object = null; 
		  private var rowIndex:int = -1;	
		  private var prevStockObj:Object = null;	
[Bindable]public var dataVisible : Boolean = true;		  


        /**
        * To add Stocks on merger event
        */
        private function addStockMergerInfo():void{
        	if(validateStockMergerEntry()){
        		if(XenosStringUtils.equals(mergerMode,"amend")) {
	        		addStockMergerService.url="cax/RightsConditionAmendDispatch.action?method=addStockMergerInfo";        			
        		} else {
	        		addStockMergerService.url="cax/rightsEventEntryConditionDispatch.action?method=addStockMergerInfo";        			
        		}        		
	        	addStockMergerService.request=populateStockMerger();
	        	addStockMergerService.send();
	        	initializeFileds(); 
        	}    
        	dataVisible = true; 	     	
        }
        
        /**
        * To remove Stocks on merger event
        */
         public function removeStockMergerInfo(data:Object):void{
        	rowIndex = addedStockSummaryResult.getItemIndex(data);
    		if(XenosStringUtils.equals(mergerMode,"amend")) {
        		removeStockMergerService.url="cax/RightsConditionAmendDispatch.action?method=removeStockMergerInfo";        			
    		} else {
        		removeStockMergerService.url="cax/rightsEventEntryConditionDispatch.action?method=removeStockMergerInfo";        			
    		}        	
            var req : Object = new Object();
            req['mergerNo'] = rowIndex;	          	
        	removeStockMergerService.request=req;
        	removeStockMergerService.send();   
        	dataVisible = true;      	
        	//data.isVisible = true;
			//addedStockSummaryResult.removeItemAt(rowIndex);   
			//addedStockSummaryResult.refresh();     	
        }  
        
        /**
        * To edit Stocks on merger event
        */
         public function editStockMergerInfo(data:Object):void{
         	addStock.visible= false;
         	addStock.includeInLayout = false;
         	cancelBtn.visible = true;
         	cancelBtn.includeInLayout= true;
         	saveBtn.visible=true;
         	saveBtn.includeInLayout=true; 
         	stockEntrySummary.enabled=false;
			data.isVisible = false;
			dataVisible = false; 
         	//stockObj = new Object();
        	rowIndex = addedStockSummaryResult.getItemIndex(data);        	
        	stockObj = addedStockSummaryResult.getItemAt(rowIndex);
        	prevStockObj = addedStockSummaryResult.getItemAt(rowIndex);
			this.security.instrumentId.text	= stockObj.instrumentCode 
			this.allotmentQuantityStr.text	=stockObj.allottedQuantityStr; 
			this.perShareStr.text		=stockObj.perShareStr;  
			this.ccyCashDividend.ccyText.text	=stockObj.ccyCashDividend  ; 
			this.allottedAmountStr.text	=stockObj.allottedAmountStr; 
			this.perShareCashDividend.text	=stockObj.perShareCashDividend;
			this.payOutCcy.ccyText.text	=stockObj.payOutCcy  ; 
			this.payOutPriceStr.text	=	stockObj.payOutPriceStr ; 									
											 					     	
        }              
        /**
        * To edit Stocks on merger event
        */        
        public function initializeFileds():void{
			this.security.instrumentId.text	="";
			this.allotmentQuantityStr.text	="";
			this.perShareStr.text		="";
			this.ccyCashDividend.ccyText.text	="";
			this.allottedAmountStr.text	="";
			this.perShareCashDividend.text	="";
			this.payOutCcy.ccyText.text	="";
			this.payOutPriceStr.text	="";
        }
        
        /**
        * To add Stocks on merger event
        */
        private function saveStockEditedEntry():void{        	        	     
        	if(validateStockMergerEntry()){
	    		if(XenosStringUtils.equals(mergerMode,"amend")) {
	        		editStockMergerService.url="cax/RightsConditionAmendDispatch.action?method=editStockMergerInfo";        			
	    		} else {
	        		editStockMergerService.url="cax/rightsEventEntryConditionDispatch.action?method=editStockMergerInfo";        			
	    		}          			        	
	            var req : Object = populateStockMerger();
	            req['editedIndex'] = rowIndex;	        	
	        	editStockMergerService.request=req;
	        	editStockMergerService.send();
	        	initializeFileds();
        	} 
        	        	     
        }  
        
        /**
        * To cancel Stock entry 
        */
        private function cancelStockEditedEntry():void{ 
        	dataVisible = true;  
    		if(XenosStringUtils.equals(mergerMode,"amend")) {
        		cancelEditedStockMergerService.url="cax/RightsConditionAmendDispatch.action?method=cancelStockMergerChange";        			
    		} else {
        		cancelEditedStockMergerService.url="cax/rightsEventEntryConditionDispatch.action?method=cancelStockMergerChange";        			
    		}    
    		//var req : Object = populateStockMerger(); 
		    	cancelEditedStockMergerService.send();      		       	   	
        }    
        
        /**
        * To popuate Stock Merger Request 
        */
        private function populateStockMerger():Object{        	
        	var reqObj:Object = new Object();
        	
        	reqObj.instrumentCode = this.security.instrumentId.text;
        	reqObj.allotmentAmountStr = this.allottedAmountStr.text;        	
        	reqObj.allotmentQuantityStr = this.allotmentQuantityStr.text;
        	reqObj.payOutCcy = this.payOutCcy.ccyText.text;
        	reqObj.ccyCashDividend = this.ccyCashDividend.ccyText.text;
        	reqObj.perShareStr = this.perShareStr.text;
        	reqObj.payOutPriceStr = this.payOutPriceStr.text;
        	reqObj.perShareCashDividend = this.perShareCashDividend.text;
			
			return reqObj;
			    	
        }                 
        
        /**
	    * This method works as the result handler of the add Stock Merger info services.
	    * 
	    */
	    public function stockAddResult(event:ResultEvent):void {
	        var rs:XML = XML(event.result);
						dataVisible = true; 
			if (null != event) {
				 if(rs.child("stockEntryList").length()>0) {
					errPage2.clearError(event);
		            addedStockSummaryResult.removeAll(); 		            	
					try {
					    for each ( var rec:XML in rs.stockEntryList.stockEntryList) {
					    	rec.isVisible = true;
		 				    addedStockSummaryResult.addItem(rec);
					    }					    

		            	addedStockSummaryResult.refresh();
		            	stockEntrySummary.visible = true;
		            	stockEntrySummary.includeInLayout = true;
					}catch(e:Error){
					    //XenosAlert.error(e.toString() + e.message);
					    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				    }
				 } else if(rs.child("Errors").length()>0) {
	                //some error found
				 	addedStockSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage2.showError(errorInfoList);//Display the error
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	addedStockSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	errPage2.removeError(); //clears the errors if any
				 }
	        }
	        
	        
	    }
	    
        /**
         * Validation of Entry of Stock Merger attributes 
         * @return true or false
         * 
         */
        private function validateStockMergerEntry():Boolean{
        	var errMsg:String="";
        	var instrumentCodeStr:String=StringUtil.trim(this.security.instrumentId.text);
        	var allotmentQty:String=StringUtil.trim(this.allotmentQuantityStr.text);
        	var perShareStr:String=StringUtil.trim(this.perShareStr.text);
        	if(XenosStringUtils.isBlank(instrumentCodeStr))
        		errMsg+="Please Enter Instrument Code.\n";      	
        	if(XenosStringUtils.isBlank(allotmentQty))
        		errMsg+="Please Enter Allotment Quantity.\n";
        	if(XenosStringUtils.isBlank(perShareStr))
        		errMsg+="Please Enter PerShare.\n";
        	
        	var payoutCcy:String=StringUtil.trim(this.payOutCcy.ccyText.text);
        	var payOutprice:String=StringUtil.trim(this.payOutPriceStr.text);        	
        	
	        if((payoutCcy == "") != (payOutprice == "")) {
	        	errMsg+="PayOutPrice and PayOutCcy should occur simultaniously!";
	    	}        	
        	
        	
        	if(!XenosStringUtils.isBlank(errMsg)){
        		XenosAlert.error(errMsg);
        		return false;
        	}
        	else
        		return true;
        }	    
	    
        
        /**
	    * This method works as the result handler of the Submit Query Http Services.
	    * 
	    */
	    public function saveEditedStockMergerResult(event:ResultEvent):void {
	        var rs:XML = XML(event.result);
			
			if (null != event) {
				if(rs.child("stockEntryList").length()>0){
					errPage2.clearError(event);
		            addedStockSummaryResult.removeAll(); 		            	
					try {
					    for each ( var rec:XML in rs.stockEntryList.stockEntryList) {
					    	rec.isVisible = true;
		 				    addedStockSummaryResult.addItem(rec);
					    }	
													   	        	
			        	addedStockSummaryResult.refresh();
			         	addStock.visible= true;
			         	addStock.includeInLayout = true;
			         	cancelBtn.visible = false;
			         	cancelBtn.includeInLayout= false;
			         	saveBtn.visible=false;
			         	cancelBtn.includeInLayout= false;        	
			        	initializeFileds();       	
			        	stockEntrySummary.enabled=true;
			        	dataVisible = true; 
					}catch(e:Error){
					    //XenosAlert.error(e.toString() + e.message);
					    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				    }
        	
				} else if(rs.child("Errors").length()>0) {
	                //some error found
				 	addedStockSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage2.showError(errorInfoList);//Display the error
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	addedStockSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	errPage2.removeError(); //clears the errors if any
				 }
	        }
	    }
	        
        /**
	    * This method works as the result handler of the Submit Query Http Services.
	    * 
	    */
	    public function cancelEditedStockMergerResult(event:ResultEvent):void {
	        var rs:XML = XML(event.result);
	
			if (null != event) {
				if(rs.child("stockEntryList").length()>0){
					errPage2.clearError(event);	
					addedStockSummaryResult.removeAll();					
					try {						
					    for each ( var rec:XML in rs.stockEntryList.stockEntryList) {					    	
					    	rec.isVisible = true;					    	
		 				    addedStockSummaryResult.addItem(rec);
					    }	
													   	        	
					       	
		        	//stockObj = prevStockObj;            	        	
		        	addedStockSummaryResult.refresh();
		         	addStock.visible= true;
		         	addStock.includeInLayout = true;
		         	cancelBtn.visible = false;
		         	cancelBtn.includeInLayout= false;
		         	saveBtn.visible=false;
		         	cancelBtn.includeInLayout= false;        	
		        	initializeFileds();  
		        	stockEntrySummary.enabled=true;  
		        	stockEntrySummary.visible = true;
		        	stockEntrySummary.includeInLayout = true; 		 
		        	dataVisible = true; 
					}catch(e:Error){
					    //XenosAlert.error(e.toString() + e.message);
					    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult')+" "+e.message);
				    }					
					
					
  
					      	
				} else if(rs.child("Errors").length()>0) {
	                //some error found
				 	addedStockSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage2.showError(errorInfoList);//Display the error
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	addedStockSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	errPage2.removeError(); //clears the errors if any
				 }
	        }
	    }	        
	        
	        
	    	 
	 