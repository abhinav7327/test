
// ActionScript file for Security Registration

 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.controls.XenosQuery;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
// import com.nri.rui.smr.validator.QueryBloombergDataValidator;
 import com.nri.rui.smr.validator.QueryBloombergDataValidator;
 import mx.events.ValidationResultEvent;
 
 import flash.events.Event;
 import flash.events.MouseEvent;
 import flash.net.URLVariables;
 
 import mx.collections.ArrayCollection;
 import mx.core.Application;
 import mx.core.UIComponent;
 import mx.events.CloseEvent;
 import mx.managers.PopUpManager;
 import mx.rpc.events.ResultEvent;
 import flash.net.URLRequest;
 import flash.net.URLRequestMethod;
 import flash.net.navigateToURL;

 
  [Bindable]
   private var summaryResult:ArrayCollection= new ArrayCollection();
 
 
  [Bindable]
  private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
  
  [Bindable]public var mode : String = "query";
  [Bindable]  
  private var keylist:ArrayCollection = new ArrayCollection();

  [Bindable]
  public var queryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
  private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
  [Bindable]
  private var bloomberg:Boolean = false;
  
  public  var i:int = 0;

  private var rndNo:Number; 
  
            [Bindable]       
            public var xmlSource:XML;
  
     
/*   [Bindable]private var selectedIndex : int = -1;  
  [Bindable]private var selectedBoolean : Boolean = false;  
  [Bindable]private var bbUniqueId:String = XenosStringUtils.EMPTY_STR;
 */  
  [Bindable]
  private var sPopup : SummaryPopup;
  
  public function loadAll():void{
  	super.setXenosQueryControl(new XenosQuery());
     rndNo= Math.random();
	var req : Object = new Object();
 	req.SCREEN_KEY = 24;
  	initializeQuery.request = req;    
   	initializeQuery.url = "smr/queryBloombergDataDispatch.action?method=initialExecute&mode=query&rnd=" + rndNo;
 //   	initializeQuery.url = "smr/queryBloombergDataDispatch.action?method=initialExecute&mode=query";
 	
  	if(this.mode == 'query'){
    	this.dispatchEvent(new Event('queryInit'));
    }
   initializeQuery.send();
  }
  
  private function initPage(event: ResultEvent) : void {  
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection;  	

    	     	//Setting value of Market sector
        if(event.result.QueryBloombergDataActionForm.marketSectorValues.item != null) {


            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.QueryBloombergDataActionForm.marketSectorValues.item is ArrayCollection)
//                initColl = event.result.InstrumentQueryActionForm.discountCouponTypeValues.item as ArrayCollection;
                initColl = event.result.QueryBloombergDataActionForm.marketSectorValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.QueryBloombergDataActionForm.marketSectorValues.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
//            discountCouponTypeValues.dataProvider=tempColl;    
            marketSector.dataProvider=tempColl;    
                 	    
        } else {
//            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('smr.instrument.msg.error.initialize.marketSector'));
        } 
	
  }
   
  override public function preQueryInit():void{
     	var rndNo:Number= Math.random();
  	   super.getInitHttpService().url = "smr/queryBloombergDataDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
   	   
  	  /*  var reqObjFect:Object = new Object();
  	   reqObject.SCREEN_KEY = 10073;
  	   super.getInitHttpService().request = reqObject;  */        	
    }
    
  override public function postQueryInit():void{
//	xmlSource = this.xmlSource

    }    
    
  private function addCommonKeys():void{ 
    	keylist = new ArrayCollection();
    	//keylist.addItem("secCodeType.item");
  }  
  override public function preQueryResultInit():Object{
    	addCommonKeys();   	
    	return keylist;        	
    }
  
  override public function postQueryResultInit(mapObj:Object):void{
	  		commonInit(mapObj);
	  		
	  		
	  		
   }
  private function clearCommonFields():void{
  		this.ticker.text = XenosStringUtils.EMPTY_STR;
  		this.cusipSecCode.text = XenosStringUtils.EMPTY_STR;
  		this.isinSecCode.text = XenosStringUtils.EMPTY_STR;
  		this.sedolSecCode.text = XenosStringUtils.EMPTY_STR;
   		this.securityName.text = XenosStringUtils.EMPTY_STR;
  		this.ccyBox.ccyText.text =  XenosStringUtils.EMPTY_STR;
   		//this.instrumentType.itemCombo.text = XenosStringUtils.EMPTY_STR;
  		this.exchngCode.text = XenosStringUtils.EMPTY_STR;
//  		this.country.text = XenosStringUtils.EMPTY_STR;
//  		this.securityType.text = XenosStringUtils.EMPTY_STR;
//  		this.marketSector.text = XenosStringUtils.EMPTY_STR;
  		this.marketSector.selectedItem = XenosStringUtils.EMPTY_STR;
  		this.issueDateFrom.text = XenosStringUtils.EMPTY_STR;
  		this.issueDateTo.text = XenosStringUtils.EMPTY_STR;
  		this.maturityDateFrom.text = XenosStringUtils.EMPTY_STR;
  		this.maturityDateTo.text = XenosStringUtils.EMPTY_STR;
        this.countryPopUp.countryCode.text = XenosStringUtils.EMPTY_STR;

  }
  private function commonInit(mapObj:Object):void{
    	clearCommonFields();
    	errPage.clearError(super.getInitResultEvent());  
    	
/*         var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection;  	

    	     	//Setting value of Market sector
        if(event.result.QueryBloombergDataActionForm.marketSectorValues.item != null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.QueryBloombergDataActionForm.marketSector.item is ArrayCollection)
//                initColl = event.result.InstrumentQueryActionForm.discountCouponTypeValues.item as ArrayCollection;
                initColl = event.result.QueryBloombergDataActionForm.marketSectorValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.QueryBloombergDataActionForm.marketSectorValues.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
//            discountCouponTypeValues.dataProvider=tempColl;    
            marketSector.dataProvider=tempColl;    
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.bondtype'));
        } 
    	
 */    	

    	/* var initcol:ArrayCollection = new ArrayCollection();
        //Security Code Types
        for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
			initcol.addItem(item);
		}
        this.secCodeType.dataProvider = initcol;
        this.secCodeType.selectedIndex = 0;  */
        //Set focus on ticker
       ticker.setFocus();
        app.submitButtonInstance = submit;       
  }    
  

  override public function preQuery():void{
  		setValidator();
    	qh.resetPageNo();	

        super.getSubmitQueryHttpService().url = "smr/queryBloombergDataDispatch.action?";  
        super.getSubmitQueryHttpService().request  =populateRequestParams();
        super.getSubmitQueryHttpService().method="POST";

//dd  		instrumentQueryRequest.send();
    }
   /**
   * Ticker or SedolCode or ISIN Code or Cusip Code is mandatory field for querying
   */

   private function setValidator():void{
	   	var validateModel:Object={
	   					secRegistrationModel:{
	   						ticker:this.ticker.text,
	   						isin:this.isinSecCode.text,
	   						cusip:this.cusipSecCode.text,
	   						sedol:this.sedolSecCode.text,
	   						exchangeCode:this.exchngCode.text,
	   						issueCcy:this.ccyBox.ccyText.text,
	   						marketSector:(this.marketSector.selectedItem !=null ? this.marketSector.selectedItem.value : null),
//	   						marketSector:this.marketSector.itemCombo.text,
//	   						securityType:this.securityType.text,	   						
	   						securityName:this.securityName.text,	   						
	   						IssueDateFrom:this.issueDateFrom.text,
	   						IssueDateTo:this.issueDateTo.text,
	   						maturityDateFrom:this.maturityDateFrom.text,
	   						maturityDateTo:this.maturityDateTo.text,
	   						issueCountry:this.countryPopUp.countryCode.text
//	   						issueCountry:this.country.text
	   						}
	   	};
	   	
	   	super._validator = new QueryBloombergDataValidator();
	   	super._validator.source = validateModel ;
        super._validator.property = "secRegistrationModel"; 
        
   } 
   /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	var reqObj : Object = new Object();
    	reqObj.method= "submitSummary";
    	
    	reqObj.exchangeCode = this.exchngCode.text;
    	reqObj.ticker = this.ticker.text;
    	reqObj.securityName = this.securityName.text;
    	reqObj.issueCcy = this.ccyBox.ccyText.text;
    	reqObj.sedolCode = this.sedolSecCode.text;
    	reqObj.isinCode = this.isinSecCode.text;
    	reqObj.cusipCode = this.cusipSecCode.text;
     	reqObj.issueDateFrom= this.issueDateFrom.text;
    	reqObj.issueDateTo= this.issueDateTo.text;
    	reqObj.maturityDateFrom= this.maturityDateFrom.text;
    	reqObj.maturityDateTo= this.maturityDateTo.text;
