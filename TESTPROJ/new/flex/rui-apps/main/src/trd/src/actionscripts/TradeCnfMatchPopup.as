


// ActionScript file

 // ActionScript file for Trade Match Popup
 		import com.nri.rui.core.Globals;
		import com.nri.rui.core.RendererFectory;
		import com.nri.rui.core.controls.XenosAlert;
		import com.nri.rui.core.renderers.SelectAllItem;
		import com.nri.rui.core.renderers.SelectItem;
		import com.nri.rui.core.utils.XenosStringUtils;
		import com.nri.rui.trd.renderers.SelectMatchButtonRenderer;
		
		import mx.collections.ArrayCollection;
		import mx.containers.TitleWindow;
		import mx.controls.CheckBox;
		import mx.controls.RadioButtonGroup;
		import mx.controls.dataGridClasses.DataGridColumn;
		import mx.events.CloseEvent;
		import mx.managers.PopUpManager;
		import mx.rpc.events.ResultEvent;

		[Embed(source="../../assets/img/inf/addcolunm.png")]
			    
		[Bindable]private var icoColumns:Class;
		[Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
		[Bindable]private var selectedQryRslt:ArrayCollection = new ArrayCollection();
   		[Bindable]public var selIndexArray:Array = new Array();
   		[Bindable]public var parentAllocConfFlag:String = null;
   		[Bindable]public var radioGroup:RadioButtonGroup = new RadioButtonGroup();
   		[Bindable]public var selectAllBind:Boolean = false;
   		[Bindable]private var selectedResults:ArrayCollection = new ArrayCollection();
   		[Bindable]private var conformSelectedResults : Array = new Array(); 
   		[Bindable]private var mode : String = Globals.MODE_RCVD_CONF;
		
		/**
		 * This method initializes the match popup screen. 
		 */
		private function init():void{
			parseUrlString();
			vstack.selectedChild = qry;
			var obj:Object = new Object();
			obj.method= "loadQueryResult";
	 		obj.selector = selIndexArray;
	 		obj.allocationConfirmationFlag = parentAllocConfFlag;
	 		obj.rnd = Math.random();
	 		if(XenosStringUtils.equals(mode,Globals.MODE_ALLOC_CXL) ){
	 			initializeTradeCnfMatchQuery.url = "trd/tradeAllocCxlQueryDispatch.action?"
	 		}else if (XenosStringUtils.equals(mode,Globals.MODE_RCVD_CONF) ){
	 			initializeTradeCnfMatchQuery.url = "trd/tradeRcvdConfQueryDispatch.action?"
	 		}
	 		initializeTradeCnfMatchQuery.request = obj;
			initializeTradeCnfMatchQuery.send();
		}
		  /**
		   * This method is the resulthandler method which initializes
		   * the match popup screen. 
		   */
          public function loadCnfQueryPopupPage(event:ResultEvent):void {
          	var rs:XML = XML(event.result);
			if (null != event) {
				if(rs.child("row").length() > 0) {
					errPage.clearError(event);
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
				 	errPage.removeError(); 
				 	this.closeHandeler();//clears the errors if any
				 }
	        }
       }
       
       private function goToUserConfirmation():void {
       		if(conformSelectedResults != null){
       			if(conformSelectedResults.length > 0){
       				var obj:Object = new Object();
				 	obj.method = "confirmTradeMatch";
				 	var selectedIndexArray:Array = new Array();
			       	for(var i:int = 0; i<conformSelectedResults.length; i++){
				 		selectedIndexArray.push(conformSelectedResults[i].rowNum);
				 	}
			 		obj.matchSelector = selectedIndexArray;
			 		obj.rnd = Math.random();
			 		if(XenosStringUtils.equals(mode,Globals.MODE_ALLOC_CXL) ){
			 			tradeMatchUserConfRequest.url = "trd/tradeAllocCxlQueryDispatch.action?"
			 		}else if (XenosStringUtils.equals(mode,Globals.MODE_RCVD_CONF) ){
			 			tradeMatchUserConfRequest.url = "trd/tradeRcvdConfQueryDispatch.action?"
			 		}
				    tradeMatchUserConfRequest.request = obj;
				    tradeMatchUserConfRequest.send();
       			} else {
       				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.trade.notselected'));
       			}
       		}else{
       			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.trade.notselected'));
       		}
       }
       
       public function loadUserConfPage(event:ResultEvent):void {
	       	var rs:XML = XML(event.result);
			if (null != event) {
				if(rs.child("row").length() > 0) {
					confLbl.text = this.parentApplication.xResourceManager.getKeyValue('trd.entry.match.user.conf');
					errPage.clearError(event);
					errPageConf.clearError(event);
		            selectedQryRslt.removeAll();
				    for each ( var rec:XML in rs.row ) {
	 				    selectedQryRslt.addItem(rec);
				    }
				 	selectedQryRslt.refresh();
				    vstack.selectedChild = rslt;
				    this.btnOk.visible = false;
				    this.btnOk.includeInLayout = false;
				 } else if(rs.child("Errors").length()>0) {
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);//Display the error
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	selectedQryRslt.removeAll(); // clear previous data if any as there is no result now.
				 	errPage.removeError(); 
				 	errPageConf.removeError();//clears the errors if any
				 }
	        }
       }
       
       private function goToSystemConfirmation():void {
	       	var obj:Object = new Object();
		 	obj.method = "findAndMatchTrade";
	 		obj.rnd = Math.random();
	 		if(XenosStringUtils.equals(mode,Globals.MODE_ALLOC_CXL) ){
	 			tradeMatchSysConfRequest.url = "trd/tradeAllocCxlQueryDispatch.action?"
	 		}else if (XenosStringUtils.equals(mode,Globals.MODE_RCVD_CONF) ){
	 			tradeMatchSysConfRequest.url = "trd/tradeRcvdConfQueryDispatch.action?"
	 		}
		    tradeMatchSysConfRequest.request = obj;
		    tradeMatchSysConfRequest.send();
       }
       
       public function loadSystemConfPage(event:ResultEvent):void {
       	    var rs:XML = XML(event.result);
			if (null != event) {
				if(rs.child("row").length() > 0) {
					confLbl.text = this.parentApplication.xResourceManager.getKeyValue('trd.entry.match.sys.conf');
					errPage.clearError(event);
					errPageConf.clearError(event);
		            selectedQryRslt.removeAll();
				    for each ( var rec:XML in rs.row ) {
	 				    selectedQryRslt.addItem(rec);
				    }
				 	selectedQryRslt.refresh();
				    this.btnOk.visible = true;
				    this.btnOk.includeInLayout = true;
				    this.btnBack.visible = false;
				    this.btnBack.includeInLayout = false;
				    this.btnCommit.visible = false;
				    this.btnCommit.includeInLayout = false;
				 } else if(rs.child("Errors").length()>0) {
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPageConf.showError(errorInfoList);//Display the error
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	selectedQryRslt.removeAll(); // clear previous data if any as there is no result now.
				 	errPage.removeError(); 
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
         vstack.selectedChild = qry;
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
       
               
	    private function parseUrlString():void {
	        try {
	            var myPattern:RegExp = /.*\?/; 
	            var s:String = this.loaderInfo.url.toString();
	            s = s.replace(myPattern, "");
	            var params:Array = s.split("&"); 
	            for (var i:int = 0; i < params.length; i++) {
	                var tempA:Array = params[i].split("=");
	                if(tempA[0] == "selIndexArr"){
	                	var selectedRowNum:String = tempA[1];
	                	if(selectedRowNum.indexOf(",",0)){
	                		var selArr:Array = selectedRowNum.split(",");
	                		for(var j:int = 0 ; j<selArr.length ; j++){
	                			selIndexArray.push(selArr[j]);
	                		}
	                	}else {
	                		selIndexArray.push(selectedRowNum);
	                	}
	                }else if(tempA[0] == "parentAllocConfFlag"){
	                	parentAllocConfFlag = tempA[1];
	                }else if (tempA[0] == Globals.MODE ) {
                        mode = tempA[1];
                    }
	            }
	        } catch (e:Error) {
	            trace(e);
	        }
	    }