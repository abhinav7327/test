
package com.nri.rui.nam.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	import com.nri.rui.core.utils.XenosPopupUtils;	
	import flash.events.MouseEvent;

	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;
	import com.nri.rui.core.controls.XenosAlert;

	public class NamFeedDetailRenderer extends Text
	{
		public function NamFeedDetailRenderer()
		{
			super();
			addEventListener(MouseEvent.CLICK, handleMouseClick);
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			 super.updateDisplayList(unscaledWidth, unscaledHeight);
				if(listData){
					var dg : DataGrid = DataGrid(listData.owner);
					var column : DataGridColumn = dg.columns[listData.columnIndex];
					text = data[column.dataField];
				}
			 visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			 //To show the underline with hand cursor
			 buttonMode = true;
			 useHandCursor = true;
			 mouseChildren = false;

			 setStyle("color",0x007ac8);
			 setStyle("textDecoration","underline");
		}

	public function handleMouseClick(event:MouseEvent):void {
 		var sPopup : SummaryPopup;
 		var parentApp :UIComponent = UIComponent(this.parentApplication);
        var tradePk : String = data.tradePk
        var feedTxnType : String = data.feedTxnType;
        var txnTable : String = data.txnTable;
        switch(txnTable)
        {
        	case 'TRD_TRADE' :
				sPopup = SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
				sPopup.title = "Trade Details Summary";
				sPopup.width = 650;
	    		sPopup.height = 420;
				PopUpManager.centerPopUp(sPopup);
				sPopup.moduleUrl = Globals.TRADE_DETAILS_SWF+Globals.QS_SIGN+Globals.TRADE_PK+Globals.EQUALS_SIGN+tradePk;
        	break;

        	case 'CAX_RIGHTS_DETAIL' :
            	sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
				sPopup.title = "Entitlements Detail View";
				sPopup.width = 830;
	    		sPopup.height = 550;
				PopUpManager.centerPopUp(sPopup);
				sPopup.moduleUrl = Globals.CAX_RIGHTS_DETAILS_SWF+Globals.QS_SIGN+	
									Globals.RIGHTS_DETAIL_PK+Globals.EQUALS_SIGN+tradePk;
			break;

			case 'CAX_RIGHTS_EXERCISE' :
            	sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
				sPopup.title = "Exercise Detail View";
				sPopup.width = 830;
	    		sPopup.height = 350;
				PopUpManager.centerPopUp(sPopup);
				sPopup.moduleUrl = Globals.CAX_RIGHTS_EXERCISE_SWF+Globals.QS_SIGN+	
									Globals.RIGHTS_EXERCISE_PK+Globals.EQUALS_SIGN+tradePk;
			break;

			case 'FRX_FOREX_TRADE' :
				sPopup = SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
	    		sPopup.title = "Forex Trade Details";
	            sPopup.width = parentApplication.width - 125;
	    		sPopup.height = parentApplication.height - 150;
	    		sPopup.horizontalScrollPolicy="auto";
	    		sPopup.verticalScrollPolicy="auto";
	    		PopUpManager.centerPopUp(sPopup);
	    		sPopup.moduleUrl = Globals.FRX_TRADE_DETAILS_SWF + Globals.QS_SIGN + "frxTradePk" + Globals.EQUALS_SIGN + tradePk;
	    	break;

			case 'CAM_ENTRY' :
				sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
				sPopup.title = "Cam - Security Detail";
				sPopup.width = 900;
	    		sPopup.height = 430;
				PopUpManager.centerPopUp(sPopup);
				sPopup.moduleUrl = Globals.CAM_SECURITY_DETAILS_SWF+Globals.QS_SIGN+Globals.CAM_ENTRY_PK+Globals.EQUALS_SIGN+tradePk;
			break;

			case 'BKG_BANKING_TRADE' :
				sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
				sPopup.title = "Banking Trade Details";
				sPopup.width = 700;
	    		sPopup.height = 460;
				PopUpManager.centerPopUp(sPopup);
				sPopup.moduleUrl = Globals.BKG_TRADE_DETAILS_SWF+Globals.QS_SIGN+Globals.BKG_TRADE_PK+Globals.EQUALS_SIGN+tradePk;
			break;

			case 'NCM_ENTRY' :
				sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
				sPopup.title = "Adjustment Query Details";
				sPopup.width = 720;
				sPopup.height = 340;
				PopUpManager.centerPopUp(sPopup);
				sPopup.moduleUrl = "assets/appl/ncm/AdjustmentQueryDetails.swf"+Globals.QS_SIGN+"ncmEntryPk"+Globals.EQUALS_SIGN+tradePk;
			break;

			case 'DRV_TRADE' :
	    		sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
	    		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('drv.derivativetrade.title') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.view');
	            sPopup.width = 975;
	    		sPopup.height = 550;
	    		sPopup.horizontalScrollPolicy="auto";
	    		sPopup.verticalScrollPolicy="auto";
	    		PopUpManager.centerPopUp(sPopup);
	    		sPopup.moduleUrl = Globals.DRV_TRADE_DETAILS_SWF + Globals.QS_SIGN + Globals.DRV_TRADE_PK + Globals.EQUALS_SIGN + tradePk;
			break;

			case 'STL_DETAIL_HISTORY' :
				XenosPopupUtils.showSettlementDetails(tradePk,parentApp,"Instruction");
			break;

			case 'STL_CLIENT_SETTLEMENT_INFO' :
				XenosPopupUtils.showSettlementDetails(tradePk,parentApp,"Instruction");
			break;

			case 'DRV_UNREALIZED_PL' :
				XenosAlert.info("Not Implemented");

			break;
			case 'DRV_MARGIN' :
				sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
	    		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('drv.derivativetrade.title') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.view');
	            sPopup.width = 975;
	    		sPopup.height = 550;
	    		sPopup.horizontalScrollPolicy="auto";
	    		sPopup.verticalScrollPolicy="auto";
	    		PopUpManager.centerPopUp(sPopup);
	    		sPopup.moduleUrl = Globals.DRV_TRADE_DETAILS_SWF + Globals.QS_SIGN + Globals.DRV_TRADE_PK + Globals.EQUALS_SIGN + tradePk;
			break;

			case 'DRV_ACTION' :
				sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
	    		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('drv.derivativetrade.title') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.view');
	            sPopup.width = 975;
	    		sPopup.height = 550;
	    		sPopup.horizontalScrollPolicy="auto";
	    		sPopup.verticalScrollPolicy="auto";
	    		PopUpManager.centerPopUp(sPopup);
	    		sPopup.moduleUrl = Globals.DRV_TRADE_DETAILS_SWF + Globals.QS_SIGN + Globals.DRV_TRADE_PK + Globals.EQUALS_SIGN + tradePk;
			break;
        }
	}
	}
}