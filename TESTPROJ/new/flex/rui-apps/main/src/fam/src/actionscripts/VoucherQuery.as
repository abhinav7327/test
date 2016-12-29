// ActionScript file


 
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosHTTPServiceForSpring;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.fam.validators.FamVoucherQueryValidator;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;

[Bindable] private var queryResult:ArrayCollection = new ArrayCollection();
[Bindable] private var summaryResult:ArrayCollection = new ArrayCollection();
[Bindable] public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable] public var mode:String = "query";
[Bindable] private var commandFormId : String = XenosStringUtils.EMPTY_STR;
 
[Bindable] private var commandForm : Object = new Object();

private var commandFormIdForTransaction : String = XenosStringUtils.EMPTY_STR;

// Stores elements of type 'Object' with two properties which are 'fundCode' and 'index'
[Bindable] private var fundCodeArrColl: ArrayCollection = new ArrayCollection() ;

[Bindable] public var editFundCodeMode: Boolean = false;
    
// Stores the row index of the Fund Code to be edited
private var editFundCodeIndex: int = -1 ;

private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
private var rndNo: Number = 0;
private var initCompFlg: Boolean = false;

 	private function initPageStart():void {
 		 
    	 parseUrlString();
    	 var req : Object = new Object();
    	 if (mode == "query") {           
	        if (!initCompFlg) {    
	            rndNo= Math.random();
	            //var req : Object = new Object();
	   			req.SCREEN_KEY = "12107";
	    	    initializeVoucherQuery.request = req;         
	            initializeVoucherQuery.url = "fam/voucherQuery.spring?method=initialExecute&rnd=" + rndNo;                    
	            initializeVoucherQuery.send();
	            dummyService.send();
	        } else
	            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
	     } else if (mode == "cancel") {
	    	if (!initCompFlg) {
	    		this.addEventListener("cancelReset", submitQuery);
	            rndNo= Math.random();
	            //var req : Object = new Object();
	   			req.SCREEN_KEY = "12107";
	   			req.mode= "cancel";
	    	    initializeVoucherQuery.request = req;         
	            initializeVoucherQuery.url = "fam/voucherQuery.spring?method=initialExecute&rnd=" + rndNo;                    
	            initializeVoucherQuery.send();
	            dummyService.send();
	        } else {
	            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
	        }
	     } 
    }
    
    private function dummyServiceResultHandler(event : ResultEvent) : void {
        commandFormIdForTransaction = event.result.transactionQueryCommandForm.commandFormId;
    }
  	
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
	                            //XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString()); 	                          
	                        }
	                    }                    	
                    } else {
                    	mode = "query";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }               
  	}
  
 	private function initPage(event: ResultEvent) : void {
        
        var initColl:ArrayCollection = new ArrayCollection();

        errPage.clearError(event);
        
        commandForm = event.result.voucherQueryCommandForm; 
        commandFormId = commandForm.commandFormId ;
        
        // Initialize the text fields
        //multipleFundSelector.fundCodeLabel.styleName="ReqdLabel";
        multipleFundSelector.fundCodeSummary.enabled=true;
        multipleFundSelector.fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;
        localCcy.ccyText.text = commandForm.localCcyStr;
        referenceNumber.text = commandForm.referenceNumber;
        security.instrumentId.text = commandForm.securityCode;
        bookdateFrom.text = commandForm.bookDateFrom != null ? commandForm.bookDateFrom : XenosStringUtils.EMPTY_STR;  
        bookdateTo.text = commandForm.bookDateTo != null ? commandForm.bookDateTo : XenosStringUtils.EMPTY_STR;
        exdateFrom.text = commandForm.exDateFrom != null ? commandForm.exDateFrom : XenosStringUtils.EMPTY_STR;  
        exdateTo.text = commandForm.exDateTo != null ? commandForm.exDateTo : XenosStringUtils.EMPTY_STR;
        paymentdateFrom.text = commandForm.paymentDateFrom != null ? commandForm.paymentDateFrom : XenosStringUtils.EMPTY_STR;  
        paymentdateTo.text = commandForm.paymentDateTo != null ? commandForm.paymentDateTo : XenosStringUtils.EMPTY_STR;
        
        handleFundCodeResult(event);
        
        initColl.removeAll();
        
        if (commandForm.voucherTypeList.item != null) {
            if (commandForm.voucherTypeList.item is ArrayCollection)
                initColl = commandForm.voucherTypeList.item as ArrayCollection;
            else
                initColl.addItem(commandForm.voucherTypeList.item);
        }
    	
        var tempColl:ArrayCollection = new ArrayCollection();
        tempColl.addItem({label: XenosStringUtils.EMPTY_STR, value: XenosStringUtils.EMPTY_STR});
        
        var i:int = 0;
        
        for (i = 0; i<initColl.length; i++) {
          	tempColl.addItem(initColl[i]);
        }
        
        voucherTypeList.dataProvider = tempColl;
        setSelectedIndexOfComboBox(voucherTypeList, tempColl , commandForm.voucherType);
        
        // Reset Multiple Fund Selector
        multipleFundSelector.reset();
        multipleFundSelector.fundPopUp.fundCode.setFocus();
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
    
	public function submitQuery(e: Event = null):void {
		
			// Reset the Page No
         	qh.resetPageNo();
		    
		    var requestObj: Object = populateRequestParams();
		    famVoucherQueryRequest.request = requestObj; 
	        var fundCodeArrCollValidate :ArrayCollection = new ArrayCollection();	        
	        var myModel:Object = {
	                                  famVoucher:{
								          voucherType:this.voucherTypeList.selectedItem.value,
								          fundCodeArrCollValidate:this.fundCodeArrColl,
								          multipleFundSelector:this.multipleFundSelector.isAllFundSelected(),
		     					          bookDateFrom:this.bookdateFrom.text,
		     					          bookDateTo:this.bookdateTo.text,
		                                  exDateFrom:this.exdateFrom.text,
		     					          exDateTo:this.exdateTo.text,
		                                  paymentDateFrom:this.paymentdateFrom.text,
							              paymentDateTo:this.paymentdateTo.text,	
							              security:this.security.instrumentId.text					         
	                                  }
	                             };
	                                
	        var famVoucherValidate:FamVoucherQueryValidator = new FamVoucherQueryValidator();
	        famVoucherValidate.source = myModel;
	        famVoucherValidate.property = "famVoucher";
	        var validationResult:ValidationResultEvent = famVoucherValidate.validate();
	        
	        if (validationResult.type==ValidationResultEvent.INVALID) {
	            var errorMsg:String=validationResult.message;
	            XenosAlert.error(errorMsg);
	        } else {
		           famVoucherQueryRequest.send();
		           //Setting Command Form Id for Peference 
		    	   qh.commandFormIdForPreference = famVoucherQueryResult.commandFormIdForPreference;
		    }
	}
	
	private function populateRequestParams():Object {
    	
    	 var reqObj: Object = new Object();
    	 reqObj["SCREEN_KEY"] = "12108";
         reqObj["method"] = "submitQuery";
         
         reqObj["rnd"] = Math.random() + "";
         reqObj["fundCode"] = this.multipleFundSelector.fundPopUp.fundCode.text;
         reqObj["voucherTypeStr"] = this.voucherTypeList.selectedItem != null?this.voucherTypeList.selectedItem.label :XenosStringUtils.EMPTY_STR;
	  	 reqObj["voucherType"] = this.voucherTypeList.selectedItem != null?this.voucherTypeList.selectedItem.value :XenosStringUtils.EMPTY_STR;
         reqObj["bookDateFrom"] = this.bookdateFrom.text;
         reqObj["bookDateTo"] = this.bookdateTo.text;
         reqObj["localCcyStr"] = this.localCcy.ccyText.text;
         reqObj["referenceNumber"] = this.referenceNumber.text;
         reqObj["securityCode"] = this.security.instrumentId.text;
         reqObj["exDateFrom"] = this.exdateFrom.text;
         reqObj["exDateTo"] = this.exdateTo.text;
         reqObj["paymentDateFrom"] = this.paymentdateFrom.text;
         reqObj["paymentDateTo"] = this.paymentdateTo.text;
         reqObj["isAllFundSelected"] = this.multipleFundSelector.isAllFundSelected(); 
         
         if (XenosStringUtils.equals(mode , "cancel")) {
         	reqObj["status"] =  Globals.STATUS_NORMAL;
         } 
         
         return reqObj;
    }
 	
 	private function loadResultPage(event:ResultEvent):void {
        
        var rs:XML = XML(XenosHTTPServiceForSpring.getXmlResult(event));       
        var cmdChildObj:XML =
        <commandFormIdForVoucher>{commandFormId}</commandFormIdForVoucher>
        
         var cmdChildObjForTransaction:XML =
        <commandFormId>{commandFormIdForTransaction}</commandFormId>
        
        if (event != null) {
            if(rs.child("row").length()>0) {
                errPage.clearError(event);
                summaryResult.removeAll();
                try {
                    for each ( var rec:XML in rs.row ) {
                    	rec.appendChild(cmdChildObj);
                    	rec.appendChild(cmdChildObjForTransaction);
                        summaryResult.addItem(rec);
                    }
                    changeCurrentState();
                    qh.setOnResultVisibility();
                    
                    qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
                    qh.PopulateDefaultVisibleColumns();
             		
                } catch(e:Error) {
                    //XenosAlert.error(e.toString() + e.message);
                    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.label.error.norecords.found'));
                }
             
            } else if(rs.child("Errors").length()>0) {
                //some error found
                summaryResult.removeAll(); // clear previous data if any as there is no result now.
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                   errorInfoList.addItem(error.toString());
                }
                errPage.showError(errorInfoList);//Display the error
             
            } else {
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('fam.label.error.norecords.found'));
                summaryResult.removeAll(); // clear previous data if any as there is no result now
                errPage.removeError(); //clears the errors if any
            }
        }
    }    
	
	private function resetQuery(e:Event=null):void {
		
		   var req : Object = new Object();
		   rndNo= Math.random();
		   
		   if (this.mode=="cancel") {
		   	
		   		req.SCREEN_KEY = "12107";
	   			req.mode = "cancel";
	    	    initializeVoucherQuery.request = req;         
	            initializeVoucherQuery.url = "fam/voucherQuery.spring?method=initialExecute&rnd=" + rndNo;                    
	            initializeVoucherQuery.send();
	        	
	        	// Reset the Page No
	            qh.resetPageNo();
	            
	            // disable the preferences
	            qh.screenPref.enabled = false;
	            qh.clearScreenPref.enabled = false;
	            qh.excelPref.enabled = false;
	            qh.clearExcelPref.enabled = false;
	            qh.pdf.enabled = false;
	            qh.xls.enabled = false;
	            qh.btnPrev.enabled = false;
	            qh.btnNext.enabled = false;
	         
	            // clear previous data if any as there is no result now	
		        this.summaryResult.removeAll();
		       
		        //clears the errors if any
		        this.errPage.removeError();
	       }
    }

	private function changeCurrentState():void {
		currentState = "result";
		app.submitButtonInstance= null;
	}
    
	/**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window
    */
	private function generateXls():void {
	     	var url : String = "fam/voucherQuery.spring?method=generateXLS&commandFormId="+ commandFormId;
	     	
	    	var request:URLRequest = new URLRequest(url);
	    	request.method = URLRequestMethod.POST;
	    	// set menu pk in the request
	      	var variables:URLVariables = new URLVariables();
	      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
	      	request.data = variables;
	    	 try {
	                navigateToURL(request,"_blank");
	         }
	         catch (e:Error) {
	                // handle error here
	                trace(e);
	         } 
	}
     
    /**
    * This will generate the Pdf report for the entire query result set 
    * and will open in a separate window
    */
     private function generatePdf():void {
        var url : String = "fam/voucherQuery.spring?method=generatePDF&commandFormId="+ commandFormId;
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        // set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
        try {
            navigateToURL(request,"_blank");
        }
        catch (e:Error) {
            // handle error here
            trace(e);
        }
    }     
 	
 	private function doPrint():void {
    	/* var printObject:XenosPrintView = new XenosPrintView();
    	printObject.frmPrintHeader.lbl.text = "Cam Movement Query";
    	printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
	    PrintDG.printAll(printObject); */
    } 
    
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
    private function doNext():void {
    	var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random() + "";
        famVoucherQueryRequest.request = reqObj;
        famVoucherQueryRequest.send();
    } 
    
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
    private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        famVoucherQueryRequest.request = reqObj;
        famVoucherQueryRequest.send();
    }
    
    /**
    * This method should be called on creationComplete of the datagrid 
    */ 
    private function bindDataGrid():void {
        qh.dgrid = famVoucherQueryResult;
    }  

	/**
	 * This method sets data to 'MultipleFundSelector' component from Server sent XML 
	 */
    private function handleFundCodeResult(event: ResultEvent):void {
    	
    	errPage.clearError(event);
    	var errorInfoList:ArrayCollection=new ArrayCollection();
    	
    	if (event.result!= null && event.result.XenosErrors!= null && 
    		event.result.XenosErrors.Errors != null) {
			   if (event.result.XenosErrors.Errors.error != null) {
					 if (event.result.XenosErrors.Errors.error is ArrayCollection) {
						 errorInfoList=event.result.XenosErrors.Errors.error as ArrayCollection;
					 } else { 
						 errorInfoList.addItem(event.result.XenosErrors.Errors.error);
					 }
			   }
			   errPage.showError(errorInfoList);
			   return;
	    }
	  
	    var commandForm: Object=event.result.voucherQueryCommandForm;
	   
	    // Set 'editFundCodeIndex' from Server sent XML 
	    editFundCodeIndex = commandForm.editFundCodeIndex ;
	   
	    // Stores elements of type 'String' i.e. Fund Code from Server sent XML
	    var tempColl: ArrayCollection = new ArrayCollection() ; 
	      	  
	    // Get rid of all previously stored items
	    fundCodeArrColl.removeAll();
    	   
    	// Fill up 'tempColl' from Server sent XML
    	if (commandForm.fundCodeList != null && commandForm.fundCodeList.fundCode != null) {          
            if (commandForm.fundCodeList.fundCode is ArrayCollection) {
           	    tempColl= commandForm.fundCodeList.fundCode as ArrayCollection ;           	  
            } else {
           	    tempColl.addItem(commandForm.fundCodeList.fundCode);           	   
            }
             
            var i: int = 0;
            // Fill up 'fundCodeArrColl' which is displayed in the Grid of 'MultipleFundSelector'           
            for(i=0; i< tempColl.length; i++) {
            	var obj:Object=new Object();
            	obj["fundCode"] = tempColl[i];
            	obj["index"] = i;
            	fundCodeArrColl.addItem(obj);            	
      		}    		
        }        
        // Set Fund Code if 'Edit' has been issued otherwise clear the TextInput.
        if(editFundCodeIndex>=0 && fundCodeArrColl.length>0){
         	multipleFundSelector.setFundCode(fundCodeArrColl.getItemAt(editFundCodeIndex)["fundCode"]);         
        } else {
         	multipleFundSelector.setFundCode(XenosStringUtils.EMPTY_STR);         	
        }
    }
    
    /**
    * This is solely used for 'MultipleFundSelector' component and handles ADD, EDIT and DELETE operations
    */ 
	private function fundCodeSelectionHandler(mode : String, fundCode : String , index : String = "-1") : void {
		
		 var params : Object = new Object();
		 
		 if (XenosStringUtils.equals(mode, MultipleFundSelector.ADD)) {	
			 // validation for trying to add empty fund code
		     if (fundCode == XenosStringUtils.EMPTY_STR) {
			     XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.transactionquery.error.fundcode.empty'));
			     return;
		     }
		     // validation for trying to add more than 10 fund code
		     if (fundCodeArrColl.length == 10) {
			  	 XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.transactionquery.error.fundcode.maxadded'));
			  	 return;
		     } 
		     // validation for trying to add duplicated fund code
		     if (editFundCodeIndex == -1) {
			     if (isDuplicatedFundCode(fundCode)) {
				 	 XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.transactionquery.error.fundcode.duplicated'));
				 	 return;
			 	 }
		     }		
			 params['method']="addFundCode";	
			 params['editFundCodeIndex']= editFundCodeIndex;
			 			
		   } else if (XenosStringUtils.equals(mode , MultipleFundSelector.EDIT)) {			
			 		  params['method']="editFundCode";
			  		  params['editFundCodeIndex']= index; 			
		   } else if (XenosStringUtils.equals(mode , MultipleFundSelector.DELETE)) {			
					  params['method']="deleteFundCode";
					  //Reset (required when the user issued Edit and then Delete)
					  params['editFundCodeIndex']= -1; 
					  params['deleteFundCodeIndex']=index;						
		   }		
		   params['fundCode']=fundCode;
		   fundCodeQueryRequest.send(params);
	 }
	 
	 /**
     * Checks whether fundCode is duplicated or not
     */
     private function isDuplicatedFundCode(value:String):Boolean {
		    var i:int;
		    var len:int=fundCodeArrColl.length;
	
		    for each (var o:Object in fundCodeArrColl) {
				 if (o.fundCode == value) {
					return true;
				 }
		   	}
		   	return false;
     }
     
     /**
 	  *  Datagrid header release event handler to handle data grid column sorting
 	  */
     private function dataGrid_headerRelease(evt:DataGridEvent):void {				
			var dg:CustomDataGridForSpring = CustomDataGridForSpring(evt.currentTarget);
	        sortUtil.clickedColumn = dg.columns[evt.columnIndex];		
	 }
	 