// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.events.CloseEvent;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;
import mx.rpc.events.ResultEvent;
import mx.containers.TitleWindow;

			
	  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var mode : String = "ENTRY";
            [Bindable]private var countryPk : String = "";
            private var keylist:ArrayCollection = new ArrayCollection();
            [Bindable]private var countryCodeSummaryResult:ArrayCollection = new ArrayCollection();
	  		[Bindable]private var editedCountryCode:XML = new XML();
	  		
	  		[Bindable]
	  		private var stateList:ArrayCollection = new ArrayCollection();
	  		[Bindable]
	  		private var stateSummaryResult:ArrayCollection = new ArrayCollection();
	  		[Bindable]
	  		private var countryCodeSubmitResult:ArrayCollection = new ArrayCollection();
	  		
	  		[Bindable]
	  		private var shortnameConfTxt:String="";
	  		[Bindable]
	  		private var officialnameConfTxt:String="";
	  		
	  		
	  		//service URL for editable datagrid.Changes according to mode
		    [Bindable]
		    private var addServiceUrl:String;
		    [Bindable]
		    private var editServiceUrl:String;
		    [Bindable]
		    private var deleteServiceUrl:String;
		    [Bindable]
		    private var backState:Boolean = true;
		    [Bindable]
		    private var uConfSubmitState:Boolean;
		    [Bindable]
		    private var cancelSubmitState:Boolean = false;
		    [Bindable]
		    private var uCancelConfSubmitState:Boolean = false;
		    [Bindable]
		    private var sConfSubmitState:Boolean = false;
		    [Bindable]
		    private var tempMode:String;
	  		
	  private function changeCurrentState():void{
				//hdbox1.selectedChild = this.rslt;
				//currentState = "result";
				vstack.selectedChild = rslt;
	 }
	 
   
			   public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosEntryControl(new XenosEntry());
           	   //XenosAlert.info("mode : "+mode);
           	   if(this.mode == 'ENTRY'){
           	   	tempMode = " Entry";
           	   	 this.dispatchEvent(new Event('entryInit'));
				//hdbox1.selectedChild = this.qry;
           	   	 //this.currentState="entryState";
           	   	 vstack.selectedChild = qry;
           	   	 addServiceUrl="ref/countryDispatch.action?method=addStateInfo";
		    	 editServiceUrl="ref/countryDispatch.action?method=updateCountryStateInfo";
		    	 deleteServiceUrl="ref/countryDispatch.action?method=deleteCountryStateInfo";
           	   } else if(this.mode == 'AMEND'){
           	   	tempMode = " Amend";
           	   	 this.dispatchEvent(new Event('amendEntryInit'));
				//hdbox1.selectedChild = this.qry;
           	   	 //this.currentState="entryState";
           	   	 vstack.selectedChild = qry;
           	   	 addServiceUrl="ref/countryAmendDispatch.action?method=addStateInfo";
		    	 editServiceUrl="ref/countryAmendDispatch.action?method=updateCountryStateInfo";
		    	 deleteServiceUrl="ref/countryAmendDispatch.action?method=deleteCountryStateInfo";
		    	 entryGrid.dataGridMode="amend";
		    	 
           	   } else { 
           	   	tempMode = " Cancel";
           	     this.dispatchEvent(new Event('cancelEntryInit'));
           	   }
           	     
           }
           
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
                    //XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
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
	                            //XenosAlert.info("movArray param = " + tempA[1]);
	                            mode = tempA[1];
	                           // Alert.show("Mode :: " + mode);
	                        }else if(tempA[0] == "countryPk"){
	                            this.countryPk = tempA[1];
	                        } 
	                    }                    	
                    }else{
                    	mode = "ENTRY";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }               
            }
            
            override public function preEntryInit():void{            	
		        var rndNo:Number= Math.random(); 		        
            	super.getInitHttpService().url = "ref/countryDispatch.action?method=initialExecute&&mode=entry&SCREEN_KEY=604&menuType=Y&rnd=" + rndNo;
            }
             override public function preAmendInit():void{     
            	initLabel.text = "Country Amend"       	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "ref/countryAmendDispatch.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "amendCountryDetails";
		  		reqObject.viewOption=this.mode;
		  		reqObject.countryPk = this.countryPk;
		  		reqObject['SCREEN_KEY']=600;
		  		super.getInitHttpService().request = reqObject;
            }
             override public function preCancelInit():void{  
            	//XenosAlert.info("preCancelInit");
            	trace("preCancelInit");
            	initLabel.text = "Country Cancel"    
            	backState = false; 
            	changeCurrentState();			             	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "ref/countryCancelDispatch.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "closeCountryDetails";
		  		reqObject.modeOfOperation=this.mode;
		  		reqObject.countryPk = this.countryPk;
		  		reqObject['SCREEN_KEY']=607;
		  		super.getInitHttpService().request = reqObject;
            }  
            
       
        
        private function addCommonKeys():void{        	
	    	keylist = new ArrayCollection();
	    	keylist.addItem("countryCodeTypeList.countryCodeType");
	    	/* keylist.addItem("dataSource");
	    	keylist.addItem("dataSourceList.item");
	    	keylist.addItem("inputPriceFormatList.item");
	    	keylist.addItem("priceTypeList.item"); */	
        }
        
        override public function preEntryResultInit():Object{
        	addCommonKeys(); 
        	return keylist;
        }
        
         override public function preAmendResultInit():Object{
        	addCommonKeys(); 
        	keylist.addItem("countryCrossRefs.countryCrossRef");
	    	keylist.addItem("country.shortName");
	    	keylist.addItem("country.officialName");
	    	keylist.addItem("countryStateList.countryState"); 
        	return keylist;
        }
        override public function preCancelResultInit():Object{
        	addCommonResultKeys();         	
        	return keylist;
        } 
        
        /**
        * To add Country Code Information
        */
        private function addCountryCode():void{
        	if(XenosStringUtils.isBlank(code.text)){
        		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.country.msg.error.mandatory.countrycode'));
        		return;
        	}
        	addCountryCodeService.request = populateCountryCode();
        	if(this.mode == "AMEND")
        		addCountryCodeService.url = "ref/countryAmendDispatch.action?method=addCountryCode"
        	else
        		addCountryCodeService.url = "ref/countryDispatch.action?method=addCountryCode"
        	addCountryCodeService.send();
        }
        
        public function editCountryCode(data:Object):void{
        	var reqObj : Object = new Object();
        	reqObj.editIndexCountry = countryCodeSummaryResult.getItemIndex(data);
        	data.isVisible=false;
        	countryCodeSummaryResult.refresh();
        	if(this.mode == "AMEND")
        		editCountryCodeService.url = "ref/countryAmendDispatch.action?method=editCountryCodeInfo"
        	else
        		editCountryCodeService.url = "ref/countryDispatch.action?method=editCountryCodeInfo"
        	editCountryCodeService.request = reqObj;
        	editCountryCodeService.send();
        }
        
         public function deleteCountryCode(data:Object):void{
        	var reqObj : Object = new Object();
        	reqObj.editIndexCountry = countryCodeSummaryResult.getItemIndex(data);
        	if(this.mode == "AMEND")
        		deleteCountryCodeService.url = "ref/countryAmendDispatch.action?method=deleteCountryCodeInfo"
        	else
        		deleteCountryCodeService.url = "ref/countryDispatch.action?method=deleteCountryCodeInfo"
        	deleteCountryCodeService.request = reqObj;
        	deleteCountryCodeService.send();
        }
        
        
        
        public function saveCountryCode():void{
        	if(XenosStringUtils.isBlank(editedcode.text)){
        		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.reportui.label.refnoref.country.msg.error.mandatory.countrycode'));
        		return;
        	}
        	
        	var reqObj : Object = new Object();
        	if(this.mode == "AMEND")
        		saveCountryCodeService.url = "ref/countryAmendDispatch.action?method=updateCountryCodeInfo"
        	else
        		saveCountryCodeService.url = "ref/countryDispatch.action?method=updateCountryCodeInfo"
        	saveCountryCodeService.request = populateEditedCountryCode();
        	saveCountryCodeService.send();
        }
        
        private function cancelEditCountryCode():void{
        	var reqObj : Object = new Object();
        	if(this.mode == "AMEND")
        		cancelEditCountryCodeService.url = "ref/countryAmendDispatch.action?method=cancelCountryCodeInfo"
        	else
        		cancelEditCountryCodeService.url = "ref/countryDispatch.action?method=cancelCountryCodeInfo"
        	cancelEditCountryCodeService.request = populateEditedCountryCode();
        	cancelEditCountryCodeService.send();
        }
        
        private function populateEditedCountryCode():Object{
        	var reqObj : Object = new Object();
	    	reqObj['countryCrossRef.countryCodeType'] = this.editedcodetype.text;
	    	
	    	reqObj['countryCrossRef.countryCode'] = this.editedcode.text;
	    	
	    	return reqObj;
        }
        
        /**
	    * This method works as the result handler of the Submit Query Http Services.
	    * 
	    */
	    public function CountryCodeResult(event:ResultEvent):void {
	        var rs:XML = XML(event.result);
	
			if (null != event) {
				 if(rs.child("countryCrossRefs").length()>0) {
					errPage.clearError(event);
					// if(this.mode != "AMEND")
		            	countryCodeSummaryResult.removeAll(); 
					try {
					    for each ( var rec:XML in rs.countryCrossRefs.countryCrossRef ) {
					    	rec.isVisible = true;
		 				    countryCodeSummaryResult.addItem(rec);
					    }
					    codeGrid.visible = true;
					    codeGrid.includeInLayout = true;
					    code.text = "";
					    editedCodeGrid.visible = false;
					    editedCodeGrid.includeInLayout = false;
		            	countryCodeSummaryResult.refresh();
		            	countryCodeSummary.visible = true;
		            	countryCodeSummary.includeInLayout = true;
					}catch(e:Error){
					    //XenosAlert.error(e.toString() + e.message);
					    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				    }
				 } else if(rs.child("Errors").length()>0) {
	                //some error found
				 	//countryCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);//Display the error
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	countryCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	errPage.removeError(); //clears the errors if any
				 }
	        }
	        
	        
	    }
        
        /**
	    * This method works as the result handler of the Submit Query Http Services.
	    * 
	    */
	    public function CountryCodeEditResult(event:ResultEvent):void {
	        var rs:XML = XML(event.result);
	
			if (null != event) {
				if(rs.child("countryCrossRef").length()>0){
					editedCountryCode = rs;
					codeGrid.visible = false;
					codeGrid.includeInLayout = false;
					editedCodeGrid.visible = true;
					editedCodeGrid.includeInLayout = true;
				} else if(rs.child("Errors").length()>0) {
	                //some error found
				 	countryCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);//Display the error
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	countryCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	errPage.removeError(); //clears the errors if any
				 }
	        }
	        
	        
	    }
        
        private function populateCountryCode():Object{
        	var reqObj : Object = new Object();
	    	reqObj['countryCrossRef.countryCodeType'] = this.codeType.selectedItem != null ? this.codeType.selectedItem : "";
	    	
	    	reqObj['countryCrossRef.countryCode'] = this.code.text;
	    	
	    	return reqObj;
        }
        
        private function commonInit(mapObj:Object):void{
	    	errPage.clearError(super.getInitResultEvent());
	    	code.text = "";
	    	shortName.text = "";
	    	officialName.text = "";
	    	 this.codeType.dataProvider = mapObj[keylist.getItemAt(0)] as ArrayCollection; 
	    	
	    	
        }
        
        override public function postEntryResultInit(mapObj:Object): void{
        	commonInit(mapObj);
        }
        
         override public function postAmendResultInit(mapObj:Object): void{
        	commonInit(mapObj);
        	var countryCodeTempResult:ArrayCollection = mapObj[keylist.getItemAt(1)] as ArrayCollection;
        	for each(var obj:Object in countryCodeTempResult){
        		if(obj.countryCodeType == "ISO2A"){
        			obj.isVisible = false;
        		}
        		else{
        			obj.isVisible = true;
        		}
	        	}
        	countryCodeSummaryResult = countryCodeTempResult;
        	shortName.text = mapObj[keylist.getItemAt(2)] != null ? mapObj[keylist.getItemAt(2)].toString() : "";
        	officialName.text = mapObj[keylist.getItemAt(3)] != null ? mapObj[keylist.getItemAt(3)].toString() : "";
        	
        	//populate xenosentrygrid
        	var tempEntryList:ArrayCollection=mapObj["countryStateList.countryState"] as ArrayCollection;
			stateList=processResultForAmendInit(tempEntryList);
			stateList.refresh();			
			//set amend data model for non-editable fields
			var amendModel:Object=new Object();			
			entryGrid.amendDataModel=amendModel;			
        	
        }
        private function commonResultPart(mapObj:Object):void{
        		 countryCodeSubmitResult=mapObj[keylist.getItemAt(0)] as ArrayCollection;
        		 shortnameConfTxt=mapObj[keylist.getItemAt(1)].toString();
        		 officialnameConfTxt=mapObj[keylist.getItemAt(2)].toString();
        		 stateSummaryResult=mapObj[keylist.getItemAt(3)] as ArrayCollection;
        		 //backState = true;
        		 uConfSubmitState = true;
        }
        override public function postCancelResultInit(mapObj:Object): void{
        	//XenosAlert.info("postCancelResultInit");	
            commonResultPart(mapObj);
        	uConfLabel.text=this.parentApplication.xResourceManager.getKeyValue('ref.country.label.countrycancel');
        	uConfSubmitState = false;
        	cancelSubmitState = true;
        }
        private function addCommonResultKeys():void{
        	keylist = new ArrayCollection();
	    	keylist.addItem("countryCrossRefs.countryCrossRef");
	    	keylist.addItem("country.shortName");	 
	    	keylist.addItem("country.officialName");
	    	keylist.addItem("countryStateList.countryState");  	
        } 
        
         private function commonResult(mapObj:Object):void{
        	
		 	//XenosAlert.info("commonResult ");
	    	if(mapObj!=null){    		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		//result = mapObj["errorMsg"] .toString();
		    		if(mode != "CANCEL"){
		    		  errPage.showError(mapObj["errorMsg"]);		    			
		    		}else{
		    			XenosAlert.error(mapObj["errorMsg"]);
		    		}
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    		
		    	 errPage.clearError(super.getSaveResultEvent());			    			
	             commonResultPart(mapObj);
				 changeCurrentState();
		    		
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
		    	}    		
	    	}
        } 
        
       
        
    	 private function setValidator():void{
		
		   /* var validateModel:Object={
                            exchangeRateEntry:{
                                 
                                 baseDate:this.baseDate.text,
                                 exchangeRateType:this.exchangeratetype.selectedItem != null ? this.exchangeratetype.selectedItem : "",
                                 calculationType:this.calculationtype.selectedItem != null ? this.calculationtype.selectedItem.value : "",
                                 againstCcy:this.againstccy.ccyText.text,
                                 rate: this.rate.text
                                        
                            }
                           }; 
	         super._validator = new ExchangeRateEntryValidator();
	         super._validator.source = validateModel ;
	         super._validator.property = "exchangeRateEntry";  */
		} 
		  override public function preEntry():void{
		 	//setValidator();
		 	//XenosAlert.info("preEntry ");
		 	super.getSaveHttpService().url = "ref/countryDispatch.action?";  
            super.getSaveHttpService().request  =populateRequestParams();
             super.getSaveHttpService().method="POST";
		 } 
		 
		  override public function preAmend():void{
		 	setValidator();
		 	super.getSaveHttpService().url = "ref/countryAmendDispatch.action?";  
            super.getSaveHttpService().request  =populateRequestParams();
		 } 
		 override public function preCancel():void{
		 	setValidator();
		 	//XenosAlert.info("preCancel");
		 	super._validator = null;
		 	super.getSaveHttpService().url = "ref/countryCancelDispatch.action?"; 
		 	 var reqObj:Object = new Object();
		 	 reqObj.method="submitCountryClose";
		 	 reqObj['SCREEN_KEY']=602;
            super.getSaveHttpService().request  =reqObj;
            super.getSaveHttpService().method="POST";
		 } 
		 
		 
		 override public function preEntryResultHandler():Object
		{
			 addCommonResultKeys();
			 return keylist;
		}
		
		override public function preAmendResultHandler():Object
		{
			addCommonResultKeys();
			return keylist;
		} 
		
		override public function postCancelResultHandler(mapObj:Object):void
		{
			//XenosAlert.info("postCancelResultHandler");
			if(submitUserConfResult(mapObj)){
				uConfLabel.text=this.parentApplication.xResourceManager.getKeyValue('ref.country.label.userconfirm')+this.parentApplication.xResourceManager.getKeyValue('ref.country.label.country')+tempMode;
				uConfLabel.includeInLayout = true;
				uConfLabel.visible = true;
	        	cancelSubmitState = false;
	        	uCancelConfSubmitState = true;
	        	sConfSubmitState = false;
	        	sConfLabel.includeInLayout = false;
	        	sConfLabel.visible = false;
   			}
		} 
		
		override public function postEntryResultHandler(mapObj:Object):void
		{
			commonResult(mapObj);
		}
		
		override public function postAmendResultHandler(mapObj:Object):void
		{
			commonResult(mapObj);
		}
		 
		 
		
		override public function preEntryConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "ref/countryDispatch.action?";  
			reqObj.method= "confirmCountryEntry";
			reqObj['SCREEN_KEY']=605;
            super.getConfHttpService().request  =reqObj;
		}
		
		override public function preAmendConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "ref/countryAmendDispatch.action?";  
			reqObj.method= "confirmCountryEntry";
			reqObj['SCREEN_KEY']=601;
            super.getConfHttpService().request  =reqObj;
		}
		
		override public function preCancelConfirm():void
		{
			//XenosAlert.info("preCancelConfirm");
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "ref/countryCancelDispatch.action?";  
			reqObj.method= "confirmCountryClose";
			reqObj['SCREEN_KEY']=603;
            super.getConfHttpService().request  =reqObj;
		}
		
		override public function postConfirmEntryResultHandler(mapObj:Object):void
		{
			submitUserConfResult(mapObj);
		}
		
		override public function postConfirmAmendResultHandler(mapObj:Object):void
		{
			submitUserConfResult(mapObj);
		}
		override public function postConfirmCancelResultHandler(mapObj:Object):void
		{
			if(submitUserConfResult(mapObj)){
			if(this.mode != "ENTRY") {
               	var titleWinInstance:TitleWindow = TitleWindow(this.parent.parent);
               	titleWinInstance.showCloseButton = false;
               	titleWinInstance.invalidateDisplayList();
               }	
        	cancelSubmitState = false;
        	uCancelConfSubmitState = false;
        	uConfLabel.includeInLayout = false;
			uConfLabel.visible = false;
			}
		} 
		
		 private function submitUserConfResult(mapObj:Object):Boolean{
    	//var mapObj:Object = mkt.userConfResultEvent(event);
    	if(mapObj!=null){    
    		//XenosAlert.info("object status : "+mapObj["errorFlag"].toString());		
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		XenosAlert.error(mapObj["errorMsg"].toString());
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    		if(mode!="CANCEL")
	    		  errPage.clearError(super.getConfResultEvent());
	    		backState = false;
			   uConfSubmit.enabled = true;	
               uConfLabel.includeInLayout = false;
               uConfLabel.visible = false;
               uConfSubmitState = false;
               sConfLabel.includeInLayout = true;
               sConfLabel.visible = true;
               sConfSubmitState = true;    
               sysConfMessage.includeInLayout=true;   
         		sysConfMessage.visible=true;     
	    	   return true;
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.erroroccurred'));
	    	}    		
    	}
    	return false;
    } 
    
      /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
     private function populateRequestParams():Object {
    	
    	 var reqObj : Object = new Object();
    	
    	reqObj.method= "submitCountryEntry";    	
    	reqObj['country.shortName']=shortName.text;
    	reqObj['country.officialName']=officialName.text;
    	reqObj.viewOption=this.mode;
    	reqObj['SCREEN_KEY']=605;
    	var random:Number=Math.random();
    	reqObj.rnd=random;

    	return reqObj;
    }
    
   override public function preResetEntry():void
   {
   	  
		       var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "ref/countryDispatch.action?method=reset&rnd=" + rndNo;
		  		countryCodeSummaryResult.removeAll();
		  		stateList.removeAll();	
		  		entryGrid.reset();	  		
		  		
   }
   override public function preResetAmend():void
   {
   	  
   	  			entryGrid.reset();
		       var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "ref/countryAmendDispatch.action?method=resetCountryAmend&rnd=" + rndNo; 
   }
   
   
	 override public function doEntrySystemConfirm(e:Event):void
	{
		      super.preEntrySystemConfirm();
	    	 this.dispatchEvent(new Event('entryReset'));
    		 backState = true;
             uConfLabel.includeInLayout = true;
             uConfLabel.visible = true;
             uConfSubmitState = true;
             sConfLabel.includeInLayout = false;
             sConfLabel.visible = false;
             sConfSubmitState = false;
             
             sysConfMessage.includeInLayout=false;   
         	sysConfMessage.visible=false;
             /* this.uConfBaseDate.text = "";
             this.uConfDataSource.text = "";
             this.uConfInputPrice.text = "";
             this.uConfInputPriceFormat.text = "";
             this.uConfPriceType.text = "";
             this.uConfSecurity.text = "";
             this.uConfMarket.text = "";
             this.uConfRemarks.text = ""; */
             /* this.againstccy.ccyText.text = "";
             this.rate.text = "";   */
			
			 //hdbox1.selectedChild = this.qry;
           	// this.currentState="entryState";
           	 vstack.selectedChild = qry;	
			 super.postEntrySystemConfirm();
		
	} 
	
	override public function doAmendSystemConfirm(e:Event):void
	{
		this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
	    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
	}
	override public function doCancelSystemConfirm(e:Event):void
	{
		this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
	    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
	} 
  
  private function doBack():void{
				//hdbox1.selectedChild = this.qry;
           	   	 //this.currentState="entryState";
           	   	 vstack.selectedChild = qry;	
  }  		
		  private function doSubmit():void
  {
  	
 	if(!XenosStringUtils.isBlank(officialName.text)){
	  	if(entryGrid.validateAllRecords(false)){
		  	if(this.mode == 'ENTRY'){
		  		this.dispatchEvent(new Event('entrySave'));
		  	}
		  	else{
		  	  this.dispatchEvent(new Event('amendEntrySave'));
		  	}
	  	}
  	 }else{
  	 	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.country.msg.error.mandatory.officialname'));
  	 }
  	
  }  		
  
  /**
   * This method reads each object from the ArrayCollection received from server 
   * and adds it to the dataprovider of the entry grid with corresponding datafield name
   * @param list ArrayCollection received from server
   * @return processed ArrayCollection
   * 
   */  
  private function processResultForAmendInit(list:ArrayCollection):ArrayCollection{
  	var newCollection:ArrayCollection=new ArrayCollection();
  	
  	for each(var rowData:Object in list){
  		var tempObj:Object=new Object();
  		tempObj['countryStates.stateCode']=rowData['stateCode'].toString();
  		tempObj['countryStates.shortName']=rowData['shortName'].toString();
  		tempObj['countryStates.officialName']=rowData['officialName'].toString(); 
  		
  		//required -special flag used by XenosEntryDataGrid
  		tempObj['isFreshObject']= false;
  		
  		newCollection.addItem(tempObj);  		
  	}
  	
  	return newCollection;
  }
		