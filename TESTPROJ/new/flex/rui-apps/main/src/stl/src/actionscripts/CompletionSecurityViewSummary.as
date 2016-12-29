
 import com.nri.rui.core.utils.PrintUtils;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.stl.StlConstants;
 
 import flash.net.URLRequest;
 import flash.net.URLRequestMethod;
 
 import mx.collections.ArrayCollection;
 import mx.rpc.events.ResultEvent;
 
 [Bindable]
 private var summaryResult:ArrayCollection= new ArrayCollection();
 [Bindable]
 private var securityShortName:String;
 [Bindable]
 private var securityCodeDisplay:String;
 
 	/**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function submitDetailQuery():void {  
    	parseUrlString();
    	
    	var req : Object = new Object();
    	req.instrumentPk=instrumentPk;
    	complSecurityDetail.request=req;
    	
    	complSecurityDetail.send();
    }
    
    private function parseUrlString():void {
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
                if (tempA[0] == StlConstants.INSTRUMENT_PK) {
                    instrumentPk = tempA[1];
                } 
            }                    
			
        } catch (e:Error) {
            trace(e);
        }
       
    }
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = secViewSummary;
    } 
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    private function onResult(event:ResultEvent):void {
    	
    	var rs:XML = XML(event.result);

		if (null != event) {
			if(rs.child("row").length()>0) {
				errPage.clearError(event);
				summaryResult.removeAll();
				try {
					for each ( var rec:XML in rs.secrow ) {
						summaryResult.addItem(rec);
					}
					
					securityCodeDisplay = rs.securityCodeDisplay;
                	securityShortName = rs.securityShortName;
					
					qh.setOnResultVisibility();	
					//qh.print.enabled=true;
					qh.PopulateDefaultVisibleColumns();
					
					summaryResult.refresh();
				} catch(e:Error) {
					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				}
			} else if(rs.child("Errors").length()>0) {
				//some error found
				summaryResult.removeAll(); // clear previous data if any as there is no result now.
				var errorInfoList : ArrayCollection = new ArrayCollection();
				//populate the error info list 			 	
				for each ( var error:XML in rs.Errors.error ) {
					errorInfoList.addItem(error.toString());
				}
				errPage.showError(errorInfoList);//Display the error
				
			} else {
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				summaryResult.removeAll(); // clear previous data if any as there is no result now.
				errPage.clearError(event); //clears the error if any
			}
			summaryResult.refresh();
		} else {
			summaryResult.removeAll();
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}
    }
    
   /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
     
     	var url : String = "stl/stlCompletionSummaryDispatch.action?method=generateXLS&pageId=detail";
    	var request:URLRequest = new URLRequest(url);
    	request.method = URLRequestMethod.POST;
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
     	
     	var url : String = "stl/stlCompletionSummaryDispatch.action?method=generatePDF&pageId=detail";
    	var request:URLRequest = new URLRequest(url);
    	request.method = URLRequestMethod.POST;
    	 try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            }
     }
     
     private function printCompletionSecurityViewSummary():void {
     	PrintUtils.printDetail(this.compSecViewSummary);
     }