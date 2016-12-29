
// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.containers.SessionSharedRestrictPopup;
import com.nri.rui.core.containers.XenosMDIWindow;
import com.nri.rui.core.controls.*;
import com.nri.rui.core.resources.*;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.CoreUtils;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.net.SharedObject;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;

import flexlib.mdi.containers.MDICanvas;
import flexlib.mdi.events.MDIManagerEvent;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.ItemClickEvent;
import mx.events.MenuEvent;
import mx.events.StyleEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.mxml.HTTPService;
import mx.styles.StyleManager;
import mx.utils.StringUtil;

private var queuedEvent:MDIManagerEvent;
private var effectsList:Array;
private var stylesList:Array;
private var cssURL:String;
private var window:XenosMDIWindow;
[Bindable]
private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
public var toolbars:Array= new Array("openMenu()","openCompMenu()");

[Bindable]
public var xResourceManager:XResourceManager;

private var bConfirmCloseStatus:Boolean=false;
private var bConfirmMultipleWindowOpenStatus:Boolean=false;
private var bconfirmMultiWinEnabled:Boolean=true;
private var preference:PreferenceDialog;
private var chngPasswdDialog:ChangePasswordDialog;
private var browserHttpService:HTTPService = new XenosHTTPService();
            
private function onCreationComplete(canvas: MDICanvas):void
{               
    
    //display the user id
    userIdAccess.send();
    // listen for window close
    //XenosAlert.info("UID :: "+this.creationIndex);
    
    browserHttpService.url = "ref/menuLoaderDispatch.action?method=browserSessionFlagLoader";
    
    browserHttpService.useProxy = false;
    
    browserHttpService.addEventListener(ResultEvent.RESULT, newSessionBrowserAllowed);
    
    browserHttpService.addEventListener(FaultEvent.FAULT, browserSessionFault);
    
    browserHttpService.resultFormat = "e4x";
    
    browserHttpService.send();
    
    canvas.windowManager.addEventListener(MDIManagerEvent.WINDOW_CLOSE, confirmWindowClose);
    
    //listen for all window events
    canvas.windowManager.addEventListener(MDIManagerEvent.WINDOW_ADD, windowEventHandler);
    
    //hrMenu.addEventListener(KeyboardEvent.KEY_UP,enterHandler); 
    
    navOpenHandler();
    hrMenu.setStyle("openDuration", 0); //To solve the display problem of child menu label showing in full screen mode
}

private function newSessionBrowserAllowed(event:ResultEvent):void{
    if(event.result){
        //XenosAlert.info("Browser Flag XML :: "+event.result.flag);
        if(event.result.flag == "false"){
            //appCtrlBar.enabled = false;
            showBrowserSessionInvalidPopup();
            //Application.application.enabled = false;            
        }
    }
    
}

private function showBrowserSessionInvalidPopup(){
    var sPopup : SessionSharedRestrictPopup;    
        var parentApplication:UIComponent = UIComponent(this);
            sPopup= SessionSharedRestrictPopup(PopUpManager.createPopUp(parentApplication,SessionSharedRestrictPopup,true));
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleLoader.url = "assets/appl/inf/SessionShare.swf";
}

private function browserSessionFault(event:FaultEvent):void{
    XenosAlert.error("Error occurred while connecting to server !!");
}

