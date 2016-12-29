
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.ModulePanelLoader;
 import com.nri.rui.core.controls.QueryResultHeader;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosPopupUtils;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.stl.StlConstants;
 import com.nri.rui.stl.controls.SendNewAddFieldsPset70e;
 import com.nri.rui.stl.validators.InstructionQueryValidator;
 import com.nri.rui.stl.validators.InxReportQueryValidators;
 
 import flash.events.Event;
 import flash.utils.ByteArray;
 
 import mx.collections.ArrayCollection;
 import mx.controls.DataGrid;
 import mx.core.UIComponent;
 import mx.events.CloseEvent;
 import mx.events.ListEvent;
 import mx.events.ModuleEvent;
 import mx.events.ValidationResultEvent;
 import mx.managers.PopUpManager;
 import mx.rpc.events.ResultEvent;
 import mx.utils.ObjectUtil;
 import mx.utils.StringUtil;
 
 
     [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    private var initColl:ArrayCollection;
    [Bindable]
    public var summaryResult:ArrayCollection= new ArrayCollection();
    
    [Bindable]
    private var confirmResult:ArrayCollection= new ArrayCollection();
    
    [Bindable]
    public var opObj : String = XenosStringUtils.EMPTY_STR; 
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnFundContextItem:ArrayCollection = new ArrayCollection();
    
    [Bindable]
    public var returnOurContextItem:ArrayCollection = new ArrayCollection();
   
    [Bindable]
    public var returnCpContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var freeTextType1List:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var freeTextType2List:ArrayCollection = new ArrayCollection();
    
    //Required for Sorting
    private var sortFieldArray:Array =new Array();
    private var sortFieldArrayForInxReport:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldDataSetForInxReport:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    private var sortFieldSelectedItemForInxReport:Array =new Array();
      
    private var  csd:CustomizeSortOrder=null;
    private var  csd1:CustomizeSortOrder=null;
    
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
       
    [Bindable]private var textType1:Array = new Array();
    [Bindable]private var text1:Array = new Array();
    [Bindable]private var textType2:Array = new Array();
    [Bindable]private var text2:Array = new Array();
    
    [Bindable]private var freeTextValueForBulk:Array = new Array();
    [Bindable]private var freeTextTypeForBulk:Array = new Array();
    [Bindable]private var stlInfoPkForBulk:Array = new Array();
       
    //For check box
    [Bindable]public var selectAllBind:Boolean=false;        
    public var stlInfoObjColl : ArrayCollection=new ArrayCollection();    
    [Bindable]public var indx :int = -1;     
    [Bindable]private var mode : String = "amend";       
    public var pop:SendNewAddFieldsPset70e;     
    private var next :Boolean = false;
    private var prev : Boolean = false;
    private static var iGrid:int = 0;
    private var inxSummary3Array:Array = null;     
    [Bindable]public var opObjDisp : String = XenosStringUtils.EMPTY_STR;     
    [Bindable]public var dynaConsPset70eList:ArrayCollection = new ArrayCollection();    
    [Bindable]public var strPset70etag:String = XenosStringUtils.EMPTY_STR;
    [Bindable]public var addButtonFlag:Boolean = false;
    public var SettlementInfoPk:int = -1;    
    [Bindable]public static var stlInfoPksConcated:String = XenosStringUtils.EMPTY_STR;
    [Bindable]public static var valueDateFrom:String = XenosStringUtils.EMPTY_STR;
    private var sPopup : SummaryPopup;
	[Bindable] private var softWarningList : ArrayCollection = new ArrayCollection();
	[Bindable] private var bulkTransmitList:ArrayCollection = new ArrayCollection();
	private var helpPopup : SummaryPopup = null;
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    * This will fetch data to fill the initial form data to show the user.
    */
     private function initPageStart():void {            
        if (!initCompFlg) {    
            rndNo= Math.random();
            var req : Object = new Object();
            req.instructionScreenType = "advisoryFundSendNew";
            req.SCREEN_KEY = 13013;
            req.dynaConstraintName = StlConstants.NARRATIVE_70E;
            initializeInxQuery.request = req;        
            initializeInxQuery.url = "stl/trxMaintenanceAdvFundQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializeInxQuery.send();        
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.alreadyinitiated'));
     }
     /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * Once initial data is fetched from database to fill some form data, this method works
    * to actually show the data.
    */   
     private function initPage(event: ResultEvent) : void {     	
         var i:int = 0;
         var selIndx1:int = 0;
         var selIndx2:int = 0;
         var selIndx3:int = 0;
         var selIndx4:int = 0;
         var selIndx5:int = 0;
         
         var tempColl: ArrayCollection = new ArrayCollection();
         var sortFieldList1: ArrayCollection = new ArrayCollection();
         var sortFieldList2: ArrayCollection = new ArrayCollection();
         var sortFieldList3: ArrayCollection = new ArrayCollection();
         var sortFieldList4: ArrayCollection = new ArrayCollection();
         var sortFieldList5: ArrayCollection = new ArrayCollection();
         
        var sortField1Default:String = event.result.trxMaintenanceQueryActionForm.sortField1;
        var sortField2Default:String = event.result.trxMaintenanceQueryActionForm.sortField2;
        var sortField3Default:String = event.result.trxMaintenanceQueryActionForm.sortField3;
        var sortField4Default:String = event.result.trxMaintenanceQueryActionForm.sortField4;
        var sortField5Default:String = event.result.trxMaintenanceQueryActionForm.sortField5;                
        errPage.clearError(event); //clears the errors if any      
        inxErrPage.clearError(event);  
              
         //initiate text fields
         fundPopUp.fundCode.text = "";
         fundActPopUp.accountNo.text = "";
         swiftRefNo.text = "";
         inxRefNo.text = "";
         bankPopUp.finInstCode.text = "";
         ourActPopUp.accountNo.text = "";
         tradeRefNo.text = "";
         refNo.text = "";
         valdateFrom.text = "";
         valdateTo.text = "";
         trddateFrom.text = "";
         trddateTo.text = "";
         instPopUp.instrumentId.text="";
		//localAc.localAccountCode.text="";
         cpActPopUp.accountNo.text = "";
         ccyBox.ccyText.text = "";
         tradeCcyBox.ccyText.text = "";
        instrumentType.text = "";
        stlCcyChkBox.selected = false;
        trdCcyChkBox.selected = false;        
        cashDel.selected = false;
        cashRec.selected = false;
        dvp.selected = false;
        rvp.selected = false;
        secDel.selected = false;
        secRec.selected = false;        
        inxCreateDate.text = "";
        trxDate.text = "";	
		fundPopUpForInxQry.fundCode.text = "";
        fundActPopUpForInxQry.accountNo.text = "";
        reportRefNoForInxQry.text = "";    
		inxCreateDateForInxQry.text = "";
        trxDateForInxQry.text = "";
         
         //1. Operation Objectives Type
        if(event.result.trxMaintenanceQueryActionForm.operationObjectiveValueList.item != null) {
            if(event.result.trxMaintenanceQueryActionForm.operationObjectiveValueList.item is ArrayCollection) {
                initColl = event.result.trxMaintenanceQueryActionForm.operationObjectiveValueList.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.trxMaintenanceQueryActionForm.operationObjectiveValueList.item);
            }
        }
        tempColl = new ArrayCollection();
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);   
        }
        opObjective.dataProvider = tempColl;
        opObjectiveForInxQry.dataProvider = tempColl;
       
        
        
        //2. ACK Status
        initColl.removeAll();
        if(event.result.trxMaintenanceQueryActionForm.acceptanceStatusValueList.item != null) {
               if(event.result.trxMaintenanceQueryActionForm.acceptanceStatusValueList.item is ArrayCollection) {
                initColl = event.result.trxMaintenanceQueryActionForm.acceptanceStatusValueList.item as ArrayCollection;
            } else {
                initColl.addItem(event.result.trxMaintenanceQueryActionForm.acceptanceStatusValueList.item);
            }
        }
        
         tempColl = new ArrayCollection();
         tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        ackStatus.dataProvider = tempColl;  
        
        //Fund Category
        initColl.removeAll();
        if(event.result.trxMaintenanceQueryActionForm.fundCategoryList.item != null) {
               if(event.result.trxMaintenanceQueryActionForm.fundCategoryList.item is ArrayCollection) {
                initColl = event.result.trxMaintenanceQueryActionForm.fundCategoryList.item as ArrayCollection;
            } else {
                initColl.addItem(event.result.trxMaintenanceQueryActionForm.fundCategoryList.item);
            }
        }
        
         tempColl = new ArrayCollection();
         tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        fundCategory.dataProvider = tempColl;  
        for (i = 0; i < tempColl.length; i++) {
		   if (XenosStringUtils.equals(tempColl[i].value, "ADVISORY_FUND")){
			this.fundCategory.selectedItem = tempColl[i];
		   } 
	    }
              
        //Dispatch for Op obj
        opObjective.dispatchEvent(new ListEvent(ListEvent.CHANGE));
        
        //3. Trade Reference For
        initColl.removeAll();
        if(event.result.trxMaintenanceQueryActionForm.tradeReferenceForValues.item != null) {
            if(event.result.trxMaintenanceQueryActionForm.tradeReferenceForValues.item is ArrayCollection) {
                initColl = event.result.trxMaintenanceQueryActionForm.tradeReferenceForValues.item as ArrayCollection;
            } else {
                initColl.addItem(event.result.trxMaintenanceQueryActionForm.tradeReferenceForValues.item);
            }
        }
        
         tempColl = new ArrayCollection();
         tempColl.addItem({label:"", value: ""});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        tradeReferenceForValues.dataProvider = tempColl;
        
        //4. Settlement For
        initColl.removeAll();
        if(event.result.trxMaintenanceQueryActionForm.settleQryForList.item != null) {
            if(event.result.trxMaintenanceQueryActionForm.settleQryForList.item is ArrayCollection) {
                initColl = event.result.trxMaintenanceQueryActionForm.settleQryForList.item as ArrayCollection;
            } else {
                initColl.addItem(event.result.trxMaintenanceQueryActionForm.settleQryForList.item);
            }
        }
        
         tempColl = new ArrayCollection();
         tempColl.addItem({label:"", value: ""});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        settlementFor.dataProvider = tempColl;
        
        //5. Status
        initColl.removeAll();
        if(event.result.trxMaintenanceQueryActionForm.statusValues.item != null) {
            if(event.result.trxMaintenanceQueryActionForm.statusValues.item is ArrayCollection) {
                initColl = event.result.trxMaintenanceQueryActionForm.statusValues.item as ArrayCollection;
            } else {
                initColl.addItem(event.result.trxMaintenanceQueryActionForm.statusValues.item);
            }
        }
        
         tempColl = new ArrayCollection();
         tempColl.addItem({label:"", value: ""});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        status.dataProvider = tempColl;
       
        //6. Office Id
        initColl.removeAll();
        if(event.result.trxMaintenanceQueryActionForm.officeIdList != null) {
            if(event.result.trxMaintenanceQueryActionForm.officeIdList.officeId is ArrayCollection) {
                initColl = event.result.trxMaintenanceQueryActionForm.officeIdList.officeId as ArrayCollection;
            } else {
                initColl.addItem(event.result.trxMaintenanceQueryActionForm.officeIdList.officeId);
            }
        }
        
         tempColl = new ArrayCollection();
         tempColl.addItem(" ");
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        office.dataProvider = tempColl;
        officeForInxQry.dataProvider = tempColl;
        //7. Origin data source list
        initColl.removeAll();
        if(event.result.trxMaintenanceQueryActionForm.OriginDataSrcList.item != null) {
            if(event.result.trxMaintenanceQueryActionForm.OriginDataSrcList.item is ArrayCollection) {
                initColl = event.result.trxMaintenanceQueryActionForm.OriginDataSrcList.item as ArrayCollection;
            } else {
                initColl.addItem(event.result.trxMaintenanceQueryActionForm.OriginDataSrcList.item);
            }
        }
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:"", value: ""});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        origindatasource.dataProvider = tempColl;  
          
        //7. Value Date From
        if(!XenosStringUtils.isBlank(event.result.trxMaintenanceQueryActionForm.valueDateFrom)) {
        	valueDateFrom = event.result.trxMaintenanceQueryActionForm.valueDateFrom;
        }

        //Free Text Types List 1
        if(event.result.trxMaintenanceQueryActionForm.freeTextType1List.item != null) {
            if(event.result.trxMaintenanceQueryActionForm.freeTextType1List.item is ArrayCollection) {
                initColl = event.result.trxMaintenanceQueryActionForm.freeTextType1List.item as ArrayCollection;
            } else {
                initColl.addItem(event.result.trxMaintenanceQueryActionForm.freeTextType1List.item);
            }
        }
        
        freeTextType1List.addItem({label:"", value: ""});
        for(i = 0; i<initColl.length; i++) {
            freeTextType1List.addItem(initColl[i]);    
        }
        
        //Free Text Types List 2
        if(event.result.trxMaintenanceQueryActionForm.freeTextType2List.item != null) {
            if(event.result.trxMaintenanceQueryActionForm.freeTextType2List.item is ArrayCollection) {
                initColl = event.result.trxMaintenanceQueryActionForm.freeTextType2List.item as ArrayCollection;
            } else {
                initColl.addItem(event.result.trxMaintenanceQueryActionForm.freeTextType2List.item);
            }
        }
        
        // For 70E Narrative
        initColl.removeAll();
        if(event.result.trxMaintenanceQueryActionForm.dynaConsPset70eList != null) {
            if(event.result.trxMaintenanceQueryActionForm.dynaConsPset70eList.dynaConsPset70e is ArrayCollection) {
                initColl = event.result.trxMaintenanceQueryActionForm.dynaConsPset70eList.dynaConsPset70e as ArrayCollection;
            } else {
                initColl.addItem(event.result.trxMaintenanceQueryActionForm.dynaConsPset70eList.dynaConsPset70e);
            }
        }
        dynaConsPset70eList.addItem("");
        for(i = 0; i<initColl.length; i++) {
            dynaConsPset70eList.addItem(initColl[i]);
        }
        
        
        freeTextType2List.addItem({label:"", value: ""});
        for(i = 0; i<initColl.length; i++) {
            freeTextType2List.addItem(initColl[i]);    
        }    
        
        

        //Sort Fields        
        initColl.removeAll();
        if(event.result.trxMaintenanceQueryActionForm.sortFieldList.item != null) {
            if(event.result.trxMaintenanceQueryActionForm.sortFieldList.item is ArrayCollection) {
               initColl = event.result.trxMaintenanceQueryActionForm.sortFieldList.item as ArrayCollection;
             } else {
               initColl.addItem(event.result.trxMaintenanceQueryActionForm.sortFieldList.item);
              }
        }      
         //Prepare 3 different Lists
         sortFieldList1.addItem({label:" ", value: " "});
         sortFieldList2.addItem({label:" ", value: " "});
         sortFieldList3.addItem({label:" ", value: " "});
        
        for(i = 0; i<initColl.length; i++) {
            //Get the default value object's index
            if(XenosStringUtils.equals((initColl[i].value),sortField1Default)){                    
                selIndx1 = i;
            }else if(XenosStringUtils.equals((initColl[i].value),sortField2Default)){
                selIndx2 = i;
            }else if (XenosStringUtils.equals((initColl[i].value),sortField3Default)){
                selIndx3 = i;
            }
            sortFieldList1.addItem(initColl[i]);
            sortFieldList2.addItem(initColl[i]);
            sortFieldList3.addItem(initColl[i]);    
        }
        
        sortFieldArray[0]=sortField1;
        sortFieldArray[1]=sortField2;
        sortFieldArray[2]=sortField3;
        
        sortFieldDataSet[0]=sortFieldList1;
        sortFieldDataSet[1]=sortFieldList2;
        sortFieldDataSet[2]=sortFieldList3;
        
        sortFieldSelectedItem[0] = sortFieldList1.getItemAt(selIndx1+1);
        sortFieldSelectedItem[1] = sortFieldList2.getItemAt(selIndx2+1);
        sortFieldSelectedItem[2] = sortFieldList3.getItemAt(selIndx3+1);
        
        sortField1.dataProvider = sortFieldList1;
        sortField2.dataProvider = sortFieldList2;
        sortField3.dataProvider = sortFieldList3;
        //inxReportSortFields
        initColl.removeAll();
        if(event.result.trxMaintenanceQueryActionForm.inxReportSortFieldList.item != null) {
            if(event.result.trxMaintenanceQueryActionForm.inxReportSortFieldList.item is ArrayCollection) {
               initColl = event.result.trxMaintenanceQueryActionForm.inxReportSortFieldList.item as ArrayCollection;
             } else {
               initColl.addItem(event.result.trxMaintenanceQueryActionForm.inxReportSortFieldList.item);
              }
        }   			
         //Prepare 2 different Lists
		 
         sortFieldList4.addItem({label:" ", value: " "});
         sortFieldList5.addItem({label:" ", value: " "});        
        for(i = 0; i<initColl.length; i++) {
            //Get the default value object's index         
           if(XenosStringUtils.equals((initColl[i].value),sortField4Default)){           		
                selIndx4 = i;
            }else if (XenosStringUtils.equals((initColl[i].value),sortField5Default)){
            	
                selIndx5 = i;
            }           
            sortFieldList4.addItem(initColl[i]);
            sortFieldList5.addItem(initColl[i]);                
        }
        
        sortFieldArrayForInxReport[0]=sortField4;
        sortFieldArrayForInxReport[1]=sortField5;        
        
        sortFieldDataSetForInxReport[0]=sortFieldList4;
        sortFieldDataSetForInxReport[1]=sortFieldList5;       
        
        sortFieldSelectedItemForInxReport[0] = sortFieldList4.getItemAt(selIndx4+1);
        sortFieldSelectedItemForInxReport[1] = sortFieldList5.getItemAt(selIndx5+1);        
        
        sortField4.dataProvider = sortFieldList4;
        sortField5.dataProvider = sortFieldList5;        
        
        fundPopUp.fundCode.setFocus();
        initCompFlg = true;
         
        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd1=new CustomizeSortOrder(sortFieldArrayForInxReport,sortFieldDataSetForInxReport,sortFieldSelectedItemForInxReport);
        csd.init();        
        csd1.init();      
        stackForQry.selectedChild = qry;      
     }
     
    private function sortOrder1Update():void{
          csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{         
         csd.update(sortField2.selectedItem,1);
     } 
     private function sortOrder4Update():void{
          csd1.update(sortField4.selectedItem,0);
     }
     /**
     * Set the display settings according to the Operation Objective
     */
     private function onChangeOperationObjective(event:ListEvent):void {
     	 SettlementInfoPk = -1;
     	 stlInfoPksConcated = XenosStringUtils.EMPTY_STR;
     	 
     	 valdateFrom.text = XenosStringUtils.EMPTY_STR;
     	 
         var target : Object = event.currentTarget.selectedItem as Object;
         var strValue: String = target.value;        
         	
         if(XenosStringUtils.equals(strValue, 'SEND_NEW') 
         	|| XenosStringUtils.equals(strValue,'MARK_AS_TRANSMITTED')
         	|| XenosStringUtils.equals(strValue,'PENDING')) {
         
             inxRefNo.text = "";
             inxRefNo.editable = false;
             ackStatus.enabled = false;
         } else {
             inxRefNo.editable = true;
             ackStatus.enabled = true;
         }         
         switch(strValue){
             case 'QUERY' :             			
                         g1.includeInLayout = true;
                         g1.visible = true;                                              
                         valdateFrom.text = valueDateFrom;
						 stackForQry.selectedChild = qry;          
						 opObjective.selectedItem = target;           
						 originDataSourceOff();       
                         break;
             case 'SEND_NEW' :
                         g1.includeInLayout = true;
                         g1.visible = true;  
						 stackForQry.selectedChild = qry;
						 opObjective.selectedItem = target;
						 originDataSourceOn();
                         break;
             case 'MARK_AS_TRANSMITTED' :
                         g1.includeInLayout = true;
                         g1.visible = true;              
						 stackForQry.selectedChild = qry;
						 opObjective.selectedItem = target;
						 originDataSourceOff(); 
                         break;
             case 'RESEND' :
                         g1.includeInLayout = true;
                         g1.visible = true;              
						 stackForQry.selectedChild = qry;
						 opObjective.selectedItem = target;
						 originDataSourceOff(); 
                         break;
             case 'INX_REPORT_QUERY':             		
						stackForQry.selectedChild = inxQry;
						opObjectiveForInxQry.selectedItem = target;
						originDataSourceOff(); 					
             			break;
             default :
                         g1.includeInLayout = false;
                         g1.visible = false;
                         originDataSourceOff();
						 stackForQry.selectedChild = qry;
						 opObjective.selectedItem = target;
                         break;
         }          
     }
     
     private function bindDataGrid():void {
        //bindQryDataGrid();
        //originalCols = inxSummary.columns;
     } 
     /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindQryDataGrid(qh:QueryResultHeader, dg:DataGrid):void {
        qh.dgrid = dg;
        //copyDataGridColumns();  
     } 
    /**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {              
        this.addEventListener(ModuleEvent.UNLOAD,destroyModule);
     }
     
     private function destroyModule(event:ModuleEvent):void {
        ModulePanelLoader(this.parent.parent).info.unload();
    } 
     
         /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specific  
          * requirement. 
          */
        private function populateFundContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            var settleActTypeArray:Array = new Array(3);
                settleActTypeArray[0]="S";
                settleActTypeArray[1]="B";
                settleActTypeArray[2]="T";
            myContextList.addItem(new HiddenObject("invActTypeContext",settleActTypeArray));
        
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="INTERNAL";
               
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
            
            return myContextList;
        }
        /**
        * Deep cloning an Object
        */
        private function clone(source:Object):*
        {
            var myBA:ByteArray = new ByteArray();
            myBA.writeObject(source);
            myBA.position = 0;
            trace("clone error");
            return(myBA.readObject());
        }

         /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateOurContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            //var settleActTypeArray:Array = new Array(2);
            //    settleActTypeArray[0]="S";
            //    settleActTypeArray[1]="B";
                //passing counter party type                
            var cpTypeArray:Array = new Array(2);
                cpTypeArray[0]="BROKER";
                cpTypeArray[1]="BANK/CUSTODIAN";
                
            //myContextList.addItem(new HiddenObject("invCPTypeContext",settleActTypeArray));
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            return myContextList;
        }
        /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateCpContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            var cpTypeArray:Array = new Array(2);
                cpTypeArray[0]="BROKER";
                cpTypeArray[1]="BANK/CUSTODIAN";
                
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var cpTradActType:Array = new Array(3);
            cpTradActType[0]="T";
            cpTradActType[1]="S";
            cpTradActType[2]="B";
            myContextList.addItem(new HiddenObject("cpTradActType",cpTradActType));
            return myContextList;
        } 
        /**
          * This is the method to pass the Collection of data items
          * through the context to the FinInst popup. This will be implemented as per specifdic  
          * requirement. 
          */
        private function populateFinInstRole():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
            
            var bankRoleArray : Array = new Array(3);
            bankRoleArray[0] = "Security Broker";
            bankRoleArray[1] = "Bank/Custodian";
            bankRoleArray[2] = "Central Depository";
            myContextList.addItem(new HiddenObject("bankRoles",bankRoleArray));
            
            return myContextList;
        }
   /**
    * It sends/submits the query after validating the user input data. 
    * 
    */
     private function submitQuery():void 
     { 
          // Reset the select all
          selectAllBind = false;
          //Set the request parameters
         var requestObj :Object = populateRequestParams();
         
         inxQueryRequest.request = requestObj;         
         var myModel:Object={
                            inxQuery:{
                                 
                                 trddateFrom:this.trddateFrom.text,
                                 trddateTo:this.trddateTo.text,
                                 valuedateFrom:this.valdateFrom.text,
                                 valuedateTo:this.valdateTo.text,
                                 tradeReferenceNo : this.tradeRefNo.text,
                                 inxCreateDate : this.inxCreateDate.text,
                                 trxDate : this.trxDate.text,
                                 settleFor : this.tradeReferenceForValues.selectedItem != null ? this.tradeReferenceForValues.selectedItem.value : XenosStringUtils.EMPTY_STR,
                                 operatiobObj : this.opObjective.selectedItem != null ? this.opObjective.selectedItem.value : XenosStringUtils.EMPTY_STR,
                                 ccyBox : this.ccyBox.ccyText.text,
                                 stlCcyExclude : this.stlCcyChkBox.selected ? true : false,
                                 tradeCcyBox : this.tradeCcyBox.ccyText.text,
                                 trdCcyExclude : this.trdCcyChkBox.selected ? true : false
                            }
                           };      
         var myModelForInxReport:Object={
                            inxQuery:{
                                 inxCreateDate : this.inxCreateDateForInxQry.text,
                                 trxDate : this.trxDateForInxQry.text                                       
                            }
                           };           
         
         var validationResult:ValidationResultEvent;
         if(this.opObjectiveForInxQry.selectedItem!=null && XenosStringUtils.equals(this.opObjectiveForInxQry.selectedItem.value, 'INX_REPORT_QUERY'))
         {
         	var inxReportQueryValidator:InxReportQueryValidators = new InxReportQueryValidators();
         	inxReportQueryValidator.source=myModelForInxReport;
         	inxReportQueryValidator.property="inxQuery";
         	validationResult =inxReportQueryValidator.validate();         	
         }
         else
         {
         	var inxQueryValidator:InstructionQueryValidator = new InstructionQueryValidator();
         	inxQueryValidator.source=myModel;
         	inxQueryValidator.property="inxQuery";
         	validationResult =inxQueryValidator.validate();
         }         	
          
         if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
            if(this.transmitAll != null){
            	this.transmitAll.enabled = true;
            }
        } else{
            switch(opObj){
                  case 'SEND_NEW' :
                       qh2.resetPageNo();
                       break;
                  case 'PENDING' :
                  	   qh4.resetPageNo();
                  	   break;
                  case 'QUERY' :
                       qh1.resetPageNo();
                       break;    
                  case 'INX_REPORT_QUERY':
                  		qh5.resetPageNo();
                  		break;
                  case XenosStringUtils.EMPTY_STR :
                       break;
                  default :                  		
                       qh3.resetPageNo();
                       break;        
              }             
             if(this.opObjectiveForInxQry.selectedItem!=null && XenosStringUtils.equals(this.opObjectiveForInxQry.selectedItem.value, 'INX_REPORT_QUERY'))
             	opObj = this.opObjectiveForInxQry.selectedItem != null ? this.opObjectiveForInxQry.selectedItem.value : XenosStringUtils.EMPTY_STR;
             else
				opObj = this.opObjective.selectedItem != null ? this.opObjective.selectedItem.value : XenosStringUtils.EMPTY_STR;              	            
            trace("OPP OBJ :: " + opObj);
            decideSelectedVBoxInVStack();
            makeOpObjDisp(); 
            inxQueryRequest.send();
        }
     }
     
   private function cancatStlInfoPks():void {
   		if(SettlementInfoPk>0 && XenosStringUtils.isBlank(pop.psetValuesCombo.text)) {
        	stlInfoPksConcated = stlInfoPksConcated.concat(SettlementInfoPk,",");
        }
   }
   
   /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	var reqObj : Object = new Object();
        reqObj.method = "submitQuery";
        reqObj.SCREEN_KEY = 13014;         
        reqObj.settlementReferenceNo = this.refNo.text; 
        reqObj.senderReferenceNo = this.swiftRefNo.text; 
        reqObj.instructionReferenceNo = this.inxRefNo.text;
        reqObj.firmBankCode = this.bankPopUp.finInstCode.text;  
        reqObj.firmBankAccount = this.ourActPopUp.accountNo.text;        
        reqObj.acceptanceStatusDisp = this.ackStatus.selectedItem != null ? this.ackStatus.selectedItem.value : XenosStringUtils.EMPTY_STR;
        reqObj.tradeReferenceNo = this.tradeRefNo.text; 
        reqObj.settleFor = this.tradeReferenceForValues.selectedItem != null ? this.tradeReferenceForValues.selectedItem.value : XenosStringUtils.EMPTY_STR;
        reqObj.valueDateFrom = this.valdateFrom.text; 
        reqObj.valueDateTo = this.valdateTo.text;
        reqObj.tradeDateFrom = this.trddateFrom.text; 
        reqObj.tradeDateTo = this.trddateTo.text;  
        reqObj.securityCode = this.instPopUp.instrumentId.text;
        reqObj.instrumentType = this.instrumentType.itemCombo.text;
        reqObj.accountNo = this.cpActPopUp.accountNo.text;
