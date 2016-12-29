
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.controls.XenosButton;
 import com.nri.rui.core.controls.XenosQuery;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.core.utils.DateUtils;
 import com.nri.rui.exm.ExmConstraints;
 import com.nri.rui.exm.validators.ExmQueryValidator;
 
 import flexlib.mdi.events.MDIWindowEvent;
 
 import mx.collections.ArrayCollection;
 import mx.controls.AdvancedDataGrid;
 import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
 import mx.core.UIComponent;
 import mx.events.AdvancedDataGridEvent;
 import mx.events.CloseEvent;
 import mx.formatters.NumberBase;
 import mx.managers.PopUpManager;
 import mx.utils.ObjectUtil;
     
 private var keylist:ArrayCollection = new ArrayCollection(); 
 private var sortFieldArray:Array =new Array();
 private var sortFieldDataSet:Array =new Array();
 private var sortFieldSelectedItem:Array =new Array();
 private var csd:CustomizeSortOrder=null; 
 private var editColumn:Object = null;
 private var isViewingTrash:Boolean = false;
 private var isFilteredQuery:Boolean = false;
 private var refreshAfterOpns:Boolean = false;
 private var filterObj:Object = null;
 private var filterGrPk:String = null;
 private var filterGrDate:String = null;
 [Bindable]
 private var userTimeZone:String = null;
  //Items returning through context - Non display objects for accountPopup
 [Bindable]
 public var returnContextItem:ArrayCollection = new ArrayCollection();
 [Bindable]
  private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
 [Bindable]
 private var mode : String = "query";
 [Bindable] private var queryResult:ArrayCollection= new ArrayCollection(); 
 [Bindable] private var summaryQueryResult:ArrayCollection= new ArrayCollection();        
    
 [Bindable]
 public var selectedMessageRecords:ArrayCollection = new ArrayCollection();     
 [Bindable] 
 public var selectAllBind:Boolean=false;
 public var menuHit:Boolean=true;
 private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
 //To hold the last instance of Submit Button
 private var lastSubmitBtnInstance:XenosButton = null;
 //To hold the default row height for keeping the height of the resultSummary dataGrid fixed throughout all submits.
 private var defaultRowHeight:Number = 23;
    
private function changeCurrentState():void{
    currentState = "result";
    app.submitButtonInstance = trashButtonPanel.includeInLayout == true? btnRestore : btnRecycle;
    lastSubmitBtnInstance = app.submitButtonInstance;
}
public function loadAll():void{
    menuHit = true;
    
    
    app.mdiWindowInstance.addEventListener(MDIWindowEvent.FOCUS_START,setActiveSubmitBtn,false,-1);
    app.mdiWindowInstance.addEventListener(MDIWindowEvent.MAXIMIZE,setActiveSubmitBtn, false, -1);
    app.mdiWindowInstance.addEventListener(MDIWindowEvent.RESTORE,setActiveSubmitBtn, false, -1);

    
    parseUrlString();
    super.setXenosQueryControl(new XenosQuery());
    //XenosAlert.info("mode : "+mode);
    if(this.mode == 'query'){
        this.dispatchEvent(new Event('queryInit'));        
    }
    
            
}

/**
 * Set last submit button instance button instance to the Application submit button instance for Minimize, Maximize, Restore
 * NOTE: look at the priority of the event creation. It is lower than default(0) so that this handler will be fired at the last
 *  of the chain of event handlers of the same event.
 * 
 * @param event   MDIWindowEvent
 * 
 */
public function setActiveSubmitBtn(event: MDIWindowEvent) : void{
    //XenosAlert.info("lastSubmitBtnInstance" + lastSubmitBtnInstance);
    app.submitButtonInstance = lastSubmitBtnInstance;
}
       
/**
 * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
 * 
 */ 
