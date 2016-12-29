// ActionScript file
package com.nri.rui.core.controls
{
    
    import mx.controls.dataGridClasses.DataGridColumn;
   
    /*Custom Data Grid Column has been used to solve the big screen size problem in fam screens(XPXR-2367).
      It has been seen that if all columns remain visible=false at first time and if we can make those
      column visible when user opens the screen, then we can solve big screen size problem. For this reason 
      new variable  _customVisible has been introduced. All datagrid column in TransactionQuery.mxml has visible=false and _customVisible = true(default).
      then when the grid initializes in CustomDataGridForSpring.sendPersonalizeService(), we make the column visible by checking
      _customVisible variable. This change also introduced at the time of clear preference.
    */
    public class CustomDataGridColumn extends DataGridColumn{
        
        private var _customVisible:Boolean=true;
		
        public function CustomDataGridColumn(){
            trace("CustomDataGridColumn");
            super();
        }        
       
        public function set customVisible(isVisible:Boolean):void
        {
            this._customVisible = isVisible;
        }
        
        public function get customVisible():Boolean
        {
            return this._customVisible;
        }
    }		
       
}