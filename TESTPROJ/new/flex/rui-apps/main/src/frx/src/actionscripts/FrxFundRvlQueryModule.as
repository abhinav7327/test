// ActionScript file
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.Globals;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.frx.validators.FrxRvlQueryValidator;
import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;
import mx.utils.StringUtil;
              
      
        [Bindable]
        private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);         
        [Bindable]
        private var queryResult:ArrayCollection= new ArrayCollection();     
        private var keylist:ArrayCollection = new ArrayCollection();                   
        [Bindable]
        private var initcol:ArrayCollection = new ArrayCollection();
         
        private var csd:CustomizeSortOrder = null;         
        private var sortFieldArray:Array = new Array();
        private var sortFieldDataSet:Array = new Array();
        private var sortFieldSelectedItem:Array = new Array();
        private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
        
        //Items returning through context - Non display objects for accountPopup
        [Bindable]
        public var returnContextItem:ArrayCollection = new ArrayCollection();       
        [Bindable]
        private var mode : String = "query";
             
        public function loadAll():void {
            parseUrlString();
            super.setXenosQueryControl(new XenosQuery());
            this.dispatchEvent(new Event('queryInit'));          
        }
        
        /**
         * Extracts the parameters and set them to some variables for query criteria from 
         * the Module Loader Info.
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
                    if(params != null) {
                        for (var i:int = 0; i < params.length; i++) {
                            var tempA:Array = params[i].split("=");  
                            if (tempA[0] == "mode") {
                                //XenosAlert.info("movArray param = " + tempA[1]);
                                mode = tempA[1];
                            }
                        }                       
                    } else {
                        mode = "query";
                    }
            } catch(e:Error) {
                trace(e);
            }               
        }
         
        private function addColumn():void {                 
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
                
        /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specific  
          * requirement. 
          */
        private function populateInvActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
            actTypeArray[0] = "T|B";
            myContextList.addItem(new HiddenObject("actTypeContext", actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
            cpTypeArray[0] = "INTERNAL";
            myContextList.addItem(new HiddenObject("invCPTypeContext", cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0] = "OPEN";
            myContextList.addItem(new HiddenObject("accountStatus", actStatusArray));
            return myContextList;
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
           
        private function dispatchNextEvent():void {
            this.dispatchEvent(new Event("next"));
        } 
         
        private function dispatchPrevEvent():void {
            this.dispatchEvent(new Event("prev"));
        }
          
        override public function preNext():Object {
            var reqObj:Object = new Object();
            reqObj.rnd = Math.random() + "";
            reqObj.method = "doNext";
            return reqObj;
        }
            
        override public function prePrevious():Object {        
            var reqObj:Object = new Object();
            reqObj.rnd = Math.random() + "";
            reqObj.method = "doPrevious";
            return reqObj;
        }
        
        override public function preGenerateXls():String {
            var url:String = null;
            url = "frx/frxFundRvlQueryDispatch.action?method=generateXLS";
            return url;
        }
            
        override public function preGeneratePdf():String {
            var url:String = null;
            url = "frx/frxFundRvlQueryDispatch.action?method=generatePDF";
            return url;
        }
        
        override public function preQueryInit():void {
            var rndNo:Number= Math.random();                    
			super.getInitHttpService().url = "frx/frxFundRvlQueryDispatch.action?";
			var reqObject:Object = new Object();
		  	   reqObject.rnd = rndNo;
            	reqObject.method= "initialExecute";
		  		reqObject.mode="query";
		  		reqObject.menuType="Y";
		  		reqObject.SCREEN_KEY = "12018";
		  		super.getInitHttpService().request = reqObject;         	
        }
     
        override public function preQueryResultInit():Object {
            addCommonKeys();            
            return keylist;         
        }
        
        private function addCommonKeys():void {  
            keylist = new ArrayCollection();        
            keylist.addItem("bookingDate");
            keylist.addItem("sortFieldList1.item");
            keylist.addItem("sortFieldList2.item");
            keylist.addItem("sortFieldList3.item");
            keylist.addItem("sortField1");
            keylist.addItem("sortField2");
            keylist.addItem("sortField3");
            keylist.addItem("scrDisDatas.tradeTypeList.tradeTypeList");
            keylist.addItem("");
        }
     
        override public function postQueryResultInit(mapObj:Object):void {
            commonInit(mapObj);
        }
        
        private function commonInit(mapObj:Object):void {
            var selIndx:int = 0;
            var i:int = 0;
            var tempColl: ArrayCollection = new ArrayCollection();
            
            errPage.clearError(super.getInitResultEvent());
            
            //For SortField1
            var sortField1Default:String = mapObj[keylist.getItemAt(4)].toString();
            //For SortField2
            var sortField2Default:String = mapObj[keylist.getItemAt(5)].toString();
            //For SortField3
            var sortField3Default:String = mapObj[keylist.getItemAt(6)].toString(); 
            
            
            this.bookingDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(0)].toString());
            bookingDate.setFocus();
            this.fundPopUp.fundCode.text = "";
            this.inventoryAccountNo.accountNo.text = "";
            this.trdRefNo.text = "";
            this.revalRefNo.text = "";
            this.buyCcy.ccyText.text = "";
            this.sellCcy.ccyText.text = "";
            //----------Start of population of SortField1----------//           
            if(null != mapObj[keylist.getItemAt(1)]) {
                initcol = new ArrayCollection();
                tempColl = new ArrayCollection();
                tempColl.addItem({label:" ", value: " "});
                selIndx = 0;
                
                if(mapObj[keylist.getItemAt(1)] is ArrayCollection) {
                    for each(var item1:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)) {
                        initcol.addItem(item1);
                    }
                } else {
                    initcol.addItem(mapObj[keylist.getItemAt(1)]);
                }
                for(i = 0; i<initcol.length; i++) {
                    //Get the default value object's index
                    if(XenosStringUtils.equals((initcol[i].value), sortField1Default)) {                    
                        selIndx = i;
                    }
                    tempColl.addItem(initcol[i]);            
                }
                
                sortFieldArray[0] = sortField1;
                sortFieldDataSet[0] = tempColl;
                //Set the default value object
                sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
            } else {
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.populate.sortorder1'));
            }           
            //---------------End of population of SortField1-----------------------//
            
            //--------Start of population of sortField2---------//          
            if(null != mapObj[keylist.getItemAt(2)]) {
                initcol = new ArrayCollection();
                tempColl = new ArrayCollection();
                tempColl.addItem({label:" ", value: " "});
                selIndx = 0;
                
                if(mapObj[keylist.getItemAt(2)] is ArrayCollection) {
                    for each(var item2:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)) {
                        initcol.addItem(item2);
                    }
                } else {
                    initcol.addItem(mapObj[keylist.getItemAt(2)]);
                }
                for(i = 0; i<initcol.length; i++) {
                    //Get the default value object's index
                    if(XenosStringUtils.equals((initcol[i].value), sortField2Default)) {                    
                        selIndx = i;
                    }
                    tempColl.addItem(initcol[i]);            
                }
                
                sortFieldArray[1] = sortField2;
                sortFieldDataSet[1] = tempColl;
                //Set the default value object
                sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
            } else {
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.populate.sortorder2'));
            }           
            //--------End of population of sortField2---------// 
            
            //--------Start of population of sortField3---------//          
            if(null != mapObj[keylist.getItemAt(3)]) {
                initcol = new ArrayCollection();
                tempColl = new ArrayCollection();
                tempColl.addItem({label:" ", value: " "});
                selIndx = 0;
                
                if(mapObj[keylist.getItemAt(3)] is ArrayCollection) {
                    for each(var item3:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)) {
                        initcol.addItem(item3);
                    }
                } else {
                    initcol.addItem(mapObj[keylist.getItemAt(3)]);
                }
                for(i = 0; i<initcol.length; i++) {
                    //Get the default value object's index
                    if(XenosStringUtils.equals((initcol[i].value), sortField3Default)) {                    
                        selIndx = i;
                    }                   
                    tempColl.addItem(initcol[i]);            
                }
                
                sortFieldArray[2] = sortField3;
                sortFieldDataSet[2] = tempColl;
                //Set the default value object
                sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
            } else {
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.populate.sortorder3'));
            }           
            //--------End of population of sortField3---------//
            
            //-------------Initializing the sortfields-------------//
            
             //Initialize Trade Type
	       if(null != mapObj[keylist.getItemAt(7)]){
	    	tempColl = new ArrayCollection();
	    	initcol = new ArrayCollection();
	    	tempColl.addItem(" ");
	    	if(mapObj[keylist.getItemAt(7)] !=null){
		    	if(mapObj[keylist.getItemAt(7)] is ArrayCollection){
		        	initcol = mapObj[keylist.getItemAt(7)] as ArrayCollection;
		        	for each(var item1:Object in initcol){
		        		tempColl.addItem(item1);
		        	}
		    	}
		    	else {
		    		tempColl.addItem(mapObj[keylist.getItemAt(7)].toString());
		    	}
	    	}
	    	this.tradeTypeValues.dataProvider = tempColl;
	       }
	       
	       else{
	       	 XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.populate.tradetype'));
	       }
            
          
            csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
            csd.init();
        }
        
         /**
         * Method for updating the other two sortfields after any change in the sortfield1
         */ 
        private function sortOrder1Update():void {
            csd.update(sortField1.selectedItem,0);
        }
        
         /**
         * Method for updating the other two sortfields after any change in the sortfield2
         */
        private function sortOrder2Update():void {      
            csd.update(sortField2.selectedItem,1);
        }     
        
        
        override public function preQuery():void {
            setValidator();
            qh.resetPageNo();
            super.getSubmitQueryHttpService().url = "frx/frxFundRvlQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request = populateRequestParams();
        }   
        
        private function setValidator():void{
            var validateModel:Object = {
                                            frxRvlQuery:{                                 
                                                 bookingDate:this.bookingDate.text
                                            }
                                       }; 
            super._validator = new FrxRvlQueryValidator();
            super._validator.source = validateModel;
            super._validator.property = "frxRvlQuery";
        }
        
        /**
        * This method will populate the request parameters for the
        * submitQuery call and bind the parameters with the HTTPService
        * object.
        */
        private function populateRequestParams():Object {
            
            var reqObj : Object = new Object();
            
            reqObj.method = "submitQuery";
	    	reqObj.SCREEN_KEY = "12077";
            reqObj.bookingDate = this.bookingDate.text;  
            reqObj.fundCode = this.fundPopUp.fundCode.text;       
            //reqObj.accountNo = this.cpAccountNo.accountNo.text;         
            reqObj.inventoryAccountNo = this.inventoryAccountNo.accountNo.text;         
            reqObj.frxTrdReferenceNo = this.trdRefNo.text;          
            reqObj.referenceNo = this.revalRefNo.text;          
            reqObj.buyCcy = this.buyCcy.ccyText.text;            
            reqObj.sellCcy = this.sellCcy.ccyText.text;
            reqObj.tradeType = (String(StringUtil.trim(this.tradeTypeValues.text)).length > 0 
         						&& this.tradeTypeValues.selectedItem != null) ? this.tradeTypeValues.selectedItem : "";
            
            reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : Globals.EMPTY_STRING;
            reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : Globals.EMPTY_STRING;
            reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : Globals.EMPTY_STRING;
            
            return reqObj;
        } 
        
        override public function postQueryResultHandler(mapObj:Object):void {
            commonResult(mapObj);
        }
        
        private function commonResult(mapObj:Object):void { 
            var result:String = "";
            if(mapObj != null) {  
                if(mapObj["errorFlag"].toString() == "error") {
                    queryResult.removeAll();
                    errPage.showError(mapObj["errorMsg"]);
                } else {
                    if(mapObj["errorFlag"].toString() == "noError") {
                        errPage.clearError(super.getSubmitQueryResultEvent());
                        queryResult.removeAll();
                        queryResult = mapObj["row"];
                        changeCurrentState();
                        qh.setOnResultVisibility();
                        qh.setPrevNextVisibility(((mapObj["prevTraversable"] == "true") ? true : false), ((mapObj["nextTraversable"] == "true") ? true : false));
                        qh.PopulateDefaultVisibleColumns();             
                    } else {
                        errPage.removeError();
                        XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                    } 
                }           
            }
        } 
                
        override public function preResetQuery():void {
            var rndNo:Number= Math.random();
            super.getResetHttpService().url = "frx/frxFundRvlQueryDispatch.action?method=resetFundRvlQueryForm&&mode=query&&menuType=Y&rnd=" + rndNo;           
        }    