public function parseUrlString():void {
    try {
        // Remove everything before the question mark, including
        // the question mark.
        var myPattern:RegExp = /.*\?/; 
       // XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
        var s:String = this.loaderInfo.url.toString();
        s = s.replace(myPattern, "");
        // Create an Array of name=value Strings.
        var params:Array = s.split(Globals.AND_SIGN); 
         // Print the params that are in the Array.
        var keyStr:String;
        var valueStr:String;
        var paramObj:Object = params;
      
        // Set the values of the salutation.
        if(params != null){
            for (var i:int = 0; i < params.length; i++) {
                var tempA:Array = params[i].split("=");  
                if (tempA[0] == "mode") {
                    //XenosAlert.info("movArray param = " + tempA[1]);
                    mode = tempA[1];
                }
            }                        
        }else{
            mode = "query";
        }                 

    } catch (e:Error) {
        trace(e);
    }               
}
        
override public function preQueryInit():void{
       var rndNo:Number= Math.random();
         super.getInitHttpService().url = "exm/browseExm.action?method=initialExecute&mode=query&menuType=Y&rnd=" + rndNo;
         
         var reqObject:Object = new Object();
       reqObject.SCREEN_KEY = 11129;
         super.getInitHttpService().request = reqObject;    
         //XenosAlert.info("I am in preQueryInit ");         
}
override public function preQueryResultInit():Object{             
    keylist = new ArrayCollection();          
    keylist.addItem("messageTypes.item");
    keylist.addItem("assignOfficeList.assignOffice");
    keylist.addItem("sortFieldList1.item");    
    keylist.addItem("sortFieldList2.item");    
    keylist.addItem("sortFieldList3.item");    
    keylist.addItem("groupIds.item");    
    keylist.addItem("sortOrder1");        
    keylist.addItem("sortOrder2");        
    keylist.addItem("sortOrder3");
    keylist.addItem("viewMessageOptionsList.viewMessageOptions");    
    keylist.addItem("userTimeZone");
    keylist.addItem("creationToDate");//auto populated as application date of EXM module(XGA-3112)    
    return keylist;            
}
override public function postQueryResultInit(mapObj:Object):void{
    var selIndx:int = -1;
    var i:int = 0;
    this.errorMessage.text = "";
    this.assignTo.employeeText.text = "";
    this.securityId.instrumentId.text = "";
    this.fundCode.fundCode.text = "";
    this.referenceNumber.text = "";
    this.dateFrom.text = "";
    this.remarks.text= "";
    this.comments.text = "";
    this.remarksEnterBy.text= "";
    this.actPopUp.accountNo.text= "";
//    this.showTrashMsg.selected = false;
    app.submitButtonInstance = submit;
    lastSubmitBtnInstance = submit;
    
    errPage.clearError(super.getInitResultEvent());
    
    resetResultHeader();
    summaryQueryResult.removeAll();
    
    
    var sortField1Default:String = mapObj[keylist.getItemAt(6)];
    var sortField2Default:String = mapObj[keylist.getItemAt(7)];
    var sortField3Default:String = mapObj[keylist.getItemAt(8)];
    
    var initcol:ArrayCollection = new ArrayCollection();
    initcol.addItem({label:" ", value: " "});
    for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
        initcol.addItem(item);
    }
        
    this.msgType.dataProvider = initcol;
    
    initcol = new ArrayCollection();
    initcol.addItem("");
    for each(var item1:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
        initcol.addItem(item1);
    }
        
    this.office.dataProvider = initcol;
    
    
    initcol = new ArrayCollection();
    initcol.addItem({label:" ", value: " "});
    for each(var item2:Object in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
        initcol.addItem(item2);
    }
        
    this.groupId.dataProvider = initcol;
    
    initcol = new ArrayCollection();
