
// ActionScript file for CashReferDtlQueryResult
import com.nri.rui.core.Globals;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.formatters.XenosNumberFormatter;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;

/**
 * Entry for Cash Adjustment.
 */
private function doEntry(event:MouseEvent):void{
    var fromPage:String = "queryDtlResult";
    var parentApp :UIComponent = UIComponent(this.parentApplication);
    if(null == movArray){
        XenosAlert.info("No Result Found !");
        return;
    }else if(movArray.length == 0){
        XenosAlert.info("Please Select Record To Proceed");
        return;        
    }       

    var sPopup : SummaryPopup;	
	sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
	
	sPopup.addEventListener("OkSystemConfirm",handleOkSystemConfirm);
	sPopup.addEventListener("RefreshChanges",handleRefreshChanges);
	sPopup.title = this.parentApplication.xResourceManager.getKeyValue('rec.xenos.cash.label.adjustment') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.entry'); //"Adjustment Entry";
	sPopup.width = parentApp.width - 100;
	sPopup.height = parentApp.height - 100;
	PopUpManager.centerPopUp(sPopup);
	
	sPopup.moduleUrl = Globals.REC_ADJUSTMENET_ENTRY_SWF+Globals.QS_SIGN+"movArray"+Globals.EQUALS_SIGN+movArray+Globals.AND_SIGN+"fromPage"+Globals.EQUALS_SIGN+fromPage;
//	XenosAlert.info("Module URL :: "+sPopup.moduleUrl);
}
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
    reqObj.rnd = Math.random()+"";
    reqObj.listIndex = "1";
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
    reqObj.rnd = Math.random()+"";
    reqObj.listIndex = "1";
    cashRefDtlHttpService.request = reqObj;
    cashRefDtlHttpService.send();
}
/**
 * Entry for Force Match.
 */
private function doForceMatch(event:MouseEvent):void{
    var k:Number;
    var netAmt:Number = 0;
    var numberFormatter:XenosNumberFormatter = new XenosNumberFormatter();
		numberFormatter.useThousandsSeparator = true;
		numberFormatter.precision = 2;
    if(null == movArray){
        XenosAlert.info("No Result Found !");
        return;
    } else if(movArray.length == 0){
        XenosAlert.info("Please Select Record To Proceed");
        return;        
    } else if(movArray.length > 0){
	    for(k = 0; k<movArray.length; k++){
	    	var  itemDtl:Object = null;
	    	var l:Number;
	    	for(l=0; l<this.cashReferDtlResult.length; l++){
	    		itemDtl = this.cashReferDtlResult.getItemAt(l);
	    		if (XenosStringUtils.equals(movArray[k],itemDtl.recNum ) ){
	    			break;
	    		}
	    		itemDtl = null;
	    	}
	    	if(itemDtl != null){
	    		if(Number(itemDtl.custBal) != 0){
		    		var custBal:Number = Number(itemDtl.custBal);
		    		if(XenosStringUtils.equals(itemDtl.custDc,"C") || 
		    		   XenosStringUtils.equals(itemDtl.custDc,"RD")){
		    			netAmt = Number((netAmt - custBal).toFixed(3));
		    		} else {
		    			netAmt = Number((netAmt + custBal).toFixed(3));
		    		}
		    	}
		    	if(Number(itemDtl.ncmBal) != 0){
		    		var ncmBal:Number = Number(itemDtl.ncmBal);
		    		if(XenosStringUtils.equals(itemDtl.ncmDc,"C") || 
		    		   XenosStringUtils.equals(itemDtl.ncmDc,"RD")){
		    			netAmt = Number((netAmt +  ncmBal).toFixed(3));
		    		} else {
		    			netAmt = Number((netAmt -  ncmBal).toFixed(3));
		    		}
		    	}
	    	}
	    }
	    
	    if(netAmt != 0){
	    	var netAmtStr:String = "";
	    	if(netAmt < 0){
	    		netAmtStr = netAmt.toString().substring(1);
	    	} else {
	    		netAmtStr = netAmt.toString();
	    	}
		    netAmtStr = numberFormatter.format(netAmtStr);       
			XenosAlert.confirm("Total Amount of Movements selected for Force Match ["+netAmtStr+"]. " + 
					"Are you sure you want to proceed? Please confirm.",confirmForceMatchHandler);
		} else {
			forceMatchEntry();
		} 
	}
}

