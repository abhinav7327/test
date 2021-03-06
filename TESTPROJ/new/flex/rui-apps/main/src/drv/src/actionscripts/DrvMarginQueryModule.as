// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.ProcessResultUtil;

import mx.collections.ArrayCollection;
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.DataGridEvent;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.drv.validators.DrvMarginQueryValidator;
			
	
	  
   [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
   [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
    private var keylist:ArrayCollection = new ArrayCollection(); 
	private var sortFieldArray:Array =new Array();
	private var sortFieldDataSet:Array =new Array();
	private var sortFieldSelectedItem:Array =new Array();
	private var  csd:CustomizeSortOrder=null; 
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
   [Bindable]
    private var mode : String = "marginquery";
   [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
	public var actionMode:String = "";
            
	  
		/**
		 *  datagrid header release event handler to handle datagridcolumn sorting
		 */
		public function dataGrid_headerRelease(evt:DataGridEvent):void {				
			//sortUtil.clickedColumn=evt.dataField;
			var dg:DataGrid = DataGrid(evt.currentTarget);
		    sortUtil.clickedColumn = dg.columns[evt.columnIndex];		
		}
		
		private function changeCurrentState():void{
			currentState = "result";
		}
			 
       public function loadAll():void{
       	   parseUrlString();
       	   super.setXenosQueryControl(new XenosQuery());
       	   //XenosAlert.info("mode : "+mode);
       	   if(this.mode == 'marginquery'){
       	   	 this.dispatchEvent(new Event('queryInit'));
       	   	 this.fundCode.setFocus();
       	   	 actionMode = "marginquery";
       	   } else if(this.mode == 'marginamend'){
       	   	 this.dispatchEvent(new Event('amendInit'));
       	   	 this.fundCode.setFocus();
       	   	 addColumn();
       	   	 actionMode = "marginamend";
       	   } else { 
       	     this.dispatchEvent(new Event('cancelInit'));
       	   	 this.fundCode.setFocus();
       	   	 addColumn();
       	   	 actionMode = "margincancel";
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
                	mode = "marginquery";
                }                 

            } catch (e:Error) {
                trace(e);
            }               
        }
        
        override public function preQueryInit():void{
	       	var rndNo:Number= Math.random();
	  		this.status.includeInLayout = true;
	  		this.status.visible = true;
	  		super.getInitHttpService().url = "drv/drvMarginQuery.action?method=initialExecute&&mode=marginquery&&menuType=Y&SCREEN_KEY=11032&rnd=" + rndNo;        	
        }
        
        override public function preAmendInit():void{
		   	var rndNo:Number= Math.random();
		   	super.getInitHttpService().url = "drv/drvMarginAmendQuery.action?&rnd=" + rndNo;
		   	var reqObject:Object = new Object();
		   	reqObject.mode=this.mode;
			reqObject.method="initialExecute";
			reqObject['SCREEN_KEY'] = "11034";
			super.getInitHttpService().request = reqObject;     	
        }
        
        override public function preCancelInit():void{
		   	var rndNo:Number= Math.random();
		   	super.getInitHttpService().url = "drv/drvMarginCancelQuery.action?&rnd=" + rndNo;  
		   	var reqObject:Object = new Object();
		  	reqObject.mode=this.mode;
		  	reqObject.method="initialExecute";
		  	reqObject['SCREEN_KEY'] = "11039";
		  	super.getInitHttpService().request = reqObject;      	
        }        
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();
	    	keylist.addItem("dropDownListValues.marginTypeList.item");	    	
	    	keylist.addItem("sortFieldList1.item");
	    	keylist.addItem("sortFieldList2.item");
	    	keylist.addItem("sortFieldList3.item");	    	
	    	keylist.addItem("sortField1");
	    	keylist.addItem("sortField2");
	    	keylist.addItem("sortField3");
        }
        
        override public function preQueryResultInit():Object{
        	//var keylist:ArrayCollection = new ArrayCollection(); 
        	addCommonKeys();   	
	    	keylist.addItem("dropDownListValues.statusList.item");	    	
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
        
        
        private function commonInit(mapObj:Object):void{
        	
        	var i:int = 0;
	        var selIndx:int = 0;
	        var dateStr:String = null;
	        var tempColl: ArrayCollection = new ArrayCollection();
	        var initColl:ArrayCollection = new ArrayCollection();
        
   	        //variables to hold the default values from the server
	        var sortField1Default:String = mapObj[keylist.getItemAt(4)];
	        var sortField2Default:String = mapObj[keylist.getItemAt(5)];
	        var sortField3Default:String = mapObj[keylist.getItemAt(6)];

        	
        	this.fundCode.fundCode.text = "";
        	this.fundAccountNo.accountNo.text = "";
	    	this.brkAccountNo.accountNo.text = "";
        	this.securityId.instrumentId.text = "";
	    	this.trddateFrom.text = "";
	    	this.trddateTo.text = "";
	    	this.trdReferenceNo.text = "";
	    	this.marginReferenceNo.text = "";
	    	this.baseDate.text = "";
	    	this.marginCcy.ccyText.text = "";
	    	   	
	    	errPage.clearError(super.getInitResultEvent());
	    	// Set Open Close List Combo box
	    	this.marginType.dataProvider = mapObj[keylist.getItemAt(0)] as ArrayCollection;
	    	
	        //Initialize sortFieldList1.
	        if(null != mapObj[keylist.getItemAt(1)]){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(1)] is ArrayCollection){
		            initColl = mapObj[keylist.getItemAt(1)] as ArrayCollection;
		       		for each(var item1:Object in initColl){
		                //Get the default value object's index
		                if(XenosStringUtils.equals(item1.value,sortField1Default)){                    
		                    selIndx = initColl.getItemIndex(item1);
		                }
		                   tempColl.addItem(item1);            
		            }
		            sortFieldArray[0]=sortField1;
			        sortFieldDataSet[0]=tempColl;
			        //Set the default value object
			        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
		            
		        } 
	        }else {
	            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.alert.value.sortorder.one'));
	        }
	        
	        //Initialize sortFieldList2.
	        if(null != mapObj[keylist.getItemAt(2)]){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx=0;
	            if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
		            initColl = mapObj[keylist.getItemAt(2)] as ArrayCollection;
		            for each(var item2:Object in initColl){
		                //Get the default value object's index
		                if(XenosStringUtils.equals(item2.value,sortField2Default)){                    
		                    selIndx = initColl.getItemIndex(item2);
		                }
		                tempColl.addItem(item2);            
		            }
	            
		            sortFieldArray[1]=sortField2;
			        sortFieldDataSet[1]=tempColl;
			        //Set the default value object
			        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);		            
		        }
	        } else {
	            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.alert.value.sortorder.two'));
	        }
	        
	        //Initialize sortFieldList3.
	        if(null != mapObj[keylist.getItemAt(3)]){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx = 0;
	            
	            if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
		            initColl = mapObj[keylist.getItemAt(3)] as ArrayCollection;
		            for each(var item3:Object in initColl){
		                //Get the default value object's index
		                if(XenosStringUtils.equals(item3.value,sortField3Default)){                    
		                    selIndx = initColl.getItemIndex(item3);
		                }
		                
		                tempColl.addItem(item3);            
		            }
	            
		            sortFieldArray[2]=sortField3;
			        sortFieldDataSet[2]=tempColl;
			        //Set the default value object
			        sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
			       
		        } 
	        }else {
	            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.alert.value.sortorder.three'));
	        }  
	        
	        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
			csd.init();  		
        }
        
        private function sortOrder1Update():void{
	    	csd.update(sortField1.selectedItem,0);
	    }
	     
	    private function sortOrder2Update():void{     	
	    	csd.update(sortField2.selectedItem,1);
	    }
	     
        override public function postQueryResultInit(mapObj:Object):void{
        	commonInit(mapObj);
	
    		var initcol:ArrayCollection = new ArrayCollection();
    		initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	var index:int=0;
	    	for each(var item:Object in (mapObj[keylist.getItemAt(7)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	this.status.dataProvider = initcol;
	    	this.status.selectedIndex =0;
	    	
	    	var initcol1:ArrayCollection = new ArrayCollection();
    		initcol1=new ArrayCollection();
	    	initcol1.addItem({label:" ", value: " "});
	    	var index1:int=0;
	    	for each(var item1:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
	    		initcol1.addItem(item1);
	    	}
	    	this.marginType.dataProvider = initcol1;
	    	this.marginType.selectedIndex =0;
        }
        
        
        override public function postAmendResultInit(mapObj:Object):void{
        	commonInit(mapObj);
        	this.satatusLebel.visible = false;
        	this.status.visible = false;
        	this.marginType.selectedIndex = 1;
        	this.marginType.enabled = false;	
        }
        
        override public function postCancelResultInit(mapObj:Object):void{
        	commonInit(mapObj);
        	this.satatusLebel.visible = false;
        	this.status.visible = false;
        	this.marginType.selectedIndex = 1;
        	this.marginType.enabled = false;	
        }
        
        private function setValidator():void{
			 var drvMarginModel:Object={
                            drvQuery:{
                                tradeDateFrom : this.trddateFrom.text,
                                tradeDateTo : this.trddateTo.text
                            }
                           }; 
	        super._validator = new DrvMarginQueryValidator();
	        super._validator.source = drvMarginModel;
	        super._validator.property = "drvQuery";
		}
		
		override public function preQuery():void{
			setValidator();
               qh.resetPageNo();	
           // XenosAlert.info("I am in preQuery ");
            super.getSubmitQueryHttpService().url = "drv/drvMarginQuery.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
           
		}
		
		override public function preAmend():void{
			setValidator();
               qh.resetPageNo();	
            //XenosAlert.info("I am in preAmend ");
            super.getSubmitQueryHttpService().url = "drv/drvMarginAmendQuery.action?";   
            super.getSubmitQueryHttpService().request  =populateRequestParams();  
           
		}
		
		
		override public function preCancel():void{
			
			setValidator();
			 qh.resetPageNo();	
            //XenosAlert.info("I am in preCancel ");
            super.getSubmitQueryHttpService().url = "drv/drvMarginCancelQuery.action?"; 
            super.getSubmitQueryHttpService().request = populateRequestParams();
           
		}
		
	    /**
	    * This method will populate the request parameters for the
	    * submitQuery call and bind the parameters with the HTTPService
	    * object.
	    */
	    private function populateRequestParams():Object {
	    	
	    	var reqObj : Object = new Object();
	    	
	    	reqObj.method= "submitQuery";
	    	
	    	reqObj.fundCode = fundCode.fundCode.text;
	    	reqObj.securityId = securityId.instrumentId.text;
	        reqObj.inventoryAccountNo = fundAccountNo.accountNo.text;
	        reqObj.cpAccountNo = brkAccountNo.accountNo.text;
			reqObj.tradeReferenceNo = trdReferenceNo.text;
			reqObj.marginReferenceNo = marginReferenceNo.text;
			reqObj.tradeDateFrom = trddateFrom.text;
	        reqObj.tradeDateTo = trddateTo.text;
	        reqObj.baseDate = baseDate.text;
	        reqObj.marginType = (this.marginType.selectedItem != null ? marginType.selectedItem.value : XenosStringUtils.EMPTY_STR);         
	        reqObj.marginCcy = marginCcy.ccyText.text;
	        
			reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
			reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
			reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;
	
	    	    	
	    	if(mode == "marginquery"){
	    		reqObj.status = this.status.selectedItem != null ? this.status.selectedItem.value : "";
	    		reqObj['SCREEN_KEY'] = "11033";
	    	}
	    	if(mode == "marginamend"){
	    		reqObj['SCREEN_KEY'] = "11035";
	    	}
	    	if(mode == "margincancel"){
	    		reqObj['SCREEN_KEY'] = "11040";
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
       
        
	    private function commonResult(mapObj:Object):void{    	
	    	//XenosAlert.info("mapObj : "+mapObj.toString()); 
	    	//var mapObj:Object = mkt.userQueryResultEvent(event,null);
	    	var result:String = "";
	    	if(mapObj!=null){   
	    		//XenosAlert.info("mapObj : "+mapObj.toString()); 		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		//result = mapObj["errorMsg"] .toString();
		    		queryResult.removeAll();
		    		errPage.showError(mapObj["errorMsg"]);
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    	   errPage.clearError(super.getSubmitQueryResultEvent());
		    	   //errPage.removeError();
		    	  // XenosAlert.info("I am in errPage ");
	               queryResult.removeAll();
		    	  // XenosAlert.info("I am in queryResult : "+currentState);
	               queryResult=mapObj["row"];
				   changeCurrentState();
	               qh.setOnResultVisibility();
	               qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
	               qh.PopulateDefaultVisibleColumns();
	               queryResult.refresh();
		    		
		    	}else{
		    		errPage.removeError();
		    		queryResult.removeAll();
		    		currentState = "";
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));		    		
		    	}    		
	    	}
	    	//XenosAlert.info(result);
	    }   
       
      
        override public function preResetQuery():void{
		    var rndNo:Number= Math.random();
		  	super.getResetHttpService().url = "drv/drvMarginQuery.action?method=resetQuery&&mode=marginquery&&menuType=Y&SCREEN_KEY=11032&rnd=" + rndNo;        	
        }
        
        override public function preResetAmend():void{
		   	var rndNo:Number= Math.random();
		   	super.getResetHttpService().url = "drv/drvMarginAmendQuery.action?&rnd=" + rndNo;
		    var reqObject:Object = new Object();
	  		reqObject.mode=this.mode;
	  		reqObject.method="resetQuery";
	  		reqObject['SCREEN_KEY'] = "11034";
	  		super.getResetHttpService().request = reqObject;     	
        }
        
        override public function preResetCancel():void{
		   	var rndNo:Number= Math.random();
		   	super.getResetHttpService().url = "drv/drvMarginCancelQuery.action?&rnd=" + rndNo;  
		    var reqObject:Object = new Object();
	  		reqObject.mode=this.mode;
	  		reqObject.method="resetQuery";
	  		reqObject['SCREEN_KEY'] = "11039";
	  		super.getResetHttpService().request = reqObject;      	
        }       
        
        
        override public function preGenerateXls():String{
	    	 var url : String =null;	
	    	 
	    	 if(this.mode == 'marginquery'){
       	   	 	url = "drv/drvMarginQuery.action?method=generateXLS";
	       	   } else if(this.mode == 'marginamend'){
	       	   	 url = "drv/drvMarginAmendQuery.action?method=generateXLS";
	       	   } else { 
	       	     url = "drv/drvMarginCancelQuery.action?method=generateXLS";
	       	   }
	    	 	    		
	    	 return url;
        }	
   		override public function preGeneratePdf():String{
           //XenosAlert.info("preGeneratePdf");
    	   var url : String =null;    
    	   
    	   if(this.mode == 'marginquery'){
   	   	 	 url = "drv/drvMarginQuery.action?method=generatePDF";
       	   } else if(this.mode == 'marginamend'){
       	   	 url = "drv/drvMarginAmendQuery.action?method=generatePDF";
       	   } else { 
       	     url = "drv/drvMarginCancelQuery.action?method=generatePDF";
       	   }
    	   		
		   return url;
        }	
            
   		override public function preNext():Object{
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
			cols.pop();
			resultSummary.columns = cols;
			
		}
		
		
		/**
	      * This is the method to pass the Collection of data items
	      * through the context to the account popup. This will be implemented as per specifdic  
	      * requriment. 
	      */
	    private function populateContext():ArrayCollection {
	        //pass the context data to the popup
	        var myContextList:ArrayCollection = new ArrayCollection(); 
	      
	        //passing account type
	        var acTypeArray:Array = new Array(1);
	            acTypeArray[0]="T|B";            
	        myContextList.addItem(new HiddenObject("invActTypeContext",acTypeArray));  
	        
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
	    private function populateInvActContext():ArrayCollection {
	        //pass the context data to the popup
	        var myContextList:ArrayCollection = new ArrayCollection(); 
	      
	        //passing account type
	        var acTypeArray:Array = new Array(1);
	            acTypeArray[0]="T|B";
	            
	        myContextList.addItem(new HiddenObject("invActTypeContext",acTypeArray));
	        
	        //passing counter party type                
	        var cpTypeArray:Array = new Array(1);
	            cpTypeArray[0]="BROKER";
	            
	        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
	        return myContextList;
	    }
