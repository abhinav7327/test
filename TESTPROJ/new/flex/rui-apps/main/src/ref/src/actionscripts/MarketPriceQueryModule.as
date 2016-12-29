// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.ref.validators.MarketPriceQueryValidator;

import mx.collections.ArrayCollection;
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.DataGridEvent;
			
	  //private var mkt:XenosQuery = new MarketPriceQuery();
	  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
     
     private var keylist:ArrayCollection = new ArrayCollection(); 
     
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
     [Bindable]private var mode : String = "query";
            
	  
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
           	   	 this.baseDate.setFocus();
           	   } else if(this.mode == 'amend'){
           	   	 this.dispatchEvent(new Event('amendInit'));
           	   	 this.baseDate.setFocus();
           	   	 addColumn();
           	   } else { 
           	     this.dispatchEvent(new Event('cancelInit'));
           	   	 this.baseDate.setFocus();
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
		  		this.status.includeInLayout = true;
		  		this.status.visible = true;
		  		this.lblStatus.includeInLayout = true;
		  		this.lblStatus.visible = true;
		  		super.getInitHttpService().url = "ref/marketPriceQueryDispatchAction.action?method=initialExecute&&mode=query&&menuType=Y&rnd=" + rndNo; 
		  		var reqObj : Object = new Object();
           		reqObj.SCREEN_KEY= 401; 
           		super.getInitHttpService().request = reqObj;      	
        }
        
        override public function preAmendInit():void{
		   var rndNo:Number= Math.random();
		   super.getInitHttpService().url = "ref/marketPriceQueryAmendDispatchAction.action?&rnd=" + rndNo;
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		super.getInitHttpService().request = reqObject;     	
        }
        
        override public function preCancelInit():void{
		   var rndNo:Number= Math.random();
		   super.getInitHttpService().url = "ref/marketPriceQueryCancelDispatchAction.action?&rnd=" + rndNo;  
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		super.getInitHttpService().request = reqObject;      	
        }        
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("dataSource");
	    	keylist.addItem("dataSourceList.item");
	    	keylist.addItem("inputPriceFormatList.item");
	    	keylist.addItem("priceTypeList.item");	
        }
        
        override public function preQueryResultInit():Object{
        	//var keylist:ArrayCollection = new ArrayCollection(); 
        	addCommonKeys();   	
	    	keylist.addItem("statusList.item");	    	
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
           	app.submitButtonInstance = submit;
        	this.security.instrumentId.text = "";
        	this.security.instrumentId.width = 150;
	    	this.currancy.ccyText.text= "";
	    	//this.remarks.text = "";
	    	this.inputPrice.text = "";
	    	this.executionMarket.text = "";
	    	this.baseDate.text = "";
	    	this.price.text = "";
    		errPage.clearError(super.getInitResultEvent());
    		this.queryResult.removeAll();
	        //errPage.removeError();
    		
	    	var index:int=-1;
	    	var initcol:ArrayCollection = new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	for each(var item:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
	    		initcol.addItem(item);
	    		if(item.value == mapObj[keylist.getItemAt(0)].toString()){
	    			index = (mapObj[keylist.getItemAt(1)] as ArrayCollection).getItemIndex(item);
	    		}
	    	}
		    	
	    	dataSource.dataProvider=initcol; 
	    	dataSource.selectedIndex = index != -1 ? index+1 : 0;
	    	
	    	initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	index=0;
	    	for each(var item:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	inputPriceFormat.dataProvider = initcol;
	    	inputPriceFormat.selectedIndex = 0;
	    	
	    	initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	index=0;
	    	for each(var item:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	priceType.dataProvider = initcol;
	    	priceType.selectedIndex = 0;    		
    		
        }
        
        override public function postQueryResultInit(mapObj:Object):void{
        	commonInit(mapObj);
	
    		var initcol:ArrayCollection = new ArrayCollection();
    		initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	var index:int=0;
	    	for each(var item:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	this.status.dataProvider = initcol;
	    	this.status.selectedIndex =0;
        }
        
        
        override public function postAmendResultInit(mapObj:Object):void{
        	commonInit(mapObj);	
        }
        
        override public function postCancelResultInit(mapObj:Object):void{
        	commonInit(mapObj);	
        }
        
        	private function setValidator():void{
			
    	    var validateModel:Object={
                            marketPriceQuery:{                                 
                                 baseDate:this.baseDate.text
                            }
                           }; 
             super._validator = new MarketPriceQueryValidator();
             super._validator.source = validateModel ;
             super._validator.property = "marketPriceQuery";
		}
		
		override public function preQuery():void{
			setValidator();
               qh.resetPageNo();	
           // XenosAlert.info("I am in preQuery ");
            super.getSubmitQueryHttpService().url = "ref/marketPriceQueryDispatchAction.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
           
		}
		
		override public function preAmend():void{
			setValidator();
               qh.resetPageNo();	
            //XenosAlert.info("I am in preAmend ");
            super.getSubmitQueryHttpService().url = "ref/marketPriceQueryAmendDispatchAction.action?";   
            super.getSubmitQueryHttpService().request  =populateRequestParams();  
           
		}
		
		
		override public function preCancel():void{
			
			setValidator();
			 qh.resetPageNo();	
            //XenosAlert.info("I am in preCancel ");
            super.getSubmitQueryHttpService().url = "ref/marketPriceQueryCancelDispatchAction.action?"; 
            super.getSubmitQueryHttpService().request = populateRequestParams();
           
		}
		
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	
    	reqObj.SCREEN_KEY=402;
    	
    	reqObj.method= "submitQuery";
    	
    	reqObj.baseDate = this.baseDate.text;
    	
    	reqObj.marketId =  executionMarket.itemCombo != null ? executionMarket.itemCombo.text : "" ;
    	
    	reqObj.securityCode = this.security.instrumentId.text;
    	
    	reqObj.dataSource = this.dataSource.selectedItem != null ? this.dataSource.selectedItem.value : "";
    	
    	reqObj.priceType = this.priceType.selectedItem != null ? this.priceType.selectedItem.value : "";
    	
    	reqObj.inputPriceStr = this.inputPrice.text;
    	
    	reqObj.inputPriceFormatStr = this.inputPriceFormat.selectedItem != null ? this.inputPriceFormat.selectedItem.value : "";
    	
    	reqObj.currency = this.currancy.ccyText.text;
    	
    	reqObj.priceStrExp = this.price.text;
    	
    	reqObj.priceStr = "";
    	
    	if(mode == "query"){
    		reqObj.status = this.status.selectedItem != null ? this.status.selectedItem.value : "";
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
		  		super.getResetHttpService().url = "ref/marketPriceQueryDispatchAction.action?method=resetQuery&&mode=query&&menuType=Y&rnd=" + rndNo;        	
        }
        
        override public function preResetAmend():void{
		   var rndNo:Number= Math.random();
		   super.getResetHttpService().url = "ref/marketPriceQueryAmendDispatchAction.action?&rnd=" + rndNo;
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="resetQuery";
		  		super.getResetHttpService().request = reqObject;     	
        }
        
        override public function preResetCancel():void{
		   var rndNo:Number= Math.random();
		   super.getResetHttpService().url = "ref/marketPriceQueryCancelDispatchAction.action?&rnd=" + rndNo;  
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="resetQuery";
		  		super.getResetHttpService().request = reqObject;      	
        }       
        
        
        override    public function preGenerateXls():String{
        	 var url : String =null;
		    	if(mode == "query"){		    		
		    	  url = "ref/marketPriceQueryDispatchAction.action?method=generateXLS";
		    	}else if(mode == "amend"){
		    		url = "ref/marketPriceQueryAmendDispatchAction.action?method=generateXLS";
		    	}else{
		    		url = "ref/marketPriceQueryCancelDispatchAction.action?method=generateXLS";
		    	}
		    	return url;
         }	
   override public function preGeneratePdf():String{
           //XenosAlert.info("preGeneratePdf");
    	   var url : String =null;
		    	if(mode == "query"){		    		
		    	  url = "ref/marketPriceQueryDispatchAction.action?method=generatePDF";
		    	}else if(mode == "amend"){
		    		url = "ref/marketPriceQueryAmendDispatchAction.action?method=generatePDF";
		    	}else{
		    		url = "ref/marketPriceQueryCancelDispatchAction.action?method=generatePDF";
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
			cols.pop();
			resultSummary.columns = cols;
			
		}
