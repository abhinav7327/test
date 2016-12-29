
 
package com.nri.rui.core.renderers
{
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import flash.events.MouseEvent;
    
    import mx.controls.DataGrid;
    import mx.controls.Text;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.core.UIComponent;
    import mx.managers.PopUpManager;
    import mx.utils.StringUtil;
    
    /**
     * ItemRenderer for displaying the movement records in a Popup style 
     * causing a particular balance position. 
     * 
     */
    public class PositionDetailsRenderer extends Text
    {
        private const POSITIVE_COLOR:uint = 0x007ac8; // Blue
        private const NEGATIVE_COLOR:uint = 0xFF0000; // Red 
        private const NEGATIVE_SIGN : String = "-";
        private const ZERO_BALANCE : String = "0";
        private var sign :String = "";
        
        public function PositionDetailsRenderer()
        {            
            super();
            addEventListener(MouseEvent.CLICK, handleMouseClick);
        }
        /**
         *  @private
         */
        override public function set data(value:Object):void
        {
            super.data = value;
            
            if(listData){
                var dg : DataGrid = DataGrid(listData.owner);
                var column : DataGridColumn = dg.columns[listData.columnIndex];
                text = data[column.dataField];
            }
             visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
             
             sign = data.displayBalanceInRed;
            
        }        
        /**
         * Overridden the updateDisplayList method to display the columns values
         * in different colors, in button mode, with Hand cursor etc.
         * 
         */ 
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
             super.updateDisplayList(unscaledWidth, unscaledHeight);
             
             //To show the underline with hand cursor
             buttonMode = true;
             useHandCursor = true;
             mouseChildren = false;
             
             //setting color depending on positive or negative sign
             if(text == ZERO_BALANCE){
                 setStyle("color", POSITIVE_COLOR);
             }
             else if(XenosStringUtils.equals(sign, NEGATIVE_SIGN)) {                    
                setStyle("color", NEGATIVE_COLOR) ;
             } else {
                setStyle("color", POSITIVE_COLOR);
             }
             //Setting underline to indicate someting will happen on click 
             setStyle("textDecoration","underline");
             
        }
        /**
         * Mouse Click event handler to open a popup with initialization and passing values.
         * 
         */ 
        public function handleMouseClick(event:MouseEvent):void {
                
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
            
            sPopup.title = "CAM Movement Request Summary";
            //set the width and height of the popup
            sPopup.width = parentApplication.width - 100;
            sPopup.height = parentApplication.height - 100;
            
            sPopup.horizontalScrollPolicy="off";
            sPopup.verticalScrollPolicy="off";
            PopUpManager.centerPopUp(sPopup);
    
            var accountNo : String = "";
            if(parentDocument.isBalanceQuery){
                accountNo = data.accountDisplayName;
            }else{
                accountNo = data.accountNoDisp;
            }
            
            var balBasis : String = "";
            var instPk : String = data.instrumentPk;
            var baseDate:String = "";
            var balanceFlag:String = "Y";
            
            //Getting values from the parent Document (for e.g. Cam PortFolioBalance Query Module.)
            balBasis = parentDocument.movBasisItemRndr; 
            baseDate = parentDocument.baseDateItemRndr;               
            
            
            //XenosAlert.info("accountNo = " + accountNo + "\n instPk = " + instPk + "\n balanceFlag = "+ balanceFlag + "\n balBasis = " + balBasis + "\n baseDate = " + baseDate);
            
            //Setting the Module path with some parameters which will be needed in the module for internal processing.
            sPopup.moduleUrl = Globals.POSITION_DETAILS_SWF + Globals.QS_SIGN + Globals.ACCOUNT_NO + Globals.EQUALS_SIGN + accountNo + Globals.AND_SIGN
                                                                              + Globals.INSTR_PK + Globals.EQUALS_SIGN + instPk + Globals.AND_SIGN
                                                                              + Globals.BALANCE_FLAG + Globals.EQUALS_SIGN + balanceFlag + Globals.AND_SIGN
                                                                              + Globals.MOVEMENT_BASIS + Globals.EQUALS_SIGN + balBasis + Globals.AND_SIGN
                                                                              + Globals.BASE_DATE + Globals.EQUALS_SIGN + baseDate;
                                                                   
            
        }
    }
    
}