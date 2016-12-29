// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.gle.validators.VoucherEntryValidator;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.events.CloseEvent;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;
import mx.rpc.events.ResultEvent;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;
import mx.utils.StringUtil;

			
	  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
		     //Items returning through context - Non display objects for accountPopup
		    [Bindable]
		    public var returnInvAcContextItem:ArrayCollection = new ArrayCollection();
		    
            [Bindable]private var mode : String = "ENTRY";
                        
            private var keylist:ArrayCollection = new ArrayCollection();
           
            [Bindable]private var journalList:ArrayCollection = new ArrayCollection();
	  		[Bindable]private var editedCountryCode:XML = new XML();
	  		[Bindable]private var totalDebitAmtStr:String = "";
	  		[Bindable]private var totalCreditAmtStr:String = "";
	  		[Bindable]private var resultObj:Object;
	  		[Bindable]private var trialBalanceId:String="";	  		
	  		[Bindable]private var refNoStr:String=""; 		
	  		
	  				   
		    [Bindable]
		    private var backState:Boolean=false;
		    [Bindable]
		    private var uConfSubmitState:Boolean;
		    [Bindable]
		    private var cancelSubmitState:Boolean = false;
		    [Bindable]
		    private var uCancelConfSubmitState:Boolean = false;
		    [Bindable]
		    private var sConfSubmitState:Boolean = false;
	  		
	  private function changeCurrentState():void{				
				vstack.selectedChild = rslt;
	 }
	 
    
			   public function loadAll():void{
			   	
			   	//set header txt align of datagrid to center
			   	var styleName:String = "." + voucherSummary.getStyle("headerStyleName");
                var cssDecl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(styleName);
                cssDecl.setStyle("textAlign", "center");

			   	
           	   parseUrlString();
           	   super.setXenosEntryControl(new XenosEntry());
           	   //XenosAlert.info("mode : "+mode);
           	   if(this.mode == 'ENTRY'){
           	   	 this.dispatchEvent(new Event('entryInit'));
				//hdbox1.selectedChild = this.qry;
           	   	 //this.currentState="entryState";
           	   	 vstack.selectedChild = qry;           	   	 
           	   } else if(this.mode == 'AMEND'){
           	   	 this.dispatchEvent(new Event('amendEntryInit'));
				//hdbox1.selectedChild = this.qry;
           	   	 //this.currentState="entryState";
           	   	 vstack.selectedChild = qry;
           	   } else { 
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
            	super.getInitHttpService().url = "gle/voucherDispatch.action?method=doInit&SCREEN_KEY=287&rnd=" + rndNo;
            }
             
                   
        private function addCommonKeys():void{        	
	    	keylist = new ArrayCollection();
	    	keylist.addItem("dbCrList.item");
	    	keylist.addItem("transactionDate");	 
	    	keylist.addItem("reversalTypeList.item");   	
        }
        
        override public function preEntryResultInit():Object{
        	addCommonKeys(); 
        	return keylist;
        }
        
         
         
        
        /**
        * To add Journal entry
        */
        private function doAddJrnl():void{
        	if(validateJournalEntry()){
	        	addJrnlService.url="gle/voucherDispatch.action?method=doAddJournal";
	        	addJrnlService.request=populateJournal();
	        	addJrnlService.send();
        	}
        }
        
        public function editJrnl(data:Object):void{
        	var reqObj : Object = new Object();
        	editJrnlService.url="gle/voucherDispatch.action?method=doEditJournal";
        	reqObj.rowNo=journalList.getItemIndex(data);
        	editJrnlService.request=reqObj;
        	editJrnlService.send();
        }
        
         public function deleteJrnl(data:Object):void{
        	var reqObj : Object = new Object();
        	reqObj.rowNo = journalList.getItemIndex(data);       	
        	deleteJrnlService.url = "gle/voucherDispatch.action?method=doDeleteJournal";
        	deleteJrnlService.request = reqObj;
        	deleteJrnlService.send();
        }
        
     
        private function doCancelJrnlEdit():void{
        	var reqObj : Object = new Object();        	
        	cancelEditJrnlService.url =  "gle/voucherDispatch.action?method=doCxlEditJournal";        	
        	cancelEditJrnlService.send();
        }
       
        
        /**
	    * This method works as the result handler of the add Http Services.
	    * 
	    */
	    public function journalAddResult(event:ResultEvent):void {
	         var rs:XML = XML(event.result);
	
			if (null != event) {
				 if(rs.child("journalList").length()>0) {
					errPage.clearError(event);
						if(!voucherSummary.visible)
							voucherSummary.visible=true;
		            	journalList.removeAll(); 
					try {
					    for each ( var rec:XML in rs.journalList.item ) {					    	
		 				    journalList.addItem(rec);		 				    
					    }
					    journalList.refresh();
					    totalDebitAmtStr=rs.voucherPage.totalDebitAmountStr;
					    totalCreditAmtStr=rs.voucherPage.totalCreditAmountStr;	
					    
					    //reset input fields
					    this.ledgerCode.gleCode.text="";	    	
	    				this.subledgercode.accountNo.text="";	    				
	    			  	debit_credit.selectedIndex=0;	    			  	
	    				this.amount.text="";
	    				this.chequeno.text="";
	    				this.empHb.employeeText.text="";
	    				this.journalRemarks.text="";
	    				
	    				cxlJrnl.includeInLayout=false;				    
					}catch(e:Error){
					    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				    }
				 } else if(rs.child("Errors").length()>0) {
	                //some error found				 	
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);//Display the error
				 	errPage.setFocus();
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	journalList.removeAll(); // clear previous data if any as there is no result now.
				 	errPage.removeError(); //clears the errors if any
				 }
	        }
	         
	        
	    }
        
        /**
	    * This method works as the result handler of the edit Http Services.
	    * 
	    */
	    public function journalEditResult(event:ResultEvent):void {
	         var rs:XML = XML(event.result);
	
			if (null != event) {
				 if(rs.child("journalList").length()>0) {
					errPage.clearError(event);
					
		            	journalList.removeAll(); 
					try {
					    for each ( var rec:XML in rs.journalList.item ) {					    	
		 				    journalList.addItem(rec);		 				    
					    }
					    journalList.refresh();
					    totalDebitAmtStr=rs.voucherPage.totalDebitAmountStr;
					    totalCreditAmtStr=rs.voucherPage.totalCreditAmountStr;	
					    	
					    this.ledgerCode.gleCode.text=rs.voucherPage.ledgerCode;	    	
	    				this.subledgercode.accountNo.text=rs.voucherPage.subLedgerCode;
	    				var index:int=0;
	    				for each(var obj:Object in (debit_credit.dataProvider as ArrayCollection)){	    					
	    			  		if(String(obj.value)==String(rs.voucherPage.debitCreditFlag)){
	    			  			debit_credit.selectedIndex=index;	    			  			
	    			  			break;
	    			  		}
	    			  		index++;	    			  			
	    			 	}
	    			 	
	    			 	cxlJrnl.includeInLayout=true;
	    			 	
	    				this.amount.text=rs.voucherPage.amountStr;
	    				this.chequeno.text=rs.voucherPage.bankChequeNo;
	    				this.empHb.employeeText.text=rs.voucherPage.staffCode;
	    				this.journalRemarks.text=rs.voucherPage.journalRemarks;
					    			    
					}catch(e:Error){
					    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				    }
				 } else if(rs.child("Errors").length()>0) {
	                //some error found				 	
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);//Display the error
				 	errPage.setFocus();
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	journalList.removeAll(); // clear previous data if any as there is no result now.
				 	errPage.removeError(); //clears the errors if any
				 }
	        }
	        
	    }
        
        private function populateJournal():Object{
        	 var reqObj : Object = new Object();
	    	reqObj['voucherPage.currency']=this.ccyHbox.ccyText.text;
	    	reqObj['transactionDate']=this.date.text;
	    	reqObj['voucherPage.reverse']=(this.reversalType.selectedItem!=null && 
	    						this.reversalType.selectedItem.value!=" ")?this.reversalType.selectedItem.value : "" ;
	    	reqObj['voucherPage.trialBalanceId']=this.trialBalanceIdHb.trialBalanceId.text;
	    	reqObj['voucherPage.extReferenceNo']=this.extRefNo.text;
	    	reqObj['voucherPage.batchFileNo']=this.batchFileNo.text;
	    	reqObj['voucherPage.remarks']=this.remarks.text;
	    	reqObj['voucherPage.inventoryAccountNo']=this.invtActPopUp.accountNo.text;
	    	
	    	/* reqObj['actTypeContext']='T|B';
	    	reqObj['cpTypeContext']='INTERNAL';
	    	reqObj['prefix']=;
	    	reqObj['invCPTypeContext']='BANK/CUSTODIAN';
	    	reqObj['accountStatus']='OPEN'; */
	    	
	    	reqObj['voucherPage.accountNo']=this.actPopUp.accountNo.text;
	    	reqObj['voucherPage.securityId']=this.securityHb.instrumentId.text;
	    	reqObj['voucherPage.projectId']=this.projectId.text;
	    	
	    	reqObj['voucherPage.ledgerCode']=this.ledgerCode.gleCode.text;
	    	//reqObj['prefix']=;
	    	reqObj['voucherPage.subLedgerCode']=this.subledgercode.accountNo.text;
	    	reqObj['voucherPage.debitCreditFlag']=(this.debit_credit.selectedItem!=null && 
	    						this.debit_credit.selectedItem.value!=" ")?this.debit_credit.selectedItem.value : "" ;
	    	reqObj['voucherPage.amountStr']=this.amount.text;
	    	reqObj['voucherPage.bankChequeNo']=this.chequeno.text;
	    	reqObj['voucherPage.staffCode']=this.empHb.employeeText.text;
	    	reqObj['voucherPage.journalRemarks']=this.journalRemarks.text;
	    	
	    	//reqObj['officeId']=;
	    	return reqObj;
        }
        
        private function commonInit(mapObj:Object):void{           	     
	    	errPage.clearError(super.getInitResultEvent());

	    	this.debit_credit.dataProvider=mapObj[keylist.getItemAt(0)];
	    	
	    	this.date.text=mapObj[keylist.getItemAt(1)].toString();
	    	
	    	var tempCollection:ArrayCollection= new ArrayCollection() ;
	    	tempCollection.addItem({label:" ",value:" "});
	    	for each(var obj:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection))
	    		tempCollection.addItem(obj);
	    	this.reversalType.dataProvider=tempCollection;
	    	
	    	//reset all fields
	    	resetEntryPage();
        }
        
        override public function postEntryResultInit(mapObj:Object): void{
        	commonInit(mapObj);
        }
        
        private function commonResultPart(mapObj:Object):void{
        		 backState = true;
        		 uConfSubmitState = true;
        }
        
        private function addCommonResultKeys():void{
        	keylist = new ArrayCollection();
	    	keylist.addItem("voucherPage.currency");
	    	keylist.addItem("voucherPage.batchFileNo");
	    	keylist.addItem("voucherPage.extReferenceNo");
	    	keylist.addItem("voucherPage.projectId");
	    	keylist.addItem("voucherPage.remarks");
	    	keylist.addItem("voucherPage.reverse");
	    	keylist.addItem("voucherPage.securityId");
	    	keylist.addItem("voucherPage.inventoryAccountNo");
	    	keylist.addItem("voucherPage.accountNo");
	    	keylist.addItem("voucherPage.trialBalanceId");
	    	keylist.addItem("transactionDate"); 
	    	keylist.addItem("voucherPage.securityName");
	    	keylist.addItem("voucherPage.inventoryAccountName");
	    	keylist.addItem("voucherPage.accountName"); 	
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
		    	 //set resultObj
		    	 resultObj=mapObj;	
		    	 trialBalanceId=resultObj['voucherPage.trialBalanceId'].toString();		    			
	             commonResultPart(mapObj);
				 changeCurrentState();
		    		
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    	}    		
	    	}
        } 
        
       
        
    	 private function setValidator():void{
		
		    var validateModel:Object={
                            voucherEntry:{
                                 
                                 ccy:this.ccyHbox.ccyText.text,
                                 date:this.date.text,
                                 accountNo:this.actPopUp.accountNo.text,
                                 invAccountNo:this.invtActPopUp.accountNo.text,
                                 trialBalanceId:this.trialBalanceIdHb.trialBalanceId.text
                                        
                            }
                           }; 
	         super._validator = new VoucherEntryValidator();
	         super._validator.source = validateModel ;
	         super._validator.property = "voucherEntry";  
		} 
		  override public function preEntry():void{
		 	setValidator();		 	
		 	super.getSaveHttpService().url = "gle/voucherDispatch.action?method=doEntryConfirm";  
            super.getSaveHttpService().request  =populateRequestParams();
            super.getSaveHttpService().method="POST";
		 } 
		 
		 
		 override public function preEntryResultHandler():Object
		{
			 addCommonResultKeys();
			 return keylist;
		}
		
		
		
		override public function postEntryResultHandler(mapObj:Object):void
		{
			commonResult(mapObj);
		}
		
		
		
		override public function preEntryConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "gle/voucherDispatch.action?";  
			reqObj.method= "doProcessEntry";
			reqObj['SCREEN_KEY']=288;
			reqObj.rnd = Math.random();
            super.getConfHttpService().request  =reqObj;
		}
		
		
		
		override public function preEntryConfirmResultHandler():Object
		{
			keylist=new ArrayCollection();
			keylist.addItem("refNo");
			return keylist;
		}
		
		override public function postConfirmEntryResultHandler(mapObj:Object):void
		{
			submitUserConfResult(mapObj);
		}
		
		
		
		private function submitUserConfResult(mapObj:Object):Boolean{    	
    	if(mapObj!=null){
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		errPage1.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    		if(mode!="CANCEL")
	    		  errPage.clearError(super.getConfResultEvent());
	    	   errPage1.clearError(super.getConfResultEvent());
	    	   refNoStr=mapObj['refNo'].toString();
	    	   backState = false;
			   uConfSubmit.enabled = true;	
               uConfLabel.includeInLayout = false;
               uConfLabel.visible = false;
               uConfSubmitState = false;
               sConfLabel.includeInLayout = true;
               sConfLabel.visible = true;
               sConfSubmitState = true;         
	    	   return true;
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
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
    	reqObj['SCREEN_KEY']=287;
    	reqObj['voucherPage.currency']=this.ccyHbox.ccyText.text;
		reqObj['transactionDate']=this.date.text;
		reqObj['voucherPage.reverse']=(this.reversalType.selectedItem!=null && 
							this.reversalType.selectedItem.value!=" ")?this.reversalType.selectedItem.value : "" ;
		reqObj['voucherPage.trialBalanceId']=this.trialBalanceIdHb.trialBalanceId.text;
		reqObj['voucherPage.extReferenceNo']=this.extRefNo.text;
		reqObj['voucherPage.batchFileNo']=this.batchFileNo.text;
		reqObj['voucherPage.remarks']=this.remarks.text;
		reqObj['voucherPage.inventoryAccountNo']=this.invtActPopUp.accountNo.text;		
		/* reqObj['actTypeContext']='T|B';
		reqObj['cpTypeContext']='INTERNAL';
		reqObj['prefix']=;
		reqObj['invCPTypeContext']='BANK/CUSTODIAN';
		reqObj['accountStatus']='OPEN'; */		
		reqObj['voucherPage.accountNo']=this.actPopUp.accountNo.text;
		reqObj['voucherPage.securityId']=this.securityHb.instrumentId.text;
		reqObj['voucherPage.projectId']=this.projectId.text;
		  	
    	var random:Number=Math.random();
    	reqObj.rnd=random;

    	return reqObj;
    }
    
   override public function preResetEntry():void
   {
   	       var rndNo:Number= Math.random();
   	       //super.getResetHttpService().url = "gle/voucherDispatch.action?method=doInit&rnd=" + rndNo;
   	       var httpService : XenosHTTPService = super.getResetHttpService();
		   httpService.url = "gle/voucherDispatch.action?method=doInit&rnd=" + rndNo;
   	       httpService.addEventListener(ResultEvent.RESULT ,
		   function (resultEvent : ResultEvent) : void {			
				 if(resultEvent.result != null) {
				 	 var rs:XML = XML(resultEvent.result);	
				 	 if(rs.child("pageSummary") != null && rs.child("pageSummary").child("status") != null) {
				 	  	if(XenosStringUtils.equals(StringUtil.trim(rs.child("pageSummary").child("status")),'Y')){
							var errorInfoList : ArrayCollection = new ArrayCollection();
							errorInfoList.addItem(rs.child("Errors").child("error"));					
							errPage.showError(errorInfoList);//Display the error
				 			errPage.setFocus();
						 }						 
				 	 }
				 } 			 
			 });
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
           	 vstack.selectedChild = qry;	
			 super.postEntrySystemConfirm();		
	} 
	
	  
	  private function doBack():void{
			 vstack.selectedChild = qry;
			 trialBalanceIdHb.trialBalanceId.text=trialBalanceId;	        
	  }  		
		private function doSubmit():void
  		{
  	
 	
		  	if(this.mode == 'ENTRY'){
		  		this.dispatchEvent(new Event('entrySave'));
		  	}
		  	else{
		  	  this.dispatchEvent(new Event('amendEntrySave'));
		  	}
	  	}
  		
  
  
  
  		/**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specific  
          * requirement. 
          */
        private function populateInvAcContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            var settleActTypeArray:Array = new Array(2);
                settleActTypeArray[0]="T";
                settleActTypeArray[1]="B";               
            myContextList.addItem(new HiddenObject("actTypeContext",settleActTypeArray));
        
        	var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="INTERNAL";
               
            myContextList.addItem(new HiddenObject("cpTypeContext",cpTypeArray));
            
            return myContextList;
        }
		private function populateAcContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            var actStatusArray:Array = new Array(1);
                actStatusArray[0]="OPEN";                             
            myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
        
        	var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="BANK/CUSTODIAN";
               
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
            
            return myContextList;
        }
        
        private function populateSubLedgerContext():ArrayCollection {
            //pass the context data to the popup
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            var settleActTypeArray:Array = new Array(2);
                settleActTypeArray[0]="T";
                settleActTypeArray[1]="B";               
            myContextList.addItem(new HiddenObject("actTypeContext",settleActTypeArray));
            
            return myContextList;
        }
        
        private function resetEntryPage():void{
        	
        	//reset input fields
        	this.ccyHbox.ccyText.text="";
        	this.reversalType.selectedIndex=0;
        	this.trialBalanceIdHb.trialBalanceId.text="";
        	this.extRefNo.text="";
        	this.batchFileNo.text="";
        	this.remarks.text="";
        	this.invtActPopUp.accountNo.text="";
        	this.actPopUp.accountNo.text="";        	
        	this.securityHb.instrumentId.text="";
        	this.projectId.text="";
        	this.journalList=new ArrayCollection();
        	this.totalDebitAmtStr="0";
        	this.totalCreditAmtStr="0";
        	
        	
        	//reset journal details
		    this.ledgerCode.gleCode.text="";	    	
			this.subledgercode.accountNo.text="";	    				
		  	debit_credit.selectedIndex=0;	    			  	
			this.amount.text="";
			this.chequeno.text="";
			this.empHb.employeeText.text="";
			this.journalRemarks.text="";
        }
        
        private function validateJournalEntry():Boolean{
        	var errMsg:String="";
        	var ccyStr:String=StringUtil.trim(this.ccyHbox.ccyText.text);
        	var legderCode:String=StringUtil.trim(this.ledgerCode.gleCode.text);
        	var legderAmt:String=StringUtil.trim(this.amount.text);
        	if(XenosStringUtils.isBlank(ccyStr))
        		errMsg+="Please Enter Currency Code.\n";      	
        	if(XenosStringUtils.isBlank(legderCode))
        		errMsg+="Please Enter Ledger Code.\n";
        	if(XenosStringUtils.isBlank(legderAmt))
        		errMsg+="Please Enter Amount.";
        	
        	
        	if(!XenosStringUtils.isBlank(errMsg)){
        		XenosAlert.error(errMsg);
        		return false;
        	}
        	else
        		return true;
        }
        
        private function setHeaderStyle():void{
        	//set header txt align of datagrid to center
		   	var styleName:String = "." + voucherSummaryConf.getStyle("headerStyleName");
            var cssDecl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(styleName);
            cssDecl.setStyle("textAlign", "center");
        }