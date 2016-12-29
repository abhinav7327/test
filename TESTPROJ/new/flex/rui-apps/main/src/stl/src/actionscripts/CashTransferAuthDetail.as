


// ActionScript file

//Action Script file for Cash Entry Authorization Detail screen

import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.events.CloseEvent;
import mx.rpc.events.ResultEvent;

private var cashEntryPk:String = XenosStringUtils.EMPTY_STR;
[Bindable]private var xmlSource:XML = new XML();

private function loadData():void{
	parseUrlString();
	var obj:Object = new Object();
	obj.method= "viewEntryDetails";
 	obj.cashEntryPk = cashEntryPk;
 	obj.rnd = Math.random();
 	initCashAuthDetailReq.request = obj;
	initCashAuthDetailReq.send();
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
            if(tempA[0] == "cashEntryPk"){
            	cashEntryPk = tempA[1];
            }
        }
    } catch (e:Error) {
        trace(e);
    }
}

public function loadDetail(event:ResultEvent):void {
	if(event != null){
		if(event.result != null){
			var rs:XML = XML(event.result);
			if(rs.child("cashEntryView").length() > 0) {				
				xmlSource = XML(rs.cashEntryView);								
				if(XenosStringUtils.equals(xmlSource.wireType,'BANK_TO_BANK')){
					wireViewStackUConf.selectedChild = bankVst;
					
        			if(uConfEntryGrid.contains(uConfEntryGleLedgerCodeTradeDateGrid)) {
						uConfEntryGrid.removeChild(uConfEntryGleLedgerCodeTradeDateGrid);						
        			}					
        			if(uConfEntryGrid.contains(uConfEntryCpAccountNoGrid)) {
						uConfEntryGrid.removeChild(uConfEntryCpAccountNoGrid);						
        			}
        			if(uConfEntryGrid.contains(uConfEntryFundAccountNoGrid)) {
						uConfEntryGrid.removeChild(uConfEntryFundAccountNoGrid);						
        			}
				} else{
					uConfEntryGrid.addChildAt(uConfEntryCpAccountNoGrid,4);
					uConfEntryGrid.addChildAt(uConfEntryFundAccountNoGrid,5);
					uConfEntryGrid.addChildAt(uConfEntryGleLedgerCodeTradeDateGrid,7);
					wireViewStackUConf.selectedChild = firmVst
				}
			}
		}else{
			errPage.removeError();
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	this.closeHandeler();
		}
	}else{
		errPage.removeError();
		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	 	this.closeHandeler();
	}
}

public function closeHandeler():void{
    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
}