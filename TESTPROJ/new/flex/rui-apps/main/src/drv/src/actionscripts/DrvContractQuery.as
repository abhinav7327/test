
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.controls.XenosQuery;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 
 import mx.collections.ArrayCollection;
 import mx.utils.StringUtil;
 
 //Items returning through context - Non display objects for accountPopup
 [Bindable]
 public var returnContextItem:ArrayCollection = new ArrayCollection();
 [Bindable]
 private var summaryResult:ArrayCollection= new ArrayCollection();

 [Bindable]
 private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);   
 [Bindable]
 private var mode : String = "query";
 [Bindable]
 private var queryResult:ArrayCollection= new ArrayCollection();  
 private var keylist:ArrayCollection = new ArrayCollection(); 
 
 private var sortFieldArray:Array =new Array();
 private var sortFieldDataSet:Array =new Array();
 private var sortFieldSelectedItem:Array =new Array();
 private var csd:CustomizeSortOrder=null;
 
 private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
 	/**
     * Loading the initial configuaration.
     * 
     */
    public function loadAll():void{
   	   super.setXenosQueryControl(new XenosQuery());
   	   //XenosAlert.info("mode : "+mode);
   	   if(this.mode == 'query'){
   	   	 this.dispatchEvent(new Event('queryInit'));
   	   } 
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
  	   super.getInitHttpService().url = "drv/drvContractQuery.action?method=initialExecute&rnd=" + rndNo;
  	   
  	   var reqObject:Object = new Object();
  	   reqObject.SCREEN_KEY = 11049;
  	   super.getInitHttpService().request = reqObject;         	
    } 
    
    private function addCommonKeys():void{  
    	keylist = new ArrayCollection();      	
    	keylist.addItem("expiryStatusList.item");
    	   	
    	//Sort fields
    	keylist.addItem("sortFieldList1.item");
    	keylist.addItem("sortFieldList2.item");
    	keylist.addItem("sortField1");
    	keylist.addItem("sortField2");
    	
    }
    
    override public function preQueryResultInit():Object{
    	addCommonKeys();   	
    	return keylist;        	
    }
    
    private function clearCommonFields():void{
    	
    	this.fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;
    	this.actPopUp.accountNo.text = XenosStringUtils.EMPTY_STR;
    	this.brkAccountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
    	this.securityId.instrumentId.text = XenosStringUtils.EMPTY_STR;
    	this.contractReferenceNo.text = XenosStringUtils.EMPTY_STR;
    	
    }
    
    private function sortOrder1Update():void{
 	    csd.update(sortField1.selectedItem,0);
    }
    
    private function commonInit(mapObj:Object):void{
    	
    	var initcol:ArrayCollection = new ArrayCollection();
    	var tempColl: ArrayCollection = new ArrayCollection();
    	var i:int = 0;
	    var selIndx:int = 0;
	    
    	clearCommonFields();
        errPage.clearError(super.getInitResultEvent());
        
        this.fundPopUp.fundCode.setFocus();
        this.securityId.instrumentId.width = 150;
        //Expiry Status
        initcol.addItem({label:" ", value: " "});
        
        
    	for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
			initcol.addItem(item);
    	}
    	expstatus.dataProvider = initcol;
    	this.expstatus.selectedIndex =0;
    	// Sort Fields
    	initcol=new ArrayCollection();
    	initcol.addItem({label:" ", value: " "});
    	selIndx = 0;
	    for each(var item:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
    		initcol.addItem(item);
    	}
    	for(i = 0; i<initcol.length; i++) {
        	//Get the default value object's index
            if(XenosStringUtils.equals(initcol[i].value,mapObj[keylist.getItemAt(3)].toString())){                    
                selIndx = i;
            }
            tempColl.addItem(initcol[i]);            
        }
        sortFieldArray[0]=sortField1;
        sortFieldDataSet[0]=tempColl;
        //Set the default value object
        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx);	
        
        initcol=new ArrayCollection();
    	initcol.addItem({label:" ", value: " "});
    	selIndx = 0;
    	for each(var item:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
    		initcol.addItem(item);
    	}
    	tempColl.removeAll();
    	for(i = 0; i<initcol.length; i++) {
        	//Get the default value object's index
            if(XenosStringUtils.equals(initcol[i].value,mapObj[keylist.getItemAt(4)].toString())){                    
                selIndx = i;
            }
        	
           tempColl.addItem(initcol[i]);            
        }
        
        sortFieldArray[1]=sortField2;
        sortFieldDataSet[1]=tempColl;
        //Set the default value object
        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx);
        
        csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
	    csd.init();
    }
    
    override public function postQueryResultInit(mapObj:Object):void{
    	commonInit(mapObj);
    	
    }
    
    override public function postQueryResultHandler(mapObj:Object):void{
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
			    changeCurrentState();
			    
	            qh.setOnResultVisibility();
	            qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
	            qh.PopulateDefaultVisibleColumns();
	    		
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}    		
    	}
     }
    
    override public function preQuery():void{
		qh.resetPageNo();	
       // XenosAlert.info("I am in preQuery ");
        super.getSubmitQueryHttpService().url = "drv/drvContractQuery.action?";  
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
    	reqObj.method= "submitQuery";
    	reqObj.SCREEN_KEY = 11050;
    	reqObj.fundCode = this.fundPopUp.fundCode.text;
    	reqObj.inventoryAccountNo = this.actPopUp.accountNo.text;
    	reqObj.cpAccountNo = this.brkAccountNo.accountNo.text;
    	reqObj.securityId = this.securityId.instrumentId.text;
    	reqObj.contractRefNo = this.contractReferenceNo.text;
    	reqObj.expiryStatus = (this.expstatus.selectedItem != null ? this.expstatus.selectedItem.value : "");
    	
    	reqObj.sortField1 = (this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : "");
        reqObj.sortField2 = (this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : "");
        reqObj.rnd = Math.random() + "";
    	return reqObj;
    }
	  
    override public function preResetQuery():void{
	    var rndNo:Number= Math.random();
	  	super.getResetHttpService().url = "drv/drvContractQuery.action?method=resetQuery&rnd=" + rndNo;
	  	var reqObject:Object = new Object();
		reqObject.SCREEN_KEY = 11049;
		super.getInitHttpService().request = reqObject;          	
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
    	if(mode == "query"){		    		
    	  url = "drv/drvContractQuery.action?method=generateXLS";
    	}
    	return url;
   }
   
   override public function preGeneratePdf():String{
    var url : String =null;
	if(mode == "query"){		    		
	  url = "drv/drvContractQuery.action?method=generatePDF";
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
	 