//    	reqObj.country= this.country.text;
//    	reqObj.country= this.countryPopUp.countryCode.text
    	reqObj.countryOfIncorp= this.countryPopUp.countryCode.text
//    	reqObj.securityType= this.securityType.text;
//    	reqObj.marketSector= this.marketSector.itemCombo.text;
//    	reqObj.marketSector= this.marketSector.text;

        reqObj.marketSector=(this.marketSector.selectedItem !=null ? this.marketSector.selectedItem.value : "");
    	return reqObj;
    } 
    
/*         private function resultHandler(event:ResultEvent):void{
    	var rs:XML = XML(event.result);
    	trace("result : "+ rs.toXMLString());
    	if (null != event && rs != null) {
    		if(rs.child("Errors").length()>0) {
    			var errorInfoList : ArrayCollection = new ArrayCollection();
				//populate the error info list 			 	
					errorInfoList.addItem(error.toString());
				}
				qerrPage.showError(errorInfoList);//Display the error
    		}else{
    			if(rs.child("registeredSecurity").length() > 0){
    				qerrPage.clearError(event);
    				
    				trace("registeredSecurity :"+rs.registeredSecurity+" : "+rs.isForUpdate);
    				if(rs.isForUpdate == false){
    					//For Addition
	    				if(rs.registeredSecurity == false){
	    					openEntryPopup(false);
	    				}else{
	    					XenosAlert.confirm(this.parentApplication.xResourceManager.getKeyValue('smr.msg.entry.confirm'),handleConfirm);
	    				}
	    			}else{
	    				//Update
	    				if(rs.registeredSecurity == true)
	    					openEntryPopup(false);
	    			}
    			}
    		}
    	}
    }
 */
    
    
    
    
    override public function preQueryResultHandler():Object
	{
		keylist = new ArrayCollection();
/* 		keylist.addItem("rows.row");
 */ 	keylist.addItem("bbresultviews.view");
		keylist.addItem("bbNextTraversable");
		keylist.addItem("bbPreviousTraversable");
		return keylist;
	}
    override public function postQueryResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
    
    private function commonResult(mapObj:Object):void{
    	
    	var result:String = "";
	
     	if(mapObj!=null){   
//    		queryResult1.removeAll(); 		
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		//result = mapObj["errorMsg"] .toString();
	    		errPage.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	    errPage.clearError(super.getSubmitQueryResultEvent());
//	    	    queryResult1=mapObj["rows.row"];
	    	    
	    	    queryResult = mapObj["bbresultviews.view"];
                //resetSelection(queryResult);
//                addPropertiesToBB(); 	
				
				if(queryResult.length > 0){
			    changeCurrentState();
			     //qh1.print.visible = false;
	            //qh1.setOnResultVisibility();
/* 	            qh1.setPrevNextVisibility((mapObj["xpreviousTraversable"] == "true")?true:false,(mapObj["xnextTraversable"] == "true")?true:false );
	            qh1.PopulateDefaultVisibleColumns();
 *//*  	        qh2.xls.visible = true;
			    qh2.pdf.visible= true;
 *///			    qh2.resultHeader.text = "Bloomberg Bulk Details";
			    qh.setOnResultVisibility();
			    qh.setPrevNextVisibility((mapObj["bbPreviousTraversable"] == "true")?true:false,(mapObj["bbNextTraversable"] == "true")?true:false );
 	    		qh.PopulateDefaultVisibleColumns();					
				}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('smr.data.not.found'));
	    	}    		
    	}
    }
    }
    override public function preResetQuery():void{
	    var rndNo:Number= Math.random();
	  	super.getResetHttpService().url = "smr/queryBloombergDataDispatch.action?method=resetQuery&mode=query"+ rndNo;
	}
    override    public function preNext():Object{
   		var reqObj : Object = new Object();
   		if(bloomberg == false)
   			reqObj.method = "doNext";
   		else {
   			reqObj.method = "doBbNext";
   		}	
   		return reqObj;
  	}	
  	override public function prePrevious():Object{
   
   	 	var reqObj : Object = new Object();
   	 	if(bloomberg == false)
  	 		reqObj.method = "doPrevious";
   	else {
   			reqObj.method = "doBbPrevious"; 
   		}
   	 	return reqObj;
  	}	
	private function dispatchBBNextEvent():void{
		bloomberg = true;
		this.dispatchEvent(new Event("next"));
	}
	
	private function dispatchBBPrevEvent():void{
		bloomberg = true;
		this.dispatchEvent(new Event("prev"));
	}
	
	private function dispatchBBPdfEvent():void {
    	var request:URLRequest = new URLRequest("smr/queryBloombergDataDispatch.action?method=generateBloombergPDF");
    	request.method = URLRequestMethod.POST;
    	// set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
		try {
        	navigateToURL(request,"_blank");
        } catch (e:Error) {
			trace(e);
        }
	}
  
	private function dispatchBBXlsEvent():void {
    	var request:URLRequest = new URLRequest("smr/queryBloombergDataDispatch.action?method=generateBloombergXLS");
    	request.method = URLRequestMethod.POST;
    	// set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
		try {
        	navigateToURL(request,"_blank");
        } catch (e:Error) {
			trace(e);
        }
	} 
	
	  	private function loadSummaryPage(event:ResultEvent):void {
     	
		var rs:XML = XML(event.result);
	
 		if (null != event) {
			if(rs.child("view").length()>0) {
			}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('smr.data.not.found'));
			}
			}
	  	}
	  	
			
				
	/* 			errPage.clearError(event);
	            summaryResult.removeAll();
				try {
				    for each ( var rec:XML in rs.view ) {
	 				    summaryResult.addItem(rec);
				    }
				    
				    changeCurrentState();
		            qh.setOnResultVisibility();
		            
		            qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.bbNextTraversable == "true")?true:false );
		            qh.PopulateDefaultVisibleColumns();
	     	        //replace null objects in datagrid with empty string
	            	summaryResult=ProcessResultUtil.process(summaryResult,resultSummary.columns);
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
 */  
         /**
    * It sends/submits the query. 
    * 
    */
