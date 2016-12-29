
// ActionScript file loading Resource Bundles

package com.nri.rui.core.resources
{
    import com.nri.rui.core.Module;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.system.System;
    
    import mx.collections.ArrayCollection;
    import mx.core.IUIComponent;
    import mx.events.ResourceEvent;
    import mx.resources.ResourceBundle;
    
    
    /**
     * This class helps to load resource bundles in the specified ResourceManager.
     * 
     * The modules for which the resource bundles will be loaded must be available
     * in the com.nri.rui.core.Module class. When a new module is added for the RUI
     * Application then the module name must be included in the 
     * com.nri.rui.core.Module class. Also the compiled resource bundle for the module
     * name must be available in the <Context_Root>/assets/appl/<module_name> directory.
     * 
     * The module name, their resource bundle names, loaded resource name would be like this:
     * 
     * Module               Resource Bundle Name                   Resource Name
     * 
     * INF                  coreResources_en_US.swf               coreResources
     * REF                  refResources_en_US.swf                refResources
     * BKG                  bkgResources_en_US.swf                bkgResources
     * CAM                  camResources_en_US.swf                camResources
     * 
     * and so on...
     * 
     * 
     * @author sanjoys
     * @version 
     */
    public class XenosResourceBundle
    {
        private var xResourceManager:XResourceManager = null;
        private var parentApp:IUIComponent=null;

        /**
         * Constructor for this class
         *  
         * @param xResourceManager The Custom resource manager
         * @param parentApp        The IUIComponent instance from where the resource will be loaded.
         * 
         */
        public function XenosResourceBundle(xResourceManager:XResourceManager,parentApp:IUIComponent){
            this.xResourceManager = xResourceManager;
            this.parentApp = parentApp;
        }
        /**
         * This method loads the dependent resource bundles related to the Total Application.
         *                         
         */
        public function loadXenosResourceBundle() : void {                                
                if(xResourceManager.localeChain == null)
                    xResourceManager.localeChain = ["en_US"]; //By Default en_US loading 
                var modules:ArrayCollection = Module.getModules();
                //XenosAlert.info("Initial Memory = "+ System.totalMemory/1024 + "Kb");
                for each (var module: String in modules) {
                    if(XenosStringUtils.equals(module,"INF"))
                        loadResourceBundle(module.toLowerCase(),"coreResources");
                    else 
                        loadResourceBundle(module.toLowerCase(),module.toLowerCase()+"Resources");
                }                
                xResourceManager.update();
        }
        
        /**
         * This method loads the particular resource bundle specified with the specified name.         
         *  
         * @param module         The module for which the resource will be loaded.
         * @param resourceName   The name with which the resource will be loaded.
         * 
         */
        private function loadResourceBundle(module:String ,resourceName:String):void {
         
            var locales:String = xResourceManager.localeChain[0];
            var resourceModuleURL:String = "assets/appl/"+ module+"/"+ resourceName+"_" + locales + ".swf";
            var bundle:ResourceBundle = ResourceBundle(xResourceManager.getResourceManager().getResourceBundle(locales,resourceName));
            var eventDispatcher:IEventDispatcher = null;
            if(bundle == null){    
                eventDispatcher = xResourceManager.loadResourceModule(resourceModuleURL);
                eventDispatcher.addEventListener(ResourceEvent.ERROR, errorHandler);
                if(resourceName == "coreResources")
                    eventDispatcher.addEventListener(ResourceEvent.COMPLETE, coreHandler);
                else
                    eventDispatcher.addEventListener(ResourceEvent.COMPLETE, completeHandler);
            }else{
                XenosAlert.info( resourceModuleURL + "Not Loaded at runtime");
            }
          
        }
        private function errorHandler(event:ResourceEvent):void{
            XenosAlert.error("Error Occured while loading Resource Bundle :: " + event.errorText);
        }
        
        /**
         * Event Handler for the core resource bundle loading completes.
         *  
         * @param event The ResourceEvent.
         * 
         */
        private function coreHandler(event:ResourceEvent):void{
            //Generate and dispach event to the source component to update the resources.
            if(null != parentApp)
                parentApp.dispatchEvent(new Event("COMPLETE"));
            this.xResourceManager.update();
            
            //XenosAlert.info("memory = "+ System.totalMemory/1024 + "Kb");
        }
        /**
         * Event Handler for the resource bundles(except core) loading completes.
         *  
         * @param event The ResourceEvent.
         * 
         */ 
        private function completeHandler(event:ResourceEvent):void{
            //XenosAlert.info("memory = "+ System.totalMemory/1024 + "Kb");
        } 
    }
}

