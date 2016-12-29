
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.controls.XenosQuery;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 
 import flash.events.Event;
 
 import mx.collections.ArrayCollection;
 import mx.events.ResourceEvent;
 import mx.resources.ResourceBundle;
 
  //Items returning through context - Non display objects for accountPopup
 [Bindable]
 public var returnContextItem:ArrayCollection = new ArrayCollection();
 [Bindable]
 private var summaryResult:ArrayCollection= new ArrayCollection();

 [Bindable]
 private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);   
 [Bindable]
 private var mode : String = "closeoutquery";
 [Bindable]
 private var queryResult:ArrayCollection= new ArrayCollection();  
 private var keylist:ArrayCollection = new ArrayCollection(); 
 [Bindable]
 public var actionMode:String = "query"; //actionMode for opening the TradeDetails screen
 
  private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
   /**
     * Loading the initial configuaration.
     * 
     */
    public function loadAll():void{
    	parseUrlString();
    	
   	   super.setXenosQueryControl(new XenosQuery());
   	   this.fundPopUp.fundCode.setFocus();
   	   if(this.mode == "closeoutquery"){
   	   	 //XenosAlert.info("Dispatch queryInit Event ");
   	   	 expiryStatusLbl.includeInLayout = true;
   	   	 expiryStatusLbl.visible = true;
   	   	 expiryStatus.includeInLayout = true;
   	   	 expiryStatus.visible = true;
   	   	 this.dispatchEvent(new Event('queryInit'));
   	   	 this.fundPopUp.fundCode.setFocus();
   	   } else if(this.mode == "closeoutentry"){      	
   	   	 this.dispatchEvent(new Event('amendInit'));
   	   	 this.fundPopUp.fundCode.setFocus();	
   	   }else{
   	   	  //XenosAlert.info(mode);
   	   	  this.dispatchEvent(new Event('cancelInit'));
   	   	  this.fundPopUp.fundCode.setFocus();
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
	                            mode = tempA[1];
	                            //XenosAlert.info("mode param = " + tempA[1]);
	                        }
	                    }                    	
                    }else{
                    	mode = "closeoutquery";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }               
            }
    /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specific  
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
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
        
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
            
        myContextList.addItem(new HiddenObject("actTypeContext",acTypeArray));
        
        //passing counter party type                
        var cpTypeArray:Array = new Array(1);
            cpTypeArray[0]="BROKER";
            
        myContextList.addItem(new HiddenObject("cpTypeContext",cpTypeArray));

        return myContextList;
    }
    private function changeCurrentState():void{
		currentState = "result";
		app.submitButtonInstance = null;
	}
	
	override public function preQueryInit():void{
       var rndNo:Number= Math.random();
  	   super.getInitHttpService().url = "drv/drvCloseOut.action?method=initialExecute&mode=closeoutquery&rnd=" + rndNo;
  	   
  	   var reqObject:Object = new Object();
  	   reqObject.SCREEN_KEY = 10088;
  	   super.getInitHttpService().request = reqObject;         	
    }
	override public function preAmendInit():void{
       var rndNo:Number= Math.random();
  	   super.getInitHttpService().url = "drv/drvCloseOutEntry.action?method=initialExecute&mode=closeoutentry&rnd=" + rndNo;
  	   
  	   var reqObject:Object = new Object();
  	   reqObject.SCREEN_KEY = 10079;
  	   super.getInitHttpService().request = reqObject;         	
    }
	override public function preCancelInit():void{
       var rndNo:Number= Math.random();
  	   super.getInitHttpService().url = "drv/drvCloseOutCancel.action?method=initialExecute&mode=closeoutcancel&rnd=" + rndNo;
  	   
  	   var reqObject:Object = new Object();
  	   reqObject.SCREEN_KEY = 10084;
  	   super.getInitHttpService().request = reqObject;         	
    }
	
