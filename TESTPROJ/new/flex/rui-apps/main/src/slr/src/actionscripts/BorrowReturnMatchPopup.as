


// ActionScript file

 // ActionScript file for Trade Match Popup
 		import com.nri.rui.core.Globals;
 		import com.nri.rui.core.controls.XenosAlert;
 		import com.nri.rui.core.startup.XenosApplication;
 		import com.nri.rui.core.utils.XenosStringUtils;
 		
 		import mx.collections.ArrayCollection;
 		import mx.controls.RadioButtonGroup;
 		import mx.events.CloseEvent;
 		import mx.rpc.events.ResultEvent;

		[Embed(source="../../assets/img/inf/addcolunm.png")]
			    
		[Bindable]private var icoColumns:Class;
		[Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
		//[Bindable]private var selectedQryRslt:ArrayCollection = new ArrayCollection();
   		[Bindable]public var selIndexArray:Array = new Array();
   		[Bindable]public var parentAllocConfFlag:String = null;
   		[Bindable]public var radioGroup:RadioButtonGroup = new RadioButtonGroup();
   		[Bindable]public var selectAllBind:Boolean = false;
   		[Bindable]private var selectedResults:ArrayCollection = new ArrayCollection();
   		[Bindable]private var conformSelectedResults : Array = new Array(); 
   		[Bindable]private var mode : String = Globals.MODE_RCVD_CONF;
   		[Bindable]private var selectedBorrowArray : Array; 
     	[Bindable]private var selectedReturnPk : int; 
     	[Bindable]public var selectedMatchStatus:String = null;
		[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
		/**
		 * This method initializes the match popup screen. 
		 */
		private function init():void{
			parseUrlString();
			var obj:Object = new Object();
	 		obj=populateRequestParams();
	 		obj.rnd = Math.random();
	 		obj.method="doPreConfirm";
	 		obj.SCREEN_KEY = "13010";
	 		borrowReturnMatchUConf.request = obj;
			borrowReturnMatchUConf.send();
		}
		
		 private function populateRequestParams():Object {
        	var reqObj : Object = new Object();        
			reqObj.selectedBrPkArray = selectedBorrowArray;
			reqObj.selectedRtPk = selectedReturnPk;
			reqObj.selMatchOperation = selectedMatchStatus;
        	return reqObj;
    	}
		  /**
		   * This method is the resulthandler method which initializes
		   * the match popup screen. 
		   */
          public function loadCnfQueryPopupPage(event:ResultEvent):void {
          	var rs:XML = XML(event.result);
			if (null != event) {
				if(rs.child("row").length() > 0) {
					//errPage.clearError(event);
		            queryResult.removeAll();
				    for each ( var rec:XML in rs.row ) {
	 				    queryResult.addItem(rec);
				    }
				 	queryResult.refresh();
				    loadRowNumber(queryResult);
	             	setIfAllSelected();
	             	this.btnOk.visible = false;
				    this.btnOk.includeInLayout = false;
				    this.btnBack.visible = true;
				    this.btnBack.includeInLayout = true;
				    this.btnCommit.visible = true;
				    this.btnCommit.includeInLayout = true;
				 } else if(rs.child("Errors").length()>0) {
	                //some error found
				 	queryResult.removeAll(); // clear previous data if any as there is no result now.
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
				 	var errorStr:String = "";
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorStr = errorStr + error.toString() + "\n";
					}
					XenosAlert.error(errorStr);
					this.closeHandeler();
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	queryResult.removeAll(); // clear previous data if any as there is no result now.
				 	//errPage.removeError(); 
				 	this.closeHandeler();//clears the errors if any
				 }
	        }
       }
		public function loadUserConfPage(event:ResultEvent):void
		{
			this.btnCommit.enabled = true;
			if(null != event){
			   var rs:XML = XML(event.result);
			   queryResult.removeAll();
			   if(rs.child("Errors").length()>0) {	   	    
		           var errorInfoList : ArrayCollection = new ArrayCollection();
		           for each ( var error:XML in rs.Errors.error ) {
		               errorInfoList.addItem(error.toString());               
		               trace(error.toString());                
		            }
		           errPageConf.showError(errorInfoList);//Display the error
		           this.btnCommit.enabled = false;
			   }else{
			   	   errPageConf.clearError(event);
		           if(rs.selectedRecordList != null) {
			            for each(var objXml:XML in rs.selectedRecordList){	        
			                queryResult.addItem(objXml);
			           }
			       }
			    }	
			}
		}
       
       private function goToSystemConfirmation():void {
       		btnBack.enabled = false;
       		btnCommit.enabled = false;
	       	var obj:Object = new Object();
		 	obj.method = "submitConfirm";
		 	obj.SCREEN_KEY = "13011";
	 		obj.rnd = Math.random();
		    tradeMatchSysConfRequest.request = obj;
		    tradeMatchSysConfRequest.send();
       }
       
       public function loadSystemConfPage(event:ResultEvent):void {
       	    var rs:XML = XML(event.result);
       	    this.btnBack.enabled = true;
       	    this.btnCommit.enabled = true;
			if (null != event) {
				if(rs.child("selectedRecordList").length() > 0) {
					confLbl.text = this.parentApplication.xResourceManager.getKeyValue('borrow.return.trd..match.system.conf');
//					errPage.clearError(event);
					errPageConf.clearError(event);
		            queryResult.removeAll();
				    for each ( var rec:XML in rs.selectedRecordList ) {
	 				    queryResult.addItem(rec);
				    }
				 	queryResult.refresh();
				 	this.sconfirmOK.visible = true;
				 	this.sconfirmOK.includeInLayout = true;
				 	this.btnOk.visible = true;
				    this.btnOk.includeInLayout = true;
				    this.btnBack.visible = false;
				    this.btnBack.includeInLayout = false;
				    this.btnCommit.visible = false;
				    this.btnCommit.includeInLayout = false;
				    this.uconfirmOk.visible = false;
				    this.uconfirmOk.includeInLayout = false;
				    hb.visible = true;
	               	hb.includeInLayout = true;
	               	if(XenosStringUtils.equals(selectedMatchStatus,"MATCH")) {
	               		txnRefNo.text = this.parentApplication.xResourceManager.getKeyValue('match.operation.label.successful.completion');
	               	} else if (XenosStringUtils.equals(selectedMatchStatus,"UNMATCH")) {
	               		txnRefNo.text = this.parentApplication.xResourceManager.getKeyValue('unmatch.operation.label.successful.completion');
	               	} else if (XenosStringUtils.equals(selectedMatchStatus,"MARK_AS_MATCH")) {
	               		txnRefNo.text = this.parentApplication.xResourceManager.getKeyValue('markmatch.operation.label.successful.completion');
	               	} else if (XenosStringUtils.equals(selectedMatchStatus,"CXL_MARK_AS_MATCH")) {
	               		txnRefNo.text = this.parentApplication.xResourceManager.getKeyValue('cxl.markmatch.operation.label.successful.completion');
	               	} 
				 } else if(rs.child("Errors").length()>0) {
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPageConf.showError(errorInfoList);//Display the error
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	queryResult.removeAll(); // clear previous data if any as there is no result now.
				 	//errPage.removeError(); 
				 	errPageConf.removeError();//clears the errors if any
				 }
	        }
       }
       
	   public function closeHandeler():void{
	        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
       }
       public function resetDataGrid():void{
       	     parentDocument.owner.submitQuery();
       }
       private function doBack():void{
        	this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
       }
       
       public function selectAllRecords(flag:Boolean): void {
	    	var i:Number = 0;
	    	selectedResults.removeAll();
	    	for(i=0; i<queryResult.length; i++){
	    		var obj:XML=queryResult[i];
	            obj.selected = flag;
	            queryResult[i]=obj;
	            addOrRemove(queryResult[i]);
	    	}
	    	conformSelectedResults = selectedResults.toArray();
	    }
	    
	    private function addOrRemove(item:Object):void {
	    	var i:Number;
	        var tempArray:Array = new Array();
	        if(item.selected == true){
	        	var obj:Object = new Object();
	        	obj.receivedConfirmationPk = item.receivedConfirmationPk;
	        	obj.tradePk = item.tradePk;
	        	obj.rowNum = item.rowNum;
	            selectedResults.addItem(obj);
	    	} else {
	    		tempArray = selectedResults.toArray();
	    	    selectedResults.removeAll();
	    		for(i=0; i<tempArray.length; i++){
	    			if(tempArray[i] != item.messageId)
	    			    selectedResults.addItem(tempArray[i]);
	    		}
	    	}	
	    }
	    
	    private function loadRowNumber(queryResult:ArrayCollection):void{
	    	for(var i:int=0 ; i<queryResult.length ; i++){
	    		queryResult[i].selected = false;
	    		queryResult[i].rowNum = i;
	    	}
	    }
	    
	    public function selectOneOption(item:Object):void {
	    	var obj:Object = new Object();
        	obj.receivedConfirmationPk = item.receivedConfirmationPk;
        	obj.tradePk = item.tradePk;
        	obj.rowNum = queryResult.getItemIndex(item);
        	if(conformSelectedResults.length > 0 && selectedResults.length > 0){
        		conformSelectedResults = null;
        		selectedResults.removeAll();
        	}
        	selectedResults.addItem(obj);
            conformSelectedResults = selectedResults.toArray();	
	    }
	    
	    public function checkSelectToModify(item:Object):void {
	        var i:Number;
	        var tempArray:Array = new Array();
	        if(item.selected == true){
	        	var obj:Object = new Object();
	        	obj.receivedConfirmationPk = item.receivedConfirmationPk;
	        	obj.tradePk = item.tradePk;
	        	obj.rowNum = item.rowNum;
	            selectedResults.addItem(obj);
	    	}else {
	    		tempArray = selectedResults.toArray();
	    	    selectedResults.removeAll();
	    		for(i=0; i<tempArray.length; i++){
	    			if(tempArray[i].receivedConfirmationPk != item.receivedConfirmationPk){
	    			    selectedResults.addItem(tempArray[i]);
	    			}
	    		}        		
	    	}    
	    	conformSelectedResults = selectedResults.toArray();
	    	setIfAllSelected();    	    	
	    }
	    
	    private function setIfAllSelected() : void {
	    	if(isAllSelected()){
	    		selectAllBind=true;
	    	} else {
	    		selectAllBind=false;
	    	}
	    }
	    
	    private function isAllSelected(): Boolean {
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
       
               
	    public function parseUrlString():void {
                try {
                    var myPattern:RegExp = /.*\?/; 
                    var s:String = this.loaderInfo.url.toString();
                    s = s.replace(myPattern, "");
                    var params:Array = s.split(Globals.AND_SIGN); 
                    var keyStr:String;
                    var valueStr:String;
                    var paramObj:Object = params;
                  
                    // Set the values of the salutation.
                    if(params != null){
                        for (var i:int = 0; i < params.length; i++) {
                            var tempA:Array = params[i].split("=");  
                            if(tempA[0] == "selBorrowArr"){
                                this.selectedBorrowArray = (tempA[1] as String).split(",");
                            } else if(tempA[0] == "selReturn"){
                                this.selectedReturnPk = tempA[1];
                            } else if(tempA[0] == "selMatchStatus") {
                            	this.selectedMatchStatus = tempA[1];
                            }
 
                        }                       
                    }                 

                } catch (e:Error) {
                    trace(e);
                }
            }
            
     private function submitOkConfirm():void{
		        var obj:Object=new Object();
				obj.method="okSystemConformation";
			    obj.unique= new Date().getTime() + "" ;
				sbrMatchOKConfirm.request=obj;
			    sbrMatchOKConfirm.send();
    }
    
     /**
	* Back to query result page. 
	*/
	 public function backToQueryResultPage():void {
		app.submitButtonInstance = null;
		closeHandeler();
	}
   