
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.RendererFectory;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.controls.XenosQuery;
 import com.nri.rui.core.renderers.ImgSummaryRenderer;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.ref.validators.FinInstQueryValidator;
 
 import mx.collections.ArrayCollection;
 import mx.controls.dataGridClasses.DataGridColumn;
 
	
 private var keylist:ArrayCollection = new ArrayCollection(); 
 private var sortFieldArray:Array =new Array();
 private var sortFieldDataSet:Array =new Array();
 private var sortFieldSelectedItem:Array =new Array();
 private var csd:CustomizeSortOrder=null;
 [Bindable]
  private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
 [Bindable]
 private var mode : String = "query";
 [Bindable]
 private var queryResult:ArrayCollection= new ArrayCollection();    	
	
	private function changeCurrentState():void{
		currentState = "result";
	 }
	public function loadAll():void{
	   	   parseUrlString();
	   	   super.setXenosQueryControl(new XenosQuery());
	   	   //XenosAlert.info("mode : "+mode);
	   	   if(this.mode == 'query'){
	   	   	 this.dispatchEvent(new Event('queryInit'));
	   	   } else if(this.mode == 'amendment'){
	   	   	 this.dispatchEvent(new Event('amendInit'))
	   	   	 addColumn();
	   	   } else { 
	   	     this.dispatchEvent(new Event('cancelInit'));
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
		  	   super.getInitHttpService().url = "ref/finInstQueryDispatch.action?method=initialExecute&mode=query&menuType=Y&rnd=" + rndNo;
		  	   
		  	   var reqObject:Object = new Object();
		  	   reqObject.SCREEN_KEY = 33;
		  	   super.getInitHttpService().request = reqObject;         	
        } 
        override public function preAmendInit():void{
		    var rndNo:Number= Math.random();
		    super.getInitHttpService().url = "ref/finInstAmendQueryDispatch.action?&rnd=" + rndNo;
		    var reqObject:Object = new Object();
		  	reqObject.mode=this.mode;
		  	reqObject.SCREEN_KEY = 33;
		  	reqObject.method="initialExecute";
		  	super.getInitHttpService().request = reqObject;     	
        }
        override public function preCancelInit():void{
		    var rndNo:Number= Math.random();
		    super.getInitHttpService().url = "ref/finInstCancelQueryDispatch.action?&rnd=" + rndNo;  
	        var reqObject:Object = new Object();
	  	    reqObject.mode=this.mode;
	  	    reqObject.SCREEN_KEY = 33;
	  	    reqObject.method="initialExecute";
	  	    super.getInitHttpService().request = reqObject;      	
        }
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("roleList.roles");
	    	keylist.addItem("ourAccountPresentList.item");
	    	keylist.addItem("ourBankGroup.item");
	    	keylist.addItem("preferredInstrumentCodeTypeList.preferredSecCodeType");
	    	
	    	//Sort fields
	    	keylist.addItem("sortFieldList1.item");
	    	keylist.addItem("sortFieldList2.item");
	    	keylist.addItem("sortFieldList3.item");	
        }
        override public function preQueryResultInit():Object{
        	addCommonKeys();   	
	    	keylist.addItem("statusList.item");	    	
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
        override public function postQueryResultInit(mapObj:Object):void{
        	commonInit(mapObj);
			// Clear specific fields for Query
			this.closedFrom.text = XenosStringUtils.EMPTY_STR;
			this.closedTo.text = XenosStringUtils.EMPTY_STR;
			
    		var initcol:ArrayCollection = new ArrayCollection();
    		
    		initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	var index:int=0;
	    	for each(var item:Object in (mapObj[keylist.getItemAt(7)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	this.status.dataProvider = initcol;
	    	this.status.selectedIndex =0;
        }
        
        override public function postAmendResultInit(mapObj:Object):void{
        	this.qryonly.includeInLayout = false;
        	this.qryonly.visible = false;
        	commonInit(mapObj);	
        }
        override public function postCancelResultInit(mapObj:Object):void{
        	this.qryonly.includeInLayout = false;
        	this.qryonly.visible = false;
        	commonInit(mapObj);	
        }
        private function sortOrder1Update():void{
     	    csd.update(sortField1.selectedItem,0);
	    }
	     
	    private function sortOrder2Update():void{     	
	    	csd.update(sortField2.selectedItem,1);
	    }
        private function commonInit(mapObj:Object):void{
        	
        	//variables to hold the default values from the server
	        var sortField1Default:String = "fin_inst_role_code";
	        var sortField2Default:String = "short_name";
	        var sortField3Default:String = "country_code";   
	        var i:int = 0;
	        var selIndx:int = 0;
	        
        	clearCommonFields();
        	
        	errPage.clearError(super.getInitResultEvent());
        	
        	var initcol:ArrayCollection = new ArrayCollection();
        	var tempColl: ArrayCollection = new ArrayCollection();
        	
        	//institution Roles
        	initcol.addItem("");
	    	for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	roles.dataProvider = initcol;
        	
        	//Our Account Present List
        	initcol=new ArrayCollection();
        	initcol.addItem({label:" ", value: " "});
        	for each(var item:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
    			initcol.addItem(item);
	    	}
	    	ouraccountpresent.dataProvider = initcol;
	    	
	    	//Populate BankGroup
	    	initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	for each(var item:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	bankgroup.dataProvider = initcol;
	    	
	    	//Populate Preferred Instrument Code Types
	    	initcol=new ArrayCollection();
    		initcol.addItem("");
    		
    		for each(var item:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
    			initcol.addItem(item);
	    	}
	    	preferredseccodetype.dataProvider = initcol;
	    	
	    	// Sort Fields
	    	initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	selIndx = 0;
	    	for each(var item:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
	    		initcol.addItem(item);
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
	        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx);
	        
	        initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	selIndx = 0;
	    	for each(var item:Object in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	tempColl.removeAll();
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
	        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx);
	        
	        initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	selIndx = 0;
	    	//index=0;
	    	tempColl.removeAll();
	    	for each(var item:Object in (mapObj[keylist.getItemAt(6)] as ArrayCollection)){
	    		initcol.addItem(item);
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
	        sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx);	
	    		
    		csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
	    	csd.init();
	        app.submitButtonInstance = submit;
        }
        
        private function clearCommonFields():void{
        	
        	this.instcode.text = XenosStringUtils.EMPTY_STR;
        	this.shortname.text = XenosStringUtils.EMPTY_STR;
        	this.offName.text = XenosStringUtils.EMPTY_STR;
        	this.countryPopUp.countryCode.text = XenosStringUtils.EMPTY_STR;
        	
        }
        
       override    public function preGenerateXls():String{
	 	var url : String =null;
    	if(mode == "query"){		    		
    	  url = "ref/finInstQueryDispatch.action?method=generateXLS";
    	}else if(mode == "amendment"){
    	  url = "ref/finInstAmendQueryDispatch.action?method=generateXLS";
    	}else{
    	  url = "ref/finInstCancelQueryDispatch.action?method=generateXLS";
    	}
    	return url;
     }
     
     override public function preGeneratePdf():String{
       //XenosAlert.info("preGeneratePdf");
	    var url : String =null;
    	if(mode == "query"){		    		
    	  url = "ref/finInstQueryDispatch.action?method=generatePDF";
    	}else if(mode == "amendment"){
    	  url = "ref/finInstAmendQueryDispatch.action?method=generatePDF";
    	}else{
    	  url = "ref/finInstCancelQueryDispatch.action?method=generatePDF";
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
      
      override public function preQuery():void{
		setValidator();
        qh.resetPageNo();	
       // XenosAlert.info("I am in preQuery ");
        super.getSubmitQueryHttpService().url = "ref/finInstQueryDispatch.action?";  
        super.getSubmitQueryHttpService().request  =populateRequestParams();
        super.getSubmitQueryHttpService().method="POST";
       
	  }
	  override public function preAmend():void{
			qh.resetPageNo();
			super.getSubmitQueryHttpService().url = "ref/finInstAmendQueryDispatch.action?";   
            super.getSubmitQueryHttpService().request  =populateRequestParams();  
            super.getSubmitQueryHttpService().method="POST";
      }
		
	  override public function preCancel():void{
			qh.resetPageNo();
			super.getSubmitQueryHttpService().url = "ref/finInstCancelQueryDispatch.action?"; 
            super.getSubmitQueryHttpService().request = populateRequestParams();
            super.getSubmitQueryHttpService().method="POST";
      }	
	  private function setValidator():void{
			
	    var validateModel:Object={
                        finInstQuery:{                                 
                             closedFromDate:this.closedFrom.text,
                             closedToDate:this.closedTo.text
                        }
                       }; 
         super._validator = new FinInstQueryValidator();
         super._validator.source = validateModel ;
         super._validator.property = "finInstQuery";
	 }
	 
	/**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	reqObj.method= "submitQuery";
    	reqObj.SCREEN_KEY = 32;
    	reqObj.finInstRoleCode = this.instcode.text;
    	reqObj.role = this.roles.selectedItems;
    	reqObj.shortName = this.shortname.text;
    	reqObj.officialName1 = this.offName.text;
    	reqObj.countryCode = this.countryPopUp.countryCode.text;
    	reqObj.ourAccountPresent = (this.ouraccountpresent.selectedItem != null ? this.ouraccountpresent.selectedItem.value : "");
    	reqObj.bankGroupId = (this.bankgroup.selectedItem != null ? this.bankgroup.selectedItem.value : "");
    	if(this.mode == "query"){
	    	reqObj.status = (this.status.selectedItem != null ? this.status.selectedItem.value : "");
	    	reqObj.closeDateFrom = this.closedFrom.text;
	    	reqObj.closeDateTo = this.closedTo.text;
    	}else{
    		reqObj.status = Globals.STATUS_NORMAL;
    	}
    	reqObj.preferredInstrumentCodeType = this.preferredseccodetype.selectedItem != null ? this.preferredseccodetype.selectedItem : "";
    	reqObj.sortField1 = (this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "");
        reqObj.sortField2 = (this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "");
        reqObj.sortField3 = (this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "");
        reqObj.rnd = Math.random() + "";
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
			    app.submitButtonInstance = null;
	            qh.setOnResultVisibility();
	            qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
	            qh.PopulateDefaultVisibleColumns();
	    		
	    	}else{
	    		errPage.removeError();
	    		queryResult.removeAll();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
	    	}    		
    	}
    	//XenosAlert.info(result);
    }
    override public function preResetQuery():void{
	    var rndNo:Number= Math.random();
	  	super.getResetHttpService().url = "ref/finInstQueryDispatch.action?method=resetQuery&mode=query&menuType=Y&rnd=" + rndNo;
	  	var reqObject:Object = new Object();
		reqObject.SCREEN_KEY = 33;
		super.getInitHttpService().request = reqObject;          	
    }
    override public function preResetAmend():void{
	   var rndNo:Number= Math.random();
	   super.getResetHttpService().url = "ref/finInstAmendQueryDispatch.action?&rnd=" + rndNo;
	   var reqObject:Object = new Object();
	   reqObject.actionType=this.mode;
	   reqObject.method="initialExecute";
	   reqObject.SCREEN_KEY = 33;
	  super.getResetHttpService().request = reqObject;     	
    }
        
    override public function preResetCancel():void{
	   var rndNo:Number= Math.random();
	   super.getResetHttpService().url = "ref/finInstCancelQueryDispatch.action?&rnd=" + rndNo;  
	   var reqObject:Object = new Object();
	   reqObject.actionType=this.mode;
	   reqObject.method="initialExecute";
	   reqObject.SCREEN_KEY = 33;
	   super.getResetHttpService().request = reqObject;      	
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
			//Add a object
			
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