//This method will determine whether multiple windows can be opened
//This will set the value globally.
private function setMultipleWindows():void {
    app.multiWindowsOpen = bConfirmMultipleWindowOpenStatus;
}
//set the value of confirmWindowClose flag to a global variable at the Application level
private function setConfirmWindowClose():void {
    app.confirmWindowClose = bConfirmCloseStatus;
}
// default event handler
private function windowEventHandler(event:Event):void
{
    if(event is MDIManagerEvent)
    {
        if(!app.horizontalMenu){ //In case of vertical menu
            //This ensures that besides Menu Panel, any other window has been opened
            //while MultipleWindows check box is selected. So disable it till 
            //no more windows other than Menu Panel are open.
            if(mdiCanvas.windowManager.windowList.length > 1 ){ 
                //confirmMultiWin.enabled = false;
                app.multiWindowsOpenEnabled = false;
            }
        }else{
            //This ensures that if any window has been opened
            //while MultipleWindows check box is selected. So disable it till 
            //no more windows are open.
            if(mdiCanvas.windowManager.windowList.length > 0 ){ 
                //confirmMultiWin.enabled = false;
                app.multiWindowsOpenEnabled = false;
            }
        }
        
    }
}
// the flex framework dispatches all kinds of events
// in order to avoid catching one of those and throwing a coercion error
// have your listener accept Event and check the type inside the function
// this is good practice for all Flex development, not specific to flexlib.mdi
private function confirmWindowClose(event:Event):void
{
    if(event is MDIManagerEvent )
    {
        queuedEvent = event.clone() as MDIManagerEvent;
        if(bConfirmCloseStatus){
            // store a copy of the event in case we want to resume later (user confirms their intention)
            //queuedEvent = event.clone() as MDIManagerEvent;
        
            // this is the line that prevents the default behavior from executing as usual
            // because the default handler checks event.isDefaultPrevented()
            event.preventDefault();
            
            XenosAlert.confirm("Want to close it?",handleAlertResponse);
        }else {
            enableMultipleWindows();
        }
    }

}

// called when the Alert window is closed
// if the user said yes, we execute the default behavior of playing an effect
// and then removing the window by sending the stored event to
// the appropriately named executeDefaultBehavior() method
private function handleAlertResponse(event:CloseEvent):void
{
    if(event.detail == mx.controls.Alert.YES)
    {
        mdiCanvas.windowManager.executeDefaultBehavior(queuedEvent);
        enableMultipleWindows();
    }
}
// While opening windows other than menu Panel, if multiple window
// check box is checked , then disable it till no more windows other than 
// Menu Panel are opened.
// When all windows are closed then again, enable the check box.
private function enableMultipleWindows():void {
    
    if(!app.horizontalMenu){    
        //Check whether all windows are closed
        if(mdiCanvas.windowManager.windowList.length == 2 && !(queuedEvent.window is MenuPanel)){
            if(mdiCanvas.windowManager.windowList[0] is MenuPanel || mdiCanvas.windowManager.windowList[1] is MenuPanel){
                //confirmMultiWin.enabled = true;
                app.multiWindowsOpenEnabled = true;
                
            }
        }else if(mdiCanvas.windowManager.windowList.length == 1){
            //confirmMultiWin.enabled = true;
            app.multiWindowsOpenEnabled = true;
        }    
    }else if(app.horizontalMenu){        
        if(mdiCanvas.windowManager.windowList.length == 1){
            app.multiWindowsOpenEnabled = true;
        }
    }
    queuedEvent=null;
    
}

private function cascadeWindows():void
{
    //switch (tabNavigator.selectedIndex)
    //{
        //case 0:
            //dashboardMdiCanvas.windowManager.cascade();
            //break;
        //case 1:
            mdiCanvas.windowManager.cascade();
            //break;
        //default:
            // do nothing
    //}
}

private function tileWindows():void
{
    //switch (tabNavigator.selectedIndex)
    //{
        //case 0:
            
            //dashboardMdiCanvas.windowManager.tile(false, Number(10))
            //break;
        //case 1:
            
            mdiCanvas.windowManager.tile(false, Number(10))
           // break;
        //default:
            // do nothing
    //}
}

public function openMenu():void{
    if(app.horizontalMenu){
        setupHRMenu();        
    }else{
        mdiCanvas.addWindow("navigation","Navigation",MenuPanel);
    }    
}
public function openCompMenu():void{
    //dashboardMdiFrame.openPanel(CompPanel, "components");
}
public function openCalc():void{
    mdiCanvas.addWindow("calculator","Calculator",CalculatorWindow);
}
public function navOpenHandler():void{
    
     //switch (tabNavigator.selectedIndex)
        //{
            //case 0:
                //openCompMenu();
                //break;
            //case 1:
                openMenu();
                //break;
            //default:
                // do nothing
        //}
}
private function buttonBarClick(event:ItemClickEvent):void
{
    switch (event.index) 
    {
        case 0:
            var dialog:ToolsDialog = PopUpManager.createPopUp(this, ToolsDialog, false) as ToolsDialog;
            PopUpManager.centerPopUp(dialog);
            break;
        case 1:
            toggle();
            break;
        case 2:
            //TabManager.openTab(ContactSummary, "ContactSummary");
            break;
        case 3:
            //TabManager.openTab(OpportunitySummary, "OpportunitySummary");
            break;
        case 4:
            //TabManager.openDashboard();
            break;
    }
}
private function toggle():void{ 
    if(stage.displayState == StageDisplayState.FULL_SCREEN){
        stage.displayState = StageDisplayState.NORMAL;
        
    }else{
        stage.displayState = StageDisplayState.FULL_SCREEN;
        
    }
}
private function loadDefaultStyles():void
{
   var event:IEventDispatcher = StyleManager.loadStyleDeclarations("assets/Default.swf",false,false,ApplicationDomain.currentDomain);
   event.addEventListener(StyleEvent.COMPLETE,changeAppState);
} 

