// ActionScript file

 // ActionScript file for rights Exercise View
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.startup.XenosApplication;

	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;


	[Bindable]
	private var errorColls:ArrayCollection = new ArrayCollection();
	[Bindable]
	private var xmlSource:XML= new XML();

	private var initCompFlg : Boolean = false;
	[Bindable]
	public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);


	[Bindable]
	public var returnContextItem:ArrayCollection = new ArrayCollection();

	[Bindable]
	public var rightsExercisePk:String;

	[Bindable]
	private var queryResult:ArrayCollection= new ArrayCollection();

   /**
   * This method is used sending the httpRequest to the server side.
   */
   public function submitQueryResult():void{
	parseUrlString();
	var requestObj :Object = populateRequestParams();
	rightExerciseRequest.request = requestObj;
	rightExerciseRequest.send();
	}

   /**
   * This method is used parsing the URL.
   */
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
				if (tempA[0] == Globals.RIGHTS_EXERCISE_PK) {
					rightsExercisePk = tempA[1];
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
		//var xmlData:XML = new XML();
		if (null != event) {
			if(null == event.result){
				queryResult.removeAll(); // clear previous data if any as there is no result now.
				if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
					errPage.clearError(event); //clears the errors if any
					XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				} else { // Must be error
					errPage.displayError(event);
				}
			}else {
					xmlSource = event.result as XML;
			}
		}else {
			//queryResult.removeAll();
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}
	}

	/**
	* This method populates the request object for Http Service.
	*
	*/
	/*private function showSettlementInfo():void {

				var sPopup : SummaryPopup;
				var parentApp :UIComponent = UIComponent(this.parentApplication);
				var rightsDetailPk:String = xmlSource.rightsDetailPk;
				sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
				sPopup.title = "Settlement Query Result Summary";
				sPopup.width = 780;
				sPopup.height = 400;
				PopUpManager.centerPopUp(sPopup);

				sPopup.moduleUrl = Globals.SETTLEMENT_QUERY_POPUP_SUMMARY_TRADE+Globals.QS_SIGN+Globals.PATH+Globals.EQUALS_SIGN+"TRADE"+Globals.AND_SIGN+Globals.DRV_TRADE_PK+Globals.EQUALS_SIGN+rightsDetailPk+Globals.AND_SIGN+Globals.SETTLEMENT_FOR+Globals.EQUALS_SIGN+"CORPORATE_ACTION";
				//XenosAlert.info("Module URL :: "+sPopup.moduleUrl);

	}*/

	/**
	*  This method populates the request object for Http Service.
	*
	*/
   private function populateRequestParams():Object {

		var reqObj : Object = new Object();
		 reqObj.rightsExercisePk = rightsExercisePk;
		 return reqObj;
	}
