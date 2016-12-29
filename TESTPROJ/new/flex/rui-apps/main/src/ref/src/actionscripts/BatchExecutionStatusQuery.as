// ActionScript file

import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.ProcessResultUtil;
import mx.collections.ArrayCollection;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
private var initCompFlg : Boolean = false;
private var rndNo:Number = 0;
private var i:int = 0;
private var keylist:ArrayCollection = new ArrayCollection(); 
import com.nri.rui.ref.validators.BatchExecutionStatusQueryValidator;
import com.nri.rui.core.controls.XenosAlert;
[Bindable]private var commandFormId : String = XenosStringUtils.EMPTY_STR; 
[Bindable]public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable] private var batchNameList:ArrayCollection = null;
[Bindable] private var executionStatusList:ArrayCollection = null;
[Bindable] private var mode : String = "query";
[Bindable] private var defaultUser: String = "SYSTEM";
[Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
private var sortUtil: ProcessResultUtil = new ProcessResultUtil();
    
       
	    	 public function loadAll():void{
	           	   parseUrlString();
	           	   super.setXenosQueryControl(new XenosQuery());        
	           	   if(this.mode == 'query'){
	           	  	 this.dispatchEvent(new Event('queryInit'));
	           	   }  else { 
	           	     this.dispatchEvent(new Event('cancelInit'));
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
                    	mode = "QUERY";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }                      	         
            }  
       
        override public function preQueryInit():void {
        	var req1 : Object = new Object();
            req1.SCREEN_KEY = "12132";
            super.getInitHttpService().url = "ref/batchExecutionStatusQueryDispatch.action?method=initialExecute";
            super.getInitHttpService().request = req1; 
        }
       
        override public function preResetQuery():void {
		    super.getResetHttpService().url = "ref/batchExecutionStatusQueryDispatch.action?method=initialExecute";    	
        }
        
        private function addCommonKeys():void{  
     
        	keylist = new ArrayCollection();      	
	    	
	    	keylist.addItem("executionDateStr");
	       	keylist.addItem("batchNameList.item");
	       	keylist.addItem("executionStatusList.item");	
	       
        }
        
        override public function preQueryResultInit():Object{
        	addCommonKeys();   	
	      	return keylist;        	
        }
        
   		override public function preQuery():void {
		    setValidator(); 
            qh.resetPageNo();	           
            super.getSubmitQueryHttpService().url = "ref/batchExecutionStatusQueryDispatch.action?"; 
            super.getSubmitQueryHttpService().request  = populateRequestParams();
            super.getSubmitQueryHttpService().method="POST";
           
		}
        
        
        override public function postQueryResultInit(mapObj:Object):void {
         	
        	commonInit(mapObj);
	    		
        }
        
        private function setValidator():void{
		 	 var validateModel:Object={
                            batchExecutionStatusQuery:{
                                 
                               executionDate:this.executionDate.text
                                        
                            }
                           }; 
	         super._validator = new BatchExecutionStatusQueryValidator();
	         super._validator.source = validateModel ;
	         super._validator.property = "batchExecutionStatusQuery";
		}

    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */  
    private function commonInit(mapObj:Object) : void{   	 
        //clears the errors if any      
        errPage.clearError(super.getInitResultEvent());
        
        // Setting Execution Date 
        executionDate.text =  mapObj[keylist.getItemAt(0)].toString();
        
        //Setting Fund Code
        fundPopUp.fundCode.text =  XenosStringUtils.EMPTY_STR; 
        
        //Setting User ID
        userId.text =  defaultUser;
        
        //Setting Error Status Only
        errorStatusOnly.selected = true;
                
                // Populate Batch Name Combo Box
                batchNameList = new ArrayCollection();
	        	batchNameList.addItem({label: " " , value : " "});
	        	
	        	for each(var obj1:Object in mapObj["batchNameList.item"] as ArrayCollection){
	        		batchNameList.addItem(obj1);
	        	}
	        	
	        	batchNameList.refresh();
	        	
	        	// Populate Execution Status Combo Box
	        	executionStatusList = new ArrayCollection();
	        	executionStatusList.addItem({label: " " , value : " "});
	        	
	        	for each(var obj2:Object in mapObj["executionStatusList.item"] as ArrayCollection){
	        		executionStatusList.addItem(obj2);
	        	}
	        	
	        	executionStatusList.refresh();
    }
    
    
    
    
    override public function postQueryResultHandler(mapObj:Object):void{
    		commonResult(mapObj);
  	 	}
    
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
			        changeCurrentStates();
		            qh.setOnResultVisibility();
		            qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
		            qh.PopulateDefaultVisibleColumns();
		    	}else{
		    		errPage.removeError();
		    		queryResult.removeAll();
		    		qh.resetPageNo();
		    		qh.setPrevNextVisibility(false,false);
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    	}    		
	    	}
    	
        }   
        
   /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        var reqObj : Object = new Object();
        reqObj["SCREEN_KEY"] = "12133";
        reqObj["method"] = "submitQuery";        
        reqObj["batchName"] = this.batchName.selectedItem != null?this.batchName.selectedItem.label :XenosStringUtils.EMPTY_STR; 
        reqObj["executionDate"] = this.executionDate.text;
        reqObj["fundCode"] = this.fundPopUp.fundCode.text;       
        reqObj["userId"] = this.userId.text; 
        reqObj["executionStatus"] = this.executionStatus.selectedItem != null?this.executionStatus.selectedItem.label :XenosStringUtils.EMPTY_STR;
        reqObj["errorStatusOnly"] = this.errorStatusOnly.selected == true ? "true" : "false"; 
        
        return reqObj;
    } 
          override   public function preGenerateXls():String{
        	 var url : String =null;
        	
		    	 if(mode == "query"){		    		
		    	  url = "ref/batchExecutionStatusQueryDispatch.action?method=generateXLS";
		    	}else{
		    		url = "ref/batchExecutionStatusQueryDispatch.action?method=generateXLS";
		    	} 
		    	return url;
         }	
        override public function preGeneratePdf():String{
    	    var url : String =null;
    	   
		    	if(mode == "query"){
		    	  url = "ref/batchExecutionStatusQueryDispatch.action?method=generatePDF";
		    	}else{
		    		url = "ref/batchExecutionStatusQueryDispatch.action?method=generatePDF";
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
          
          private function dispatchPrintEvent():void {
              this.dispatchEvent(new Event("print"));
          }  
          private function dispatchPdfEvent():void {
               this.dispatchEvent(new Event("pdf"));
          }  
          private function dispatchXlsEvent():void {
              this.dispatchEvent(new Event("xls"));
          }   
          private function dispatchNextEvent():void{
              this.dispatchEvent(new Event("next"));
          }  
          private function dispatchPrevEvent():void{
              this.dispatchEvent(new Event("prev"));
          }          	