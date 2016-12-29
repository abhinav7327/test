

package com.nri.rui.fam.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	import com.nri.rui.fam.FamConstants;
	import flash.events.MouseEvent;
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;

	/**
	 * ItemRenderer for displaying the Receivable Income Details records in a Popup style.
	 *
	 */
	public class ReceivableIncomeDetailsRenderer extends Text
	{

		public function ReceivableIncomeDetailsRenderer()
		{
			super();
		}

		private const BLUE_COLOR:uint=0x0000FF; // Blue         

		override public function set data(value:Object):void
		{
			super.data=value;
			setVisibleProp();
		}

		/**
		 * Mouse Click event handler to open a popup with initialization and passing values.
		 *
		 */
		public function handleMouseClick(event:MouseEvent):void
		{
			var sPopup:SummaryPopup;
			sPopup=SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication), SummaryPopup, false));

			sPopup.title=this.parentApplication.xResourceManager.getKeyValue('fam.portfoliobalance.label.receivableincomedetails');
			//set the width and height of the popup
			sPopup.width=parentApplication.width - 100;
			sPopup.height=554;

			sPopup.horizontalScrollPolicy="auto";
			sPopup.verticalScrollPolicy="auto";
			PopUpManager.centerPopUp(sPopup);

			var fundPk:String=data.fundPk;
			var instrumentPk:String=data.instrumentPk;
			var baseDate:String=data.baseDateStr;
			var syntaxSecurityType:String=data.syntaxSecurityType;
			var commandFormId:String=data.commandFormIdForPortfolioBalance;

			//Setting the Module path with some parameters which will be needed in the module for internal processing.
			sPopup.moduleUrl=Globals.FAM_RECEIVABLE_INCOME_DETAILS_SWF + Globals.QS_SIGN + 
							 Globals.FUND_PK + Globals.EQUALS_SIGN + fundPk + 
							 Globals.AND_SIGN + 
							 Globals.INSTRUMENT_PK + Globals.EQUALS_SIGN + instrumentPk + 
							 Globals.AND_SIGN + 
							 Globals.BASE_DATE + Globals.EQUALS_SIGN + baseDate + 
							 Globals.AND_SIGN + 
							 Globals.COMMAND_FORM_ID + Globals.EQUALS_SIGN + commandFormId;
		}

		/**
		 * Overridden the updateDisplayList method to display the columns values
		 * in different colors, in button mode, with Hand cursor etc.
		 *
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}

		private function setVisibleProp():void
		{
			var visibleFlag:Boolean = true;
			if((StringUtil.trim(data.syntaxSecurityType) != Globals.SYNTAX_SECURITY_TYPE_S) || (StringUtil.trim(text) == Globals.EMPTY_STRING )) 
				visibleFlag = false;
			
			buttonMode=visibleFlag;
			useHandCursor=visibleFlag;
			mouseChildren=!visibleFlag;
			if (visibleFlag)
			{
				setStyle("color", 0x007ac8);
				setStyle("textDecoration", "underline");
				addEventListener(MouseEvent.CLICK, handleMouseClick);
			}
			else
			{
				if (hasEventListener(MouseEvent.CLICK))
					removeEventListener(MouseEvent.CLICK, handleMouseClick);
				setStyle("color", 0x000000);
				setStyle("textDecoration", "normal");
			}
		}
	}

}
