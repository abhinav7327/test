


// ActionScript file

 
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.fam.FamConstants;

import mx.events.CloseEvent;
import mx.rpc.events.ResultEvent;
import com.nri.rui.core.formatters.CustomDateFormatter;
import mx.utils.StringUtil;
import com.nri.rui.core.utils.DateUtils;
 	
[Bindable] public var amendResult: Object;
[Bindable] public var mode:String = Globals.MODE_QUERY;
[Bindable] public var commandForm: Object = new Object();
[Bindable] private var commandFormId : String = XenosStringUtils.EMPTY_STR;
private var commandFormIdForTransaction : String = XenosStringUtils.EMPTY_STR;
[Bindable] private var transactionPk : String = Globals.EMPTY_STRING;
[Bindable] private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

[Bindable] private var commandFormIdForAmend : String = XenosStringUtils.EMPTY_STR;
[Bindable] private var transactionTypeStr : String = XenosStringUtils.EMPTY_STR;
[Bindable] private var statusStr : String = XenosStringUtils.EMPTY_STR;
[Bindable] private var bookDateStrng : String = XenosStringUtils.EMPTY_STR;
[Bindable] private var originalBookDateStrng : String = XenosStringUtils.EMPTY_STR;
[Bindable] private var nextPaymentDateStrng : String = XenosStringUtils.EMPTY_STR;
[Bindable] private var valueDateStrng : String = XenosStringUtils.EMPTY_STR;
     
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
		params["SCREEN_KEY"] = 13006;
		params.rnd = Math.random()+"";
		transactionAmendService.send(params);
		dummyService.send();		
	}
	 
	private function dummyServiceResultHandler(event : ResultEvent) : void {
        commandFormIdForTransaction = event.result.transactionQueryCommandForm.commandFormId;
    }
	 /**
	  * Result Handler for transactionAmendServiceHandler HTTPService
	  */          	
	 private function transactionAmendServiceHandler(event:ResultEvent):void {
	 	errPage.clearError(event);
	 	 var rs:XML = XML(XenosHTTPServiceForSpring.getXmlResult(event));
  	      var result:XML = XML(event.result);
	      if (result != null) {
	      	  commandForm=result.transactionPage;
			  if (commandForm != null) {
				  amendResult=commandForm;
			  }
		  }
		   var cmdChildObjForTransaction:XML = <commandFormIdTrans>{commandFormIdForTransaction}</commandFormIdTrans>
        
         if(rs.child("row").length()>0) {
            try {
                for each ( var rec:XML in rs.row ) {
                	rec.appendChild(cmdChildObjForTransaction);     
                }                
         
            }catch(e:Error){
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }
         }
          transactionTypeStr = amendResult.transactionType;
		  statusStr = amendResult.statusStr;
		  valueDateStrng = amendResult.valueDateStr;
        
		  if(amendResult.transactionType == "SECURITY_TRADE") {
		  	this.originalBookDateStr.visible = false;
		  	this.originalBookDateStr.includeInLayout = false;
		  	this.bookDateStr.visible = false;
		  	this.bookDateStr.includeInLayout = false;
		  	this.nextPayDateLbl.visible = false;
		  	this.nextPayDateLbl.includeInLayout = false;
		  	this.nextPaymentDate.styleName = "ReqdLabel";
		  	this.bookDate.styleName = "FormLabelHeading";
		  	this.originalBookDate.styleName = "FormLabelHeading";
		  } else if (amendResult.transactionType == "CAM_CASH_DIVIDEND" && 
		  					amendResult.statusStr =="NORMAL") {
		  	this.nextPayDateStr.visible = false;
		  	this.nextPayDateStr.includeInLayout = false;
		  	this.originalBookDateStr.visible = false;
		  	this.originalBookDateStr.includeInLayout = false;
		  	this.bookDateLbl.visible = false;
		  	this.bookDateLbl.includeInLayout = false;
		  	this.bookDate.styleName = "ReqdLabel";
		  	this.nextPaymentDate.styleName = "FormLabelHeading";
		  	this.originalBookDate.styleName = "FormLabelHeading";
		  } else if (amendResult.transactionType == "CAM_CASH_DIVIDEND" && 
		  					amendResult.statusStr =="CANCEL") {
		  	this.nextPayDateStr.visible = false;
		  	this.nextPayDateStr.includeInLayout = false;
		  	this.originalBookDateLbl.visible = false;
		  	this.originalBookDateLbl.includeInLayout = false;
		  	this.bookDateLbl.visible = false;
		  	this.bookDateLbl.includeInLayout = false;
		  	this.bookDate.styleName = "ReqdLabel";
		  	this.originalBookDate.styleName = "ReqdLabel";
		  	this.nextPaymentDate.styleName = "FormLabelHeading";
		  	}
		  	
		  	this.refno.styleName="TextLink"; 
            this.refno.useHandCursor=true;
            this.refno.buttonMode=true;
            this.refno.mouseChildren=false;
            this.refno.selectable=true;
            this.refno.addEventListener(MouseEvent.CLICK, showSourceComponentDetails); 
		  	
		  	backButton.enabled = false;
			backButton.includeInLayout= false;
			sconfMsg.visible = false;
		  	sconfMsg.includeInLayout = false;
			amendReset.enabled = true;
			cancelSubmit.enabled = true;
		  	app.submitButtonInstance=cancelSubmit;
		  
	 }
	 
			
	 /**
	   * This method is used for loading Instrument Details popup
	   * 
	   */  
	   private function showInstrumentDetails(insPk:String):void{
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showInstrumentDetails(insPk, parentApp);
		}
					
	// Displays Account Details window
	   private function showAccountDetails(accPk:String):void{
	   	    var parentApp :UIComponent = UIComponent(this.parentApplication);
	   	    XenosPopupUtils.showAccountSummary(accPk,parentApp, this.parentApplication.xResourceManager.getKeyValue('fam.transactionquery.label.result')); 
	   }
	   
	/**
	   * This method is used for showing instrument detail from underlying instrument
	   * 
	   */  
	   	private function handleUnderlyingInstrument(event: MouseEvent):void {
		   	var instrumentPk:String = this.txnInfoLc.underlyingInstrumentPk; 
	   		showInstrumentDetails(instrumentPk);
		}
		
	    private function doSubmit():void {
			cancelSubmit.enabled = false;
			amendReset.enabled = false;
			var params : Object = new Object();
			var dateformat:CustomDateFormatter=new CustomDateFormatter();
			//format of the date
			dateformat.formatString="YYYYMMDD";
			if(XenosStringUtils.equals(transactionTypeStr,"CAM_CASH_DIVIDEND")) {
					if(XenosStringUtils.equals(statusStr,"NORMAL")) {
						if(XenosStringUtils.isBlank(bookDateStr.text)){
					     XenosAlert.error("Book Date can not be Empty");
					     cancelSubmit.enabled = true;
					     amendReset.enabled = true;
					     return;
					   } else if (!DateUtils.isValidDate(StringUtil.trim(bookDateStr.text))){ 
					   	   XenosAlert.error("Invalid Book Date");
			        	   cancelSubmit.enabled = true;
					       amendReset.enabled = true;
					       return;
					   }
					} else if(XenosStringUtils.equals(statusStr,"CANCEL")) {
								if (XenosStringUtils.isBlank(bookDateStr.text) && XenosStringUtils.isBlank(originalBookDateStr.text)){
									  XenosAlert.error("Original Book Date and Book Date Cannot be Empty");
							          cancelSubmit.enabled = true;
							          amendReset.enabled = true;
							          return;
								}else if(XenosStringUtils.isBlank(bookDateStr.text)){
							          XenosAlert.error("Book Date can not be Empty");
							          cancelSubmit.enabled = true;
							          amendReset.enabled = true;
							          return;
							   } else if (!DateUtils.isValidDate(StringUtil.trim(bookDateStr.text))){ 
							   	      XenosAlert.error("Invalid Book Date");
					        	      cancelSubmit.enabled = true;
							          amendReset.enabled = true;
							          return;
							   }else if(XenosStringUtils.isBlank(originalBookDateStr.text)){
							          XenosAlert.error("Original Book Date can not be Empty");
							          cancelSubmit.enabled = true;
							          amendReset.enabled = true;
							          return;
							   }else  if (!DateUtils.isValidDate(StringUtil.trim(originalBookDateStr.text))){ 
							   	      XenosAlert.error("Invalid Original Book Date");
					        	      cancelSubmit.enabled = true;
							          amendReset.enabled = true;
							          return;
							   }
					}
			} else if(XenosStringUtils.equals(transactionTypeStr,"SECURITY_TRADE")) {
						if(XenosStringUtils.isBlank(nextPayDateStr.text)){
							 XenosAlert.error("Next Payment Date can not be Empty");
							 cancelSubmit.enabled = true;
							 amendReset.enabled = true;
							 return;
						} else  {
					         var comDate:int = 0;
					         if (DateUtils.isValidDate(StringUtil.trim(nextPayDateStr.text))){
					         	var nextPaymentDate:Date = dateformat.toDate(CustomDateFormatter.customizedInputDateString(nextPayDateStr.text));
					         	var valueDate:Date = dateformat.toDate(CustomDateFormatter.customizedInputDateString(valueDateStrng));
							 	comDate = ObjectUtil.dateCompare(valueDate, nextPaymentDate);
							  	if(comDate == 1) {
							  	   XenosAlert.error("Next Payment Date must be greater than or equal to Value Date");
							  	   cancelSubmit.enabled = true;
							       amendReset.enabled = true;
							       return;
							     }	
					         } else {
					        	 XenosAlert.error("Invalid Next Payment Date");
					        	 cancelSubmit.enabled = true;
							     amendReset.enabled = true;
							     return;
					            }
							}   				
			}
			
			
			params["SCREEN_KEY"] = 13007;
			params.rnd = Math.random()+"";
			params["transactionPk"] = transactionPk;
			params["bookDateStr"] = bookDateStr.text;
			params["originalBookDateStr"] = originalBookDateStr.text;
			params["nextPayDateStr"] = nextPayDateStr.text;		
			transactionAmendSubmitService.send(params);
			
			
      }
     
     private function transactionAmendSubmitServiceHandler(event:ResultEvent):void {
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
			     	sconfMsg.visible = false;
			     	sconfMsg.includeInLayout=false;
			        ucsclbl.text = this.parentApplication.xResourceManager.getKeyValue('fam.transaction.amend.user.conf');
					originalBookDateLbl.visible = true;
                    originalBookDateLbl.includeInLayout = true;
                    originalBookDateStr.visible = false;
                    originalBookDateStr.includeInLayout = false;
		            bookDateLbl.visible = true;
		            bookDateLbl.includeInLayout = true;
		            bookDateStr.visible = false;
		            bookDateStr.includeInLayout = false;
		            nextPayDateLbl.visible = true;
		            nextPayDateLbl.includeInLayout = true;
		        	nextPayDateStr.visible = false;
		            nextPayDateStr.includeInLayout = false;
			    	amendReset.visible=false;
			    	amendReset.includeInLayout=false;
					cancelSubmit.visible=false;
					cancelSubmit.includeInLayout=false;
			    	backButton.visible = true;
			    	backButton.includeInLayout= true;
					backButton.enabled = true;
			    	uCancelConfSubmit.visible = true;
			    	uCancelConfSubmit.includeInLayout= true;
					uCancelConfSubmit.enabled = true;
			    	app.submitButtonInstance=uCancelConfSubmit;
			    	this.bookDate.styleName = "FormLabelHeading";
		  	        this.nextPaymentDate.styleName = "FormLabelHeading";
		  	        this.originalBookDate.styleName = "FormLabelHeading";
				       
			      	commandForm=result.transactionPage;
					
					if (commandForm != null) {
						  amendResult = commandForm;
						  nextPaymentDateStrng = commandForm.nextPayDateStr;
						  bookDateStrng = commandForm.bookDateStr;
						  originalBookDateStrng = commandForm.originalBookDateString;				  
					}
		     	}
	     	}
			cancelSubmit.enabled = true;
			amendReset.enabled = true;
     }
  /**
    * This method sends the HttpService for reset operation.
    * 
    */   
    public function doAmendReset():void  { 
    	amendReset.enabled = false;
		cancelSubmit.enabled = false;
		var params : Object = new Object();
		parseUrlString();
		params["transactionPk"] = transactionPk;
		params["SCREEN_KEY"] = 13006;
		params.rnd = Math.random()+"";
        transactionAmendResetRequest.send(params);
    }

 	private function doConfirm():void {
		uCancelConfSubmit.enabled = false;
		backButton.enabled = false;
		var params : Object = new Object();
		params["transactionPk"] = transactionPk;
		params["SCREEN_KEY"] = "13008";
		params.rnd = Math.random()+"";
		transactionAmendConfirmService.send(params);
    }
	
    private function doBack() :void {
		uCancelConfSubmit.enabled=false;
		backButton.enabled=false;
		  if(transactionTypeStr == "SECURITY_TRADE") {
		  	this.originalBookDateStr.visible = false;
		  	this.originalBookDateStr.includeInLayout = false;
		  	this.bookDateStr.visible = false;
		  	this.bookDateStr.includeInLayout = false;
		  	this.nextPayDateLbl.visible = false;
		  	this.nextPayDateLbl.includeInLayout = false;
		  	this.nextPayDateStr.visible = true;
		  	this.nextPayDateStr.includeInLayout = true;
		  	this.nextPayDateStr.text = nextPaymentDateStrng;
		  	this.nextPaymentDate.styleName = "ReqdLabel";
		  	this.bookDate.styleName = "FormLabelHeading";
		  	this.originalBookDate.styleName = "FormLabelHeading";
		  } else if (transactionTypeStr == "CAM_CASH_DIVIDEND" && 
		  					statusStr =="NORMAL") {
		  	this.nextPayDateStr.visible = false;
		  	this.nextPayDateStr.includeInLayout = false;
		  	this.originalBookDateStr.visible = false;
		  	this.originalBookDateStr.includeInLayout = false;
		  	this.bookDateLbl.visible = false;
		  	this.bookDateLbl.includeInLayout = false;
		  	this.bookDateStr.visible = true;
		  	this.bookDateStr.includeInLayout = true;
		  	this.bookDateStr.text = bookDateStrng;
		  	this.bookDate.styleName = "ReqdLabel";
		  	this.nextPaymentDate.styleName = "FormLabelHeading";
		  	this.originalBookDate.styleName = "FormLabelHeading";
		  } else if (transactionTypeStr == "CAM_CASH_DIVIDEND" && 
		  					statusStr =="CANCEL") {
		  	this.nextPayDateStr.visible = false;
		  	this.nextPayDateStr.includeInLayout = false;
		  	this.originalBookDateLbl.visible = false;
		  	this.originalBookDateLbl.includeInLayout = false;
		  	this.bookDateLbl.visible = false;
		  	this.bookDateLbl.includeInLayout = false;
		  	this.originalBookDateStr.visible = true;
		  	this.originalBookDateStr.includeInLayout = true;
		  	this.originalBookDateStr.text = originalBookDateStrng;
		  	this.bookDateStr.visible = true;
		  	this.bookDateStr.includeInLayout = true;
		  	this.bookDateStr.text = bookDateStrng;
		  	this.bookDate.styleName = "ReqdLabel";
		  	this.originalBookDate.styleName = "ReqdLabel";
		  	this.nextPaymentDate.styleName = "FormLabelHeading";
		  	}
		  	sconfMsg.visible = false;
		  	sconfMsg.includeInLayout = false;
    	    cancelSubmit.visible=true;
			cancelSubmit.includeInLayout=true;
			amendReset.visible=true;
			amendReset.includeInLayout=true;
			backButton.visible = false;
			backButton.includeInLayout= false;
			uCancelConfSubmit.visible=false;
			uCancelConfSubmit.includeInLayout= false;
			sConfSubmit.visible=false;
			sConfSubmit.includeInLayout= false;
			app.submitButtonInstance=cancelSubmit;
			ucsclbl.text = XenosStringUtils.EMPTY_STR;
    }
    
    private function transactionAmendConfirmServiceHandler(event:ResultEvent):void {
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
			            commandForm=result.transactionPage;
					    if (commandForm != null) {
						    amendResult=commandForm;
					    }
						sconfMsg.visible = true;
					    sconfMsg.includeInLayout=true;
			            ucsclbl.text = this.parentApplication.xResourceManager.getKeyValue('fam.transaction.amend.system.conf');
					    originalBookDateLbl.visible = true;
                        originalBookDateLbl.includeInLayout = true;
                        originalBookDateStr.visible = false;
                        originalBookDateStr.includeInLayout = false;
                        bookDateLbl.visible = true;
                        bookDateLbl.includeInLayout = true;
                        bookDateStr.visible = false;
                        bookDateStr.includeInLayout = false;
                        nextPayDateLbl.visible = true;
                        nextPayDateLbl.includeInLayout = true;
                        nextPayDateStr.visible = false;
                        nextPayDateStr.includeInLayout = false;
                        backButton.visible = false;
			            backButton.includeInLayout= false;
						uCancelConfSubmit.visible = false;
						uCancelConfSubmit.includeInLayout= false;
					    sConfSubmit.visible= true;
					    sConfSubmit.includeInLayout = true;
						sConfSubmit.enabled= true;
					    app.submitButtonInstance=sConfSubmit;
			       }
		    }
			uCancelConfSubmit.enabled= true;
			backButton.enabled= true;
     }
  
    private function doOk():void {
		sConfSubmit.enabled= false;
	    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
    
     private function showFundDetails(fundPk:String):void{	   			
				var parentApp :UIComponent = UIComponent(this.parentApplication);
				XenosPopupUtils.showFundCodeDetails(fundPk, parentApp);
	   }
	   
	 // Displays Transaction Result window
	   private function showTxnDetails(txnPk:String):void{
	   	    var parentApp :UIComponent = UIComponent(this.parentApplication);
	   	    XenosPopupUtils.showTransactionDetails(txnPk,commandFormIdForTransaction, parentApp, this.parentApplication.xResourceManager.getKeyValue('fam.transactionquery.label.result')); 
	   }
	   
	   /**
	   * This method is used for loading original component Details popup module
	   * 
	   */  
	   	private function showSourceComponentDetails(event: MouseEvent):void {
	   		var sourceComponent:String = amendResult.sourceComponent;
	   		var trgTransactionPk:String = amendResult.trgTransactionPk; 
	   		var transactionType:String = amendResult.transactionType; 
	   		var parentPk:String = amendResult.parentPk;
	   		// XenosAlert.info("transactionType :: "+transactionType); 
	   		var sPopup : SummaryPopup;
			if(XenosStringUtils.equals(sourceComponent,"TRD")) {
				
				sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
				
				sPopup.title = this.parentApplication.xResourceManager.getKeyValue('trd.summaryquery.label.tradedetailsummary');
				sPopup.width = 650;
	    		sPopup.height = 420;
				PopUpManager.centerPopUp(sPopup);		
				sPopup.moduleUrl = Globals.TRADE_DETAILS_SWF+Globals.QS_SIGN+Globals.TRADE_PK+Globals.EQUALS_SIGN+trgTransactionPk;
			}  else if(XenosStringUtils.equals(sourceComponent,"CAX")) {
					sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
					sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.label.entitlement.detail.view');
					//set the width and height of the popup
					sPopup.width = 800;
					sPopup.height = 500;
					sPopup.horizontalScrollPolicy="auto";
					sPopup.verticalScrollPolicy="auto";
					PopUpManager.centerPopUp(sPopup);
					
					//Setting the Module path with some parameters which will be needed in the module for internal processing.
					sPopup.moduleUrl = Globals.CAX_RIGHTS_DETAILS_SWF + Globals.QS_SIGN + Globals.RIGHTS_DETAIL_PK + Globals.EQUALS_SIGN + trgTransactionPk;
            }  
	   }
	   
	   