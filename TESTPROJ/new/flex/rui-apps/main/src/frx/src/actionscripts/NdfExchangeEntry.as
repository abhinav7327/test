




import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.events.CloseEvent;
import mx.formatters.NumberBase;
import mx.rpc.events.ResultEvent;


            
      
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     [Bindable]public var cxlMessage:String="will be cancelled";
     
            [Bindable]private var mode : String = "entry";
			private var rndNo:Number = 0;            
            private var keylist:ArrayCollection = new ArrayCollection();
            [Bindable]private var selectedItemArray:Array; 
            [Bindable]private var queryResult:ArrayCollection = new ArrayCollection();

			private function init():void{
				parseUrlString();
				var obj:Object=new Object();
				rndNo = Math.random();
				app.submitButtonInstance = uConfSubmit;
				obj=populateRequestParams();
				obj.rnd = rndNo+"";
				obj.method="confirmExchangeRate";
		        obj.modeOfOperation = "amend";
				obj.rowPkArray = selectedItemArray;
				obj.SCREEN_KEY = "12024";
				ndfExchangeRateAmend.request = obj;
				ndfExchangeRateAmend.send();
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
                            if (tempA[0] == "mode") {
                                mode = tempA[1];
                               // Alert.show("Mode :: " + mode);
                            }else if(tempA[0] == "selectedItems"){
                                this.selectedItemArray = (tempA[1] as String).split(",");
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
            keylist.addItem("SelectedExchangeList.SelectedExchange");
        } 
        
    
    
     public function LoadUserConfirmPage(event:ResultEvent):void {
			if (null != event) {
				if(event.result != null){
					if(event.result.ndfExchangeRateQueryActionForm != null){
						if(event.result.ndfExchangeRateQueryActionForm.SelectedExchangeList!= null) {
							if(event.result.ndfExchangeRateQueryActionForm.SelectedExchangeList.SelectedExchange != null){
								errPage.clearError(event);
					            queryResult.removeAll();
					            if(event.result.ndfExchangeRateQueryActionForm.SelectedExchangeList.SelectedExchange  is ArrayCollection){
					            	queryResult = event.result.ndfExchangeRateQueryActionForm.SelectedExchangeList.SelectedExchange ;
					            }else{
					            	queryResult.addItem(event.result.ndfExchangeRateQueryActionForm.SelectedExchangeList.SelectedExchange );
					            }
							}else {
							 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
							 	queryResult.removeAll(); // clear previous data if any as there is no result now.
							 	errPage.removeError(); //clears the errors if any
							 }
						 } else if(event.result.ndfExchangeRateQueryActionForm.Errors != null) {
			                //some error found
			                // clear previous data if any as there is no result now.
						 	queryResult.removeAll(); 
						 	var errorInfoList : ArrayCollection = new ArrayCollection();
			                //populate the error info list 	
			                if(event.result.ndfExchangeRateQueryActionForm.Errors.error != null){
			                	if(event.result.ndfExchangeRateQueryActionForm.Errors.error is ArrayCollection){
			                		errorInfoList = event.result.ndfExchangeRateQueryActionForm.Errors.error;
			                	}else{
			                		errorInfoList.addItem(event.result.ndfExchangeRateQueryActionForm.Errors.error);
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
	    public function submitAmend(event:Event):void {
	    	uConfSubmit.enabled = false;
	    	var reqObj:Object = new Object();
	   		reqObj.method = "commitExchangeRate";
	    	rndNo = Math.random();
			reqObj.rnd = rndNo+"";
	        reqObj.modeOfOperation = "amend";	
			reqObj.SCREEN_KEY = "12025";	
	    	ndfExchangeRateAmendConfirm.request=reqObj;
			ndfExchangeRateAmendConfirm.send();
	    }
     private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();        
        var rowNumArray:Array = new Array();        
        for(var index:int=0; index<selectedItemArray.length; index++ ){
        	var indexArray:Array = String(selectedItemArray[index]).split("|");
        	rowNumArray.push(indexArray[0]);
            reqObj['resultView['+ indexArray[0] + '].baseDateStr'] = this.parentDocument.owner.queryResult[indexArray[1]].baseDate;
            reqObj['resultView['+ indexArray[0] + '].exchangeRate'] = this.parentDocument.owner.queryResult[indexArray[1]].exchangeRate;
        } 
		reqObj.rowNoArray = rowNumArray;
        return reqObj;
    }
    public function LoadSysConfirmPage(event:ResultEvent):void {
        	if (null != event) {
        		trace(event.result);
    			if(null != event.result.XenosErrors){
    				errPage.displayError(event);	
    			}else{
		    		uConfSubmit.includeInLayout = false;
					uConfSubmit.visible = false;
					uConfBack.includeInLayout = false;
					uConfBack.visible = false;
	    			sConfSubmit.includeInLayout = true;
        			sConfSubmit.visible = true;  
        			app.submitButtonInstance = sConfSubmit;
        			uConfLabel.includeInLayout = false;
               		uConfLabel.visible = false;
	    	        sConfLabel.includeInLayout = true;
    	            sConfLabel.visible = true;      			
    			}
        	}
               	
    }
    private function closeHandler():void{
   		parentDocument.owner.dispatchEvent(new Event('amendSubmit'));
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
    private function closeHandlerOnError():void{
      	this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
    
   

	  
    
        