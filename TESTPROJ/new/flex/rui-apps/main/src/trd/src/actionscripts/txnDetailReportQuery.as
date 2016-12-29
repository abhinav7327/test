// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.core.utils.ProcessResultUtil;

import com.nri.rui.core.validators.XenosNumberValidator;

import mx.collections.ArrayCollection;

import mx.controls.dataGridClasses.DataGridColumn;

import mx.resources.ResourceBundle;

import mx.events.ResourceEvent;
import mx.events.ValidationResultEvent;

import mx.utils.ObjectUtil;
import mx.utils.StringUtil;
            
  
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();

    private var keylist:ArrayCollection = new ArrayCollection(); 
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    private var  csd:CustomizeSortOrder=null;

    [Bindable]private var mode : String = "query";
            
    private function addCommonKeys():void{ 

        keylist = new ArrayCollection();

        keylist.addItem("buySellFlagList.item");

        keylist.addItem("sortFieldList1.item"); 
        keylist.addItem("sortFieldList2.item"); 
        keylist.addItem("sortFieldList3.item");

    }
        
         
    private function commonInit(mapObj:Object):void{

       resetFormValues();
       errPage.clearError(super.getInitResultEvent());


       var i:int = 0;
       var selIndx:int = 0;

       var initcol:ArrayCollection = new ArrayCollection();

       initcol=new ArrayCollection();

       initcol.addItem({label:" ", value: " "});
           for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
               initcol.addItem(item);
           }
        buysellflagList.dataProvider = initcol;


        // Sort fields

        //Sort Field1
        initcol=new ArrayCollection();
        initcol.addItem({label:" ", value: " "});
        for each(item in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
            initcol.addItem(item);
        }

        sortFieldArray[0]=sortField1;
        sortFieldDataSet[0]=initcol;
        //Set the default value object
        sortFieldSelectedItem[0] = initcol.getItemAt(++selIndx);

        //Sort Field2
        initcol=new ArrayCollection();
        initcol.addItem({label:" ", value: " "});
        for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
            initcol.addItem(item);
        }

        sortFieldArray[1]=sortField2;
        sortFieldDataSet[1]=initcol;
        //Set the default value object
        sortFieldSelectedItem[1] = initcol.getItemAt(++selIndx);

        //Sort Field3
        initcol=new ArrayCollection();
        initcol.addItem({label:" ", value: " "});
        for each(item in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
            initcol.addItem(item);
        }

        sortFieldArray[2]=sortField3;
        sortFieldDataSet[2]=initcol;
        //Set the default value object
        sortFieldSelectedItem[2] = initcol.getItemAt(++selIndx);    

        csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();

        fundPopUp.fundCode.setFocus();

        app.submitButtonInstance = submit;

    }
        
  /**
    *  This method resets all the values in the form.
    */
    private function resetFormValues():void {

        actPopUp.accountNo.text = "";
        fundPopUp.fundCode.text = "";
        instPopUp.instrumentId.text = "";
        finInstPopUp.finInstCode.text = "";
        tradeDateFromStr.text = "";
        tradeDateToStr.text = "";
        executionMarket.text = "";
    }
        
  /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        
        reqObj.method= "submitQuery";
        
        
        //fundcode
        reqObj.fundCode = fundPopUp.fundCode.text;

        //securtiycode
        reqObj.securityCode = instPopUp.instrumentId.text;

        //fundaccountno
        reqObj.fundAccountNo = actPopUp.accountNo.text;
        
        //Date Fields
        reqObj.dateForm = this.tradeDateFromStr.text;
        reqObj.dateTo = this.tradeDateToStr.text;

        //buysell
        reqObj.buySell = (this.buysellflagList.selectedItem != null ? this.buysellflagList.selectedItem.value : "");    

         //broker code        
        reqObj.brokerCode = finInstPopUp.finInstCode.text;

        //execution market        
        reqObj.executionMarket  = executionMarket.itemCombo != null ? executionMarket.itemCombo.text : "" ;
        
        
       //populate sort fields
        
        reqObj.sortField1 = (this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "");
        reqObj.sortField2 = (this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "");
        reqObj.sortField3 = (this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "");

        reqObj.rnd = Math.random() + "";
        
        return reqObj;
        
    }

    private function commonResult(mapObj:Object):void{      
        
        //XenosAlert.info("mapObj : "+mapObj.toString()); 
        
        var result:String = "";
        
        if(mapObj!=null){   
        
            if(mapObj["errorFlag"].toString() == "error"){
            
                queryResult.removeAll();
                errPage.showError(mapObj["errorMsg"]);
                
            } else if(mapObj["errorFlag"].toString() == "noError"){
               
               errPage.clearError(super.getSubmitQueryResultEvent());
               queryResult.removeAll();
               queryResult=mapObj["row"];
               changeCurrentState();
               qh.setOnResultVisibility();
               qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
               qh.PopulateDefaultVisibleColumns();
                
            }else{
                errPage.removeError();
                queryResult.removeAll();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
            }           
        }
        //XenosAlert.info(result);
    }
    
    override public function preQueryResultInit():Object{
        //var keylist:ArrayCollection = new ArrayCollection(); 
        addCommonKeys();    

        return keylist;         
    }


    private function sortOrder1Update():void{
        csd.update(sortField1.selectedItem,0);
    }

    private function sortOrder2Update():void{      
        csd.update(sortField2.selectedItem,1);
    }
    
    private function changeCurrentState():void{
        currentState = "result";
    }

    public function loadAll():void{
        parseUrlString();
        super.setXenosQueryControl(new XenosQuery());
        //XenosAlert.info("mode : "+mode);
        this.dispatchEvent(new Event('queryInit'));
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
            //XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
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
        super.getInitHttpService().url = "trd/txnDetailQueryDispatch.action?method=initialExecute&&menuType=Y&rnd=" + rndNo;         
    }
    
    override public function postQueryResultInit(mapObj:Object):void{
        commonInit(mapObj);
    }

    private function setValidator():void{

    } 

    override public function preQuery():void{
        setValidator();
        qh.resetPageNo();    
        // XenosAlert.info("I am in preQuery ");
        super.getSubmitQueryHttpService().url = "trd/txnDetailQueryDispatch.action?";  
        super.getSubmitQueryHttpService().request  =populateRequestParams();
    }    

    override public function postQueryResultHandler(mapObj:Object):void{
        commonResult(mapObj);
    }      
      
    override public function preResetQuery():void{
        var rndNo:Number= Math.random();
        super.getResetHttpService().url = "trd/txnDetailQueryDispatch.action?method=resetQuery&&menuType=Y&rnd=" + rndNo;            
    }
        
    override    public function preGenerateXls():String{
        var url : String =null;
            url = "trd/txnDetailQueryDispatch.action?method=generateXLS";
            return url;
    }  
    override public function preGeneratePdf():String{
        //XenosAlert.info("preGeneratePdf");
        var url : String =null;  
            url = "trd/txnDetailQueryDispatch.action?method=generatePDF";
            return url;
    } 
            
    override public function preNext():Object{
       var reqObj : Object = new Object();
       reqObj.method = "doNext";
       return reqObj;
    }  
    override public function prePrevious():Object{
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        return reqObj;
    } 
          
    private function dispatchPrintEvent():void{
      this.dispatchEvent(new Event("print"));
    }  
    private function dispatchPdfEvent():void{
     // XenosAlert.info("dispatchEvent pdf");
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


    /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing counter party type                
        var cpTypeArray:Array = new Array(1);
            cpTypeArray[0]="INTERNAL";
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
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

    var bankRoleArray : Array = new Array(1);
    bankRoleArray[0] = "Bank/Custodian";
    bankRoleArray[1] = "Security Broker";
    myContextList.addItem(new HiddenObject("bankRoles",bankRoleArray));

    return myContextList;
    }