//    initcol.addItem({label:" ", value: " "});
    for each(var item6:Object in (mapObj[keylist.getItemAt(9)] as ArrayCollection)){
        initcol.addItem(item6);
    }        
    this.showTrashMsg.dataProvider = initcol;
    
    if(!XenosStringUtils.isBlank(mapObj[keylist.getItemAt(10)])){
        userTimeZone = mapObj[keylist.getItemAt(10)];
    }else{
        userTimeZone = null;
    }
    //Creation date to is auto populated as application date of EXM module(XGA-3112)    
    var dateStr:String = "";
	if(mapObj[keylist.getItemAt(11)]!= null) {
		dateStr = mapObj[keylist.getItemAt(11)];
		if(!XenosStringUtils.isBlank(dateStr))
			dateTo.selectedDate = DateUtils.toDate(dateStr);          
	} else {
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('exm.error.initialize.date'));
	}
    
    /* population of creation_date_to completes */
    
    
    initcol=new ArrayCollection();
    initcol.addItem({label:" ", value: ""});
    selIndx = -1;
    //index=0;
    for each(var item3:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
        //Get the default value object's index
        if(XenosStringUtils.equals((item3.value),sortField1Default)){                    
            selIndx = i;
        }
        i++;
        initcol.addItem(item3);
    }
    sortFieldArray[0]=sortField1;
    sortFieldDataSet[0]=initcol;
    //Set the default value object
    sortFieldSelectedItem[0] = initcol.getItemAt(selIndx != -1 ? (selIndx+1) : 0);
    
    
    initcol=new ArrayCollection();
    initcol.addItem({label:" ", value: ""});
    selIndx = -1;
    i=0;
    for each(var item4:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
        //Get the default value object's index
        if(XenosStringUtils.equals((item4.value),sortField2Default)){                    
            selIndx = i;
        }
        i++;
        initcol.addItem(item4);
    }
    
    /* for(i = 0; i<initcol.length; i++) {
        //Get the default value object's index
        if(XenosStringUtils.equals((initcol[i].value),sortField2Default)){                    
            selIndx = i;
        }
        
       tempColl.addItem(initcol[i]);            
    } */
    sortFieldSelectedItem[1] = initcol.getItemAt(selIndx != -1 ? (selIndx+1) : 0);
    
    sortFieldArray[1]=sortField2;
    sortFieldDataSet[1]=initcol;
    //Set the default value object
    
    initcol=new ArrayCollection();
    initcol.addItem({label:" ", value: ""});
    selIndx = -1;
    i=0;
    for each(var item5:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
        //Get the default value object's index
        if(XenosStringUtils.equals((item5.value),sortField3Default)){                    
            selIndx = i;
        }
        i++;
        initcol.addItem(item5);
    }
    
    /* for(i = 0; i<initcol.length; i++) {
        //Get the default value object's index
        if(XenosStringUtils.equals((initcol[i].value),sortField3Default)){                    
            selIndx = i;
        }
        
       tempColl.addItem(initcol[i]);            
    } */
    
    sortFieldSelectedItem[2] = initcol.getItemAt(selIndx != -1 ? (selIndx+1) : 0);
    sortFieldArray[2]=sortField3;
    sortFieldDataSet[2]=initcol;
    //Set the default value object    
        
    csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
    csd.init();
    if(menuHit){                
        //this.dispatchEvent(new Event('querySubmit'));             
        
        menuHit = false;
    }
    emxcurrency.ccyText.text="";
    
}      
private function sortOrder1Update():void{
  csd.update(sortField1.selectedItem,0);
}
 
private function sortOrder2Update():void{         
    csd.update(sortField2.selectedItem,1);
}
        
override    public function preGenerateXls():String{
    var url : String ="";        
    url = "exm/browseExm.action?method=generateXLS";
    return url;
}
     
override public function preGeneratePdf():String{
    //XenosAlert.info("preGeneratePdf");
    var url : String =null;
    url = "exm/browseExm.action?method=generatePDF";
    return url;
}    
      
override    public function preNext():Object{
    var reqObj : Object = new Object();
    reqObj.method = "doNext";
    return reqObj;
}    
override public function prePrevious():Object{
    var reqObj : Object = new Object();
    reqObj.method = "doPrevious";
    return reqObj;
}    
      
override public function preQuery():void{
    setValidator();
    qh.resetPageNo();    
   // XenosAlert.info("I am in preQuery ");
    isViewingTrash = this.showTrashMsg.selectedItem == null ? false : (XenosStringUtils.equals(this.showTrashMsg.selectedItem.toString(), ExmConstraints.VIEW_BIN_MESSAGES) == true ? true : false);
    
    super.getSubmitQueryHttpService().url = "exm/browseExm.action?";  
    super.getSubmitQueryHttpService().request  =populateRequestParams();
    super.getSubmitQueryHttpService().method="POST";   
}
override public function postQuery():void{
    if(isViewingTrash){
       this.buttonPanel.includeInLayout = false;
       this.buttonPanel.visible = false;
       this.trashButtonPanel.includeInLayout = true;
       this.trashButtonPanel.visible = true;
       if(editColumn == null){    
         removeColumn();
       }
    }else{            
       this.buttonPanel.includeInLayout = true;
       this.buttonPanel.visible = true;
       this.trashButtonPanel.includeInLayout =false ;
       this.trashButtonPanel.visible = false;
       if(editColumn != null){               
          addColumn();
       }
    }   
}
      
