// ActionScript file

 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 
 import flash.events.Event;
 
 import mx.collections.ArrayCollection;
 import mx.containers.TitleWindow;
 import mx.events.CloseEvent;
 import mx.rpc.events.ResultEvent;
 
 	[Bindable]
    private var queryResult:XML= new XML();
    
    [Bindable]private var journalResult:ArrayCollection = new ArrayCollection();
    [Bindable]private var journalResultDebit:ArrayCollection = new ArrayCollection();
    [Bindable]private var journalResultCredit:ArrayCollection = new ArrayCollection();
    [Bindable]public var mode:String="QUERY";
    
    [Bindable]private var backState:Boolean = false;    
    [Bindable]private var cancelSubmitState:Boolean = true;
    [Bindable]private var uCancelConfSubmitState:Boolean = false;
    [Bindable]private var sConfSubmitState:Boolean = false;
    [Bindable]private var refNoStr:String="";
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
  /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function submitDetailQuery():void {    	
    	parseUrlString();   	
    	var req : Object = new Object();
    	req.voucherPk=entryPk;
    	
    	//If cancel mode
    	if(this.mode=="CANCEL"){
    		app.submitButtonInstance=cancelSubmit;
    		req.mode="cancel";
    		gleVoucherQueryRefDetails.url="gle/gleVoucherCancelQueryResult.action?method=viewVoucherDetails";
    	}
    	else{
    		gleVoucherQueryRefDetails.url="gle/gleVoucherQueryResult.action?method=viewVoucherDetails";
    	}
    	gleVoucherQueryRefDetails.request=req;
    		
    	gleVoucherQueryRefDetails.send();
    	//stateChangeHandler();
    	
    } 
    
    private function parseUrlString():void {
        try {
            // Remove everything before the question mark, including
            // the question mark.
            var myPattern:RegExp = /.*\?/; 
            var s:String = this.loaderInfo.url.toString();
            s = s.replace(myPattern, "");
            // Create an Array of name=value Strings.
            var params:Array = s.split("&"); 
             // Print the params that are in the Array.
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
          
            // Set the values of the salutation.
            for (var i:int = 0; i < params.length; i++) {
                var tempA:Array = params[i].split("=");  
                if (tempA[0] == "voucherPk") {
                    entryPk = tempA[1];
                } else if (tempA[0] == "mode") {
                    mode = tempA[1];
                }
            }
        } 
        catch (e:Error) {
            trace(e);
        }
       
    }
 /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    public function onResult(event:ResultEvent):void {
    	if (null != event) {      
    		if(null == event.result){
                //queryResult.removeAll(); // clear previous data if any as there is no result now.
            	if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
            	  XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            	} else { // Must be error
            		
            	}            	
            }else {
            	queryResult = event.result as XML;
            	
            	 /* if(event.result.journalQueryResultActionForm.journalListColl.journalList is ArrayCollection) {
                                journalResult = event.result.journalQueryResultActionForm.journalListColl.journalList as ArrayCollection;
	                } else {
	                        journalResult.removeAll();
	                        journalResult.addItem(event.result.journalQueryResultActionForm.journalListColl.journalList);
	                } */
	                // Debit Journal Results
	                /* if(event.result.journalQueryResultActionForm.drJournalDetailListColl.drJournalDetailList is ArrayCollection) {
	                		XenosAlert.info("Debit ArrayCollection");
	                        journalResultDebit = event.result.journalQueryResultActionForm.drJournalDetailListColl.drJournalDetailList as ArrayCollection;
	                } else {
	                        journalResultDebit.removeAll();
	                        journalResultDebit.addItem(queryResult.drJournalDetailListColl.drJournalDetailList);
	                        XenosAlert.info("Not an ArrayCollection Debit:: "+queryResult.drJournalDetailListColl.drJournalDetailList.total);
	                }
	                //Credit Journal Results
	                if(event.result.journalQueryResultActionForm.crJournalDetailListColl.crJournalDetailList is ArrayCollection) {
	                		XenosAlert.info("Credit ArrayCollection");
	                        journalResultCredit = event.result.journalQueryResultActionForm.crJournalDetailListColl.crJournalDetailList as ArrayCollection;
	                } else {
	                        journalResultCredit.removeAll();
	                        journalResultCredit.addItem(queryResult.crJournalDetailListColl.crJournalDetailList);
	                        XenosAlert.info("Not an ArrayCollection Credit:: "+queryResult.drJournalDetailListColl.drJournalDetailList.total);
	                } */
            	
            	
	        } 
        }else {
            //queryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
    }
    
    private function doBack():void{
    	
    }
    private function doCancel():void{
    	cancelSubmit.enabled=false;
    	gleVoucherCxl.send();
    }
    private function doSubmitUserConf():void{
    	uCancelConfSubmit.enabled=false;
    	gleVoucherCxlConfirm.send();
    }
    private function doSysConfirm():void{
    	this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
	    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
    
     public function gleVoucherCxlResult(event:ResultEvent):void {
	        var rs:XML = XML(event.result);
			cancelSubmit.enabled=true;
			if (null != event) {
				 if(rs.child("Errors").length()>0) {
	                //some error found				 	
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);//Display the error
				 	errPage.setFocus();
				 } 
				 else if(rs.name()=="journalQueryResultActionForm"){
				 	//result found	
				 	uConfLabel.includeInLayout=true;	
				 	sconfMsg.includeInLayout=false;
				 	sconfMsg.visible=false;		 	
				 	cancelSubmitState=false;
				 	uCancelConfSubmitState=true;
				 	app.submitButtonInstance=uCancelConfSubmit;
				 }
	        }	        
	}
	 public function gleVoucherCxlConfirmResult(event:ResultEvent):void {
	        var rs:XML = XML(event.result);
			uCancelConfSubmit.enabled=true;
			if (null != event) {
				 if(rs.child("Errors").length()>0) {
	                //some error found				 	
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);//Display the error
				 	errPage.setFocus();
				 } 
				 else if(rs.name()=="journalQueryResultActionForm"){
				 	//result found
				 	refNoStr=rs.cxlVoucherRefNo;
				 	uConfLabel.includeInLayout=false;
				 	uConfLabel.visible=false;
				 	sconfMsg.includeInLayout=true;
				 	sconfMsg.visible=true;
				 					 	
				 	uCancelConfSubmitState=false;
				 	sConfSubmitState=true;
				 	
				 	//hide close button			 	
	               	var titleWinInstance:TitleWindow = TitleWindow(this.parent.parent);
	               	titleWinInstance.showCloseButton = false;
	               	titleWinInstance.invalidateDisplayList();
	               	app.submitButtonInstance=sConfSubmit;
		            	
				 }
	        }	        
	}
	
  