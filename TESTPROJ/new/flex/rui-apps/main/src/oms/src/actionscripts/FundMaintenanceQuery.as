// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.oms.renderers.FundMaintenanceDetailRenderer;

import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;



[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]private var mode : String = "";
private var keylist:ArrayCollection = new ArrayCollection();
private var  csd:CustomizeSortOrder=null;   
private var sortFieldArray:Array =new Array();
private var sortFieldDataSet:Array =new Array();
private var sortFieldSelectedItem:Array =new Array() 
private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
[Bindable]private var queryResult:ArrayCollection= new ArrayCollection();

 		/**
    	 * At the time of loading the module if the module specific Resource is not loaded then load them
    	 */ 
    	public function loadResourceBundle():void{
        	var locales:String = this.parentApplication.xResourceManager.localeChain[0];
        	var resourceModuleURL:String = "assets/appl/oms/omsResources_" + locales + ".swf";
        	var bundle:ResourceBundle = ResourceBundle(resourceManager.getResourceBundle(locales, "omsResources"));
        	var eventDispatcher:IEventDispatcher = null;
           		if(bundle == null){    
            		eventDispatcher = this.parentApplication.xResourceManager.loadResourceModule(resourceModuleURL);
            		eventDispatcher.addEventListener(ResourceEvent.ERROR, errorHandler);            
        	}        
        	this.parentApplication.xResourceManager.update();
    	}
    	
    	/**
		 * Error handler for loading the resource bundle for OMS
		 */     
    	private function errorHandler(event:ResourceEvent):void{
        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('oms.msg.common.info.resource.bundle.erroroccurred', new Array(event.errorText)));
    	}
    	
    	 /**
    	 * Checks the mode of operation
    	 * invoked at creation complete of the Page
    	 */ 
		public function loadAll():void{
	   		parseUrlString();
		  	super.setXenosQueryControl(new XenosQuery());
		  	if(this.mode == 'query'){
		   		this.dispatchEvent(new Event('queryInit'));
		  	} else if(this.mode == 'amend'){
		   		this.dispatchEvent(new Event('amendInit'));
		   		addExtraColumn();
		  	} else { 
				this.dispatchEvent(new Event('cancelInit'));
		   		addExtraColumn();
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
                        }else if(tempA[0] == "fundInstrParticipantPk"){
                          //  this.fundInstrParticipantPk = tempA[1];
                        } 
                    }
                }else{
                	mode = "query";
                }                 

            } catch (e:Error) {
                trace(e);
            }               
        }
        
      	/**
	 	*This method should be called on creationComplete of the datagrid 
	 	*/ 
	 	private function bindDataGrid():void {
	 		//addExtraColumn();
			qh.dgrid = fundMaintenanceSummary;
		}
        
         /**
     	  * In case of Delete Operation Mode Add Extra column in the result columns.
     	  */    
   		 private function addExtraColumn():void {
            var delColumn:DataGridColumn = new DataGridColumn();
            delColumn.headerText = "";
            delColumn.draggable=false;
            delColumn.resizable=false;
            delColumn.width = 40;
            delColumn.itemRenderer = new  RendererFectory(FundMaintenanceDetailRenderer, mode);
            
            //delColumn.
            var colArray:Array = fundMaintenanceSummary.columns;
            var customArray:Array = new Array();
            
            customArray.push(colArray[0]);
            customArray.push(delColumn);
            for(var i:int=1; i<colArray.length;i++){
                customArray.push(colArray[i]);
            }
            
            fundMaintenanceSummary.columns = customArray;
            
            qh.startIndex = 2; // To list list the columns from the 3rd column
      
    }  
        
        /**
	     * Method for updating the other three sortfields after any change in the sortfield1
         */
	    private function sortOrder1Update():void{
	     	 csd.update(sortField1.selectedItem, 0);
	    } 
	    
	     /**
	     * Method for updating the other three sortfields after any change in the sortfield2
         */
	    private function sortOrder2Update():void{
	     	 csd.update(sortField2.selectedItem, 1);
	    } 
        
        /**
        * Method to reset the Page for Query
        */ 
        override public function preResetQuery():void{
        	   errPage.clearError(super.getInitResultEvent());
		       var rndNo:Number= Math.random();
		  	   super.getResetHttpService().url = "oms/fundMaintenanceQuery.action?method=resetQuery&mode="+mode+"&rnd=" + rndNo;        	
        }
        /**
        * Method to reset the Page for Amend Query
        */ 
        override public function preResetAmend():void{
        	   errPage.clearError(super.getInitResultEvent());
		       super.getResetHttpService().url = "oms/fundMaintenanceAmendQuery.action?method=resetQuery&mode="+mode;        	
        }
        
        /**
        * Method to reset the Page for Cancel
        */ 
        override public function preResetCancel():void{
		  	   errPage.clearError(super.getInitResultEvent());
		       var rndNo:Number= Math.random();
		  	   super.getResetHttpService().url = "oms/fundMaintenanceQueryForCancel.action?method=resetQuery&mode="+mode+"&rnd=" + rndNo;        	    	
        }  
         
       /**
       * Initial execute of the query page
       */ 
       override public function preQueryInit():void{
	        var rndNo:Number= Math.random();
	  		super.getInitHttpService().url = "oms/fundMaintenanceQuery.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
        }
        
        /**
        * Result handler of the initial execute
        */ 
        override public function preQueryResultInit():Object{
        	addCommonKeys();   	
	    	return keylist;        	
        }
        
        /**
        * Displays the default fields in the UI . Also checks for errors.
        */ 
        override public function postQueryResultInit(mapObj:Object):void{
        	if(!checkError(mapObj))
        		commonInit(mapObj);
        }
        /**
       	* Initial execute of the amend query page
       	*/
        override public function preAmendInit():void{
	   		super.getInitHttpService().url = "oms/fundMaintenanceAmendQuery.action?";
		    var reqObject:Object = new Object();
		  	reqObject.mode=this.mode;
		  	reqObject.method="initialExecute";
		  	reqObject.actionType = "edit";
		  	super.getInitHttpService().request = reqObject;
		  	//make hidden status field
		  	this.statusList.visible= false;
		  	this.statuslbl.visible= false;
		  	
        }
        override public function preAmendResultInit():Object{
        	addCommonKeys();   		    	
	    	return keylist;        	
        }
        override public function postAmendResultInit(mapObj:Object):void{
        	if(!checkError(mapObj))
        		commonInit(mapObj);
        }
        
        override public function preCancelInit():void{
          removeStatusField();
		  var rndNo:Number= Math.random();
	      super.getInitHttpService().url = "oms/fundMaintenanceQueryForCancel.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
        }  
        
        override public function preCancelResultInit():Object{
        	addCommonKeys();   	
	    	return keylist;   	
        }
        
        override public function postCancelResultInit(mapObj:Object):void{
        	if(!checkError(mapObj))
        		commonInit(mapObj);
        }
        
        /**
    	 * 
    	 */ 
    	override public function preQuery():void{
            qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "oms/fundMaintenanceQuery.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
            super.getSubmitQueryHttpService().method = "POST";
		}
		
		/**
    	 * 
    	 */ 
		override public function postQueryResultHandler(mapObj:Object):void{
    		if(!commonResult(mapObj)){
    			errPage.removeError();
    		}
    	}
    	
    	override public function postAmendResultHandler(mapObj:Object):void{
    		if(!commonResult(mapObj)){
    			errPage.removeError();
    		}
    	}
    	
    	override public function preAmend():void{
			qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "oms/fundMaintenanceAmendQuery.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
            super.getSubmitQueryHttpService().method = "POST";
		}
    	
    	/**
    	 * 
    	 */ 
    	override public function preCancel():void{
            qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "oms/fundMaintenanceQueryForCancel.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
            super.getSubmitQueryHttpService().method = "POST";
		}
		
		override public function postCancelResultHandler(mapObj:Object):void{
    		if(!commonResult(mapObj)){
    			errPage.removeError();
    		}
    	}
    	
        /**
        * Fields added to the key list for the display of default value
        */ 
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();
	    	keylist.addItem("Errors.error");
	    	keylist.addItem("buySellFlag.item");
	    	keylist.addItem("upDownFlag.item");
	    	keylist.addItem("sortFieldList1.item");	
	    	keylist.addItem("sortFieldList2.item");
	    	keylist.addItem("sortFieldList3.item");
	    	keylist.addItem("statusList.item");	    
        }
        
         /**
        * Checks for errors and displays the same if any.
        */ 
        private function checkError(mapObj:Object):Boolean{
    		if(mapObj["Errors.error"] != null){
	    		if(mapObj["Errors.error"].toString().length > 0){
	    		  errPage.showError(mapObj["Errors.error"]);
	    		  return true;
	    		}
    		}
    		else{      	
				errPage.clearError(super.getInitResultEvent());
        	}
        	return false;
        }
        
        /**
        * Diplays the common fields.
        */ 
        private function commonInit(mapObj:Object):void{
        	var tempColl: ArrayCollection = new ArrayCollection();
        	var sortField1Default:String = "fund_code";
        	var sortField2Default:String = "security_id";
        	var sortField3Default:String = "buy_sell_flag";
        	
        	fundPopUp.fundCode.text = "";
        	instPopUp.instrumentId.text = "";
        	var i:int = 0;
        	var selIndx:int = 0;
        	
        	var initcol:ArrayCollection = new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	for each(var item:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
		    	
		    buySellFlag.dataProvider = initcol ;
        	
        	initcol = new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
		    	
		    roundUpDownFlag.dataProvider = initcol ;
		    
		    initcol = new ArrayCollection();
		    initcol.addItem({label:" ", value: " "});
	    	for each(var item1:Object in (mapObj[keylist.getItemAt(6)] as ArrayCollection)){
	    		initcol.addItem(item1);
	    	}
		    
		    statusList.dataProvider = initcol;
		    
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
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('oms.msg.error.load.sortfieldlist', new Array("1")));
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
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('oms.msg.error.load.sortfieldlist', new Array("2")));
      		}
	    	
	         //--------End of population of sortField2---------// 
	         
	         //----------Start of population of SortField3----------//
	        
	        if(null != mapObj[keylist.getItemAt(5)]){
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
        		tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	if(mapObj[keylist.getItemAt(5)] is ArrayCollection){
	        		for each(item4 in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
		    			initcol.addItem(item4);
		    		}
	        	}else {
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
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('oms.msg.error.load.sortfieldlist', new Array("3")));
	    	}
	        
	        //---------------End of population of SortField3-----------------------//
	         
	         csd = new CustomizeSortOrder(sortFieldArray, sortFieldDataSet, sortFieldSelectedItem);
        	 csd.init();
        	 this.fundPopUp.fundCode.setFocus();
        }
		
		/**
    	 * This method will populate the request parameters for the
    	 * submitQuery call and bind the parameters with the HTTPService
   	     * object.
    	 */
   		 private function populateRequestParams():Object {
    	
    		var reqObj : Object = new Object();
    		
    		reqObj.fundCode 	  	  = this.fundPopUp.fundCode.text;
    		reqObj.securityId   	  = this.instPopUp.instrumentId.text;
    		reqObj.buySellFlag        = this.buySellFlag.selectedItem != null ? this.buySellFlag.selectedItem.value:"";
    		reqObj.roundUpDown        = this.roundUpDownFlag.selectedItem != null ? this.roundUpDownFlag.selectedItem.value:"";
    		if(XenosStringUtils.equals(mode, Globals.MODE_QUERY)) {             	
            	reqObj.status = this.statusList.selectedItem != null ? this.statusList.selectedItem.value:"";
	        } else {
	            reqObj.status = Globals.STATUS_NORMAL; 
	        } 
    		reqObj.sortField1 		  = this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "";
        	reqObj.sortField2 		  = this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "";
        	reqObj.sortField3 		  = this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "";
    		reqObj.method= "submitQuery";
    		return reqObj;
    	}
		
		
    	/**
    	 * 
    	 */ 
    	private function commonResult(mapObj:Object):Boolean{    	
    	var result:String = "";
    	if(mapObj!=null){   
    		//XenosAlert.info("mapObj : "+mapObj.toString()); 		
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		//result = mapObj["errorMsg"] .toString();
	    		queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    		return true;
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	   errPage.clearError(super.getSubmitQueryResultEvent());
               queryResult.removeAll();
               queryResult=mapObj["row"];
			   changeCurrentState();
	           qh.setOnResultVisibility();
	           //qh.print.enabled = false;
	           qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
	           qh.PopulateDefaultVisibleColumns();
	    		
	    	}else{
	    		errPage.removeError();
	    		queryResult.removeAll();
	    		currentState = "";
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}   	
    	}
    	return false;
    	//XenosAlert.info(result);
    } 
    	/**
    	 * 
    	 */ 
    	private function changeCurrentState():void{
				currentState = "result";
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
        override  public function preGenerateXls():String{
        		var url : String =null;
		    	if(mode == "query"){		    		
		    	  url = "oms/fundMaintenanceQuery.action?method=generateXLS";
		    	}else if(mode == "amend"){
		    		url = "oms/fundMaintenanceAmendQuery.action?method=generateXLS";
		    	}else{
		    		url = "oms/fundMaintenanceQueryForCancel.action?method=generateXLS";
		    	}
		    	return url;
        }	
        
         override public function preGeneratePdf():String{
           		var url : String =null;
		    	if(mode == "query"){		    		
		    	  url = "oms/fundMaintenanceQuery.action?method=generatePDF";
		    	}else if(mode == "amend"){
		    		url = "oms/fundMaintenanceAmendQuery.action?method=generatePDF";
		    	}else{
		    		url = "oms/fundMaintenanceQueryForCancel.action?method=generatePDF";
		    	}
		    	return url;
          }	
          
     /**
     * In case of Cancel Operation Mode Disable the status field. 
     */ 
     private function removeStatusField():void {
            statuslbl.includeInLayout = false;
            statuslbl.visible = false;
            statusList.includeInLayout = false;
            statusList.visible = false;
    } 
              