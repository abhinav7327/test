                        
import com.nri.rui.core.Globals;
import mx.collections.ArrayCollection;
import mx.rpc.events.FaultEvent;
import com.nri.rui.core.controls.XenosHTTPService;
import mx.rpc.events.ResultEvent;
import com.nri.rui.core.controls.CustomChangeEvent;
import com.nri.rui.core.controls.TreeCombo;
import flash.utils.getQualifiedClassName;
import flash.utils.getDefinitionByName;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.WizardPage;
import com.nri.rui.core.controls.CustomChangeEvent;

import mx.events.ChildExistenceChangedEvent;
import mx.events.IndexChangedEvent;
import mx.events.FlexEvent;
import mx.resources.ResourceBundle;
import mx.core.Application;
import mx.logging.ILogger;
import com.nri.rui.core.logging.XenosLogImpl;

import flash.utils.getDefinitionByName;

import mx.collections.ArrayCollection;
import mx.core.Application;
import mx.events.ChildExistenceChangedEvent;
import mx.events.IndexChangedEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import com.nri.rui.core.utils.XenosStringUtils;
            
		[Bindable]public var submitResult:XML;
		[Bindable]private var urlModeBind:String="";
		[Bindable] private var method:String;
		
		private var noOfLoadedClasses:int = 0;
		private var childsArray:Array = new Array();
		private var populateTabsRequest:XenosHTTPService = new XenosHTTPService();
		public var log : XenosLogImpl = XenosLogImpl.getLog("Entry.mxml");
		
		[Bindable]
		private var mode: String = "ENTRY" ;
		
		private var tradePk : String = "" ;
		
		private var terminationMode : Boolean = false ;

		private function init() : void {
			parseLoaderUrl();
			
			if (XenosStringUtils.equals(mode , "AMEND") 
			     || XenosStringUtils.equals(mode , "amend") ) {
			    wizard.viewStackInstance.addEventListener(ChildExistenceChangedEvent.CHILD_ADD, childAdded);
			}
			
			
			
			if (terminationMode) {
				wizard.initUrl = "swp/swpTrade" + urlModeBind + "Dispatch.action?method=" 
							+ method + "&modeOfOperation=TERMINATION"
							+ "&tradePk=" + tradePk
							+ "&SCREEN_KEY = 12031";
			} else {
				wizard.initUrl = "swp/swpTrade" + urlModeBind + "Dispatch.action?method=" 
							+ method + "&modeOfOperation=" + mode
							+ "&tradePk=" + tradePk
							+ "&SCREEN_KEY = 12031";
			}
							
			load();
			
			if (!XenosStringUtils.equals(mode , "CANCEL")) {
				registerClassAlias("GeneralTab", GeneralTab);
				registerClassAlias("DeliverTab", DeliverTab);	
				registerClassAlias("ReceiveTab", ReceiveTab);
			} else {
				confirmTab.confirmInitXML = wizard.submitResult;		
			    confirmTab.dispatchEvent(new CustomChangeEvent("visibleTabsEvent",wizard.visibleTabs));	
				vstack.selectedIndex = 1 ;
			}
			addEventListener("confirmOk",confirmOkHandler);
			log.info("wizard.initUrl - {0}", [wizard.initUrl]);
		}
		
		/**
         * Event handler for ChildExistenceChangedEvent.CHILD_ADD event.
         */
        public function childAdded(event:ChildExistenceChangedEvent):void {
            trace("childAdded ::" + wizard.viewStackInstance.numChildren);
            wizard.trailArray.push(WizardPage(wizard.viewStackInstance.getChildAt(wizard.viewStackInstance.numChildren - 1)).shortTitle);
            trace("trailArray ::" + wizard.trailArray);
            trace("trailArray.length ::" + wizard.trailArray.length);
            wizard.buttonBar.dataProvider = wizard.trailArray;
        }

		private function confirmOkHandler(event:CustomChangeEvent) : void {
			if (XenosStringUtils.equals(mode , "AMEND") || XenosStringUtils.equals(mode , "amend") 
				|| XenosStringUtils.equals(mode , "CANCEL") || XenosStringUtils.equals(mode , "TERMINATION") ) {
				parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
			} else {
				vstack.selectedIndex = 0;
				wizard.dispatchEvent(new Event("entryConfirmOk"));
			}
		}
 
		private function load() : void {
		    var rndNo:int = Math.random();
			populateTabsRequest.url = "swp/swpTrade" + urlModeBind + "Dispatch.action?method=loadTab&rnd=" + rndNo;
			 
			populateTabsRequest.addEventListener(FaultEvent.FAULT, handleError);
			populateTabsRequest.addEventListener(ResultEvent.RESULT, handleResult);
			populateTabsRequest.showBusyCursor = true;
			populateTabsRequest.resultFormat = "xml";
			populateTabsRequest.method = "POST";
			var reqObj:Object = new Object();
			reqObj["modeOfOperation"] = mode ;
			populateTabsRequest.request = reqObj;
			populateTabsRequest.send();
		}

		private function handleResult(event:ResultEvent):void {
			var rs:XML = XML(event.result);
			if(rs.child("Errors").length() > 0) {
			    var errorInfoList : ArrayCollection = new ArrayCollection();
			    //populate the error info list              
			    for each ( var error:XML in rs.Errors.error ) {
			       errorInfoList.addItem(error.toString());
			    }
			    wizard.errPage.showError(errorInfoList);
			 } else {
                wizard.populateVisibleTabs(rs);
                populateTabs();
			}
		}

		private function handleError(event:FaultEvent):void {
		    XenosAlert.error(Application.application.xResourceManager.getKeyValue('ref.msg.common.info.errorfaultstr', 
		    				 new Array(event.fault.faultDetail)));
		}

		public function populateTabs() : void {
			 var tabArray:Array = wizard.visibleTabs;
			 var indx:int = 0;
			 log.info("tabArray.length - {0}", [tabArray.length]);
			 if(tabArray.length != 0){
			     for (var count:int = 0; count < tabArray.length; count++) {
			         var obj:Object = tabArray[count];
			         var dispObjClass:Class =  getDefinitionByName(obj['label'].toString()) as Class;
			         var myInstance:Object = new dispObjClass();
			         wizard.viewStackInstance.addChild(WizardPage(myInstance));
			     }
			 }
			 wizard.dispatchEvent(new Event("moduleCreationComplete"));
		}

           
		private function doViewStackChange(event:IndexChangedEvent):void {
		    if(event.newIndex == 1) {
		       confirmTab.confirmInitXML = wizard.submitResult;		
			   confirmTab.dispatchEvent(new CustomChangeEvent("visibleTabsEvent",wizard.visibleTabs));	
		    }
		}

		public function parseLoaderUrl() : void {
		    try {
			    var myPattern:RegExp = /.*\?/; 
			    var s:String = this.loaderInfo.url.toString();
			    
			    s = s.replace(myPattern, "");
			    var params:Array = s.split(Globals.AND_SIGN); 
			   
			    if(params != null){
				    for (var i:int = 0; i < params.length; i++) {
		                var temp:Array = params[i].split("=");  
		                if(temp[0] == "method"){
		                	this.method = temp[1];
		                } 
		                if (temp[0] == "modeOfOperation") {
		                	mode =  temp[1];
		                }
		                if (temp[0] == "tradePk") {
		                	tradePk = temp[1];
		                }
		                if (temp[0] == "termination") {
		                	if (temp[1] == "true") {
		                		terminationMode = true;
		                	}
		                }
				    }                    	
			    }
			    //XenosAlert.info("Mode : " + mode);
			    if (XenosStringUtils.equals(mode , "ENTRY")) {
			    	 urlModeBind = "Entry" ;
			    	 wizard.mode = "ENTRY";
			    } else if (XenosStringUtils.equals(mode , "AMEND") || XenosStringUtils.equals(mode , "amend")) {
			    	 urlModeBind = terminationMode ? "Termination" : "Amend" ;
			    	 wizard.mode = "amend";
			    	 wizard.viewMode  = "amend";
			    } else if (XenosStringUtils.equals(mode , "CANCEL")) {
			    	 wizard.mode = "cancel";
			    	 urlModeBind = "Cancel" ;
			    } /* else if (XenosStringUtils.equals(mode , "TERMINATION")) {
			    	 urlModeBind = "Termination" ;
			    	 wizard.mode = "amend";
			    	 wizard.viewMode  = "amend";
			    } */
			    
			    confirmTab.restoreXmlRequest.url = "swp/swpTrade"+urlModeBind+"Dispatch.action?method=submitConfirm"+"&SCREEN_KEY = 12036";
			
		        wizard.submitUrl="swp/swpTrade"+urlModeBind+"Dispatch.action?method=submitEntry"+"&SCREEN_KEY = 12033";
			    wizard.switchTabUrl="swp/swpTrade"+urlModeBind+"Dispatch.action?method=switchEntryTab"+"&SCREEN_KEY = 12031";
			    wizard.resetUrl="swp/swpTrade"+urlModeBind+"Dispatch.action?method=resetEntryPage"+"&SCREEN_KEY = 12031";;
			
			    confirmTab.urlModeBind = urlModeBind;
				
			} catch (e:Error) {
			    trace(e);
			}
		}