/*

$LastChangedDate$
$Author: sumanb $
*/
package com.nri.rui.core.popups
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.controls.XenosButton;
    import com.nri.rui.core.controls.XenosHTTPService;
    import com.nri.rui.core.utils.*;
    
    import mx.collections.ArrayCollection;
    import mx.controls.TextInput;
    import mx.managers.PopUpManager;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.utils.StringUtil;
    
    import com.nri.rui.core.controls.XenosPopup;

   // public class XPopUp extends TitleWindow
    public class XPopUp extends XenosPopup
    {
         public var emptyResult:ArrayCollection= new ArrayCollection();;
         public var rndNo:Number;

         [Bindable]
         public var newuri:String;
         [Bindable]
         public var mapping:String;
         [Bindable]
         public var reseturi:String;
         [Bindable]
         public var initColl:ArrayCollection;
         [Bindable]
         public var summaryResult:ArrayCollection = new ArrayCollection();
         [Bindable]
         public var summaryStateResult:ArrayCollection = new ArrayCollection();
		 [Bindable]
         public var bankCode : TextInput = null;
         [Bindable]
         public var bankName : TextInput = null;
         [Bindable]
         // A reference to the TextInput control in which to put the result.
         //public var retTxtInput:AutoComplete;
         public var retTxtInput:TextInput;
         
         [Bindable]
         //Items receiveing through context - Non display objects
         public var receiveCtxItems:ArrayCollection;
         [Bindable]
         //Items returning through context - Non display objects
         public var returnContextItems:ArrayCollection;
         
         private var myStyleSheet : String = "PopupTitleWindow";
         
         [Bindable]
         public var returnDefaultBtn : XenosButton = null;
         
         //Some Http Service
         public var popUpContainer : XenosHTTPService;
         public var popUpQueryPage : XenosHTTPService;
         [Bindable]
         public var popUpQueryRequest : XenosHTTPService;
         public var popUpQueryDoNext : XenosHTTPService;
         public var popUpQueryDoPrevious : XenosHTTPService;
         public var popUpResetQuery : XenosHTTPService;
         //Some Http Service
         
        
        //Constructor
        public function XPopUp()
        {
            super();
            if(receiveCtxItems != null && receiveCtxItems.length > 0)
            {
	            receiveCtxItems.removeAll();
	            receiveCtxItems = new ArrayCollection();
            }
            this.styleName= myStyleSheet;
            this.showCloseButton=true;
            this.returnDefaultBtn = app.submitButtonInstance;
           // trace("constructor .. : "+ this.returnDefaultBtn.id);
            //Initializeing popup container
            this.popUpContainer = new XenosHTTPService();
            popUpContainer.addEventListener("result", initPopupContainer);
            popUpContainer.addEventListener("fault", showErrorMessage);   
            popUpContainer.showBusyCursor=true;
            popUpContainer.useProxy=false;    
            
            this.popUpQueryPage = new XenosHTTPService();
            popUpQueryPage.addEventListener("result", populatePopUpQueryPage);
            popUpQueryPage.addEventListener("fault", showErrorMessage);   
            popUpQueryPage.showBusyCursor=true;
            popUpQueryPage.useProxy=false;
            this.popUpQueryPage.method="POST";
            
            this.popUpQueryDoNext = new XenosHTTPService();
            popUpQueryDoNext.addEventListener("result", populatePopUpQuerySummaryPage);
            popUpQueryDoNext.addEventListener("fault", showErrorMessage);   
            popUpQueryDoNext.showBusyCursor=true;
            popUpQueryDoNext.useProxy=false;
            
            this.popUpQueryDoPrevious = new XenosHTTPService();
            popUpQueryDoPrevious.addEventListener("result", populatePopUpQuerySummaryPage);
            popUpQueryDoPrevious.addEventListener("fault", showErrorMessage);   
            popUpQueryDoPrevious.showBusyCursor=true;
            popUpQueryDoPrevious.useProxy=false;
            
            this.popUpResetQuery = new XenosHTTPService();
            popUpResetQuery.addEventListener("result", populatePopUpResetQueryPage);
            popUpResetQuery.addEventListener("fault", showErrorMessage);   
            popUpResetQuery.showBusyCursor=true;
            popUpResetQuery.useProxy=false;
			
        }
        
        public virtual function populatePopUpQuerySummaryPage(event:ResultEvent):void {
            
        }
        /**
          * This API is handleing the account query page initialization Http service.
          * @param ResultEvent the result set event object.
          */
        public virtual function populatePopUpQueryPage(event: ResultEvent) : void{
            
        }
        /**
          * Called by the close event raised byclicking the close button.
          * This will close the popup window.
          */
        private function showErrorMessage(event: FaultEvent):void {
           var faultstring:String = event.fault.faultString;
           XenosAlert.error('Error Occured :  ' + faultstring );
           //XenosAlert.error(event.fault.faultDetail);
        }
        
        /**
          * Called by the close event raised byclicking the close button.
          * This will close the popup window.
          */
        public function closeWindow():void {
        	app.submitButtonInstance = returnDefaultBtn;
        	//trace("button id .. "+returnDefaultBtn.id);
           PopUpManager.removePopUp(this);
        }
        
        /**
          * This will prepare the passing context according to the server side 
          * requriment. The server side format is as follows:
          * field: <code>invCPTypeContext<code>
          * value:<code>INTERNAL|CLIENT<code>
          * The <code>receiveCtxItems<code>hold the data as object of HiddenObject
          * type. This API prepare the information as requried by server side object.
          * @see xenos.utils.HiddenObject
          */   
        protected function getReceiveContext():String {

            var dStr:String ="";
            if (receiveCtxItems != null){

                for (var i:int = 0; i<receiveCtxItems.length; i++) {
                //XenosAlert.info("index :: "+ i);
                var itemObject:HiddenObject;
                var originalStr:String;
                var newStr:String;
                var objVal:String;

                itemObject = HiddenObject (receiveCtxItems.getItemAt(i));

                // store original value
                originalStr = itemObject.m_propertyName;
                
                // Replace . with 9 and store into a new var.
                //As java try to resolve anything before  a dot[.] as object
                newStr = originalStr.replace(/\./gi,"9");   
                // Replace [ with 8 and store into a new var.
                // As java try to resolve anything before  a dot[.] as object
                newStr = newStr.replace(/\[/gi,"8");
                // Replace ] with 7 and store into a new var.
                // As java try to resolve anything before  a dot[.] as object
                newStr = newStr.replace(/\]/gi,"7");

                var propertyValues:Array = itemObject.m_propertyValues;

                    for (var j:int = 0; j<propertyValues.length; j++){

                        if (j==0){
                            objVal = propertyValues[j];
                        } else {
                            objVal += "|" + propertyValues[j];
                        }

                    }//end of inner for loop

                dStr+="&dependents("+newStr+")="+objVal;
                }//end of outer for loop
            }   

         return dStr;
        }
        
        /**
         * Submit the account query page.
         */
        public function submitQuery():void { 
            popUpQueryRequest.url=mapping + "?method=submitQuery&unique=" + new Date().getTime() + ""; 
            popUpQueryRequest.send();
        } 
        /**
         * Reset the account query page. 
         */
        public function resetQuery():void { 
           rndNo= Math.random();
           popUpQueryPage.url = mapping + "?method=resetQuery&rnd="+ rndNo;
           popUpQueryPage.send();
           //clearResultPage();

        }
        
        /**
         *  Traverse the previous result page
         */
        public function doPrevious():void {
        	 rndNo= Math.random();
            popUpQueryDoPrevious.url=mapping + "?method=doPrevious&rnd="+ rndNo;
            popUpQueryDoPrevious.send();
        }
        /**
         *  Traverse the next result page
         */
        public function doNext():void {
        	rndNo= Math.random();
            popUpQueryDoNext.url=mapping + "?method=doNext&rnd="+ rndNo;
            popUpQueryDoNext.send();
        } 
        
        /**
         * Initalize the account popup container
         */
        public function initPopup():void {
            popUpContainer.url = mapping + "?unique=" + new Date().getTime() + "&method=load"+getReceiveContext();
            //XenosAlert.info(popUpContainer.url);
            popUpContainer.send();
        }
        /**
         * Initalize the gle popup container
         */
        public function initGlePopup():void {
            popUpContainer.url = mapping + "?method=load&mode=popupquery&unique=" + new Date().getTime() + "";
            
            popUpContainer.send();
        }
       /**
         * Initalize the ssi info popup container
         */
        public function initSsiInfoPopup():void {
            popUpQueryRequest.url = mapping + "?method=doInit&mode=popupquery&unique=" + new Date().getTime() + ""+getReceiveContext();
            
            popUpQueryRequest.send();
        }
        /**
          * This API is handleing the popup initialization Http service.
          * @param ResultEvent the result set event object.
          * @see initPopUpPage.
          */
        private function initPopupContainer(event: ResultEvent):void {
        	
        	var reseturl:String;
        	newuri = event.result.popupSearchLoaderBean.action as String;
	        newuri = StringUtil.trim(newuri);
	        reseturi = event.result.popupSearchLoaderBean.requestURI as String;
	        
	        if(reseturi.indexOf("ref") != -1)
            	reseturl = reseturi.substr(reseturi.indexOf("ref",0),reseturi.length);
            else if(reseturi.indexOf("gle") != -1)
            	reseturl = reseturi.substr(reseturi.indexOf("gle",0),reseturi.length);
        	else if(reseturi.indexOf("cax") != -1)
            	reseturl = reseturi.substr(reseturi.indexOf("cax",0),reseturi.length);
            else if(reseturi.indexOf("stl") != -1)
            	reseturl = reseturi.substr(reseturi.indexOf("stl",0),reseturi.length);
            else if(reseturi.indexOf("swp") != -1)
                reseturl = reseturi.substr(reseturi.indexOf("swp",0),reseturi.length);	
            	
            popUpResetQuery.url = reseturl + "&unique=" + new Date().getTime() + "";
            popUpResetQuery.send();
	        
        }
        
        /**
          * This API is handleing the popup Reset Http service. If Reset service returns 
          * success then call load method.
          * @param ResultEvent the result set event object.
          * @see initPopUpPage.
          */
        private function populatePopUpResetQueryPage(event: ResultEvent):void {
        	
        	if (null != event) { 
        		var acturi:String;
        		rndNo= Math.random();
        		if(newuri.indexOf("ref") != -1)
            		acturi = newuri.substr(newuri.indexOf("ref",0),newuri.length);
            	else if(newuri.indexOf("gle") != -1)
            		acturi = newuri.substr(newuri.indexOf("gle",0),newuri.length);
            	else if(newuri.indexOf("cax") != -1)
            		acturi = newuri.substr(newuri.indexOf("cax",0),newuri.length);
	        	else if(newuri.indexOf("stl") != -1)
            		acturi = newuri.substr(newuri.indexOf("stl",0),newuri.length);
            	else if(newuri.indexOf("swp") != -1)
                    acturi = newuri.substr(newuri.indexOf("swp",0),newuri.length);	
            	
	        	popUpQueryPage.url = acturi+"&rnd="+ rndNo;
	        	popUpQueryPage.send();   
        	}
        	else {
        		XenosAlert.info("No Results Found");
        	}
	        
        }
                
        /**
         * Initalize the account query page Http service.
         */     
        private function initGlePopUpPage():void {

            var acturi:String
            rndNo= Math.random();
            acturi = newuri.substr(newuri.indexOf("gle",0),
            newuri.length);
	        popUpQueryPage.url = acturi+"&rnd="+ rndNo;
           // XenosAlert.info(popUpQueryPage.url);
            popUpQueryPage.send();        

        }
        
        /**
         * Initalize the state popup container
         */
        public function initStatePopup():void {
            popUpContainer.url = mapping + "?unique=" + new Date().getTime() + "&method=loadContainer"+getReceiveContext();
            //XenosAlert.info(popUpContainer.url);
            popUpContainer.send();
        }
        
    }
    
}