/**
* Confirm Handeler.
*/    
private function confirmForceMatchHandler(event:CloseEvent):void {
     if (event.detail == Alert.YES) {
		forceMatchEntry();
     } 
}
/**
 * Pops up force match entry screen.
 */
private function forceMatchEntry():void{
    var fromPage:String = "queryDtlResult";
	var parentApp :UIComponent = UIComponent(this.parentApplication);
	
	var sPopup : SummaryPopup;	
	sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));

	sPopup.addEventListener("OkSystemConfirm",handleOkSystemConfirm);
	sPopup.addEventListener("RefreshChanges",handleRefreshChanges);
	sPopup.title = this.parentApplication.xResourceManager.getKeyValue('rec.xenos.sec.bal.label.forcematch') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.entry'); //"ForceMatch Entry";
	sPopup.width = parentApp.width - 100;
	sPopup.height = parentApp.height - 100;
	PopUpManager.centerPopUp(sPopup);
	sPopup.moduleUrl = Globals.REC_FORCE_MATCH_ENTRY_SWF+Globals.QS_SIGN+"movArray"+Globals.EQUALS_SIGN+movArray+Globals.AND_SIGN+"fromPage"+Globals.EQUALS_SIGN+fromPage;
}

/**
 * Entry for Remarks.
 */
private function doRemarksEntry(event:MouseEvent):void{
    var fromPage:String = "queryDtlResult";
    var parentApp :UIComponent = UIComponent(this.parentApplication);
    if(null == movArray){
        XenosAlert.info("No Result Found !");
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
	
	sPopup.moduleUrl = Globals.REC_REMARKS_ENTRY_SWF+Globals.QS_SIGN+"movArray"+Globals.EQUALS_SIGN+movArray+Globals.AND_SIGN+"fromPage"+Globals.EQUALS_SIGN+fromPage;
	//XenosAlert.info("Module URL :: "+sPopup.moduleUrl);
}
/**
 * Entry for Remarks.
 */
private function calculateMovDiff(event:MouseEvent):void{
    var fromPage:String = "queryDtlResult";
    var parentApp :UIComponent = UIComponent(this.parentApplication);
    if(null == movArray){
        XenosAlert.info("No Result Found !");
        return;
    }else if(movArray.length == 0){
        XenosAlert.info("Please Select Record To Proceed");
        return;        
    }       

    var sPopup : SummaryPopup;	
	sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,false));
	
	sPopup.addEventListener("OkSystemConfirm",handleOkSystemConfirm);
	sPopup.addEventListener("RefreshChanges",handleRefreshChanges);
	sPopup.title = "Movement Difference"; 
	sPopup.width = 500;
	sPopup.height = 300;
	PopUpManager.centerPopUp(sPopup);
	
	sPopup.moduleUrl = "assets/appl/rec/CalculateMovementDiffrence.swf"+Globals.QS_SIGN+"movArray"+Globals.EQUALS_SIGN+movArray+Globals.AND_SIGN+"fromPage"+Globals.EQUALS_SIGN+fromPage;
	//XenosAlert.info("Module URL :: "+sPopup.moduleUrl);
}
/**
 *Intermedate Closing Balance On Off 
 *  
 * @param event
 * 
 */
