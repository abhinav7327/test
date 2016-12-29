
package com.nri.rui.icn.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.XenosPopupUtils;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;


	public class DetailRenderer extends Text
	{
		
		protected var xnsPkStr:String;
		protected var xnsTable:String;
		public function DetailRenderer()
		{
			super();
			
			//addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			 super.updateDisplayList(unscaledWidth, unscaledHeight);
			 /* visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			 //To show the underline with hand cursor
			 buttonMode = true;
			 useHandCursor = true;
			 mouseChildren = false;
			 
			 setStyle("color",0x007ac8);
			 setStyle("textDecoration","underline"); */
			 
			 
		}
		
		override public function set data(value:Object):void{
			super.data = value;
			//visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			setVisibleProp();
		}
		
		private function setVisibleProp():void{
			
			var visibleFlag : Boolean = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			buttonMode = visibleFlag;
			useHandCursor = visibleFlag;
			mouseChildren = !visibleFlag;
			if(visibleFlag){
				setStyle("color",0x007ac8);
				setStyle("textDecoration","underline");
				addEventListener(MouseEvent.CLICK, handleMouseClick);
			}
			else{
				if(hasEventListener(MouseEvent.CLICK))
					removeEventListener(MouseEvent.CLICK,handleMouseClick);
				setStyle("color",0x000000);
				setStyle("textDecoration","normal");
				//removeEventListener(MouseEvent.CLICK,handleMouseClick);
			}
			
		}
		
		 public function handleMouseClick(event:MouseEvent):void {
		 	var sPopup : SummaryPopup;	
		 	xnsTable = data.xnsTxnTable;
		 	xnsPkStr = data.xnsTxnPK;
		 	var parentApp :UIComponent = UIComponent(this.parentApplication);
		 	//XenosAlert.info("xnsTable" +xnsTable);
		 	//XenosAlert.info("xnsTxnPK" +xnsPkStr);
		 	switch (xnsTable){
		 	
		 		case 'TRD_TRADE' :
					sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
					
					sPopup.title = "Trade Details Summary";
					sPopup.width = 650;
		    		sPopup.height = 420;			
					
					PopUpManager.centerPopUp(sPopup);
					sPopup.moduleUrl = Globals.TRADE_DETAILS_SWF+Globals.QS_SIGN+Globals.TRADE_PK+Globals.EQUALS_SIGN+xnsPkStr;
        		break;
        		
        		case 'CAX_RIGHTS_DETAIL' :
        			//XenosAlert.info("xnsPkStr" +xnsPkStr);
					sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
					
					sPopup.title = "Entitlements Detail View";
					sPopup.width = 830;
		    		sPopup.height = 550;
					PopUpManager.centerPopUp(sPopup);
					
					sPopup.moduleUrl = Globals.CAX_RIGHTS_DETAILS_SWF+Globals.QS_SIGN+	
										Globals.RIGHTS_DETAIL_PK+Globals.EQUALS_SIGN+xnsPkStr;
		 		break;
					
				case 'FRX_FOREX_TRADE' :
					
					sPopup = SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
		    		sPopup.title = "Forex Trade Details";
		            //set the width and height of the popup
		            sPopup.width = parentApplication.width - 125;
		    		sPopup.height = parentApplication.height - 150;
		 
		    		sPopup.horizontalScrollPolicy="auto";
		    		sPopup.verticalScrollPolicy="auto";
		    		PopUpManager.centerPopUp(sPopup);
		    
		    		sPopup.moduleUrl = Globals.FRX_TRADE_DETAILS_SWF + Globals.QS_SIGN + "frxTradePk" + Globals.EQUALS_SIGN + xnsPkStr;
		    	break;
					
				case 'CAM_ENTRY' :
					sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
					
					sPopup.title = "NAM - Security Detail";
					sPopup.width = 780;
		    		sPopup.height = 430;
					PopUpManager.centerPopUp(sPopup);
					
					sPopup.moduleUrl = Globals.CAM_SECURITY_DETAILS_SWF+Globals.QS_SIGN+Globals.CAM_ENTRY_PK+Globals.EQUALS_SIGN+xnsPkStr;
				break;
				
				case 'BKG_BANKING_TRADE' :
					sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
					sPopup.title = "Banking Trade Details";
					sPopup.width = 700;
		    		sPopup.height = 460;
					PopUpManager.centerPopUp(sPopup);		
					//var bankingTrdPkStr : String = data.bankingTradePk;
					sPopup.moduleUrl = Globals.BKG_TRADE_DETAILS_SWF+Globals.QS_SIGN+Globals.BKG_TRADE_PK+Globals.EQUALS_SIGN+xnsPkStr;
				break;
				
				case 'NCM_ENTRY' :
					sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
					
					sPopup.title = "Adjustment Query Details";
					sPopup.width = 720;
					sPopup.height = 340;
					PopUpManager.centerPopUp(sPopup);		
					//var ncmEntryPk : String = data.ncmEntryPk;
					sPopup.moduleUrl = "assets/appl/ncm/AdjustmentQueryDetails.swf"+Globals.QS_SIGN+"ncmEntryPk"+Globals.EQUALS_SIGN+xnsPkStr;
				break;
				
				case 'DRV_TRADE' :
		    		sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
		    		
		    		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('drv.derivativetrade.title') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.view');
		            //set the width and height of the popup
		            sPopup.width = 975;
		    		sPopup.height = 550;
		 
		    		sPopup.horizontalScrollPolicy="auto";
		    		sPopup.verticalScrollPolicy="auto";
		    		PopUpManager.centerPopUp(sPopup);
		    		
		    		//Setting the Module path with some parameters which will be needed in the module for internal processing.    		
		    		sPopup.moduleUrl = Globals.DRV_TRADE_DETAILS_SWF + Globals.QS_SIGN + Globals.DRV_TRADE_PK + Globals.EQUALS_SIGN + xnsPkStr;
				break;
				
				case 'STL_DETAIL_HISTORY' :
					sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
					
					sPopup.title = "Settlement History Details";
					sPopup.width = 780;
		    		sPopup.height = 320;
					PopUpManager.centerPopUp(sPopup);
					
					sPopup.moduleUrl = Globals.SETTLEMENT_HISTORY_DETAILS_SWF+Globals.QS_SIGN+Globals.SETTLEMENT_DETAIL_HISTORY_PK+Globals.EQUALS_SIGN+xnsPkStr;
				break;
				
				case 'STL_CLIENT_SETTLEMENT_INFO' :
					var infoPk : string = data.infoPK;
					var viewMode:String = "Instruction";
					//var parentApp :UIComponent = UIComponent(this.parentApplication);
					XenosPopupUtils.showSettlementDetails(infoPk,
									      parentApp,
									      this.parentApplication.xResourceManager.getKeyValue('icn.feedquery.label.settlement.detail.header'),
									      viewMode);
					

					
				break;
				
				case 'DRV_UNREALIZED_PL' :
					XenosAlert.info("Not Implemented");
					
				break;
				case 'DRV_MARGIN' :
					//XenosAlert.info("There is no detail page For Drv Margin");
					sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
		    		
		    		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('drv.derivativetrade.title') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.view');
		            //set the width and height of the popup
		            sPopup.width = 975;
		    		sPopup.height = 550;
		 
		    		sPopup.horizontalScrollPolicy="auto";
		    		sPopup.verticalScrollPolicy="auto";
		    		PopUpManager.centerPopUp(sPopup);
		    		
		    		//Setting the Module path with some parameters which will be needed in the module for internal processing.    		
		    		sPopup.moduleUrl = Globals.DRV_TRADE_DETAILS_SWF + Globals.QS_SIGN + Globals.DRV_TRADE_PK + Globals.EQUALS_SIGN + xnsPkStr;
				break;
				
				case 'DRV_ACTION' :
					
					sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
		    		
		    		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('drv.derivativetrade.title') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.view');
		            //set the width and height of the popup
		            sPopup.width = 975;
		    		sPopup.height = 550;
		 
		    		sPopup.horizontalScrollPolicy="auto";
		    		sPopup.verticalScrollPolicy="auto";
		    		PopUpManager.centerPopUp(sPopup);
		    		
		    		//Setting the Module path with some parameters which will be needed in the module for internal processing.    		
		    		sPopup.moduleUrl = Globals.DRV_TRADE_DETAILS_SWF + Globals.QS_SIGN + Globals.DRV_TRADE_PK + Globals.EQUALS_SIGN + xnsPkStr;
				break;
		 	}
					
		} 
		override public function validateProperties():void{
			super.validateProperties();
			if (listData)
			{	
				var dg :DataGrid = DataGrid(listData.owner);
				var column:DataGridColumn =	dg.columns[listData.columnIndex];
				var dataTips:Boolean = dg.showDataTips;
				if (column.showDataTips == true)
					dataTips = true;
				if (column.showDataTips == false)
					dataTips = false;

				if (dataTips)
				{
					if (!(data is DataGridColumn) && (textWidth > width 
						|| column.dataTipFunction || column.dataTipField 
						|| dg.dataTipFunction || dg.dataTipField))
					{
						toolTip = column.itemToDataTip(data);
					}
					else
					{
						toolTip = null;
					}
				}
				else
				{
					toolTip = null;
				}

			}
		}
	}
}