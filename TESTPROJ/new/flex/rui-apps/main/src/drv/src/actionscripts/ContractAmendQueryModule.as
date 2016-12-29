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
import com.nri.rui.drv.validators.DrvTradeQueryValidator;
import com.nri.rui.core.utils.HiddenObject;
			
	
	  
   [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
   [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
    private var keylist:ArrayCollection = new ArrayCollection();
   [Bindable]
    private var mode : String = "query";
   [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
	public var actionMode:String = ""; 
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
            
	  
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
       	   if(this.mode == 'query'){
       	   	 this.dispatchEvent(new Event('queryInit'));
       	   	 this.fundCode.setFocus();
       	   	 actionMode = "query";
       	   } else if(this.mode == 'amend'){
       	   	 this.dispatchEvent(new Event('amendInit'));
       	   	 this.fundCode.setFocus();
       	   	 addColumn();
       	   	 actionMode = "amend";
       	   } else { 
       	     this.dispatchEvent(new Event('cancelInit'));
       	   	 this.fundCode.setFocus();
       	   	 addColumn();
       	   	 actionMode = "cancel";
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
        
        override public function preAmendInit():void{
		   	var rndNo:Number= Math.random();
		   	super.getInitHttpService().url = "drv/drvContractAmendQuery.action?&rnd=" + rndNo;
		   	var reqObject:Object = new Object();
		   	reqObject.mode=this.mode;
			reqObject.method="initialExecute";
			reqObject['SCREEN_KEY'] = "11044";
			super.getInitHttpService().request = reqObject;     	
        }        
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();
        	keylist.addItem("dropDownListValues.drvSettlementTypeList.item");
        	keylist.addItem("dropDownListValues.settlementBasisList.item");
	    	
        }
        
        override public function preAmendResultInit():Object{
        	//var keylist:ArrayCollection = new ArrayCollection(); 
        	addCommonKeys();   		    	
	    	return keylist;        	
        }        
        
        private function commonInit(mapObj:Object):void{
        	       	
        	this.fundCode.fundCode.text = "";
        	this.securityId.instrumentId.text = "";
        	this.underlyingSecurityId.instrumentId.text = "";
	    	this.contractReferenceNo.text = "";
	    	this.fundAccountNo.accountNo.text = "";
	    	this.brkAccountNo.accountNo.text = "";
	    	   	
	    	errPage.clearError(super.getInitResultEvent());
	    	
	    	// Set Settlement Type Combo
	    	this.settlementType.dataProvider = mapObj[keylist.getItemAt(0)] as ArrayCollection;
	    	
	    	// Set Settlement Basis Combo
	    	var initcol1:ArrayCollection = new ArrayCollection();
    		initcol1=new ArrayCollection();
	    	initcol1.addItem({label:" ", value: " "});
	    	var index:int=0;
	    	for each(var item:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
	    		initcol1.addItem(item);
	    	}
	    	this.settlementBasis.dataProvider = initcol1;
	    	this.settlementBasis.selectedIndex =0;
	    	
	    	// Set Expiry Status Combo
	    	var initcol2:ArrayCollection = new ArrayCollection();
    		initcol2=new ArrayCollection();
	    	initcol2.addItem({label:" ", value: " "});
	    	initcol2.addItem({label:"OPEN", value: "OPEN"});
	    	initcol2.addItem({label:"EXPIRED", value: "EXPIRED"});
	    	
	    	this.expiryStatus.dataProvider = initcol2;
	    	this.expiryStatus.selectedIndex =0;
	    	 		
        }        
        
        override public function postAmendResultInit(mapObj:Object):void{
        	commonInit(mapObj);
        	this.settlementType.selectedIndex = 0;
        	this.settlementType.enabled = false;	
        }
        
        private function setValidator():void{
			
		}
		
		override public function preAmend():void{
			setValidator();
               qh.resetPageNo();	
            //XenosAlert.info("I am in preAmend ");
            super.getSubmitQueryHttpService().url = "drv/drvContractAmendQuery.action?";   
            super.getSubmitQueryHttpService().request  =populateRequestParams();  
           
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
	        reqObj.inventoryAccountNo = fundAccountNo.accountNo.text;
	        reqObj.cpAccountNo = brkAccountNo.accountNo.text;
	        reqObj.securityId = securityId.instrumentId.text;
	        reqObj.underlyingSecurityId = underlyingSecurityId.instrumentId.text;
	        reqObj.contractReferenceNo = contractReferenceNo.text;
	        reqObj.expiryStatus = this.expiryStatus.selectedItem != null ? this.expiryStatus.selectedItem.value : "";
	        reqObj.settlementBasis = this.settlementBasis.selectedItem != null ? this.settlementBasis.selectedItem.value : "";
	        reqObj['SCREEN_KEY'] = "11045";
	    	
	    	return reqObj;
	    }
	    override public function postAmendResultHandler(mapObj:Object):void{
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
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    	}    		
	    	}
	    	//XenosAlert.info(result);
	    }
        
        override public function preResetAmend():void{
		   var rndNo:Number= Math.random();
		   super.getResetHttpService().url = "drv/drvContractAmendQuery.action?&rnd=" + rndNo;
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="resetQuery";
		  		super.getResetHttpService().request = reqObject;     	
        }       
        
        
        override public function preGenerateXls():String{
        	 var url : String =null;		    		
	    	 url = "drv/drvContractAmendQuery.action?method=generateXLS";
	    	 return url;
        }	
   		override public function preGeneratePdf():String{
           //XenosAlert.info("preGeneratePdf");
    	   var url : String =null;    		
		   url = "drv/drvContractAmendQuery.action?method=generatePDF";
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