private function intBalOnOff(event:MouseEvent):void{
    var fromPage:String = "queryDtlResult";
    var parentApp :UIComponent = UIComponent(this.parentApplication);
    //this.movArray = new Array ();/* Reseting Movment Array */
    this.showIntBal  = ! this.showIntBal;
    //XenosAlert.info("intBalOn/Off");
    if(this.showIntBal){
    	cashReferDtlResult =  this.tempAllResult;
    	this.btnIntBalOnOff.label = this.parentApplication.xResourceManager.getKeyValue('rec.form.button.label.intbaloff'); 
    }else{
		var tempResult:ArrayCollection = new ArrayCollection();
        for each ( var rec:XML in tempAllResult) {
			if( XenosStringUtils.equals(rec.showColor , "color")
	    			|| ! XenosStringUtils.equals(rec.custTrn , "CLOSE")){
	    		tempResult.addItem(rec);
	    	}
	    }
		cashReferDtlResult =  tempResult;
		this.btnIntBalOnOff.label = this.parentApplication.xResourceManager.getKeyValue('rec.form.button.label.intbalon');
	}	
}


/**
 * Entry for Forex Transfer.
 */
private function doForexTransfer(event:MouseEvent):void{
    var fromPage:String = "queryDtlResult";
    var parentApp :UIComponent = UIComponent(this.parentApplication);
    if(null == movArray){
        XenosAlert.info("No Result Found !");
        return;
    }else if(movArray.length == 0){
        XenosAlert.info("Please Select Record To Proceed");
        return;        
    }else if(movArray.length != 2){
        XenosAlert.info("Two Records Must Be Selected");
        return;        
    }

    var sPopup : SummaryPopup;	
	sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
	
	sPopup.addEventListener("OkSystemConfirm",handleOkSystemConfirm);
	sPopup.addEventListener("RefreshChanges",handleRefreshChanges);
	sPopup.title = "Forex Transfer"; 
	sPopup.width = parentApp.width - 100;
	sPopup.height = parentApp.height - 100;
	PopUpManager.centerPopUp(sPopup);
	
	sPopup.moduleUrl = "assets/appl/rec/ForexTransferPopUp.swf" + Globals.QS_SIGN+"movArray"+Globals.EQUALS_SIGN+movArray+Globals.AND_SIGN+"fromPage"+Globals.EQUALS_SIGN+fromPage;
	//XenosAlert.info("Module URL :: "+sPopup.moduleUrl);
}
 
/**
 * Entry for Unmatch Operation
 */
private function doUnmatch(event:MouseEvent):void{
    var fromPage:String = "queryDtlResult";
    var parentApp :UIComponent = UIComponent(this.parentApplication);
    if(null == movArray){
        XenosAlert.info("No Result Found !");
        return;
    }else if(movArray.length == 0){
        XenosAlert.info("Please Select Record To Proceed");
        return;        
    }         

    var sPopup : SummaryPopup;	
	sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
	
	sPopup.addEventListener("OkSystemConfirm",handleOkSystemConfirm);
	sPopup.addEventListener("RefreshChanges",handleRefreshChanges);
	sPopup.title = "Unmatch"; 
	sPopup.width = parentApp.width - 100;
	sPopup.height = parentApp.height - 100;
	PopUpManager.centerPopUp(sPopup);
	
	sPopup.moduleUrl = "assets/appl/rec/UnmatchOperation.swf" + Globals.QS_SIGN+"movArray"+Globals.EQUALS_SIGN+movArray+Globals.AND_SIGN+"fromPage"+Globals.EQUALS_SIGN+fromPage;
	//XenosAlert.info("Module URL :: "+sPopup.moduleUrl);
}
	/**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "rec/cashReferResultDispatch.action?method=generateXLS&fromPage=queryResult&showIntBalFlag="+ (showIntBal?"Y":"N");
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
        var url : String = "rec/cashReferResultDispatch.action?method=generatePDF&fromPage=queryResult&showIntBalFlag="+ (showIntBal?"Y":"N");
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
 