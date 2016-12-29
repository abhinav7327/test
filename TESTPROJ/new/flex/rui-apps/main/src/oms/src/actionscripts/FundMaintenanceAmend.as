// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.oms.OmsConstants;
import com.nri.rui.oms.validator.FundMaintenanceValidator;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;

[Bindable]private var mode : String = Globals.MODE_AMEND;
private var keylist:ArrayCollection = new ArrayCollection(); 
private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
[Bindable] private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

	/**
	 * Called on creation complete of the Amend UI.
	 * Parses the URL and checks the "mode" of operation.
	 */    
     public function loadAll():void{
       	   parseUrlString();
       	   super.setXenosEntryControl(new XenosEntry());
       	   this.dispatchEvent(new Event('amendEntryInit'));       	   
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
                    if (tempA[0] == Globals.MODE) {//getting the mode i.e. query/amend etc
                        this.mode = tempA[1];
                    }else if(tempA[0] == OmsConstants.FUND_INSTR_PARTICIPANT_PK){
                        this.fundInstrPk = tempA[1];
                    }
                }
            }else{
            	mode = Globals.MODE_AMEND;
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
    * details page for amend is displayed.
    */ 
	 override public function preAmendInit():void{        
	        var rndNo:Number= Math.random(); 
	    	super.getInitHttpService().url = "oms/fundMaintenanceAmendQuery.action?";
	    	var reqObject:Object = new Object();
	    	reqObject.rnd = rndNo;
	    	reqObject.method= "detailsViewForAmend";
	  		reqObject.mode=this.mode;
	  		reqObject.fundInstrParticipantPk = this.fundInstrPk;
	  		super.getInitHttpService().request = reqObject;
	    }
	    
	  override public function preAmendResultInit():Object{
        	addCommonKeys();   		    	
	    	return keylist;        	
      }
      
      override public function postAmendResultInit(mapObj:Object):void{
        	var errorFlag:Boolean = checkError(mapObj); // true when error;else false
            commonResultPart(mapObj);
        	uConfSubmit.includeInLayout = false;
        	uConfSubmit.visible = false;
        	amendSubmit.enabled = !errorFlag;
        	amendSubmit.visible = true;
       		amendSubmit.includeInLayout = true;
        	 if(errorFlag){// refresh the page when error occurs and user clicks back button
        		back.includeInLayout = false;
        		back.visible= false;
        		backFromUserConf.addEventListener(MouseEvent.CLICK, doRefreshSummaryPage);
				backFromUserConf.includeInLayout = true;
				backFromUserConf.visible = true;
        	} 
        	app.submitButtonInstance = amendSubmit;
        }
        
       private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("entry.fundCode");
	    	keylist.addItem("entry.securityCode");
	    	keylist.addItem("entry.buySellFlagDisp");
	    	keylist.addItem("entry.roundUpDownFlagDisp");
	    	keylist.addItem("Errors.error");
	    	keylist.addItem("buySellFlag.item");
	    	keylist.addItem("upDownFlag.item");
        }
      
      
       /**
       *	 Adds the values to the fields of the UI from the values of the resultant XML.
       */
      private function commonResultPart(mapObj:Object):void{
    		this.fundPopUp.fundCode.text = mapObj[keylist.getItemAt(0)].toString();
    		this.fundCode.text = mapObj[keylist.getItemAt(0)].toString();
    		
            this.instPopUp.instrumentId.text = mapObj[keylist.getItemAt(1)].toString();
            this.securityId.text = mapObj[keylist.getItemAt(1)].toString();
            
            //Set Buy/Sell flag
            var initcol:ArrayCollection = new ArrayCollection();
    		initcol.addItem({label:" ", value: " "});
    		var count:int = 0;
	    	for each(var flagItem:Object in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
	    		initcol.addItem(flagItem);
	    	}		    	
		    buySellFlag.dataProvider = initcol ;
		    
		    var selectedLabel :String = mapObj[keylist.getItemAt(2)].toString();
		    //XenosAlert.info("BuySellDisp :: " + selectedLabel);
		    if ( !XenosStringUtils.isBlank(selectedLabel) ){
			    var selectedIndex:int = 0; 
			    for (count = 0; count < initcol.length; count++) {
		            var bean:Object = initcol.getItemAt(count);
		            if (bean['label'] == selectedLabel) {
		                  selectedIndex = count;
		                  break;
		            }
		      	}
			    this.buySellFlag.selectedIndex = selectedIndex ;
			    this.buySell.text = selectedLabel;
		    }
            
            //Set Round Up/Down flag
            initcol = new ArrayCollection();
    		initcol.addItem({label:" ", value: " "});
    		count = 0;
	    	for each(flagItem in (mapObj[keylist.getItemAt(6)] as ArrayCollection)){
	    		initcol.addItem(flagItem);
	    	}		    	
		    roundUpDownFlag.dataProvider = initcol ;

    
		    selectedLabel = mapObj[keylist.getItemAt(3)].toString() ;
		    if ( !XenosStringUtils.isBlank(selectedLabel) ){
			    selectedIndex = 0; 
			    for (count = 0; count < initcol.length; count++) {
		            bean = initcol.getItemAt(count);
		            if (bean['label'] == selectedLabel) {
		                  selectedIndex = count;
		                  break;
		            }
		      	}
			    this.roundUpDownFlag.selectedIndex = selectedIndex ;
			    this.roundUpDown.text = selectedLabel;
		    }
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
      	// Setting The Validatior 
      	private function setValidator():void{
    		var myModel:Object = { mappingEntry : {
                                fundCode : this.fundPopUp.fundCode.text,
                                securityCode : this.instPopUp.instrumentId.text,
                                bsFlag : (this.buySellFlag.selectedItem != null ?  this.buySellFlag.selectedItem.value : ""),
                                roundFlag : (this.roundUpDownFlag.selectedItem != null ?  this.roundUpDownFlag.selectedItem.value : "")//,
                                }
                            };
	    	super._validator = new FundMaintenanceValidator();
	        super._validator.source = myModel ;
	        super._validator.property = "mappingEntry";
		}
		 /**
	    * This method will populate the request parameters for the
	    * submitQuery call and bind the parameters with the HTTPService
	    * object.
	    */
	    private function populateRequestParams():Object {
	    	var reqObj:Object = new Object();
		 	reqObj.method="submitFundMappingDetailAmend";
		 	reqObj.mode=this.mode;
		 	//DATA FIELD
			reqObj['entry.fundInstrParticipantPk']	= this.fundInstrPk;
			reqObj['entry.fundCode']				= fundPopUp.fundCode.text;
			reqObj['entry.securityCode']			= instPopUp.instrumentId.text;
			reqObj['entry.buySellFlag']			= this.buySellFlag.selectedItem != null ?  this.buySellFlag.selectedItem.value : "" ;
			reqObj['entry.roundUpDownFlag']			= this.roundUpDownFlag.selectedItem != null ?  this.roundUpDownFlag.selectedItem.value : "" ;
			return reqObj;
	    }
      
        /**
     	* Overridden method - responsible for sending the server request for user confirmation from 
     	* the Amend Details UI.
     	*/ 
     	override public function preAmend():void{
			setValidator();
			super.getSaveHttpService().url = "oms/fundMaintenanceAmendQuery.action?"; 
			super.getSaveHttpService().request = populateRequestParams();
	 	}
	 	override public function preAmendResultHandler() :Object
		{
			return keylist;
		}
	 
		/**
		* Overridden method - result handler for the  preAmend() request.
		* Displays the User Confirmation UI.
		*/  
	 	override public function postAmendResultHandler(mapObj:Object):void{
			var errorFlag:Boolean = submitUserConfResult(mapObj);// true when error;else false
			
			backFromUserConf.removeEventListener(MouseEvent.CLICK,doRefreshSummaryPage);
			backFromUserConf.removeEventListener(MouseEvent.CLICK,backToAmendDetails);
			if(errorFlag){
				backFromUserConf.addEventListener(MouseEvent.CLICK, doRefreshSummaryPage);
			}
			else{
				this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('oms.fund.amend.user.confirm');
				backFromUserConf.addEventListener(MouseEvent.CLICK, backToAmendDetails);				
				commonResultPart(mapObj);
				markEditable(false);
				backFromUserConf.includeInLayout = true;
				backFromUserConf.visible = true;
				uDetailsLabel.includeInLayout = errorFlag;
				uDetailsLabel.visible = errorFlag;
				uConfLabel.includeInLayout = !errorFlag;// user conf msg: diplayed when no error
				uConfLabel.visible = !errorFlag;
				amendSubmit.enabled = !errorFlag;
	        	amendSubmit.visible = errorFlag;
	        	amendSubmit.includeInLayout = errorFlag;
	        	uAmendConfSubmit.enabled = !errorFlag;
	        	uAmendConfSubmit.visible = !errorFlag;
	        	uAmendConfSubmit.includeInLayout = !errorFlag;
	        	sConfSubmit.includeInLayout = false;
	        	sConfSubmit.visible = false;
	        	sConfLabel.includeInLayout = false;
	        	sConfLabel.visible = false;
	        	back.visible = false;
	        	back.includeInLayout = false;
		        app.submitButtonInstance = uAmendConfSubmit; 
			}
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
	 	errPage.removeError();
    	if(mapObj!=null){
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		errPage.showError(mapObj["errorMsg"]);
	    		return true;
	    	} else if(mapObj["errorFlag"].toString() == "noError"){
		    	//NOP for amend
	    	} else{	    		
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.msg.common.info.erroroccurred'));
	    	}    		
    	}
    	return false;
    }
    /**
      * Takes the control back to the Amend Details UI when user clicks the
      * back button of the User Confirmation UI.
      */
     public function backToAmendDetails(event:MouseEvent):void {
       		 this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('oms.fund.amend.header');
             uConfLabel.includeInLayout = false;
			 uConfLabel.visible 		= false;
			 uDetailsLabel.includeInLayout = true;
			 uDetailsLabel.visible = true;
			 uAmendConfSubmit.visible = false;
	         uAmendConfSubmit.includeInLayout = false;
	         amendSubmit.enabled = true;
			 amendSubmit.visible = true;
	         amendSubmit.includeInLayout = true;
			 backFromUserConf.includeInLayout = false;
			 backFromUserConf.visible = false;
			 back.visible = true;
	         back.includeInLayout = true;
	         markEditable(true);
       }
       private function markEditable(editable:Boolean): void {
       		
       		this.buySell.includeInLayout = !editable;
       		this.buySell.visible		 = !editable;
       		this.buySellFlag.includeInLayout = editable;
       		this.buySellFlag.visible = editable;
       	
       		this.roundUpDown.includeInLayout = !editable;
       		this.roundUpDown.visible		 = !editable;
       		this.roundUpDownFlag.includeInLayout = editable;
       		this.roundUpDownFlag.visible = editable;
       		
       		this.instPopUp.includeInLayout = editable;
       		this.instPopUp.visible = editable;
       		this.securityId.includeInLayout = !editable;
       		this.securityId.visible = !editable;
       		
       		this.fundPopUp.includeInLayout = editable;
       		this.fundPopUp.visible = editable;
       		this.fundCode.includeInLayout = !editable;
       		this.fundCode.visible = !editable;
       		if(editable){
       			this.confFundCodeLabel.styleName = "ReqdLabel";	
       			this.confSecurityIdLabel.styleName = "ReqdLabel";
       			this.confRoundUpDownFlagLabel.styleName = "ReqdLabel";
       			this.confBuySellFlagLabel.styleName = "ReqdLabel";
       		}else{
       			this.confFundCodeLabel.styleName = "FormLabelHeading";	
       			this.confSecurityIdLabel.styleName = "FormLabelHeading";
       			this.confRoundUpDownFlagLabel.styleName = "FormLabelHeading";
       			this.confBuySellFlagLabel.styleName = "FormLabelHeading";
       		}
       		
       }
      /**
     * Overridden method - responsible for sending the final confirmation from the User Confirmation UI. 
     */
     override public function preAmendConfirm():void{
     	
			uAmendConfSubmit.enabled = false; // disabling the cofrim button;avoid multiple submission
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "oms/fundMaintenanceAmendQuery.action?"; 
			reqObj.method= "confirmFundMaintenanceAmend";
            super.getConfHttpService().request  =reqObj;
		}
	/**
	  * Overridden method - displays the System Confirmation UI on successful amendof
	  * the record.
	  */ 
      override public function postConfirmAmendResultHandler(mapObj:Object):void
		{
			var errorFlag:Boolean = submitUserConfResult(mapObj);
			if(!errorFlag){
				this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('oms.fund.amend.system.confirm');
				backFromUserConf.label = "Ok";
				backFromUserConf.addEventListener(MouseEvent.CLICK, doRefreshSummaryPage);
				amendSubmit.visible = errorFlag;
        		amendSubmit.includeInLayout = errorFlag;
        		sConfLabel.includeInLayout = !errorFlag;
	        	sConfLabel.visible = !errorFlag;
	        	
	        	uAmendConfSubmit.enabled = !errorFlag;
	        	uAmendConfSubmit.visible = errorFlag;
	        	uAmendConfSubmit.includeInLayout = errorFlag;
	        	uConfLabel.includeInLayout = errorFlag;
				uConfLabel.visible = errorFlag;
			}else{
				backFromUserConf.addEventListener(MouseEvent.CLICK, doRefreshSummaryPage);	
			}
		}	 
