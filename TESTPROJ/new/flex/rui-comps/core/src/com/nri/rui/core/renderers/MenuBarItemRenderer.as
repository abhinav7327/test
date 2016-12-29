package com.nri.rui.core.renderers
{
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.controls.menuClasses.MenuBarItem;

    public class MenuBarItemRenderer extends MenuBarItem
    {
        /**
         *  @private
         */
        private var leftMargin:int = 16;
        
        private var _labelStr:String = null; 
        
        public function MenuBarItemRenderer()
        {            
            super();
        }
        // Override the set method for the data property        
        override public function set data(value:Object):void {
            super.data = value;
            var xmlData:XML = XML(value); 
            if(xmlData != null){
                _labelStr = xmlData.attribute("label").toString();
               
                if(label != null )
                    label.text = _labelStr;
            }
        }
        /**
         * This method overrides the updateDisplayList method to set the different properties 
         * of the MenuBarItems in the Menu Bar for their individual width, height.
         * This step has been taken due to default top menu item labels was showing 
         * half/none/little... at different login/refresh time.
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {

            var labelCharWidth:Number;
            
            super.updateDisplayList(unscaledWidth,unscaledHeight);            
            
            if(XenosStringUtils.isBlank(_labelStr)){// when no data going for default settings.
                return;
            }
            
            labelCharWidth = _labelStr.length * Globals.WIDTH_SINGLE_CHARACTER;

            super.width = labelCharWidth + leftMargin;
            super.label.explicitHeight = Globals.MENU_HEIGHT; //=24;
            
            // Code modified from super class
            if (icon)
            {
                icon.x = (leftMargin - icon.measuredWidth) / 2;
                icon.setActualSize(icon.measuredWidth, icon.measuredHeight);
                label.x = leftMargin;
            }
            else
                label.x = leftMargin / 2;
                
            label.setActualSize(labelCharWidth+ 4.5, 
                label.getExplicitOrMeasuredHeight()); //Modified here
                
            label.y = ((unscaledHeight - label.height) / 2) + 3;
            
            if (icon)
                icon.y = (unscaledHeight - icon.height) / 2;
                
            menuBarItemState = "itemUpSkin";
        } 
    }
}