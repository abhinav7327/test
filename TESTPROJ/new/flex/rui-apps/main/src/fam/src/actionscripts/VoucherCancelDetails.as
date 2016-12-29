// ActionScript file

 
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.fam.FamConstants;
 
import flash.events.Event;
 
import mx.events.CloseEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.events.FaultEvent;
 	
[Bindable] public var cancelResult: Object;
[Bindable] public var mode:String = Globals.MODE_QUERY;
[Bindable] public var commandForm: Object = new Object();
[Bindable] private var commandFormId : String = XenosStringUtils.EMPTY_STR;
[Bindable] private var transactionPk : String = Globals.EMPTY_STRING;
[Bindable] private var backState:Boolean = false;    
[Bindable] private var cancelSubmitState:Boolean = true;
[Bindable] private var uCancelConfSubmitState:Boolean = false;
[Bindable] private var uCancelState:Boolean = false;
[Bindable] private var sConfSubmitState:Boolean = false;
[Bindable] private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
/**
 * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
 * 
 */ 
    public function parseUrlString():void {
        try {
            // Remove everything before the question mark, including
            // the question mark.
            var myPattern:RegExp = /.*\?/; 
            var s:String = this.loaderInfo.url.toString();
            s = s.replace(myPattern, "");
            // Create an Array of name=value Strings.
            var params:Array = s.split(Globals.AND_SIGN); 
             // Print the params that are in the Array.
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
          
            // Set the values of the salutation.
            for (var i:int = 0; i < params.length; i++) {
                var tempA:Array = params[i].split("=");  
                if (tempA[0] == FamConstants.TRANSACTION_PK) {
                    transactionPk = tempA[1];
                }
                if(tempA[0] == Globals.COMMAND_FORM_ID){
                	commandFormId = tempA[1];
                } 
            }
        } catch (e:Error) {
            trace(e);
        }
    }
    
    /**
     * This page initializes the Voucher Cancel Page
     */
	private function initPage():void {    
	  		
		var params : Object = new Object();
		
		parseUrlString();
		
		params["transactionPk"] = transactionPk;
		params["SCREEN_KEY"] = 12085;
		
		voucherCancelService.send(params);
	}
	 
	 /**
	  * Result Handler for voucherCancelService HTTPService
	  */          	
	 private function voucherCancelServiceHandler(event:ResultEvent):void {
	 		
  	      var result:XML = XML(event.result);
  	      
	      if (result != null) {
	      	  commandForm=result.voucherDetailPage;
			  if (commandForm != null) {
				  cancelResult=commandForm;
			  }
		  }
	 }
	 
	 private function doSubmit():void {
    	
    	var params : Object = new Object();
		
		params["SCREEN_KEY"] = 12115;
		
    	voucherCancelSubmitService.send(params);
     }
     
     private function voucherCancelSubmitServiceHandler(event:ResultEvent):void {
     	
	     	var result:XML = XML(event.result);
	     	
	     	errPage.clearError(event);
		    //var errorInfoList:ArrayCollection = new ArrayCollection();
		  
		    if (result != null) {
			    if (result.child("Errors").length() > 0) {
			          var errorInfoList : ArrayCollection = new ArrayCollection();
			          //populate the error info list              
			          for each (var error:XML in result.Errors.error) {
			             errorInfoList.addItem(error.toString());
			          }
			          //Display the error
			          errPage.showError(errorInfoList);
			          
		     	} else {          
			     	uConfLabel.includeInLayout=true;
			     	uConfLabel.visible=true;
			     	sconfMsg.includeInLayout=false;
					sconfMsg.visible=false;	
			    	cancelSubmit.enabled=false;
			    	cancelSubmitState=false;
			    	uCancelConfSubmitState=true;
			    	uCancelState=true;
			    	app.submitButtonInstance=uCancelConfSubmit;
				       
			      	commandForm=result.voucherDetailPage;
					
					if (commandForm != null) {
						  cancelResult = commandForm;
					}
		     	}
	     	}
     }

 	private function doConfirm():void {
    	    
    	    uCancel.enabled=false;
    	    uCancelConfSubmit.enabled=false;
    	    var params : Object = new Object();
    	    
    	    params["transactionPk"] = transactionPk;
    	    params["SCREEN_KEY"] = "12116";
    	    
    	    voucherCancelConfirmService.send(params);
    }
    
    private function faultAlert(event:FaultEvent):void {
    	uCancelConfSubmit.enabled=true;
    	uCancelConfSubmitState=true;
    	uCancel.enabled=true;
    	uCancelState=true;
    	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred.initialize') + event.fault.faultString)
    }
    
    private function voucherCancelConfirmServiceHandler(event:ResultEvent):void {
    	    
 		    uCancelConfSubmit.enabled=true;
 		    uCancel.enabled=true;
 		    var result:XML = XML(event.result);
 		    
 		    errPage.clearError(event);
	  	      
	        if (result != null) {
	        	
		      	   if (result.child("Errors").length() > 0) {
				          var errorInfoList : ArrayCollection = new ArrayCollection();
				          //populate the error info list              
				          for each (var error:XML in result.Errors.error) {
				             errorInfoList.addItem(error.toString());
				          }
				          //Display the error
				          errPage.showError(errorInfoList);
				          
			       } else {
			       		uConfLabel.includeInLayout=false;
					 	uConfLabel.visible=false;
					    sconfMsg.includeInLayout=true;
					    sconfMsg.visible=true;	
					    uCancelConfSubmit.enabled=false;
					    uCancelConfSubmitState=false;
					    uCancel.enabled=false;
					    uCancelState=false;
					    sConfSubmitState=true;
					    app.submitButtonInstance=sConfSubmit;
					    
			      	    commandForm=result.voucherDetailPage;
					    if (commandForm != null) {
						    cancelResult=commandForm;
					    }
			       }
		    }
     }
  
    private function doOk():void {
	    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
  