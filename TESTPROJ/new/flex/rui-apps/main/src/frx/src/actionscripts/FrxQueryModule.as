// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.frx.validators.FrxTrdQueryValidator;

import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.UIComponent;
import mx.managers.PopUpManager;
import mx.utils.StringUtil;
			
	  //private var mkt:XenosQuery = new MarketPriceQuery();
	  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
	private var queryResult:ArrayCollection= new ArrayCollection();
	[Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
	 
	private var keylist:ArrayCollection = new ArrayCollection(); 
	private var sortFieldArray:Array =new Array();
	private var sortFieldDataSet:Array =new Array();
	private var sortFieldSelectedItem:Array =new Array();
	private var  csd:CustomizeSortOrder=null;
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
     
     [Bindable]private var mode : String = "query";
            
	  
	  private function changeCurrentState():void{
				currentState = "result";
	 }
			 
           public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosQueryControl(new XenosQuery());
           	   if(this.mode == 'query'){
           	   	 this.dispatchEvent(new Event('queryInit'));
           	   } else if(this.mode == 'amend'|| this.mode == 'ptaxentry'){
           	   	 this.dispatchEvent(new Event('amendInit'));
           	   	 addColumn();
           	   } else { 
           	     this.dispatchEvent(new Event('cancelInit'));
           	   	 addColumn();
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
	                        }
	                    }                    	
                    }else{
                    	mode = "query";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }               
            }
        override public function preQueryInit():void{
		       var rndNo:Number= Math.random();
//		  	   super.getInitHttpService().url = "frx/forexQueryDispatch.action?";
//		  	   var reqObject:Object = new Object();
//		  	   reqObject.rnd = rndNo;
//            	reqObject.method= "initialExecute";
//		  		reqObject.mode="query";
//		  		reqObject.SCREEN_KEY = "328";
//		  		super.getInitHttpService().request = reqObject;
		  		
	  		if(this.mode == "query") {
		   	super.getInitHttpService().url = "frx/forexQueryDispatch.action?";
		   	var reqObject:Object = new Object();
		  	reqObject.rnd = rndNo;
            reqObject.method= "initialExecute";
		  	reqObject.mode="query";
		  	reqObject.SCREEN_KEY = "328";
		  	super.getInitHttpService().request = reqObject;
		   }else if(this.mode == "ptaxentry"){
		   	super.getInitHttpService().url = "frx/forexPtaxQueryDispatch.action?";
		   	var reqObject:Object = new Object();
		  	reqObject.rnd = rndNo;
            reqObject.method= "initialExecute";
		  	reqObject.mode="ptaxentry";
		  	reqObject.SCREEN_KEY = "328";
		  	super.getInitHttpService().request = reqObject;
		   }          	
        }
         
        override public function preAmendInit():void{
		   var rndNo:Number= Math.random();
		   if(this.mode == "amend") {
		   	super.getInitHttpService().url = "frx/forexAmendQueryDispatch.action?";
		   	var reqObject:Object = new Object();
		  	reqObject.rnd = rndNo;
            reqObject.method= "initialExecute";
		  	reqObject.mode="amend";
		  	reqObject.SCREEN_KEY = "328";
		  	super.getInitHttpService().request = reqObject;
		   }else if(this.mode == "ptaxentry"){
		   	super.getInitHttpService().url = "frx/forexPtaxQueryDispatch.action?";
		   	var reqObject:Object = new Object();
		  	reqObject.rnd = rndNo;
            reqObject.method= "initialExecute";
		  	reqObject.mode="ptaxentry";
		  	reqObject.SCREEN_KEY = "328";
		  	super.getInitHttpService().request = reqObject;
		   }
        }
        
        override public function preCancelInit():void{
		   var rndNo:Number= Math.random();
//		   super.getInitHttpService().url = "frx/forexCxlQueryDispatch.action?";
//		   var reqObject:Object = new Object();
//		  	reqObject.rnd = rndNo;
//            reqObject.method= "initialExecute";
//		  	reqObject.mode="cancel";
//		  	reqObject.SCREEN_KEY = "328";
//		  	super.getInitHttpService().request = reqObject;
		  	
		  	if(this.mode == "cancel") {
		   	super.getInitHttpService().url = "frx/forexCxlQueryDispatch.action?";
		   	var reqObject:Object = new Object();
		  	reqObject.rnd = rndNo;
            reqObject.method= "initialExecute";
		  	reqObject.mode="cancel";
		  	reqObject.SCREEN_KEY = "328";
		  	super.getInitHttpService().request = reqObject;
		   }else if(this.mode == "ptaxentry"){
		   	super.getInitHttpService().url = "frx/forexPtaxQueryDispatch.action?";
		   	var reqObject:Object = new Object();
		  	reqObject.rnd = rndNo;
            reqObject.method= "initialExecute";
		  	reqObject.mode="ptaxentry";
		  	reqObject.SCREEN_KEY = "328";
		  	super.getInitHttpService().request = reqObject;
		   }  
        }
                 
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("scrDisDatas.tradeTypeList.tradeTypeList");
	    	keylist.addItem("scrDisDatas.buySellFlagList.item");
	    	keylist.addItem("scrDisDatas.statusList.statusList");
	    	keylist.addItem("scrDisDatas.spotRateStatusList.item");
	    	keylist.addItem("scrDisDatas.confirmationStatusList.item");
	    	keylist.addItem("sortFieldList1.item");
	    	keylist.addItem("sortFieldList2.item");
	    	keylist.addItem("sortFieldList3.item");
	    	keylist.addItem("sortField1");
	    	keylist.addItem("sortField2");
	    	keylist.addItem("sortField3");
	    		
        }
        
        override public function preQueryResultInit():Object{
        	addCommonKeys();	    	
	    	return keylist;        	
        }
        
         override public function preAmendResultInit():Object{
        	addCommonKeys();   		    	
	    	return keylist;        	
        }
        
        override public function preCancelResultInit():Object{
        	addCommonKeys();   		    	
	    	return keylist;        	
        } 
        
        
        private function commonInit(mapObj:Object):void{
	    	
	    	errPage.clearError(super.getInitResultEvent());
	    	app.submitButtonInstance = submit;
	        var i:int = 0;
	        var selIndx:int = 0;
	        var dateStr:String = null;
	        var tempColl: ArrayCollection = new ArrayCollection();
	        var initColl:ArrayCollection = new ArrayCollection();
	        //variables to hold the default values from the server
	        
	        
	        var sortField1Default:String = mapObj[keylist.getItemAt(8)].toString();
	        var sortField2Default:String = mapObj[keylist.getItemAt(9)].toString();
	        var sortField3Default:String = mapObj[keylist.getItemAt(10)].toString(); 
	        //initiate text fields
	        
	        fundPopUp.fundCode.text = "";
	        fundPopUp.setFocus();
	        
	        invActPopUp.accountNo.text = "";
	        cpActPopUp.accountNo.text = "";
	        cancelReferenceNo.text = "";
	        trdDateFrom.text = "";
	        trdDateTo.text = "";
	        valueDateFrom.text = "";
	        valueDateTo.text = "";
	        trdCcyBox.ccyText.text = "";
	        counterCcyBox.ccyText.text = "";
	        referenceNo.text = "";
	        status.text = "";
	        creationDateFrom.text = "";
	        creationDateTo.text = "";
	        updateDateFrom.text = "";
	        updateDateTo.text = "";
	        this.statusTxt.visible = false;
		    this.statusTxt.includeInLayout = false;
	        
	        //Initialize Trade Type
	       
	    	tempColl = new ArrayCollection();
	    	initColl = new ArrayCollection();
	    	tempColl.addItem(" ");
	    	if(mapObj[keylist.getItemAt(0)] !=null){
		    	if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
		        	initColl = mapObj[keylist.getItemAt(0)] as ArrayCollection;
		        	for each(var item1:Object in initColl){
		        		tempColl.addItem(item1);
		        	}
		    	}
		    	else {
		    		tempColl.addItem(mapObj[keylist.getItemAt(0)].toString());
		    	}
	    	}
	    	this.tradeType.dataProvider = tempColl;
	     
	        
	        //Initialize Buy Sell Flag
		    tempColl = new ArrayCollection();
		    initColl = new ArrayCollection();
		    tempColl.addItem({label:" ", value: " "});
		    
		    	if(mapObj[keylist.getItemAt(1)] !=null){
		    	if(mapObj[keylist.getItemAt(1)] is ArrayCollection){
		        	initColl = mapObj[keylist.getItemAt(1)] as ArrayCollection;
		        	for each(var item2:Object in initColl){
		        		tempColl.addItem(item2);
		        	}
		    	}
		    	else {
		    		tempColl.addItem(mapObj[keylist.getItemAt(1)].toString());
		    	}
		    	} 
		    	
		    	//this.buySellFlag.dataProvider =  tempColl;
	        	
			
			//Initialize Status
			tempColl = new ArrayCollection();
		    initColl = new ArrayCollection();
	       
        	if(mapObj[keylist.getItemAt(2)] !=null){
	        	if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
	            	initColl = mapObj[keylist.getItemAt(2)] as ArrayCollection;
	            	for each(var item3:Object in initColl){
		        		tempColl.addItem(item3);
		        	}
	        	}
	        	else {
	        		tempColl.addItem(mapObj[keylist.getItemAt(2)].toString());
	        	}
        	}
        	this.status.dataProvider =  tempColl;
	        
	        //Initialize NoExchangeFlag
	        tempColl = new ArrayCollection();
		    initColl = new ArrayCollection();
		    tempColl.addItem({label:" ", value: " "});
	       
	        	if(mapObj[keylist.getItemAt(3)] !=null){
	        	if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
	            	initColl = mapObj[keylist.getItemAt(3)] as ArrayCollection;
	            	for each(var item4:Object in initColl){
		        		tempColl.addItem(item4);
		        	}
	        	}
	        	else {
	        		tempColl.addItem(mapObj[keylist.getItemAt(3)].toString());
	        	}
	        	}
	        
	        this.spotRateStatus.dataProvider = tempColl;
	        
	        //Initialize confirmationStatus
	        tempColl = new ArrayCollection();
		    initColl = new ArrayCollection();
		    tempColl.addItem({label:" ", value: " "});
	       
	        	if(mapObj[keylist.getItemAt(4)] !=null){
	        	if(mapObj[keylist.getItemAt(4)] is ArrayCollection){
	            	initColl = mapObj[keylist.getItemAt(4)] as ArrayCollection;
	            	for each(var item5:Object in initColl){
		        		tempColl.addItem(item5);
		        	}
	        	}
	        	else {
	        		tempColl.addItem(mapObj[keylist.getItemAt(4)]);
	        	}
	        	}
	        this.confirmationStatus.dataProvider = tempColl;
	        
	        //Initialize sortFieldList1.
	        if(null != mapObj[keylist.getItemAt(5)]){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(5)] is ArrayCollection){
	            initColl = mapObj[keylist.getItemAt(5)] as ArrayCollection;
	       		for each(var item6:Object in initColl){
	                //Get the default value object's index
	                if(XenosStringUtils.equals(item6.value,sortField1Default)){                    
	                    selIndx = initColl.getItemIndex(item6);
	                }
	                   tempColl.addItem(item6);            
	            }
	            sortFieldArray[0]=sortField1;
		        sortFieldDataSet[0]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
	            
	        } 
	        }else {
	            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.populate.sortorder1'));
	        }
	        
	        //Initialize sortFieldList2.
	        if(null != mapObj[keylist.getItemAt(6)]){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx=0;
	            if(mapObj[keylist.getItemAt(6)] is ArrayCollection){
	            initColl = mapObj[keylist.getItemAt(6)] as ArrayCollection;
	            for each(var item7:Object in initColl){
	                //Get the default value object's index
	                if(XenosStringUtils.equals(item7.value,sortField2Default)){                    
	                    selIndx = initColl.getItemIndex(item7);
	                }
	                tempColl.addItem(item7);            
	            }
	            
	            sortFieldArray[1]=sortField2;
		        sortFieldDataSet[1]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
	            
	        }
	        } else {
	            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.populate.sortorder2'));
	        }
	        
	        //Initialize sortFieldList3.
	        if(null != mapObj[keylist.getItemAt(7)]){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx = 0;
	            
	            if(mapObj[keylist.getItemAt(7)] is ArrayCollection){
	            initColl = mapObj[keylist.getItemAt(7)] as ArrayCollection;
	            for each(var item8:Object in initColl){
	                //Get the default value object's index
	                if(XenosStringUtils.equals(item8.value,sortField3Default)){                    
	                    selIndx = initColl.getItemIndex(item8);
	                }
	                
	                tempColl.addItem(item8);            
	            }
	            
	            sortFieldArray[2]=sortField3;
		        sortFieldDataSet[2]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
		       
		        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
		        csd.init();
		        
	        } 
	        }else {
	            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.populate.sortorder3'));
	        }
    		
        }
        
        override public function postQueryResultInit(mapObj:Object):void{
        	commonInit(mapObj);
        }
        
        
        override public function postAmendResultInit(mapObj:Object):void{
        	commonInit(mapObj);
        	this.statusTxt.visible = true;
        	this.statusTxt.includeInLayout = true;
        	this.status.visible = false;
        	this.status.includeInLayout = false;
        	this.statusTxt.text = this.parentApplication.xResourceManager.getKeyValue('frx.statustxt.amend.cxl');	
        	if(this.mode == "ptaxentry"){
        		this.confirmationStatusLbl.visible = false;
        		this.confirmationStatusLbl.includeInLayout = false;
        		this.confirmationStatus.visible =  false;
        		this.confirmationStatus.includeInLayout = false;
		    			    	
		    	var initColl:ArrayCollection = new ArrayCollection();
		    	if(mapObj[keylist.getItemAt(0)] !=null){
			    	if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
			        	initColl = mapObj[keylist.getItemAt(0)] as ArrayCollection;
			    	}
			    	else {
			    		initColl.addItem(mapObj[keylist.getItemAt(0)].toString());
			    	}
		    	}
		    	this.tradeType.dataProvider = initColl;
		    	this.tradeType.selectedIndex = 0;
		    	
		    	initColl = new ArrayCollection();
		    	if(mapObj[keylist.getItemAt(3)] !=null){
			    	if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
			        	initColl = mapObj[keylist.getItemAt(3)] as ArrayCollection;
			    	}
			    	else {
			    		initColl.addItem(mapObj[keylist.getItemAt(3)].toString());
			    	}
		    	}
		    	this.spotRateStatus.dataProvider = initColl;
		    	this.spotRateStatus.selectedIndex = 0;
        		
        	}else{
        		this.confirmationStatusLbl.visible = true;
        		this.confirmationStatusLbl.includeInLayout = true;
        		this.confirmationStatus.visible =  true;
        		this.confirmationStatus.includeInLayout = true;
        	}
        }
        
        override public function postCancelResultInit(mapObj:Object):void{
        	commonInit(mapObj);	
        	this.statusTxt.visible = true;
        	this.statusTxt.includeInLayout = true;
        	this.status.visible = false;
        	this.status.includeInLayout = false;
        	this.statusTxt.text = this.parentApplication.xResourceManager.getKeyValue('frx.statustxt.amend.cxl');
        }
        
        	private function setValidator():void{
			
    	    var frxQryValidationModel:Object={
                            frxTrdQry:{
	                                 trdDateFrom:this.trdDateFrom.text,
	                                 trdDateTo:this.trdDateTo.text,
	                                 valueDateFrom:this.valueDateFrom.text,
	                                 valueDateTo:this.valueDateTo.text,
	                                 creationDateFrom:this.creationDateFrom.text,
	                                 creationDateTo:this.creationDateTo.text,
	                                 updateDateFrom:this.updateDateFrom.text,
	                                 updateDateTo:this.updateDateTo.text
                            	}
                           }; 
             super._validator = new FrxTrdQueryValidator();
             super._validator.source = frxQryValidationModel ;
             super._validator.property = "frxTrdQry";
		}
		
		override public function preQuery():void{
			setValidator();
            qh.resetPageNo();	
//            super.getSubmitQueryHttpService().url = "frx/forexQueryDispatch.action?";
            if(this.mode == "ptaxentry"){
		   		super.getSubmitQueryHttpService().url = "frx/forexPtaxQueryDispatch.action?";
            }else{
            	super.getSubmitQueryHttpService().url = "frx/forexQueryDispatch.action?";
            }  
            super.getSubmitQueryHttpService().method="POST";
            super.getSubmitQueryHttpService().request  =populateRequestParams();
           
		}
		
		override public function preAmend():void{
			setValidator();
            qh.resetPageNo();	
            super.getSubmitQueryHttpService().method="POST";
            if(this.mode == "ptaxentry"){
		   		super.getSubmitQueryHttpService().url = "frx/forexPtaxQueryDispatch.action?";
            }else{
            	super.getSubmitQueryHttpService().url = "frx/forexAmendQueryDispatch.action?";
            }   
            super.getSubmitQueryHttpService().request  =populateRequestParams();  
           
		}
		
		
		override public function preCancel():void{
			
			setValidator();
			qh.resetPageNo();
			super.getSubmitQueryHttpService().method="POST";	
//            super.getSubmitQueryHttpService().url = "frx/forexCxlQueryDispatch.action?";
            if(this.mode == "ptaxentry"){
		   		super.getSubmitQueryHttpService().url = "frx/forexPtaxQueryDispatch.action?";
            }else{
            	super.getSubmitQueryHttpService().url = "frx/forexCxlQueryDispatch.action?";
            } 
            super.getSubmitQueryHttpService().request = populateRequestParams();
           
		}
		
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
         reqObj.method = "submitQuery";
         if(this.mode == 'query'){
    		reqObj.SCREEN_KEY = "329";
    	} else if(this.mode == 'amend'){
    		reqObj.SCREEN_KEY = "329";
    	} else if(this.mode == 'ptaxentry'){
    		reqObj.SCREEN_KEY = "11055";
    	} else if(this.mode == 'cancel'){
    		reqObj.SCREEN_KEY = "329";
    	}
         reqObj.fundCode = this.fundPopUp.fundCode.text;
         reqObj.inventoryAccountNo = this.invActPopUp.accountNo.text;
         reqObj.tradeType = (String(StringUtil.trim(this.tradeType.text)).length > 0 
         						&& this.tradeType.selectedItem != null) ? this.tradeType.selectedItem : "";
         reqObj.accountNo = this.cpActPopUp.accountNo.text;
         //reqObj.buySellFlag = this.buySellFlag.selectedItem != null ? this.buySellFlag.selectedItem.value : "";
         reqObj.cancelReferenceNo = this.cancelReferenceNo.text;
         reqObj.tradeDateFrom = this.trdDateFrom.text;
         reqObj.tradeDateTo = this.trdDateTo.text;
         reqObj.valueDateFrom = this.valueDateFrom.text;
         reqObj.valueDateTo = this.valueDateTo.text;
         reqObj.baseCcy = this.trdCcyBox.ccyText.text;
         reqObj.againstCcy = this.counterCcyBox.ccyText.text;
         reqObj.referenceNo = this.referenceNo.text;
         if(this.mode == 'query'){
         	reqObj.status = (this.status.selectedItem != null) ? this.status.selectedItem : "";
         }else{
         	reqObj.status = this.statusTxt.text;
         }
         reqObj.appRegiDateFrom = this.creationDateFrom.text;
         reqObj.appRegiDateTo = this.creationDateTo.text;
         reqObj.appUpdDateFrom = this.updateDateFrom.text;
         reqObj.appUpdDateTo = this.updateDateTo.text;
         reqObj.spotRateStatus = this.spotRateStatus.selectedItem != null ? this.spotRateStatus.selectedItem.value : "";
         if(this.mode != 'ptaxentry'){
         	reqObj.confirmationStatus = this.confirmationStatus.selectedItem != null ? this.confirmationStatus.selectedItem.value : "";
         }
	     reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
       	 reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
       	 reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;
       	 
       	 reqObj.rnd = Math.random() + "";
    	
    	return reqObj;
    }
    
    override public function postQueryResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
    override public function postAmendResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
    override public function postCancelResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
       
        
    private function commonResult(mapObj:Object):void{    	
    	var result:String = "";
    	if(mapObj!=null){   
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		if(queryResult.length > 0){
	    			queryResult.removeAll();
	    		}
	    		errPage.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	   errPage.clearError(super.getSubmitQueryResultEvent());
	    	   if(queryResult.length > 0){
	    	   		queryResult.removeAll();
	    	   }
               queryResult=mapObj["row"];
			   changeCurrentState();
	           qh.setOnResultVisibility();
	           qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
	           qh.PopulateDefaultVisibleColumns();
               if(queryResult.length == 1 && this.mode == 'query'){
               	displayDetailView(queryResult[0].frxTrdPk);
               }
	    		
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}    		
    	}
    }   
       
      
        override public function preResetQuery():void{
		       var rndNo:Number= Math.random();
//		  		super.getResetHttpService().url = "frx/forexQueryDispatch.action?method=resetQuery&&mode=query&&menuType=Y&rnd=" + rndNo; 
	  		if(this.mode == "ptaxentry"){
	   			super.getResetHttpService().url = "frx/forexPtaxQueryDispatch.action?method=resetQuery&&mode=query&&menuType=Y&rnd=" + rndNo;
            }
            else{
		   		super.getResetHttpService().url = "frx/forexQueryDispatch.action?method=resetQuery&&mode=query&&menuType=Y&rnd=" + rndNo;
            }       	
        }
        
        override public function preResetAmend():void{
		   var rndNo:Number= Math.random();
		   if(this.mode == "ptaxentry"){
		   		super.getResetHttpService().url = "frx/forexPtaxQueryDispatch.action?method=resetQuery&&mode=amend&&menuType=Y&rnd=" + rndNo;
            }
            else{
		   		super.getResetHttpService().url = "frx/forexAmendQueryDispatch.action?method=resetQuery&&mode=amend&&menuType=Y&rnd=" + rndNo;
            }
        }
        
        override public function preResetCancel():void{
		   var rndNo:Number= Math.random();
//		   super.getResetHttpService().url = "frx/forexCxlQueryDispatch.action?method=resetQuery&&mode=cancel&&menuType=Y&rnd=" + rndNo;  
		   if(this.mode == "ptaxentry"){
		   		super.getResetHttpService().url = "frx/forexPtaxQueryDispatch.action?method=resetQuery&&mode=cancel&&menuType=Y&rnd=" + rndNo;
            }
            else{
		   		super.getResetHttpService().url = "frx/forexCxlQueryDispatch.action?method=resetQuery&&mode=cancel&&menuType=Y&rnd=" + rndNo;
            }
        }       
        
        
        override    public function preGenerateXls():String{
        	 var url : String =null;
		    	if(mode == "query"){		    		
		    	  url = "frx/forexQueryDispatch.action?method=generateXLS";
		    	}else if(mode == "amend"){
		    		url = "frx/forexAmendQueryDispatch.action?method=generateXLS";
		    	}else if(mode=='cancel'){
		    		url = "frx/forexCxlQueryDispatch.action?method=generateXLS";
		    	}
		    	else{
		    		url = "frx/forexPtaxQueryDispatch.action?method=generateXLS";
		    	}
		    	return url;
         }	
   override public function preGeneratePdf():String{
    	   var url : String =null;
		    	if(mode == "query"){		    		
		    	  url = "frx/forexQueryDispatch.action?method=generatePDF";
		    	}else if(mode == "amend"){
		    		url = "frx/forexAmendQueryDispatch.action?method=generatePDF";
		    	}else if(mode=='cancel'){
		    		url = "frx/forexCxlQueryDispatch.action?method=generatePDF";
		    	}
		    	else{
		    		url = "frx/forexPtaxQueryDispatch.action?method=generatePDF";
		    	}
		    	return url;
          }	
            
   override    public function preNext():Object{
    	   var reqObj : Object = new Object();
    	   reqObj.method = "doNext";
    	   return reqObj;
         }	
    override public function prePrevious():Object{
    	   
    	    var reqObj : Object = new Object();
    	    reqObj.method = "doPrevious";
    	    return reqObj;
          }	
          
          private function dispatchPrintEvent():void{
              this.dispatchEvent(new Event("print"));
          }  
          private function dispatchPdfEvent():void{
             // XenosAlert.info("dispatchEvent pdf");
              this.dispatchEvent(new Event("pdf"));
          }  
          private function dispatchXlsEvent():void{
              this.dispatchEvent(new Event("xls"));
          }   
          private function dispatchNextEvent():void{
              this.dispatchEvent(new Event("next"));
          }  
          private function dispatchPrevEvent():void{
              this.dispatchEvent(new Event("prev"));
          }      
      
		private function addColumn():void
		{
			//Add a object
			
			var dg :DataGridColumn = new DataGridColumn();
			dg.dataField="";
			dg.editable = false;
			dg.headerText = "";
			dg.width = 40;
			dg.itemRenderer = new RendererFectory(ImgSummaryRenderer);
			
			var cols :Array = resultSummary.columns;
			cols.unshift(dg);
			resultSummary.columns = cols;
			
		}
		
		private function sortOrder1Update():void{
	     	 csd.update(sortField1.selectedItem,0);
	     }
	     
	     private function sortOrder2Update():void{     	
	     	csd.update(sortField2.selectedItem,1);
	     }
	     
	     /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateInvActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|B";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="INTERNAL";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
            return myContextList;
        }
        
                /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateConterPartyActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|B";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("cpActTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(2);
                cpTypeArray[0]="BROKER";
                cpTypeArray[1]="BANK/CUSTODIAN";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
            return myContextList;
        }
        
        private function displayDetailView(frxTrdPk:String):void{
    		var sPopup:SummaryPopup = SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
	    		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('frx.detail.title');
	            //set the width and height of the popup
	    		sPopup.width = parentApplication.width - 125;
	    		sPopup.height = parentApplication.height - 150;
	    		sPopup.horizontalScrollPolicy="auto";
	    		sPopup.verticalScrollPolicy="auto";
	    		PopUpManager.centerPopUp(sPopup);
	    		//Setting the Module path with some parameters which will be needed in the module for internal processing.
	    		sPopup.moduleUrl = Globals.FRX_TRADE_DETAILS_SWF + Globals.QS_SIGN + "frxTradePk" + Globals.EQUALS_SIGN + frxTrdPk;
        }
