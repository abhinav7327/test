


// ActionScript file

 // ActionScript file for Trade Unmatch Popup
 		import com.nri.rui.core.Globals;
		import com.nri.rui.core.controls.XenosAlert;
		import com.nri.rui.core.renderers.SelectAllItem;
		import com.nri.rui.core.renderers.SelectItem;
		import com.nri.rui.core.utils.XenosStringUtils;
		
		import mx.collections.ArrayCollection;
		import mx.containers.TitleWindow;
		import mx.controls.dataGridClasses.DataGridColumn;
		import mx.events.CloseEvent;
		import mx.managers.PopUpManager;
		import mx.rpc.events.ResultEvent;

		[Bindable]private var selectedQryRslt:ArrayCollection = new ArrayCollection();
   		[Bindable]public var selIndexArray:Array = new Array();
   		[Bindable]private var mode : String = Globals.MODE_RCVD_CONF;
		
		/**
		 * This method initializes the unmatch popup screen. 
		 */
		private function init():void{
			parseUrlString();
			var obj:Object = new Object();
			obj.method= "validateTradeUnmatch";
	 		obj.selector = selIndexArray;
	 		obj.rnd = Math.random();
	 		if(XenosStringUtils.equals(mode,Globals.MODE_ALLOC_CXL) ){
	 			initializeUnmatchUserconf.url = "trd/tradeAllocCxlQueryDispatch.action?"
	 		}else if (XenosStringUtils.equals(mode,Globals.MODE_RCVD_CONF) ){
	 			initializeUnmatchUserconf.url = "trd/tradeRcvdConfQueryDispatch.action?"
	 		}
	 		initializeUnmatchUserconf.request = obj;
			initializeUnmatchUserconf.send();
		}
       
       
       /**
       * This method loads the unmatch popup screen
       * 
       * */
       public function loadUserConfPage(event:ResultEvent):void {
	       	var rs:XML = XML(event.result);
			if (null != event) {
				if(rs.child("row").length() > 0) {
					errPageConf.clearError(event);
		            selectedQryRslt.removeAll();
				    for each ( var rec:XML in rs.row ) {
	 				    selectedQryRslt.addItem(rec);
				    }
				 	selectedQryRslt.refresh();
				 } else if(rs.child("Errors").length()>0) {
				 	selectedQryRslt.removeAll(); 
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
				 	var errorStr:String = XenosStringUtils.EMPTY_STR;
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorStr = errorStr + error.toString() + "\n";
					}
					XenosAlert.error(errorStr);
					this.closeHandeler();
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	selectedQryRslt.removeAll(); 
				 	errPageConf.removeError();
				 	this.closeHandeler();
				 }
	        }
       }
       
       
       /**
       * 
       * This method fires action method for going to unmatch
       * system confirmation screen.
       * 
       * */
       private function goToSystemConfirmation():void {
	       	var obj:Object = new Object();
		 	obj.method = "processForUnmatch";
	 		obj.rnd = Math.random();
	 		if( XenosStringUtils.equals(mode,Globals.MODE_ALLOC_CXL) ){
	 			tradeUnmatchSysConfRequest.url = "trd/tradeAllocCxlQueryDispatch.action?"
	 		}else if ( XenosStringUtils.equals(mode,Globals.MODE_RCVD_CONF) ){
	 			tradeUnmatchSysConfRequest.url = "trd/tradeRcvdConfQueryDispatch.action?"
	 		}
		    tradeUnmatchSysConfRequest.request = obj;
		    tradeUnmatchSysConfRequest.send();
       }
       
       
       /**
       * This method loads the system confirmation page for trade unmatch.
       * */
       public function loadSystemConfPage(event:ResultEvent):void {
       	    var rs:XML = XML(event.result);
			if (null != event) {
				if(rs.child("row").length() > 0) {
					confLbl.text = this.parentApplication.xResourceManager.getKeyValue('trd.entry.match.sys.conf');
					errPageConf.clearError(event);
		            selectedQryRslt.removeAll();
				    for each ( var rec:XML in rs.row ) {
	 				    selectedQryRslt.addItem(rec);
				    }
				 	selectedQryRslt.refresh();
				    this.btnCommit.visible = false;
				    this.btnCommit.includeInLayout = false;
				    this.btnCxl.visible = false;
				    this.btnCxl.includeInLayout = false;
				    this.btnOk.visible = true;
				    this.btnOk.includeInLayout = true;
				 } else if(rs.child("Errors").length()>0) {
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPageConf.showError(errorInfoList);
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	selectedQryRslt.removeAll(); 
				 	errPageConf.removeError();
				 }
	        }
       }
       
	   public function closeHandeler():void{
	        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
       }
       public function resetDataGrid():void{
       	     parentDocument.owner.submitQuery();
       }
       
        /**
        * This method parses the url associated with this module.
        * */      
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
	                }else if (tempA[0] == Globals.MODE ) {
                        mode = tempA[1];
                    }
	            }
	        } catch (e:Error) {
	            trace(e);
	        }
	    }