private function doLogout():void {
    //Destroy LSO
    SharedObject.getLocal(Globals.LSO_USER,Globals.LSO_PATH).clear();
    var req : Object = new Object();
    req.unique = new Date().getTime() + "";
    logout.request = req;
    logout.send();
}

private function onResult(event:ResultEvent) : void {
            var url:String = "main.action?unique="+ new Date().getTime() +"";
            var request:URLRequest = new URLRequest(url);
            request.method = "POST";
            try {
                navigateToURL(request,"_top");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            }
}

private function onFault(event:FaultEvent) : void {
    trace(event);
    XenosAlert.error("Error while logging out."+event.fault.faultString);
}

/**
 * This method loads all the resource bundles needed for the application 
 * 
 */
public function loadResourceManager():void{
    xResourceManager = new XResourceManager();
    xResourceManager.localeChain = ["en_US"]; //By Default en_US loading    

    this.addEventListener("COMPLETE", updateHandler);
    var resource : XenosResourceBundle = new XenosResourceBundle(xResourceManager,this);
    resource.loadXenosResourceBundle();
    
} 

/**
 * This method gets the values from the core Resource Bundle when its load completes.
 * 
 * @param event 
 * 
 */
private function updateHandler(event:Event):void{
    this.invalidateDisplayList();
    this.validateNow();
    //Update the component from the values loaded from the resources.                  
    lblProject.text = xResourceManager.getKeyValue('core.project.name');
    
    this.removeEventListener("COMPLETE", updateHandler);
}

 

private function showPreference():void{
    preference = new PreferenceDialog();
       var SPACING_X : int = 0;
    var SPACING_Y : int = 0;    
    var rect:Rectangle = btnPrefernces.getRect(btnPrefernces);
    var pt:Point = btnPrefernces.localToGlobal(rect.bottomRight);            
    preference.x=pt.x - preference.width;
    preference.y=appCtrlBar.y + appCtrlBar.height + SPACING_Y;        
    this.preference.alpha=1;
    preference.mdiParent=this.mdiCanvas;
    preference.ConfirmMultipleWindowsEnabled=this.bconfirmMultiWinEnabled;
    preference.addEventListener("confirmationClick",confirmClose_clickHandler);
    preference.addEventListener("confirmMultipleWindowClick",multipleWindowOpen_clickHandler);
    preference.addEventListener(Globals.EVENT_MENU_ORIENTATION, hrVrMenu_clickHandler);
    preference.addEventListener(CloseEvent.CLOSE,preferenceWindowClose_handler);
    PopUpManager.addPopUp(this.preference,this,false);
    btnPrefernces.enabled=false;
}

private function preferenceWindowClose_handler(evt:CloseEvent):void{
    PopUpManager.removePopUp(preference);
    this.btnPrefernces.enabled=true;    
}


private function confirmClose_clickHandler(evt:Event):void{
    this.bConfirmCloseStatus=this.preference.ConfirmCloseStatus;
    this.setConfirmWindowClose();
}

private function multipleWindowOpen_clickHandler(evt:Event):void{
    this.bConfirmMultipleWindowOpenStatus=this.preference.ConfirmMultipleWindowsOpenStatus;
    this.setMultipleWindows();
}

