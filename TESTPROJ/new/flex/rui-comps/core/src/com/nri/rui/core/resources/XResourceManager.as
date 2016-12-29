package com.nri.rui.core.resources
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	
	import mx.controls.Alert;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.utils.StringUtil;
	
	[Event(name="change", type="flash.events.Event")]
	[ExcludeClass]
	public class XResourceManager extends EventDispatcher implements IEventDispatcher
	{
		private var manager:IResourceManager;
		private var keyvalue:String = null;
		public function XResourceManager()
		{
			manager = ResourceManager.getInstance();
		}

		[Bindable(event="change")]
		public function getKeyValue(key:String, parameters:Array = null):String {
			return getStringFromBundle(key, parameters);
		}
		
		//[Bindable('change')]
		[Bindable(event="change")]
		private function getStringFromBundle(key:String, parameters:Array = null):String{
			var bundStr:String = "Bundle Names :: ";
			for each (var locale:String in manager.localeChain) { 
				//Alert.show("Locale Name " + locale);				               
                for each (var bundleName:String in manager.getBundleNamesForLocale(locale)) {
                   bundStr = bundStr + " " + bundleName;
                   
                   keyvalue = manager.getString(bundleName,key, parameters);
                    //var bundle:ResourceBundle = ResourceBundle(manager.getResourceBundle(locale, bundleName));

					//keyvalue = bundle.content[key];
					if(keyvalue != null){
						//Alert.show("Value Found " + keyvalue + " from " + bundleName);
						return keyvalue;
					}
                }
            }
            var curLocale:String = manager.localeChain[0];
            for each (locale in manager.getLocales()) { 
            	if(locale == curLocale)
            		continue;
				//Alert.show("Locale Name " + locale);				               
                for each (bundleName in manager.getBundleNamesForLocale(locale)) {
                   bundStr = bundStr + " " + bundleName;
                   
                   keyvalue = manager.getString(bundleName,key);
                    //var bundle:ResourceBundle = ResourceBundle(manager.getResourceBundle(locale, bundleName));

					//keyvalue = bundle.content[key];
					if(keyvalue != null){
						Alert.show("Value Found " + keyvalue + " from " + locale);
						return keyvalue;
					}
                }
            }
            
            Alert.show("Value Not Found from in All Locales" + bundStr);
            return null;
		}
		
		public function loadResourceModule(url:String, updateFlag:Boolean = true,
                                       applicationDomain:ApplicationDomain = null,
                                       securityDomain:SecurityDomain = null):
                                       IEventDispatcher {
                                       	
    		return manager.loadResourceModule(url, updateFlag,
                                       applicationDomain,
                                       securityDomain);
    	}
		
		/**
	     *  @copy mx.resources.IResourceManager#localeChain
	     */
	    public function get localeChain():Array /* of String */
	    {
	        return manager.localeChain;
	    }
	    
	    /**
	     *  @private
	     */
	    public function set localeChain(value:Array /* of String */):void
	    {
	        manager.localeChain = value;	        
	    }
	    public function getResourceManager():IResourceManager {
	    	return manager;
	    }
	    public function update():void{
	    	manager.update();
	    	//dispatchEvent(new Event(Event.CHANGE));
	    }
	}

	
}