
// ActionScript file for CashReferDtlQueryResult
import com.nri.rui.core.Globals;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.XenosAlert;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;


/**
 * Event handler for the "OkSystemConfirm" custom event.
 */
public function handleOkSystemConfirm(event:Event):void {
    //XenosAlert.info("handleOkSystemConfirm");
    //this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
    //this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));   
    //this.parentDocument.cashRefDtlHttpServiceRefresh.send();
    this.selectCheckBox = false;
    initService();
}
/**
 * Event handler for the "RefreshChanges" custom event.
 */
public function handleRefreshChanges(event:Event):void {
//    XenosAlert.info("handleRefreshChanges");    
    this.selectCheckBox = true;
    this.refreshData();
}
/**
 * Go to the previous window.
 */ 
private function doBack(event:MouseEvent):void{
    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
}

/**
 * This method should be called on creationComplete of the datagrid 
 */ 
private function bindDataGrid():void {	
    qh.dgrid = cashReferDtlDG;	
}

/**
* This is for the Print button which at a  time will print all the data 
* in the dataprovider of the Datagrid object
*/
 private function doPrint():void{
   	// do nothing
}

/**
* This method sends the HttpService for Next Set of results operation.
* This is actually server side pagination for the next set of results.
*/ 
  private function doNext():void { 
    var reqObj : Object = new Object();
    reqObj.method = "doNext";
    reqObj.listIndex = "2";
    reqObj.rnd = Math.random()+"";
    cashRefDtlHttpService.request = reqObj;
    cashRefDtlHttpService.send();
}  
/**
* This method sends the HttpService for Previous Set of results operation.
* This is actually server side pagination for the previous set of results.
*/ 
  private function doPrev():void { 
    var reqObj : Object = new Object();
    reqObj.method = "doPrevious";
    reqObj.listIndex = "2";
    reqObj.rnd = Math.random()+"";
    cashRefDtlHttpService.request = reqObj;
    cashRefDtlHttpService.send();
}

 


/**
 * Entry for Remarks.
 */
private function doRemarksEntry(event:MouseEvent):void{
    var fromPage:String = "queryResultSecBal";
    var parentApp :UIComponent = UIComponent(this.parentApplication);
    if(null == movArray){
        XenosAlert.info("No Record To Proceed");
        return;
    }else if(movArray.length == 0){
        XenosAlert.info("Please Select Record To Proceed");
        return;        
    }       

    var sPopup : SummaryPopup;	
	sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
	
	sPopup.addEventListener("OkSystemConfirm",handleOkSystemConfirm);
	sPopup.addEventListener("RefreshChanges",handleRefreshChanges);
	sPopup.title = this.parentApplication.xResourceManager.getKeyValue('rec.xenos.cash.label.remarks') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.entry'); 
	sPopup.width = parentApp.width - 100;
	sPopup.height = parentApp.height - 100;
	PopUpManager.centerPopUp(sPopup);
	
	sPopup.moduleUrl = "assets/appl/rec/SecRemarksEntryPopUp.swf"+Globals.QS_SIGN+"movArray"+Globals.EQUALS_SIGN+movArray+Globals.AND_SIGN+"fromPage"+Globals.EQUALS_SIGN+fromPage;
	//XenosAlert.info("Module URL :: "+sPopup.moduleUrl);
}

 	/**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "rec/recXenosSecBalDispatch.action?method=generateXLS&fromPage=queryResultMov";
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
        var url : String = "rec/recXenosSecBalDispatch.action?method=generatePDF&fromPage=queryResultMov";
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


 
 