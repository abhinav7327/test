




import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.core.utils.ProcessResultUtil;
import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.events.CloseEvent;
import mx.formatters.NumberBase;
import mx.rpc.events.ResultEvent;


            
      
     [Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     [Bindable]public var cxlMessage:String="will be cancelled";
     [Bindable]private var mode : String = "entry";
	 private var rndNo:Number = 0;            
     private var keylist:ArrayCollection = new ArrayCollection();
     [Bindable]private var selectedAuthRejectArray:Array; 
     [Bindable]private var selectedCashEntryPkArray:Array; 
     [Bindable]private var queryResult:ArrayCollection = new ArrayCollection();
     //[Bindable]private var refreshRequired:Boolean = false;
	 
 	 private function init():void{
		parseUrlString();
		var obj:Object=new Object();
		rndNo = Math.random();
		obj=populateRequestParams();
		obj.rnd = rndNo+"";
		obj.method="doPreConfirmAuthorize";
		obj.SCREEN_KEY = "12056";
		stlCashTransferAuthorizationUconf.request = obj;
		stlCashTransferAuthorizationUconf.resultFormat = "xml";
		stlCashTransferAuthorizationUconf.send();
	}
           
            /**
             * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
             * 
             */ 
            public function parseUrlString():void {
                try {
                    var myPattern:RegExp = /.*\?/; 
                    var s:String = this.loaderInfo.url.toString();
                    s = s.replace(myPattern, "");
                    var params:Array = s.split(Globals.AND_SIGN); 
                    var keyStr:String;
                    var valueStr:String;
                    var paramObj:Object = params;
                  
                    // Set the values of the salutation.
                    if(params != null){
                        for (var i:int = 0; i < params.length; i++) {
                            var tempA:Array = params[i].split("=");  
                            if(tempA[0] == "selectedCashEntryPkArray"){
                                this.selectedCashEntryPkArray = (tempA[1] as String).split(",");
                            }else if(tempA[0] == "selectedAuthRejectArray"){
                                this.selectedAuthRejectArray = (tempA[1] as String).split(",");
                            } 
 
                        }                       
                    }                 

                } catch (e:Error) {
                    trace(e);
                }
            }
            
        
        private function commonResultPart(mapObj:Object):void{
        }
        private function addCommonResultKeys():void{
            keylist = new ArrayCollection();
            keylist.addItem("SelectedAuthRejectList.SelectedAuthReject");
        } 
        
    
    /*
     public function LoadUserConfirmPage(event:ResultEvent):void {
			if (null != event) {
				if(event.result != null){
					if(event.result.stlCashTransferAuthQueryActionForm != null){
						if(event.result.stlCashTransferAuthQueryActionForm.SelectedAuthRejectList!= null) {
							if(event.result.stlCashTransferAuthQueryActionForm.SelectedAuthRejectList.SelectedAuthReject != null){
								errPage.clearError(event);
					            queryResult.removeAll();
					            if(event.result.stlCashTransferAuthQueryActionForm.SelectedAuthRejectList.SelectedAuthReject  is ArrayCollection){
					            	queryResult = event.result.stlCashTransferAuthQueryActionForm.SelectedAuthRejectList.SelectedAuthReject ;
					            }else{
					            	queryResult.addItem(event.result.stlCashTransferAuthQueryActionForm.SelectedAuthRejectList.SelectedAuthReject);
					            }					            
							}else {
							 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
							 	queryResult.removeAll(); // clear previous data if any as there is no result now.
							 	errPage.removeError(); //clears the errors if any
							 }
						 } else if(event.result.stlCashTransferAuthQueryActionForm.Errors != null) {
			                //some error found
			                // clear previous data if any as there is no result now.
						 	queryResult.removeAll(); 
						 	var errorInfoList : ArrayCollection = new ArrayCollection();
			                //populate the error info list 	
			                if(event.result.stlCashTransferAuthQueryActionForm.Errors.error != null){
			                	if(event.result.stlCashTransferAuthQueryActionForm.Errors.error is ArrayCollection){
			                		errorInfoList = event.result.stlCashTransferAuthQueryActionForm.Errors.error;
			                	}else{
			                		errorInfoList.addItem(event.result.stlCashTransferAuthQueryActionForm.Errors.error);
			                	}
			                }		 	
						 	//Display the error
						 	errPage.showError(errorInfoList);
						 } else {
						 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
						 	queryResult.removeAll(); // clear previous data if any as there is no result now.
						 	errPage.removeError(); //clears the errors if any
						 }
					}
				}
	        }
     }
     */
     
     
public function LoadUserConfirmPage(event:ResultEvent):void
{
	if(null != event){
	   var rs:XML = XML(event.result);
	   queryResult.removeAll();
	   if(rs.child("Errors").length()>0) {	   	    
           var errorInfoList : ArrayCollection = new ArrayCollection();
           for each ( var error:XML in rs.Errors.error ) {
               errorInfoList.addItem(error.toString());               
               trace(error.toString());                
            }
           errPage.showError(errorInfoList);//Display the error
	   }else{
	   	   errPage.clearError(event);
           if(rs.SelectedAuthRejectList != null) {
	            for each(var objXml:XML in rs.SelectedAuthRejectList.SelectedAuthReject){	            	                   
	                queryResult.addItem(objXml);
	           }        
	       }
	    }	
	}
}
     
     
     
	    public function submitConfirm(event:Event):void {
	    	uConfSubmit.enabled = false;
	    	var reqObj:Object = new Object();
	   		reqObj.method = "doConfirmEntry";
			reqObj.SCREEN_KEY = "12057";	
	    	stlCashTransferAuthorizationSconf.request=reqObj;
			stlCashTransferAuthorizationSconf.send();
	    }
     private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();        
		reqObj.selectedCashEntryPkArray = selectedCashEntryPkArray;
		reqObj.selectedAuthRejectArray = selectedAuthRejectArray;
        return reqObj;
    }
    public function LoadSysConfirmPage(event:ResultEvent):void {
        	if (null != event) {
    			if(null != event.result.XenosErrors){
    				errPage.displayError(event);	
    				uConfSubmit.enabled = true;
    			}else{
		    		uConfSubmit.includeInLayout = false;
					uConfSubmit.visible = false;
					uConfBack.includeInLayout = false;
					uConfBack.visible = false;
        			uConfLabel.includeInLayout = false;
               		uConfLabel.visible = false;
	    			sConfSubmit.includeInLayout = true;
        			sConfSubmit.visible = true;  
	    	        sConfLabel.includeInLayout = true;
    	            sConfLabel.visible = true;      			
    			}
        	}
               	
    }
    private function submitOkConfirm():void{
		        var obj:Object=new Object();
				obj.method="okSystemConformation";
			    obj.unique= new Date().getTime() + "" ;
				stlCashTransferAuthorizationOkConfirmRequest.request=obj;
			    stlCashTransferAuthorizationOkConfirmRequest.send();
				//refreshRequired = true;
    }
    private function closeHandlerOnError():void{
      	this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
   /**
	* Back to query result page. 
	*/
	 public function backToQueryResultPage():void {
		app.submitButtonInstance = null;
		this.parentDocument.owner.submitQuery();
		closeHandeler();
	}
   /**
    * Closes the handler to close the popup.
    */
	 public function closeHandeler():void{		
		this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
	}
    
   

	  
    
        