private function removeColumn():void
{
    
    var cols :Array = resultSummary.columns;
    var column:Object =  cols.shift();
    editColumn = cols.shift();
    cols.unshift(column);
//    cols.pop();
    
    resultSummary.columns = cols;
    
}
private function addColumn():void
{
    
    var cols :Array = resultSummary.columns;
    var column:Object =  cols.shift();
    cols.unshift(editColumn);
    cols.unshift(column);
    //cols.pop();
    
    resultSummary.columns = cols;
    editColumn = null;
    
}
private function setValidator():void{
   var validateModel:Object={
                        exmQuery:{                             
                           baseDateFromStr:this.dateFrom.text,
                           baseDateToStr:this.dateTo.text                                    
                        }
                       }; 
    super._validator = new ExmQueryValidator();
    super._validator.source = validateModel ;
    super._validator.property = "exmQuery";
 }
     
/**
 * This method will populate the request parameters for the
 * submitQuery call and bind the parameters with the HTTPService
 * object.
 */
private function populateRequestParams():Object {
    
    var reqObj : Object = new Object();
    reqObj.method= "submitQuery";
    reqObj.msgType = this.msgType.selectedItem == null ? "" : this.msgType.selectedItem.value;
    reqObj.errorMessage =  this.errorMessage.text;
    reqObj.creationFormDate = this.dateFrom.text ;
    reqObj.creationToDate = this.dateTo.text;
    reqObj.securityCode = this.securityId.instrumentId.text;
    reqObj.accountNo = this.actPopUp.accountNo.text;
    reqObj.fundCode = this.fundCode.fundCode.text;
    reqObj.referenceNo = this.referenceNumber.text;
    reqObj.remarks = this.remarks.text;
    reqObj.comment = this.comments.text;
    reqObj.remarksEnterBy = this.remarksEnterBy.text;
    reqObj.assignOffice = this.office.selectedItem == null ? "" : this.office.selectedItem;
    reqObj.assignTo = this.assignTo.employeeText.text;
    
    reqObj.viewTrash = isViewingTrash;
    reqObj.groupPk = this.groupId.selectedItem == null ? "" : this.groupId.selectedItem.value;
    
    reqObj.currencyCode = this.emxcurrency.ccyText.text;
    reqObj.excludeCcy = this.excludeCcy.selected;
    
    reqObj.SCREEN_KEY = 11130;
    reqObj.sortOrder1 = this.sortField1.selectedItem == null ? "" : this.sortField1.selectedItem.value;
    reqObj.sortOrder2 = this.sortField2.selectedItem == null ? "" : this.sortField2.selectedItem.value;
    reqObj.sortOrder3 = this.sortField3.selectedItem == null ? "" : this.sortField3.selectedItem.value;
    reqObj.rnd = Math.random() + "";
    
    reqObj.filterGroupPk = "";
    reqObj.filterCreationDate = "";
    if(this.isFilteredQuery){
    	var itrf:int =0;
        for(var item:String in filterObj){
            //trace(item + " : " + filterObj[item]);
            reqObj[item] = filterObj[item];
            //XenosAlert.info(item + " : " + filterObj[item]);
            if(item == 'filterGroupPk')
              filterGrPk = filterObj[item];
            if(item == 'filterCreationDate')
              filterGrDate = filterObj[item];
           itrf++;
        }
        if(itrf<=1)
          filterGrDate = null;
    }
    
    return reqObj;
}
    
override public function preQueryResultHandler():Object{             
    keylist = new ArrayCollection();          
    keylist.addItem("rows.row");
    keylist.addItem("groupInfo.item");    
    keylist.addItem("Errors.error");
    keylist.addItem("nextTraversable");
    keylist.addItem("prevTraversable");
    return keylist;            
}
    
