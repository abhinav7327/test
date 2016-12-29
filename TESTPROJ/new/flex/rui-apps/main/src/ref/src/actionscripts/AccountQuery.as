
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
 import com.nri.rui.ref.validators.AccountQueryValidator;
 
 import flash.net.URLRequest;
 import flash.net.URLRequestMethod;
 
 import mx.collections.ArrayCollection;
 import mx.controls.dataGridClasses.DataGridColumn;
 import mx.events.ValidationResultEvent;
 import mx.rpc.events.ResultEvent;
 
 

    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    private var finInst:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var returnFinContext:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var returnEmpContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    private var queryResult:Object= new Object();
    [Bindable]
    private var finContextList:ArrayCollection = new ArrayCollection();
    [Bindable]
    //private var accContextList:ArrayCollection = populateContext();   
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    
    private var  csd:CustomizeSortOrder=null;
    
    [Bindable]
    public var mode : String = "query";
    
    public var iMEntry :String = "";
    
    private var screenType:String="";
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = accountSummary;      
    }
    
    
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    * This will fetch data to fill the initial form data to show the user.
    */
     private function initPageStart():void {
     	parseUrlString();
        if (!initCompFlg) {
			if (mode=="copy" || mode=="amend" || mode=="reopen") {
            	acctStatusLbl.includeInLayout=false;
            	acctStatusLbl.visible=false;
            	acctStatusFld.includeInLayout=false;
            	acctStatusFld.visible=false;
            }else {
            	acctStatusLbl.includeInLayout=true;
            	acctStatusLbl.visible=true;
            	acctStatusFld.includeInLayout=true;
            	acctStatusFld.visible=true;
            }
            rndNo= Math.random();
            var req : Object = new Object();
           
           	if (mode=="copy") {
            	req.SCREEN_KEY = 924;
            }else{
            	req.SCREEN_KEY = 61;
            }
            initAccountQuery.request = req;
            
		   	if (mode=="query" ) {      
		    	initAccountQuery.url = "ref/accountQueryDispatch.action?method=initialExecute&mode=query&rnd=" + rndNo;
		    } else if (mode=="amend") {
		    	initAccountQuery.url = "ref/accountAmendQueryDispatch.action?method=initialExecute&mode=amendment&reopenFlag=false&rnd=" + rndNo;
		    } else if (mode=="reopen") {
		    	initAccountQuery.url = "ref/accountReopenQueryDispatch.action?method=initialExecute&mode=reopen&reopenFlag=true&rnd=" + rndNo;
		    } else if( mode=="copy"){
		      	if(!XenosStringUtils.isBlank(screenType) && screenType=="imEntry"){
		      		initAccountQuery.url = "ref/accountIMEntryQueryDispatch.action?method=doImEntry&mode=copy&rnd=" + rndNo;	    		
		    	}else{
		    		initAccountQuery.url = "ref/accountCopyQueryDispatch.action?method=initialExecute&mode=copy&rnd=" + rndNo;	
		    	}	  
		      		
		      		  		
		    }else {
		    	initAccountQuery.url = "ref/accountCloseQueryDispatch.action?method=initialExecute&mode=close&rnd=" + rndNo;
		    }
		    initAccountQuery.send();            
        } else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.alreadyinitiated'));
        }
        
		if (this.mode == 'query') {
   			this.dispatchEvent(new Event('queryInit'));
  		} else if(this.mode == 'amend' || 'reopen') {
   			this.dispatchEvent(new Event('amendInit'));
   			addColumn();
  		} else if(this.mode == 'cancel') {
			this.dispatchEvent(new Event('cancelInit'));
   			addColumn();
  		}        
     }
     
	private function addColumn():void
	{
		//Add a object 
		var dg :DataGridColumn = new DataGridColumn();
		dg.dataField="";
		dg.editable = false;
		dg.headerText = "";
		dg.width = 40;
		dg.resizable = false;
		dg.itemRenderer = new RendererFectory(ImgSummaryRenderer);
		
		var cols :Array = accountSummary.columns;
		cols.unshift(dg);
		accountSummary.columns = cols;
		
	}    
     
    /**
     * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
     */ 
    private function parseUrlString():void {
        try {
            var myPattern:RegExp = /.*\?/; 
            var s:String = this.loaderInfo.url.toString();
            trace("this.loaderInfo.url.toString() :: " + s);
            s = s.replace(myPattern, "");
            var params:Array = s.split(Globals.AND_SIGN); 
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
            trace("params :: " + params);
          
            if(params != null) {
                for (var i:int = 0; i < params.length; i++) {
                    var tempA:Array = params[i].split("=");  
                    if (tempA[0] == "mode") {
                        mode = tempA[1];
                    } else if (tempA[0] == "imEntry") {
                        this.iMEntry = tempA[1];
                    }else if (tempA[0] == "screenType") {
                        this.screenType = tempA[1];
                    }
                }                    	
            } else {
            	mode = "query";
            }                 

        } catch (e:Error) {
            trace(e);
        }               
    }
    
     public function getIMEntry():String{
    	return iMEntry;
    }
     
    /**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {

     }     
    
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * Once initial data is fetched from database to fill some form data, this method works
    * to actually show the data.
    */   
     private function initPage(event: ResultEvent) : void {
        
        var i:int = 0;
        var dateStr:String = null;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection;
        var selIndx:int = 0;
        var bankAccTypeInitColl: ArrayCollection = null;
        var bakAccTypeColl:ArrayCollection=new ArrayCollection();
        
        //variables to hold the default values from the server
        var sortField1Default:String = "ACCOUNT_NO";
        var sortField2Default:String = "OFFICE_ID";
        var sortField3Default:String = "STATUS";
        
        errPage.clearError(event); //clears the errors if any 
        
        // Reseting values of form.
        this.resetFormValues();
        
        ///
        
        if(counterpartyCodeBox.getChildByName("Broker")){
                    finInst.finInstCode.text = "";
                    counterpartyCodeBox.removeChild(finInst);
            }
            
            // Popultate Im Entry
         if(event.result.accountQueryActionForm.imEntry != null){
            iMEntry = event.result.accountQueryActionForm.imEntry;
	           	if(iMEntry=="true")
	          	  counterPartyCode.enabled=false;
			    else
			    counterPartyCode.enabled=true;
          }
          
        //1. Setting values of the Office Id
        initColl.removeAll();
        
        if(event.result.accountQueryActionForm.srvOfficeListColl.serviceOfficeList != null) {
            
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.accountQueryActionForm.srvOfficeListColl.serviceOfficeList is ArrayCollection)
                initColl = event.result.accountQueryActionForm.srvOfficeListColl.serviceOfficeList as ArrayCollection;
            else
                initColl.addItem(event.result.accountQueryActionForm.srvOfficeListColl.serviceOfficeList);
                
            for(i = 0; i<initColl.length; i++) {
                
               //XenosAlert.info(initColl[i].value);
               tempColl.addItem(initColl[i]);
            }
            
            officeIdList.dataProvider = tempColl;
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.officeidlist'));
        }
        
        //2. Setting values of the CounterParty-Code
        initColl.removeAll();
        if(event.result.accountQueryActionForm.cpDetailTypeList.item != null) {
            
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.accountQueryActionForm.cpDetailTypeList.item is ArrayCollection)
                initColl = event.result.accountQueryActionForm.cpDetailTypeList.item as ArrayCollection;
            else
                initColl.addItem(event.result.accountQueryActionForm.cpDetailTypeList.item);
                
            for(i = 0; i<initColl.length; i++) {
                
               //XenosAlert.info(initColl[i].value);
               tempColl.addItem(initColl[i]);            
            }
            counterPartyCode.dataProvider = tempColl;
            //for IMEntry get the index of Fund Counter Party type value from list of values
            if(mode=="copy" && screenType=="imEntry"){
            	for(var i:int =0;i<tempColl.length;i++){
            		if(tempColl.getItemAt(i).value.toString()==event.result.accountQueryActionForm.counterPartyDetailType.toString()){
            			counterPartyCode.selectedIndex=i;
            			break;
            		}
            	}
            }
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.counterpartycodelist'));
        }
        
        
        //3. Setting values of the Sales Role
        /* initColl.removeAll();
        if(event.result.accountQueryActionForm.salesRoleListColl.salesRoleList != null){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.accountQueryActionForm.salesRoleListColl.salesRoleList is ArrayCollection)
                initColl = event.result.accountQueryActionForm.salesRoleListColl.salesRoleList as ArrayCollection;
            else
                initColl.addItem(event.result.accountQueryActionForm.salesRoleListColl.salesRoleList);
                
            for(i = 0; i<initColl.length; i++) {
                
               //XenosAlert.info(initColl[i].value);
               tempColl.addItem(initColl[i]);            
            }
            salesRole.dataProvider = tempColl;
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.salesrolelist'));
        } */
        
        
        //4. Setting values of the Account Type
        initColl.removeAll();
        if(event.result.accountQueryActionForm.accntTypeList.item != null){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.accountQueryActionForm.accntTypeList.item is ArrayCollection)
                initColl = event.result.accountQueryActionForm.accntTypeList.item as ArrayCollection;
            else
                initColl.addItem(event.result.accountQueryActionForm.accntTypeList.item);
                
            for(i = 0; i<initColl.length; i++) {
                
               //XenosAlert.info(initColl[i].value);
               tempColl.addItem(initColl[i]);            
            }
            accountType.dataProvider = tempColl;
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.acctypelist'));
        }
        
        //Populating  the Bank Account type drop down list
        initColl.removeAll();
         if(event.result.accountQueryActionForm.bankAccountTypeList.item != null){
            if(event.result.accountQueryActionForm.bankAccountTypeList.item is ArrayCollection)
                initColl = event.result.accountQueryActionForm.bankAccountTypeList.item as ArrayCollection;
            else
                initColl.addItem(event.result.accountQueryActionForm.bankAccountTypeList.item);
         
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
         
            for(i = 0; i<initColl.length; i++) {
                
               //XenosAlert.info(initColl[i].value);
               tempColl.addItem(initColl[i]);            
            }
            bankAccTypeList.dataProvider = tempColl;
         } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.bankacctypelist'));
        }
        
        //Setting values of the Tax/Fee Inclusion
            initColl.removeAll();
            if(event.result.accountQueryActionForm.taxFeeInclusionList.item != null) {
                
                tempColl = new ArrayCollection();
                tempColl.addItem({label:" ", value: " "});
                selIndx = 0;
            
                if(event.result.accountQueryActionForm.taxFeeInclusionList.item is ArrayCollection)
                    initColl = event.result.accountQueryActionForm.taxFeeInclusionList.item as ArrayCollection;
                else
                    initColl.addItem(event.result.accountQueryActionForm.taxFeeInclusionList.item);
                    
                for(i = 0; i<initColl.length; i++) {
                    
                   //XenosAlert.info(initColl[i].value);
                   tempColl.addItem(initColl[i]);            
                }
                taxFeeInclusionList.dataProvider = tempColl;
            } else {
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.taxfeeinclusion'));
            }
        
        
        //5. Setting values of the Account Status
        initColl.removeAll();
        if(event.result.accountQueryActionForm.accntStatusList.item != null){
            
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.accountQueryActionForm.accntStatusList.item is ArrayCollection)
                initColl = event.result.accountQueryActionForm.accntStatusList.item as ArrayCollection;
            else
                initColl.addItem(event.result.accountQueryActionForm.accntStatusList.item);
                
            for(i = 0; i<initColl.length; i++) {
                
               //XenosAlert.info(initColl[i].value);
               tempColl.addItem(initColl[i]);            
            }
            accountStatus.dataProvider = tempColl;
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.accstatuslist'));
        }
        //Setting values of the ICON Required
            initColl.removeAll();
            if(event.result.accountQueryActionForm.iconRequiredList.item != null) {
                
                tempColl = new ArrayCollection();
                tempColl.addItem({label:" ", value: " "});
                selIndx = 0;
            
                if(event.result.accountQueryActionForm.iconRequiredList.item is ArrayCollection)
                    initColl = event.result.accountQueryActionForm.iconRequiredList.item as ArrayCollection;
                else
                    initColl.addItem(event.result.accountQueryActionForm.iconRequiredList.item);
                    
                for(i = 0; i<initColl.length; i++) {
                    
                   //XenosAlert.info(initColl[i].value);
                   tempColl.addItem(initColl[i]);            
                }
                iconRequiredList.dataProvider = tempColl;
            } else {
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.iconreqd'));
            }
        //Setting values of the GEMS Required
        initColl.removeAll();
        if(event.result.accountQueryActionForm.gemsRequiredList.item != null) {
            
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.accountQueryActionForm.gemsRequiredList.item is ArrayCollection)
                initColl = event.result.accountQueryActionForm.gemsRequiredList.item as ArrayCollection;
            else
                initColl.addItem(event.result.accountQueryActionForm.gemsRequiredList.item);
                
            for(i = 0; i<initColl.length; i++) {
                
               //XenosAlert.info(initColl[i].value);
               tempColl.addItem(initColl[i]);            
            }
            gemsRequiredList.dataProvider = tempColl;
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.gemsreqd'));
        }
        
        //Setting values of the INT1 Required
        /*
        initColl.removeAll();
        if(event.result.accountQueryActionForm.int1RequiredList.item != null) {
            
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.accountQueryActionForm.int1RequiredList.item is ArrayCollection)
                initColl = event.result.accountQueryActionForm.int1RequiredList.item as ArrayCollection;
            else
                initColl.addItem(event.result.accountQueryActionForm.int1RequiredList.item);
                
            for(i = 0; i<initColl.length; i++) {
                
               //XenosAlert.info(initColl[i].value);
               tempColl.addItem(initColl[i]);            
            }
            int1RequiredList.dataProvider = tempColl;
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.int1reqd'));
        }
        */
        
        //Setting values of the FormA Required
        initColl.removeAll();
        if(event.result.accountQueryActionForm.formaRequiredList.item != null) {
            
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.accountQueryActionForm.formaRequiredList.item is ArrayCollection)
                initColl = event.result.accountQueryActionForm.formaRequiredList.item as ArrayCollection;
            else
                initColl.addItem(event.result.accountQueryActionForm.formaRequiredList.item);
                
            for(i = 0; i<initColl.length; i++) {
                
               //XenosAlert.info(initColl[i].value);
               tempColl.addItem(initColl[i]);            
            }
            formaRequiredList.dataProvider = tempColl;
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.formareqd'));
        }
        
        //Setting values of the Thinkfolio Required
        initColl.removeAll();
        if(event.result.accountQueryActionForm.tfRequiredList.item != null) {
            
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.accountQueryActionForm.tfRequiredList.item is ArrayCollection){
                initColl = event.result.accountQueryActionForm.tfRequiredList.item as ArrayCollection;
            }else{
                initColl.addItem(event.result.accountQueryActionForm.tfRequiredList.item);
            }
            for(i = 0; i<initColl.length; i++) {
               tempColl.addItem(initColl[i]);            
            }
            tfRequiredList.dataProvider = tempColl;
        } else {
            XenosAlert.error("Thinkfolio Required is not Populated");
        }
        
        //Setting values of the FBP IF Required
        initColl.removeAll();
        if(event.result.accountQueryActionForm.fbpifRequiredList.item != null) {
            
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.accountQueryActionForm.fbpifRequiredList.item is ArrayCollection){
                initColl = event.result.accountQueryActionForm.fbpifRequiredList.item as ArrayCollection;
            }else{
                initColl.addItem(event.result.accountQueryActionForm.fbpifRequiredList.item);
            }
            for(i = 0; i<initColl.length; i++) {
               tempColl.addItem(initColl[i]);            
            }
            fbpifrequiredList.dataProvider = tempColl;
        } else {
            XenosAlert.error("FBP IF Required is not Populated");
        }
        
         //Setting values of the RTFP Required
         /*
        initColl.removeAll();
        if(event.result.accountQueryActionForm.rtfpRequiredList.item != null) {
            
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.accountQueryActionForm.rtfpRequiredList.item is ArrayCollection)
                initColl = event.result.accountQueryActionForm.rtfpRequiredList.item as ArrayCollection;
            else
                initColl.addItem(event.result.accountQueryActionForm.rtfpRequiredList.item);
                
            for(i = 0; i<initColl.length; i++) {
                
               //XenosAlert.info(initColl[i].value);
               tempColl.addItem(initColl[i]);            
            }
            rtfpRequiredList.dataProvider = tempColl;
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.formareqd'));
        }
        */
        
         //Setting values of the Forma Recreated Allowed 
        initColl.removeAll();
        if(event.result.accountQueryActionForm.formaRecreatedAllowedList.item != null) {
            
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.accountQueryActionForm.formaRecreatedAllowedList.item is ArrayCollection)
                initColl = event.result.accountQueryActionForm.formaRecreatedAllowedList.item as ArrayCollection;
            else
                initColl.addItem(event.result.accountQueryActionForm.formaRecreatedAllowedList.item);
                
            for(i = 0; i<initColl.length; i++) {
                
               //XenosAlert.info(initColl[i].value);
               tempColl.addItem(initColl[i]);            
            }
            formaRecreatedAllowedList.dataProvider = tempColl;
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.formareqd'));
        }
        
        //6. Setting values of the SortField1
        initColl.removeAll();
        if(null != event.result.accountQueryActionForm.sortFieldList1.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.accountQueryActionForm.sortFieldList1.item is ArrayCollection)
                initColl = event.result.accountQueryActionForm.sortFieldList1.item as ArrayCollection;
            else
                initColl.addItem(event.result.accountQueryActionForm.sortFieldList1.item);
            
            for(i = 0; i<initColl.length; i++) {
                
               //XenosAlert.info(initColl[i].value);
               if(XenosStringUtils.equals((initColl[i].value),sortField1Default)){                    
                    selIndx = i;
                }
               tempColl.addItem(initColl[i]);            
            }
            //sortField1.dataProvider = tempColl;
            sortFieldArray[0]=sortField1;
            sortFieldDataSet[0]=tempColl;
            //Set the default value object
            sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.sortfieldlist', new Array("1")));
        }
        
        
        //7. Setting values of the SortField2
        initColl.removeAll();
        if(null != event.result.accountQueryActionForm.sortFieldList2.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.accountQueryActionForm.sortFieldList2.item is ArrayCollection)
                initColl = event.result.accountQueryActionForm.sortFieldList2.item as ArrayCollection;
            else
                initColl.addItem(event.result.accountQueryActionForm.sortFieldList2.item);
                
            for(i = 0; i<initColl.length; i++) {
               //XenosAlert.info(initColl[i].value);
               if(XenosStringUtils.equals((initColl[i].value),sortField2Default)){                    
                    selIndx = i;
                }
               tempColl.addItem(initColl[i]);            
            }
            //sortField2.dataProvider = tempColl;
            sortFieldArray[1]=sortField2;
            sortFieldDataSet[1]=tempColl;
            //Set the default value object
            sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.sortfieldlist', new Array("2")));
        }
        
        
        //8. Setting values of the SortField3
        initColl.removeAll();
        if(null != event.result.accountQueryActionForm.sortFieldList3.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.accountQueryActionForm.sortFieldList3.item is ArrayCollection)
                initColl = event.result.accountQueryActionForm.sortFieldList3.item as ArrayCollection;
            else
                initColl.addItem(event.result.accountQueryActionForm.sortFieldList3.item);
                
            for(i = 0; i<initColl.length; i++) {
               //XenosAlert.info(initColl[i].value);
               if(XenosStringUtils.equals((initColl[i].value),sortField3Default)){                    
                    selIndx = i;
                }
               tempColl.addItem(initColl[i]);            
            }
            //sortField3.dataProvider = tempColl;
            sortFieldArray[2]=sortField3;
            sortFieldDataSet[2]=tempColl;
            //Set the default value object
            sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.sortfieldlist', new Array("3")));
        }
        
        
        //Setting values of the Long/Short Flag
            initColl.removeAll();
            if(event.result.accountQueryActionForm.longShortFlagList.item != null) {
                
                tempColl = new ArrayCollection();
                tempColl.addItem({label:" ", value: " "});
                selIndx = 0;
            
                if(event.result.accountQueryActionForm.longShortFlagList.item is ArrayCollection)
                    initColl = event.result.accountQueryActionForm.longShortFlagList.item as ArrayCollection;
                else
                    initColl.addItem(event.result.accountQueryActionForm.longShortFlagList.item);
                    
                for(i = 0; i<initColl.length; i++) {
                   tempColl.addItem(initColl[i]);            
                }
                longShortFlagList.dataProvider = tempColl;
            } else {
                XenosAlert.error("Long/Short Flag is not Populated");
            }
            
        //Setting values of the STL Instruction Output Format
            initColl.removeAll();
            if(event.result.accountQueryActionForm.stlInxOutputFormatList.item != null) {
                
                tempColl = new ArrayCollection();
                tempColl.addItem({label:" ", value: " "});
                selIndx = 0;
            
                if(event.result.accountQueryActionForm.stlInxOutputFormatList.item is ArrayCollection)
                    initColl = event.result.accountQueryActionForm.stlInxOutputFormatList.item as ArrayCollection;
                else
                    initColl.addItem(event.result.accountQueryActionForm.stlInxOutputFormatList.item);
                    
                for(i = 0; i<initColl.length; i++) {
                   tempColl.addItem(initColl[i]);            
                }
                stlInxOutputFormatList.dataProvider = tempColl;
            } else {
                XenosAlert.error("STL Instruction Output Format is not Populated");
            }
            
        
        //Setting values of the Short Sell Flag List
            initColl.removeAll();
            if(event.result.accountQueryActionForm.shortSellFlagList.item != null) {
                
                tempColl = new ArrayCollection();
                tempColl.addItem({label:" ", value: " "});
                selIndx = 0;
            
                if(event.result.accountQueryActionForm.shortSellFlagList.item is ArrayCollection)
                    initColl = event.result.accountQueryActionForm.shortSellFlagList.item as ArrayCollection;
                else
                    initColl.addItem(event.result.accountQueryActionForm.shortSellFlagList.item);
                    
                for(i = 0; i<initColl.length; i++) {
                   tempColl.addItem(initColl[i]);            
                }
                shortSellFlagList.dataProvider = tempColl;
            } else {
                XenosAlert.error("Short Sell Flag is not Populated");
            }
        		
        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();
     }
     
     private function sortOrder1Update():void{
         //XenosAlert.info(sortField1.selectedItem.value);
         csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{      
        //XenosAlert.info(sortField2.selectedItem.value);
        csd.update(sortField2.selectedItem,1);
     }
     
  /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on teh top panel of the
    * result.
    */
    private function loadSummaryPage(event:ResultEvent):void {
        
    var rs:XML = XML(event.result);
    
        if (null != event) {
/*         	if(mode=="copy"){
        		iMEntry = rs.imEntry.toString();
        	} */
            if(rs.child("row").length()>0) {
                errPage.clearError(event);
                summaryResult.removeAll();
                try {
                    for each ( var rec:XML in rs.row ) {
                        summaryResult.addItem(rec);
                    }
                    
                    changeCurrentState();
                    qh.setOnResultVisibility();
                    
                    qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
                    qh.PopulateDefaultVisibleColumns();
                    //replace null objects in datagrid with empty string
                    summaryResult=ProcessResultUtil.process(summaryResult,accountSummary.columns);
                    summaryResult.refresh();
                }catch(e:Error){
                    //XenosAlert.error(e.toString() + e.message);
                    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
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
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                summaryResult.removeAll(); // clear previous data if any as there is no result now.
                errPage.removeError(); //clears the errors if any
             }
        
        }
     }
     
     /**
     *  This method resets all the values in the form.
     */
     private function resetFormValues():void {
        
        this.actPopUp.accountNo.text = "";
        this.fundPopUp.fundCode.text = "";
        this.countryPopUp.countryCode.text = "";
        this.accountName.text = "";
        this.officialName.text = "";
        this.accessUserID.employeeText.text = "";
        this.openDateFrom.text = "";
        this.openDateTo.text = "";
        this.openedBy.text = "";
        this.closeDateFrom.text = "";
        this.closeDateTo.text = "";
        this.closedBy.text = "";
     }
     
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        accountSubmitQuery.request = reqObj;
        accountSubmitQuery.send();
     }
     
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        accountSubmitQuery.request = reqObj;
        accountSubmitQuery.send();
     }
     
    /**
    * It sends/submits the query. 
    * 
    */
    private function submitQuery():void 
    {
        //Reset Page No
         qh.resetPageNo();
        //Set the request parameters
        var requestObj :Object = populateRequestParams();
        
        accountSubmitQuery.request = requestObj;
        
        var myModel:Object={
                            accountQuery:{
                                 
                                 officeIdList:this.officeIdList.selectedItem,
                                 //salesRole:this.salesRole.selectedItem,
                                 openDateFrom:this.openDateFrom.text,
                                 openDateTo:this.openDateTo.text,
                                 closeDateFrom:this.closeDateFrom.text,
                                 closeDateTo:this.closeDateTo.text
                            }
                           };
        
        var accountQueryValidator:AccountQueryValidator = new AccountQueryValidator();
        accountQueryValidator.source = myModel;
        accountQueryValidator.property = "accountQuery";
        
        var validationResult:ValidationResultEvent = accountQueryValidator.validate();
        
        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            //trace(errorMsg);
            XenosAlert.error(errorMsg);
        } else {
            qh.resetPageNo();
            /* if(mode=="copy"){
            	accountSubmitQuery.url = "ref/accountCopyQueryDispatch.action"
            } */
            
            if (mode=="query" ) {      
	    		accountSubmitQuery.url = "ref/accountQueryDispatch.action";
		    } else if (mode=="amend") {
		    	accountSubmitQuery.url = "ref/accountAmendQueryDispatch.action";
		    } else if (mode=="reopen") {
		    	accountSubmitQuery.url = "ref/accountReopenQueryDispatch.action";
		    } else if( mode=="copy"){
		      	if(!XenosStringUtils.isBlank(screenType) && screenType=="imEntry"){
		      		accountSubmitQuery.url = "ref/accountIMEntryQueryDispatch.action";	    		
		    	}else{
		    		accountSubmitQuery.url = "ref/accountCopyQueryDispatch.action";	
		    	}	  
		    }else {
		    	accountSubmitQuery.url = "ref/accountCloseQueryDispatch.action";
		    }
            accountSubmitQuery.send();
        }
    }
    
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        
        if (mode=="copy") {
            reqObj.SCREEN_KEY = 925;
        }else{
        	reqObj.SCREEN_KEY = 62;
        }
        reqObj.method = "submitQuery";
        
        reqObj.accountNo = this.actPopUp.accountNo.text;
        reqObj.serviceOffice = (this.officeIdList.selectedItem != null ? this.officeIdList.selectedItem.value : "");
        reqObj.defaultShortName = this.accountName.text;
        reqObj.defaultOfficialName1 = this.officialName.text;
        reqObj.counterPartyDetailType = (this.counterPartyCode.selectedItem != null ? this.counterPartyCode.selectedItem.value : "");
        if(reqObj.counterPartyDetailType=="BROKER"||reqObj.counterPartyDetailType=="BANK/CUSTODIAN")
                reqObj.counterPartyCode = finInst.finInstCode.text;
        else 
                reqObj.counterPartyCode = "";
        reqObj.salesCode = this.accessUserID.employeeText.text;
        //reqObj.salesRole = (this.salesRole.selectedItem != null ? this.salesRole.selectedItem.value : "");
        reqObj.nationality = this.countryPopUp.countryCode.text;
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.bankAccountType = (this.bankAccTypeList.selectedItem!=null) ? this.bankAccTypeList.selectedItem.value : "";
        reqObj.taxFeeInclusion = (this.taxFeeInclusionList.selectedItem!=null) ? this.taxFeeInclusionList.selectedItem.value : "";

        
        reqObj.accountOpenDateFrom = this.openDateFrom.text;
        reqObj.accountOpenDateTo = this.openDateTo.text;
        reqObj.accountOpenBy = this.openedBy.text;
        reqObj.accountClosingDateFrom = this.closeDateFrom.text;
        reqObj.accountClosingDateTo = this.closeDateTo.text;
        reqObj.accountCloseBy = this.closedBy.text;
        reqObj.accountType = (this.accountType.selectedItem != null ? this.accountType.selectedItem.value : "");
