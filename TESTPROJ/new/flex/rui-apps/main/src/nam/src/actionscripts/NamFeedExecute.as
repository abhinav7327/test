
// ActionScript file for Nam Feed Execute
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.startup.XenosApplication;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.nam.validators.NamFeedExecuteValidator;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.events.ValidationResultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	[Bindable]
	public var app:XenosApplication=XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
	private var initCompFlg:Boolean=false;
	[Bindable]
	public var selectedRdArray:Array=new Array();

	
	
	/**
	 * This method will be called at the time of the loading the Entry initial screen.
	 *
	 */
	private function initPageStart():void
	{
		if (!initCompFlg)
		{
			//rndNo= Math.random();
			var req:Object=new Object();
			req.SCREEN_KEY=12002;
			initializeExecute.request=req;
			initializeExecute.url="nam/namFeedExecuteDispatch.action?method=doInit";
			initializeExecute.send();
		}
		else
			XenosAlert.info("Already Initiated!");
	}

	/**
	 * This method works as the result handler of the initializeExecute Http Services.
	 *
	 */
	private function initPage(event:ResultEvent):void
	{
		app.submitButtonInstance = submit;
		var i:int=0;
		var selIndx:int=0;
		var initColl:ArrayCollection=new ArrayCollection();
		var tempColl:ArrayCollection;
		fundPopUp.fundCode.text="";
		errPage.clearError(event); //clears the errors if any 
		errPageCfm.clearError(event); //clears the errors if any 
		submit.enabled = true;
		back.enabled = true;
		officeId.setFocus();
		// Setting values of the officeId
		initColl.removeAll();
		if (event.result.namFeedExecuteActionForm.officeIdValues.officeId != null)
		{
			if (event.result.namFeedExecuteActionForm.officeIdValues.officeId is ArrayCollection)
				initColl=event.result.namFeedExecuteActionForm.officeIdValues.officeId as ArrayCollection;
			else
				initColl.addItem(event.result.namFeedExecuteActionForm.officeIdValues.officeId);
		}
		tempColl=new ArrayCollection();
		tempColl.addItem("");
		for (i=0; i < initColl.length; i++)
		{
			tempColl.addItem(initColl[i]);
		}
		officeId.dataProvider=tempColl;
		// Setting values of the interface names
		initColl.removeAll();
		if (event.result.namFeedExecuteActionForm.scrDisData.interfaceNameValues != null)
		{
			if (event.result.namFeedExecuteActionForm.scrDisData.interfaceNameValues.item is ArrayCollection)
			{
				initColl=event.result.namFeedExecuteActionForm.scrDisData.interfaceNameValues.item as ArrayCollection;
			}
			else
			{
				initColl.addItem(event.result.namFeedExecuteActionForm.scrDisData.interfaceNameValues.item);
			}
		}
		tempColl=new ArrayCollection();
		tempColl.addItem({label: "", value: ""});
		for (i=0; i < initColl.length; i++)
		{
			tempColl.addItem(initColl[i]);
		}
		interfacetype.dataProvider=tempColl;

		// Setting values of the Issue Currency Values
		initColl.removeAll();
		if (event.result.namFeedExecuteActionForm.scrDisData.issueCcyValues != null)
		{
			if (event.result.namFeedExecuteActionForm.scrDisData.issueCcyValues.item is ArrayCollection)
			{
				initColl=event.result.namFeedExecuteActionForm.scrDisData.issueCcyValues.item as ArrayCollection;
			}
			else
			{
				initColl.addItem(event.result.namFeedExecuteActionForm.scrDisData.issueCcyValues.item);
			}
		}
		tempColl=new ArrayCollection();
		tempColl.addItem({label: "", value: ""});
		for (i=0; i < initColl.length; i++)
		{
			tempColl.addItem(initColl[i]);
		}
		issueCurrency.dataProvider=tempColl;
		
		if (event == null || event.result == null || event.result.namFeedExecuteActionForm == null)
		{
			XenosAlert.error("Failed to Initialize the Form");
			return;
		}     
		showIssueCurrency();
	  }

	/**
	 * This method is to reset the Execute screen.
	 *
	 */
	private function resetExecute():void
	{
        NamExecuteResetRequest.url="nam/namFeedExecuteDispatch.action?method=doInit";
		NamExecuteResetRequest.send();
	}
	
	/**
	 * It sends/submits the Execute screen.
	 *
	 */
	private function submitQuery():void
	{
		var myModel:Object={feedexecuteentry: {officeId: this.officeId.selectedItem,
		                                       intfType: this.interfacetype.selectedItem.label,
		                                       intfTypeVal: this.interfacetype.selectedItem.value,
		                                       issueCcy: this.issueCurrency.selectedItem.label
		                                       }
		                    };
		var namFeedExecuteValidator:NamFeedExecuteValidator=new NamFeedExecuteValidator();
		namFeedExecuteValidator.source=myModel;
		namFeedExecuteValidator.property="feedexecuteentry";
		var validationResult:ValidationResultEvent=namFeedExecuteValidator.validate();
		if (validationResult.type == ValidationResultEvent.INVALID)
		{
			var errorMsg:String=validationResult.message;
			XenosAlert.error(errorMsg);
		}
		else
		{
			var reqObj:Object=new Object();
			var fndstr:String=this.fundPopUp.fundCode.text;
			reqObj.fundCode=this.fundPopUp.fundCode.text;
			fundCodeValidateRequest.request=reqObj;
			fundCodeValidateRequest.send();
		}
	}

    /**
	 * The method called when press the back button from the confirm screen.
	 *
	 */
	private function doBack():void
	{
		namFeedEntry.selectedChild=entry;
	    submitCfm.enabled = true;
	    errPageCfm.showError(null);
	    officeId.setFocus();
	    app.submitButtonInstance = submit;
	}
	
	/**
	 * This method works as the result handler of fundCodeValidateRequest Http Services.
	 * This also takes care of the buttons/images to be shown on teh top panel of the
	 * result.
	 */
	private function fundCodeValidateResult(event:ResultEvent):void
	{
		var rs:XML=new XML();
		rs=XML(event.result);
		if (null != event)
		{
			if (rs.child("Errors").length() > 0)
			{	
				// i.e. Must be error, display it .
				var errorInfoList:ArrayCollection=new ArrayCollection();
				//populate the error info list              
				for each (var error:XML in rs.Errors.error)
				{
					errorInfoList.addItem(error.toString());
				}
				errPage.showError(errorInfoList);
				namFeedEntry.selectedChild=entry;
			}
			else
			{	
				submitCfm.includeInLayout = true;
				submitCfm.visible = true;	
				fundCodeCfm.text=this.fundPopUp.fundCode.text != "" ? this.fundPopUp.fundCode.text : "ALLINONE";
				officeIdCfm.text=this.officeId.selectedItem != null ? StringUtil.trim(this.officeId.selectedItem.value) : "";
				intfTypeCfm.text=this.interfacetype.selectedItem != null ? StringUtil.trim(this.interfacetype.selectedItem.label) : "";
				issueCcyCfm.text=this.issueCurrency.selectedItem != null ? StringUtil.trim(this.issueCurrency.selectedItem.label) : "";
				submitCfm.setFocus();
				namFeedEntry.selectedChild=confirm;
				app.submitButtonInstance = submitCfm;
			}
		}
	}

	/**
	 * It sends/submits the Execute Confirm.
	 *
	 */
	private function submitConfirm():void
	{
		var requestObj:Object=populateRequestParams();
		feedExecuteRequest.request=requestObj;
		feedExecuteRequest.send();
		submit.enabled = false;
		back.enabled = false;
	}

	/**
	 * This method works as the result handler of feedExecuteRequest Http Services.
	 */
	private function feedExecuteResult(event:ResultEvent):void
	{
		var rs:XML=new XML();
		rs=XML(event.result);
		if (null != event)
		{   
			var childList:XMLList = rs.child("Errors");
			if (childList.children().length() > 0)
			{	
				// i.e. Must be error, display it .
				var errorInfoList:ArrayCollection=new ArrayCollection();
				//populate the error info list              
				for each (var error:XML in rs.Errors.error)
				{
					errorInfoList.addItem(error.toString());
				}
				errPageCfm.showError(errorInfoList);
				namFeedEntry.selectedChild=confirm;
			} 
			else
			{
				var recordXML:XML = XML(rs.recordCount);
				var recordStr:String = recordXML.toString();
				transStatus.text="Transaction Completed";
				transStatus.styleName="FormLabelHeading";
				recordCount.text="No of Record Generated:" + recordStr;
				ok.setFocus();
				namFeedEntry.selectedChild=result;
				app.submitButtonInstance = ok;
			}
		}
	}

	/**
	 * It called press the Ok screen.
	 *
	 */
	private function doOK(event:Event):void
	{
		namFeedEntry.selectedChild=entry;
//		resetExecute();
        NamExecuteResetRequest.url="nam/namFeedExecuteDispatch.action?method=doInit";
		NamExecuteResetRequest.send();
	}

	/**
	 * This method will populate the request parameters for the
	 * submitQuery call and bind the parameters with the HTTPService
	 * object.
	 */
	private function populateRequestParams():Object
	{	
		var reqObj:Object=new Object();
		var fndCode:String= String(fundPopUp.fundCode.text)
		if(fndCode != null && fndCode.length > 0)
		{
			reqObj.fundCode	= fndCode;	
		}
		else
		{
			reqObj.fundCode	= "ALLINONE";	
		}		
		reqObj.officeId=(this.officeId.selectedItem != null ? this.officeId.selectedItem : "");
		reqObj.interfaceId=(this.interfacetype.selectedItem != null ? this.interfacetype.selectedItem.value : "");
		reqObj.issueCcy=(this.issueCurrency.selectedItem != null ? this.issueCurrency.selectedItem.value : "");
		return reqObj;
	}

	/**
	 * This Method check the selected office Id and Interface Type
	 * If Office Id = TK and Interface Type = Equity Trade then enable Issue Currency Field.
	 * Otherwise it disable the Issue Currency Field
	 */
	private function showIssueCurrency():void{
		
   		if(this.interfacetype.selectedItem != null && this.officeId.selectedItem != null){
   			if(XenosStringUtils.equals(this.interfacetype.selectedItem.value,"INTFTXNPX001") &&
   			XenosStringUtils.equals(this.officeId.selectedItem.value,"TK")){
   				this.issueCcyEntryRow.visible = true;
   				this.issueCcyEntryRow.includeInLayout = true;
   				this.issueCcyUseConfRow.visible = true;
   				this.issueCcyUseConfRow.includeInLayout = true;
   			}else{
   				this.issueCcyEntryRow.visible = false;
   				this.issueCcyEntryRow.includeInLayout = false;
   				this.issueCurrency.selectedIndex = 0;
   				this.issueCcyUseConfRow.visible = false;
   				this.issueCcyUseConfRow.includeInLayout = false;
   			}
   		}
   		else
   		{
   			this.issueCcyEntryRow.visible = false;
   			this.issueCcyEntryRow.includeInLayout = false;
   			this.issueCurrency.selectedIndex = 0;
   			this.issueCcyUseConfRow.visible = false;
   			this.issueCcyUseConfRow.includeInLayout = false;
   		}
    }