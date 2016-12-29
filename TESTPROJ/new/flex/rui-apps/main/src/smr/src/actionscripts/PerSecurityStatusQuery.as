
// ActionScript file for PerSecurityStatusQuery

 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.controls.XenosQuery;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.smr.validator.PerSecurityStatusQueryValidator;
 
 import flash.events.Event;
 
 import mx.collections.ArrayCollection;
 import mx.rpc.events.ResultEvent;

  [Bindable]
  private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
  
  private var keylist:ArrayCollection = new ArrayCollection();
 
  [Bindable]public var queryResult1:ArrayCollection= new ArrayCollection();
  
  [Bindable]private var selectedIndex : int = -1;
  private var initCompFlg : Boolean = false;
  private var tempColl: ArrayCollection = new ArrayCollection();

  private var sortFieldArray:Array =new Array();
  private var sortFieldDataSet:Array =new Array();
  private var sortFieldSelectedItem:Array =new Array();
  private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
  private var csd:CustomizeSortOrder=null; 
  
  [Bindable]public var mode : String = "query";
  
  public function loadAll():void{
  	super.setXenosQueryControl(new XenosQuery());
  	if(this.mode == 'query'){
    	this.dispatchEvent(new Event('queryInit'));
    }
  }
  
  override public function preQueryInit():void{
    	var rndNo:Number= Math.random();
  	   super.getInitHttpService().url = "smr/perSecurityStatusQueryDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
  	   
  	  /*  var reqObject:Object = new Object();
  	   reqObject.SCREEN_KEY = 10073;
  	   super.getInitHttpService().request = reqObject;  */
  	     
    }
 
  private function addCommonKeys():void{ 
    	keylist = new ArrayCollection();
    	keylist.addItem("requestedStatusValues.item"); 
  }  
  override public function preQueryResultInit():Object{
    	addCommonKeys();   	
    	return keylist;        	
    }  
  
       private function initPageStart():void {            
        if (!initCompFlg) { 
        	var rndNo:Number= Math.random(); 
			var req:Object = new Object();
/* 			reqObject.SCREEN_KEY = 10073     */         
            initializePerSecurityStatusQuery.url = "smr/perSecurityStatusQueryDispatch.action?method=initialExecute&rnd=" + rndNo; 
            initializePerSecurityStatusQuery.request = req;                    
            initializePerSecurityStatusQuery.send();   
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('smr.msg.common.info.alreadyinitiated'));
     }
  
      /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * Once initial data is fetched from database to fill some form data, this method works
    * to actually show the data.
    */   
     private function initPage(event: ResultEvent) : void {
        var i:int = 0;        
        errPage.clearError(event); //clears the errors if any       
    }
    private function sortOrder1Update():void{
         csd.update(sortFieldList1.selectedItem,0);
     } 
     
     private function sortOrder2Update():void{      
        csd.update(sortFieldList2.selectedItem,1);
     }
  
  override public function postQueryResultInit(mapObj:Object):void{
        		commonInit(mapObj);
   }
  private function clearCommonFields():void{
  		
  		this.dateFrom.text = XenosStringUtils.EMPTY_STR;
  		this.dateTo.text = XenosStringUtils.EMPTY_STR;
  		this.userIdPopUp.employeeText.text = XenosStringUtils.EMPTY_STR;
      }
  private function commonInit(mapObj:Object):void{
  	 	
     	clearCommonFields();
    	errPage.clearError(super.getInitResultEvent()); 
    
	    	var initcol:ArrayCollection = new ArrayCollection();
	    	for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
		    this.requestedStatus.dataProvider = initcol ;
        app.submitButtonInstance = submit;
        
        
        
            // Populating sortfield combos
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:"", value: ""});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('smr.persecuritystatusquery.label.requesteddate3'), value: "requestedDate desc"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('smr.persecuritystatusquery.label.userid'), value: "userId"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('smr.persecuritystatusquery.label.requestedstatus'), value: "requestedStatusSeq"});
        sortFieldList1.dataProvider = tempColl;

        sortFieldArray[0]= sortFieldList1;
        sortFieldDataSet[0]=tempColl;
       //Set the default value object
        sortFieldSelectedItem[0] = tempColl.getItemAt(1);   
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('smr.persecuritystatusquery.label.requesteddate3'), value: "requestedDate desc"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('smr.persecuritystatusquery.label.userid'), value: "userId"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('smr.persecuritystatusquery.label.requestedstatus'), value: "requestedStatusSeq"});
        sortFieldList2.dataProvider = tempColl;
                
        sortFieldArray[1]= sortFieldList2;
        sortFieldDataSet[1]=tempColl;
       //Set the default value object
        sortFieldSelectedItem[1] = tempColl.getItemAt(2);
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('smr.persecuritystatusquery.label.requesteddate3'), value: "requestedDate desc"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('smr.persecuritystatusquery.label.userid'), value: "userId"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('smr.persecuritystatusquery.label.requestedstatus'), value: "requestedStatusSeq"});
        sortFieldList3.dataProvider = tempColl;
                
        sortFieldArray[2]= sortFieldList3;
        sortFieldDataSet[2]=tempColl;
       //Set the default value object
        sortFieldSelectedItem[2] = tempColl.getItemAt(3);
               
        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();            
  }    
  
  override public function preQuery():void{
  		setValidator();
    	qh1.resetPageNo();	
       
        super.getSubmitQueryHttpService().url = "smr/perSecurityStatusQueryDispatch.action?";  
        super.getSubmitQueryHttpService().request  =populateRequestParams();
        super.getSubmitQueryHttpService().method="POST";
    }
   /**
   * Ticker or SedolCode or ISIN Code or Cusip Code is mandatory field for querying
   */
   private function setValidator():void{
 	   	var validateModel:Object={
	   					perSecurityStatusQuery:{
                             fromDate:this.dateFrom.text,
                             toDate:this.dateTo.text
	   					}
	   	};
	   	super._validator = new PerSecurityStatusQueryValidator();
	   	super._validator.source = validateModel ;
        super._validator.property = "perSecurityStatusQuery";
    } 
   /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	var reqObj : Object = new Object();
    	reqObj.method= "submitQuery";
    	
    	reqObj.requestedDateTo= this.dateTo.text;
    	reqObj.requestedDateFrom= this.dateFrom.text;
    	reqObj.userId = this.userIdPopUp.employeeText.text;
    	reqObj.requestedStatusSelectedValue = this.requestedStatus.selectedIndices
	
        reqObj.sortField1 = this.sortFieldList1.selectedItem != null ? this.sortFieldList1.selectedItem.value : "";
        reqObj.sortField2 = this.sortFieldList2.selectedItem != null ? this.sortFieldList2.selectedItem.value : "";
        reqObj.sortField3 = this.sortFieldList3.selectedItem != null ? this.sortFieldList3.selectedItem.value : ""; 
  
 		return reqObj;
    } 
    
    override public function preQueryResultHandler():Object
	{
 		keylist = new ArrayCollection();
		keylist.addItem("rows.row");
		keylist.addItem("prevTraversable");
		keylist.addItem("nextTraversable"); 
		
		return keylist;
	}
    override public function postQueryResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
    private function commonResult(mapObj:Object):void{
    	
    	var result:String = "";
    	if(mapObj!=null){
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		//result = mapObj["errorMsg"] .toString();
	    		queryResult1.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	    errPage.clearError(super.getSubmitQueryResultEvent());
	    	    queryResult1=mapObj["rows.row"];
	    	    
	    	    if(queryResult1.length > 0){
	    	    	changeCurrentState();
			        qh1.resultHeader.text = "Query Result";
	    	    
			    /* changeCurrentState(); */
			     //qh1.print.visible = false;
	            qh1.setOnResultVisibility();
	            qh1.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
	            qh1.PopulateDefaultVisibleColumns();		
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('smr.persecuritystatusquery.inf.label.query.noresult'));
	    	}    		
    	}
    }
    }
    override public function preResetQuery():void{
	    var rndNo:Number= Math.random();
	  	super.getResetHttpService().url = "smr/perSecurityStatusQueryDispatch.action?method=resetQuery&mode=query"+ rndNo;
	}
	
	
	    override public function preGenerateXls():String{
	 	var url : String =null;
    	if(mode == "query"){		    		
    	  url = "smr/perSecurityStatusQueryDispatch.action?method=generateXLS";
    	}else if(mode == "amendment"){
    	  url = "smr/perSecurityStatusQueryDispatch.action?method=generateXLS";
    	}else{
    	  url = "smr/perSecurityStatusQueryDispatch.action?method=generateXLS";
    	}
    	return url;
     }
     
     override public function preGeneratePdf():String{
       //XenosAlert.info("preGeneratePdf");
	    var url : String =null;
    	if(mode == "query"){		    		
    	  url = "smr/perSecurityStatusQueryDispatch.action?method=generatePDF";
    	}else if(mode == "amendment"){
    	  url = "smr/perSecurityStatusQueryDispatch.action?method=generatePDF";
    	}else{
    	  url = "smr/perSecurityStatusQueryDispatch.action?method=generatePDF";
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
	
	/**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on teh top panel of the
    * result .
    */
     public function loadPage(event:ResultEvent):void {
        var showPrev:Boolean;
        
        //changeColumnOrder(event);
        
         if (null != event) {            
            if(null == event.result.rows){
                queryResult1.removeAll(); // clear previous data if any as there is no result now.
                if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
                    errPage.clearError(event); //clears the errors if any
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                } else { // Must be error
                    errPage.displayError(event);    
                }                
            }else {
                errPage.clearError(event);                
                queryResult1.removeAll();
                if(event.result.rows.row != null){   
                    if(event.result.rows.row is ArrayCollection) {
                            queryResult1 = event.result.rows.row as ArrayCollection;
                    } else {                            
                            queryResult1.addItem(event.result.rows.row);
                    }
                    changeCurrentState();
                }else{                    
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                }                 
                //replace null objects if any with empty string
                queryResult1=ProcessResultUtil.process(queryResult1,resultSummary1.columns);
                //changeCurrentState();
                qh1.setOnResultVisibility();
                qh1.setPrevNextVisibility(Boolean(event.result.rows.prevTraversable),Boolean(event.result.rows.nextTraversable));
                qh1.PopulateDefaultVisibleColumns();
            }
            //refresh the results.
            queryResult1.refresh(); 
        }else {
            queryResult1.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }  
    } 
