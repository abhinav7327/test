
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.controls.XenosQuery;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.ref.validators.EmployeeQueryValidator;
 
 import mx.collections.ArrayCollection;
 import mx.rpc.events.ResultEvent;
 import mx.utils.StringUtil;
 

 
    [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
   
    [Bindable]
     private var queryResult:ArrayCollection= new ArrayCollection();
     private var keylist:ArrayCollection = new ArrayCollection(); 
     
    [Bindable]
     private var mode : String = "query";
     
     private var sortFieldArray:Array =new Array();
     private var sortFieldDataSet:Array =new Array();
     private var sortFieldSelectedItem:Array =new Array();
     private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    
     private var  csd:CustomizeSortOrder=null;    
    
     private function changeCurrentState():void{
				currentState = "result";
	 }
	 
	 /**
	  * For various query modes i.e. 'query', 'amend', 'cancel','reopen' etc.
	  * Dispatches an event
	  */
	 public function loadAll():void{
	 	parseUrlString();
   	    super.setXenosQueryControl(new XenosQuery());
   	    if(this.mode == 'query'){
   	   	 this.dispatchEvent(new Event('queryInit'));
   	    }else if(this.mode == 'amend'){
   	   	 this.dispatchEvent(new Event('amendInit'))
   	   	 addColumn();
   	    }else if(this.mode == 'cancel'){
   	   	 this.dispatchEvent(new Event('cancelInit'))
   	   	 addColumn();
   	    } 
   	    else if(this.mode == 'reopen'){
   	    	this.dispatchEvent(new Event('reopenInit'))
   	   	 	addColumn();
   	    } 
     }
     /**
     * Extracts the parameters and set them to some variables for query criteria
     * from the Module Loader Info.
     * 
     */ 
     public function parseUrlString():void {
        try {
            var myPattern:RegExp = /.*\?/; 
            var s:String = this.loaderInfo.url.toString();
            s = s.replace(myPattern, "");
            var params:Array = s.split(Globals.AND_SIGN); 
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
          
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
	  	super.getInitHttpService().url = "ref/employeeQueryDispatch.action?method=initialExecute&&mode=query&rnd=" + rndNo;        	
    }
        
        override public function preAmendInit():void{
		   var rndNo:Number= Math.random();
		   super.getInitHttpService().url = "ref/employeeQueryAmendDispatch.action?&rnd=" + rndNo;
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		reqObject.actionType = "edit";
		  		super.getInitHttpService().request = reqObject;     	
        }
        
        override public function preCancelInit():void{
		   var rndNo:Number= Math.random();
		   super.getInitHttpService().url = "ref/employeeQueryCancelDispatch.action?&rnd=" + rndNo;  
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.actionType = "delete";
		  		reqObject.method="initialExecute";
		  		super.getInitHttpService().request = reqObject;      	
        }        
        
    /**
     *  Creates a new XenosHTTPService
     * 
     */
    override public function preReopenInit():void{
    	var rndNo:Number= Math.random();
	    super.getInitHttpService().url = "ref/employeeQueryReopenDispatch.action?&rnd=" + rndNo;  
	    var reqObject:Object = new Object();
	  		reqObject.mode=this.mode;
	  		reqObject.actionType = "REOPEN";
	  		reqObject.method="initialExecute";
	  		super.getInitHttpService().request = reqObject;      	
    }            
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("officeList.officeList");
	    	keylist.addItem("officeApplRoles.item");
	    	keylist.addItem("lockedList.item");
	    	keylist.addItem("sortFieldList1.item");	
	    	keylist.addItem("sortFieldList2.item");	
	    	keylist.addItem("sortFieldList3.item");	
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
    
        override public function preReopenResultInit():Object{
        	//XenosAlert.info("pre reopen result init");
        	addCommonKeys();   		    	
	    	return keylist;        	
        }
    
	    /**
	    * This method works as the result handler of the Initialization/Reset Http Services.
	    * Once initial data is fetched from database to fill some form data, this method works
	    * to actually show the data.
	    */   
        private function commonInit(mapObj:Object):void{
        	this.resetFormValues();
	    	
    		errPage.clearError(super.getInitResultEvent());
    		
    		var sortField1Default:String = "user_id";
        	var sortField2Default:String = "last_name";
        	var sortField3Default:String = "first_name";
        	var tempColl: ArrayCollection = new ArrayCollection();        	
     		var selIndx:int = 0;
     		var item:Object; 
    	
    		var index:int=-1;
	    	var i:int = 0;
	    	var initcol:ArrayCollection = new ArrayCollection();
	    	initcol.addItem(" ");
	    	for each(item in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	officeIdList.dataProvider=initcol; 
	    	 
	    	initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	index=0;
	    	for each(var item:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	applicationRoles.dataProvider = initcol;
	    	
	    	initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	index=0;
	    	for each( item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	lockedList.dataProvider = initcol;
	    	
	    	//----------Start of population of SortField1----------//
	        
	        if(null != mapObj[keylist.getItemAt(3)]){
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
        		tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
	        		for each(var item4:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
		    			initcol.addItem(item4);
		    		}
	        	}else {
	        		initcol.addItem(mapObj[keylist.getItemAt(3)]);
	        	}
		        for(i = 0; i<initcol.length; i++) {
		        	//Get the default value object's index
	                if(XenosStringUtils.equals((initcol[i].value),sortField1Default)){                    
	                    selIndx = i;
	                }
		           tempColl.addItem(initcol[i]);            
	    	}
		        
	    	sortFieldArray[0]=sortField1;
		        sortFieldDataSet[0]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
	        
	        } else {
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.employee.msg.error.load.sortfieldlist', new Array("1")));
	    	}
	        
	        //---------------End of population of SortField1-----------------------//
	        
	        //--------Start of population of sortField2---------//
	        
	        if(null != mapObj[keylist.getItemAt(4)]){
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(4)] is ArrayCollection){
	        		for each(var item5:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
		    			initcol.addItem(item5);
		    		}
	    	}else{
	        		initcol.addItem(mapObj[keylist.getItemAt(4)]);
	        	}
		        for(i = 0; i<initcol.length; i++) {
		        	//Get the default value object's index
	                if(XenosStringUtils.equals((initcol[i].value),sortField2Default)){                    
	                    selIndx = i;
	                }
		           tempColl.addItem(initcol[i]);            
		        }
		        
		        sortFieldArray[1]=sortField2;
		        sortFieldDataSet[1]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
		        
	        } else {
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.employee.msg.error.load.sortfieldlist', new Array("2")));
      		}
	    	
	         //--------End of population of sortField2---------// 
	    	
	         //--------Start of population of sortField3---------//
	        
	        if(null != mapObj[keylist.getItemAt(5)]){
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(5)] is ArrayCollection){
	        		for each(var item6:Object in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
		    			initcol.addItem(item6);
		    		}
	        	}else{
	        		initcol.addItem(mapObj[keylist.getItemAt(5)]);
	        	}
		        for(i = 0; i<initcol.length; i++) {
		        	//Get the default value object's index
	                if(XenosStringUtils.equals((initcol[i].value),sortField3Default)){                    
	                    selIndx = i;
	                }
		        	
		           tempColl.addItem(initcol[i]);            
	    	}
	        
		        sortFieldArray[2]=sortField3;
		        sortFieldDataSet[2]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
		        
	        } else {
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.employee.msg.error.load.sortfieldlist', new Array("3")));
	        } 
	        
	         //--------End of population of sortField3---------//
	        //-------------Initializing the sortfields-------------//
			csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        	csd.init();
	    	firstName.setFocus();
    	}
    	/**
	     * Method for updating the other two sortfields after any change in the sortfield1
        	*/
	     private function sortOrder1Update():void{
	     	 csd.update(sortField1.selectedItem,0);
	     }
	     /**
	     * Method for updating the other two sortfields after any change in the sortfield2
	     */
	     private function sortOrder2Update():void{     	
	     	csd.update(sortField2.selectedItem,1);
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
        
        override public function postReopenResultInit(mapObj:Object):void{
        	//XenosAlert.info("Post Reopen Result Init");
        	commonInit(mapObj);	
        }
        
        private function setValidator():void{
		    var validateModel:Object={
                            employeeQuery:{
                                startDate:this.startDate.text,
                                logDate:this.logDate.text,
                                defaultOffice:this.officeIdList.value//selectedItem
                            }
                           };
            super._validator = new EmployeeQueryValidator();
            super._validator.source = validateModel ;
            super._validator.property = "employeeQuery";
		}
		
		override public function preQuery():void{
			setValidator();
			qh.resetPageNo();
            super.getSubmitQueryHttpService().url = "ref/employeeQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
           
		}
		
		override public function preAmend():void{
			setValidator();
            qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "ref/employeeQueryAmendDispatch.action?";   
            super.getSubmitQueryHttpService().request  =populateRequestParams();
		}
		
		
		override public function preCancel():void{
			setValidator();
			qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "ref/employeeQueryCancelDispatch.action?"; 
            super.getSubmitQueryHttpService().request = populateRequestParams();
           
		}
    
	override public function preReopen():void{
		setValidator();
		qh.resetPageNo();	
        super.getSubmitQueryHttpService().url = "ref/employeeQueryReopenDispatch.action?"; 
        super.getSubmitQueryHttpService().request = populateRequestParams();
           
	}
    
    
  /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on teh top panel of the
    * result.
    */
     private function commonResult(mapObj:Object):void{
    	var result:String = "";
    	if(mapObj!=null){
    		if(mapObj["errorFlag"].toString() == "error"){
	    		queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	   errPage.clearError(super.getSubmitQueryResultEvent());
	           queryResult.removeAll();
	           queryResult=mapObj["row"];
			   changeCurrentState();
		       qh.setOnResultVisibility();
		       qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
		       qh.PopulateDefaultVisibleColumns();
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
	    	}
    	}
    	//XenosAlert.info(result);
    }   
     
     /**
     *  This method resets all the values in the form.
     */
     private function resetFormValues():void {
     	this.title.text = "";
     	this.middleName.text = "";
     	this.firstName.text = "";
     	this.lastName.text = "";
     	this.startDate.text = "";
     	this.logDate.text = "";
     	this.userId.text = "";
     	var tempCollApplRoles: ArrayCollection = new ArrayCollection();
		this.applicationRoles.dataProvider = tempCollApplRoles;
     }     
   
     
    
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	reqObj.SCREEN_KEY = 62;
     	reqObj.method = "submitQuery";
     	
     	reqObj.lastLogDateStr = this.logDate.text;
     	reqObj.locked = (this.lockedList.selectedItem!=null) ? this.lockedList.selectedItem.value : "";
     	reqObj.userId = this.userId.text;
     	reqObj.defaultOffice = (this.officeIdList.selectedItem != null ? this.officeIdList.selectedItem : "");
     	reqObj.title      = this.title.text;
     	reqObj.firstName  = this.firstName.text;
     	reqObj.middleInitial = this.middleName.text;
     	reqObj.lastName   = this.lastName.text;
     	reqObj.startDateStr = this.startDate.text;
	    	reqObj.selectedApplnRole = (this.applicationRoles.selectedItem != null ? this.applicationRoles.selectedItem.value : "");
     	reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : Globals.EMPTY_STRING;
        reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : Globals.EMPTY_STRING;
        reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : Globals.EMPTY_STRING;
     	
     	if(mode == "query"){
     		
     	}else if(mode == "amend"){
     		reqObj.actionType = "edit";
     	}else if(mode == "cancel"){
     		reqObj.actionType = "delete";
     	}
     	else if(mode == "reopen"){
     		reqObj.actionType = "REOPEN";
     	}
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
    
    override public function postReopenResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
    
    
    override public function preResetQuery():void{
		 var rndNo:Number= Math.random();
		 super.getResetHttpService().url = "ref/employeeQueryDispatch.action?method=resetQuery&&mode=query&rnd=" + rndNo;        	
    }
      
	override public function preResetAmend():void{
		   var rndNo:Number= Math.random();
		   super.getResetHttpService().url = "ref/employeeQueryAmendDispatch.action?&rnd=" + rndNo;
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.actionType = "edit";
		  		reqObject.method="resetQuery";
		  		super.getResetHttpService().request = reqObject;     	
        }
        
     override public function preResetCancel():void{
		   var rndNo:Number= Math.random();
		   super.getResetHttpService().url = "ref/employeeQueryCancelDispatch.action?&rnd=" + rndNo;  
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="resetQuery";
		  		super.getResetHttpService().request = reqObject;      	
      }       
        
	override public function preResetReopen():void{
		var rndNo:Number= Math.random();
		super.getResetHttpService().url = "ref/employeeQueryReopenDispatch.action?&rnd=" + rndNo;  
		var reqObject:Object = new Object();
		reqObject.mode=this.mode;
		reqObject.method="resetQuery";
		super.getResetHttpService().request = reqObject;      	
    }        
        
    
      override    public function preGenerateXls():String{
        	 var url : String =null;
		    	if(mode == Globals.MODE_QUERY){		    		
		    	  url = "ref/employeeQueryDispatch.action?method=generateXLS";
		    	}else if(mode == Globals.MODE_AMEND){
		    		url = "ref/employeeQueryAmendDispatch.action?method=generateXLS";
		    	}else if(mode == Globals.MODE_CANCEL){
		    		url = "ref/employeeQueryCancelDispatch.action?method=generateXLS";
		    	}else if(mode == Globals.MODE_REOPEN){
		    		url = "ref/employeeQueryReopenDispatch.action?method=generateXLS";
		    	}
		    	return url;
      }	
      override public function preGeneratePdf():String{
           var url : String =null;
		    	if(mode == Globals.MODE_QUERY ){		    		
		    	  url = "ref/employeeQueryDispatch.action?method=generatePDF";
		    	}else if(mode == Globals.MODE_AMEND){
		    		url = "ref/employeeQueryAmendDispatch.action?method=generatePDF";
		    	}else if(mode == Globals.MODE_CANCEL){
		    		url = "ref/employeeQueryCancelDispatch.action?method=generatePDF";
		    	}else if(mode == Globals.MODE_REOPEN){
		    		url = "ref/employeeQueryReopenDispatch.action?method=generatePDF";
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
      private function addColumn():void
      {
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
	  
	   private function populateApplicationRoles(event: ResultEvent): void{
   		var i:int = 0;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection = new ArrayCollection();
        
        if(event.result.employeeQueryActionForm.applRoleNames.item!=null){
	        tempColl.addItem({label:" ", value: " "});
	        if(event.result.employeeQueryActionForm.applRoleNames.item is ArrayCollection)
	        	initColl = event.result.employeeQueryActionForm.applRoleNames.item as ArrayCollection;
	        else
	        	initColl.addItem(event.result.employeeQueryActionForm.applRoleNames.item);	
	         for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
             applicationRoles.dataProvider=tempColl; 
        	
        }else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.employee.msg.error.load.applrolelist'));
        } 
    }
    
    
     /**
 	* This method sets the Application Roles for the corresponding Office Id
 	* in Employee Query Page.
 	*/
 	private function setApplicationRoles() : void { 
        if(String(StringUtil.trim(this.officeIdList.text)).length != 0) {
        	//XenosAlert.info("setApplicationRoles:"+this.officeIdList.selectedItem);
       		var reqObj : Object = new Object();
       		reqObj.defaultOffice = (this.officeIdList.selectedItem != null ? this.officeIdList.selectedItem : "");
        	//reqObj.officeId=this.officeIdList.selectedItem;
        	if(this.mode == "query"){		    		
        	initializeApplicationRoles.url="ref/employeeQueryDispatch.action?method=loadApplRoleNames";	
		    }else if(mode == "amend"){
		    	  initializeApplicationRoles.url = "ref/employeeQueryAmendDispatch.action?method=loadApplRoleNames";
		    }else if(mode=="cancel"){
		    	  initializeApplicationRoles.url = "ref/employeeQueryCancelDispatch.action?method=loadApplRoleNames";
		    }
		    else if(mode=="reopen"){
		    	  initializeApplicationRoles.url = "ref/employeeQueryReopenDispatch.action?method=loadApplRoleNames";
		    }
        	
        	//initializeApplicationRoles.url="ref/employeeQueryDispatch.action?method=loadApplRoleNames";	
        	initializeApplicationRoles.send(reqObj);
        	
        }else {
        	var tempColl: ArrayCollection = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	applicationRoles.dataProvider=tempColl;
        }        	
	}