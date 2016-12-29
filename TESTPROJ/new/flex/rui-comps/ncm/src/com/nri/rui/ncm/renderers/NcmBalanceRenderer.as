
 
package com.nri.rui.ncm.renderers
{
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.XenosAlert;
    
    import flash.events.MouseEvent;
    
    import mx.controls.DataGrid;
    import mx.controls.Text;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.core.UIComponent;
    import mx.managers.PopUpManager;
    import mx.utils.StringUtil;
    import mx.core.Application;
    
    /**
     * ItemRenderer for displaying the movement records in a Popup style 
     * causing a particular balance position. 
     * 
     */
    public class NcmBalanceRenderer extends Text
    {
        private const POSITIVE_COLOR:uint = 0x007ac8; // Blue
        private const NEGATIVE_COLOR:uint = 0xFF0000; // Red 
        private const NEGATIVE_SIGN : String = "-";
        
        public function NcmBalanceRenderer()
        {            
            super();
            //addEventListener(MouseEvent.CLICK, handleMouseClick);
        }
        /**
         * Overridden the updateDisplayList method to display the columns values
         * in different colors, in button mode, with Hand cursor etc.
         * 
         */ 
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    		 super.updateDisplayList(unscaledWidth, unscaledHeight);
    			/* if(listData){
    				var dg : DataGrid = DataGrid(listData.owner);
    				var column : DataGridColumn = dg.columns[listData.columnIndex];
    				text = data[column.dataField];
    			} 
    		 visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
    		 //To show the underline with hand cursor
    		 buttonMode = true;
    		 useHandCursor = true;
    		 mouseChildren = false;
    		 
    		 //setting color depending on positive or negative value
    		 if(listData){               
               // text = DataGridListData(listData).label ;
                if(String(text).charAt(0) == NEGATIVE_SIGN){                    
                    setStyle("color",  NEGATIVE_COLOR) ;
                }else {
                    setStyle("color", POSITIVE_COLOR);
                }
             }
             //Setting underline to indicate someting will happen on click 
    		 setStyle("textDecoration","underline");
    		 */
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
				if(String(text).charAt(0) == NEGATIVE_SIGN){                    
                    setStyle("color",  NEGATIVE_COLOR) ;
                }else {
                    setStyle("color", POSITIVE_COLOR);
                }
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
    	
    	/**
    	 * Mouse Click event handler to open a popup with initialization and passing values.
    	 * 
    	 */ 
         public function handleMouseClick(event:MouseEvent):void {
    			
    		var sPopup : SummaryPopup;	
    		sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
    		
    		var bankPk : String = data.bankPk;
    		var accountPk : String = data.accountPk;
    		var balanceBasis : String = "";
    		var accountNo : String = data.brknoAccountNo;
    		var bankName : String = data.bankCode;
    		var popupFlag : String = parentDocument.popupFlag;
    		//var balanceType: String = data.balanceType;
    		
    		var dg :DataGrid = DataGrid(listData.owner);
    		var dgc:DataGridColumn = DataGridColumn(dg.columns[listData.columnIndex]);
    		
    		var colHeader:String = dgc.headerText;
    		
    		//pop up titles are decided according to the jsp version
    		if(colHeader == "Value Date Balance"){
    			sPopup.title = Application.application.xResourceManager.getKeyValue('ncm.balance.query.projected.header');
    			balanceBasis = "projected_balance";
    		}else if(colHeader == "Settlement Date Balance"){
    			sPopup.title = Application.application.xResourceManager.getKeyValue('ncm.balance.query.actual.header');
    			balanceBasis = "actual_balance";
    		}else if(colHeader == "Fail Balance"){
    			sPopup.title = Application.application.xResourceManager.getKeyValue('ncm.balance.query.fail.header');
    			balanceBasis = "fail_balance";
    		}else if(colHeader == "Temp Balance as Value Date"){
    			sPopup.title = Application.application.xResourceManager.getKeyValue('ncm.balance.query.unmatched.header');
    			balanceBasis = "unmatched_balance";
    		}
    		
    		
    		sPopup.width = 500;
    		sPopup.height = 400;
    		PopUpManager.centerPopUp(sPopup);
    		
    		
    		sPopup.moduleUrl = Globals.NCM_BALANCE_DETAILS_SWF + Globals.QS_SIGN + Globals.ACCOUNT_NO + Globals.EQUALS_SIGN + accountNo 
    														+ Globals.AND_SIGN + Globals.ACCOUNTS_PK + Globals.EQUALS_SIGN + accountPk
    														+ Globals.AND_SIGN + Globals.BANK_PK + Globals.EQUALS_SIGN + bankPk
    														+ Globals.AND_SIGN + Globals.BANK_NAME + Globals.EQUALS_SIGN + bankName
    														+ Globals.AND_SIGN + Globals.BALANCE_BASIS + Globals.EQUALS_SIGN + balanceBasis
    														+ Globals.AND_SIGN + "flag" + Globals.EQUALS_SIGN + popupFlag;
    		
    		
    		
	                                                               
    		
    	} 
    }
    
}