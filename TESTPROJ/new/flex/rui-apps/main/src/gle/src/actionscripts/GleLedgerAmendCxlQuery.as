// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.gle.renderers.GleLedgerSummaryRenderer;

import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
			
	 [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     [Bindable]
   	 private var queryResult:ArrayCollection= new ArrayCollection();
     
     private var keylist:ArrayCollection = new ArrayCollection(); 
     
     [Bindable]private var mode : String = "query";
     
     private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    
     [Bindable]
     private var ledgerTypeValuesList:ArrayCollection=null;
     [Bindable]
     private var statusValuesList:ArrayCollection=null;
     [Bindable]
     private var subCodeTypeValuesList:ArrayCollection=null;
	  
	 private function changeCurrentState():void{
				currentState = "result";
	 }
			 
           public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosQueryControl(new XenosQuery());           	   
           	   if(this.mode == 'query'){
           	   	 this.dispatchEvent(new Event('queryInit'));
           	   } else if(this.mode == 'amend'){
           	   	 this.dispatchEvent(new Event('amendInit'));
           	   	 addColumn();
           	   } else { 
           	     this.dispatchEvent(new Event('cancelInit'));
           	   	 addColumn();
           	   }
           	   
           	   if(mode!="query"){
           	   		status.visible=false;
           	   		status.includeInLayout=false;
           	   		statuslabel.visible=false;
           	   		statuslabel.includeInLayout=false;
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
            var req : Object = new Object();
   			req.SCREEN_KEY = 292;
    	    super.getInitHttpService().request = req;         
            super.getInitHttpService().url = "gle/gleLedgerQueryDispatchAction.action?method=initialExecute&mode=query&rnd=" + rndNo;
        }
        
        override public function preAmendInit():void{
		    var rndNo:Number= Math.random();
		    super.getInitHttpService().url = "gle/gleLedgerAmendQueryDispatchAction.action?rnd=" + rndNo;
		    var reqObject:Object = new Object();
		  	reqObject.mode="amend";
		  	reqObject.method="initialExecute";
		  	reqObject.SCREEN_KEY = 292;
		  	super.getInitHttpService().request = reqObject;     	
        }
        
        override public function preCancelInit():void{
		   var rndNo:Number= Math.random();
		   super.getInitHttpService().url = "gle/gleLedgerCxlQueryDispatchAction.action?&rnd=" + rndNo;  
		   var reqObject:Object = new Object();
		   reqObject.mode="cancel";
		   reqObject.method="initialExecute";
		   reqObject.SCREEN_KEY = 292;
		   super.getInitHttpService().request = reqObject;      	
        }        
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("ledgerTypeValuesList.item");   	
	    	keylist.addItem("statusValuesList.item");   	
	    	keylist.addItem("subCodeTypeValuesList.item");	    	
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
        	
        	this.lCode.text="";
        	this.sName.text="";
        	this.lName.text="";
        	
        		
        	ledgerTypeValuesList=new ArrayCollection();
        	ledgerTypeValuesList.addItem({label: "" , value : ""});
        	for each(var objLedgerTypeValuesList:Object in mapObj["ledgerTypeValuesList.item"] as ArrayCollection){
        		ledgerTypeValuesList.addItem(objLedgerTypeValuesList)
        	}
        	
        	statusValuesList=new ArrayCollection();
	        statusValuesList.addItem({label: "" , value : ""});
	        for each(var objStatusValuesList:Object in mapObj["statusValuesList.item"] as ArrayCollection){
	        	statusValuesList.addItem(objStatusValuesList);
	        }
	        
	        subCodeTypeValuesList=new ArrayCollection();
	        subCodeTypeValuesList.addItem({label: "" , value : ""});
	        for each(var objSubCodeTypeValuesList:Object in mapObj["subCodeTypeValuesList.item"] as ArrayCollection){
	       		subCodeTypeValuesList.addItem(objSubCodeTypeValuesList);
	        }
	        
        	ledgerTypeValuesList.refresh();
        	statusValuesList.refresh();
        	subCodeTypeValuesList.refresh();
	        	
    		errPage.clearError(super.getInitResultEvent());
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
        
        	/* private function setValidator():void{
			
    	    var validateModel:Object={
                            marketPriceQuery:{                                 
                                 baseDate:this.baseDate.text
                            }
                           }; 
             super._validator = new MarketPriceQueryValidator();
             super._validator.source = validateModel ;
             super._validator.property = "marketPriceQuery";
		} */
		
		override public function preQuery():void{
			//setValidator();
            qh.resetPageNo();	           
            super.getSubmitQueryHttpService().url = "gle/gleLedgerQueryDispatchAction.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
            super.getSubmitQueryHttpService().method="POST";
           
		}
		
		override public function preAmend():void{
			qh.resetPageNo();	           
            super.getSubmitQueryHttpService().url = "gle/gleLedgerAmendQueryDispatchAction.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
            super.getSubmitQueryHttpService().method="POST";
           
		}
		
		
		override public function preCancel():void{
			
			//setValidator();
			qh.resetPageNo();	           
            super.getSubmitQueryHttpService().url = "gle/gleLedgerCxlQueryDispatchAction.action?";
            super.getSubmitQueryHttpService().request  =populateRequestParams();
            super.getSubmitQueryHttpService().method="POST";
           
		}
		
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	
    	reqObj.SCREEN_KEY = 779;
    	reqObj.method = "submitQuery";
    	reqObj.ledgerCode = this.lCode.text;
    	reqObj.ledgerType = this.ltype.selectedItem !=null ? this.ltype.selectedItem.value :"";
    	reqObj.shortName = this.sName.text;
    	reqObj.subcodeType = this.sCodeType.selectedItem !=null ? this.sCodeType.selectedItem.value :"";
    	reqObj.longName = this.lName.text;
    	reqObj.status = this.status.selectedItem !=null ? this.status.selectedItem.value :"";
    	
    	reqObj.rnd = Math.random() + "";
    	return reqObj;
    	
    	
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
	    		//result = mapObj["errorMsg"] .toString();
	    		queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	   errPage.clearError(super.getSubmitQueryResultEvent());
	    	   //errPage.removeError();
	    	  
               queryResult.removeAll();
	    	 
               queryResult=mapObj["row"];
			   changeCurrentState();
		            qh.setOnResultVisibility();
		            qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
		            qh.PopulateDefaultVisibleColumns();
	    		
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('gle.label.norecord.found'));
	    	}    		
    	}
    	
    }   
       
      
        override public function preResetQuery():void{
		       var rndNo:Number= Math.random();
		  	   super.getResetHttpService().url = "gle/gleLedgerQueryDispatchAction.action?method=initialExecute&mode=query&rnd=" + rndNo;        	
        }
        
        override public function preResetAmend():void{
		  	   var rndNo:Number= Math.random();
		  	   super.getResetHttpService().url = "gle/gleLedgerAmendQueryDispatchAction.action?method=initialExecute&mode=amend&rnd=" + rndNo;
		}
        
        override public function preResetCancel():void{
		  		var rndNo:Number= Math.random();
		  	   super.getResetHttpService().url = "gle/gleLedgerCxlQueryDispatchAction.action?method=initialExecute&mode=cancel&rnd=" + rndNo;      	
        }       
        
        
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */   
     override   public function preGenerateXls():String{
        	 var url : String =null;
        	  if(mode=="amend"){
        	 	url = "gle/gleLedgerAmendQueryDispatchAction.action?method=generateXLS";
        	 }else if(mode=="cancel"){
        	 	 url = "gle/gleLedgerCxlQueryDispatchAction.action?method=generateXLS";
        	 } else{
        		 url = "gle/gleLedgerQueryDispatchAction.action?method=generateXLS";
        	 }
        	 
        	 
		    	return url;
         }	
         
    /**
    * This will generate the Pdf report for the entire query result set 
    * and will open in a separate window.
    */    
  	 override public function preGeneratePdf():String{
           var url : String =null;
    	    
    	   	 if(mode=="amend"){
        	 	url = "gle/gleLedgerAmendQueryDispatchAction.action?method=generatePDF";
        	 }else if(mode=="cancel"){
        	 	 url = "gle/gleLedgerCxlQueryDispatchAction.action?method=generatePDF";
        	 } else{
        		 url = "gle/gleLedgerQueryDispatchAction.action?method=generatePDF";
        	 }
		  
		    	return url;
          }
    
	 public function getStatus(item:Object, column:DataGridColumn):String{
	   	if(item=="cancel"){
	   		return "CXL"
	   	}
	  return " ";  	
	 }
            
    override    public function preNext():Object{
    	   var reqObj : Object = new Object();
    	   reqObj.method = "doNext";
    	   reqObj.rnd = Math.random()+"";
    	   return reqObj;
         }	
    override public function prePrevious():Object{
    	   
    	    var reqObj : Object = new Object();
    	    reqObj.method = "doPrevious";
    	    reqObj.rnd = Math.random()+"";
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
			dg.itemRenderer = new RendererFectory(GleLedgerSummaryRenderer);
			
			var cols :Array = resultSummary.columns;
			cols.unshift(dg);
			resultSummary.columns = cols;
			
		}
		
	