override public function postQueryResultHandler(mapObj:Object):void{
    //XenosAlert.info("height = " + resultSummary.rowHeight);
    resultSummary.rowHeight = defaultRowHeight;
    commonResult(mapObj);
    setRefreshAfterOpns(false);
    
}
private function commonResult(mapObj:Object):void{
    //XenosAlert.info("mapObj : "+mapObj.toString()); 
    //var mapObj:Object = mkt.userQueryResultEvent(event,null);
    var result:String = "";
    var rs:XML = XML(super.getSubmitQueryResultEvent().result);
    if(mapObj!=null){        
        if(rs.child("Errors").length()>0){
            //result = mapObj["errorMsg"] .toString();
            queryResult.removeAll();
            summaryQueryResult.removeAll();
            var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list                  
             for each ( var error:XML in rs.Errors.error ) {
                errorInfoList.addItem(error.toString());
            }
            errPage.showError(errorInfoList);
        }else {
            errPage.clearError(super.getSubmitQueryResultEvent());
            //errPage.removeError();
            //XenosAlert.info("I am in errPage ");
            queryResult.removeAll();
            //summaryQueryResult.removeAll();
            if(!this.isFilteredQuery || this.refreshAfterOpns){
                summaryQueryResult.removeAll();
                var tempCol : ArrayCollection = (mapObj["groupInfo.item"]as ArrayCollection); 
                for(var itr:int = 0; itr < tempCol.length ;itr ++){
                    //XenosAlert.info(tempCol[itr]);
                      var grpArr:Array = String(tempCol[itr]).split("/");
                      if(prvType == String(grpArr[0])){
                          prvType = grpArr[0];
                          grpArr[0] = "";
                      }else{
                          prvType = grpArr[0];
                      } 
                      summaryQueryResult.addItem({type : grpArr[0],grpPk : grpArr[1],date : grpArr[2], count : grpArr[3]});                        
                }    
            }else if(this.isFilteredQuery){
            	var notFound:Boolean = true;
                var tempCol : ArrayCollection = (mapObj["groupInfo.item"]as ArrayCollection); 
            	for(var summaryItr:int =0;  summaryItr < summaryQueryResult.length ;summaryItr++){
            		for(var itr:int = 0; itr < tempCol.length ;itr ++){
            			var grpArr:Array = String(tempCol[itr]).split("/");
            			if( summaryQueryResult[summaryItr]['grpPk'] == grpArr[1] && summaryQueryResult[summaryItr]['date'] == grpArr[2]){	                  		
	                  		//XenosAlert.info(" item.grpPk "+ summaryQueryResult[summaryItr]['grpPk']+" **grpArr[1]** "+grpArr[1]+" item.date "+ summaryQueryResult[summaryItr]['date']+" **grpArr[2]** "+grpArr[2]);
	                  		//XenosAlert.info(" item.grpPk "+ summaryQueryResult[summaryItr]['grpPk']+" **grpArr[1]** "+grpArr[1]+" item.date "+ summaryQueryResult[summaryItr]['date']+" **grpArr[2]** "+grpArr[2]);
		                  	//XenosAlert.info("count :"+summaryQueryResult[summaryItr]['count'] +" :: "+ grpArr[3] + " filterGrPk : "+filterGrPk+" filterGrDate : "+filterGrDate);
		                  	if( summaryQueryResult[summaryItr]['count'] != grpArr[3] && filterGrPk == grpArr[1] && (filterGrDate == null || filterGrDate == grpArr[2])){
		                  		summaryQueryResult[summaryItr]['count'] = grpArr[3];
		                  		summaryQueryResult.refresh(); 
		                  	}		                  	
		                  	notFound = false;	
		                  	break;                		
	                  	}
	                  	
            		}            		
                  	if(notFound && filterGrPk == summaryQueryResult[summaryItr]['grpPk'] && (filterGrDate == null || filterGrDate == summaryQueryResult[summaryItr]['date'])){
                  	  summaryQueryResult[summaryItr]['count'] = 0;
                  	  summaryQueryResult.refresh(); 
                  	}
                  	notFound = true;
            	}
            }            
            // XenosAlert.info("I am in queryResult : "+currentState);
            if((mapObj["rows.row"]as ArrayCollection).length > 0){
                queryResult=(mapObj["rows.row"]as ArrayCollection);
                var prvType:String = "";
                for(var i:int = 0; i < queryResult.length; i++){
                   queryResult[i]['selected'] = false;   //['selected'] = false;                   
                }

                //queryResult = ProcessResultUtil.process(queryResult, resultSummary.columns);
                queryResult.refresh();
                changeCurrentState();
                //app.submitButtonInstance = null;
                qh.setOnResultVisibility();
                qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
                qh.PopulateDefaultVisibleColumns();
                if(isViewingTrash){
                    qh.resultHeader.text = "Query Result - " + ExmConstraints.VIEW_BIN_MESSAGES + " Messages";
                }else{
                    qh.resultHeader.text = "Query Result - " + ExmConstraints.VIEW_LIVE_EXCEPTION_MESSAGES + " Messages";
                }
            }else{
                errPage.removeError();
                queryResult.removeAll();
                if(!this.isFilteredQuery){
                    summaryQueryResult.removeAll();    
                }                
                XenosAlert.info("Data Not Found");
                qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
                qh.pdf.enabled = false;
                qh.xls.enabled = false;
            }
        }            
    }
    selectedMessageRecords.removeAll();
    selectAllBind = false;
    //XenosAlert.info(result);
}    
override public function preResetQuery():void{
    var rndNo:Number= Math.random();
    super.getResetHttpService().url = "exm/browseExm.action?method=resetQuery&mode=query&menuType=Y&rnd=" + rndNo;
    var reqObject:Object = new Object();
    reqObject.SCREEN_KEY = 11129;
    super.getInitHttpService().request = reqObject;              
} 
private function dispatchPrintEvent():void{
    this.dispatchEvent(new Event("print"));
}  
private function dispatchPdfEvent():void{
    this.dispatchEvent(new Event("pdf"));
}  
private function dispatchXlsEvent():void{
    this.dispatchEvent(new Event("xls"));
}   
private function dispatchNextEvent():void{
    this.dispatchEvent(new Event("next"));
}  
private function dispatchPrevEvent():void{
    this.dispatchEvent(new Event("prev"));
}
       
