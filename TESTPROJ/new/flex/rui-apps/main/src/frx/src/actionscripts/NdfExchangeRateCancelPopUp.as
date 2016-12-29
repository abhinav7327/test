/*



*/

        // ActionScript file for BkgTradeEntryModule
        import com.nri.rui.core.Globals;
        import com.nri.rui.core.controls.XenosAlert;
        import com.nri.rui.core.controls.XenosEntry;
        import com.nri.rui.core.formatters.CustomDateFormatter;
        import com.nri.rui.core.startup.XenosApplication;
        import com.nri.rui.core.utils.DateUtils;
        import com.nri.rui.core.utils.HiddenObject;
        import com.nri.rui.core.utils.NumberUtils;
        import com.nri.rui.core.utils.OnDataChangeUtil;
        import com.nri.rui.core.utils.XenosStringUtils;
        import com.nri.rui.frx.validators.FrxTradeEntryValidator;
        
        import flash.events.Event;
        import flash.events.FocusEvent;
        import flash.events.MouseEvent;
        
        import mx.collections.ArrayCollection;
        import mx.controls.TextInput;
        import mx.events.CloseEvent;
        import mx.events.FlexEvent;
        import mx.events.ResourceEvent;
        import mx.resources.ResourceBundle;
        import mx.utils.StringUtil;
                    
              
             [Bindable]
             private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var mode : String = "entry";
            [Bindable]private var ndfRevalExchangeRatePk : String = "";
            [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
            [Bindable]private var exchangeRateList:ArrayCollection = null;
            private var keylist:ArrayCollection = new ArrayCollection();
      
              private function changeCurrentState():void{
                        vstack.selectedChild = rslt;
             }
          
        /**
         * Load the Entry/Amend/Cancel according to 
         * the operational mode (e.g. Entry/Amend/Cancel)
         */  
           public function loadAll():void{
               parseUrlString();
               super.setXenosEntryControl(new XenosEntry());
               this.dispatchEvent(new Event('cancelEntryInit'));
           }
           
            /**
             * Extracts the parameters and set them to some variables for 
             * query criteria from the Module Loader Info.
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
                    if(params != null){
                        for (var i:int = 0; i < params.length; i++) {
                            var tempA:Array = params[i].split("=");  
                            if (tempA[0] == "mode") {
                                mode = tempA[1];
                            }else if(tempA[0] == "ndfRevalExchangeRatePk"){
                                this.ndfRevalExchangeRatePk = tempA[1];
                            }
                        }                       
                    }                
                } catch (e:Error) {
                    trace(e);
                }               
            }
   
            /**
            * This method fires the dispatchaction to initialize the
            * NDF Exchange Rate cancel
            */
            override public function preCancelInit():void{              
                changeCurrentState();     
                app.submitButtonInstance = uCancelConfSubmit;                      
                var rndNo:Number= Math.random(); 
                super.getInitHttpService().url = "frx/ndfExchangeRateCancelQueryDispatch.action?";
                var reqObject:Object = new Object();
                reqObject.rnd = rndNo;
                reqObject.method= "confirmCancel";
                reqObject.modeOfOperation=this.mode;
                reqObject.ndfRevalExchangeRatePk = this.ndfRevalExchangeRatePk;
		  		reqObject.SCREEN_KEY = "12026";
                super.getInitHttpService().request = reqObject;
            }
        
           
            /**
            * This method is pre-result handler for the Banking Trade Cancel
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the Banking trade Cancel screen. 
            * (InitCancel-SEQ-2)
            */
            override public function preCancelResultInit():Object{
                keylist.addItem("selectedCancelRecord.tradeReferenceNo");
                keylist.addItem("selectedCancelRecord.baseDateStr");
                keylist.addItem("selectedCancelRecord.exchangeRate");
                keylist.addItem("selectedCancelRecord.revaluationCcy");
                keylist.addItem("selectedCancelRecord.calculationTypeStr");
               return keylist;
            }
            
            

            
            /**
            * This method populates the elements of the Banking
            * Trade Cancel screen(mxml)
            * from the map obtained from preCancelResultInit() (InitCancel-SEQ-3)
            */
            override public function postCancelResultInit(mapObj:Object): void{
                    
                commonResultPart(mapObj);
                uConfLabel.text= this.parentApplication.xResourceManager.getKeyValue('frx.exchangerate.cancel.userconf.label');
            }
            
           
          
             /*override public function preCancel():void{
                super._validator = null;
                super.getSaveHttpService().url = "frx/frxTrdCancelDetailsDispatch.action?"; 
                var reqObj:Object = new Object();
			 	reqObj.SCREEN_KEY = "326";
                reqObj.method="frxTrdDetailsCancelConfirm";
                super.getSaveHttpService().request = reqObj;
             }*/
             
             
            
           
            override public function postCancelResultHandler(mapObj:Object):void
            {
                submitCxlConfResult(mapObj);
            } 
            
            private function submitCxlConfResult(mapObj:Object):void{
	            if(mapObj!=null){    
	                if(mapObj["errorFlag"].toString() == "error"){
	                    usrConfErrPage.showError(mapObj["errorMsg"]);
	                }else if(mapObj["errorFlag"].toString() == "noError"){
	                    uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('frx.exchangerate.cancel.userconf.label');
		                uConfLabel.includeInLayout = true;
		                uConfLabel.visible = true;
		                uCancelConfSubmit.visible = true;
		                uCancelConfSubmit.includeInLayout = true;
		                //app.submitButtonInstance = uCancelConfSubmit;
		                sConfSubmit.includeInLayout = false;
		                sConfSubmit.visible = false;
		                sConfLabel.includeInLayout = false;
		                sConfLabel.visible = false;
	                    app.submitButtonInstance = uCancelConfSubmit;
	                    usrConfErrPage.clearError(super.getConfResultEvent());
	                    commonResultPart(mapObj);
	                }else{
	                    errPage.removeError();
	                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
	                }           
	            }
	        }
            

            override public function preCancelConfirm():void
            {
                var reqObj :Object = new Object();
                super.getConfHttpService().url = "frx/ndfExchangeRateCancelQueryDispatch.action?";  
				reqObj.SCREEN_KEY = "12027";				
                reqObj.modeOfOperation=this.mode;
                reqObj.method= "commitCancel";
                super.getConfHttpService().request = reqObj;
            }
            
       
            override public function postConfirmCancelResultHandler(mapObj:Object):void
            {
                submitUserConfResult(mapObj);
            }
            
           
           
           
           
            
           
            override public function doCancelSystemConfirm(e:Event):void
            {
                this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
            }
            
            
           
            
            private function commonResultPart(mapObj:Object):void{
            	this.uConfRefNo.text = mapObj[keylist.getItemAt(0)].toString();
                this.uConfBaseDate.text = mapObj[keylist.getItemAt(1)].toString();          
                this.uConfExchangeRate.text = mapObj[keylist.getItemAt(2)].toString();
                this.uConfRevaluationCcy.text = mapObj[keylist.getItemAt(3)].toString();                 
                this.uConfCalculationType.text = mapObj[keylist.getItemAt(4)].toString();
            }
            
            
            private function addCommonResultKeys():void{
                keylist = new ArrayCollection();
                keylist.addItem("selectedCancelRecord.tradeReferenceNo");
                keylist.addItem("selectedCancelRecord.baseDateStr");
                keylist.addItem("selectedCancelRecord.exchangeRate");
                keylist.addItem("selectedCancelRecord.revaluationCcy");
                keylist.addItem("selectedCancelRecord.calculationTypeStr");
            }
            
            private function commonResult(mapObj:Object):void{
                if(mapObj!=null){  
                    if(mapObj["errorFlag"].toString() == "error"){
                    	//app.submitButtonInstance = submit;
                        errPage.showError(mapObj["errorMsg"]);                      
                    }else if(mapObj["errorFlag"].toString() == "noError"){
                     usrConfErrPage.clearError(super.getSaveResultEvent());
                     errPage.clearError(super.getSaveResultEvent());                            
                     commonResultPart(mapObj);
                     changeCurrentState();
                    }else{
                        errPage.removeError();
                        XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                    }           
                }
            }
        
       
        override public function preCancelResultHandler():Object{
            addCommonResultKeys();
            return keylist;
        }
        
        override public function preConfirmCancelResultHandler():Object{
            addCommonResultKeys();
            return keylist;
        }
        
        private function submitUserConfResult(mapObj:Object):void{
            if(mapObj!=null){    
                if(mapObj["errorFlag"].toString() == "error"){
                    usrConfErrPage.showError(mapObj["errorMsg"]);
                    if(mode=="cancel"){
                    	uCancelConfSubmit.enabled = true;
                    	app.submitButtonInstance = uCancelConfSubmit;
                    }
                }else if(mapObj["errorFlag"].toString() == "noError"){
                    if(mode!="cancel"){
                      errPage.clearError(super.getConfResultEvent());
                    } else if(mode=="cancel"){
                    	sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('frx.exchangerate.cancel.sysconf.label');
		                uCancelConfSubmit.visible = false;
		                uCancelConfSubmit.includeInLayout = false;
                    }
                    sConfLabel.includeInLayout = true;
		            sConfLabel.visible = true;
                    uConfLabel.includeInLayout = false;
		            uConfLabel.visible = false;
                    sConfSubmit.includeInLayout = true;
	                sConfSubmit.visible = true;   
	                app.submitButtonInstance = sConfSubmit;
                    usrConfErrPage.clearError(super.getConfResultEvent());
                    commonResultPart(mapObj);
                }else{
                    errPage.removeError();
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
                }           
            }
        }
    
   /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
    	if(this.mode == 'entry'){
    		reqObj['SCREEN_KEY'] = "326";
    	} else if(this.mode == 'amend'){
    		reqObj['SCREEN_KEY'] = "11088";
    	} else if(this.mode == 'ptaxentry'){
    		reqObj['SCREEN_KEY'] = "11057";
    	}
        reqObj.method= "confirm";
        reqObj.rnd= Math.random();
        
        return reqObj;
    }
    
   
      private function doBack():void{
        //app.submitButtonInstance = submit;
        //vstack.selectedChild = qry;
      } 
  private function submitConfirm():void{ 
  	uCancelConfSubmit.enabled = false;
  	this.dispatchEvent(new Event('cancelEntryConf'))   
  }
        