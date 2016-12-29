// ActionScript file

import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.OnDataChangeUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.fam.FamConstants;
import com.nri.rui.fam.validators.FamVoucherEntryValidator;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;
import mx.events.ValidationResultEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

[Bindable] private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
      		
[Bindable] private var mode : String = "ENTRY";
            
[Bindable] private var commandFormId : String = XenosStringUtils.EMPTY_STR;

[Bindable] private var commandForm : Object = new Object();

		/**
		 * This method is called when the View Stack has been created. It performs initialization and adds event listeners to the Fund Code and Security Code fields
		 */
		private function loadAll():void {
			   app.submitButtonInstance = submit;	
               callInitService();	    	
		       hideAll();		    	
		       fundPopUp.fundCode.addEventListener(FlexEvent.VALUE_COMMIT, onChangeFundCode);		        
		       securityCode.instrumentId.addEventListener(FlexEvent.VALUE_COMMIT, onChangeSecurityCode);
        }

		/**
		 * This method helps to display the initial Voucher Entry Screen
		 */             
        private function callInitService() : void {
        	
         	var rndNo:Number = Math.random();
    		var req : Object = new Object();
    		req.SCREEN_KEY = 12084;
    		initializeVoucherEntry.request = req;         
    		initializeVoucherEntry.url = "fam/voucherEntry.spring?method=initPage&menuType=y&rnd=" + rndNo;                    
    		initializeVoucherEntry.send();
        }
       
        /**
        * This method helps to display the initial Voucher Entry Screen and it is also the Result Handler of the HTTP Service named initializeVoucherEntry
        */
        private function initPage(event: ResultEvent) : void {
     		errPage.clearError(event);
     		hideAll();
     		commandForm = event.result.voucherEntryCommandForm; 
     		initInternal();
 		}
        
        /**
        * This method initializes the necessary variables
        */   
        private function initInternal() : void {
        		commandFormId = commandForm.commandFormId ;        
        		//initialize text fields
        		fundPopUp.fundCode.text = commandForm.fundCode;        		
        		bookDate.text = commandForm.bookDateStr;        		
        		localCcy.ccyText.text = commandForm.localCcyStr; 
        		allotmentAmount.text = commandForm.allotmentAmountStr; 
        		share.text = commandForm.shareStr;     		
        		securityCode.instrumentId.text = commandForm.securityCode;
        		amountlc.text = commandForm.amountLcStr;
        		amountbc.text = commandForm.amountBcStr;
        		
        		var dateStr:String = null;
        		
				if (commandForm.exDateStr != null) {
		            dateStr = commandForm.exDateStr;
		            if (dateStr != null)
		                exDate.selectedDate = DateUtils.toDate(dateStr);
		  		} else {
		  			exDate.text = XenosStringUtils.EMPTY_STR;
		  		}    
		        
		        if (commandForm.paymentDateStr != null) {
		            dateStr = commandForm.paymentDateStr;
		            if (dateStr != null)
		                paymentDate.selectedDate = DateUtils.toDate(dateStr);
		        } else {
		        	paymentDate.text = XenosStringUtils.EMPTY_STR;
		        }   
        		
        		var initColl:ArrayCollection = new ArrayCollection();     		       		
        		
        		// Populate the drop down list for the Voucher Type List
        		
        		if (commandForm.voucherTypeList.item != null) {
            		if (commandForm.voucherTypeList.item is ArrayCollection) {
            			initColl = commandForm.voucherTypeList.item as ArrayCollection;
            		} else {
            			initColl.addItem(commandForm.voucherTypeList.item);
            		}
        		}
    
        		var tempColl:ArrayCollection = new ArrayCollection();
        		tempColl.addItem({label: XenosStringUtils.EMPTY_STR, value: XenosStringUtils.EMPTY_STR});
        		
        		var i:int = 0;
        		
        		for(i = 0; i<initColl.length; i++) {
            		tempColl.addItem(initColl[i]);
        		}
        		voucherTypeList.dataProvider = tempColl;
        		setSelectedIndexOfComboBox(voucherTypeList, tempColl , commandForm.voucherType);
        		
        		// Populate the drop down list for the Auto Reverse Flag List
        		
        		var initColl2:ArrayCollection = new ArrayCollection(); 
        
        		if (commandForm.autoReverseFlagList.item != null) {
            		if (commandForm.autoReverseFlagList.item is ArrayCollection)
                		initColl2 = commandForm.autoReverseFlagList.item as ArrayCollection;
            		else
                		initColl2.addItem(commandForm.autoReverseFlagList.item);
        		}
    
        		var tempColl2:ArrayCollection = new ArrayCollection();

        		tempColl2.addItem({label: XenosStringUtils.EMPTY_STR, value: XenosStringUtils.EMPTY_STR});
        		for(i = 0; i<initColl2.length; i++) {
            		tempColl2.addItem(initColl2[i]);
        		}
        		autoReverseFlag.dataProvider = tempColl2;
        		setSelectedIndexOfComboBox(autoReverseFlag, tempColl2 , commandForm.autoReverseFlag);
        		
        		showHideFieldsForEntry();
        }
        
        /**
        * This method is called when the Voucher Type is changed and performs the necesssary tasks
        */
        private function onChangeVoucherType():void {
	    		var req : Object = new Object();
	    		req["voucherType"] = this.voucherTypeList.selectedItem != null?this.voucherTypeList.selectedItem.value :XenosStringUtils.EMPTY_STR;
	    		initializeVoucherEntry.request = req;         
	    		initializeVoucherEntry.url = "fam/voucherEntry.spring?method=onChangeVoucherType";             
	    		initializeVoucherEntry.send();
        }        
        
        /**
        * This method displays the fields to be entered corresponding to each Voucher Type
        */
        private function showHideFieldsForEntry():void {
        	
	        displayAll();
	        
	        switch(voucherTypeList.selectedItem.value) {
	        	
	            case FamConstants.PAYABLE_MGMT_FEE:
	        		this.autoReverseFlagLabel.visible = false;
	        		this.autoReverseFlagLabel.includeInLayout = false; 
	        		
	        		this.autoReverseFlagField.visible = false;
	        		this.autoReverseFlagField.includeInLayout = false;  
	        		
	        		this.localCcyLabel.visible = false;
	        		this.localCcyLabel.includeInLayout = false;
	        		
	        		this.localCcy.visible = false;
	        		this.localCcy.includeInLayout = false;
	        		
	        		this.shareRow.visible = false;
	        		this.shareRow.includeInLayout = false;
	        		
	        		this.allotmentAmountLabel.visible = false;
	        		this.allotmentAmountLabel.includeInLayout = false;
	        		
	        		this.allotmentAmount.visible = false;
	        		this.allotmentAmount.includeInLayout = false;
	        		
	        		this.securityCodePopUp.visible = false;
	        		this.securityCodePopUp.includeInLayout = false;
	        		
	        		this.securityCodeLabel.visible = false;
	        		this.securityCodeLabel.includeInLayout = false;
	        		
	        		this.row3.visible = false;
	        		this.row3.includeInLayout = false;
	        		
	        		this.amountlcLabel.visible = false;
	        		this.amountlcLabel.includeInLayout = false;
	        		
	        		this.amountlc.visible = false;
	        		this.amountlc.includeInLayout = false;
	        		break;
	        	
	        	case FamConstants.ACCRUED_INTEREST_ADJUST:
	        	
	        		this.exDateLabel.visible = false;
	        		this.exDateLabel.includeInLayout = false;
	        		        		
	        		this.exDateField.visible = false;
	        		this.exDateField.includeInLayout = false;
	        		
	        		this.localCcyLabel.visible = false;
	        		this.localCcyLabel.includeInLayout = false;
	        		        		
	        		this.localCcy.visible = false;
	        		this.localCcy.includeInLayout = false;  
	        		
	        		this.shareRow.visible = false;
	        		this.shareRow.includeInLayout = false;
	        		
	        		this.allotmentAmountLabel.visible = false;
	        		this.allotmentAmountLabel.includeInLayout = false;
	        		
	        		this.allotmentAmount.visible = false;
	        		this.allotmentAmount.includeInLayout = false; 
	        		break;       		   		        		  		        		
	        
	        	case FamConstants.RECEIVABLE_DIV_INCOME_ADJUST:
	        	
	        		this.autoReverseFlagLabel.visible = false;
	        		this.autoReverseFlagLabel.includeInLayout = false;
	        		
	        		this.autoReverseFlagField.visible = false;
	        		this.autoReverseFlagField.includeInLayout = false; 
	        		
	        		this.localCcyLabel.visible = false;
	        		this.localCcyLabel.includeInLayout = false;
	        		        		
	        		this.localCcy.visible = false;
	        		this.localCcy.includeInLayout = false;
	        		break;
	        	
	        	case FamConstants.OTHER_PAY_EXPENSE:
	        	
	        		this.autoReverseFlagLabel.visible = false;
	        		this.autoReverseFlagLabel.includeInLayout = false;
	        		
	        		this.autoReverseFlagField.visible = false;
	        		this.autoReverseFlagField.includeInLayout = false; 
	        		 
	        		this.securityCodeLabel.visible = false;
	        		this.securityCodeLabel.includeInLayout = false;
	        		
	        		this.securityCodePopUp.visible = false;
	        		this.securityCodePopUp.includeInLayout = false;
	        		
	        		this.row3.visible = false;
	        		this.row3.includeInLayout = false;
	        		
	        		this.allotmentAmountLabel.visible = false;
	        		this.allotmentAmountLabel.includeInLayout = false;
	        		
	        		this.allotmentAmount.visible = false;
	        		this.allotmentAmount.includeInLayout = false;
	        		
	        		this.shareRow.visible = false;
	        		this.shareRow.includeInLayout = false;
	        		break;
	       
	        	case FamConstants.ACCRUED_INTEREST_PAID_ADJUST:
	
	        		this.autoReverseFlagLabel.visible = false;
	        		this.autoReverseFlagLabel.includeInLayout = false;
	        		
	        		this.autoReverseFlagField.visible = false;
	        		this.autoReverseFlagField.includeInLayout = false;
	        		
	        		this.localCcyLabel.visible = false;
	        		this.localCcyLabel.includeInLayout = false;
	        		
	        		this.allotmentAmountLabel.visible = false;
	        		this.allotmentAmountLabel.includeInLayout = false;
	        		
	        		this.localCcy.visible = false;
	        		this.localCcy.includeInLayout = false;
	        		        		
	        		this.row3.visible = false;
	        		this.row3.includeInLayout = false;
	        		
	        		this.allotmentAmount.visible = false;
	        		this.allotmentAmount.includeInLayout = false;
	        		
	        		this.shareRow.visible = false;
	        		this.shareRow.includeInLayout = false;
	        		break;
	        		
	        	default:
	       			 hideAll();
	                 break;
	        } 
        }
        
        /**
        * This method displays all the fields
        */         
        private function displayAll():void {
        		this.row1.visible = true;
		    	this.row1.includeInLayout = true;
				
				this.row2.visible = true;
		    	this.row2.includeInLayout = true;
		    	
		    	this.row3.visible = true;
		    	this.row3.includeInLayout = true;
		    	
		    	this.row4.visible = true;
		    	this.row4.includeInLayout = true;
		    	
		    	this.autoReverseFlagLabel.visible = true;
        		this.autoReverseFlagLabel.includeInLayout = true;
		    	
		    	this.autoReverseFlagField.visible = true;
        		this.autoReverseFlagField.includeInLayout = true;  
		    	
		    	this.exDateLabel.visible = true;
        		this.exDateLabel.includeInLayout = true;
        		
        		this.exDateField.visible = true;
        		this.exDateField.includeInLayout = true;
        		
		    	this.securityCodeLabel.visible = true;
        		this.securityCodeLabel.includeInLayout = true;
        		
        		this.securityCodePopUp.visible = true;
        		this.securityCodePopUp.includeInLayout = true;
        		
        		this.localCcyLabel.visible = true;
        		this.localCcyLabel.includeInLayout = true;
        		        		
        		this.localCcy.visible = true;
        		this.localCcy.includeInLayout = true;
        		
        		this.shareRow.visible = true;
        		this.shareRow.includeInLayout = true;
        		
        		this.allotmentAmountLabel.visible = true;
		    	this.allotmentAmountLabel.includeInLayout = true;
		    	
		    	this.allotmentAmount.visible = true;
		    	this.allotmentAmount.includeInLayout = true;  
		    	
		    	this.amountlcLabel.visible = true;
        		this.amountlcLabel.includeInLayout = true;
        		
        		this.amountlc.visible = true;
        		this.amountlc.includeInLayout = true;
        		
        		this.amountbcLabel.visible = true;
        		this.amountbcLabel.includeInLayout = true;
        		
        		this.amountbc.visible = true;
        		this.amountbc.includeInLayout = true;
        }
        
        /**
        * This method hides all the fields
        */
        private function hideAll():void {
        		this.row1.visible = false;
		    	this.row1.includeInLayout = false;
				
				this.row2.visible = false;
		    	this.row2.includeInLayout = false;
		    	
		    	this.row3.visible = false;
		    	this.row3.includeInLayout = false;
		    	
		    	this.row4.visible = false;
		    	this.row4.includeInLayout = false;
		    	
		    	this.shareRow.visible = false;
		    	this.shareRow.includeInLayout = false;
		    	
		    	this.allotmentAmountLabel.visible = false;
		    	this.allotmentAmountLabel.includeInLayout = false;
		    	
		    	this.allotmentAmount.visible = false;
		    	this.allotmentAmount.includeInLayout = false;
		    	
		    	this.autoReverseFlagLabel.visible = false;
        		this.autoReverseFlagLabel.includeInLayout = false;
        		
        		this.autoReverseFlagField.visible = false;
        		this.autoReverseFlagField.includeInLayout = false;
        		
        		this.localCcyLabel.visible = false;
        		this.localCcyLabel.includeInLayout = false;
        		        		
        		this.localCcy.visible = false;
        		this.localCcy.includeInLayout = false;
        		
        		this.allotmentAmountLabel.visible = false;
		    	this.allotmentAmountLabel.includeInLayout = false;
		    	
		    	this.allotmentAmount.visible = false;
		    	this.allotmentAmount.includeInLayout = false;  
        		
        		this.amountlcLabel.visible = false;
        		this.amountlcLabel.includeInLayout = false;
        		
        		this.amountlc.visible = false;
        		this.amountlc.includeInLayout = false;
        		
        		this.amountbcLabel.visible = false;
        		this.amountbcLabel.includeInLayout = false;
        		
        		this.amountbc.visible = false;
        		this.amountbc.includeInLayout = false;
        }
        
        /**
        * This method is called when the user presses the Submit button in the Voucher Entry Screen. 
        * It displays the User Confirmation Screen, if valid data has been entered. 
        */
        private function doSubmit():void {
        	
  			switch (voucherTypeList.selectedItem.value) {
  				
  				case FamConstants.PAYABLE_MGMT_FEE:
  					formatNumber(amountbc);
  					break;
  				
  				case FamConstants.ACCRUED_INTEREST_ADJUST:
  					formatNumber(amountlc);
  					formatNumber(amountbc);
  					break;
  				
  				case FamConstants.RECEIVABLE_DIV_INCOME_ADJUST:
  					formatNumber(allotmentAmount);
  					formatNumber(share);
  					formatNumber(amountlc);
  					formatNumber(amountbc);
  					break;
  				
  				case FamConstants.OTHER_PAY_EXPENSE:
  					formatNumber(amountlc);
  					formatNumber(amountbc);
  					break;
  				
  				case FamConstants.ACCRUED_INTEREST_PAID_ADJUST:
  					formatNumber(amountlc);
  					formatNumber(amountbc);
  					break;
  			}
  		
  			// Populate the Request Object
  			var requestObj:Object = new Object();
  			
  			requestObj = populateRequestParams();
  			
  			var validEntryData:Boolean;
  			
  			validEntryData = validateFormData();
  			
  			if (validEntryData) {
  				requestObj.SCREEN_KEY = 12102;
  				voucherEntrySubmitService.request = requestObj;  				  				
  				voucherEntrySubmitService.url = "fam/voucherEntry.spring?method=submitPage";
  				voucherEntrySubmitService.send();
  			} 
	  	}
	  	
	  	/**
	  	 * This method helps to validate the data entered
	  	 */
	  	private function validateFormData():Boolean {
	  		var model:Object = {
                                    famVoucherEntry:{						          			
						          			voucherType:this.voucherTypeList.selectedItem.value,
						          			fundCode:this.fundPopUp.fundCode.text,
						          			securityCode:this.securityCode.instrumentId.text,
						          			share:this.share.text,
						          			bookDate:this.bookDate.text,
						          			allotmentAmount:this.allotmentAmount.text,
						          			localCcy:this.localCcy.ccyText.text,
						          			exDate:this.exDate.text,
						          			paymentDate:this.paymentDate.text,
						          			amountlc:this.amountlc.text,
						          			amountbc:this.amountbc.text						          									         
                                   	}
                               };
                                   
		    var famVoucherValidate:FamVoucherEntryValidator = new FamVoucherEntryValidator();
		    
		    famVoucherValidate.source = model;
		    famVoucherValidate.property = "famVoucherEntry";
		    
		    var validationResult:ValidationResultEvent = famVoucherValidate.validate();			
		    
		    if (validationResult.type == ValidationResultEvent.INVALID) {
		        // Invalid Entry Data
		        var errorMsg:String = validationResult.message;
		        XenosAlert.error(errorMsg);
		        return false;		        
		    } else {
		    	// Valid Entry Data
		    	return true;
		    }
	  	}
	  	
	  	/**
	  	 * This method populates the data entered by the user in the Request Object
	  	 */
	  	private function populateRequestParams():Object {
	  		if (XenosStringUtils.equals(voucherTypeList.selectedItem.value , FamConstants.RECEIVABLE_DIV_INCOME_ADJUST)
	  		    && XenosStringUtils.isBlank(this.paymentDate.text)) {
	  		    	this.paymentDate.text = "20991231";
	  		}
	  		var reqObj:Object = new Object();
	  		reqObj["voucherTypeStr"] = this.voucherTypeList.selectedItem != null?this.voucherTypeList.selectedItem.label :XenosStringUtils.EMPTY_STR;
	  		reqObj["voucherType"] = this.voucherTypeList.selectedItem != null?this.voucherTypeList.selectedItem.value :XenosStringUtils.EMPTY_STR;
	  		reqObj["autoReverseFlagStr"] = this.autoReverseFlag.selectedItem != null?this.autoReverseFlag.selectedItem.label :XenosStringUtils.EMPTY_STR; 
	  		reqObj["autoReverseFlag"] = this.autoReverseFlag.selectedItem != null?this.autoReverseFlag.selectedItem.value :XenosStringUtils.EMPTY_STR;  		
  			reqObj["fundCode"] = this.fundPopUp.fundCode.text;
  			reqObj["fundName"] = this.fundAccName.text;
  			reqObj["localCcyStr"] = this.localCcy.ccyText.text;
  			reqObj["allotmentAmountStr"] = this.allotmentAmount.text; 
  			reqObj["shareStr"] = this.share.text;
  			reqObj["bookDateStr"] = this.bookDate.text;
  			reqObj["securityCode"] = this.securityCode.instrumentId.text; 
  			reqObj["securityName"] = this.securityName.text;
  			reqObj["exDateStr"] = this.exDate.text;
  			reqObj["paymentDateStr"] = this.paymentDate.text;
  			reqObj["amountLcStr"] = this.amountlc.text;
  			reqObj["amountBcStr"] = this.amountbc.text;

  			return reqObj;	
	  	}
	  	
	  	/**
	  	 * This method is the Result Handler for the HTTP Service named voucherEntrySubmitService
	  	 */
	  	private function submitResultHandler(event: ResultEvent):void {
	  		
	  		  var result:XML = XML(event.result);
	  		  
	 		  errPage.clearError(event);
	    	  //var errorInfoList:ArrayCollection = new ArrayCollection();
	    	  
	    	  if (result.child("Errors").length() > 0) {
                  var errorInfoList : ArrayCollection = new ArrayCollection();
                  //populate the error info list              
                  for each (var error:XML in result.Errors.error) {
                     errorInfoList.addItem(error.toString());
                  }
                  errPage.showError(errorInfoList);//Display the error
	    	  } else {
    	  		  commandForm = result;
		          commandFormId = commandForm.commandFormId;  
		  			
		  		  // Display the Voucher Entry - User Confirmation Screen
		  		  vstack.selectedChild = userconf;
 		  		  if (errPageConf != null) {
		  			  errPageConf.clearError(event);
		  		  }
 		  			
		  		  app.submitButtonInstance = confirm;
	    	  }
 		}
	  	
	  	/**
	  	 * This method is the Result Handler for the HTTP Service named voucherEntryUserConfirmationService
	  	 */
	  	private function userConfirmationResultHandler(event: ResultEvent):void {
	  		   
	  		   // Enable the confirm button
	  		   this.confirm.enabled = true;
		  	   this.back.enabled = true;
		  	   var result:XML = XML(event.result);
	  		  
	 		   errPageConf.clearError(event);
	    	   //var errorInfoList:ArrayCollection = new ArrayCollection();
	    	  
	    	   if (result.child("Errors").length() > 0) {
                   var errorInfoList : ArrayCollection = new ArrayCollection();
                   //populate the error info list              
                   for each (var error:XML in result.Errors.error) {
                      errorInfoList.addItem(error.toString());
                   }
                   errPageConf.showError(errorInfoList);//Display the error
	    	   } else {
    	  		   commandForm = result;
		           commandFormId = commandForm.commandFormId;  
		  			
		  		   // Display the Voucher Entry - User Confirmation Screen
		  		   vstack.selectedChild = systemconf;
		  		   /*
		  		   if (errPageConf != null) {
		  			   errPageConf.clearError(event);
		  		   }
		  		   */
		  		   app.submitButtonInstance = ok;
	    	   }
 		}
	  	
	  	/**
	  	 * This method is the Fault Handler for the HTTP Service named voucherEntryUserConfirmationService
	  	 */ 
	  	private function faultHandlerOfUserConfirmationService(event: FaultEvent):void {
	  		// Enable the confirm button
	  		this.confirm.enabled = true;
	  		this.back.enabled=true;
	  		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred') + event.fault.faultString);
	  	}
	  	
	  	/**
	  	 * This method displays the Voucher Entry Screen when the Back button is pressed
	  	 */
	  	private function doBack():void { 	
		  	vstack.selectedChild = entry;
		  	app.submitButtonInstance = submit;		  	 
	  	}
	  	
	  	/**
	  	 * This method displays the System Confirmation Screen when the user presses the Confirm button in the User Confirmation Screen
	  	 */
	  	private function doConfirm():void {
	  		var req: Object = new Object();
	  		req.SCREEN_KEY = 12103;
	  		voucherEntryUserConfirmationService.request = req;
	  		 
	  		// Disable the confirm button
	  		this.confirm.enabled = false;
	  		this.back.enabled = false;
  			voucherEntryUserConfirmationService.send();
	  	}
	  	
	  	/**
	  	 * This method displays the Voucher Entry Screen when the user presses the Ok button in the System Confirmation Screen
	  	 */
	  	private function doOk():void {   				
		  	vstack.selectedChild = entry;
		  	hideAll();		  	 
		  	callInitService();
		  	
		  	app.submitButtonInstance = submit;
	  	}
	  	
	  	/**
	  	 * This method displays the Fund Name corresponding to the Fund Code
	  	 */
	  	private function onChangeFundCode(event:Event):void {
    		OnDataChangeUtil.onChangeFundCode(fundAccName,fundPopUp.fundCode.text);
	    }
	    
	    /**
	    * This method displays the Security Name corresponding to the Security Code
	    */
	    private function onChangeSecurityCode(event:Event):void {
	    	OnDataChangeUtil.onChangeSecurityCode(securityName,securityCode.instrumentId.text);
	    }
	    
		/**
	     * Calculates the index of Combo Box 
		 * Set  index and prompt of the Combo Box.
	     */
	    private function setSelectedIndexOfComboBox(comboBoxId : ComboBox , collection : ArrayCollection , defaultValue : String):void {
	     	var index:int = 0;
		    if (!XenosStringUtils.isBlank(defaultValue)) {
		        //return index;
		        for (var count:int = 0; count < collection.length; count++) {
			        var bean:Object = collection.getItemAt(count);
			        if (XenosStringUtils.equals(bean['value'] , defaultValue)) {
			            index = count;
			            break;
			        }
			    }
		    }
		    comboBoxId.selectedIndex = index ;
		    if (index == 0 ) {
		    	comboBoxId.prompt = "Select";
		    } 	   
    	}
    	
	    /**
	    * This method validates and formats Amount (LC) for Voucher Entry Screen
	    */
	    private function validateAmountLc():void {	
	    	
	       var tmpStr:String = amountlc.text;
	       
	       if (XenosStringUtils.equals(tmpStr.charAt(0),"-")) {
	       		amountlc.text = tmpStr.substr(1,tmpStr.length);
	       		amountlcValidation.handleNumericField(numberFormatter);
	       		amountlc.text = "-" + amountlc.text;
	       } else {
	       		amountlcValidation.handleNumericField(numberFormatter);
	       }
	    }
	    
	    /**
	    * This method validates and formats Amount (BC) for Voucher Entry Screen
	    */
	    private function validateAmountBc():void {	
	    	
	       var tmpStr:String = amountbc.text;
	       
	       if (XenosStringUtils.equals(tmpStr.charAt(0),"-")) {
	       		amountbc.text = tmpStr.substr(1,tmpStr.length);
	       		amountbcValidation.handleNumericField(numberFormatter);
	       		amountbc.text = "-" + amountbc.text;
	       } else {
	       		amountbcValidation.handleNumericField(numberFormatter);
	       }
	    }
	    
	    /**
        * This method formats the number fields
        */
        private function formatNumber(numberField:Object):void {
        	
        	var tmpStr:String;
        	
        	if (numberField.text.charAt(0) != '-') {
  				if (checkValidNumber(numberField.text)) {
  					numberField.text = numberFormatter.format(numberField.text);
  				}
  			} else {
  				tmpStr = numberField.text.substr(1,numberField.text.length);
  				if (checkValidNumber(tmpStr)) {
  					numberField.text = '-' + numberFormatter.format(tmpStr);
  				}
  			}
        }
	    
	    /**
        * Checking valid input
        */
        private function checkValidNumber(number:String):Boolean {
            var length:int = number.length;
            var i:int = 0;
            if(number.charAt(0) != '.' &&  number.charAt(0) != '-' && isNaN(Number(number.charAt(0))) ){            
                return false;             
            }
            while (i<length) {
                if (isNaN(Number(number.charAt(i))) && (number.charAt(i) != '.')&&  (number.charAt(0) != '-')) {          
                    if(!((i == length -1) && ((number.charAt(i) == 'B')|| 
                        (number.charAt(i) == 'M') ||(number.charAt(i) == 'T')))) {
                        return false;
                    }    
                }
                i++;
            }
            return true;
        }
	    