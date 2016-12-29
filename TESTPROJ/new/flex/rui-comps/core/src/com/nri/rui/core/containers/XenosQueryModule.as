




package com.nri.rui.core.containers
{
    import com.nri.rui.core.controls.CustomDataGrid;
    import com.nri.rui.core.controls.XenosAdvancedDataGrid;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.controls.XenosHTTPService;
    import com.nri.rui.core.controls.XenosQuery;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.navigateToURL;
    import flash.net.URLVariables;
    
    import mx.collections.Sort;
    import mx.controls.AdvancedDataGrid;
    import mx.controls.DataGrid;
    import mx.core.UIComponent;
    import mx.events.ModuleEvent;
    import mx.modules.Module;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.validators.Validator;

    /**
     * 
     * @author krishnendur
     * 
     */
    public class XenosQueryModule extends Module implements IXenosQueryModule
    {
        private var _xenosQueryControl:XenosQuery = null;
        
        private var _serviceArray : Array = new Array(3);
        
        protected var _validator : Validator = null;
        
        private var _modeOfOperation:String = "query";
        
      // public var statesEle : Array = null;
       
       //public var transitionsEle:Array = null;
       
        private var _resultEvent:Array = new Array(3);
        
        /**
         * Stores the current event 
         */
        private var _currentEvent:Event = null;
        /**
         * Stores the Sorted fields on the supplied DataGrid.
         */
        private var _sortFieldsArray:Array;
        /**
         * Stores the DataGrid component for client sorting operation.
         */
        private var _dataGridComp:UIComponent = null;
       
        public function XenosQueryModule()
        {
            super();
            //statesEle = super.states;
            //transitionsEle = super.transitions;
            this.addEventListener("queryInit",doQueryInit);
            this.addEventListener("queryReset",doResetQuery);
            this.addEventListener("querySubmit",doQuery);
            this.addEventListener("querySubmitRefresh",doQueryRefresh);
            this.addEventListener("amendInit",doAmendInit);
            this.addEventListener("amendReset",doResetAmend);
            this.addEventListener("amendSubmit",doAmend);
            this.addEventListener("amendSubmitRefresh",doAmendQryRefresh);
            this.addEventListener("cancelInit",doCancelInit);
            this.addEventListener("cancelReset",doResetCancel);
            this.addEventListener("cancelSubmit",doCancel);
            this.addEventListener("cancelSubmitRefresh",doCancelQryRefresh);
            
            
            /**
            * Registers an event listener object with an EventDispatcher object 
            * Dispatched Event: reopenInit
            * Listener Function: doReopenInit
            */
            this.addEventListener("reopenInit",doReopenInit);
            this.addEventListener("reopenReset",doResetReopen);
            this.addEventListener("reopenSubmit",doReopen);
            
            this.addEventListener("prev",doPrevious);
            this.addEventListener("next",doNext);
            this.addEventListener("pdf",generatePdf);
            this.addEventListener("xls",generateXls);
            this.addEventListener("prient",doPrint);
            this.addEventListener(ModuleEvent.UNLOAD,destroyModule);
        }
        
        /**
         * 
         */
        public function setXenosQueryControl(xenosQuery:XenosQuery):void{
            _xenosQueryControl = xenosQuery;
        }
        
        
        
        public function getInitHttpService():XenosHTTPService{
            return _serviceArray[0];
        }
        
        public function getResetHttpService():XenosHTTPService{
            return _serviceArray[2];
        }
        
        public function getSubmitQueryHttpService():XenosHTTPService{
            return _serviceArray[1];
        }
        public function getInitResultEvent():ResultEvent{
            return _resultEvent[0];
        }
        
        public function getSubmitQueryResultEvent():ResultEvent{
            return _resultEvent[1];
        }
        public function set sortFieldsArray(sortFldsArr:Array):void{
            _sortFieldsArray = sortFldsArr;
        }
        public function get sortFieldsArray():Array{
            return _sortFieldsArray;
        }
        public function set dataGridComp(dataGrid:UIComponent):void{
            _dataGridComp = dataGrid;
        }
        public function get dataGridComp():UIComponent{
            return _dataGridComp;
        }        
        public function preQueryInit():void
        {
            
        }
        public function doQueryInit(event:Event):void
        {
            _currentEvent = event;
            _modeOfOperation = "query";
            _serviceArray[0] = new XenosHTTPService();
            
            (_serviceArray[0] as XenosHTTPService).addEventListener(ResultEvent.RESULT,doQueryResultInit);
            
            (_serviceArray[0] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
            
            preQueryInit();
            
            (_serviceArray[0] as XenosHTTPService).resultFormat = "xml";
            
            try{
               _xenosQueryControl.setInitService(_serviceArray[0]);
            
               _xenosQueryControl.intialExecute();
            }catch(e:Error){
                XenosAlert.error(e.message);
            }
            
            postQueryInit();
            
        }
        
        
        public function postQueryInit():void
        {
        }
        
        public function preAmendInit():void
        {
            
        }
        
        public function doAmendInit(event:Event):void
        {
            _currentEvent = event;
            _modeOfOperation = "amend";
            _serviceArray[0] = new XenosHTTPService();
            
            (_serviceArray[0] as XenosHTTPService).addEventListener(ResultEvent.RESULT,doAmendResultInit);
            
            (_serviceArray[0] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
            
            preAmendInit();
            
            (_serviceArray[0] as XenosHTTPService).resultFormat = "xml";
                        
            try{
                _xenosQueryControl.setInitService(_serviceArray[0]);
            
                _xenosQueryControl.intialExecute();
            }catch(e:Error){
                XenosAlert.error(e.message);
            }
            
            postAmendInit();
        }
        
        public function postAmendInit():void
        {
        }
        
        public function preCancelInit():void
        {
        }
        
        public function doCancelInit(event:Event):void
        {
            _currentEvent = event;
            _modeOfOperation = "cancel";
            _serviceArray[0] = new XenosHTTPService();
            
            (_serviceArray[0] as XenosHTTPService).addEventListener(ResultEvent.RESULT,doCancelResultInit);
            
            (_serviceArray[0] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
            
            preCancelInit();
            
            (_serviceArray[0] as XenosHTTPService).resultFormat = "xml";
            
            try{
                _xenosQueryControl.setInitService(_serviceArray[0]);
            
                _xenosQueryControl.intialExecute();
            }catch(e:Error){
                XenosAlert.error(e.message);
            }
            
            postCancelInit();
        }
        
        /**
         * This Method is usually overridden by the sub-classses to create a new XenosHTTPService
         * 
         */
        public function preReopenInit():void
        {
        }
        public function doReopenInit(event:Event):void
        {    
            _currentEvent = event; 
            _modeOfOperation = "reopen";
            _serviceArray[0] = new XenosHTTPService();
            
            (_serviceArray[0] as XenosHTTPService).addEventListener(ResultEvent.RESULT,doReopenResultInit);
            
            (_serviceArray[0] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
            
            preReopenInit();
            
            (_serviceArray[0] as XenosHTTPService).resultFormat = "xml";
            
            try{
                _xenosQueryControl.setInitService(_serviceArray[0]);
            
                _xenosQueryControl.intialExecute();
            }catch(e:Error){
                XenosAlert.error(e.message);
            }
            
            postReopenInit();
        }
        
        public function postReopenInit():void
        {
        }
        
        public function postCancelInit():void
        {
        }
        
        public function preQueryResultInit():Object
        {
            return null;
        }
        
        public function doQueryResultInit(resultEvent:ResultEvent):void
        {
            _resultEvent[0] = resultEvent;
            var keyList:Object=preQueryResultInit();
            var result:Object = _xenosQueryControl.resultHandler(resultEvent,keyList);
            postQueryResultInit(result);
            //postQueryResultInit(_xenosQueryControl.resultHandler(resultEvent,preQueryResultInit()));
        }
        
        public function postQueryResultInit(result:Object):void
        {
        }
        
        public function preAmendResultInit():Object
        {
            return null;
        }
        
        public function doAmendResultInit(resultEvent:ResultEvent):void
        {
            _resultEvent[0] = resultEvent;
            var keyList:Object=preAmendResultInit();
            var result:Object = _xenosQueryControl.resultHandler(resultEvent,keyList);
            postAmendResultInit(result);
            //postAmendResultInit(_xenosQueryControl.resultHandler(resultEvent,preAmendResultInit()));

        }
        
        public function postAmendResultInit(result:Object):void
        {
        }
        
        public function preCancelResultInit():Object
        {
            return null;
        }
        
        public function doCancelResultInit(resultEvent:ResultEvent):void
        {
            _resultEvent[0] = resultEvent;
            var keyList:Object=preCancelResultInit();
            var result:Object = _xenosQueryControl.resultHandler(resultEvent,keyList);
            postCancelResultInit(result);
            //postCancelResultInit(_xenosQueryControl.resultHandler(resultEvent,preCancelResultInit()));
        }
        
        public function postCancelResultInit(result:Object):void
        {
        }
        
        public function preReopenResultInit():Object
        {
            return null;
        }
        
        public function doReopenResultInit(resultEvent:ResultEvent):void
        {
            _resultEvent[0] = resultEvent;
            var keyList:Object=preReopenResultInit();
            var result:Object = _xenosQueryControl.resultHandler(resultEvent,keyList);
            postReopenResultInit(result);
            //postCancelResultInit(_xenosQueryControl.resultHandler(resultEvent,preCancelResultInit()));
        }
        
        public function postReopenResultInit(result:Object):void
        {
        }
        
        
        public function preQuery():void
        {
        }
        
        public function doQuery(event:Event):void
        {
            _currentEvent = event;
            
            _serviceArray[1] = new XenosHTTPService();
            
            (_serviceArray[1] as XenosHTTPService).addEventListener(ResultEvent.RESULT,queryResultHandler);
            
            (_serviceArray[1] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
            
            preQuery();
            
            (_serviceArray[1] as XenosHTTPService).resultFormat = "xml";
                        
            try{
               _xenosQueryControl.setQueryService(_serviceArray[1],_validator);            
               _xenosQueryControl.sendUserQuery();
            }catch(e:Error){
                trace(e.getStackTrace());
                XenosAlert.error(e.message);
            }
            
            postQuery();
        }
        
        public function postQuery():void
        {
        }
        
        public function preAmend():void
        {
        }
        
        public function doAmend(event:Event):void
        {
            _currentEvent = event;
            
            _serviceArray[1] = new XenosHTTPService();
            
            (_serviceArray[1] as XenosHTTPService).addEventListener(ResultEvent.RESULT,amendQueryResultHandler);
            
            (_serviceArray[1] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
            
            preAmend();
            
            (_serviceArray[1] as XenosHTTPService).resultFormat = "xml";
                        
            try{
               _xenosQueryControl.setQueryService(_serviceArray[1],_validator);            
               _xenosQueryControl.sendUserQuery();
            }catch(e:Error){
                XenosAlert.error(e.message);
            }
            
            postAmend();
        }
        
        public function postAmend():void
        {
        }
        
        public function preCancel():void
        {
        }
        
        public function doCancel(event:Event):void
        {
            _currentEvent = event;
            
            _serviceArray[1] = new XenosHTTPService();
            
            (_serviceArray[1] as XenosHTTPService).addEventListener(ResultEvent.RESULT,cancelQueryResultHandler);
            
            (_serviceArray[1] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
            
            preCancel();
            
            (_serviceArray[1] as XenosHTTPService).resultFormat = "xml";
                        
            try{
               _xenosQueryControl.setQueryService(_serviceArray[1],_validator);            
               _xenosQueryControl.sendUserQuery();
            }catch(e:Error){
                XenosAlert.error(e.message);
            }
            
            postCancel();
        }
        
        public function postCancel():void
        {
        }
        
        public function preReopen():void
        {
        }
        
        public function doReopen(event:Event):void
        {
            _currentEvent = event;
            
            _serviceArray[1] = new XenosHTTPService();
            
            (_serviceArray[1] as XenosHTTPService).addEventListener(ResultEvent.RESULT,reopenQueryResultHandler);
            
            (_serviceArray[1] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
            
            preReopen();
            
            (_serviceArray[1] as XenosHTTPService).resultFormat = "xml";
                        
            try{
               _xenosQueryControl.setQueryService(_serviceArray[1],_validator);            
               _xenosQueryControl.sendUserQuery();
            }catch(e:Error){
                XenosAlert.error(e.message);
            }
            
            postReopen();
        }
        
        public function postReopen():void
        {
        }
        
        public function preQueryResultHandler():Object
        {
            return null;
        }
        
        public function queryResultHandler(resultEvent:ResultEvent):void
        {
            _resultEvent[1] = resultEvent;
            var keyList:Object=preQueryResultHandler();
            var result:Object = _xenosQueryControl.userQueryResultEvent(resultEvent,keyList);
            postQueryResultHandler(result);
            keepPrevSortingIfRequired();
        }
        
        public function postQueryResultHandler(result:Object):void
        {
        }
        
        public function preAmendResultHandler():Object
        {
            return null;
        }
        
        public function amendQueryResultHandler(resultEvent:ResultEvent):void
        {
            _resultEvent[1] = resultEvent;
            var keyList:Object=preAmendResultHandler();
            var result:Object = _xenosQueryControl.userQueryResultEvent(resultEvent,keyList);
            postAmendResultHandler(result);
            //postAmendResultHandler(_xenosQueryControl.resultHandler(resultEvent,preAmendResultHandler()));
            keepPrevSortingIfRequired();            
        }
        
        public function postAmendResultHandler(result:Object):void
        {
        }
        
        public function preCancelResultHandler():Object
        {
            return null;
        }
        
        public function cancelQueryResultHandler(resultEvent:ResultEvent):void
        {
            _resultEvent[1] = resultEvent;
            var keyList:Object=preCancelResultHandler();
            var result:Object = _xenosQueryControl.userQueryResultEvent(resultEvent,keyList);
            postCancelResultHandler(result);
            keepPrevSortingIfRequired();
            //postCancelResultHandler(_xenosQueryControl.resultHandler(resultEvent,preCancelResultHandler()));
        }
        
        public function postCancelResultHandler(result:Object):void
        {
        }
        
        
        public function preReopenResultHandler():Object
        {
            return null;
        }
        
        public function reopenQueryResultHandler(resultEvent:ResultEvent):void
        {
            _resultEvent[1] = resultEvent;
            var keyList:Object=preReopenResultHandler();
            var result:Object = _xenosQueryControl.userQueryResultEvent(resultEvent,keyList);
            postReopenResultHandler(result);
            //postCancelResultHandler(_xenosQueryControl.resultHandler(resultEvent,preCancelResultHandler()));
        }
        
        public function postReopenResultHandler(result:Object):void
        {
        }
        
        //Reset
        
        
        public function preResetQuery():void
        {
            
        }
        public function doResetQuery(event:Event):void
        {
            _currentEvent = event;
            
            _serviceArray[2] = new XenosHTTPService();
            
            (_serviceArray[2] as XenosHTTPService).addEventListener(ResultEvent.RESULT,doQueryResultInit);
            
            (_serviceArray[2] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
            
            preResetQuery();
            
            (_serviceArray[2] as XenosHTTPService).resultFormat = "xml";
            
            try{
               _xenosQueryControl.setInitService(_serviceArray[2]);
            
               _xenosQueryControl.intialExecute();
            }catch(e:Error){
                XenosAlert.error(e.message);
            }
            
            postResetQuery();
            
        }
        
        
        public function postResetQuery():void
        {
        }
        
        public function preResetAmend():void
        {
            
        }
        
        public function doResetAmend(event:Event):void
        {
            _currentEvent = event;
            
            _serviceArray[2] = new XenosHTTPService();
            
            (_serviceArray[2] as XenosHTTPService).addEventListener(ResultEvent.RESULT,doAmendResultInit);
            
            (_serviceArray[2] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
            
            preResetAmend();
            
            (_serviceArray[2] as XenosHTTPService).resultFormat = "xml";
                        
            try{
                _xenosQueryControl.setInitService(_serviceArray[2]);
            
                _xenosQueryControl.intialExecute();
            }catch(e:Error){
                XenosAlert.error(e.message);
            }
            
            postResetAmend();
        }
        
        public function postResetAmend():void
        {
        }
        
        public function preResetCancel():void
        {
        }
        
        public function doResetCancel(event:Event):void
        {
            _currentEvent = event;
            
            _serviceArray[2] = new XenosHTTPService();
            
            (_serviceArray[2] as XenosHTTPService).addEventListener(ResultEvent.RESULT,doCancelResultInit);
            
            (_serviceArray[2] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
            
            preResetCancel();
            
            (_serviceArray[2] as XenosHTTPService).resultFormat = "xml";
            
            try{
                _xenosQueryControl.setInitService(_serviceArray[2]);
            
                _xenosQueryControl.intialExecute();
            }catch(e:Error){
                XenosAlert.error(e.message);
            }
            
            postResetCancel();
        }
        
        public function postResetCancel():void
        {
        }    
        
        
        public function preResetReopen():void
        {
        }
        
        public function doResetReopen(event:Event):void
        {
            _currentEvent = event;
            
            _serviceArray[2] = new XenosHTTPService();
            
            (_serviceArray[2] as XenosHTTPService).addEventListener(ResultEvent.RESULT,doReopenResultInit);
            
            (_serviceArray[2] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
            
            preResetReopen();
            
            (_serviceArray[2] as XenosHTTPService).resultFormat = "xml";
            
            try{
                _xenosQueryControl.setInitService(_serviceArray[2]);
            
                _xenosQueryControl.intialExecute();
            }catch(e:Error){
                XenosAlert.error(e.message);
            }
            
            postResetReopen();
        }
        
        public function postResetReopen():void
        {
        }    
        
     public function preGenerateXls():String{
        return null;
    }    
     /**
      * This will generate the Xls report for the entire query result set 
      * and will open in a separate window.
     
      * @param e
      * 
      */
     public function generateXls(e:Event):void {
        //var url : String = "trd/tradeRcvdConfQueryDispatch.action?method=generateXLS";
        var request:URLRequest = new URLRequest(preGenerateXls());
        request.method = URLRequestMethod.POST;
        // set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
         try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            }
            postGenerateXls();
    } 
    
    public function postGenerateXls():void{
        
    }
    
    public function preGeneratePdf():String{
        return null;
    }
    /**
    * This will generate the Pdf report for the entire query result set 
    * and will open in a separate window.
    */    
     public function generatePdf(e:Event):void {
        //var url : String = "trd/tradeRcvdConfQueryDispatch.action?method=generatePDF";
        var request:URLRequest = new URLRequest(preGeneratePdf());
        request.method = URLRequestMethod.POST;
        // set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
         try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            }
            
         postGeneratePdf();   
    } 
    
    public function postGeneratePdf():void{
        
    }
    
    public function prePrint():Object{
        return null;
    }
    /**
    * This is for the Print button which at a  time will print all the data 
    * in the dataprovider of the Datagrid object
    */
     public function doPrint(e:Event):void{
        prePrint();
        //nothing to do
        postPrint();
    }
      
    public function postPrint():void{
        
    }
    
    public function preNext():Object{
        return null;
    }
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     public function doNext(e:Event):void { 
        this.getSubmitQueryHttpService().request = preNext();
        _xenosQueryControl.setQueryService(this.getSubmitQueryHttpService(),null);
        
         _xenosQueryControl.sendUserQuery();
         postNext();
    } 
     
    public function postNext():void{
        
    }
    public function prePrevious():Object{
        return null;
    }
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     public function doPrevious(e:Event):void { 
        this.getSubmitQueryHttpService().request = prePrevious();
        _xenosQueryControl.setQueryService(this.getSubmitQueryHttpService(),null);
        
         _xenosQueryControl.sendUserQuery();
         postPrevious();
    }  
         
    public function postPrevious():void{
        
    }
        //Reset block end
        
        public function destroyModule(event:ModuleEvent):void {
                        
            this.removeEventListener("queryInit",doQueryInit);
            this.removeEventListener("queryReset",doResetQuery);
            this.removeEventListener("querySubmit",doQuery);
            this.removeEventListener("amendInit",doAmendInit);
            this.removeEventListener("amendReset",doResetAmend);
            this.removeEventListener("amendSubmit",doAmend);            
            this.removeEventListener("cancelInit",doCancelInit);
            this.removeEventListener("cancelReset",doResetCancel);
            this.removeEventListener("cancelSubmit",doCancel);
            
            this.removeEventListener("reopenInit",doReopenInit);
            this.removeEventListener("reopenReset",doResetReopen);
            this.removeEventListener("reopenSubmit",doReopen);
            
            this.removeEventListener("prev",doPrevious);
            this.removeEventListener("next",doNext);
            this.removeEventListener("pdf",generatePdf);
            this.removeEventListener("xls",generateXls);
            this.removeEventListener("print",doPrint);
            
            this.removeEventListener("querySubmitRefresh",doQueryRefresh);
            this.removeEventListener("amendSubmitRefresh",doAmendQryRefresh);
            this.removeEventListener("cancelSubmitRefresh",doCancelQryRefresh);
            
            if(_serviceArray[0] != null){
                switch(_modeOfOperation){
                    case "query":
                     (_serviceArray[0] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.doQueryResultInit);
                     break;
                    case "amend":
                     (_serviceArray[0] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.doAmendResultInit);
                      break;
                    case "cancel":
                     (_serviceArray[0] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.doCancelResultInit);
                      break;
                      case "reopen":
                     (_serviceArray[0] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.doReopenResultInit);
                      break;
                }            
            }
            if(_serviceArray[1] != null){
                switch(_modeOfOperation){
                    case "entry":
                     (_serviceArray[1] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.queryResultHandler);
                     break;
                    case "amend":
                     (_serviceArray[1] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.amendQueryResultHandler);
                      break;
                    case "cancel":
                     (_serviceArray[1] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.cancelQueryResultHandler);
                      break;
                      case "reopen":
                     (_serviceArray[1] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.reopenQueryResultHandler);
                      break;
                }            
            } 
            if(_serviceArray[2] != null){
                switch(_modeOfOperation){
                    case "entry":
                     (_serviceArray[2] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.doQueryResultInit);
                     break;
                    case "amend":
                     (_serviceArray[2] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.doAmendResultInit);
                      break;
                    case "cancel":
                     (_serviceArray[2] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.doCancelResultInit);
                      break;
                      case "reopen":
                     (_serviceArray[2] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.doReopenResultInit);
                      break;
                }            
            }
            var i:int= 0;
            for(i=0;i<_serviceArray.length;i++){
                if(_serviceArray[i] != null){
                    (_serviceArray[i] as XenosHTTPService).removeEventListener(FaultEvent.FAULT,faultHandler);
                }
                _serviceArray[i] = null;
            }
            for(i=0;i<_resultEvent.length;i++){                
                _resultEvent[i] = null;
            }
            this.removeEventListener(ModuleEvent.UNLOAD,destroyModule); 
        }
                
        public function faultHandler(event:FaultEvent):void{
            XenosAlert.error('Error Occured :  ' + event.fault.faultString)
        }
        /**
         * Event handler to perform query same as by "querySubmit" event with preserving client side sorting.
         * 
         * @param event   Custom event generated with type "querySubmitRefresh".
         * 
         */
        public function doQueryRefresh(event:Event):void{
            _currentEvent = event;
            //trace("_currentEvent.type : " + _currentEvent.type)
            preRefreshQry();
            // Perform the original submit query
            doQuery(event); 
            
        }
        /**
         * Set the  previous client sorting into "_sortFieldsArray"
         * 
         */
        protected function preRefreshQry():void{
            if(_dataGridComp != null){
                _sortFieldsArray = null;
                if(_dataGridComp is XenosAdvancedDataGrid){
                    _sortFieldsArray = (_dataGridComp as XenosAdvancedDataGrid).getSortFields();
                }else if(_dataGridComp is CustomDataGrid){
                    _sortFieldsArray = (_dataGridComp as CustomDataGrid).getSortFields();
                }else{
                    trace("Unsupported DataGrid component specified.");
                }
            }
        }
        
        /**
         * Sets previous sorting fields into the supplied DataGrid instance 
         * for keeping client side sorting. 
         * 
         */
        protected function postRefreshQry():void{
            if(_sortFieldsArray != null && _sortFieldsArray.length > 0){
                if(_dataGridComp != null){
                    if(_dataGridComp is AdvancedDataGrid){                        
                        if((_dataGridComp as AdvancedDataGrid).dataProvider.sort == null){
                            (_dataGridComp as AdvancedDataGrid).dataProvider.sort = new Sort();
                        }
                        (_dataGridComp as AdvancedDataGrid).dataProvider.sort.fields = _sortFieldsArray;
                        (_dataGridComp as AdvancedDataGrid).dataProvider.refresh();
                        trace("AdvancedDataGrid");
                    }else if(_dataGridComp is DataGrid){
                        if((_dataGridComp as DataGrid).dataProvider.sort == null){
                            (_dataGridComp as DataGrid).dataProvider.sort = new Sort();
                        }
                        (_dataGridComp as DataGrid).dataProvider.sort.fields = _sortFieldsArray;
                        (_dataGridComp as DataGrid).dataProvider.refresh();
                        trace("DataGrid");
                    }else{
                        trace("Invalid DataGrid Object specified for client sorting.");
                    }
                }
            }
        }
        /**
         * This  method will keep the previous client sorting if the event type despatched belongs to 
         * ["querySubmitRefresh" ,"amendSubmitRefresh","cancelSubmitRefresh"]
         * 
         */
        protected function keepPrevSortingIfRequired():void{
            if(_currentEvent != null && (XenosStringUtils.equals(_currentEvent.type, "querySubmitRefresh") ||
                                        XenosStringUtils.equals(_currentEvent.type, "amendSubmitRefresh") ||
                                        XenosStringUtils.equals(_currentEvent.type, "cancelSubmitRefresh"))){
                postRefreshQry();
            }
        }        
        /**
         * Event handler to perform query same as by "amendSubmit" event with preserving client side sorting.
         * 
         * @param event   Custom event generated with type "amendSubmitRefresh".
         * 
         */
        public function doAmendQryRefresh(event:Event):void{
            _currentEvent = event;
            trace("_currentEvent.type : " + _currentEvent.type)
            preRefreshQry();
            doAmend(event);
        }        
        /**
         * Event handler to perform query same as by "cancelSubmit" event with preserving client side sorting.
         * 
         * @param event   Custom event generated with type "cancelSubmitRefresh".
         * 
         */
        public function doCancelQryRefresh(event:Event):void{
            _currentEvent = event;
            trace("_currentEvent.type : " + _currentEvent.type)
            preRefreshQry();
            doCancel(event);
        }
            
    }
}