//        reqObj.localAccount = this.localAc.localAccountCode.text;
        reqObj.settleQueryFor = this.settlementFor.selectedItem != null ? this.settlementFor.selectedItem.value : XenosStringUtils.EMPTY_STR;
        reqObj.settlementCcy = this.ccyBox.ccyText.text;        
        reqObj.status = this.status.selectedItem != null ? this.status.selectedItem.value : XenosStringUtils.EMPTY_STR;        
        reqObj.originDataSource = this.origindatasource.selectedItem != null ? this.origindatasource.selectedItem.value : XenosStringUtils.EMPTY_STR;
        reqObj.tradeCcy = this.tradeCcyBox.ccyText.text;
        if(this.opObjectiveForInxQry.selectedItem!=null && XenosStringUtils.equals(this.opObjectiveForInxQry.selectedItem.value, 'INX_REPORT_QUERY'))
        {
        	reqObj.fundCode = this.fundPopUpForInxQry.fundCode.text;
        	reqObj.fundAccountNo = this.fundActPopUpForInxQry.accountNo.text;
        	reqObj.officeId = this.officeForInxQry.selectedItem != null ? this.officeForInxQry.selectedItem : XenosStringUtils.EMPTY_STR;
        	reqObj.inxCreationDate = this.inxCreateDateForInxQry.text;
        	reqObj.transmissionDate = this.trxDateForInxQry.text;
        	reqObj.reportReferenceNo = this.reportRefNoForInxQry.text;        
        	reqObj.operationObjective = this.opObjectiveForInxQry.selectedItem != null ? this.opObjectiveForInxQry.selectedItem.value : XenosStringUtils.EMPTY_STR;
        }	
        else
        {
        	reqObj.officeId = this.office.selectedItem != null ? this.office.selectedItem : XenosStringUtils.EMPTY_STR;
        	reqObj.fundCode = this.fundPopUp.fundCode.text;
        	reqObj.fundAccountNo = this.fundActPopUp.accountNo.text;
        	reqObj.inxCreationDate = this.inxCreateDate.text;
        	reqObj.transmissionDate = this.trxDate.text;	
        	reqObj.operationObjective = this.opObjective.selectedItem != null ? this.opObjective.selectedItem.value : XenosStringUtils.EMPTY_STR;
        }
        if(stlCcyChkBox.selected) {
        	reqObj.stlCcyExclude = this.stlCcyChkBox.name;
        } else {
        	reqObj.stlCcyExclude = XenosStringUtils.EMPTY_STR;
        }
        
        if(trdCcyChkBox.selected) {
        	reqObj.trdCcyExclude = this.trdCcyChkBox.name;
        } else {
        	reqObj.trdCcyExclude = XenosStringUtils.EMPTY_STR;
        }
        
        
        var instructionTypeArray:Array = new Array();
            if(cashDel.selected)
                instructionTypeArray.push(cashDel.name);
            if(cashRec.selected)
                instructionTypeArray.push(cashRec.name);
            if(dvp.selected)
                instructionTypeArray.push(dvp.name);
            if(rvp.selected)
                instructionTypeArray.push(rvp.name);
            if(secDel.selected)
                instructionTypeArray.push(secDel.name);
            if(secRec.selected)
                instructionTypeArray.push(secRec.name);
                
        reqObj.instructionTypeArray = instructionTypeArray;
        
        reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField4 = this.sortField4.selectedItem != null ? StringUtil.trim(this.sortField4.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField5 = this.sortField5.selectedItem != null ? StringUtil.trim(this.sortField5.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.rnd = Math.random() + "";
        
        if(XenosStringUtils.equals(opObj, "SEND_NEW")) {
        	cancatStlInfoPks();
        }
        reqObj.stlInfoPksConcated = stlInfoPksConcated;
        reqObj.fundCategory = this.fundCategory.selectedItem != null ? StringUtil.trim(this.fundCategory.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        
        return reqObj;
    }
    
    /**
     * This method works as the result handler of the Submit Query Http Services.
     * This also takes care of the buttons/images to be shown on the top panel of the
     * result .
     */
     private function loadSummaryPage(event:ResultEvent):void {     	
         resetPrevNext();
         
         var rs:XML = XML(event.result);

        if (null != event) {
            if(rs.child("row").length()>0) {
                
                changeState();
                
                errPage.clearError(event);
                summaryResult.removeAll();
                
                try {
                    for each ( var rec:XML in rs.row ) {
                        summaryResult.addItem(rec);
                    }
                    
                    //modifySummaryResult();
                    prev = (rs.prevTraversable == "true")?true:false;
                    next = (rs.nextTraversable == "true")?true:false;
                    
                    var strStatistics:String = 'Total : '+summaryResult[0].totalRecordsFetched+
                                                    ' Transmitted : '+summaryResult[0].totalTransmitted+
                                                    '(Ack : '+summaryResult[0].totalOriginalAck+') Unsent : '+summaryResult[0].totalUnsent+
                                                    '\nCopy Transmitted : '+summaryResult[0].totalCopyTransmitted+
                                                    '(Ack : '+summaryResult[0].totalCopyAck+')';
                    
                    var strStatisticsSendNew:String = 'Total:'+summaryResult[0].totalRecordsFetched+
                    								  '; Cancel:'+summaryResult[0].totalCancel+
                    								  '; \nPending:'+summaryResult[0].totalPending+
                    								  '; (Unknown CPSSI:'+summaryResult[0].totalUnknownCpSsi+
                    								  '; PreferredCode Not Set:'+summaryResult[0].totalPrefcodeNotset+
                    								  '; Others:'+summaryResult[0].totalPsetNotset+
                    								  '; 70E Tag:'+summaryResult[0].totalPset70tag+
                    								  ')';
                    
                    var strStatisticsPending:String = 'Total:'+summaryResult[0].totalRecordsFetched+
                    								  '; \n(Unknown CPSSI:'+summaryResult[0].totalUnknownCpSsi+
                    								  '; PreferredCode Not Set:'+summaryResult[0].totalPrefcodeNotset+
                    								  '; Others:'+summaryResult[0].totalPsetNotset+
                    								  '; 70E Tag:'+summaryResult[0].totalPset70tag+
                    								  ')';
                   
                   var strNormalStatistics:String = '[Swift related Number]\tTotal(Normal):' + summaryResult[0].normalTotal +
                                                ' Transmitted:' + summaryResult[0].normalTransmittedTotal + '(Ack:' + 
                                                summaryResult[0].normalAckTotal + ') Unsent:' + summaryResult[0].normalUnsentTotal + 
                                                ' Copy Transmitted:' + summaryResult[0].normalCopyTransmittedTotal + '(Ack:' + 
                                                summaryResult[0].normalCopyAckTotal + ')\n';
                   var strCancelStatistics:String = '\t\t\t\t\t\t\tTotal(Cancel):' + summaryResult[0].cancelTotal +
                                                ' Transmitted:' + summaryResult[0].cancelTransmittedTotal + '(Ack:' + 
                                                summaryResult[0].cancelAckTotal + ') Unsent:' + summaryResult[0].cancelUnsentTotal + 
                                                ' Copy Transmitted:' + summaryResult[0].cancelCopyTransmittedTotal + '(Ack:' + 
                                                summaryResult[0].cancelCopyAckTotal + ')';
                    
                                       
                    if(XenosStringUtils.equals(opObj, "QUERY")) {
//                        qh1.recordCount.text = strStatistics;
                        swiftNormal.text = strNormalStatistics+strCancelStatistics;
                    } else if(XenosStringUtils.equals(opObj, "RESEND")
                              || XenosStringUtils.equals(opObj, "MESSAGE_CANCELLATION")
                              || XenosStringUtils.equals(opObj, "RESET_LIVE_INSTRUCTION")) {
                        qh3.recordCount.text = strStatistics;
                        if(iGrid==0) {
                            inxSummary3Array=inxSummary3.columns;
                        } else {
                            inxSummary3.columns = inxSummary3Array;
                        }
                        ++iGrid;
                    } else if(XenosStringUtils.equals(opObj, "SEND_NEW")) {
						/**
						 * Enable Duplicate button when when duplicate record found
						 */
						softWarningList.removeAll();
						if( summaryResult.length> 0  && parseInt(summaryResult[0].maxDupCount)>1){
							
							softWarningList.addItem( this.parentApplication.xResourceManager.getKeyValue(
											'stl.inst.dup.trd.softwarning.msg',
											new Array( this.parentApplication.xResourceManager.getKeyValue('stl.label.inx.duplecate') )
											)
									);
							softWarning.showWarning(softWarningList);
							this.duplicatebtn.includeInLayout = true;
							this.duplicatebtn.visible = true;
							this.sendNewDispText.includeInLayout = true;
							this.sendNewDispText.visible = true;
							this.sendNewDispTextOriginal.includeInLayout = false;
							this.sendNewDispTextOriginal.visible = false;
						}else{
							softWarning.removeWarning();
							this.sendNewDispText.includeInLayout = false;
							this.sendNewDispText.visible = false;
							this.sendNewDispTextOriginal.includeInLayout = true;
							this.sendNewDispTextOriginal.visible = true;
							
							this.duplicatebtn.includeInLayout = false;
							this.duplicatebtn.visible = false;
							
						}
                        
                        qh2.recordCount.text = strStatisticsSendNew;
                        qh2.recordCount.minWidth = 620;
                        for(var t:int=0;t<summaryResult.length;++t) {
                        	textType1[t] = summaryResult[t].freeTextType;
                        	text1[t]     = summaryResult[t].freeTextValue;
                        	if(!XenosStringUtils.isBlank(summaryResult[t].freeTextValue)) {
                        		freeTextTypeForBulk[t] 		= summaryResult[t].freeTextType;
                        		freeTextValueForBulk[t]     = summaryResult[t].freeTextValue;
                        		stlInfoPkForBulk[t]			= summaryResult[t].settlementInfoPk;
                        	} else {
                        		freeTextTypeForBulk[t] 		= XenosStringUtils.EMPTY_STR;
                        		freeTextValueForBulk[t]     = XenosStringUtils.EMPTY_STR;
                        		stlInfoPkForBulk[t]			= XenosStringUtils.EMPTY_STR;
                        	}
                        }
                        
                    } else if(XenosStringUtils.equals(opObj, "PENDING")) {
                    	qh4.recordCount.text = strStatisticsPending;
                    	qh4.recordCount.minWidth = 620;
                    } else if(XenosStringUtils.equals(opObj, "MARK_AS_TRANSMITTED")) {
                        qh3.recordCount.text = XenosStringUtils.EMPTY_STR;
                        if(iGrid==0) {
                            inxSummary3Array=inxSummary3.columns;
                        }
                        ++iGrid;
                        inxSummary3.columns = removeColumn(inxSummary3.columns,'View');
                    }
                    
                    if(summaryResult.length==1 
                            && XenosStringUtils.equals(opObj, "QUERY")) {
                         XenosPopupUtils.showSettlementDetails(summaryResult[0].settlementInfoPk, 
                                                               UIComponent(this.parentApplication),
                                                               this.parentApplication.xResourceManager.getKeyValue('stl.stlqry.label.settlementviewheader'), 
                                                               "Instruction");
                     }
                } catch(e:Error) {
                    trace(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred')+e);
                    XenosAlert.error(e.getStackTrace());
                }
                try{
                    opObjSpecificDgChanges(prev,next);
                    if (XenosStringUtils.equals(opObj, 'SEND_NEW')) {
                        errPage2.removeError();
                    } else if(XenosStringUtils.equals(opObj, 'PENDING')) {
                    	errPage4.removeError();
                    } else if (XenosStringUtils.equals(opObj, 'QUERY')) {
                        // nothing to do
                    } else if(XenosStringUtils.equals(opObj, 'INX_REPORT_QUERY')){
                    	errPage5.removeError();
                    }else {
                        errPage3.removeError();                     
                    }
                } catch(e:Error) {                
                    trace(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred')+e);
                }
            } else {
                 if(rs.child("Errors").length()>0) {
                    //some error found
                    summaryResult.removeAll(); // clear previous data if any as there is no result now.
                    var errorInfoList : ArrayCollection = new ArrayCollection();
                    //populate the error info list                  
                    for each ( var error:XML in rs.Errors.error ) {
                        errorInfoList.addItem(error.toString());
                    }
                    errPage.showError(errorInfoList);//Display the error
                    
                } else {
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                    summaryResult.removeAll(); // clear previous data if any as there is no result now.
                    errPage.clearError(event); //clears the error if any
                    if(XenosStringUtils.equals(opObj, "RESEND")
                              || XenosStringUtils.equals(opObj, "MESSAGE_CANCELLATION")
                              || XenosStringUtils.equals(opObj, "RESET_LIVE_INSTRUCTION")) {
                        qh3.recordCount.text = '\tTotal : 0\t\tTransmitted : 0(Ack : 0)\t\tUnsent : 0\t\tCopy Transmitted : 0(Ack : 0)';
                    } else if(XenosStringUtils.equals(opObj, "SEND_NEW")) {
                    	qh2.recordCount.text = '\tTotal: 0; Pending: 0; (Unknown CP SSI: 0; Preferred Code Not Set:0)';
                    } else if(XenosStringUtils.equals(opObj, "PENDING")) {
                    	qh4.recordCount.text = '\tTotal: 0; (Unknown CP SSI: 0; Preferred Code Not Set:0)';
                    }
                }
                opObj = XenosStringUtils.EMPTY_STR;
            }
            /**
            *	Focus to Submit Button when no record found. 
            */
            app.submitButtonInstance = submit;
            
            
            
            //replace null references in datagrid for sorting           
            //processDataForSorting();         
            resetSellection(summaryResult);
            //refresh the results.       
            summaryResult.refresh();
            
        } else {
            summaryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
        
        if(this.transmitAll != null){
        	this.transmitAll.enabled = true;
        }
     }
     
     private function resetPrevNext():void{
         prev = false;
         next = false;
     }
     /**
     * This function removes any column as specified.
     */
     private function removeColumn(gridArr:Array,columnHeaderText:String):Array {
         var y:int = -1;
         for(var x:int=0;x<gridArr.length;++x) {
             if(gridArr[x].headerText==columnHeaderText) {
                 y=x;
                 break;
             }
         }
         //XenosAlert.info("y="+y);
         if(y>-1) {
             gridArr.splice(y,1);
         }
         return gridArr;
     }
     
     private function setVisibleQh(qh : QueryResultHeader):void{     	
         if(qh!=null){
         	if(!XenosStringUtils.equals(opObj, 'INX_REPORT_QUERY')) {
            	qh.setOnResultVisibility();
          	}
            qh.setPrevNextVisibility(prev,next);
            qh.PopulateDefaultVisibleColumns();
            addLabelToBtn();
         }
     }
     /**
     * Changes the current State of the View Stack
     * Also changes the btn label and the handler
     */
     private function changeCurrentState():void{
           currentState = "result";
           switch(opObj){
               case 'SEND_NEW' :
                       stack.selectedChild = sendNew;
                       app.submitButtonInstance = transmit;
                       break;
               case 'PENDING' :
                	   stack.selectedChild = pending;
                       //app.submitButtonInstance = transmit;
                       break;
               case 'QUERY' :
                    stack.selectedChild = query;
                    app.submitButtonInstance = null;
                       break;    
               default :
                       trace(opObj);
                       //addLabelToBtn();
                       stack.selectedChild = other;
                       app.submitButtonInstance = btnInxOp;
                       break;        
           }
        }
        
        private function changeState():void{
           currentState = "result";
           switch(opObj){
               case 'SEND_NEW' :
                       app.submitButtonInstance = transmit;
                       break;
               case 'PENDING' :
                       app.submitButtonInstance = null;
                       break;
               case 'QUERY' :
                       app.submitButtonInstance = null;
                       break; 
               case 'INX_REPORT_QUERY':
               		  app.submitButtonInstance = null;
                      break; 
               default :
                       trace(opObj);
                       app.submitButtonInstance = btnInxOp;
                       break;        
           }
        }
        
        private function decideSelectedVBoxInVStack():void {
        	switch(opObj) {
                   case 'SEND_NEW' :
                           stack.selectedChild = sendNew;
                           break;
                   case 'PENDING' :
                           stack.selectedChild = pending;
                           break;
               	   case 'QUERY' :
                           stack.selectedChild = query;
                           break;    
                   case 'INX_REPORT_QUERY' :
                           stack.selectedChild = inxReportQuery;
                           break;    
                   default :
                           trace(opObj);
                           stack.selectedChild = other;
                           break;        
           }
        }
        
        private function makeOpObjDisp() : void {
            switch(opObj) {
                case 'SEND_NEW' :
                    opObjDisp = 'SEND NEW';
                    break;
                case 'PENDING' :
                	opObjDisp = 'PENDING';
                    break;
                case 'MESSAGE_CANCELLATION' :
                    opObjDisp = 'MESSAGE CANCELLATION';
                    break;
                case 'RESET_LIVE_INSTRUCTION' :
                    opObjDisp = 'RESET LIVE INSTRUCTION';
                    break;
                case 'MARK_AS_TRANSMITTED' :
                    opObjDisp = 'MARK AS TRANSMITTED';
                    break;
                case 'INX_REPORT_QUERY' :
                    opObjDisp = 'INX REPORT QUERY';
                    break;
                default :
                    opObjDisp = opObj;
                    break;      
           }            
        }
        
        private function clearState():void{
            currentState = '';
            app.submitButtonInstance = submit;
        }
      /** 
      * Gives the label to the button for Resend and other
      * operations and adds the Event Handler properly
      */  
      private function addLabelToBtn():void {
          if(btnInxOp != null){
              switch(opObj){
                  
                  case 'RESEND' :
                          btnInxOp.label = this.parentApplication.xResourceManager.getKeyValue('stl.label.inx.resend');
                          break;
                  case 'MESSAGE_CANCELLATION' :
                          btnInxOp.label = this.parentApplication.xResourceManager.getKeyValue('stl.label.inx.cxltransmit');
                          break;
                  case 'RESET_LIVE_INSTRUCTION' :
                          btnInxOp.label = this.parentApplication.xResourceManager.getKeyValue('stl.label.inx.cxlliveinx');
                          break;
                  case 'MARK_AS_TRANSMITTED' :
                          btnInxOp.label = this.parentApplication.xResourceManager.getKeyValue('stl.label.inx.markastransmit');
                          break;
              }
          }
      }
      
      private function validateRecords():void{
          if(stlInfoObjColl.length == 0) {
              XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.selectatleastonerecord'));
          } else {
          	 
              var item:Object = null;
              var stlInfoPkArray:Array = new Array();
              var stlInstructionRefNoSelArray:Array = new Array();
              
              for(var i:int=0; i<stlInfoObjColl.length; i++){
                  item=stlInfoObjColl[i];
                  stlInfoPkArray[i] = !XenosStringUtils.isBlank(item.settlementInfoPk)? item.settlementInfoPk : null;
                  stlInstructionRefNoSelArray[i] = !XenosStringUtils.isBlank(item.instructionRefNo)? item.instructionRefNo : null;
              }
              var reqObj : Object = new Object();
              reqObj.method = "confirm"; 
              reqObj.instructionScreenType = "advisoryFundSendNew";
              reqObj.stlInfoPkArray = stlInfoPkArray;
              reqObj.stlInstructionRefNoSelectedArray = stlInstructionRefNoSelArray;
              reqObj.rnd = Math.random()+"";
              reqObj.SCREEN_KEY = 13016;
              inxDetailConfirmRequest.request = reqObj;
              inxDetailConfirmRequest.send();
          }
      }  
      
      private function confirmHandler(event:ResultEvent):void {          
          var rs:XML = XML(event.result);
           
        if (null != event) {
            if(rs.child("row").length()>0) {
                confirmResult.removeAll();
                if(XenosStringUtils.equals(opObj,'SEND_NEW')) {
                    errPage2.clearError(event); //clears the errors if any
                } else if(XenosStringUtils.equals(opObj,'PENDING')) {
                	errPage4.clearError(event); //clears the errors if any
                } else {
                    errPage3.clearError(event); //clears the errors if any
                } 
                
                try {
                    for each ( var rec:XML in rs.row ) {
                        confirmResult.addItem(rec);
                    }
                } catch(e:Error) {
                    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                }
            } else if(rs.child("Errors").length()>0) {
                //some error found
                confirmResult.removeAll(); // clear previous data if any as there is no result now.
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list                  
                for each ( var error:XML in rs.Errors.error ) {
                    errorInfoList.addItem(error.toString());
                }
                if(XenosStringUtils.equals(opObj,'SEND_NEW')) {
                    errPage2.showError(errorInfoList);//Display the error
                } else if(XenosStringUtils.equals(opObj,'PENDING')) {
                	errPage4.showError(errorInfoList);//Display the error
                } else {
                    errPage3.showError(errorInfoList);//Display the error
                } 
                return;
            } else {
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                confirmResult.removeAll(); // clear previous data if any as there is no result now.
                if(XenosStringUtils.equals(opObj,'SEND_NEW')) {
                    errPage2.clearError(event); //clears the errors if any
                } else if(XenosStringUtils.equals(opObj,'PENDING')) {
                	errPage4.clearError(event); //clears the errors if any
                } else {
                    errPage3.clearError(event); //clears the errors if any
                }
            }
        } else {
            confirmResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
          
          trxpop = TrxConfirmAdvFund(PopUpManager.createPopUp(this, TrxConfirmAdvFund, true));

        
        trxpop.width = this.parentApplication.width - 100;
            
        trxpop.dProvider = confirmResult;
        trxpop.operationObj = opObj;
        trxpop.formData = rs;
        
        if(rs.child("FailInstructionList").length()>0) {
            var failedInxList:XMLList = rs.child("FailInstructionList"); 
            if(failedInxList.child("FailInstruction").length()>0) {
                trxpop.failInstructionList = new ArrayCollection();
                for each ( var record:XML in failedInxList.FailInstruction) {
                    trxpop.failInstructionList.addItem(record);
                }
            }
        }
        
        trxpop.title = this.parentApplication.xResourceManager.getKeyValue('stl.stlinxadvfund.lbl.confirm');
        trxpop.addEventListener("OkSystemConfirm",handleOkSystemConfirm);
            
        PopUpManager.centerPopUp(trxpop);
     }

    /**
     * Event Handler for the custom event "OkSystemConfirm" refreshes the query page
     */
    public function handleOkSystemConfirm(event:Event):void {              
        submitQuery();
    }         
      
     /**
     * This method will set the visibility of the buttons of the queryResultHeader
     * on receiving the result of the query
     */
     private function opObjSpecificDgChanges(prev:Boolean,next:Boolean):void{     	
         switch(opObj){
                    case 'SEND_NEW' : 
                        modifySummaryResult();
                        qh2.setOnResultVisibility();
                        qh2.setPrevNextVisibility(prev,next);
                        qh2.PopulateDefaultVisibleColumns();
                        break;
                     case 'PENDING' :
                     	modifySummaryResult();
                        qh4.setOnResultVisibility();
                        qh4.setPrevNextVisibility(prev,next);
                        qh4.PopulateDefaultVisibleColumns();
                    case 'QUERY' :
                        qh1.setOnResultVisibility();
                        qh1.setPrevNextVisibility(prev,next);
                        qh1.PopulateDefaultVisibleColumns();    
                        break;
                    case 'INX_REPORT_QUERY':
                    	qh5.pdf.enabled=false;
                    	qh5.xls.enabled=false;                  	
                    	qh5.setPrevNextVisibility(prev,next);
                        qh5.PopulateDefaultVisibleColumns();
                        break;                        
                    default :
                        modifySummaryResult();
                        qh3.setOnResultVisibility();
                        qh3.setPrevNextVisibility(prev,next);
                        qh3.PopulateDefaultVisibleColumns();    
                        break;
                }
     }
      private function originDataSourceOn():void {
      	
      	origindatasourceLabel.includeInLayout = true;
        origindatasourceLabel.visible = true;
        origindatasource.includeInLayout = true;
        origindatasource.visible = true;
      }
      private function originDataSourceOff():void{

      	origindatasourceLabel.includeInLayout = false;
        origindatasourceLabel.visible = false;
        origindatasource.includeInLayout = false;
        origindatasource.visible = false;
      }
     private function modifySummaryResult():void {     	
         var i :int = 0;
         switch(opObj){
             case 'SEND_NEW' :
                 //trace("send new modify results");
                 for(;i<summaryResult.length;i++){
                     summaryResult[i].selected = false;
                     summaryResult[i].freeTextType1 = XenosStringUtils.EMPTY_STR;
                     summaryResult[i].freeText1 = XenosStringUtils.EMPTY_STR;
                     summaryResult[i].freeTextType2 = XenosStringUtils.EMPTY_STR;
                     summaryResult[i].freeText2 = XenosStringUtils.EMPTY_STR;
                     
                 //    trace("i = "+i+":"+summaryResult[i].selected+":"+summaryResult[i].freeTextType1+":"+summaryResult[i].freeText1+":"+summaryResult[i].freeTextType2);
                 }
                 break;
                 
                 case 'PENDING' :
                 	//trace("pending modify results");
	                 for(;i<summaryResult.length;i++){
	                     summaryResult[i].selected = false;
	                     summaryResult[i].freeTextType1 = XenosStringUtils.EMPTY_STR;
	                     summaryResult[i].freeText1 = XenosStringUtils.EMPTY_STR;
	                     summaryResult[i].freeTextType2 = XenosStringUtils.EMPTY_STR;
	                     summaryResult[i].freeText2 = XenosStringUtils.EMPTY_STR;
	                     
	                 //    trace("i = "+i+":"+summaryResult[i].selected+":"+summaryResult[i].freeTextType1+":"+summaryResult[i].freeText1+":"+summaryResult[i].freeTextType2);
	                 }
	                 break;
                 case 'MARK_AS_TRANSMITTED' :
                     for(;i<summaryResult.length;i++){
                         summaryResult[i].selected = false;
                     }
                 if(iGrid==0) {
                    inxSummary3Array=inxSummary3.columns;
                }
                ++iGrid;
                 var cols:Array = removeColumn(inxSummary3.columns,this.parentApplication.xResourceManager.getKeyValue('stl.label.copy'));           
                 inxSummary3.columns = removeColumn(cols,this.parentApplication.xResourceManager.getKeyValue('stl.label.instructionreferenceno'));             
                 break;
             default :
                 for(;i<summaryResult.length;i++){
                         summaryResult[i].selected = false;
                 }
                 if(iGrid==0) {
                    inxSummary3Array=inxSummary3.columns;
                } else {
                    inxSummary3.columns = inxSummary3Array;
                }
                ++iGrid;                
                 break;
         }
     }    
     
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
         var url : String = "stl/trxMaintenanceAdvFundQueryDispatch.action?method=generateXLS";
        var request:URLRequest = new URLRequest(url);
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
    } 
    /**
    * This will generate the Pdf report for the entire query result set 
    * and will open in a separate window.
    */
     private function generatePdf():void {
        var url : String = "stl/trxMaintenanceAdvFundQueryDispatch.action?method=generatePDF";
        var request:URLRequest = new URLRequest(url);
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
    } 
    /**
    * This is for the Print button which at a  time will print all the data 
    * in the dataprovider of the Datagrid object
    */
     private function doPrint():void{
        /* var printObject:XenosPrintView = new XenosPrintView();
        printObject.frmPrintHeader.lbl.text = "Cam Movement Query";
        printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
        PrintDG.printAll(printObject); */
    } 
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        inxQueryRequest.request = reqObj;
        inxQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        inxQueryRequest.request = reqObj;
        inxQueryRequest.send();
    }   
   /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void {         
         //XenosAlert.info("resetQuery");
         var reqObj : Object = new Object();
         reqObj.method = "resetQuery";
         reqObj.rnd = Math.random()+"";
         inxQueryResetRequest.request = reqObj;
         inxQueryResetRequest.send();
    } 
    
    private function resetSellection(summaryResult:ArrayCollection):void{
        stlInfoObjColl.removeAll();

        for(var i:int=0;i<summaryResult.length;i++){
            summaryResult[i].selected = false;
            addOrRemove(summaryResult[i],i);
        }
        summaryResult.refresh();
    }
  
    //This as file contains code specific to the Check Box Selections.    
    
    public function selectAllRecs(flag:Boolean): void {
        var i:Number = 0;
        stlInfoObjColl.removeAll();
        for(i=0; i<summaryResult.length; i++){
            var obj:XML=summaryResult[i];
            
            if(XenosStringUtils.equals(obj.operationObjective,StlConstants.SEND_NEW)) {
            	
            	if(!XenosStringUtils.equals(obj.unknownCpSsi,Globals.DATABASE_YES) 
            	&& (XenosStringUtils.isBlank(obj.preferredCodetypeNotset))
            	&& (XenosStringUtils.isBlank(obj.pset70tag))
            	&& (XenosStringUtils.isBlank(obj.psetNotset))) {
	            	obj.selected = flag;
	            }
            } else {
            	obj.selected = flag;
            }
            
            summaryResult[i]=obj;
                                                
            summaryResult.refresh();            
            addOrRemove(summaryResult[i],i);
        }
        summaryResult.refresh();
        this.invalidateDisplayList();        
        //trace("stlInfoArray = "+ stlInfoObjColl);
        
     }
    
    /**
    * Determines whether the record needs to be added 
    * or deleted according the selected value of teh Check Box.
    */ 
    private function addOrRemove(item:Object,ix : int):void {
        var i:Number;
        
        if(item.selected == true || item.selected == 'true') { 
            stlInfoObjColl.addItem(getExtractedObject(item));         
        } else { //needs to pop
            if(stlInfoObjColl.length <= 0)
                return;
            var tempStlInfoObjs:ArrayCollection = new ArrayCollection();
            var tmpObj:Object;
            
            //trace("stlInfoObjColl.length : " + stlInfoObjColl.length);
            for(i=0; i<stlInfoObjColl.length; i++){
                tmpObj = stlInfoObjColl.getItemAt(i); 
                //trace("item.settlementInfoPk" + item.settlementInfoPk + " tmpObj.settlementInfoPk = " + tmpObj.settlementInfoPk);
                //trace("item.instructionRefNo = [" + item.instructionRefNo + "] tmpObj.instructionRefNo = [" + tmpObj.instructionRefNo +"]");                
                if(!((tmpObj.settlementInfoPk == item.settlementInfoPk) && XenosStringUtils.equals(tmpObj.instructionRefNo, item.instructionRefNo))){
                    tempStlInfoObjs.addItem(tmpObj);
                    //trace("ADDED ::: item.settlementInfoPk" + item.settlementInfoPk + " item.instructionRefNo = " + item.instructionRefNo);
                }
            }
            stlInfoObjColl.removeAll();
            stlInfoObjColl = null;
            stlInfoObjColl = tempStlInfoObjs;            
        }           
    }
    /**
    * This function will be called when user clicks the "OK"
    * after selecting the free Text fields. It has to update the 
    * item in the stlInfoPk list.
    */ 
    private function addForFreeFields(item:Object):void{
        
           //trace("addForFreeFields: index"+indx);
           //stlInfoPks[indx] = item.settlementInfoPk;
           text1[indx]= item.freeText;
           textType1[indx] = item.freeTextType;
           /*text2[indx] = item.freeText2;
           textType2[indx] = item.freeTextType2;*/
    }
    
    public function checkSelectToModify(item:Object,ix:int):void {
           //trace("checkSelectToModify: index"+ix);
           addOrRemove(item,ix);
        setIfAllSelected();                
    }
    
    private function setIfAllSelected() : void {
        if(isAllSelected()){
            selectAllBind=true;
        } else {
            selectAllBind=false;
        }
    } 
    private function isAllSelected(): Boolean {
        var i:Number = 0;            
        if(summaryResult == null){
            return false;
        }
            
        for(i=0; i<summaryResult.length; i++){
            if(summaryResult[i].selected == false || summaryResult[i].selected == 'false') {
                return false;
            }
        }
        if(i == summaryResult.length) {
            return true;
         }else {            
            return false;                
        }
    } 
   
   private function populate70eNarrativeDropdown():void {
   	
   	var reqObj : Object = new Object();
    reqObj.method = "populatePset70eNarrative";
    reqObj.dynaConstraintName = StlConstants.NARRATIVE_70E;
   	populatePset70eNarrative.request = reqObj;
   	populatePset70eNarrative.send();
   }
   
   private function loadValuesForDropDown(event:ResultEvent):void {
   	// For 70E Narrative
        initColl.removeAll();
        if(event.result.trxMaintenanceQueryActionForm.dynaConsPset70eList != null) {
            if(event.result.trxMaintenanceQueryActionForm.dynaConsPset70eList.dynaConsPset70e is ArrayCollection) {
                initColl = event.result.trxMaintenanceQueryActionForm.dynaConsPset70eList.dynaConsPset70e as ArrayCollection;
            } else {
                initColl.addItem(event.result.trxMaintenanceQueryActionForm.dynaConsPset70eList.dynaConsPset70e);
            }
        }
        dynaConsPset70eList.removeAll();
        dynaConsPset70eList.addItem("");
        for(var t:int = 0; t<initColl.length; t++) {
            dynaConsPset70eList.addItem(initColl[t]);
        }
   }
   
   
   public function displayForm(event:Event,index:int, stlInfoPk:int):void {
   		
   		//XenosAlert.info("*** stlInfoPk = "+stlInfoPk);
        populate70eNarrativeDropdown();
        
        SettlementInfoPk = stlInfoPk;
        
        pop = SendNewAddFieldsPset70e(
                    PopUpManager.createPopUp(this, SendNewAddFieldsPset70e, true));
       // pop.title="Add Fields";
        pop.title=this.parentApplication.xResourceManager.getKeyValue('stl.label.inx.addfields');
        
        pop["cancelButton"].addEventListener("click", removeMe);    
        pop["okButton"].addEventListener("click", submitPset70eData);   
        
        pop.pset70eList = dynaConsPset70eList;
        
        pop.width = this.parentApplication.width - 275;
                
        /*pop.freeList1 = freeTextType1List;
        pop.freeList2 = freeTextType2List;*/
        
        PopUpManager.centerPopUp(pop);
    }
    // Cancel button click event listener.
    private function removeMe(event:Event):void {
        SettlementInfoPk = -1;
        PopUpManager.removePopUp(pop);
    }
    
    private function handleUpdateComplete(e:Event,grids:DataGrid):void
    {
        var currLen:uint = grids.dataProvider.length;
        grids.scrollToIndex(currLen);
    }
    /*
    private function submitData(event:Event):void {
        var str1 : String = pop.cb1.selectedItem != null ? pop.cb1.selectedItem.value : XenosStringUtils.EMPTY_STR;
        var str2 : String = pop.cb2.selectedItem != null ? pop.cb2.selectedItem.value : XenosStringUtils.EMPTY_STR;
        var tt1 : String = String(pop.t1.text);
        var tt2 : String = String(pop.t2.text);
        //var flag:Boolean = false;
        
        if(XenosStringUtils.equals(str1,str2) && !XenosStringUtils.isBlank(str1) && !XenosStringUtils.isBlank(str2)){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.pleasechoosedifferentvalue'));
        }else if(XenosStringUtils.isBlank(str1) && !XenosStringUtils.isBlank(tt1)){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.improperfieldtype1'));
        }else if(XenosStringUtils.isBlank(tt1) && !XenosStringUtils.isBlank(str1)){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.improperfieldtype1'));
        }else if(XenosStringUtils.isBlank(str2) && !XenosStringUtils.isBlank(tt2)){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.improperfieldtype2'));
        }else if(XenosStringUtils.isBlank(tt2) && !XenosStringUtils.isBlank(str2)){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.improperfieldtype2'));
        }else{
            
            //Set the values.
            summaryResult[indx].freeTextType1 = str1;
             summaryResult[indx].freeText1 = tt1;
             summaryResult[indx].freeTextType2 = str2;
             summaryResult[indx].freeText2 = tt2;
             
             //Refresh the ArrayCollection
             summaryResult.refresh();
             //Add the Free Fields
             addForFreeFields(summaryResult[indx]);
             removeMe(null); 
        }
    }
    */
    private function submitPset70eData(event:Event):void {
    	
    	strPset70etag = StlConstants.NARRATIVE_70E;
    	
        var reqObj : Object = new Object();
        reqObj.method = "addPset70eNarrative";
        reqObj.dynaPsetName = StlConstants.NARRATIVE_70E;
        reqObj.dynaPsetValue = StringUtil.trim(pop.psetValuesCombo.text);
        reqObj.stlInfoPk = SettlementInfoPk;
        
        addPset70eNarrative.request = reqObj;
        addPset70eNarrative.send();
        //this.summaryResult.refresh();
        
    	closePopUp();
    }
    
    private function closePopUp():void {
    	PopUpManager.removePopUp(pop);
    }
        
    /**
     * Fixes null references in the query result data. 
     * Required for sorting by clicking on column headers. 
     * 
     */    
    private function processDataForSorting():void { 
            var columns:Array=null;       
            if(ObjectUtil.stringCompare("SEND_NEW",opObj)==0) {                       
                columns=new Array("valueDateStr","cpTradingAccount","localAccountNo","deliverReceiveDisplay",
                                  "instrumentCode","altSecurityCode","instructionQuantityStr","ccyCode","instructionAmountStr",
                                  "firmBank","status","acceptanceStatus","freeTextType1","freeText1","freeTextType2",
                                  "freeText2");                
                    
            } else if(ObjectUtil.stringCompare("PENDING",opObj)==0) {
            	columns=new Array("valueDateStr","cpTradingAccount","localAccountNo","deliverReceiveDisplay",
                                  "instrumentCode","altSecurityCode","instructionQuantityStr","ccyCode","instructionAmountStr",
                                  "firmBank","status","acceptanceStatus","freeTextType1","freeText1","freeTextType2",
                                  "freeText2"); 
            } else if(ObjectUtil.stringCompare("QUERY",opObj)==0) {     
                columns=new Array("valueDateStr","cpTradingAccount","localAccountNo","deliverReceiveDisplay",
                                  "instrumentCode","altSecurityCode","instructionQuantityStr","ccyCode",
                                  "instructionAmountStr","firmBank","status","csiStatus","acceptanceStatus");                  
                          
            } else {                     
                columns=new Array("valueDateStr","cpTradingAccount","localAccountNo","deliverReceiveDisplay",
                                  "instrumentCode","altSecurityCode","instructionQuantityStr","ccyCode",
                                  "instructionAmountStr","firmBank","status","acceptanceStatus");      
                    
            }
                         
            summaryResult=ProcessResultUtil.processUsingDataField(summaryResult,columns);
    }
    
    private function getInstrumentCode(item:Object, column:DataGridColumn):String {
        return item.instrumentCode;
    }
    private function getCpAccountNo(item:Object, column:DataGridColumn):String {
        return item.cpAccountNo
    }
    private function getCpBankDisplay(item:Object, column:DataGridColumn):String {
        return item.cpBankDisplay;
    }
    private function getExtractedObject(item:Object):Object{
        if(item == null)
            return null;
        //trace("ADDED ::: item.settlementInfoPk" + item.settlementInfoPk + " item.instructionRefNo = " + item.instructionRefNo);
        var exObj:Object = new Object();
        exObj.settlementInfoPk = item.settlementInfoPk;
        exObj.instructionRefNo = item.instructionRefNo;
        return exObj;
    }
	private function duplicateRecords():void{
		if(this.duplicatebtn.visible){
			sPopup = SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));	
			sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.stlinx.lbl.duplicaterecords.advfund');
			sPopup.addEventListener(CloseEvent.CLOSE,closeHandler,false,0,true);
			sPopup.width  = this.parentApplication.width - 100;
			sPopup.height = 400;
			PopUpManager.centerPopUp(sPopup);
			sPopup.moduleUrl = "assets/appl/stl/TrxDuplicateRecordsAdvFund.swf";
		}
	}
	 /**
	 * Event Handler for the Close Event "close"
	 */
	public function closeHandler(event:Event):void {        		
        handleOkSystemConfirm(event);
        sPopup.removeMe();
    }
    /**
	 * This method fetches the Records for Bulk Transmit
	 * 
	 */
	private function bulkTransmit():void {
		if(this.transmitAll != null){
			this.transmitAll.enabled = false;
		}
		var reqObj : Object = new Object();
		//Commented for XGA-2400
		//reqObj.freeTextValueArrayForBulk = freeTextValueForBulk;
		//reqObj.freeTextTypeArrayForBulk  = freeTextTypeForBulk;
		//reqObj.stlInfoPkArrayForBulk     = stlInfoPkForBulk;
		reqObj.instructionScreenType = "advisoryFundSendNew";
		reqObj.method = "transmitBulkInx";
		reqObj.rnd = Math.random()+"";
		reqObj.SCREEN_KEY = 13023;
		bulkTransmitRequest.request = reqObj;
		bulkTransmitRequest.send();
	}
	/**
	 * This method gets fired when result is obtained by bulkTransmitRequest
	 * 
	 * 
	 */
	private function openBulkTransmitUserConfirmation(event:ResultEvent):void {
		
		var rs:XML = XML(event.result);
		//XenosAlert.info("### "+rs);
		bulkTransmitList.removeAll();
		
		if (null != event) {
			if(rs.child("row").length()>0) {
				if(XenosStringUtils.equals(opObj,'SEND_NEW')) {
                    errPage2.clearError(event); //clears the errors if any
                }
                
                try {
                    for each ( var rec:XML in rs.row ) {
                        bulkTransmitList.addItem(rec);
                    }
                } catch(e:Error) {
                	if(this.transmitAll != null){
                		this.transmitAll.enabled = true;
                	}
                    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                }
			} else if(rs.child("Errors").length()>0) {
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list                  
                for each ( var error:XML in rs.Errors.error ) {
                    errorInfoList.addItem(error.toString());
                }
                if(XenosStringUtils.equals(opObj,'SEND_NEW')) {
                    errPage2.showError(errorInfoList);//Display the error
                }
                return;
			} else {
				if(this.transmitAll != null){
                	this.transmitAll.enabled = true;
                }
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                if(XenosStringUtils.equals(opObj,'SEND_NEW')) {
                    errPage2.clearError(event); //clears the errors if any
                }
			}
		} else {
			if(this.transmitAll != null){
                this.transmitAll.enabled = true;
            }
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}
		
        var totalBulkTransmitRecords:Number = (new Number(bulkTransmitList[0].totalRecordsFetched)) - (new Number(bulkTransmitList[0].totalPending));
        if(totalBulkTransmitRecords > 0) {
        	bulkTransmitInxAdvFund = BulkTransmitInxAdvFund(PopUpManager.createPopUp(this, BulkTransmitInxAdvFund, true));
			bulkTransmitInxAdvFund.title = this.parentApplication.xResourceManager.getKeyValue('stl.stlinx.lbl.bulk.transmit.advfund.user.confirmation');
	        bulkTransmitInxAdvFund.addEventListener("OkSystemConfirm",handleOkSystemConfirm);
	        bulkTransmitInxAdvFund.width = this.parentApplication.width - 200;
	        bulkTransmitInxAdvFund.height = this.parentApplication.height - 200;
        	bulkTransmitInxAdvFund.totalEligibleRecordsFetched = totalBulkTransmitRecords;
	        bulkTransmitInxAdvFund.totalRptExpected = new Number(bulkTransmitList[0].countExpectedRpt);
	        PopUpManager.centerPopUp(bulkTransmitInxAdvFund);
        } else {
        	if(this.transmitAll != null){
        		this.transmitAll.enabled = true;
        	}
        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.stlinx.lbl.bulk.transmit.no.records.found'));
        }
	}
	/**
	 * This method opens up the Help Pop-up when help button is clicked
	 */
	private function displayHelp():void {
		
		this.helpBox.visible = true;
		this.helpBox.includeInLayout = true;
		
		PopUpManager.removePopUp(helpPopup);
		
		helpPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
		
		helpPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.label.color.background.info');
		helpPopup.width = 325;
		helpPopup.height = 165;
		helpPopup.addChild(this.helpBox);
		PopUpManager.centerPopUp(helpPopup);
	}	