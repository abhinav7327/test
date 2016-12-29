package com.nri.rui.core.startup
{
    import com.nri.rui.core.controls.XenosButton;
    import com.nri.rui.core.startup.vo.CachedVo;
    
    import flexlib.mdi.containers.MDIWindow;
    
    /**
     * This class is modelled as a Singleton class
     * This will create a InitContext
     */
    public final class XenosApplication 
                             
    {
        [Bindable]
        private static var m_instance:XenosApplication;
        //This caches the instrument tree, ccy items, market tree, menu tree
        [Bindable]
        public var cachedItems:CachedVo;
        //This denotes whether user can open multiple windows
        [Bindable]
        public var multiWindowsOpen:Boolean = false;
        //multiWindows enabled flag
        [Bindable]
        public var multiWindowsOpenEnabled:Boolean = true;
        //confirmWindowClose flag
        [Bindable]
        public var confirmWindowClose:Boolean = false;
        // Horizontal/Vertical menu flag
        [Bindable]
        public var horizontalMenu:Boolean = true;
        //This denotes the UserId when a particular user logs in
        [Bindable]
        public var userId : String; 
        [Bindable]
        public  var winX : Number;
        [Bindable]
        public  var winY : Number;
        
        //This variable stores the default submit button instance
        [Bindable]
        public  var submitButtonInstance : XenosButton;
        
        //This variable stores the active window instance
        [Bindable]
        public  var mdiWindowInstance : MDIWindow;
        
        [Bindable]
        public var minimumVisibleColumns:Number;
        
        [Bindable]
        public var visibleColumnsFrom:String="";
        
        [Bindable]
        public var caxAppDate: String="";
        // Constructor
        public final function XenosApplication(enterpriseName : String,enforcer : SingletonEnforcer)
        {    
            if (enforcer == null) {
                throw new Error( "Only One XenosApplication is allowed" );
            }
            //super();
            cachedItems = new CachedVo();
        }
        // Returns the Single Instance
        public static function getInstance(enterpriseName:String):XenosApplication {
            if(m_instance == null) {
                m_instance = new XenosApplication(enterpriseName,new SingletonEnforcer);
            }
            return m_instance;
        }
             
    }
}

class SingletonEnforcer{}