private function numaricCompareFunc(itemA:Object, itemB:Object):int {
    var dataFormatter:NumberBase = new NumberBase(".",",",
                                                  ".",",");
    var valueA:Number = Number(dataFormatter.parseNumberString(itemA.age));
    var valueB:Number = Number(dataFormatter.parseNumberString(itemB.age));
    return ObjectUtil.numericCompare(valueA, valueB);
}

// ################## Handling CheckBoxes #########################33
//************* To fetch selected records *******************
public function checkSelectToModify(item:Object):void {
    var i:Number;
    var tempArray:Array = new Array();
    if(item.selected == 'true'){
         // needs to insert
        var obj:Object=new Object();
        
        obj.messagePk = item.messagePk;          
        
        selectedMessageRecords.addItem(obj);
    }else { //needs to pop
        tempArray=selectedMessageRecords.toArray();
        selectedMessageRecords.removeAll();
        for(i=0; i<tempArray.length; i++){
            if(tempArray[i].messagePk != item.messagePk){
                selectedMessageRecords.addItem(tempArray[i]);
            }
        }                
    }        
    setIfAllSelected();                
}
    
public function selectAllRecords(flag:Boolean): void {
    var i:Number = 0;
    //trace("flag = " + flag);
    selectedMessageRecords.removeAll();
    var tempColl : ArrayCollection = resultSummary.dataProvider as ArrayCollection;
    for(i=0; i<tempColl.length; i++){
        tempColl[i]['selected'] = flag;
        addOrRemove(tempColl[i]);
    }
    queryResult.refresh();
    resultSummary.invalidateDisplayList();
    btnRecycle.setFocus();               
}
    
public function addOrRemove(item:Object):void {
    var i:Number;
    var tempArray:Array = new Array();
    //trace("item.selected=" + item.selected + " :: item.messagePk " + item.messagePk + " : " + (item.selected == true));
    if(item.selected == 'true' || item.selected == true){ 
        var obj:Object=new Object();
        obj.messagePk = item.messagePk;        
        selectedMessageRecords.addItem(obj);       
    }else { //needs to pop
        tempArray=selectedMessageRecords.toArray();
        selectedMessageRecords.removeAll();
        for(i=0; i<tempArray.length; i++){
            if(tempArray[i].messagePk != item.messagePk)
                selectedMessageRecords.addItem(tempArray[i]);
        }
    }        
}

