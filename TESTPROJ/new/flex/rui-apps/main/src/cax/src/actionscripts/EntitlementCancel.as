 /*Action script for the Rights Detail Cancel UI*/


    import com.nri.rui.cax.CaxConstants;
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.controls.XenosEntry;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.ProcessResultUtil;
    
    import flash.events.MouseEvent;
    
    import mx.collections.ArrayCollection;
    import mx.events.CloseEvent;

    [Bindable]
    private var queryResult:XML= new XML();
    [Bindable]
    private var usrConfMsg:String = "";
     [Bindable]
    private var usrConfRefNo:String = "";
    private var rndNo:Number = 0;
	[Bindable]
    private var summaryResult:Object= new Object();
    [Bindable]
    private var pkArrayColl:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var pkArray:Array = new Array();
    [Bindable]
 	private var rs:XML = new XML();
 	
 	private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    private var  csd:CustomizeSortOrder=null;
    
    [Bindable]private var mode : String = "";
     private var keylist:ArrayCollection = new ArrayCollection();
    [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     [Bindable]private var availableDateGrid_visible:Boolean=true;
	/**
	 * Called on creation complete of the Cancel UI.
	 * Parses the URL and checks the "mode" of operation.
	 */    
     public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosEntryControl(new XenosEntry());
           	   //XenosAlert.info("mode : "+mode);
           	   if(this.mode == 'entry'){
           	   	/*No operation */
           	   } else if(this.mode == 'amend'){
           	   	 /*No operation */
           	   } else { 
           	     this.dispatchEvent(new Event('cancelEntryInit'));
           	   }
           	     
           }
           
    /**
     * Extracts the parameters and set them to some variables for query 
     * criteria from the Module Loader Info.
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
                    if (tempA[0] == Globals.CAX_MODE_OPERATION) {//getting the mode i.e. query/cancel etc
                        mode = tempA[1];
                    }else if(tempA[0] == CaxConstants.RIGHTS_DETAIL_PK){
                        this.rdPk = tempA[1];
                    } 
                }                    	
            }else{
            	mode = Globals.MODE_ENTRY;
            }                 

        } catch (e:Error) {
            trace(e);
        }               
    }
    
    /**
    * Overridden method - responsible for initialization process before the 
    * details page for cancel is displayed.
    */ 
	 override public function preCancelInit():void{        
	        var rndNo:Number= Math.random(); 
	    	super.getInitHttpService().url = "cax/RightsCancelDetailViewDispatch.action?";
	    	var reqObject:Object = new Object();
	    	reqObject.rnd = rndNo;
	    	reqObject.SCREEN_KEY = 449; // SCREEN_KEY for "CAX Rights Detail Cancel View"
	    	reqObject.method= "detailsViewForCancel";
	  		reqObject.mode=this.mode;
	  		reqObject.rightsDetailPk = this.rdPk;
	  		super.getInitHttpService().request = reqObject;
	    }
	    
	/**
	 * Overridden method - result handler of the preCancelInit() request.
	 */    
	 override public function preCancelResultInit():Object{
     	  	addCommonResultKes();         	
        	return keylist;
      }
      
     /**
      *  Overridden method - responsible for adding the fields to the 'keyList'.
      *  The fields added to the key list will be displayed in the Cancel Details UI.
      */ 
     private function addCommonResultKes():void{
        	keylist = new ArrayCollection();
	    	keylist.addItem("rdReferenceNo");
	    	keylist.addItem("rcReferenceNo");
	    	keylist.addItem("detailTypeDescription");
	    	keylist.addItem("subEventTypeDescription");
	    	keylist.addItem("conditionStatus");
	    	keylist.addItem("instrumentCode");
	    	keylist.addItem("instrumentName");
	    	keylist.addItem("allottedInstrument");
	    	keylist.addItem("allottedInstrumentName");
	    	keylist.addItem("recordDate");
	    	keylist.addItem("paymentDate");
	    	keylist.addItem("accountNo");
	    	keylist.addItem("accountName");
	    	keylist.addItem("allottedQuantityStr");
	    	keylist.addItem("allottedAmountStr");
	    	keylist.addItem("fractionalShareStr");
	    	keylist.addItem("cashInLieuFlagExp");
	    	keylist.addItem("securityBalanceStr");
	    	keylist.addItem("netAmountStr");
	    	keylist.addItem("status");
	    	keylist.addItem("isForTempBalance");
	    	keylist.addItem("remarks");
	    	keylist.addItem("Errors.error"); // since error for INIT is handled in the frame work (as on 20090420)
	    	keylist.addItem("availableDate");
	    	keylist.addItem("isIncome");
	    	keylist.addItem('finalizedFlagDropdownList.item');
	    	keylist.addItem('finalizedFlag');
	    	keylist.addItem('finalizedFlagDisp');
	    	keylist.addItem('inConsistencyFlagDisp');
        }
        
     /**
     * Overridden method - responsible for displaying the fields (added to the "keyList") 
     * in the Cancel details UI.
     */ 
     override public function postCancelResultInit(mapObj:Object): void{
        	var errorFlag:Boolean = checkError(mapObj); // true when error;else false
        	if(mapObj['isIncome'].toString()=='true'){
        		availableDateGrid_visible=false;        		
        	}
            commonResultPart(mapObj);
        	uConfSubmit.includeInLayout = false;
        	uConfSubmit.visible = false;
        	cancelSubmit.enabled = !errorFlag;
        	cancelSubmit.visible = true;
        	cancelSubmit.includeInLayout = true;
        	if(errorFlag){// refresh the page when error occurs and user clicks back button
        		back.includeInLayout = false;
        		back.visible= false;
        		backFromUserConf.addEventListener(MouseEvent.CLICK, doRefreshSummaryPage);
				backFromUserConf.includeInLayout = true;
				backFromUserConf.visible = true;
        	}
        	app.submitButtonInstance = cancelSubmit;
        }
     
     /**
     * Checks the errors and displays the same in the UI.
     */    
     private function checkError(mapObj:Object):Boolean{
	    	if(mapObj!=null){    		
		    	if(mapObj["Errors.error"]!=null){
		    		if(mapObj["Errors.error"].toString().length > 0){
		    		  errPage.showError(mapObj["Errors.error"]);
		    		  return true;
		    		}		    			
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    	 	errPage.clearError(super.getSaveResultEvent());			    			
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cax.data.not.found'));
		    	}    		
	    	}
	    	return false;
        }
     
     /**
      *	 Adds the values to the fields of the UI from the values of the resultant XML.
      */
     private function commonResultPart(mapObj:Object):void{
    		 this.rdReferenceNo.text = mapObj[keylist.getItemAt(0)].toString();
             this.rcReferenceNo.text = mapObj[keylist.getItemAt(1)].toString();
             // this.detailTypeDescription.text = mapObj[keylist.getItemAt(2)].toString();
             this.subEventTypeDescription.text = mapObj[keylist.getItemAt(3)].toString();
             this.conditionStatus.text = mapObj[keylist.getItemAt(4)].toString();
             this.instrumentCode.text = mapObj[keylist.getItemAt(5)].toString();
             this.instrumentName.text = mapObj[keylist.getItemAt(6)].toString();
             this.allottedInstrument.text = mapObj[keylist.getItemAt(7)].toString();
             this.allottedInstrumentName.text = mapObj[keylist.getItemAt(8)].toString();
             
             this.recordDate.text = mapObj[keylist.getItemAt(9)].toString();
             this.paymentDate.text = mapObj[keylist.getItemAt(10)].toString();
             this.accountNo.text = mapObj[keylist.getItemAt(11)].toString();
             this.accountName.text = mapObj[keylist.getItemAt(12)].toString();
             this.allottedQuantityStr.text = mapObj[keylist.getItemAt(13)].toString();
             this.allottedAmountStr.text = mapObj[keylist.getItemAt(14)].toString();
             this.fractionalShareStr.text = mapObj[keylist.getItemAt(15)].toString();
             this.cashInLieuFlagExp.text = mapObj[keylist.getItemAt(16)].toString();
             this.securityBalanceStr.text = mapObj[keylist.getItemAt(17)].toString();
             this.netAmountStr.text = mapObj[keylist.getItemAt(18)].toString();
             this.status.text = mapObj[keylist.getItemAt(19)].toString();
             this.isForTempBalance.text = mapObj[keylist.getItemAt(20)].toString();
             this.remarks.text = mapObj[keylist.getItemAt(21)].toString();
             this.availableDateConf.text=mapObj['availableDate'].toString();
             this.finalizedFlag.dataProvider=mapObj['finalizedFlagDropdownList.item'];
             
             var index:int=0;
             finalizedFlag.selectedIndex=index;
             for each(var item:Object in mapObj['finalizedFlagDropdownList.item']){
             	if(item.value.toString()==mapObj['finalizedFlag'].toString()){
             		finalizedFlag.selectedIndex=index;
             		break;
             	}
             	index++;
             }
             this.inconsistencyflagConf.text=mapObj['inConsistencyFlagDisp'].toString();
             
        }
     
     /**
      * 
      */ 
     private function doBack():void{
				this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
  		}
  	
  	 /**
     * Overridden method - responsible for sending the server request for user confirmation from 
     * the Cancel Details UI.
     */ 
     override public function preCancel():void{
		 	//setValidator();
		 	cancelSubmit.enabled = false; // disable the submit button;avoiding multiple submission
		 	super._validator = null;
		 	super.getSaveHttpService().url = "cax/rightsDetailCancelDispatch.action?"; 
		 	var reqObj:Object = new Object();
		 	reqObj.SCREEN_KEY = 450;
		 	reqObj.method="SubmitRightsDetailCancel";
		 	reqObj.finalizedFlag=(this.finalizedFlag.selectedItem!=null)?this.finalizedFlag.selectedItem.value:"";
		 	reqObj.mode=this.mode;
            super.getSaveHttpService().request  =reqObj;
		 }
		
	  override public function preCancelResultHandler():Object{
     	  	addCommonResultKes();         	
        	return keylist;
      }
	
     /**
	  * Overridden method - result handler for the  preCancel() request.
	  * Displays the User Confirmation UI.
	  */  
	 override public function postCancelResultHandler(mapObj:Object):void{
	 		softWarn.removeWarning();
			var errorFlag:Boolean = submitUserConfResult(mapObj);// true when error;else false
			if(errorFlag){
				backFromUserConf.addEventListener(MouseEvent.CLICK, doRefreshSummaryPage);
			}
			else{
				this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.cancel')+ ' - ' + this.parentApplication.xResourceManager.getKeyValue('cax.user.confirmation1');
				backFromUserConf.addEventListener(MouseEvent.CLICK, backToCancelDetails);
				//finalizedFlagConf.includeInLayout=true;
				finalizedFlagConf.text=mapObj['finalizedFlagDisp'].toString();				
				if(mapObj['finalizedFlag'].toString()==Globals.DATABASE_YES){					
					var softWarningList:ArrayCollection=new ArrayCollection();
					softWarningList.addItem("The Entitlement to be cancelled has Finalized Flag as Y.");					
					softWarn.showWarning(softWarningList);					
				}
			}
			
			backFromUserConf.includeInLayout = true;
			backFromUserConf.visible = true;
			uDetailsLabel.includeInLayout = errorFlag;
			uDetailsLabel.visible = errorFlag;
			uConfLabel.includeInLayout = !errorFlag;// user conf msg: diplayed when no error
			uConfLabel.visible = !errorFlag;
			cancelSubmit.enabled = !errorFlag;
        	cancelSubmit.visible = errorFlag;
        	cancelSubmit.includeInLayout = errorFlag;
        	uCancelConfSubmit.enabled = !errorFlag;
        	uCancelConfSubmit.visible = !errorFlag;
        	uCancelConfSubmit.includeInLayout = !errorFlag;
        	finalizedFlag.includeInLayout=errorFlag;
        	finalizedFlagConf.includeInLayout=!errorFlag;
        	
        	sConfSubmit.includeInLayout = false;
        	sConfSubmit.visible = false;
        	sConfLabel.includeInLayout = false;
        	sConfLabel.visible = false;
        	back.visible = false;
        	back.includeInLayout = false;
	        app.submitButtonInstance = uCancelConfSubmit; 
	        trace("44444");
		}
	
	 /**
	  * Checks for errors while the User Confirmation UI gets displayed and displays
	  * the error in the UI.
	  */ 
	 private function submitUserConfResult(mapObj:Object):Boolean{
    	if(mapObj!=null){
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		errPage.showError(mapObj["errorMsg"]);
	    		//XenosAlert.error(mapObj["errorMsg"].toString());
	    		return true;
	    	} else if(mapObj["errorFlag"].toString() == "noError"){
		    	//NOP for cancel
	    	} else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
	    	}    		
    	}
    	return false;
    }
    
     /**
      * Takes the control back to the Cancel Details UI when user clicks the
      * back button of the User Confirmation UI.
      */
     public function backToCancelDetails(event:MouseEvent):void {
       		 this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.cancel');                
             uConfLabel.includeInLayout = false;
			 uConfLabel.visible 		= false;
			 uDetailsLabel.includeInLayout = true;
			 uDetailsLabel.visible = true;
			 uCancelConfSubmit.visible = false;
	         uCancelConfSubmit.includeInLayout = false;
	         cancelSubmit.enabled = true;
			 cancelSubmit.visible = true;
	         cancelSubmit.includeInLayout = true;
			 backFromUserConf.includeInLayout = false;
			 backFromUserConf.visible = false;
			 back.visible = true;
	         back.includeInLayout = true;
	        finalizedFlag.includeInLayout=true;
        	finalizedFlagConf.includeInLayout=false;
        	softWarn.removeWarning();
       }
     
     /**
     * Overridden method - responsible for sending the final confirmation from the User Confirmation UI. 
     */
     override public function preCancelConfirm():void
		{
			uCancelConfSubmit.enabled = false; // disabling the cofrim button;avoid multiple submission
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "cax/rightsDetailCancelDispatch.action?"; 
			reqObj.method= "ConfirmRightsDetailCancel";
			reqObj.SCREEN_KEY = 451; //SCREEN_KEY for "CAX Rights Detail Cancel Ok"
            super.getConfHttpService().request  =reqObj;
		}
	 /**
	  * Overridden method - displays the System Confirmation UI on successful cancellation of
	  * the record.
	  */ 
      override public function postConfirmCancelResultHandler(mapObj:Object):void
		{
			var errorFlag:Boolean = submitUserConfResult(mapObj);
			if(!errorFlag){
				this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.cancel') + ' - ' + this.parentApplication.xResourceManager.getKeyValue('cax.system.confirmation1');
				backFromUserConf.label = "Ok";
				softWarn.removeWarning();
			}
			backFromUserConf.addEventListener(MouseEvent.CLICK, doRefreshSummaryPage);
			sConfLabel.includeInLayout = !errorFlag;
        	sConfLabel.visible = !errorFlag;
        	cancelSubmit.visible = false;
        	cancelSubmit.includeInLayout = false;
        	uCancelConfSubmit.enabled = !errorFlag;
        	uCancelConfSubmit.visible = errorFlag;
        	uCancelConfSubmit.includeInLayout = errorFlag;
        	uConfLabel.includeInLayout = errorFlag;
			uConfLabel.visible =errorFlag;
			
		}
		
	 /**
      * On Clicking the Ok button the System Confirmation UI, the Refreshed Summary Result 
      * page will be displayed  
      */
     public function doRefreshSummaryPage(event:MouseEvent):void{	
    		this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
    		this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    	}
  