//---------- This part has been added for change password window ---------\\

 private function showChangePasswdWindow():void{
    chngPasswdDialog = new ChangePasswordDialog();
    //var SPACING_X : int = 0;
    //var SPACING_Y : int = 0;    
    //var rect:Rectangle = btnChangePasswd.getRect(btnChangePasswd);
    //var pt:Point = btnChangePasswd.localToGlobal(rect.bottomRight);            
    /* chngPasswdDialog.x=pt.x - chngPasswdDialog.width;
    chngPasswdDialog.y=appCtrlBar.y + appCtrlBar.height + SPACING_Y;   */      
    this.chngPasswdDialog.alpha=1;
    PopUpManager.addPopUp(this.chngPasswdDialog,this,true);
    PopUpManager.centerPopUp(this.chngPasswdDialog);
    btnChangePasswd.enabled=false;
} 


// -----------------------------####--START--####---------------------------------
// Menu(Horizontal) related methods

/**
 * Event(MenuOrientationChanged) Handler generated from Menu Orientation of the Preference window.
 * Depending on the value of the of the "app.horizontalMenu" this method will open/close the 
 * Horizontal/Vertical Menu.
 */
private function hrVrMenu_clickHandler(evt:Event):void{    
    if(app.horizontalMenu){
        hrMenu.includeInLayout = true;
        hrMenu.visible = true;
        
        navOpener.enabled = false;
        
        var menu : XenosMDIWindow = CoreUtils.getWindow(mdiCanvas,"navigation");              //getMenuWindow("navigation");
        if(menu!= null){
            menu.close();
        }
        //Handle the multiWindowsOpenEnabled
        if(mdiCanvas.windowManager.windowList.length > 0 ){         
            app.multiWindowsOpenEnabled = false;
        }else{
            app.multiWindowsOpenEnabled = true;
        }
        
    }else{
        hrMenu.includeInLayout = false;
        hrMenu.visible = false;
        navOpener.enabled = true;
        openMenu();
        //Handle the multiWindowsOpenEnabled
        if(mdiCanvas.windowManager.windowList.length > 1 ){         
            app.multiWindowsOpenEnabled = false;
        }else{
            app.multiWindowsOpenEnabled = true;
        }
    }
}
/**
 * SetUp data for the menu if it is already not available.
 */
private function setupHRMenu():void{    
    //A httpService needs to send if the cache for the menu is already not available.   
    if(app.cachedItems.menuList == null || app.cachedItems.ccyList == null) {
        navHr.send();
        ccyRequest.send();
        instrumentRequest.send();
        bbInstrumentRequest.send();
        marketRequest.send();
        retentionDateRequest.send();
    }    
    //Disable the navigation opening button
    navOpener.enabled = false;
}
/**
 * Result Handler for the navHr HttpService
 */
public function resultHandler(event:ResultEvent):void {
                
    var httpService:HTTPService = event.target as HTTPService;
    data = event.result as XML;
    
    app.cachedItems.menuList  = data.child(Globals.MENU_NODE);
//    app.cachedItems.ccyList = data.child(Globals.CCY_NODE);
//    app.cachedItems.instrumentTree = data.child(Globals.INSTR_NODE);
//    app.cachedItems.marketTree = data.child(Globals.MARKET_NODE);
    
    httpService.removeEventListener(ResultEvent.RESULT,resultHandler);     
    
    //Set the focus on Horizontal menu
    focusManager.setFocus(hrMenu);
}

    /**
     * Result Handler for the navHr HttpService
     */
    public function displayUserInfo(event:ResultEvent):void {
       
       this.userName = event.result.userInfoActionForm.userName;
       ///This part has been added to display password warning notice///
       if ((event.result.userInfoActionForm.dispMsg != null) ||
                       (StringUtil.trim(event.result.userInfoActionForm.dispMsg) != "")) {
               XenosAlert.confirm(event.result.userInfoActionForm.dispMsg,handleChngPasswdDecesion);
       }
       
    }
    
    /**
    * function to handle the decesion of the user whether to change password or not.
    */
    private function handleChngPasswdDecesion(event:CloseEvent){
        if (event.detail == Alert.YES) {
            showChangePasswdWindow();
        }
    }
    
    private function onFaultUserInfo(event:FaultEvent) : void {
    trace(event);
    XenosAlert.error("Error while retrieving user id: "+event.fault.faultString);
    }

