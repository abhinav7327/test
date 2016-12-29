




import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.frx.validators.NdfRevalExchangeRateQueryValidator;
import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.UIComponent;
import mx.managers.PopUpManager;
			
	  //private var mkt:XenosQuery = new MarketPriceQuery();
	  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    public var queryResult:ArrayCollection= new ArrayCollection();
     [Bindable]
    public var selectAllBind:Boolean=false;

     
     private var keylist:ArrayCollection = new ArrayCollection(); 
     private var sortFieldArray:Array =new Array();
     private var sortFieldDataSet:Array =new Array();
     private var sortFieldSelectedItem:Array =new Array();
     private var  csd:CustomizeSortOrder=null;
     
     [Bindable]private var mode : String = "query";
     [Bindable]private var skippedColumns:Array = new Array();
            
	  
	  private function changeCurrentState():void{
				currentState = "result";
	 }
			 
           public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosQueryControl(new XenosQuery());
           	   //XenosAlert.info("mode : "+mode);
           	   if(this.mode == 'query'){
           	   	 skippedColumns = [1,7,8];
           	   	 this.dispatchEvent(new Event('queryInit'));
           	   } else if(this.mode == 'amend'){
           	   	 skippedColumns = [1,3,6,9];
           	   	 this.dispatchEvent(new Event('amendInit'));
           	   	 //addColumn();
           	   } else { 
           	   	 skippedColumns = [1,2,8,9,10];
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
		     var reqObject:Object = new Object();
	  		reqObject.SCREEN_KEY="12015";
		       var rndNo:Number= Math.random();
		  		super.getInitHttpService().url = "frx/ndfExchangeRateQueryDispatch.action?method=initialExecute&mode=query&menuType=Y&rnd=" + rndNo;
		  		super.getInitHttpService().request = reqObject;        	
        }
        
        override public function preAmendInit():void{
		   var rndNo:Number= Math.random();
		   super.getInitHttpService().url = "frx/ndfExchangeRateAmendQueryDispatch.action?&rnd=" + rndNo;
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		reqObject.SCREEN_KEY = "12016";
		  		super.getInitHttpService().request = reqObject;     	
        }
        
        override public function preCancelInit():void{
		   var rndNo:Number= Math.random();
		   super.getInitHttpService().url = "frx/ndfExchangeRateCancelQueryDispatch.action?&rnd=" + rndNo;  
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		reqObject.SCREEN_KEY = "12017"
		  		super.getInitHttpService().request = reqObject;      	
        }        
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();
	    	keylist.addItem("statusList.statusList");
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
        
        private function sortOrder1Update():void{
     	 csd.update(sortField1.selectedItem,0);
	     }
	     
	     private function sortOrder2Update():void{     	
	     	csd.update(sortField2.selectedItem,1);
	     }
        
        private function commonInit(mapObj:Object):void{
        	var i:int = 0;
	        var selIndx:int = 0;
	        var initcol:ArrayCollection = new ArrayCollection();
	        var tempColl: ArrayCollection = new ArrayCollection();
	        app.submitButtonInstance = submit;
	        //variables to hold the default values from the server
	        var sortField1Default:String = mapObj[keylist.getItemAt(4)].toString();
	        var sortField2Default:String = mapObj[keylist.getItemAt(5)].toString();
	        var sortField3Default:String = mapObj[keylist.getItemAt(6)].toString(); 
	        
	     	//initiate text fields
	     	baseDateFrom.text="";
	     	baseDateFrom.setFocus();
	     	baseDateTo.text="";
	     	//calculationTypeList.text="";
	     	revaluationCcyBox.ccyText.text=""; 
	     	tradeReferenceNo.text="";
		    entryDateFrom.text="";
	     	entryDateTo.text="";
		    updateDateFrom.text="";
	     	updateDateTo.text="";
 
    		errPage.clearError(super.getInitResultEvent());
    		
	        //errPage.removeError();
	    	
			tempColl = new ArrayCollection();
		    initcol = new ArrayCollection();
	       
        	if(mapObj[keylist.getItemAt(0)] !=null){
	        	if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
	        		tempColl.addItem("");
	            	initcol = mapObj[keylist.getItemAt(0)] as ArrayCollection;
	            	for each(var item3:Object in initcol){
		        		tempColl.addItem(item3);
		        	}
	        	}
	        	else {
	        		tempColl.addItem(mapObj[keylist.getItemAt(0)].toString());
	        	}
        	}
        	this.status.dataProvider =  tempColl;
	    	
	        //Initialize sortFieldList1.
	        if(null != mapObj[keylist.getItemAt(1)]){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(1)] is ArrayCollection){
	            initcol = mapObj[keylist.getItemAt(1)] as ArrayCollection;
	       		for each(var item6:Object in initcol){
	                //Get the default value object's index
	                if(XenosStringUtils.equals(item6.value,sortField1Default)){                    
	                    selIndx = initcol.getItemIndex(item6);
	                }
	                   tempColl.addItem(item6);            
	            }
	            sortFieldArray[0]=sortField1;
		        sortFieldDataSet[0]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
	            
	        } 
	        }else {
	            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.populate.sortorder1'));
	        }
	        
	        //Initialize sortFieldList2.
	        if(null != mapObj[keylist.getItemAt(2)]){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx=0;
	            if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
	            initcol = mapObj[keylist.getItemAt(2)] as ArrayCollection;
	            for each(var item7:Object in initcol){
	                //Get the default value object's index
	                if(XenosStringUtils.equals(item7.value,sortField2Default)){                    
	                    selIndx = initcol.getItemIndex(item7);
	                }
	                tempColl.addItem(item7);            
	            }
	            
	            sortFieldArray[1]=sortField2;
		        sortFieldDataSet[1]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
	            
	        }
	        } else {
	            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.populate.sortorder2'));
	        }
	        
	        //Initialize sortFieldList3.
	        if(null != mapObj[keylist.getItemAt(3)]){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx = 0;
	            
	            if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
	            initcol = mapObj[keylist.getItemAt(3)] as ArrayCollection;
	            for each(var item8:Object in initcol){
	                //Get the default value object's index
	                if(XenosStringUtils.equals(item8.value,sortField3Default)){                    
	                    selIndx = initcol.getItemIndex(item8);
	                }
	                
	                tempColl.addItem(item8);            
	            }
	            
	            sortFieldArray[2]=sortField3;
		        sortFieldDataSet[2]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
		       
		        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
		        csd.init();
	    	
	    	//Set Array for Exchange Rate Type and Base CCy 
	    	
        }
	        }
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
        
		
		override public function preQuery():void{
			setValidator();
            qh.resetPageNo();	
  	       var reqObject:Object = new Object();
  	       reqObject = populateRequestParams();
            super.getSubmitQueryHttpService().url = "frx/ndfExchangeRateQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request  = reqObject;
           
		}
		
		override public function preAmend():void{
			setValidator();
            qh.resetPageNo();	
            //XenosAlert.info("I am in preAmend ");
			var reqObject:Object = new Object();
		 	//reqObject.SCREEN_KEY = "12022"; 		
			reqObject = populateRequestParams();
			super.getSubmitQueryHttpService().url = "frx/ndfExchangeRateAmendQueryDispatch.action?";               
            super.getSubmitQueryHttpService().request  = reqObject;  
           
		}
		
		
		override public function preCancel():void{
			setValidator();
			 qh.resetPageNo();	
		    var reqObject:Object = new Object();
			//reqObject.SCREEN_KEY = "12023";
			reqObject = populateRequestParams()		  		
            super.getSubmitQueryHttpService().url = "frx/ndfExchangeRateCancelQueryDispatch.action?"; 
            super.getSubmitQueryHttpService().request = reqObject;
           
		}
		
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	//XenosAlert.info("Mode :: "+mode);
		if(this.mode == 'query'){
   	   	 reqObj.SCREEN_KEY = "12021";
   	   } else if(this.mode == 'amend'){
   	   	 reqObj.SCREEN_KEY = "12022";
   	   } else if(this.mode == 'cancel'){ 
   	     reqObj.SCREEN_KEY = "12023";
   	   }
    	
    	reqObj.method= "submitQuery";
    	
        reqObj.revaluationCcy = this.revaluationCcyBox.ccyText.text;
        
        //Date Fields
        reqObj.baseDateFromStr = this.baseDateFrom.text;
        reqObj.baseDateToStr = this.baseDateTo.text;
        
        //Text Fields
        reqObj.tradeReferenceNo = this.tradeReferenceNo.text;     
         if(this.mode == 'query'){
         	reqObj.status = (this.status.selectedItem != null) ? this.status.selectedItem : "";
         }else{
        	reqObj.status="NORMAL";
         }
        reqObj.entryDateFromStr = this.entryDateFrom.text;
        reqObj.entryDateToStr = this.entryDateTo.text;          
        reqObj.updateDateFromStr = this.updateDateFrom.text;
        reqObj.updateDateToStr = this.updateDateTo.text;
        
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
       	resetSellection(queryResult);
		selectAllBind=false;
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
		       	for(var indx:int=0; indx<queryResult.length; indx++){
               		queryResult.getItemAt(indx).originalIndex = indx;
               		queryResult.getItemAt(indx).originalBaseDate = queryResult.getItemAt(indx).baseDate.toString();
               		queryResult.getItemAt(indx).originalExchangeRate = queryResult.getItemAt(indx).exchangeRate.toString();
               }

	    		
	    	}else{
	    		queryResult.removeAll();
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('frx.msg.common.info.datanotfound'));
	    	}    		
    	}
    	//XenosAlert.info(result);
    }   
       
      
        override public function preResetQuery():void{
		       var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "frx/ndfExchangeRateQueryDispatch.action?method=resetQuery&&mode=query&&menuType=Y&rnd=" + rndNo;        	
        }
        
        override public function preResetAmend():void{
		   var rndNo:Number= Math.random();
		   super.getResetHttpService().url = "frx/ndfExchangeRateAmendQueryDispatch.action?&rnd=" + rndNo;
		     var reqObject:Object = new Object();
		  		reqObject.actionType=this.mode;
		  		reqObject.method="initialExecute";
		  		super.getResetHttpService().request = reqObject;     	
        }
        
        override public function preResetCancel():void{
		   var rndNo:Number= Math.random();
		   super.getResetHttpService().url = "frx/ndfExchangeRateCancelQueryDispatch.action?&rnd=" + rndNo;  
		     var reqObject:Object = new Object();
		  		reqObject.actionType=this.mode;
		  		reqObject.method="initialExecute";
		  		super.getResetHttpService().request = reqObject;      	
        }       
        
        
        override    public function preGenerateXls():String{
        	 var url : String =null;
        	 	 if(this.mode == "query")		    		
		    	 	url = "frx/ndfExchangeRateQueryDispatch.action?method=generateXLS";
		    	 else if(this.mode == "amend")
		    	 	url = "frx/ndfExchangeRateAmendQueryDispatch.action?method=generateXLS";
		    	 else
		    	 	url = "frx/ndfExchangeRateCancelQueryDispatch.action?method=generateXLS";
		    	 return url;
         }	
   override public function preGeneratePdf():String{
           //XenosAlert.info("preGeneratePdf");
    	   var url : String =null;	
    	   	   if(this.mode == "query") 		
	    	   	url = "frx/ndfExchangeRateQueryDispatch.action?method=generatePDF";
	    	   else if(this.mode == "amend")
	    	   	url = "frx/ndfExchangeRateAmendQueryDispatch.action?method=generatePDF";
	    	   else
	    	   	url = "frx/ndfExchangeRateCancelQueryDispatch.action?method=generatePDF";	
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
			resultSummary.columns = cols;
			
		}
    private function showConfirmModule():void{
    	if(mode == "query"){
    		return;
    	}
    	var parentApp :UIComponent = UIComponent(this.parentApplication);
    	var selectedItem:Array = getSelectedRows();
    	if(selectedItem.length < 1){
			if(this.mode == "amend"){
	    		XenosAlert.error("Select at least one NDF Revaluation exchange Rate to Amend");
	    		return;
    		}
    	}
		if(this.mode == "amend"){
			var flag:Boolean = validate();
			if(flag == false)
				return;
    	}

    	var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,false));
			if(mode == "amend") {
				sPopup.title = this.parentApplication.xResourceManager.getKeyValue('frx.exchangerate.amend');
			}else{
				sPopup.title = this.parentApplication.xResourceManager.getKeyValue('frx.exchangerate.cancel');
			}
			/* sPopup.width = parentApplication.width * 50/100;
    		sPopup.height = parentApplication.height * 55/100; */
    		sPopup.width = 620;
    		sPopup.height = 330;
			PopUpManager.centerPopUp(sPopup);
			sPopup.owner = this;
			sPopup.dataObj = queryResult;
			sPopup.moduleUrl = "assets/appl/frx/NdfExchangeEntry.swf"+Globals.QS_SIGN+"mode"+Globals.EQUALS_SIGN+mode+Globals.AND_SIGN+"selectedItems"+Globals.EQUALS_SIGN+selectedItem;
    }
    private function getSelectedRows():Array{
    	var tempArray:ArrayCollection = new ArrayCollection();
    	for(var i:int=0;i<queryResult.length;i++){
    		if(queryResult[i].selected == true){
    			tempArray.addItem(queryResult[i].originalIndex + "|" + i);
    		} 		
    	}
    	return tempArray.toArray();
    }
   	private function resetBaseDateCol():void {
    	if(mode == "amend"){
        	for(var i:int=0; i<queryResult.length; i++){
            	var qntStr:String = queryResult[i].originalBaseDate.toString();
            	queryResult[i].baseDate = qntStr;
        	}
        	resetSellection(queryResult);
    	}
    	resultSummary.dataProvider = queryResult;     
	}
    private function resetSellection(queryResult:ArrayCollection):void{
    	for(var i:int=0;i<queryResult.length;i++){
    		queryResult[i].selected = false;
    		queryResult[i].rowNum = i;
    	}
    }
    public function checkSelectToModify(item:Object):void {
    	setIfAllSelected();    	    	
    }
    public function setIfAllSelected() : void {
    	if(isAllSelected()){
    		selectAllBind=true;
    	} else {
    		selectAllBind=false;
    	}
    }
    public function isAllSelected(): Boolean {
    	var i:Number = 0;
    	if(queryResult == null){
    	 return false;
    	}
    	for(i=0; i<queryResult.length; i++){
    		if(queryResult[i].selected == false) {
        		return false;
        	}
    	}
    	if(i == queryResult.length) {
    		return true;
         }else {
    		return false;
    	}
    }
    public function selectAllRecords(flag:Boolean): void {
    	var i:Number = 0;
    	//selectedResults.removeAll();
    	for(i=0; i<queryResult.length; i++){
    		var obj:XML=queryResult[i];
            obj.selected = flag;
            queryResult[i]=obj;
    	}
    }
    private function resetExchangeRateCol():void {
    	if(mode == "amend"){
        	for(var i:int=0; i<queryResult.length; i++){
            	var qntStr:String = queryResult[i].originalExchangeRate.toString();
            	queryResult[i].exchangeRate = qntStr;
        	}
        	resetSellection(queryResult);
    	}
    	resultSummary.dataProvider = queryResult;     
	}
    private function validate():Boolean{
    	for(var i:int=0;i<queryResult.length;i++){    		
    		if(queryResult[i].selected == true){
				if(XenosStringUtils.isBlank(queryResult[i].exchangeRate)){ 
			    	XenosAlert.error("Exchange Rate can not be blank");				   		
					return false;
				}else{
					var rate:String = queryResult[i].exchangeRate;
					// numbers less than equal to three digits and zero will go inside the if block
					if(!isNaN(Number(rate))){
						if(Number(rate) == 0){
							XenosAlert.error("Exchange Rate can not be zero");	
					return false;
						}
					}
				}
				if(XenosStringUtils.isBlank(queryResult[i].baseDate) || queryResult[i].baseDate == ""){
			    	XenosAlert.error("Base date can not be blank");	
					return false;				
				}
			} 		
    	}
    	return true;
    }
    	private function setValidator():void{
		
	    var ndfRevalExchangeRateQueryModule:Object={
                        ndfRevalExchangeRateQuery:{                                 
                             baseDateFrom:this.baseDateFrom.text,
                             baseDateTo:this.baseDateTo.text,
                             entryDateFrom:this.entryDateFrom.text,
                             entryDateTo:this.entryDateTo.text,
                             updateDateFrom:this.updateDateFrom.text,
                             updateDateTo:this.updateDateTo.text
                        }
                       }; 
         super._validator = new NdfRevalExchangeRateQueryValidator();
         super._validator.source = ndfRevalExchangeRateQueryModule ;
         super._validator.property = "ndfRevalExchangeRateQuery";
		}



    
    
		
