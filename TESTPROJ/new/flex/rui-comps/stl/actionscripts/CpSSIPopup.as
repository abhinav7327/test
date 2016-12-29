// ActionScript file for account popup

import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.HiddenObject;

import mx.collections.ArrayCollection;
import mx.controls.TextInput;
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
 * This will return the return context for the record selected from the popup 
 * window to the main application.
 */  
public function returnSelectedCpSSI(data:Object):void { 
     if (cpSSISummary.selectedItem != null){         
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
    if(data.detailSide=='SECURITY'){                
        returnContextItems.addItem(new HiddenObject("cpListHitCopy",[data.cpListHitCopy]));
        returnContextItems.addItem(new HiddenObject("secCpChainIndex",[data.secCpChainIndex]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(cpBank)",[data.settlementBank]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(cpSettleAc)",[data.settlementAc]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.cpExtSettleAccountName1",[data.settlementAcName1]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.cpExtSettleAccountName2",[data.settlementAcName2]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.cpExtSettleAccountName3",[data.settlementAcName3]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.cpExtSettleAccountName4",[data.settlementAcName4]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(cpIntermediaryInfo)",[data.intermediaryInfo]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(contraId)",[data.contraId]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(deliveryInstruction)",[data.fullDeliveryInx]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.dtcInstitutionId",[data.institutionIdName]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.dtcAgentId",[data.agentIdName]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.dtcAgentAccountNo",[data.agentAccountNo]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.dtcParticipantId",[data.participantNoName]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(beneficiaryName)",[data.beneficiaryName]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.furtherCredit",[data.furtherCredit]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.settlementMode",[data.settlementMode]));
        returnContextItems.addItem(new HiddenObject("secSSILayout",[data.ssiLayout]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(placeOfSettlement)",[data.placeOfSettlement]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.participantId",[data.participantId]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.brokerBic",[data.brokerBic]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.cpBankCodeType",[data.bankCodeType]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.participantId2",[data.participantId2]));
                                        
    }else if(data.detailSide=='CASH'){                
        returnContextItems.addItem(new HiddenObject("cpListHitCopy",[data.cpListHitCopy]));
        returnContextItems.addItem(new HiddenObject("cashCpChainIndex",[data.secCpChainIndex]));
        returnContextItems.addItem(new HiddenObject("mapCashSdVO(cpBank)",[data.settlementBank]));
        returnContextItems.addItem(new HiddenObject("mapCashSdVO(cpSettleAc)",[data.settlementAc]));
        returnContextItems.addItem(new HiddenObject("cashStlDetail.cpExtSettleAccountName1",[data.settlementAcName1]));
        returnContextItems.addItem(new HiddenObject("cashStlDetail.cpExtSettleAccountName2",[data.settlementAcName2]));
        returnContextItems.addItem(new HiddenObject("cashStlDetail.cpExtSettleAccountName3",[data.settlementAcName3]));
        returnContextItems.addItem(new HiddenObject("cashStlDetail.cpExtSettleAccountName4",[data.settlementAcName4]));
        returnContextItems.addItem(new HiddenObject("mapCashSdVO(cpIntermediaryInfo)",[data.intermediaryInfo]));
        returnContextItems.addItem(new HiddenObject("mapCashSdVO(contraId)",[data.contraId]));
        returnContextItems.addItem(new HiddenObject("mapCashSdVO(deliveryInstruction)",[data.fullDeliveryInx]));
        returnContextItems.addItem(new HiddenObject("cashStlDetail.dtcInstitutionId",[data.institutionIdName]));
        returnContextItems.addItem(new HiddenObject("cashStlDetail.dtcAgentId",[data.agentIdName]));
        returnContextItems.addItem(new HiddenObject("cashStlDetail.dtcAgentAccountNo",[data.agentAccountNo]));
        returnContextItems.addItem(new HiddenObject("cashStlDetail.dtcParticipantId",[data.participantNoName]));
        returnContextItems.addItem(new HiddenObject("mapCashSdVO(beneficiaryName)",[data.beneficiaryName]));
        returnContextItems.addItem(new HiddenObject("cashStlDetail.furtherCredit",[data.furtherCredit]));
        returnContextItems.addItem(new HiddenObject("cashStlDetail.settlementMode",[data.settlementMode]));
        returnContextItems.addItem(new HiddenObject("cashSSILayout",[data.ssiLayout]));
        returnContextItems.addItem(new HiddenObject("mapCashSdVO(placeOfSettlement)",[data.placeOfSettlement]));
        returnContextItems.addItem(new HiddenObject("cashStlDetail.participantId",[data.participantId]));
        returnContextItems.addItem(new HiddenObject("cashStlDetail.brokerBic",[data.brokerBic]));
        returnContextItems.addItem(new HiddenObject("cashStlDetail.cpBankCodeType",[data.bankCodeType]));
        returnContextItems.addItem(new HiddenObject("cashStlDetail.participantId2",[data.participantId2]));
    }else{
        returnContextItems.addItem(new HiddenObject("cpListHitCopy",[data.cpListHitCopy]));
        returnContextItems.addItem(new HiddenObject("secCpChainIndex",[data.secCpChainIndex]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(cpBank)",[data.settlementBank]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(cpSettleAc)",[data.settlementAc]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.cpExtSettleAccountName1",[data.settlementAcName1]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.cpExtSettleAccountName2",[data.settlementAcName2]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.cpExtSettleAccountName3",[data.settlementAcName3]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.cpExtSettleAccountName4",[data.settlementAcName4]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(cpIntermediaryInfo)",[data.intermediaryInfo]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(contraId)",[data.contraId]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(deliveryInstruction)",[data.fullDeliveryInx]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.dtcInstitutionId",[data.institutionIdName]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.dtcAgentId",[data.agentIdName]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.dtcAgentAccountNo",[data.agentAccountNo]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.dtcParticipantId",[data.participantNoName]));
        returnContextItems.addItem(new HiddenObject("mapSecSdVO(beneficiaryName)",[data.beneficiaryName]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.furtherCredit",[data.furtherCredit]));
        returnContextItems.addItem(new HiddenObject("securityStlDetail.settlementMode",[data.settlementMode]));
    }
}        
