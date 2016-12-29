// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
import com.nri.rui.ref.validators.SwiftMessageSearchValidator;
              
      
        [Bindable]
       	private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE); 
       	        
        [Bindable]
        private var queryResult:ArrayCollection= new ArrayCollection();    
         
        private var keylist:ArrayCollection = new ArrayCollection();      
                     
        [Bindable]
        private var initCol:ArrayCollection = new ArrayCollection();
   
        private var csd:CustomizeSortOrder = null;         
        private var sortFieldArray:Array = new Array();
        private var sortFieldDataSet:Array = new Array();
        private var sortFieldSelectedItem:Array = new Array();
        private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
        private var initCompFlg : Boolean = false;
        private var invalidData:Boolean = false;
           
        [Bindable]
        private var mode : String = "query";
      
      /**
      * Initialize Page
      */ 
        private function initPageStart():void {           
        if (!initCompFlg) {            
            var req : Object = new Object();
            req.SCREEN_KEY = 12028;
            initializeSwiftSearch.request = req;
            initializeSwiftSearch.url = "ref/swiftMsgQueryDispatch.action?method=initialExecute&screenType=M";                    
            initializeSwiftSearch.send();        
        } else
            XenosAlert.info("Already Initiated!");
         
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
                    trace(s);
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
         
        /**
        *Reset the page and populate the drop downs and date fields 
        */
        private function initPage(event: ResultEvent):void {
        //	XenosAlert.info("Inside initial execute");
            var selIndx:int = 0;
            var i:int = 0;
            var tempColl: ArrayCollection = new ArrayCollection();
            this.senderRefNo.text = "";
            this.senderBic.text = "";
            this.receiverBic.text = "";
            this.searchText.text = "";
            this.senderRefNo.setFocus();
            qh.pdf.enabled = true;
            qh.pdf.includeInLayout = true;
            qh.xls.enabled = true;
            qh.xls.includeInLayout = true;
            
            errPage.clearError(event);
            invalidData = false;
            
            if(event == null || event.result == null || event.result.swiftMsgQueryActionForm == null){
            XenosAlert.error("Failed to Initialize the Form");
            return;
           }
           
            if(event.result.swiftMsgQueryActionForm.swiftMessagesTypeList.item != null) {
            if(event.result.swiftMsgQueryActionForm.swiftMessagesTypeList.item is ArrayCollection)
                initCol = event.result.swiftMsgQueryActionForm.swiftMessagesTypeList.item as ArrayCollection;
            else
                initCol.addItem(event.result.swiftMsgQueryActionForm.swiftMessagesTypeList.item);
           }
          // XenosAlert.info("Message Type ::" + initCol.length);
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            for(i = 0; i<initCol.length; i++) {                      
              tempColl.addItem(initCol[i]);            
            }
           this.msgType.dataProvider = tempColl;
           this.receiveDateFrom.selectedDate = DateUtils.toDate(event.result.swiftMsgQueryActionForm.receiveDateFrom.toString());
           this.receiveDateTo.selectedDate = DateUtils.toDate(event.result.swiftMsgQueryActionForm.receiveDateFrom.toString());	
          
           var sortField1Default:String = event.result.swiftMsgQueryActionForm.sortField1.toString();
        
           var sortField2Default:String = event.result.swiftMsgQueryActionForm.sortField2.toString();
             
           var sortField3Default:String = event.result.swiftMsgQueryActionForm.sortField3.toString();

             // Sort Field 1 
             if(null != event.result.swiftMsgQueryActionForm.sortFieldList1.item) {
                initCol = new ArrayCollection();
                tempColl = new ArrayCollection();
                tempColl.addItem({label:" ", value: " "});
                selIndx = 0;
                
                if(event.result.swiftMsgQueryActionForm.sortFieldList1.item is ArrayCollection) {
                    for each(var item1:Object in (event.result.swiftMsgQueryActionForm.sortFieldList1.item as ArrayCollection)) {
                        initCol.addItem(item1);
                    }
                } else {
                    initCol.addItem(event.result.swiftMsgQueryActionForm.sortFieldList1.item);
                }
                for(i = 0; i<initCol.length; i++) {
                    //Get the default value object's index
                    if(XenosStringUtils.equals((initCol[i].value), sortField1Default)) {                    
                        selIndx = i;
                    }
                    tempColl.addItem(initCol[i]);            
                }
                
                sortFieldArray[0] = sortField1;
                sortFieldDataSet[0] = tempColl;
                //Set the default value object
                sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
            } else {
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.swiftmessage.error.sortfield1'));
            }
            
            // Sort Field2
            if(null != event.result.swiftMsgQueryActionForm.sortFieldList2.item) {
                initCol = new ArrayCollection();
                tempColl = new ArrayCollection();
                tempColl.addItem({label:" ", value: " "});
                selIndx = 0;
                
                if(event.result.swiftMsgQueryActionForm.sortFieldList2.item is ArrayCollection) {
                    for each(var item2:Object in (event.result.swiftMsgQueryActionForm.sortFieldList2.item as ArrayCollection)) {
                        initCol.addItem(item2);
                    }
                } else {
                    initCol.addItem(event.result.swiftMsgQueryActionForm.sortFieldList2.item);
                }
                for(i = 0; i<initCol.length; i++) {
                    //Get the default value object's index
                    if(XenosStringUtils.equals((initCol[i].value), sortField2Default)) {                    
                        selIndx = i;
                    }
                    tempColl.addItem(initCol[i]);            
                }
                
                sortFieldArray[1] = sortField2;
                sortFieldDataSet[1] = tempColl;
                //Set the default value object
                sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
            } else {
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.swiftmessage.error.sortfield2'));
            }    
          
          // Sort Field3
          if(null != event.result.swiftMsgQueryActionForm.sortFieldList3.item) {
                initCol = new ArrayCollection();
                tempColl = new ArrayCollection();
                tempColl.addItem({label:" ", value: " "});
                selIndx = 0;
                
                if(event.result.swiftMsgQueryActionForm.sortFieldList3.item is ArrayCollection) {
                    for each(var item3:Object in (event.result.swiftMsgQueryActionForm.sortFieldList3.item as ArrayCollection)) {
                        initCol.addItem(item3);
                    }
                } else {
                    initCol.addItem(event.result.swiftMsgQueryActionForm.sortFieldList3.item);
                }
                for(i = 0; i<initCol.length; i++) {
                    //Get the default value object's index
                    if(XenosStringUtils.equals((initCol[i].value), sortField3Default)) {                    
                        selIndx = i;
                    }
                    tempColl.addItem(initCol[i]);            
                }
                sortFieldArray[2] = sortField3;
                sortFieldDataSet[2] = tempColl;
                //Set the default value object
                sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
            } else {
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.swiftmessage.error.sortfield3'));
            }
          
            csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
            csd.init();
            initCompFlg = true;   
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
        
        /**
        * This method will populate the request parameters for the
        * submitQuery call and bind the parameters with the HTTPService
        * object.
        */
        private function populateRequestParams():Object {
            var reqObj : Object = new Object();
            reqObj.senderRefNo = this.senderRefNo.text;
            if(this.msgType.selectedItem!= null){
            reqObj.msgType = StringUtil.trim(this.msgType.selectedItem.value);
            }else{
            	reqObj.msgType = this.msgType.text;
            }
            reqObj.receiverBic = this.receiverBic.text;
            reqObj.senderBic = this.senderBic.text;
            reqObj.searchText =  this.searchText.text;
            reqObj.receiveDateFrom = this.receiveDateFrom.text;
            reqObj.receiveDateTo = this.receiveDateTo.text;
            //reqObj.method = "submitQuery";
	    	reqObj.SCREEN_KEY = "12028";
            reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : Globals.EMPTY_STRING;
            reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : Globals.EMPTY_STRING;
            reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : Globals.EMPTY_STRING; 
            return reqObj;
        } 
                   
        /**
         *Load Result Page
         * 
         */       
         private function loadResultPage(event:ResultEvent):void {
         	 var rs:XML = XML(event.result);
         	 submit.enabled = true;
         	 if (null != event) {
         	 	 if(rs.child("swiftMessageList").length()>0) {
         	 	 	queryResult.removeAll();
         	 	 	  try {
				            for each ( var rec:XML in rs.swiftMessageList.swiftMessage) {
	 				         	 queryResult.addItem(rec);
				            }
				          }catch(e:Error)	{
				             XenosAlert.error(e.toString() + e.message);
				             XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			              }
			              if(queryResult.length>0){
			              		changeCurrentState();
			              		qh.setOnResultVisibility();
			              		qh.PopulateDefaultVisibleColumns(); 
			              		qh.setPrevNextVisibility(((rs.child("prevTraversable") == "true") ? true : false), ((rs.child("nextTraversable") == "true") ? true : false));
			              }
			              else{
			              	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	            queryResult.removeAll(); // clear previous data if any as there is no result now.
			 	            errPage.removeError();
			              }
         	 	 }else if(rs.child("Errors").length()>0) {
              				//some error found
			 				queryResult.removeAll(); // clear previous data if any as there is no result now.
			 				var errorInfoList : ArrayCollection = new ArrayCollection();
               				//populate the error info list 			 	
			 				for each ( var error:XML in rs.Errors.error ) {
	 			  				 errorInfoList.addItem(error.toString());
							}
			 				errPage.showError(errorInfoList);//Display the error
				 } else {
			 			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 			queryResult.removeAll(); // clear previous data if any as there is no result now.
			 			errPage.removeError(); //clears the errors if any
				 }
         	 }
         }

    
     /**
     * This method sends the HttpService for reset operation.
     * 
     */    
        public function resetQuery():void{
          submit.enabled = true;	
          var reqObj : Object = new Object();
     	  reqObj.rnd = Math.random();
          swiftSearchResetQueryRequest.request = reqObj;
          swiftSearchResetQueryRequest.send();
       }
            
     /**
     * Submit Query
     * 
     */        
        public function submitQuery():void{
    	//Reset Page No
    	trace("Submit query");
    	 qh.resetPageNo();
    	 submit.enabled = false;
     	
     	 var validateModel:Object = {
                                      swiftMessageSearch:{                                 
                                      		receiveDateFrom:this.receiveDateFrom.text,
                                            receiveDateTo:this.receiveDateTo.text
                                            }
                                       }; 
            //XenosAlert.info("Inside validator");                           
          var dateValidator:SwiftMessageSearchValidator = new SwiftMessageSearchValidator();
          dateValidator.source = validateModel;
          dateValidator.property = "swiftMessageSearch";
          var validationResult:ValidationResultEvent = dateValidator.validate();
     	  if(validationResult.type==ValidationResultEvent.INVALID){
     	  	     submit.enabled = true;
                 var errorMsg:String=validationResult.message;
                 XenosAlert.error(errorMsg);
          }else{
            	 var requestObj :Object = populateRequestParams();
     	         swiftSearchRequest.request = requestObj; 
                 swiftSearchRequest.send();  
          }
    }   
    
    
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
         var url : String = "ref/swiftMsgQueryDispatch.action?method=generateXLS";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        // set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
         try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            } 
    } 
    /**
    * This will generate the Pdf report for the entire query result set 
    * and will open in a separate window.
    */
     private function generatePdf():void {
        var url : String = "ref/swiftMsgQueryDispatch.action?method=generatePDF";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        // set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
         try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            } 
    }    
    
      private function dispatchNextEvent():void {
        	doNextRequest.send(); 
        } 
         
      private function dispatchPrevEvent():void {
            doPreviousRequest.send(); 
        }         
          