// ActionScript file for Fund Maintenance
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.oms.validator.FundMaintenanceValidator;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.ResourceEvent;
import mx.events.ValidationResultEvent;
import mx.resources.ResourceBundle;
import mx.rpc.events.ResultEvent;

private var keylist:ArrayCollection = new ArrayCollection();
[Bindable]private var mappingList:ArrayCollection=new ArrayCollection();
[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]private var mode : String = "entry";
[Bindable]private var fundInstrParticipantPk : String = "";
[Bindable]private var stateList:ArrayCollection = new ArrayCollection();

/*HTTP request URLs for the advanced data grid edit/save/delete operation */
/* [Bindable]private var addServiceUrl:String="oms/fundMaintenanceEntry.action?method=addMappingEntry";
[Bindable]private var editServiceUrl:String="oms/fundMaintenanceEntry.action?method=updateFundMaintenanceEntry";
[Bindable]private var deleteServiceUrl:String="oms/fundMaintenanceEntry.action?method=deleteMappingEntry"; */

/* [Bindable]private var backState:Boolean = true;
[Bindable]private var uConfSubmitState:Boolean;
[Bindable]private var cancelSubmitState:Boolean = false;
[Bindable]private var uCancelConfSubmitState:Boolean = false;
[Bindable]private var sConfSubmitState:Boolean = false; */
[Bindable]public var result:ArrayCollection=new ArrayCollection();
	  		
	  	/**
	  	 * Activates the child for user conf and sys conf
	  	 */ 
	  	private function changeCurrentState():void{
				vstack.selectedChild = rslt;
				app.submitButtonInstance = uConfSubmit;
		}
	 
    	/**
    	 * At the time of loading the module if the module specific Resource is not loaded then load them
    	 * 
    	 */ 
    	public function loadResourceBundle():void{
        	var locales:String = this.parentApplication.xResourceManager.localeChain[0];
        
        	var resourceModuleURL:String = "assets/appl/oms/omsResources_" + locales + ".swf";
           
        	var bundle:ResourceBundle = ResourceBundle(resourceManager.getResourceBundle(locales, "omsResources"));
           
        	var eventDispatcher:IEventDispatcher = null;
           		if(bundle == null){    
            		eventDispatcher = this.parentApplication.xResourceManager.loadResourceModule(resourceModuleURL);
            		eventDispatcher.addEventListener(ResourceEvent.ERROR, errorHandler);            
        	}        
        	this.parentApplication.xResourceManager.update();
    	}
    
		/**
		 * Error handler for loading the resource bundle for OMS
		 */     
    	private function errorHandler(event:ResourceEvent):void{
        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('oms.msg.common.info.resource.bundle.erroroccurred', new Array(event.errorText)));
    	}
    	
    	/**
    	 * Checks the mode of operation
    	 * invoked at creation complete of the Page
    	 */ 
		public function loadAll():void{
           parseUrlString();
           super.setXenosEntryControl(new XenosEntry());
           if(this.mode == 'entry'){
           	   	 this.dispatchEvent(new Event('entryInit'));
           	   	 vstack.selectedChild = qry;
           	   } else if(this.mode == 'AMEND'){
           	   	
           	   } else {
           	   	 
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
                        }else if(tempA[0] == "fundInstrParticipantPk"){
                            this.fundInstrParticipantPk = tempA[1];
                        } 
                    }                    	
                }else{
                	mode = "entry";
                }                 

            } catch (e:Error) {
                trace(e);
            }               
        }
     
	    /**
		 * Overridden method - responsible for initialization process before the 
		 * details page for entry is displayed.
		 */      
	    override public function preEntryInit():void{  
			super.getInitHttpService().url = "oms/fundMaintenanceEntry.action?method=initialExecute";
	 	}
	 	
     	/**
	 	 * Overridden method - result handler of the preEntryInit() request.
	 	 */    
	    override public function preEntryResultInit():Object{
     	  	addCommonResultKes();         	
        	return keylist;
        }
        
        /**
      	 *  Overridden method - responsible for adding the fields to the 'keyList'.
      	 *  The fields added to the key list will be displayed in the Cancel Details UI.
      	 */ 
     	private function addCommonResultKes():void{
        	keylist = new ArrayCollection();
	    	keylist.addItem("Errors.error"); 
	    	keylist.addItem("buySellFlag.item");
	    	keylist.addItem("upDownFlag.item");
	    	
        }
        
        /**
         * Invoked from the Result method for the httpRequests
         */	
        private function commonInit(mapObj:Object):void{ 
	    		if(mapObj["Errors.error"].toString().length > 0){
		    		  errPage.showError(mapObj["Errors.error"]);
		    		}		    			
        		else{  
					
					var initcol:ArrayCollection = new ArrayCollection();
					for each(var item:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
	    					initcol.addItem(item);
	    			}
					buySellFlag.dataProvider=initcol;
					
					initcol = new ArrayCollection();
	    			for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
	    					initcol.addItem(item);
	    			}
					roundUpDownFlag.dataProvider=initcol;
					
					
					
					errPage.clearError(super.getInitResultEvent());
					this.fundPopUp.fundCode.setFocus();
					app.submitButtonInstance=submit;
	        	}
        }
        
		/**
     	 * Overridden method - responsible for displaying the fields (added to the "keyList") 
     	 * in the Entry details UI.Since for the entry page of Fund Maintenance no default value is to be
     	 * displayed hence the 'keyList' is not formed for the entry part.
     	*/  
 	    override public function postEntryResultInit(mapObj:Object): void{
			commonInit(mapObj);
		}
		
		/**
		  * Overridden method - responsible for resetting the fields ; both client side and server side
		 */ 
        override public function preResetEntry():void{
        	errPage.clearError(super.getSaveResultEvent());	
		 	super.getResetHttpService().url = "oms/fundMaintenanceEntry.action?method=reset";
		 	this.fundPopUp.fundCode.text = "";
		 	this.instPopUp.instrumentId.text = "";
		 	this.fundPopUp.fundCode.setFocus();
		 	mappingList.removeAll();
		 	mappingList.refresh();
			//entryGrid.reset();		 
   		}
   		
   		/**
   		 * Invoked on clicking the submit button of the entry UI.
   		 */ 
   		private function doSubmit():void
  		{
  		 	if(mappingList.length > 0){
	  			if(this.mode == 'entry'){
	  				this.dispatchEvent(new Event('entrySave'));
	  				this.submit.enabled= false;
	  			}
	  			else{
	  	  			this.dispatchEvent(new Event('amendEntrySave'));
	  			}
  			} else{
  				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('oms.fund.error.maapingnotdefined'));
  			}
  		}
  		
  		/**
  		 * Sets the URL for entry
  		 */ 
  		override public function preEntry():void{		 	
		 	super.getSaveHttpService().url = "oms/fundMaintenanceEntry.action?method=submitFundMappingEntry";  
            super.getSaveHttpService().method="POST";
		}
		
		/**
		 * Overridden method - adds the fields to the 'keylist'
		 */ 
		override public function preEntryResultHandler():Object{
			 addCommonResultKeys();
			 return keylist;
		}
		
		/**
		 * adds the fields to the 'keylist'
		 */ 
		private function addCommonResultKeys():void{
        	keylist = new ArrayCollection();
	    	keylist.addItem("entryPageList.entryPage");	    	
        }
        
        /**
        * Overridden method - to display the result in the UI.
        */ 
        override public function postEntryResultHandler(mapObj:Object):void{
			commonResult(mapObj);
		}
		/**
		 * Checks for error and diplays the error/result in the UI.
		 */
		 private function commonResult(mapObj:Object):void{
        	
	    	if(mapObj!=null){    		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		if(mode != "cancel"){
		    		  errPage.showError(mapObj["errorMsg"]);
		    		  this.submit.enabled = true;		    			
		    		}else{
		    			XenosAlert.error(mapObj["errorMsg"]);
		    		}
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    		
		    	 errPage.clearError(super.getSaveResultEvent());			    			
	             commonResultPart(mapObj);
				 changeCurrentState();
				 uConfSubmit.setFocus();
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.datanotfound'));
		    	}    		
	    	}
        }
        
        /**
        * Diplays the result in the user conf page
        */ 
        private function commonResultPart(mapObj:Object):void{
        		result = mapObj[keylist.getItemAt(0)] as ArrayCollection;
        		result.refresh(); 
	            resultGrid.dataProvider=result;
        }
        
        /**
        * On clicking the 'confirm' button of the user confirmation page
        */ 
        private function doUserConfSubmit():void{
        	this.back.enabled = false;
  			uConfSubmit.enabled=false;
  			{this.mode == 'entry' ?  this.dispatchEvent(new Event('entryConf')) :  this.dispatchEvent(new Event('amendEntryConf'))};
  		}
  		
  		/**
  		 * On clicking the 'back' button of the user confirmation page
  		 */ 
  		private function doBack():void{
  				this.submit.enabled = true;
  			 	uConfSubmit.enabled = true;	
  			 	errPage.clearError(super.getConfResultEvent());
	    	 	errPage1.clearError(super.getConfResultEvent());
     			vstack.selectedChild = qry;	
  		}
  		
  		/**
  		 * Overridden method - invoked to hit the request for entry UI to user confirm UI.
  		 */ 
  		override public function preEntryConfirm():void{
			super.getConfHttpService().url = "oms/fundMaintenanceEntry.action?method=confirmFundMaintenanceEntry";
		} 
		
		/**
		 * Overridden method - invoked to diplay the fields in the user confirmation UI.
		 */ 
		override public function postConfirmEntryResultHandler(mapObj:Object):void{
			submitUserConfResult(mapObj);
		}
		
		/**
		 * Diplays the error/result in the user confirm UI.
		 */ 
		private function submitUserConfResult(mapObj:Object):Boolean{
			
	    	if(mapObj!=null){
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		errPage1.showError(mapObj["errorMsg"]);
		    		this.back.enabled = true;
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    		if(mode!="cancel")
		    		  errPage.clearError(super.getConfResultEvent());
		    	   errPage1.clearError(super.getConfResultEvent());
		    	   this.back.includeInLayout = false;
		    	   this.back.visible = false;
				   uConfSubmit.enabled = true;	
	               uConfLabel.includeInLayout = false;
	               uConfLabel.visible = false;
	               uConfSubmit.includeInLayout = false;
	               uConfSubmit.visible = false;
	               sConfLabel.includeInLayout = true;
	               sConfLabel.visible = true;
	               sConfSubmit.includeInLayout = true;
	               sConfSubmit.visible = true;    
	               sysConfMessage.includeInLayout=true;   
	               sysConfMessage.visible=true;
	               sConfSubmit.setFocus();
	               app.submitButtonInstance = sConfSubmit;
	               return true;
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.msg.common.info.erroroccurred'));
		    	}    		
	    	}
	    	return false;
    	}
    	/**
    	 * System confirmation UI.
    	 */ 
    	override public function doEntrySystemConfirm(e:Event):void{
		     super.preEntrySystemConfirm();
	    	 this.dispatchEvent(new Event('entryReset'));
    		 this.back.includeInLayout = true;
    		 this.back.visible = true;
    		 this.submit.enabled = true;
    		 this.back.enabled = true;
             uConfLabel.includeInLayout = true;
             uConfLabel.visible = true;
             uConfSubmit.includeInLayout = true;
             uConfSubmit.visible = true;
             sConfLabel.includeInLayout = false;
             sConfLabel.visible = false;
             sConfSubmit.includeInLayout = false;
             sConfSubmit.visible = false;
             
             sysConfMessage.includeInLayout=false;   
             sysConfMessage.visible=false;
             
             preResetEntry();
             
           	 vstack.selectedChild = qry;
           	 	
			 super.postEntrySystemConfirm();
    	}
    	
    	private function addMapping():void{
    		 var myModel:Object = { mappingEntry : {
                                    fundCode : this.fundPopUp.fundCode.text,
                                    securityCode : this.instPopUp.instrumentId.text,
                                    bsFlag : (this.buySellFlag.selectedItem != null ?  this.buySellFlag.selectedItem.value : ""),
                                    roundFlag : (this.roundUpDownFlag.selectedItem != null ?  this.roundUpDownFlag.selectedItem.value : "")//,
                                    }
                                };
                                
             var mappingValidate : FundMaintenanceValidator = new FundMaintenanceValidator();
	         mappingValidate.source = myModel;
	         mappingValidate.property = "mappingEntry";
	         var validationResult:ValidationResultEvent = mappingValidate.validate();
         
	         if(validationResult.type==ValidationResultEvent.INVALID){
	            var errorMsg:String=validationResult.message;
	            XenosAlert.error(errorMsg);                   
          	}                  
			else{
				var reqObj:Object=new Object();
				reqObj['entry.fundCode']=fundPopUp.fundCode.text;
				reqObj['entry.securityCode']=instPopUp.instrumentId.text;
				reqObj['entry.buySellFlag']=this.buySellFlag.selectedItem != null ?  this.buySellFlag.selectedItem.value : "" ;
				reqObj['entry.roundUpDownFlag']=this.roundUpDownFlag.selectedItem != null ?  this.roundUpDownFlag.selectedItem.value : "" ;
				
				addMappingService.request=reqObj;
				addMappingService.send();
			} 
		}
		
		
		public function deleteMapping(data:Object):void{
			 var reqObj:Object=new Object();
			reqObj['editIndex']=mappingList.getItemIndex(data);	
			deleteMappingService.request=reqObj;
			deleteMappingService.send()
		}
		
		private function addMappingServiceResult(event:ResultEvent):void{
			var rs:XML = XML(event.result);
			if (null != event) {
				 if(rs.child("Errors").length()>0) {
		           	var errorInfoList : ArrayCollection = new ArrayCollection();
		            //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
		 			   trace(error.toString()); 			   
					}
				 	errPage.showError(errorInfoList);//Display the error
				 }
				 else{
				 			
					errPage.clearError(event);			
		            mappingList.removeAll(); 
					try {				
					    for each ( var rec:XML in rs.entryPageList.entryPage) {
		 				    mappingList.addItem(rec); 		
					    }			    		   
		            	mappingList.refresh();
		            	fundPopUp.fundCode.text="";
		            	instPopUp.instrumentId.text="";
		            	roundUpDownFlag.selectedIndex = -1;
		            	buySellFlag.selectedIndex = -1;
		            	/* mappingCancelSave.includeInLayout=false;
		            	mappingCancelSave.visible=false; */
					}catch(e:Error){			    
					    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				    }
				 } 
		     }
		     app.submitButtonInstance = submit;
		}
           	