public function setIfAllSelected() : void {
    if(isAllSelected()){
        selectAllBind=true;
    } else {
        selectAllBind=false;
    }                     
}

public function isAllSelected(): Boolean {
    var i:Number = 0;
    if(queryResult == null){
     return false;
    }
    for(i=0; i<queryResult.length; i++){
        if(queryResult[i].selected == 'false') {
            return false;
        }
    }
    
    if(i == queryResult.length) {
        return true;
     }else {
        return false;
    }
}

// ################## End Handling CheckBoxes #########################33
    
//********* User Confirmation Popup *************
    
public function showRecycleModule():void {
    var parentApp :UIComponent = UIComponent(this.parentApplication);        
    if(selectedMessageRecords.length < 1){
        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('exm.label.Recycle.select.atleastone.record'));        
        return;
    }
    btnRecycle.enabled = false;
    var summaryPopup:SummaryPopup;
    summaryPopup = SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
    summaryPopup.title = "Recycle - Exm Message";
    summaryPopup.width = 840;
    summaryPopup.height = 445;
    PopUpManager.centerPopUp(summaryPopup);
    summaryPopup.owner = this;
    summaryPopup.addEventListener(CloseEvent.CLOSE,closeHandler,false,0,true);
    var rndNo:Number = Math.random();
    summaryPopup.moduleUrl = "assets/appl/exm/RecycleExmMessages.swf?mode=entry&rnd="+rndNo;       
    
} 
/**
 * Event Handler for the close event
 */
public function closeHandler(event:CloseEvent):void {
            
    //this.dispatchEvent(new Event("querySubmit"));
    //this.parentDocument.dispatchEvent(new Event("querySubmit")); 
    btnRecycle.enabled = true;
    app.submitButtonInstance = btnRecycle;
    lastSubmitBtnInstance = btnRecycle;               
}     


public function showTrashModule():void {
    var parentApp :UIComponent = UIComponent(this.parentApplication);        
    if(selectedMessageRecords.length < 1){
        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('exm.label.Trash.select.atleastone.record'));
        return;
    }
    buttonPanel.enabled = false;
    var summaryPopup:SummaryPopup;
    summaryPopup = SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
    summaryPopup.title = "Trashed - Exm Message";
    summaryPopup.width = 840;
    summaryPopup.height = 445;
    PopUpManager.centerPopUp(summaryPopup);
    summaryPopup.owner = this;
    summaryPopup.addEventListener(CloseEvent.CLOSE,closeTrashHandler,false,0,true);
    var rndNo:Number = Math.random();
    summaryPopup.moduleUrl = "assets/appl/exm/TrashExmMessages.swf?mode=entry&rnd="+rndNo;       
    
} 
/**
 * Event Handler for the close event
 */
public function closeTrashHandler(event:CloseEvent):void {
            
    //this.dispatchEvent(new Event("querySubmit"));
    //this.parentDocument.dispatchEvent(new Event("querySubmit")); 
    buttonPanel.enabled = true;
    app.submitButtonInstance = btnDelete;
    lastSubmitBtnInstance = btnDelete;               
}  
    
    
//****************** Trash Queue Functionality
    
    
public function showDeleteModule():void {
    var parentApp :UIComponent = UIComponent(this.parentApplication);        
    if(selectedMessageRecords.length < 1){
        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('exm.label.Delete.select.atleastone.record'));
        return;
    }
    trashButtonPanel.enabled = false;
    var summaryPopup:SummaryPopup;
    summaryPopup = SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
    summaryPopup.title = "Delete - Exm Message";
    summaryPopup.width = 840;
    summaryPopup.height = 445;
    PopUpManager.centerPopUp(summaryPopup);
    summaryPopup.owner = this;
    summaryPopup.addEventListener(CloseEvent.CLOSE,closeDeleteHandler,false,0,true);
    var rndNo:Number = Math.random();
    summaryPopup.moduleUrl = "assets/appl/exm/DeleteExmMessages.swf?mode=entry&rnd="+rndNo;       
    
} 
/**
 * Event Handler for the close event
 */