//   private function addCommonKeys():void{  
//    	keylist = new ArrayCollection();      	
//    	keylist.addItem("marketPriceNotFoundValues.marketPriceNotFound");
//    	keylist.addItem("baseDateStr");
//   } 	
//	

   override public function preQueryResultInit():Object{
    	keylist = new ArrayCollection();  
    	keylist.addItem("expiryStatusList.item");  	
    	return keylist;        	
    }	
   
   private function clearCommonFields():void{
    	
    	this.fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;
    	this.actPopUp.accountNo.text = XenosStringUtils.EMPTY_STR;
    	this.brkAccountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
    	this.securityId.instrumentId.text = XenosStringUtils.EMPTY_STR;
    	this.contractReferenceNo.text = XenosStringUtils.EMPTY_STR;
//    	this.trdReferenceNo.text = XenosStringUtils.EMPTY_STR;
//    	this.basedate.text = XenosStringUtils.EMPTY_STR;
    }
   
//   private function commonInit(mapObj:Object):void{
//   }
   override public function postAmendResultInit(mapObj:Object):void{ 
   		clearCommonFields();
        errPage.clearError(super.getInitResultEvent());   	
   }
   override public function postCancelResultInit(mapObj:Object):void{ 
   		clearCommonFields();
        errPage.clearError(super.getInitResultEvent());   	
        this.fundPopUp.fundCode.setFocus();
   }
   override public function postQueryResultInit(mapObj:Object):void{  
   	  	   		
   		var initcol:ArrayCollection = new ArrayCollection();
   		clearCommonFields();
        errPage.clearError(super.getInitResultEvent());
        
        this.fundPopUp.fundCode.setFocus();
        this.securityId.instrumentId.width = 150;
        
        initcol.addItem({label:" ", value: " "});
        for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
			initcol.addItem(item);
    	}
    	
    	this.expiryStatus.dataProvider = initcol;
    	expiryStatus.selectedIndex = 0;
    	
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
                for(var itr:int=0; itr < queryResult.length;itr++){
                	//XenosAlert.info("item.totalclosedoutqty : " +queryResult[itr].totalClosedOutQty);
                	if(Number(queryResult[itr].totalClosedOutQty) > 0){
                		queryResult[itr].showDetailFlag = true;
                	} else{
                	  queryResult[itr].showDetailFlag = false;                		
                	} 
                	queryResult[itr].rowNo = itr;
                }
                queryResult.refresh();
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
   }
   
   override public function preQuery():void{
		//setValidator();
		qh.resetPageNo();	
       // XenosAlert.info("I am in preQuery ");
        super.getSubmitQueryHttpService().url = "drv/drvCloseOut.action?";  
        var robj:Object =populateRequestParams();
        robj.SCREEN_KEY = 10089;
        super.getSubmitQueryHttpService().request  =robj;
        super.getSubmitQueryHttpService().method="POST";
       
	}
   override public function preAmend():void{
		//setValidator();
		qh.resetPageNo();	
       // XenosAlert.info("I am in preQuery ");
        super.getSubmitQueryHttpService().url = "drv/drvCloseOutEntry.action?";  
        var robj:Object =populateRequestParams();
        robj.SCREEN_KEY = 10080;
        super.getSubmitQueryHttpService().request  =robj;
        super.getSubmitQueryHttpService().method="POST";
       
	}
   override public function preCancel():void{
		//setValidator();
		qh.resetPageNo();	
       // XenosAlert.info("I am in preQuery ");
        super.getSubmitQueryHttpService().url = "drv/drvCloseOutCancel.action?";  
        var robj:Object =populateRequestParams();
        robj.SCREEN_KEY = 10085;
        super.getSubmitQueryHttpService().request  =robj;
        super.getSubmitQueryHttpService().method="POST";
       
	}
   
