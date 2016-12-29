// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.core.validators.XenosNumberValidator;

import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.UIComponent;
import mx.formatters.NumberBase;
import mx.managers.PopUpManager;
import mx.utils.StringUtil;
			
	  //private var mkt:XenosQuery = new MarketPriceQuery();
	  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    public var queryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    public var tempQueryResult:ArrayCollection= new ArrayCollection();
     
     private var keylist:ArrayCollection = new ArrayCollection(); 
     private var sortFieldArray:Array =new Array();
     private var sortFieldDataSet:Array =new Array();
     private var sortFieldSelectedItem:Array =new Array();
     private var  csd:CustomizeSortOrder=null;
     [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
     [Bindable]
    public var selectAllBind:Boolean=false;
    private var selectedResults:ArrayCollection=new ArrayCollection();   
     [Bindable]public var mode : String = "query";
     [Bindable]private var exercisedQuantityExceedFlag:Boolean = false;       
	  [Bindable]private var exercisedQuantityBlankFlag:Boolean = false;  
	  [Bindable]private var skippedColumns:Array = new Array();
	  private function changeCurrentState():void{
				currentState = "result";
	 }
			 
           public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosQueryControl(new XenosQuery());
           	   //XenosAlert.info("mode : "+mode);
           	   if(this.mode == 'query'){
           	   	 skippedColumns = [10,12,15,16,18,22,23,25,29];
           	   	 this.dispatchEvent(new Event('queryInit'));
           	   } else if(this.mode == 'entry'){
           	   	 //skippedColumns = [2,12,14,15,18,21,23,26,24,27,28,29,32];
           	   	 //skippedColumns = [2,12,14,15,18,20,25,27,28,29,32];
           	   	 skippedColumns = [2,14,15,18,20,25,27,28,29,32];
           	   	 this.dispatchEvent(new Event('amendInit'));
           	   	 addColumn();
           	   }else if(this.mode == 'amend'){
           	   	 skippedColumns = [2,13,14,15,18,20,25,27,28,29,32];
           	   	 this.dispatchEvent(new Event('amendInit'));
           	   	 addColumn();
           	   } else { 
           	   	 skippedColumns = [2,11,13,16,17,19,21,23,24,26,30,32];
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
                    //XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
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
	                            //XenosAlert.info("movArray param = " + tempA[1]);
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
		  		/* this.status.includeInLayout = true;
		  		this.status.visible = true;
		  		this.lblStatus.includeInLayout = true;
		  		this.lblStatus.visible = true; */
		  		super.getInitHttpService().url = "cax/rightsExerciseQueryDispatch.action?method=initialExecute&mode=query&SCREEN_KEY=11126&menuType=Y&rnd=" + rndNo;  
        }
        
        override public function preAmendInit():void{
		   var rndNo:Number= Math.random();
		   if(this.mode == "entry")
		   	 super.getInitHttpService().url = "cax/rightsExerciseEntryQueryDispatch.action?&rnd=" + rndNo;
		   else if(this.mode == "amend")
		   	 super.getInitHttpService().url = "cax/rightsExerciseAmendQueryDispatch.action?&rnd=" + rndNo;
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		reqObject.SCREEN_KEY=11126
		  		super.getInitHttpService().request = reqObject;     	
        }
        
        override public function preCancelInit():void{
		   var rndNo:Number= Math.random();
		   super.getInitHttpService().url = "cax/rightsExerciseCancelQueryDispatch.action?&rnd=" + rndNo;  
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		reqObject.SCREEN_KEY=11126
		  		super.getInitHttpService().request = reqObject;      	
        }        
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();
	    	keylist.addItem("statusDropdownList.item");
	    	keylist.addItem("sortFieldList1.item");	
	    	keylist.addItem("sortFieldList2.item");	
	    	keylist.addItem("sortFieldList3.item");	
        }
        
        override public function preQueryResultInit():Object{
        	//var keylist:ArrayCollection = new ArrayCollection(); 
        	addCommonKeys();   	
	    	   	
	    	return keylist;        	
        }
        
        override public function preAmendResultInit():Object{
        	//var keylist:ArrayCollection = new ArrayCollection(); 
        	addCommonKeys();   		    	
	    	return keylist;        	
        }
        
        override public function preCancelResultInit():Object{
        	//var keylist:ArrayCollection = new ArrayCollection(); 
        	addCommonKeys();   		    	
	    	return keylist;        	
        }
        
        private function sortOrder1Update():void{
     	 csd.update(sortField1.selectedItem,0);
	     }
	     
	     private function sortOrder2Update():void{     	
	     	csd.update(sortField2.selectedItem,1);
	     }
        
        private function commonInit(mapObj:Object):void{
        	var item:Object;
        	var i:int = 0;
	        var selIndx:int = 0;
	        var initcol:ArrayCollection = new ArrayCollection();
	        var tempColl: ArrayCollection = new ArrayCollection();
	        
	        //variables to hold the default values from the server
	        var sortField1Default:String = "";
	        var sortField2Default:String = "";
	        var sortField3Default:String = "";   	
	        
	     	//initiate text fields
	     	rightsexerciserefno.text = "";
	     	if(mode != "entry")
	     		fundPopUpQuery.fundCode.text = "";
	     	else{
	     		fundPopUpEntry.fundCode.text = "";
	     		fullypaidShareCode.instrumentId.text = "";
	     	}
	     	fundaccountno.accountNo.text = "";
	     	rightscode.instrumentId.text = "";
	     	status.text = "";
	     	exdateFromStr.text = "";
	     	exdateToStr.text = "";
	     	recorddateFromStr.text = "";
	     	recorddateToStr.text = "";
	     	deadlinedateFromStr.text = "";
	     	deadlinedateToStr.text = "";
	     	expirydateFromStr.text ="";
	     	expirydateToStr.text = "";
	     	paymentdateFromStr.text = "";
	     	paymentdateToStr.text = "";
	     	exercisedateFromStr.text = "";
	     	exercisedateToStr.text = "";
	     	paymentdateTakeUpFromStr.text = "";
	     	paymentdateTakeUpToStr.text = "";
	     	securityCode.instrumentId.text = "";
	     	
	     	//Making Date fields reset
	     	exdateFromStr.selectedDate = null;
	     	exdateToStr.selectedDate = null;
	     	recorddateFromStr.selectedDate = null;
	     	recorddateToStr.selectedDate = null;
	     	deadlinedateFromStr.selectedDate = null;
	     	deadlinedateToStr.selectedDate = null;
	     	expirydateFromStr.selectedDate = null;
	     	expirydateToStr.selectedDate = null;
	     	paymentdateFromStr.selectedDate = null;
	     	paymentdateToStr.selectedDate = null;
	     	exercisedateFromStr.selectedDate = null;
	     	exercisedateToStr.selectedDate = null;	 	     	
	     	availableDateFrom.selectedDate=null;
	     	availableDateTo.selectedDate=null;
	     
    		errPage.clearError(super.getInitResultEvent());
    		if(mode == "entry"){
    			fundPopUpEntry.setFocus();
    		}else{
    			rightsexerciserefno.setFocus();
    		}
	        //errPage.removeError();
	    	
	    	initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	//index=0;
	    	for each(item in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	status.dataProvider = initcol;
	    	
	    	
	    	initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	selIndx = 0;
	    	//index=0;
	    	for each(item in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	
	    	/* for(i = 0; i<initcol.length; i++) {
	        	//Get the default value object's index
                 if(XenosStringUtils.equals((initcol[i].value),sortField1Default)){                    
                    selIndx = i;
                } 
	        	
	           tempColl.addItem(initcol[i]);            
	        } */
	        
	        sortFieldArray[0]=sortField1;
	        sortFieldDataSet[0]=initcol;
	        //Set the default value object
	        sortFieldSelectedItem[0] = initcol.getItemAt(1);
	        
	        
	        initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	selIndx = 0;
	    	//index=0;
	    	for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	
	    	/* for(i = 0; i<initcol.length; i++) {
	        	//Get the default value object's index
                 if(XenosStringUtils.equals((initcol[i].value),sortField2Default)){                    
                    selIndx = i;
                } 
	        	
	           tempColl.addItem(initcol[i]);            
	        } */
	        
	        sortFieldArray[1]=sortField2;
	        sortFieldDataSet[1]=initcol;
	        //Set the default value object
	        sortFieldSelectedItem[1] = initcol.getItemAt(2);
	        
	        initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	selIndx = 0;
	    	//index=0;
	    	for each(item in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	
	    	/* for(i = 0; i<initcol.length; i++) {
	        	//Get the default value object's index
                /* if(XenosStringUtils.equals((initcol[i].value),sortField3Default)){                    
                    selIndx = i;
                } */
	        	
	           //tempColl.addItem(initcol[i]);            
	        //} 
	        
	        sortFieldArray[2]=sortField3;
	        sortFieldDataSet[2]=initcol;
	        //Set the default value object
	        sortFieldSelectedItem[2] = initcol.getItemAt(3);
	        
	    		
    		csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
	    	csd.init();
	    	
	    	app.submitButtonInstance = submit;
        }
        
        /**
	     * Method to Format and validate numbers(B,M,T)
	     */
	     private function numberHandler(numVal:XenosNumberValidator):void{
	     	//The source textinput control
	     	/* var source:Object=numVal.source; 
	     	    	
	     	var vResult:ValidationResultEvent;
	     	var tmpStr:String = source.text; 
	     	if(XenosStringUtils.isBlank(source.text)){
	     		return;
	     	}
	     	else{
				vResult = numVal.validate();
		        
		        if (vResult.type==ValidationResultEvent.VALID) {
		     		source.text=numberFormatter.format(source.text);     		
		        }else{
		        	source.text = tmpStr;        	
		        }
		        
		        if(vResult != null && vResult.type ==ValidationResultEvent.INVALID){
	             var errorMsg:String=vResult.message;
	             XenosAlert.error(errorMsg);
		        }else{
		        	var digitsAfterDecimalArray:Array = exchangeRateStr.text.split(".");
		        	var digitsAfterDecimal:String = digitsAfterDecimalArray[1];
		        	if(Number(digitsAfterDecimal) > 99999999){
		        		source.text = tmpStr;
		        		XenosAlert.error("8 digits are allowed after decimal point");
		        	}
		        }
		     } */
	        
	     }
        
        override public function postQueryResultInit(mapObj:Object):void{
        	commonInit(mapObj);
        }
        
        
        override public function postAmendResultInit(mapObj:Object):void{
        	commonInit(mapObj);	
        }
        
        override public function postCancelResultInit(mapObj:Object):void{
        	commonInit(mapObj);	
        }
        
        	 private function setValidator():void{
			
    	    /* var validateModel:Object={
                            marketPriceQuery:{                                 
                                 baseDate:this.baseDate.text
                            }
                           }; 
             super._validator = new MarketPriceQueryValidator();
             super._validator.source = validateModel ;
             super._validator.property = "marketPriceQuery"; */
		} 
		
		override public function preQuery():void{
			setValidator();
               qh.resetPageNo();	
           // XenosAlert.info("I am in preQuery ");
            super.getSubmitQueryHttpService().url = "cax/rightsExerciseQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
           
		}
		
		override public function preAmend():void{
			//setValidator();
               qh.resetPageNo();	
            //XenosAlert.info("I am in preAmend ");
           if(this.mode == "entry")
		   	 super.getSubmitQueryHttpService().url = "cax/rightsExcerciseEntryDispatch.action?";
		   else if(this.mode == "amend")
		   	 super.getSubmitQueryHttpService().url = "cax/rightsExcerciseAmendDispatch.action?";
          //  super.getSubmitQueryHttpService().url = "cax/rightsExcerciseEntryDispatch.action?";   
            super.getSubmitQueryHttpService().request  =populateRequestParams();  
           
		}
		
		
		override public function preCancel():void{
			
			setValidator();
			 qh.resetPageNo();	
            //XenosAlert.info("I am in preCancel ");
            super.getSubmitQueryHttpService().url = "cax/rightsExerciseCancelQueryDispatch.action?"; 
            super.getSubmitQueryHttpService().request = populateRequestParams();
           
		}
		
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	 var reqObj : Object = new Object();
    	if (mode == "query" || mode == "cancel")
    		reqObj.method= "submitQuery";
    	else if(mode == "entry")
    		reqObj.method= "getRightsPosition";
    	else if(mode == "amend")
    		reqObj.method= "getAmendableRights";
    	if (mode != "entry")
    		reqObj.exerciseReferenceNo = this.rightsexerciserefno.text;   
    	if (mode == "amend" || mode == "cancel"){
    		reqObj.status = "NORMAL"; 
    	}  
    	if(mode != "entry")   
        	reqObj.fundCode = this.fundPopUpQuery.fundCode.text;
		else
			reqObj.fundCode = this.fundPopUpEntry.fundCode.text;       
        reqObj.fundAccountNo = this.fundaccountno.accountNo.text;
        reqObj.SCREEN_KEY = "10060";
        reqObj.rightsCode = this.rightscode.instrumentId.text;
        if (mode == "query")
        	reqObj.status = (this.status.selectedItem != null ? this.status.selectedItem.value : "");
        else{
        	reqObj.fullyPaidShareCode = this.fullypaidShareCode.instrumentId.text;
        }
        	
        //Date Fields
        reqObj.exDateFromStr = this.exdateFromStr.text;
        reqObj.exDateToStr = this.exdateToStr.text;
        reqObj.recordDateFromStr = this.recorddateFromStr.text;
        reqObj.recordDateToStr = this.recorddateToStr.text;
        reqObj.deadlineDateFromStr = this.deadlinedateFromStr.text;
        reqObj.deadlineDateToStr = this.deadlinedateToStr.text;
        reqObj.expiryDateFromStr = this.expirydateFromStr.text;
        reqObj.expiryDateToStr = this.expirydateToStr.text;
        reqObj.paymentDateFromStr = this.paymentdateFromStr.text;
        reqObj.paymentDateToStr = this.paymentdateToStr.text;
        reqObj.availableDateFromStr = this.availableDateFrom.text;
        reqObj.availableDateToStr = this.availableDateTo.text;
        if (mode != "entry"){
	        reqObj.exerciseDateFromStr = this.exercisedateFromStr.text;
	        reqObj.exerciseDateToStr = this.exercisedateToStr.text;
        }
        reqObj.paymentDateTakeUpFromStr = this.paymentdateTakeUpFromStr.text;
        reqObj.paymentDateTakeUpToStr   = this.paymentdateTakeUpToStr.text;
        //Text Fields    
        reqObj.sortField1 = (this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : "");
        reqObj.sortField2 = (this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : "");
        reqObj.sortField3 = (this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : "");
        reqObj.rnd = Math.random() + ""; 
    	reqObj.conditionReferenceNo = this.conditionReferenceNo.text;
    	reqObj.securityCode = this.securityCode.instrumentId.text;
    	reqObj.modeOfOperation=mode;
    	return reqObj;
    }
    override public function preAmendResultHandler():Object
	{
		keylist = new ArrayCollection();
		if(this.mode == "entry")
    		keylist.addItem("rightsList.rightsList");
    	else if(this.mode == "amend")
    		keylist.addItem("amendableRightsList.amendableRights");
    	return keylist;
	}
    override public function postQueryResultHandler(mapObj:Object):void{
    	
    	commonResult(mapObj);
    }
    override public function postAmendResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    	
    	setIfAllSelected();
    }
    override public function postCancelResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
       
        
    private function commonResult(mapObj:Object):void{    	
    	//XenosAlert.info("mapObj : "+mapObj.toString()); 
    	//var mapObj:Object = mkt.userQueryResultEvent(event,null);
    	var result:String = "";
    	queryResult = new ArrayCollection();
    	//XenosAlert.info("queryResult length" + queryResult.length);
    	
    	if(mapObj!=null){   
    		//XenosAlert.info("mapObj : "+mapObj.toString()); 		
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		//result = mapObj["errorMsg"] .toString();
	    		//queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	   errPage.clearError(super.getSubmitQueryResultEvent());
	    	   //errPage.removeError();
	    	  // XenosAlert.info("I am in errPage ");
               
	    	  // XenosAlert.info("I am in queryResult : "+currentState);
	    	   if(mode == "query" || mode == "cancel")
               	queryResult=mapObj["row"];
               else if(mode == "entry"){
               	queryResult=mapObj["rightsList.rightsList"];
               	resetQuantityCol();
               	queryResult=ProcessResultUtil.process(queryResult,resultSummary.columns);
               }else if(mode == "amend"){
               //	queryResult=mapObj["amendableRightsList.amendableRights"];
               	queryResult=new ArrayCollection();
               	for each(var item:Object in mapObj["amendableRightsList.amendableRights"]){
               		var obj:Object=ObjectUtil.copy(item);
               		var flag:String=item.exerciseFinalizeFlag;
               		obj.prevFinalizeFlag=flag;
		    		queryResult.addItem(obj);	    		
		    		
		    	}    	
		    	//queryResult.refresh(); 
		    	
               	resetQuantityCol();
               	queryResult=ProcessResultUtil.process(queryResult,resultSummary.columns);
               }
               if(queryResult.length == 0){
               	errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    		return;
               }
               for(var indx:int=0; indx<queryResult.length; indx++){
               	queryResult.getItemAt(indx).originalIndex = indx;
               	queryResult.getItemAt(indx).originalTakeUpCost = queryResult.getItemAt(indx).totalSubscriptionCostStr.toString();
               }
               	for(var index:int=0; index<queryResult.length; index++){
               		if(queryResult.getItemAt(index).availableDateStr != null) {
               			queryResult.getItemAt(index).originalAvailableDateStr = queryResult.getItemAt(index).availableDateStr.toString();
               		} else {
               			queryResult.getItemAt(index).originalAvailableDateStr = "";
               		}
               		if(queryResult.getItemAt(index).exerciseFinalizeFlag != null) {
               			queryResult.getItemAt(index).originalExerciseFinalizeFlag = queryResult.getItemAt(index).exerciseFinalizeFlag.toString();
               		} else {
               			queryResult.getItemAt(index).originalExerciseFinalizeFlag = "";
               		}
               		if(queryResult.getItemAt(index).paymentDateCashStr != null) {
               			queryResult.getItemAt(index).originalPaymentDateCashStr = queryResult.getItemAt(index).paymentDateCashStr.toString();
               		} else {
               			queryResult.getItemAt(index).originalPaymentDateCashStr = "";
               		}
               		if(queryResult.getItemAt(index).paymentDateStr != null) {
               			queryResult.getItemAt(index).originalPaymentDateStr = queryResult.getItemAt(index).paymentDateStr.toString();
               		} else {
               			queryResult.getItemAt(index).originalPaymentDateStr = "";
               		}
               		if(queryResult.getItemAt(index).expiryQuantityStr != null) {
               			queryResult.getItemAt(index).originalExpiryQuantityStr = queryResult.getItemAt(index).expiryQuantityStr.toString();
               		} else {
               			queryResult.getItemAt(index).originalExpiryQuantityStr = "";
               		}
					if(queryResult.getItemAt(index).exerciseDateStr != null) {
               			queryResult.getItemAt(index).originalExerciseDateStr = queryResult.getItemAt(index).exerciseDateStr.toString();
               		} else {
               			queryResult.getItemAt(index).originalExerciseDateStr = "";
               		}
               	}
               	
               	if(mode=="amend"){
               		tempQueryResult=new ArrayCollection();
               		for each(var item:Object in queryResult){
               			tempQueryResult.addItem(ObjectUtil.copy(item));
               		}
               	}
			   changeCurrentState();
			   app.submitButtonInstance = submitResult;
			   //resultSummary.dataProvider = queryResult;
			   		//if(this.mode != "entry"){
		            	qh.setOnResultVisibility();
		      		//}
		            qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
		            qh.PopulateDefaultVisibleColumns();
	    		
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}    		
    	}
    	//XenosAlert.info(result);
    }   
       
       private function resetQuantityCol():void{
       		//var tempResult:ArrayCollection = new ArrayCollection();
       		selectAllBind = false;
	       	if(mode == "entry"){
       			//var tempResult:ArrayCollection = col["rightsList.rightsList"];
               	for(var i:int=0; i<queryResult.length; i++){
               		var qntStr:String = queryResult[i].availableRightsStr;
                    queryResult[i].exercisingQuantityStr = qntStr;
                }
               	//queryResult = tempResult;
           		resetSellection(queryResult);
           		
             }else if(mode == "amend"){
             	//var tempResult:ArrayCollection = col["amendableRightsList.amendableRights"];
               	for(i=0; i<queryResult.length; i++){
               		queryResult[i].exercisingQuantityStr = "";
//                    queryResult[i].totalSubscriptionCostStr = "";
				}
               	//queryResult = tempResult;
           		resetSellection(queryResult);
             }
	          resultSummary.dataProvider = queryResult; 	
	        }
      
       private function resetTakeUpCostCol():void {
            if(mode == "entry") {
                for(var i:int=0; i<queryResult.length; i++){
                    queryResult[i].totalSubscriptionCostStr = "";
                }
                resetSellection(queryResult);
                
            } else if(mode == "amend"){
                for(i=0; i<queryResult.length; i++){
                    var qntStr:String = queryResult[i].originalTakeUpCost.toString();
                    queryResult[i].totalSubscriptionCostStr = qntStr;
                }
                resetSellection(queryResult);
            }
            resultSummary.dataProvider = queryResult;     
        }
        
        private function resetAvailableDate():void {
            /* if(mode == "entry") {
                for(var i:int=0; i<queryResult.length; i++){
                    queryResult[i].availableDateStr = "";
                }
            } else  */
            if(mode == "entry" || mode == "amend"){
                for(var i:int=0; i<queryResult.length; i++){
                    var avlDtStr:String = queryResult[i].originalAvailableDateStr.toString();
                    queryResult[i].availableDateStr = avlDtStr;
                }
            }
            resultSummary.dataProvider = queryResult;     
        }
        
        private function resetOtherFields():void {
            /* if(mode == "entry") {
                for(var i:int=0; i<queryResult.length; i++){
                    queryResult[i].availableDateStr = "";
                }
            } else */ 
            //if(mode == "amend"){
                for(var i:int=0; i<queryResult.length; i++){
                    var finalizeFlag:String = queryResult[i].originalExerciseFinalizeFlag.toString();
                    var paymentDateCashStr:String = queryResult[i].originalPaymentDateCashStr.toString();
                    var paymentDateStr:String = queryResult[i].originalPaymentDateStr.toString();
                    var expiryQuantityStr:String = queryResult[i].originalExpiryQuantityStr.toString();
					var exerciseDateStr:String = queryResult[i].originalExerciseDateStr.toString();
                    
                    queryResult[i].exerciseFinalizeFlag = finalizeFlag;
                    queryResult[i].paymentDateCashStr = paymentDateCashStr;
                    queryResult[i].paymentDateStr = paymentDateStr;
                    queryResult[i].expiryQuantityStr = expiryQuantityStr;
					queryResult[i].exerciseDateStr = exerciseDateStr;
                }
            //}
            resultSummary.dataProvider = queryResult;     
        }

        override public function preResetQuery():void{
		       var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "cax/rightsExerciseQueryDispatch.action?method=resetQuery&modeOfOperation=query&mode=query&&menuType=Y&rnd=" + rndNo;        	
        }
        
        override public function preResetAmend():void{
		   var rndNo:Number= Math.random();
		   if(this.mode == "entry")
		   	 super.getResetHttpService().url = "cax/rightsExerciseEntryQueryDispatch.action?method=resetQuery&modeOfOperation=entry&mode=entry&&menuType=Y&rnd=" + rndNo;
		   else if(this.mode == "amend")
		   	 super.getResetHttpService().url = "cax/rightsExerciseAmendQueryDispatch.action?method=resetQuery&modeOfOperation=amend&mode=amend&&menuType=Y&rnd=" + rndNo;
		   //super.getResetHttpService().url = "ref/rightsExerciseQueryDispatch.action?&rnd=" + rndNo;
//		     var reqObject:Object = new Object();
//		  		reqObject.actionType=this.mode;
//		  		reqObject.method="initialExecute";
//		  		super.getResetHttpService().request = reqObject;     	
        }
        
        override public function preResetCancel():void{
		   var rndNo:Number= Math.random();
		   super.getResetHttpService().url = "cax/rightsExerciseCancelQueryDispatch.action?method=resetQuery&&mode=cancel&modeOfOperation=cancel&menuType=Y&rnd=" + rndNo;  
//		     var reqObject:Object = new Object();
//		  		reqObject.actionType=this.mode;
//		  		reqObject.method="initialExecute";
//		  		super.getResetHttpService().request = reqObject;      	
        }       
        
        
        override    public function preGenerateXls():String{
        	 var url : String =null;
        	 
        	 	 if(mode == "entry")
		    	 	url = "cax/rightsExcerciseEntryDispatch.action?method=generateXLS";
		    	 else if(mode == "amend")
		    	 	url = "cax/rightsExcerciseAmendDispatch.action?method=generateXLS";
		    	 else if(mode == "query")		    		
		    	 	url = "cax/rightsExerciseQueryDispatch.action?method=generateXLS";
		    	 else
		    	 	url = "cax/rightsExerciseCancelQueryDispatch.action?method=generateXLS";
		    	 return url;
         }	
   override public function preGeneratePdf():String{
           //XenosAlert.info("preGeneratePdf");
    	     var url : String =null;
		   	 if(mode == "entry")
			 	url = "cax/rightsExcerciseEntryDispatch.action?method=generatePDF";
			 else if(mode == "amend")
			 	url = "cax/rightsExcerciseAmendDispatch.action?method=generatePDF";
			 else if(mode == "query")		    		
			 	url = "cax/rightsExerciseQueryDispatch.action?method=generatePDF";
			 else
			 	url = "cax/rightsExerciseCancelQueryDispatch.action?method=generatePDF";
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

		/**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateInvActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var prefixArray:Array = new Array(1);
                prefixArray[0]="";
            myContextList.addItem(new HiddenObject("prefix",prefixArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="INTERNAL";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            
            return myContextList;
        }
        
      
      private function resetSellection(queryResult:ArrayCollection):void{
    	for(var i:int=0;i<queryResult.length;i++){
    		queryResult[i].selected = false;
    		queryResult[i].rowNum = i;
    	}
    }
    
    
    
    public function setIfAllSelected() : void {
    	if(isAllSelected()){
    		selectAllBind=true;
    	} else {
    		selectAllBind=false;
    	}
    }
    
    
    public function isAllSelected(): Boolean {
    	var i:Number = 0;
    	if(queryResult == null){
    	 return false;
    	}
    	for(i=0; i<queryResult.length; i++){
    		if(queryResult[i].selected == false) {
        		return false;
        	}
    	}
    	if(i == queryResult.length) {
    		return true;
         }else {
    		return false;
    	}
    }
    
       
// This as file contains code specific to the Check Box Selections.    
    
    public function selectAllRecords(flag:Boolean): void {
    	var i:Number = 0;
    	selectedResults.removeAll();
    	for(i=0; i<queryResult.length; i++){
    		var obj:XML=queryResult[i];
            obj.selected = flag;
            queryResult[i]=obj;
            //addOrRemove(queryResult[i]);
    	}
    	//conformSelectedResults = selectedResults.toArray();
    }
    
   /*  public function addOrRemove(item:Object):void {
    	var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){ 
        	var obj:Object=new Object();
        	obj.receivedConfirmationPk=item.receivedConfirmationPk;
        	obj.tradePk=item.tradePk;
        	obj.allocationConfirmationFlag=item.allocationConfirmationFlag;
        	obj.controlNo=item.controlNo;
        	obj.matchStatusDisp=item.matchStatusDisp;
        	obj.status=item.status;
        	obj.rowNum=item.rowNum;
        	obj.dataSource = item.dataSource;
        	obj.settlementStatus = item.settlementStatus;
            selectedResults.addItem(obj);
           
    	}else { //needs to pop
    		tempArray=selectedResults.toArray();
    	    selectedResults.removeAll();
    		for(i=0; i<tempArray.length; i++){
    			if(tempArray[i] != item.messageId)
    			    selectedResults.addItem(tempArray[i]);
    		}
    	}		
    } */
   
   
    public function checkSelectToModify(item:Object):void {
        /* var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){
        	 // needs to insert
        	var obj:Object=new Object();
            selectedResults.addItem(item.rowNum);
    	}else { //needs to pop
    		tempArray=selectedResults.toArray();
    	    selectedResults.removeAll();
    		     		
    	}    */ 
    	//conformSelectedResults=	selectedResults.toArray();
    	setIfAllSelected();    	    	
    }
    
    private function getSelectedRows():Array{
    	var tempArray:ArrayCollection = new ArrayCollection();
    	var numBase:NumberBase = new NumberBase();
    	for(var i:int=0;i<queryResult.length;i++){
    		if(queryResult[i].selected == true){
    			tempArray.addItem(queryResult[i].originalIndex + "|" + i);
    			trace("Selected index :: " + queryResult[i].originalIndex);
    			if(queryResult[i].exercisingQuantityStr == ""){
    				trace("exercisingQuantityStr :: " + queryResult[i].exercisingQuantityStr);
    				var exerciseFinalizeFlag:String=queryResult[i].exerciseFinalizeFlag;
    				var prevFinalizeFlag:String=queryResult[i].prevFinalizeFlag;
    				if(exerciseFinalizeFlag!=prevFinalizeFlag ){
    				  	queryResult[i].exercisingQuantityStr="0";    					
    				}
    				else{
    					exercisedQuantityBlankFlag = true;
    				}
    			}
    			var exercisingQuantityNum:Number = Number(numBase.parseNumberString(String(queryResult[i].exercisingQuantityStr)));
    			var availableRightsNum:Number = Number(numBase.parseNumberString(String(queryResult[i].availableRightsStr)));
    			var exercisedQuantityNum:Number = Number(numBase.parseNumberString(String(queryResult[i].exerciseQuantityStr)));
    			if(exercisingQuantityNum > availableRightsNum && this.mode == "entry"){
	    			exercisedQuantityExceedFlag = true;
	    			trace("exercisingQuantityNum :: " + exercisingQuantityNum);
	    			trace("availableRightsNum :: " + availableRightsNum);
	    			break;
	    		}else if(exercisingQuantityNum > (availableRightsNum + exercisedQuantityNum) && this.mode == "amend"){
	    			trace("exercisingQuantityNum :: " + exercisingQuantityNum);
	    			trace("availableRightsNum :: " + availableRightsNum);
	    			trace("exercisedQuantityNum :: " + exercisedQuantityNum);
	    			exercisedQuantityExceedFlag = true;
	    			break;
	    		}
	    		
	    	}
    		
    	}
    	return tempArray.toArray();
    }
    
    private function showConfirmModule():void{
    	if(mode == "query"){
    		return;
    	}
    	var parentApp :UIComponent = UIComponent(this.parentApplication);
    	var selectedItem:Array = getSelectedRows();
    	if(selectedItem.length < 1){
    		if(this.mode == "entry"){
	    		XenosAlert.error("Select at least one Rights Exercise to Entry");
	    		return;
    		}else if(this.mode == "amend"){
	    		XenosAlert.error("Select at least one Rights Exercise to Amend");
	    		return;
    		}else{
	    		XenosAlert.error("Select at least one Rights Exercise to Cancel");
	    		return;
    		}
    	}
    	if(exercisedQuantityBlankFlag){
    		exercisedQuantityBlankFlag = false;
    		XenosAlert.error("Put at least one valid Exercise Quantity to proceed");
    		return;
    	}
    	if(exercisedQuantityExceedFlag){
    		exercisedQuantityExceedFlag = false;
    		XenosAlert.error("Exercising Quantity can not be greater than the Available Rights Quantity");
    		return;
    	}
    	var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,false));
			if(mode == "entry")
				sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.rights.exercise.entry');
			else if(mode == "amend")
				sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.rights.exercise.amend');
			else
				sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.rights.exercise.cancel');
			/* sPopup.width = parentApplication.width * 50/100;
    		sPopup.height = parentApplication.height * 55/100; */
    		sPopup.width = 620;
    		sPopup.height = 330;
			PopUpManager.centerPopUp(sPopup);
			sPopup.owner = this;
			sPopup.dataObj = queryResult;
			sPopup.moduleUrl = "assets/appl/cax/RightsExerciseEntry.swf"+Globals.QS_SIGN+"mode"+Globals.EQUALS_SIGN+mode+Globals.AND_SIGN+"selectedItems"+Globals.EQUALS_SIGN+selectedItem;
    }
    
    public function isDataAmended(data:Object,originalData:Object):Boolean{
    	if(!XenosStringUtils.equals(data.exercisingQuantity,originalData.exercisingQuantity)
    		|| !XenosStringUtils.equals(data.totalSubscriptionCostStr,originalData.totalSubscriptionCostStr)
    		|| !XenosStringUtils.equals(data.paymentDateCashStr,originalData.paymentDateCashStr)
    		|| !XenosStringUtils.equals(data.paymentDateStr,originalData.paymentDateStr) ){
    			
    			return true;
    			
    	}
    	return false;
    }