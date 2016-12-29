

import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.*;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

private var rndNo:Number = 0;
private var initCompFlg : Boolean = false;
[Bindable]
public var summaryResult:ArrayCollection= new ArrayCollection();
[Bindable]
public var summaryResult2:ArrayCollection= new ArrayCollection();
//For check box
[Bindable]
public var selectAllBind:Boolean=false;
[Bindable]
public var caEventRefNo:String=null;
[Bindable]
public var eventType:String=null;
[Bindable]
public var entryPk:String;
[Bindable]
public var securityCode:String=null;
[Bindable]
public var securityName:String=null;
[Bindable]
public var IntruPk:String=null;
[Bindable]
public var allottedSecurityCode:String=null;
[Bindable]
public var allotedSecurityName:String=null;
[Bindable]
public var allotedIntruPk:String=null;
[Bindable]
public var errorArray:ArrayCollection = null;
public var rowNum : ArrayCollection=new ArrayCollection();
[Bindable]
public var selectedRdArray : Array = new Array();
private var tempArray : Array = new Array();
private var rowNumArray : Array = new Array();
private var originalRowNumArrColl:ArrayCollection = new ArrayCollection();
private var n : int =0;
[Bindable]private var incomeFlag:Boolean=false;
public var lmOfficeId:String="";
public var fundCategory:String ="";
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    *
    */
    private function initPageStart():void {
        if (!initCompFlg) {
            var reqObj : Object = new Object();
            parseUrlString();
            rndNo= Math.random();
            initRightsDetailEntry.url = "cax/entitlementEntryDispatch.action?method=doSubmitEntry&rnd=" + rndNo;
            reqObj['conditionPk'] = entryPk;     
            reqObj['lmOfficeId'] = lmOfficeId;  
            reqObj['fundCategory'] = fundCategory;     
            reqObj.SCREEN_KEY = 452;
            initRightsDetailEntry.request = reqObj;
            initRightsDetailEntry.send();
        } else
            XenosAlert.info("Already Initiated!");
    }
    
    /**
    * This method will be called for parsing URL to retrieve the ca Event Pk.
    *
    */
    private function parseUrlString():void {
        try {
            // Remove everything before the question mark, including
            // the question mark.
            var myPattern:RegExp = /.*\?/;
            var s:String = this.loaderInfo.url.toString();
            s = s.replace(myPattern, "");
            // Create an Array of name=value Strings.
            var params:Array = s.split("&");
             // Print the params that are in the Array.
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;

            // Set the values of the salutation.
            for (var i:int = 0; i < params.length; i++) {
                var tempA:Array = params[i].split("=");
                if (tempA[0] == "conditionPk") {
                    entryPk = tempA[1];
                }
                else if (tempA[0] == "lmOfficeId") {
                    lmOfficeId = tempA[1];
                }
                else if (tempA[0] == "fundCategory") {
                    fundCategory = tempA[1];
                }
            }
            //XenosAlert.info("condition pk "+entryPk);

        } catch (e:Error) {
            trace(e);
        }

    }


   /**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {

     }
     
     //This as file contains code specific to the Check Box Selections.    
    /**
     * Used to select all records together.
     */    
    public function selectAllRecs(flag:Boolean): void {
        var i:Number = 0;
        selectedRdArray = new Array();
        rowNum = new ArrayCollection();
        originalRowNumArrColl.removeAll();
        for(i=0; i<summaryResult.length; i++){
        	if(summaryResult[i].fundCode != "") {
            	var obj:XML=summaryResult[i];
            	obj.selected = flag;
            	summaryResult[i] = obj;
            	addOrRemove(summaryResult[i],i);
         	}
        }       
     }   
     
   /**
    * Determines whether the record needs to be added 
    * or deleted according the selected value of teh Check Box.
    */ 
     private function addOrRemove(item:Object,ix : int):void {
        var i:int = 0;
        var j:int = 0;
        trace("addOrRemove: index"+ix);
        if(item.selected == true){ // need to insert
            rowNum.addItem(ix);                    
            selectedRdArray[ix] = ix;
            originalRowNumArrColl.addItem(item.parentIndex);
            trace("originalRowNo : "+originalRowNumArrColl);       
        }else { //need to pop   
            tempArray=rowNum.toArray();
            rowNum.removeAll();
            selectedRdArray[ix] = null;
            for(i=0; i<tempArray.length; i++){
                if(tempArray[i] != ix){
                    rowNum.addItem(tempArray[i]);
                }
            }
            var temporiginalRowNumArrColl:Array = originalRowNumArrColl.toArray();
            originalRowNumArrColl.removeAll();
            for(j=0; j<temporiginalRowNumArrColl.length; j++) {
            	if(temporiginalRowNumArrColl[j] != item.parentIndex) {
            		originalRowNumArrColl.addItem(temporiginalRowNumArrColl[j]);
            	}
            }          
        }
    } 
     
     
     
    //select function
    /**
     * Check one by one selection.
     */
    public function checkSelectToModify(item:Object,ix:int):void {
        var i:int = 0;
        addOrRemove(item,ix);
        setIfAllSelected();     
    }
    /**
     * sets all selected.
     */
    private function setIfAllSelected() : void {
        if(isAllSelected()){
            selectAllBind=true;
        } else {
            selectAllBind=false;
        }
    }

    /**
     * Checks whether all the records are selected one by one then make all selected true.
     *
     */
    private function isAllSelected(): Boolean {
        var i:int = 0;
        if(summaryResult == null){
            return false;
        }

        for(i=0; i<summaryResult.length; i++){
        	if(summaryResult[i].fundCode != "") {
            	if(summaryResult[i].selected == false) {
            		return false;
            	}
         	}
            //return false;
                            
        }
        
        return true;
        /*if(i == summaryResult.length) {
            return true;
         }else {
            return false;
        } */      

    }

   /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on the top panel of the
    * result .
    */
      private function loadSummaryPage(event:ResultEvent):void {
        var rs:XML = XML(event.result);
        selectAllBind = false;
        rowNum.removeAll();
        if (null != event) { 
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
                var initColl:ArrayCollection = new ArrayCollection();
                errPage.clearError(event);
                errPage.removeError();
                entry.visible = true;
                entry.includeInLayout = true;               
                summaryResult.removeAll();
                var rec:XML = new XML();
                var counter:int=0;
                try {                   
                    caEventRefNo = rs.caEventRefNo;
                    eventType =  rs.eventType;   
                    incomeFlag=(rs.isIncome=='true')?true:false;           
                    if(rs.entitlementPage.entitlementPageItem != null) {    
                        initColl.removeAll();
                        for each (rec in rs.entitlementPage.entitlementPageItem) {
                        	rec.index = counter ;
                            initColl.addItem(rec);
                            counter++;
                        }   
                        if(initColl.length != 0) {          
                            var i:int = 0;
                            var j:int = 0;
                            summaryResult = new ArrayCollection();
                            /* for(i = 0; i<initColl.length; i++) {                        
                                summaryResult.addItem(initColl[i]);
                                summaryResult[i].instrumentPk= rs.instrumentPk;
                                summaryResult[i].securityCode= rs.securityCode;
                                summaryResult[i].allottedInstrumentPk= rs.allottedInstrumentPk;
                                summaryResult[i].allottedSecurityCode= rs.allottedSecurityCode;
                                summaryResult[i].securityName= rs.securityName;
                                summaryResult[i].allottedSecurityName= rs.allottedSecurityName; 
                                summaryResult[i].ccyFlagIndication= rs.ccyFlagIndication;                            
                            } */
                            // Iterate over the list of entitlement pages
                            for(i = 0; i<initColl.length; i++) {
                            	// Number of ownership entitlements under each entitlement page
                            	var entl:XML = new XML();
                            	var entls:ArrayCollection = new ArrayCollection();
                            	for each (entl in initColl[i].camRightsDetailVO.camRightsDetailVOItem) {
                        			entls.addItem(entl);
                            	}
                            	
                            	var k:int = 0;
                            	var prevFundCode:String = null;
                            	// Iterate over each ownership entitlements
                            	for(k = 0; k<entls.length; k++) {
                            		summaryResult.addItemAt(entls[k], j);
                            		// Add information corresponding to corporate actions
                            		//summaryResult[j].instrumentPk= rs.instrumentPk;
                            		//summaryResult[j].securityCode= rs.securityCode;
                                	summaryResult[j].allottedInstrumentPk= rs.allottedInstrumentPk;
                                	summaryResult[j].allottedSecurityCode= rs.allottedSecurityCode;
                                	//summaryResult[j].securityName= rs.securityName;
                                	summaryResult[j].allottedSecurityName= rs.allottedSecurityName; 
                                	summaryResult[j].ccyFlagIndication= rs.ccyFlagIndication;
                                	//summaryResult[j].availableDate = rs.availableDate;
                                	//summaryResult[j].paymentDate = rs.paymentDate;
                                	summaryResult[j].parentIndex = -1;
                                	// If fundCode of the record is same as the fundCode of the
                                	// previous record, then skip
                                	if(!XenosStringUtils.equals(prevFundCode, initColl[i].fundCode)) {
                                		summaryResult[j].fundCode= initColl[i].fundCode;
                                		summaryResult[j].fundPk= initColl[i].fundPk;
                                		summaryResult[j].lmOfficeId= initColl[i].lmOfficeId;
                                		prevFundCode = initColl[i].fundCode;
                                		summaryResult[j].parentIndex = i;//initColl[i].index as String;
                                	} else {
                                		summaryResult[j].fundCode = "";
                                		summaryResult[j].lmOfficeId= "";
                                	}
                                	summaryResult[j].index = j;
                                	j++;
                            	}
                            }
                            //changeCurrentState();
                            //replace null objects in dataProvider with empty string
                            summaryResult=ProcessResultUtil.process(summaryResult,rightsDetail.columns);
                            //changeCurrentState();                                         
                            summaryResult.refresh();
                            resetSellection(summaryResult);
                            setIfAllSelected(); 
                        } else {
                            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                            summaryResult.removeAll(); // clear previous data if any as there is no result now.
                            errPage.removeError(); //clears the errors if any
                        }                   
                    } else {
                        XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                        summaryResult.removeAll(); // clear previous data if any as there is no result now.
                        errPage.removeError(); //clears the errors if any
                     }                                                              
                }catch(e:Error){
                    XenosAlert.error(e.toString() + e.message);
                    //XenosAlert.error("No result found");
                }
               }                 
            } else {
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                summaryResult.removeAll(); // clear previous data if any as there is no result now.
                errPage.removeError(); //clears the errors if any           
            }
      }
      
    private function resetSellection(summaryResult:ArrayCollection):void{
        for(var i:int=0;i<summaryResult.length;i++){
            summaryResult[i].selected = false;
            //summaryResult[i].rowNoArray = i;
        }
    }     
      
   /**
    * It sends/submits the query after validating the user input data. 
    * 
    */
     private function submitEntry():void 
     {          
        if(rowNum.length == 0){
            XenosAlert.info("Please select at least one record for Entitlement Entry");
        }else{
        //Set the request parameters
         var requestObj :Object = populateRequestParams();
         var validated: Boolean = false;         
         rightDetailEntrySubmit.request = requestObj;
         validateEntry();       	
    	 originalRowNumArrColl = new ArrayCollection();
    	 originalRowNumArrColl.refresh();
    	 trace("size : "+originalRowNumArrColl.length); 
         rowNum.removeAll();
         rowNum.refresh();
         for(var i:int=0; i<summaryResult.length; i++){
            var obj:XML=summaryResult[i];
            obj.selected = false;
            summaryResult[i] = obj;
        }   
        }
     }    
     
   /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