public function closeDeleteHandler(event:CloseEvent):void {
            
    //this.dispatchEvent(new Event("querySubmit"));
    //this.parentDocument.dispatchEvent(new Event("querySubmit")); 
    trashButtonPanel.enabled = true;
    app.submitButtonInstance = btnHardDelete;
    lastSubmitBtnInstance = btnHardDelete;               
}
/**
 *  
 */
public function showRestoreModule():void {
    var parentApp :UIComponent = UIComponent(this.parentApplication);        
    if(selectedMessageRecords.length < 1){
        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('exm.label.Restore.select.atleastone.record'));
        return;
    }
    trashButtonPanel.enabled = false;
    var summaryPopup:SummaryPopup;
    summaryPopup = SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
    summaryPopup.title = "Restore - Exm Message";
    summaryPopup.width = 840;
    summaryPopup.height = 445;
    PopUpManager.centerPopUp(summaryPopup);
    summaryPopup.owner = this;
    summaryPopup.addEventListener(CloseEvent.CLOSE,closeRestoreHandler,false,0,true);
    var rndNo:Number = Math.random();
    summaryPopup.moduleUrl = "assets/appl/exm/RestoreExmMessages.swf?mode=entry&rnd="+rndNo;       
    
} 
/**
 * Event Handler for the close event
 */
public function closeRestoreHandler(event:CloseEvent):void {
            
    //this.dispatchEvent(new Event("querySubmit"));
    //this.parentDocument.dispatchEvent(new Event("querySubmit")); 
    trashButtonPanel.enabled = true;
    app.submitButtonInstance = btnRestore;
    lastSubmitBtnInstance = btnRestore;               
}   
/**
  * This is the method to pass the Collection of data items
  * through the context to the account popup. This will be implemented as per specific  
  * requriment. 
  */
private function populateContext():ArrayCollection {
    //pass the context data to the popup
    var myContextList:ArrayCollection = new ArrayCollection();
    //passing account type
    var acTypeArray:Array = new Array(1);
    acTypeArray[0]="T|B";            
    myContextList.addItem(new HiddenObject("invActTypeContext",acTypeArray));  
    
    //passing counter party type                
    var cpTypeArray:Array = new Array(1);
    cpTypeArray[0]="INTERNAL";
    myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));

    //passing account status                
    var actStatusArray:Array = new Array(1);
    actStatusArray[0]="OPEN";
    myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
    
    return myContextList;
}
/**
 * Retrieve and return the Broker Account Number.
 */
private function  getAccNo (item:Object,column : AdvancedDataGridColumn):String {
    return item.accountNo;
} 

/**
 * Retrieve and return the Broker Account Number.
 */
private function  getInstId (item:Object,column : AdvancedDataGridColumn):String {
    return item.securityCode;
}
/**
 * Reset the query result on error and when no result is found.
 */ 
private function resetResultHeader():void{
    queryResult.removeAll();
    qh.resetPageNo();            
    qh.setPrevNextVisibility(false,false);
    qh.pdf.enabled = false;
    qh.xls.enabled = false;
    //qh.print.enabled = false;
}
/**
 *  datagrid header release event handler to handle datagridcolumn sorting
 */
public function dataGrid_headerRelease(evt:AdvancedDataGridEvent):void {                
    //sortUtil.clickedColumn=evt.dataField;
    var dg:AdvancedDataGrid = AdvancedDataGrid(evt.currentTarget);
    sortUtil.clickedColumn = dg.columns[evt.columnIndex];        
}          
/**
 * Submit the query depending on whether filter with sorting is required or not.
 *  
 * @param filterReqd flag or filter required or not.
 */
private function submitQuery(filterReqd:Boolean):void{
    this.isFilteredQuery = filterReqd;
    if(filterReqd)//Decides sorting preserving required or not.
        this.dispatchEvent(new Event('querySubmitRefresh'));             
    else
        this.dispatchEvent(new Event('querySubmit'));             
}
/**
 * Set the flag to determine Group Summary will be refresged or not in the next retrieved result.
 * Main purpose to refresh after Recycle/Trash/Restore/Delete operations.
 */
public function setRefreshAfterOpns(flag:Boolean):void{
    this.refreshAfterOpns = flag;
}