//   private function setValidator():void{
//   	var validateModel:Object={
//   			drvUnrealizedPL :{
//   				baseDate : this.basedate.text
//   			}
//   	};
//   	super._validator = new DrvUnrealizedPLValidator();
//   	super._validator.source = validateModel ;
//    super._validator.property = "drvUnrealizedPL";
//   }
   /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	reqObj.method= "submitQuery";    	
    	reqObj.fundCode = this.fundPopUp.fundCode.text;
    	reqObj.inventoryAccountNo = this.actPopUp.accountNo.text;
    	reqObj.cpAccountNo = this.brkAccountNo.accountNo.text;
    	reqObj.securityId = this.securityId.instrumentId.text;
    	reqObj.contractRefNo = this.contractReferenceNo.text;
    	if(mode == 'closeoutquery'){
    	  reqObj.expiryStatus = (this.expiryStatus.selectedItem != null ? this.expiryStatus.selectedItem.value : "");    	    		
    	}
    	reqObj.rnd = Math.random() + "";
    	return reqObj;
    }
    	     	
   override public function preResetQuery():void{
	    var rndNo:Number= Math.random();
	  	super.getResetHttpService().url = "drv/drvCloseOut.action?";
	  	var reqObject:Object = new Object();
		reqObject.method = "resetQuery";
		reqObject.SCREEN_KEY = 10088;
		reqObject.rnd = rndNo;
		super.getResetHttpService().request = reqObject;          	
    }
   override public function preResetAmend():void{
	    var rndNo:Number= Math.random();
	  	super.getResetHttpService().url = "drv/drvCloseOutEntry.action?";
	  	var reqObject:Object = new Object();
		reqObject.method = "resetQuery";
		reqObject.SCREEN_KEY = 10079;
		reqObject.rnd = rndNo;
		super.getResetHttpService().request = reqObject;          	
    }
   override public function preResetCancel():void{
	    var rndNo:Number= Math.random();
	  	super.getResetHttpService().url = "drv/drvCloseOutCancel.action?";
	  	var reqObject:Object = new Object();
		reqObject.method = "resetQuery";
		reqObject.SCREEN_KEY = 10084;
		reqObject.rnd = rndNo;
		super.getResetHttpService().request = reqObject;          	
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
   
   override public function preGenerateXls():String{
	 	var url : String =null;
    	if(mode == "closeoutquery"){		    		
    	  url = "drv/drvCloseOut.action?method=generateXLS";
    	}
    	if(mode == "closeoutentry"){		    		
    	  url = "drv/drvCloseOutEntry.action?method=generateXLS";
    	}
    	if(mode == "closeoutcancel"){		    		
    	  url = "drv/drvCloseOutCancel.action?method=generateXLS";
    	}
    	return url;
   }
   
   override public function preGeneratePdf():String{
	    var url : String =null;
	   // XenosAlert.info("Dispatch queryInit Event ");
		if(mode == "closeoutquery"){		    		
		  url = "drv/drvCloseOut.action?method=generatePDF";
		}
		if(mode == "closeoutentry"){		    		
		  url = "drv/drvCloseOutEntry.action?method=generatePDF";
		}
		if(mode == "closeoutcancel"){		    		
		  url = "drv/drvCloseOutCancel.action?method=generatePDF";
		}
		return url;
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
   * This method is used for loading Trade Details popup module
   * 
   */  
//   public function displayCloseOutDetails(data:XML):void{
//   	  		var sPopup : SummaryPopup = SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
//    		
//    		sPopup.title = "Closeout Trade Details View";
//            //set the width and height of the popup
//            sPopup.width = 975;
//    		sPopup.height = 350;
// 
//    		sPopup.horizontalScrollPolicy="auto";
//    		sPopup.verticalScrollPolicy="auto";
//    		PopUpManager.centerPopUp(sPopup);
//            XenosAlert.info("data.contractPK : "+data.contractPK);
//            var closeOutTradePk : String = data.contractPK;
//    		
//    		//Setting the Module path with some parameters which will be needed in the module for internal processing.
//    		sPopup.moduleUrl = "assets/appl/drv/CloseOutContractDetailView.swf" + Globals.QS_SIGN + "closeOutTradePk" + Globals.EQUALS_SIGN + closeOutTradePk;
//
//   }
   
	  
