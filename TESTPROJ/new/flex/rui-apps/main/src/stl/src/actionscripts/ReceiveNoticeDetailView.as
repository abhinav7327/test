// ActionScript file
// ActionScript file

 // ActionScript file for Trade Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import flash.events.MouseEvent;
    
    import mx.collections.ArrayCollection;
    import mx.rpc.events.ResultEvent;
    import mx.events.DataGridEvent;
    
    [Bindable]
    //private var initColl:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var dkViewListColl:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var xmlSource:XML= new XML();
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    public var o:Object = {};
    
    [Bindable]
    private var receivedCompNoticeInfoPk:String;
    private var instrumentPkforDetail:String;
    	   
            
    public function parseUrlString():void {
        try {
            // Remove everything before the question mark, including
            // the question mark.
            var myPattern:RegExp = /.*\?/; 
            var s:String = this.loaderInfo.url.toString();
            s = s.replace(myPattern, "");
            // Create an Array of name=value Strings.
            var params:Array = s.split("&"); 
             // Print the params that are in the Array.
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
          
            // Set the values of the salutation.
            for (var i:int = 0; i < params.length; i++) {
                var tempA:Array = params[i].split("=");  
                if (tempA[0] == Globals.RECEIVED_COMP_NOTICE_INFO_PK) {
                    o.receivedCompNoticeInfoPk = tempA[1];
                    receivedCompNoticeInfoPk = o.receivedCompNoticeInfoPk;
//                    XenosAlert.info("receivedCompNoticeInfoPk =" + receivedCompNoticeInfoPk);                    
                }
            } 
            
        } catch (e:Error) {
            trace(e);
        }
       
    }
     
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    public function LoadResultPage(event:ResultEvent):void {
        
        var rs:XML = XML(event.result); 
               
        if (null != event) {
			if(rs.child("receiveNoticeView").length()>0) {
				errPage.clearError(event);
				
				xmlSource = XML(rs.receiveNoticeView);				
				//For security Side details
				if(XenosStringUtils.equals(xmlSource.settlementType, "AGAINST") || !XenosStringUtils.isBlank(xmlSource.quantityStr) ){
				    ws2.includeInLayout = true;
				    ws2.visible = true;
				    
				    if(!XenosStringUtils.isBlank(xmlSource.extSecurityDisplayStr) && rs.isSecurityRegistered == "Y" && rs.isDuplicateSecurity != "Y"){
				        secSideSecurity.useHandCursor = true;
    				    secSideSecurity.styleName = "TextLink";
    				    secSideSecurity.buttonMode=true;
    				    secSideSecurity.mouseChildren = false;
    				    
    				    secSideSecurity.text = xmlSource.extSecurityDisplayStr;
    				    instrumentPkforDetail = rs.instrumentPk;
    				    
    				    secSideSecurity.addEventListener(MouseEvent.CLICK,showInstrumentDetail);    				    
				    }else if(!XenosStringUtils.isBlank(xmlSource.extSecurityDisplayStr)){
				        secSideSecurity.text = xmlSource.extSecurityDisplayStr;
				    }else if(rs.isSecurityRegistered == "Y" && rs.isDuplicateSecurity != "Y"){
				        secSideSecurity.useHandCursor = true;
    				    secSideSecurity.styleName = "TextLink";
    				    secSideSecurity.buttonMode=true;
    				    secSideSecurity.mouseChildren = false;
    				    
    				    secSideSecurity.text = xmlSource.securityId;
    				    instrumentPkforDetail = rs.instrumentPk;
    				    
    				    secSideSecurity.addEventListener(MouseEvent.CLICK,showInstrumentDetail);
				    }else{
				        secSideSecurity.text = xmlSource.securityId;
				    }
				    
				    
				}else{
				    ws2.includeInLayout = false;
				    ws2.visible = false;
				}
				//For Cash side details
				if(xmlSource.settlementType == "AGAINST" || !XenosStringUtils.isBlank(xmlSource.amountStr) ){
				    ws3.includeInLayout = true;
				    ws3.visible = true;
				    
				    if(xmlSource.settlementType == "FREE"){
				        cashAmtRow.includeInLayout = false;
				        cashAmtRow.visible = false;
				    }else{
				        cashAmtbalRow.includeInLayout = false;
				        cashAmtbalRow.visible = false;
				        cashTaxAmtRow.includeInLayout = false;
				        cashTaxAmtRow.visible = false;
				    }
				    
				}else{
				    ws3.includeInLayout = false;
				    ws3.visible = false;
				}
				
				//populate dkViewListColl with receiveNoticeQueryActionForm.receiveNoticeView.dkViewList
				
				if(null != xmlSource && xmlSource.child("dkViewList").length()>0) {
    				
    				dkViewListColl.removeAll();
    				try {
    					for each ( var rec:XML in xmlSource.dkViewList ) {
    						dkViewListColl.addItem(rec);
    					}
    					dkViewListColl.refresh();
    				} catch(e:Error) {
    					XenosAlert.error("No Result Found DK Instruction History : " + e.getStackTrace());
    				}
				
				}
				//For Controlling the Submit Buttons
				
				
				
				
			} else if(rs.child("Errors").length()>0) {				
				var errorInfoList : ArrayCollection = new ArrayCollection();
				//populate the error info list 			 	
				for each ( var error:XML in rs.Errors.error ) {
					errorInfoList.addItem(error.toString());
				}
				errPage.showError(errorInfoList);//Display the error
				
			} else {
				XenosAlert.info("Data Not Populated");				
				errPage.clearError(event); //clears the error if any
			}
		} else {			
			XenosAlert.info("Data Not Populated");
		}
    }
   
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.ReceivedCompNoticeInfoPk = receivedCompNoticeInfoPk;
         return reqObj;
    }
    
    private function showInstrumentDetail(event:MouseEvent):void{
        //var InstPkStr : String = xmlSource.detailView.summary.instrumentPk;
		var parentApp :UIComponent = UIComponent(this.parentApplication);
		XenosPopupUtils.showInstrumentDetails(instrumentPkforDetail, parentApp);
        
    }
    /**
 	 * datagrid header release event handler to handle datagridcolumn sorting
 	 */
	public function dataGrid_headerRelease(evt:DataGridEvent):void {				
		//sortUtil.clickedColumn=evt.dataField;
		var dg:DataGrid = DataGrid(evt.currentTarget);
        sortUtil.clickedColumn = dg.columns[evt.columnIndex];		
	} 		