//        rowNumArray = rowNum.toArray();
//        reqObj['rowNoArray'] = rowNumArray;
		reqObj['rowNoArray'] = originalRowNumArrColl.toArray();
        reqObj.SCREEN_KEY = 453;
        return reqObj;
    }  
    
   /**
    * Validates Entry.
    */
    private function validateEntry():void {
    var i:int = 0;
    var j:int = 0;  
    // var confirmMsg:Boolean = false;
    errorArray = new ArrayCollection();
    errorArray.removeAll();
    
     /* for(i = 0; i<rowNum.length; i++) {                         
        if(summaryResult.getItemAt(rowNum.toArray()[i]).ownerLocationConsistency == "N") {
            confirmMsg=true;
            break;
        }                        
     } */
     
    /*for(j = 0; j<rowNum.length; j++) {  
        if(summaryResult.getItemAt(rowNum.toArray()[j]).ccyFlagIndication == "Y") {
            var ownerAllotmentAmt:Number = Number((summaryResult.getItemAt(rowNum.toArray()[j]).ownershipAllottedAmount).toString());
            // var locationAllotmentAmt:Number = Number((summaryResult.getItemAt(rowNum.toArray()[j]).locationAllottedAmount).toString());                                         
                
            if(ownerAllotmentAmt == 0) { 
                var error1:String = "Failed to Generate Ownership Entitlement as Allotted Amount is Zero for fund [" +summaryResult.getItemAt(rowNum.toArray()[i]).fundCode +"]";       
                errorArray.addItem(error1.toString());              
            }  */
            /* if(locationAllotmentAmt == 0) {
                var error2:String ="Failed to Generate Location Entitlement as Allotted Amount is Zero for fund [" +summaryResult.getItemAt(rowNum.toArray()[i]).fundCode +"]";
                errorArray.addItem(error2.toString());      
            } 
        } */
        /* if(summaryResult.getItemAt(rowNum.toArray()[j]).ccyFlagIndication == "N") {
            var ownerAllotmentQty:Number = Number((summaryResult.getItemAt(rowNum.toArray()[j]).ownershipAllottedQty).toString());
            // var locationAllotmentQty:Number = Number((summaryResult.getItemAt(rowNum.toArray()[j]).locationAllottedQty).toString());                                            
                
            if(ownerAllotmentQty == 0) { 
                var error3:String = "Failed to Generate Ownership Entitlement as Allotted Quantity is Zero for fund [" +summaryResult.getItemAt(rowNum.toArray()[i]).fundCode +"]";     
                errorArray.addItem(error3.toString());              
            }  */
            /* if(locationAllotmentQty == 0) {
                var error4:String ="Failed to Generate Location Entitlement as Allotted Quantity is Zero for fund [" +summaryResult.getItemAt(rowNum.toArray()[i]).fundCode +"]";
                errorArray.addItem(error4.toString());      
            } */                     
        /*}
        
    }*/    
    
    detailEntry.selectedChild=confirm;      
	rightDetailEntrySubmit.send();
    
     /* if(confirmMsg) {
        XenosAlert.confirm("Entitlements has inconsistency between Ownership and Location balance. " + 
                           "Do you want to continue?",confirmHandler);
     } else {               
        detailEntry.selectedChild=confirm;      
        rightDetailEntrySubmit.send();  
     } */ 

    }    
    
   /**
    * Confirm Handeler.
    */    
    private function confirmHandler(event:CloseEvent):void {
         if (event.detail == Alert.YES) {
             detailEntry.selectedChild=confirm;  
             this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.entry') + ' - ' + this.parentApplication.xResourceManager.getKeyValue('cax.user.confirmation');
             rightDetailEntrySubmit.send(); 
         } 
    }        
    
     /**
     * Initial state to remove the Popup after System confirmation
     */
     private function initialState():void{
        errPageOk.removeError();
        errPage2.removeError();
        errPageConf.removeError();
        // to call the submit query of ca event again.
        this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));    
        PopUpManager.removePopUp(UIComponent(this.parent.parent));
     } 
     
   /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on the top panel of the
    * result .
    */
    private function loadConfirmPage(event:ResultEvent):void {      
        var rs:XML = XML(event.result);
        selectAllBind = false;
        if (null != event) { 
            if(!rs.child("Errors").length()>0) {
                this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.entry') + ' - ' + this.parentApplication.xResourceManager.getKeyValue('cax.user.confirmation');
                if(errPage == null) { 
                    errPage2.removeError();
                } else {                        
                    errPage.removeError();
                }   


                var softWarningList : ArrayCollection = new ArrayCollection();
                //populate the softwarning info list
                if(rs.softExceptionList != null) {
	                for each (var warning:XML in rs.softExceptionList.item.value) {
	                    softWarningList.addItem(warning.toString());
	                }
	                if(softWarningList.length > 0) {
	                    softWarning.dataProvider = softWarningList;
	                    softWarning.rowCount = softWarningList.length;
	                    softWarning.maxHeight = 200;
	                    softWarning.visible = true;
	                    softWarning.includeInLayout = true;
	                }
                }



                errPageConf.showError(errorArray);          
                summaryResult2.removeAll();
                ok.visible = true;
                ok.includeInLayout=true;                
                var initColl:ArrayCollection = new ArrayCollection();    
                var rec:XML = new XML();                                                
                try {                                  
                    caEventRefNo = rs.caEventRefNo;
                    eventType =  rs.eventType;              
                    if(rs.selectedEntitlementPage.selectedEntitlementPageItem != null) {        
                    	initColl.removeAll();
                    	for each (rec in rs.selectedEntitlementPage.selectedEntitlementPageItem) {
                    		initColl.addItem(rec);
                    	}
                    	
                    	// ------------------------------
                    	if(initColl.length != 0) {          
							var i:int = 0;
                        	var j:int = 0;
                    		summaryResult2 = new ArrayCollection();
                        	// Iterate over the list of selected entitlement pages
                    		for(i = 0; i<initColl.length; i++) {
                        		// Number of ownership entitlements under each entitlement page
                            	var entl:XML = new XML();
                            	var entls:ArrayCollection = new ArrayCollection();
                            	for each (entl in initColl[i].camRightsDetailVO.camRightsDetailVOItem) {
                        			entls.addItem(entl);
                            	}
                            	
                            	var k:int = 0;
                            	var prevFundCode:String = null;
                            	// Iterate over each ownership entitlements
                            	for(k = 0; k<entls.length; k++) {
                            		summaryResult2.addItemAt(entls[k], j);
                            		// Add information corresponding to corporate actions
                            	//	summaryResult2[j].instrumentPk= rs.instrumentPk;
                            	//	summaryResult2[j].securityCode= rs.securityCode;
                                	summaryResult2[j].allottedInstrumentPk= rs.allottedInstrumentPk;
                                	summaryResult2[j].allottedSecurityCode= rs.allottedSecurityCode;
                                //	summaryResult2[j].securityName= rs.securityName;
                                	summaryResult2[j].allottedSecurityName= rs.allottedSecurityName; 
                                	summaryResult2[j].ccyFlagIndication= rs.ccyFlagIndication;
                                	//summaryResult2[j].availableDate = rs.availableDate;
                                	//summaryResult2[j].paymentDate = rs.paymentDate;
                                	// If fundCode of the record is same as the fundCode of the
                                	// previous record, then skip
                                	if(!XenosStringUtils.equals(prevFundCode, initColl[i].fundCode)) {
                                		summaryResult2[j].fundCode= initColl[i].fundCode;
                                		summaryResult2[j].fundPk= initColl[i].fundPk;
                                		prevFundCode = initColl[i].fundCode;
                                		summaryResult2[j].lmOfficeId= initColl[i].lmOfficeId;
                                	} else {
                                		summaryResult2[j].fundCode = "";
                                		summaryResult2[j].lmOfficeId="";
                                	}
                                	// summaryResult2[j].parentIndex = rec.index;
                                	summaryResult2[j].index = j;
                            		j++;
                        		}
                    		}
                    		summaryResult2=ProcessResultUtil.process(summaryResult2,rightsDetailUserConf.columns);
                    		//changeCurrentState();                                         
                    		summaryResult2.refresh();
                    	}
                   		// ------------------------------
                    	/*var i:int = 0;  
                    	summaryResult2 = new ArrayCollection();
                    	for(i = 0; i<initColl.length; i++) {                        
                        	summaryResult2.addItem(initColl[i]);
                        	summaryResult2[i].instrumentPk= rs.instrumentPk;
                        	summaryResult2[i].securityCode= rs.securityCode;
                        	summaryResult2[i].allottedInstrumentPk= rs.allottedInstrumentPk;
                        	summaryResult2[i].allottedSecurityCode= rs.allottedSecurityCode;
                        	summaryResult2[i].securityName= rs.securityName;
                    		summaryResult2[i].allottedSecurityName= rs.allottedSecurityName;                             
                    	}                               
                    	//changeCurrentState();
                    	//replace null objects in dataProvider with empty string
                    	summaryResult2=ProcessResultUtil.process(summaryResult2,rightsDetailUserConf.columns);
                    	//changeCurrentState();                                         
                    	summaryResult2.refresh(); */                                         
                    } else {
                        XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                        summaryResult2.removeAll(); // clear previous data if any as there is no result now.
                        errPage2.removeError(); //clears the errors if any                      
                    }                                                                   
                }catch(e:Error){
                    XenosAlert.error(e.toString() + e.message);                 
                }                       
            } else {                
                                
                //some error found
                summaryResult2.removeAll(); // clear previous data if any as there is no result now.
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                    errorInfoList.addItem(error.toString());
                }                           
                detailEntry.selectedChild = entry;
                this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.entry');                                    
                errPage.showError(errorInfoList);//Display the error            
            }   
        } else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            summaryResult2.removeAll(); // clear previous data if any as there is no result now.
            errPage2.removeError(); //clears the errors if any
        }  
    }  
      
     /** 
     * This will determine whether the transaction Number should be shown
     * with OK button or it will be the User Confirmation page.
     */
     private function changeToConfirmState():void {                     
        detailEntry.selectedChild = confirm;          
     }    
      
     /**
     * Sending the http service for SAVE operation
     */
     private function  doSave() :void{   
        //disable button after confirm to prevent multiple click     
        ok.enabled=false;   
        var req : Object = new Object();
        req.SCREEN_KEY = 11053;
        rightsDetailOk.request = req;          
        rightsDetailOk.send();          
     }
     
     /**
     * Sending reset service.
     */
     private function resetEntry() :void{
        rightsDetailReset.send();
                
     }     
     
    /**
    * This method is the resultHandler for confirm action. This is required for the 
    * User Confirmation Screen to show the values in non editable form.
    */
     private function okResult(event:ResultEvent):void{
        ok.enabled=true;
        if (null != event) {   
                var rs:XML = XML(event.result);         
                if(null == event.result.entitlementActionForm){ 
                    errPage2.displayError(event);   
                                        
                } else if (rs.child("Errors").length()>0) {
                            // Must be error
                            errPageOk.removeError();                        
                            var errorInfoList : ArrayCollection = new ArrayCollection();
                            //populate the error info list              
                            for each ( var error:XML in rs.Errors.error ) {
                                errorInfoList.addItem(error.toString());
                            }           
                            errPageOk.showError(errorInfoList);//Display the error
                            XenosAlert.info(" in ok page error ");
              }else {
                    softWarning.visible = false;
                    softWarning.includeInLayout = false;
                    errPageOk.removeError();
                    caEventRefNo = event.result.entitlementActionForm.caEventRefNo as String;
                    eventType =  event.result.entitlementActionForm.eventType as String;
                    detailEntry.selectedChild = confirm;
                    hb.visible=true;
                    hb.includeInLayout=true; 
                    ok.visible = false;
                    ok.includeInLayout=false;
                    cancel.visible=false;
                    cancel.visible=false;        
                    ok2.visible = true;
                    ok2.includeInLayout=true;           
                    this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.entry') + ' - ' + this.parentApplication.xResourceManager.getKeyValue('cax.system.confirmation');
              }      
        }else {
            XenosAlert.info("event = null");
            errPageOk.removeError();
        }
     }     
     
     /**
     * Previous State
     */
     private function previousState():void{         
        detailEntry.selectedChild = entry;
        this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.entry');  
        errPageOk.removeError();
        errPage2.removeError();
        errPageConf.removeError(); 
        errPage.removeError();
        //initPageStart();
        
     }
                 
                           
      