public function ccyResultHandler(event:ResultEvent):void {
                
    var httpService:HTTPService = event.target as HTTPService;
    data = event.result as XML;

    app.cachedItems.ccyList = data.child(Globals.CCY_NODE);    
    httpService.removeEventListener(ResultEvent.RESULT,ccyResultHandler);     
    
    //Set the focus on Horizontal menu
    focusManager.setFocus(hrMenu);
}


public function instruResultHandler(event:ResultEvent):void {
                
    var httpService:HTTPService = event.target as HTTPService;
    data = event.result as XML;

    app.cachedItems.instrumentTree = data.child(Globals.INSTR_NODE);   
    httpService.removeEventListener(ResultEvent.RESULT,instruResultHandler);     
    
    //Set the focus on Horizontal menu
    focusManager.setFocus(hrMenu);
}

public function bbInstrumentResultHandler(event:ResultEvent):void {
                
    var httpService:HTTPService = event.target as HTTPService;
    data = event.result as XML;

    app.cachedItems.bbInstrumentTree = data.child(Globals.BB_INSTR_NODE);   
    httpService.removeEventListener(ResultEvent.RESULT, bbInstrumentResultHandler);     
    
    //Set the focus on Horizontal menu
    focusManager.setFocus(hrMenu);
}

public function marketResultHandler(event:ResultEvent):void {
                
    var httpService:HTTPService = event.target as HTTPService;
    data = event.result as XML;

    app.cachedItems.marketTree = data.child(Globals.MARKET_NODE);   
    httpService.removeEventListener(ResultEvent.RESULT,marketResultHandler);     
    
    //Set the focus on Horizontal menu
    focusManager.setFocus(hrMenu);
}

public function retentionDateResultHandler(event:ResultEvent):void {
                
    var httpService:HTTPService = event.target as HTTPService;
    data = event.result as XML;

    app.cachedItems.retentionDates = data.child(Globals.RETENTION_DATES_NODE);   
    httpService.removeEventListener(ResultEvent.RESULT, retentionDateResultHandler);     
    
    //Set the focus on Horizontal menu
    focusManager.setFocus(hrMenu);
}

/**
 * Fault Handler for the navHr HttpService
 */
public function faultHandler(event:FaultEvent):void {
    
    XenosAlert.error("Failed to load navigation menu.");
}
/**
 * Label Function for the MenuBar
 */
public function fixLabel(item:XML):String {
    return unescape(item.@label);
}
// Event handler for the MenuBar control's change event.
private function changeHandler(event:MenuEvent):void  {
    // Only open a Window for a selection in a pop-up submenu.
    // The MenuEvent.menu property is null for a change event 
    // dispatched by the menu bar.
    
    if (event.menu != null) {    	    	
        /*Alert.show("Label: " + event.item.@label + "\n" + 
            "compName: " + event.item.@comp+ "\n" + 
            "url: " + event.item.@url+ "\n" + 
            "title: " + event.item.@title, "Clicked menu item");*/
                      
	        //HttpService Call
		    var httpService : XenosHTTPService = new XenosHTTPService();        
		    httpService.url="screenClosing.action?menuPk="+event.item.@pk;		  
		    httpService.addEventListener(ResultEvent.RESULT , 
			function (resultEvent : ResultEvent) : void {
				 // If No error Then
				 //	XenosAlert.info("Result alert1:: "+ resultEvent.result.pageSummary.status);
				 if(!XenosStringUtils.equals(StringUtil.trim(resultEvent.result.XenosErrors.pageSummary.status),'Y')){        							 
						var compName:String = event.item.@comp ;
						var url:String = event.item.@url;
						var title:String = event.item.@title;       
						var menuPk:String = event.item.@pk; 
						//Open a Window for the menu item clicked/Selected						
						mdiCanvas.addWindow(compName,title,ModulePanelLoader,url,menuPk);
				 }
				 else{ 										 	  	 
				      mdiCanvas.addWindow("test","",ModulePanelLoader,"assets/appl/ref/IllegalScreenAccess.swf?messageStr="+resultEvent.result.XenosErrors.Errors.error,"47437437843");
				 }
			 });
            httpService.send();
    }
}    
/**
 * Enter Key handler for the MenuBar
 */
public function enterHandler(event:KeyboardEvent):void {
    if(event.keyCode == Keyboard.ENTER)
    {
        // Do Nothing
    }
}

// -----------------------------####--END--####---------------------------------    
                       
