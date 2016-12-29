// ActionScript file
import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.events.CloseEvent;
import mx.rpc.events.ResultEvent;

[Bindable]
private var confResult:ArrayCollection=new ArrayCollection();

/**
 * Loading the initial configuaration.
 */
private function loadAll():void
{
	var genPlanPkArray:Array = new Array();
	for(var index:int=0; index<this.parentDocument.owner.selectedScheduleRecords.length; index++ )
	{
        var reportGenPlanPk:Number  = this.parentDocument.owner.selectedScheduleRecords[index].reportGenPlanPk;
        for(var i:int=0; i<this.parentDocument.owner.summaryResult.length; i++)
        {
        	if(reportGenPlanPk == this.parentDocument.owner.summaryResult[i].reportGenPlanPk)
        	{
        		var result:Object=new Object();
        		result["reportGenPlanPk"] = this.parentDocument.owner.summaryResult[i].reportGenPlanPk;
        		result["referenceNo"] = this.parentDocument.owner.summaryResult[i].referenceNo;
        		result["fundCode"] = this.parentDocument.owner.summaryResult[i].fundCode;
        		result["fundCodePx"] = this.parentDocument.owner.summaryResult[i].fundCodePx;
        		result["tempOrFinal"] = this.parentDocument.owner.summaryResult[i].tempOrFinal;
        		result["scheduleType"] = this.parentDocument.owner.summaryResult[i].scheduleType;
        		result["generationDay"] = this.parentDocument.owner.summaryResult[i].scheduleDayStr;
        		result["reportAsOfDate"] = this.parentDocument.owner.summaryResult[i].asOfDateStr;
        		result["reportPattern"] = this.parentDocument.owner.summaryResult[i].reportPattern;
        		result["userId"] = this.parentDocument.owner.summaryResult[i].userId;
				this.confResult.addItem(result);
        	}
        	confResult.refresh();
        }
    }

	var dataSortField:SortField=new SortField();
	dataSortField.name="reportGenPlanPk";
	dataSortField.numeric=true;

	var stringDataSort:Sort=new Sort();
	stringDataSort.fields=[dataSortField];
	confResult.sort=stringDataSort;
	confResult.refresh();
}

/**
 * Confirmation Screen
 */
private function doConfirm():void
{
	var rndNo:Number = Math.random();   
	var requestObj:Object=populateRequestParams();
	deleteScheduleService.request=requestObj;
    deleteScheduleService.url = "nam/scheduleEntryDispatchAction.action?rnd="+rndNo; 
    deleteScheduleService.send();
}

/**
 * This method will populate the request parameters for the
 * submitQuery call and bind the parameters with the HTTPService
 * object.
 */
private function populateRequestParams():Object 
{
    
    this.parentDocument.owner.summaryPopup.showCloseButton = false;
    var reqObj : Object = new Object();
    reqObj.method = "doConfirmDelete";
    var genPlanPkArray:Array = new Array();
    for(var index:int=0; index<this.parentDocument.owner.selectedScheduleRecords.length; index++ )
    {
        genPlanPkArray[index] = this.parentDocument.owner.selectedScheduleRecords[index].reportGenPlanPk;
    }
    if(genPlanPkArray.length <= 0)
    {
        genPlanPkArray[0] = '';
    }
    reqObj.genPlanPkArray = genPlanPkArray;
    return reqObj;
}

private function deleteSchedule(event:ResultEvent):void
{
	uConfLabel.visible = false;
	uConfLabel.includeInLayout = false;
	
	uConfSubmit.visible = false;
	uConfSubmit.includeInLayout = false;
	
	sConfLabel.visible = true;
	sConfLabel.includeInLayout = true;
	
	sConfSubmit.visible = true;
	sConfSubmit.includeInLayout = true;
}

private function ok():void
{
	this.parentDocument.owner.submitQuery();
	this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
}
