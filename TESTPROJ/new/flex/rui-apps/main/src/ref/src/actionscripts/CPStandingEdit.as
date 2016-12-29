// ActionScript file
import mx.collections.ArrayCollection;

 [Bindable]
 public var xmlObj:XML;
 [Bindable]
 private var sttlType:ArrayCollection;
 private var stlTypeIndx:int=0;
  [Bindable]
 private var delevieryMethodLst:ArrayCollection;
 private var dlvMthdIndx:int=0;
   [Bindable]
 private var priorityLst:ArrayCollection;
 private var priorityLstIndx:int=0;
 private var modeOfTran:String="";

 
 
      public function setXMLObj(xml:XML):void{
         xmlObj = xml;   
       }
       
      public function setModeOfTransaction(mode:String):void{
     	  	modeOfTran =mode;
       }
       
    		
     public function initializeView():void 
     {  
       if(xmlObj!=null){
       	// Control the dispaly of the CPStandingEditScreen
        onChangeSecCashAmand();     
        // Method calling to cntrl the flow of UI
        controldeliverMethod();
        //XGA-1678 UI Changes
        //controlSettlementmodeView();
        // Combo Population
       	sttlType =new ArrayCollection();
       // For settlement type combo box
       	if(xmlObj.child("stlTypeList").length()>0){
       	 var indx:int = 0; 
		 for each(var obj:Object in xmlObj.stlTypeList.item ){
		 	if(xmlObj.cpSecRule.settlementType.toString()==obj.value){
		 		stlTypeIndx=indx;
		 	}
		  		indx++;
		 	    sttlType.addItem(obj);;
	        }
	       sttlType.refresh();  
	       stltype.selectedIndex= stlTypeIndx; 
       	}
       	
       	// For Delivery Method Form combo box
       	 delevieryMethodLst =new ArrayCollection();
       	 delevieryMethodLst.addItem({label: "" , value : ""});
       	if(xmlObj.child("deliveryMethodList").length()>0){
       	 var indx1:int = 0; 
		 for each(var obj2:Object in xmlObj.deliveryMethodList.item ){
		 	
		 	if(xmlObj.cpSecRule.deliveryMethod.toString()==obj2.value){
		 		dlvMthdIndx=indx1;
		 	}
		  		indx1++;
		 	    delevieryMethodLst.addItem(obj2);;
	        }
	       delevieryMethodLst.refresh();  
	       dlvMth.selectedIndex =dlvMthdIndx;
       	}
       	
       	
      // For Priority List combo box
       	priorityLst =new ArrayCollection();
       	if(xmlObj.child("priorityList").length()>0){
       	 var indx2:int = 0; 
		 for each(var obj1:Object in xmlObj.priorityList.item ){
		 	if(xmlObj.cpSecRule.priority.toString()==obj1.value){
		 		priorityLstIndx=indx2;
		 	}
		  		indx2++;
		 	    priorityLst.addItem(obj1);;
	        }
	       
	       priorityLst.refresh(); 
	       priortyLst.selectedIndex=priorityLstIndx;
	         
       	}
       	// Set the value for Place of Settlement
       	if(xmlObj.child("placeOfSettlement").length()>0){
         finInstPopUp.finInstCode.text = xmlObj.placeOfSettlement.toString();
        }else{
        	finInstPopUp.finInstCode.text="";
        }
        
       	// Select the child screen
   		selectChildScreen();
   		
        }
	   	
     }
     
     // Control the display of Delivery Method(Form) Display
     private function controldeliverMethod():void{
     	if(xmlObj.cpSecRule.cashSecurityFlag.toString()=="CASH"){
        	delivryMthTxt.includeInLayout=true;
        	delivryMthTxt.visible=true;
        	delivryMthLst.includeInLayout=false;
        	delivryMthLst.visible=false;
        	settlementTypeFld.enabled=false;
        }
        else{
        	delivryMthTxt.includeInLayout=true;
        	delivryMthTxt.visible=true;
        	delivryMthLst.includeInLayout=false;
        	delivryMthLst.visible=false;
        	
        }
     }
     
     // Control the display of Settlement mode row
     private function controlSettlementmodeView():void{
     	if(this.modeOfTran != 'ADD'){
     		stlmntMode.includeInLayout=true;
     		stlmntMode.visible=true;
     	}
     	else{
     		stlmntMode.includeInLayout=false;
     		stlmntMode.visible=false;
     	}
     }
     
     private function selectChildScreen():void{
    	
    	// See comment on  XENOSCD-4279
     /*	if(xmlObj.cpSecRule.settlementMode.toString()=='INTERNAL'){
		    this.dynaStack.selectedChild=cpNormalEntry;
			cpNormalEntry.initializeView(xmlObj);
			cpNormalEntry.setModeOfTran(modeOfTran);
     	}
     	
     	else if(xmlObj.cpSecRule.settlementMode.toString()=='EXTERNAL'){
     	
		if((XML(xmlObj.cpSecRule).child("dtcIndicator")).length()>0 && xmlObj.cpSecRule.dtcIndicator=='true'){
			this.dynaStack.selectedChild=cpDtcEntry;
			cpDtcEntry.initializeView(xmlObj);
		}
		
	    else if((XML(xmlObj.cpSecRule).child("contraIdCodeType")).length()>0 && xmlObj.cpSecRule.contraIdCodeType !=""){
  		    this.dynaStack.selectedChild=cpStandingContraIDEntry;
			cpStandingContraIDEntry.initializeView(xmlObj);
		}else{
			this.dynaStack.selectedChild=cpNormalEntry;
			cpNormalEntry.initializeView(xmlObj);
			cpNormalEntry.setModeOfTran(modeOfTran);
		}
   	 }*/
			cpNormalEntry.setModeOfTran(modeOfTran);
			cpNormalEntry.initializeView(xmlObj);
			
  }
  
  // Control the Display of Way of Pay in CPStanding Normal Entry
  
   public function showHideWayofPay(settlementType:String):void{
   		if(settlementType=="AGAINST"){
		   	cpNormalEntry.wayOfPay.includeInLayout=true;
		   	cpNormalEntry.wayOfPay.visible=true;
		}
		else{
		   	cpNormalEntry.wayOfPay.includeInLayout=false;
		   	cpNormalEntry.wayOfPay.visible=false;
		}
	}
     
     
     public function onChangeSecCashAmand():void 
	{
	 if((xmlObj.secCash.toString()).toUpperCase()=="SECURITY") 
		{
		 if((xmlObj.cpSecRule.counterPartyType.toString()).toUpperCase()!='BROKER')
			{
			settlementModeSecurityAmendLbl.includeInLayout=true;
			settlementModeSecurityAmendLbl.visible=true;
			settlementModeSecurityAmendFld.includeInLayout=true;
			settlementModeSecurityAmendFld.visible=true;
			}
			settlementTypeLbl.includeInLayout=false;
			settlementTypeLbl.visible=false;
			settlementTypeFld.includeInLayout=true;
			settlementTypeFld.visible=true;
		}
		else
		{
			settlementModeSecurityAmendLbl.includeInLayout=false;
			settlementModeSecurityAmendLbl.visible=false;
			settlementModeSecurityAmendFld.includeInLayout=false;
			settlementModeSecurityAmendFld.visible=false;;
			settlementTypeFld.includeInLayout=false;
			settlementTypeFld.visible=false;
			settlementTypeLbl.includeInLayout=true;
			settlementTypeLbl.visible=true;
		}
	}
	
	
	/**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
	public function populateEditParmeter(reqObj:Object):void{
		if(reqObj!=null){
			// Populate the data from Edit Screen
			if(settlementTypeFld.includeInLayout){
				reqObj['cpSecRule.settlementType'] = this.stltype.selectedItem.value;
			 }
			 if(delivryMthLst.includeInLayout){
			 	reqObj['cpSecRule.deliveryMethod'] = this.dlvMth.selectedItem.value;
			 }
			 reqObj['cpSecRule.priority'] = this.priortyLst.selectedItem.value;
			 if(stlmntMode.includeInLayout){
			 	reqObj['cpSecRule.settlementMode'] = "EXTERNAL";
			 }
			reqObj['placeOfSettlement'] = finInstPopUp.finInstCode.text;
			
			cpNormalEntry.populateNormalEntryParmeter(reqObj);
		}
	}

     
     
     
