// ActionScript file for account popup

import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.HiddenObject;

import mx.collections.ArrayCollection;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

[Bindable]private var currentPage:Number = 0;
[Bindable]private var pageSize:uint = 12;
[Bindable]private var navPage:uint = 1;
[Bindable]private var navSize:uint = 10;  	

/**
 * This API will clear the result page to empty page
 */
public function clearResultPage():void{
    summaryResult.removeAll();
}
/**
* It sets the enable property of the Next and Previous button
* depending on the result set, whether available or not
*/
public function setPrevNextVisibility(prev:Boolean, next:Boolean):void{	    	
}      
   /**
 * The view state handler.
 * This is used to changed the view state between Query and Query Result container. 
 */  
private function changeCurrentState():void{
    //this.currentState = "qryres";
}        

/**
 * The Fault Event Handler used for error in query result http service
 * @param event The fault Event
 * 
 */        
public function popUpQueryRequestErrorHand(event:FaultEvent):void {

    var errorMsg : String = this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred') + event.fault.faultString;

    XenosAlert.error(errorMsg);
}
/**
  * This will return the return contexts for the selected record from the popup 
  * window to the main application.
  */  
public function returnSelectedOwnSSI(data:Object):void { 
     if (ownSSISummary.selectedItem != null){
         populateReturnContext(data);
         super.closeWindow();
     }
}
        
/**
  * This will initialize the pop up query page.
  * @param ResultEvent the result set event object.
  */
public override function populatePopUpQueryPage(event: ResultEvent) : void {
	if(null != event ){
	  var rs:XML = XML(event.result);
	  if(rs.child("Errors") != null && rs.child("Errors").length()>0){
	  	// i.e. Must be error, display it .
        var errorInfoList : ArrayCollection = new ArrayCollection();
        //populate the error info list 			 	
         for each ( var error:XML in rs.Errors.error ) {
			errorInfoList.addItem(error.toString());
        }
         errPage.showError(errorInfoList);//Display the error	 	         
	  }else{
	  	try {
	  		errPage.clearError(event);
	        summaryResult.removeAll();			  		
  			if(rs.summary.noOfRecords > 0){
  				var initcol:ArrayCollection = new ArrayCollection();
			    for each ( var rec:XML in rs.summary.data ) {						    	
 				    initcol.addItem(rec);
			    }					    
			    summaryResult = initcol;
	           	summaryResult.refresh();
	           	if(summaryResult.length == 0)
       	             XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));	
  			}
	  			  		
	  	}catch(e:Error){
	  		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	  	}
	  }	
	}			
}

/**
 * Reset the account query page. 
 */
public override function resetQuery():void { 
   super.initPopup();
}
	    
/**
 * Submit the account query page.
 */
public override function submitQuery():void { 

}

/**
 * This API return the data through the context from popup to the main  
 * application.
 * @TODO To be implemented if requried.
 * 
 */        
private function populateReturnContext(data:Object):void {
    if(data.cashSecFlag == "SECURITY"){
        returnContextItems.addItem(new HiddenObject("secOurChainIndex",[data.index]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(ourBank)",[data.settlementBank]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(ourSettleAc)",[data.settlementAc]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(ourIntermediaryInfo)",[data.intermediaryInfo]));                                                 
    }else if (data.cashSecFlag == "CASH"){
        returnContextItems.addItem(new HiddenObject("cashOurChainIndex",[data.index]));
        returnContextItems.addItem(new HiddenObject("mapCashSdVO(ourBank)",[data.settlementBank]));
        returnContextItems.addItem(new HiddenObject("mapCashSdVO(ourSettleAc)",[data.settlementAc]));
        returnContextItems.addItem(new HiddenObject("mapCashSdVO(ourIntermediaryInfo)",[data.intermediaryInfo]));                                                 
    }
}        