/*     private function submitQuery():void 
    {  
    	
//		if(mode=="query"){      
	    	instrumentQueryRequest.url = "ref/instrumentQueryDispatch.action?";
	    	instrumentQueryRequest.url = "smr/queryBloombergDataDispatch.action?";

            instrumentQueryRequest.method="POST";




/* 	    }   
	    else if(mode=="amend"){
	    	instrumentQueryRequest.url = "smr/queryBloombergDataDispatch.action?";
	    }    
	    else {
	    	instrumentQueryRequest.url = "smr/queryBloombergDataDispatch.action?";
	    }      
 */        //Set the request parameters
/*      	var requestObj :Object = populateRequestParams();
     	instrumentQueryRequest.request = requestObj;
     	//instrumentQueryRequest.send(); 
     	
	   	var validateModel:Object={
	   					secRegistrationModel:{
	   						ticker:this.ticker.text,
	   						isin:this.isinSecCode.text,
	   						cusip:this.cusipSecCode.text,
	   						sedol:this.sedolSecCode.text,
	   						exchangeCode:this.exchngCode.text,
	   						issueCcy:this.ccyBox.ccyText.text,
	   						marketSector:this.marketSector.selectedItem,
//	   						marketSector:this.marketSector.itemCombo.text,
//	   						securityType:this.securityType.text,	   						
	   						securityName:this.securityName.text,	   						
	   						IssueDateFrom:this.issueDateFrom.text,
	   						IssueDateTo:this.issueDateTo.text,
	   						maturityDateFrom:this.maturityDateFrom.text,
	   						maturityDateTo:this.maturityDateTo.text,
	   						issueCountry:this.countryPopUp.countryCode.text
//	   						issueCountry:this.country.text
	   						}
	   	};
 */
     	
/* 	   	super._validator = new QueryBloombergDataValidator();
	   	super._validator.source = validateModel ;
        super._validator.property = "secRegistrationModel"; 
 */
/*       	var instrumentQueryValidator:InstrumentQueryValidator = new InstrumentQueryValidator();
     	instrumentQueryValidator.source = myModel;
		instrumentQueryValidator.property = "instrumentQuery";
 */
/*        	var queryBloombergDataValidator:QueryBloombergDataValidator = new QueryBloombergDataValidator();
     	queryBloombergDataValidator.source = validateModel;
		queryBloombergDataValidator.property = "secRegistrationModel";
  		
 		var validationResult:ValidationResultEvent = queryBloombergDataValidator.validate();
     	
     	if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            //trace(errorMsg);
            
            XenosAlert.error(errorMsg);
            
        } else {
     		qh.resetPageNo();
    		instrumentQueryRequest.send();
        }
     	        
    }
 
  
  
  
  
  
 */