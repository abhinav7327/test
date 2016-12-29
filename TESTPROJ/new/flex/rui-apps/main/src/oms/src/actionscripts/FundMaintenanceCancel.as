// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.oms.OmsConstants;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;

[Bindable]private var mode : String = "cancel";
private var keylist:ArrayCollection = new ArrayCollection(); 
private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
[Bindable] private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

	/**
	 * Called on creation complete of the Cancel UI.
	 * Parses the URL and checks the "mode" of operation.
	 */    
     public function loadAll():void{
       	   parseUrlString();
       	   super.setXenosEntryControl(new XenosEntry());
       	   if(this.mode == 'cancel'){
       	   	  this.dispatchEvent(new Event('cancelEntryInit'));
       	   }
     }
     
     /**
     * Extracts the parameters and set them to some variables for query 
     * criteria from the Module Loader Info.
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
          
            if(params != null){
                for (var i:int = 0; i < params.length; i++) {
                    var tempA:Array = params[i].split("=");  
                    if (tempA[0] == Globals.MODE) {//getting the mode i.e. query/cancel etc
                        mode = tempA[1];
                    }else if(tempA[0] == OmsConstants.FUND_INSTR_PARTICIPANT_PK){
                        this.fundInstrPk = tempA[1];
                    } 
                }                    	
            }else{
            	mode = Globals.MODE_CANCEL;
            }                 

        } catch (e:Error) {
            trace(e);
        }               
    }
     /**
      * 
      */ 
     private function doBack():void{
			this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
  	}
    
    /**
    * Overridden method - responsible for initialization process before the 
    * details page for cancel is displayed.
    */ 
	 override public function preCancelInit():void{        
	        var rndNo:Number= Math.random(); 
	    	super.getInitHttpService().url = "oms/fundMaintenanceQueryForCancel.action?";
	    	var reqObject:Object = new Object();
	    	reqObject.rnd = rndNo;
	    	reqObject.method= "detailsViewForCancel";
	  		reqObject.mode=this.mode;
	  		reqObject.fundInstrParticipantPk = this.fundInstrPk;
	  		super.getInitHttpService().request = reqObject;
	    }
	    
	  override public function preCancelResultInit():Object{
        	addCommonKeys();   		    	
	    	return keylist;        	
      }
      
      override public function postCancelResultInit(mapObj:Object):void{
        	var errorFlag:Boolean = checkError(mapObj); // true when error;else false
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
        
       private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("entry.fundCode");
	    	keylist.addItem("entry.securityCode");
	    	keylist.addItem("entry.buySellFlagDisp");
	    	keylist.addItem("entry.roundUpDownFlagDisp");
	    	keylist.addItem("Errors.error");
        }
      
      
       /**
       *	 Adds the values to the fields of the UI from the values of the resultant XML.
       */
      private function commonResultPart(mapObj:Object):void{
    		 this.fundCode.text = mapObj[keylist.getItemAt(0)].toString();
             this.securityId.text = mapObj[keylist.getItemAt(1)].toString();
             this.buySellFlag.text = mapObj[keylist.getItemAt(2)].toString();
             this.roundUpDown.text = mapObj[keylist.getItemAt(3)].toString();
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
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.datanotfound'));
		    	}    		
	    	}
	    	return false;
      }
      /**
     	* Overridden method - responsible for sending the server request for user confirmation from 
     	* the Cancel Details UI.
     	*/ 
     override public function preCancel():void{
		 	cancelSubmit.enabled = false; // disable the submit button;avoiding multiple submission
		 	super._validator = null;
		 	super.getSaveHttpService().url = "oms/fundMaintenanceQueryForCancel.action?"; 
		 	var reqObj:Object = new Object();
		 	reqObj.method="submitFundMappingDetailCancel";
		 	reqObj.mode=this.mode;
            super.getSaveHttpService().request  =reqObj;
	 }
	  /**
	  * Overridden method - result handler for the  preCancel() request.
	  * Displays the User Confirmation UI.
	  */  
	 override public function postCancelResultHandler(mapObj:Object):void{
			var errorFlag:Boolean = submitUserConfResult(mapObj);// true when error;else false
			if(errorFlag){
				backFromUserConf.addEventListener(MouseEvent.CLICK, doRefreshSummaryPage);
			}
			else{
				this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('oms.fund.cancel.user.confirm');
				backFromUserConf.addEventListener(MouseEvent.CLICK, backToCancelDetails);
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
        	sConfSubmit.includeInLayout = false;
        	sConfSubmit.visible = false;
        	sConfLabel.includeInLayout = false;
        	sConfLabel.visible = false;
        	back.visible = false;
        	back.includeInLayout = false;
	        app.submitButtonInstance = uCancelConfSubmit; 
	}
	/**
      * On Clicking the Ok button the System Confirmation UI, the Refreshed Summary Result 
      * page will be displayed  
      */
     public function doRefreshSummaryPage(event:MouseEvent):void{
    		this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
     }
     /**
	  * Checks for errors while the User Confirmation UI gets displayed and displays
	  * the error in the UI.
	  */ 
	 private function submitUserConfResult(mapObj:Object):Boolean{
    	if(mapObj!=null){
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		errPage.showError(mapObj["errorMsg"]);
	    		return true;
	    	} else if(mapObj["errorFlag"].toString() == "noError"){
		    	//NOP for cancel
	    	} else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.msg.common.info.erroroccurred'));
	    	}    		
    	}
    	return false;
    }
    /**
      * Takes the control back to the Cancel Details UI when user clicks the
      * back button of the User Confirmation UI.
      */
     public function backToCancelDetails(event:MouseEvent):void {
       		 this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('oms.fund.cancel.header');         
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
       }
       
      /**
     * Overridden method - responsible for sending the final confirmation from the User Confirmation UI. 
     */
     override public function preCancelConfirm():void{
     	
			uCancelConfSubmit.enabled = false; // disabling the cofrim button;avoid multiple submission
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "oms/fundMaintenanceQueryForCancel.action?"; 
			reqObj.method= "confirmFundMaintenanceCancel";
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
				this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('oms.fund.cancel.system.confirm');
				backFromUserConf.label = "Ok";
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
