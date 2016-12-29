
package com.nri.rui.core.utils
{
    import com.nri.rui.core.containers.XenosMDIWindow;
    import com.nri.rui.core.containers.XenosMDICanvas;    
     
    /**
     * Utility class for whole application
     * 
     */
    public class CoreUtils
    {
        public function CoreUtils()
        {
            //TODO: implement function
        }
        
        /**
         * This method will search a window by a given uniqueId in the given window Container.
         * @param windowContainer   The window Container.
         * @param uniqueId          The unique id of the window to be searched.
         * @return                  The window object reference if found else null.
         * 
         */
        public static function getWindow(windowContainer:XenosMDICanvas,uniqueId:String):XenosMDIWindow
        {
            var availablewindows : Array = windowContainer.windowManager.windowList;
            for(var i:int = 0; i<availablewindows.length;i++){
                var tempWin:XenosMDIWindow = XenosMDIWindow(availablewindows[i]);
                if(tempWin.uniqueId == uniqueId){
                    //window = tempWin;
                    return tempWin;
                }
            }
            return null;
        }
    }
}