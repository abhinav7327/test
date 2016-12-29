
// ActionScript file for Sba Feed Execute
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.startup.XenosApplication;
	import com.nri.rui.nam.validators.SbaFeedExecutionValidator;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	import mx.events.ValidationResultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	[Bindable]
	public var app:XenosApplication=XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
	private var initCompFlg:Boolean=false;
	
	/**
	 * This method will be called at the time of the loading the Entry initial screen.
	 *
	 */
	private function initPageStart():void
	{
		if (!initCompFlg)
		{
			var req:Object=new Object();
			req.SCREEN_KEY=12078;
			initializeExecute.request=req;
			initializeExecute.url="nam/sbaFeedExecuteDispatch.action?method=doInit";
			initializeExecute.send();
		}
		else
		{
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
		}
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

		//variables to hold the default values from the server
		var originalDataSourceDefault:String=event.result.sbaFeedExecuteActionForm.originalDataSource;
		loriginalDataSource.visible=false;
		loriginalDataSource.includeInLayout=false;
		originalDataSource.visible=false;
		originalDataSource.includeInLayout=false;

		if (event == null || event.result == null || event.result.sbaFeedExecuteActionForm == null)
		{
			 XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('nam.common.prompt.init.failed'));
            return;
		}

		// Setting values of the officeId
		initColl.removeAll();
				
		if(event.result.sbaFeedExecuteActionForm.officeIdValues.officeId != null)
        {
            if(event.result.sbaFeedExecuteActionForm.officeIdValues.officeId is ArrayCollection)
                initColl = event.result.sbaFeedExecuteActionForm.officeIdValues.officeId as ArrayCollection;
            else
                initColl.addItem(event.result.sbaFeedExecuteActionForm.officeIdValues.officeId);
        }
        
        tempColl = new ArrayCollection();
        for(i = 0; i<initColl.length; i++) 
        {
            tempColl.addItem(initColl[i]);
        }
        officeId.dataProvider = tempColl;
        
         // Setting values of the fund category
		initColl.removeAll();
		if (event.result.sbaFeedExecuteActionForm.fundCategoryList.item != null)
		{
			if (event.result.sbaFeedExecuteActionForm.fundCategoryList.item is ArrayCollection)
			{
				initColl=event.result.sbaFeedExecuteActionForm.fundCategoryList.item as ArrayCollection;
			}
			else
			{
				initColl.addItem(event.result.sbaFeedExecuteActionForm.fundCategoryList.item);
			}
		}
	
		tempColl=new ArrayCollection();
		tempColl.addItem({label: " ", value: " "});
		for (i=0; i < initColl.length; i++)
		{
			tempColl.addItem(initColl[i]);
		}
		this.fundCategory.dataProvider=tempColl;

         // Setting values of the Original Data Source
		initColl.removeAll();
		if (event.result.sbaFeedExecuteActionForm.originalDataSourceList.item != null)
		{
			if (event.result.sbaFeedExecuteActionForm.originalDataSourceList.item is ArrayCollection)
			{
				initColl=event.result.sbaFeedExecuteActionForm.originalDataSourceList.item as ArrayCollection;
			}
			else
			{
				initColl.addItem(event.result.sbaFeedExecuteActionForm.originalDataSourceList.item);
			}
		}

	    selIndx=0;
		tempColl=new ArrayCollection();
		for (i=0; i < initColl.length; i++)
		{
			if (XenosStringUtils.equals((initColl[i].value), originalDataSourceDefault))
			{
				selIndx=i;
			}
			tempColl.addItem(initColl[i]);
		}

		this.originalDataSource.dataProvider=tempColl;
		this.originalDataSource.selectedIndex = selIndx;
	}

	/**
	 * Based on Advisory/Mutual , Original DataSource display.
	 */
	private function advisoryOrMutualOnchange():void
	{
	    if (XenosStringUtils.equals('Advisory', this.fundCategory.selectedItem.value))
		{
			originalDataSource.selectedIndex = 0;
			loriginalDataSource.visible=true;
			loriginalDataSource.includeInLayout=true;
			originalDataSource.visible=true;
			originalDataSource.includeInLayout=true;
		}
		else
		{
			loriginalDataSource.visible=false;
			loriginalDataSource.includeInLayout=false;
			originalDataSource.visible=false;
			originalDataSource.includeInLayout=false;
		}
	}

	/**
	 * This method is to reset the SBA Feed Execute screen.
	 *
	 */
	private function resetExecute():void
	{
        SBAExecuteResetRequest.url="nam/sbaFeedExecuteDispatch.action?method=doInit";
		SBAExecuteResetRequest.send();
	}
	
	/**
	 * It submits the SBA Execute screen.
	 *
	 */
	private function submitQuery():void
	{
		var validateModel:Object={sbaFeed: 
		{
			officeId:this.officeId.text,
			fundCategory:this.fundCategory.text,
			originalDataSource:this.originalDataSource.text
		}};

		var sbaFeedExecutionValidator:SbaFeedExecutionValidator=new SbaFeedExecutionValidator();
		sbaFeedExecutionValidator.source=validateModel;
		sbaFeedExecutionValidator.property="sbaFeed";
	
		var validationResult:ValidationResultEvent=sbaFeedExecutionValidator.validate();
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
	 */
	private function doBack():void
	{
		sbaFeedEntry.selectedChild=entry;
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
				var errorInfoList:ArrayCollection = new ArrayCollection();
				for each (var error:XML in rs.Errors.error)
				{
					errorInfoList.addItem(error.toString());
				}
				errPage.showError(errorInfoList);
				sbaFeedEntry.selectedChild = entry;
			}
			else
			{	
				submitCfm.includeInLayout = true;
				submitCfm.visible = true;	
				back.enabled = true;
				fundCodeCfm.text = this.fundPopUp.fundCode.text != "" ? this.fundPopUp.fundCode.text : "";
				officeIdCfm.text = this.officeId.selectedItem != null ? StringUtil.trim(this.officeId.selectedItem.value) : "";
				fundCategoryCfm.text = this.fundCategory.selectedItem != null ? StringUtil.trim(this.fundCategory.selectedItem.value) : "";
			    if (XenosStringUtils.equals('Advisory', this.fundCategory.selectedItem.value))
				{
					secondRowCfm.visible=true;
					secondRowCfm.includeInLayout=true;
					loriginalDataSourceCfm.visible=true;
					loriginalDataSourceCfm.includeInLayout=true;
					originalDataSourceCfm.visible=true;
					originalDataSourceCfm.includeInLayout=true;
				}
				else
				{
					secondRowCfm.visible=false;
					secondRowCfm.includeInLayout=false;
					loriginalDataSourceCfm.visible=false;
					loriginalDataSourceCfm.includeInLayout=false;
					originalDataSourceCfm.visible=false;
					originalDataSourceCfm.includeInLayout=false;					
				}
				originalDataSourceCfm.text = this.originalDataSource.selectedItem != null ? StringUtil.trim(this.originalDataSource.selectedItem.value) : "";
				submitCfm.setFocus();
				sbaFeedEntry.selectedChild = uConfirm;
				app.submitButtonInstance = submitCfm;
			}
		}
	}

	/**
	 * It submits the Execute Confirm.
	 */
	private function submitConfirm():void
	{
		if(submitCfm.enabled == true)
		{
			var requestObj:Object=populateRequestParams();
			feedExecuteRequest.request=requestObj;
			feedExecuteRequest.send();
		}
		submitCfm.enabled = false;
		back.enabled = false;
	}

	/**
	 * This method works as the result handler of Sba feedExecuteRequest Http Services.
	 */
	 private function feedExecuteResult(event:ResultEvent):void
	 {
		var rs:XML=new XML();
		rs=XML(event.result);
		var dummySecDetailStr:String = "";
		submitCfm.enabled = true;
		back.enabled = true;
		if (null != event)
		{
			var childList:XMLList = rs.child("Errors");
			if (childList.children().length() > 0)
			{	
				var errorInfoList:ArrayCollection=new ArrayCollection();
				for each (var error:XML in rs.Errors.error)
				{
					errorInfoList.addItem(error.toString());
				}
				errPageCfm.showError(errorInfoList);
				sbaFeedEntry.selectedChild=uConfirm;
			} 
			else
			{
				var recordXML:XML = XML(rs.recordCount);
				var dummySecCountXML:XML = XML(rs.dummySecCount);
				var dummySecDetailXML:XML = XML(rs.dummySecurityDetails);
				
				var dummySecXMLList:XMLList = dummySecDetailXML.child("dummySecurity");
   				var dummySecXMLCollList : XMLListCollection = new XMLListCollection(dummySecXMLList);
   				for each (var dummy : Object in dummySecXMLCollList)
   				{
   					dummySecDetailStr = dummySecDetailStr.concat(dummy + "\n");
   				}
				transStatus.text= this.parentApplication.xResourceManager.getKeyValue('sba.label.transcomplete');
				transStatus.styleName="FormLabelHeading";
				recordCount.text=this.parentApplication.xResourceManager.getKeyValue('sba.label.transcount') + recordXML.toString();
				recCountDummySecurity.text =  this.parentApplication.xResourceManager.getKeyValue('sba.label.dummyseccount') + dummySecCountXML.toString();
				dummyDetail.text = dummySecDetailStr;
				ok.setFocus();
				sbaFeedEntry.selectedChild = sConfirm;
				app.submitButtonInstance = ok;
			}
		}
	}

	/**
	 * It called press the Ok screen.
	 */
	private function doOK(event:Event):void
	{
		sbaFeedEntry.selectedChild=entry;
        SBAExecuteResetRequest.url="nam/sbaFeedExecuteDispatch.action?method=doInit";
		SBAExecuteResetRequest.send();
	}

	/**
	 * This method will populate the request parameters for the
	 * submitQuery call and bind the parameters with the HTTPService
	 * object.
	 */
	private function populateRequestParams():Object
	{	
		var reqObj:Object=new Object();
		reqObj.fundCode	= this.fundPopUp.fundCode.text
		reqObj.officeId=(this.officeId.selectedItem != null ? this.officeId.selectedItem : "");
		reqObj.fundCategory=(this.fundCategory.selectedItem != null ? this.fundCategory.selectedItem.value : "");
		reqObj.originalDataSource=(this.originalDataSource.selectedItem != null ? this.originalDataSource.selectedItem.value : "");
		return reqObj;
	}
	