//        reqObj.accountStatus = (this.accountStatus.selectedItem != null ? this.accountStatus.selectedItem.value : "");
		if (this.mode == 'amend' || this.mode == "copy" || this.mode == "cancel") {
        	reqObj.accountStatus = "OPEN";
  		} else if(this.mode == 'reopen') {
        	reqObj.accountStatus = "CLOSE";
  		} else {   			
       		 reqObj.accountStatus = (this.accountStatus.selectedItem != null ? this.accountStatus.selectedItem.value : "");
  		}
        
        reqObj.sortField1 = (this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "");
        reqObj.sortField2 = (this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "");
        reqObj.sortField3 = (this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "");
        
        reqObj.iconRequired = (this.iconRequiredList.selectedItem!=null) ? this.iconRequiredList.selectedItem.value : "";
        reqObj.gemsRequired = (this.gemsRequiredList.selectedItem!=null) ? this.gemsRequiredList.selectedItem.value : "";
        //reqObj.int1Required = (this.int1RequiredList.selectedItem!=null) ? this.int1RequiredList.selectedItem.value : "";
        reqObj.formaRequired = (this.formaRequiredList.selectedItem!=null) ? this.formaRequiredList.selectedItem.value : "";
        reqObj.tfRequired 	= (this.tfRequiredList.selectedItem!=null) ? this.tfRequiredList.selectedItem.value : XenosStringUtils.EMPTY_STR;
        reqObj.fbpifRequired	= (this.fbpifrequiredList.selectedItem!=null) ? this.fbpifrequiredList.selectedItem.value : XenosStringUtils.EMPTY_STR;
        //reqObj.rtfpRequired = (this.rtfpRequiredList.selectedItem!=null) ? this.rtfpRequiredList.selectedItem.value : "";
        reqObj.formaRecreatedAllowed = (this.formaRecreatedAllowedList.selectedItem!=null) ? this.formaRecreatedAllowedList.selectedItem.value : "";
        reqObj.shortSellFlag = (this.shortSellFlagList.selectedItem!=null) ? this.shortSellFlagList.selectedItem.value : "";
        reqObj.longShortFlag = (this.longShortFlagList.selectedItem!=null) ? this.longShortFlagList.selectedItem.value : "";
        reqObj.stlInxOutputFormat = (this.stlInxOutputFormatList.selectedItem!=null) ? this.stlInxOutputFormatList.selectedItem.value : "";
        
        
        reqObj.rnd = Math.random() + "";
        return reqObj;
    }
    
    
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    public function resetQuery():void { 
    if (mode=="query" ) { 
    	accountResetQuery.url="ref/accountQueryDispatch.action?method=resetQuery";
    }else if(mode=="copy"){    	
		if(!XenosStringUtils.isBlank(screenType) && screenType=="imEntry"){    
           accountResetQuery.url="ref/accountIMEntryQueryDispatch.action?method=resetQuery";
        }else{
        	accountResetQuery.url="ref/accountCopyQueryDispatch.action?method=resetQuery";
        }
     }else if (mode=="reopen") {
    	accountResetQuery.url = "ref/accountReopenQueryDispatch.action?method=resetQuery";
     }else if(mode==Globals.MODE_AMEND){
     	accountResetQuery.url="ref/accountAmendQueryDispatch.action?method=resetQuery";
     }else{
     	accountResetQuery.url="ref/accountCloseQueryDispatch.action?method=resetQuery";
     }
      accountResetQuery.send();
    }
    /**
    * This is for the Print button which at a  time will print all the data 
    * in the dataprovider of the Datagrid object
    */
     private function doPrint():void{
        
     } 
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
     	
     	var url : String = "";
 		if (mode=="query" ) {      
	    	url = "ref/accountQueryDispatch.action?method=generateXLS";
	    } else if (mode=="amend") {
	    	url = "ref/accountAmendQueryDispatch.action?method=generateXLS";
	    } else if (mode=="reopen") {
	    	url = "ref/accountReopenQueryDispatch.action?method=generateXLS";
	    } else if( mode=="copy"){
	      	if(!XenosStringUtils.isBlank(screenType) && screenType=="imEntry"){
	      		url = "ref/accountIMEntryQueryDispatch.action?method=generateXLS";	    		
	    	}else{
	    		url = "ref/accountCopyQueryDispatch.action?method=generateXLS";	
	    	}	  
	    }else {
	    	url = "ref/accountCloseQueryDispatch.action?method=generateXLS";
	    }
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        // set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
         try {
                navigateToURL(request,"_blank");
         } catch (e:Error) {
                // handle error here
                trace(e);
         }
     }
    /**
    * This will generate the Pdf report for the entire query result set 
    * and will open in a separate window.
    */
     private function generatePdf():void {

        var url : String = "";
        if (mode=="query" ) {      
	    	url = "ref/accountQueryDispatch.action?method=generatePDF";
	    } else if (mode=="amend") {
	    	url = "ref/accountAmendQueryDispatch.action?method=generatePDF";
	    } else if (mode=="reopen") {
	    	url = "ref/accountReopenQueryDispatch.action?method=generatePDF";
	    } else if( mode=="copy"){
	      	if(!XenosStringUtils.isBlank(screenType) && screenType=="imEntry"){
	      		url = "ref/accountIMEntryQueryDispatch.action?method=generatePDF";	    		
	    	}else{
	    		url = "ref/accountCopyQueryDispatch.action?method=generatePDF";	
	    	}	  
	    }else {
	    	url = "ref/accountCloseQueryDispatch.action?method=generatePDF";
	    }
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        // set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
         try {
                navigateToURL(request,"_blank");
         } catch (e:Error) {
                // handle error here
                trace(e);
         }
     }
     
     
     
     private function populateCounterpartyCode():void{
            finInst.percentWidth = 50;
            finInst.name = "Broker";
            if(counterpartyCodeBox.getChildByName("Broker")){
                    finInst.finInstCode.text = "";
                    counterpartyCodeBox.removeChild(finInst);
            }
            switch(counterPartyCode.selectedItem.label){
                case "BROKER"           :
                case "BANK/CUSTODIAN"   :
                                            counterpartyCodeBox.addChild(finInst);
                                            break;
                case "FUND"             :
                default                 :   
            }                                                       
        }