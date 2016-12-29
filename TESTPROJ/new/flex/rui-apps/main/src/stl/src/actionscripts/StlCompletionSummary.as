
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.stl.validators.CompletionSummaryValidator;
 import com.nri.rui.core.utils.ProcessResultUtil;
 
 import flash.events.IEventDispatcher;
 
 import mx.collections.ArrayCollection;
 import mx.events.ResourceEvent;
 import mx.events.ValidationResultEvent;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
 
// ActionScript file for Completion Summary

	private var rndNo:Number = 0;
	private var initCompFlg : Boolean = false;
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnOurContextItem:ArrayCollection = new ArrayCollection();
    
    private const notApplicable : String = "NA";
    [Bindable]
    public var returnCpContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var firmBankCode:String = notApplicable;
    [Bindable]
    private var firmBankAccount:String = notApplicable;
    [Bindable]
    private var brokerCode:String = notApplicable;
    [Bindable]
    private var appDate:String;
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
   
	/**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    * This will fetch data to fill the initial form data to show the user.
    */
     private function initPageStart():void {            
        if (!initCompFlg) {    
            rndNo= Math.random();
            var req : Object = new Object();
            req.SCREEN_KEY = 623;
            initializeCompletionQuery.request = req;        
            initializeCompletionQuery.url = "stl/stlCompletionSummaryDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializeCompletionQuery.send();        
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.summary.already.initiated'));
     } 
     /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * Once initial data is fetched from database to fill some form data, this method works
    * to actually show the data.
    */   
     private function initPage(event: ResultEvent) : void {
     	
     	errPage.clearError(event); //clears the errors if any 
     	
     	//initiate text fields
     	ccyBox.ccyText.text = "";
     	instPopUp.instrumentId.text="";
     	ourActPopUp.accountNo.text = "";
     	cpActPopUp.accountNo.text = "";
     	
     	ourActPopUp.accountNo.setFocus(); //Sets the focus in the first element
     	
     	//Setting the default CCY
     	if(event.result.stlCompletionSummaryActionForm.settlementCcy!= null){
     		ccyBox.ccyText.text  = event.result.stlCompletionSummaryActionForm.settlementCcy;
     	}else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.summary.defaultcurrency.cannotbe.initialized'));
        }
     	initCompFlg = true;
     }	
	/**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {        
        //var title:String = this.parentApplication.xResourceManager.getKeyValue('stl.compl.summary') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.query');
        //if(title!= null)
        //    this.parentDocument.title = title;
     } 
     
       /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateOurContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            var settleActTypeArray:Array = new Array(2);
                settleActTypeArray[0]="S";
                settleActTypeArray[1]="B";
                //passing counter party type                
            var cpTypeArray:Array = new Array(2);
                cpTypeArray[0]="BROKER";
                cpTypeArray[1]="BANK/CUSTODIAN";
                
            myContextList.addItem(new HiddenObject("settleActType",settleActTypeArray));
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            return myContextList;
        }
        /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateCpContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            var cpTypeArray:Array = new Array(2);
                cpTypeArray[0]="BROKER";
                cpTypeArray[1]="BANK/CUSTODIAN";
                
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var cpTradActType:Array = new Array(3);
            cpTradActType[0]="T";
            cpTradActType[1]="S";
            cpTradActType[2]="B";
            myContextList.addItem(new HiddenObject("cpTradActType",cpTradActType));
            return myContextList;
        }
        /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void {         
        
        initCompFlg = false;
        initPageStart();
    }
    /**
    * It sends/submits the query after validating the user input data. 
    * 
    */
     private function submitQuery():void 
     { 
     	//Set the request parameters
         var requestObj :Object = populateRequestParams();
         
         completionQueryRequest.request = requestObj;
         
         var myModel:Object={
         						completion:{
         							ccy:this.ccyBox.ccyText.text,
         							ourAccNo : this.ourActPopUp.accountNo.text
         						}
         					};
         
         var validator :CompletionSummaryValidator = new CompletionSummaryValidator();
         validator.source = myModel;
         validator.property = "completion";
         var validationResult:ValidationResultEvent = validator.validate();
		
		if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
                       
        }else {
        	 completionQueryRequest.send();
        }
     }
     /**
    * This method will populate the request parameters for the
    * doQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	reqObj.method = "doQuery";
    	reqObj.SCREEN_KEY = 621;
    	reqObj.firmBankAccount = this.ourActPopUp.accountNo.text;
    	reqObj.securityCode = this.instPopUp.instrumentId.text;
    	reqObj.settlementCcy = this.ccyBox.ccyText.text;
    	reqObj.accountNo = this.cpActPopUp.accountNo.text;
    	reqObj.rnd = Math.random() + "";
    	
    	return reqObj;
    }
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on teh top panel of the
    * result .
    */
     private function loadSummaryPage(event:ResultEvent):void {
     	
     	var rs:XML = XML(event.result);

		if (null != event) {
			if(rs.child("row").length()>0) {
				errPage.clearError(event);
				summaryResult.removeAll();
				try {
					for each ( var rec:XML in rs.row ) {
						summaryResult.addItem(rec);
					}
					
					brokerCode = rs.brokerCode;
                
                	if(brokerCode == null)
                		brokerCode = "";
                
                	firmBankAccount = rs.firmBankAccount;
                	firmBankCode = rs.firmBankCode;
               	 	appDate = rs.appDate;
					
					changeCurrentState();
                    pdf.enabled = true;
                    xls.enabled = true;
					
					//replace null objects in datagrid with empty string
					summaryResult=ProcessResultUtil.process(summaryResult, 
					                                        adg.columns);
					                                      
				} catch(e:Error) {
					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				}
			} else if(rs.child("Errors").length()>0) {
				//some error found
				summaryResult.removeAll(); // clear previous data if any as there is no result now.
				brokerCode = notApplicable;
     			firmBankCode = notApplicable;
     			firmBankAccount = notApplicable;
				var errorInfoList : ArrayCollection = new ArrayCollection();
				//populate the error info list 			 	
				for each ( var error:XML in rs.Errors.error ) {
					errorInfoList.addItem(error.toString());
				}
				errPage.showError(errorInfoList);//Display the error
				
			} else {
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				summaryResult.removeAll(); // clear previous data if any as there is no result now.
				errPage.clearError(event); //clears the error if any
				brokerCode = notApplicable;
     			firmBankCode = notApplicable;
     			firmBankAccount = notApplicable;
			}
		} else {
			summaryResult.removeAll();
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}
     }
     
     /**
   	  * This will generate the Pdf report for the entire query result set 
      * and will open in a separate window.
      */
     private function pdfFunction():void {
     	var url : String = "stl/stlCompletionSummaryDispatch.action?method=generatePDF&pageId=info";
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
      * This will generate the Xls report for the entire query result set 
      * and will open in a separate window.
      */
     private function xlsFunction():void {
     	var url : String = "stl/stlCompletionSummaryDispatch.action?method=generateXLS&pageId=info";
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