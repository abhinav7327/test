package com.nri.rui.oms.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.utils.XenosPopupUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Text;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridListData;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;
	
	public class OmsDataCompareRenderer extends Text
	{
		public function OmsDataCompareRenderer()
		{
			super();
		}
		
		/*Color = RED*/
		private const RED_COLOR:uint = 0xFF0000; 
		/*Color = BLACK*/
		private const BLK_COLOR:uint = 0x000000; 
		
		private var orderReferenceNo:String =  "orderReferenceNoVersion";
		private var executionReferenceNo:String = "executionReferenceNoVersion";
		private var executionNumericStatus:String = "executionNumericStatus";
		//private var specialUnmatchFlag:String     = "specialUnmatchFlag";
		private var yesFlag:String = "Y";
		
		/*
			Contains the list of order fields which will be compared when MATCH_STATUS != UNPAIRED
			This list has been kept hard coded as a single renderer is being used to compare all the 
			7 fields.
		*/
		private var orderFields:Array = new Array(
												  "orderBuySellFlag", "orderTradeDateDisp",
												  "orderValueDateDisp","orderInstrumentCode",
												  "orderPrincipalAmount","orderNumberOfUnits",
												  "orderStatus"
												  );
		/*
			Contains the list of execution fields which will be compared when MATCH_STATUS != UNPAIRED
			This list has been kept hard coded as a single renderer is being used to compare all the 
			7 fields.
		*/										
		private var executionFields:Array =  new Array(
													   "executionBuySellFlag", "executionTradeDateDisp",
													   "executionValueDateDisp", "executionInstrumentCode",
													   "executionPrincipalAmount", "executionNumberOfUnits",
													   "executionStatus"		
												);
												
		

		override public function set data(value:Object):void
		{
			super.data = value;
			
			if(listData is AdvancedDataGridListData){
	         	var dataField:String=(listData as AdvancedDataGridListData).dataField;
	         	
				if( XenosStringUtils.equals(dataField, orderReferenceNo)
     						|| XenosStringUtils.equals(dataField, executionReferenceNo)){
     					if(StringUtil.trim(text) != Globals.EMPTY_STRING)
         					setVisibleProp(dataField)
         			}
	  		}
		}												
														
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
			//super.data = value;
			var i:int = 0;
			var j:int = 0;
			var temp:String =  null;
			if(listData){ 
				
	         	if(listData is AdvancedDataGridListData){
	         		var dataField:String=(listData as AdvancedDataGridListData).dataField;	 
					if(!XenosStringUtils.equals("UNPAIRED", data.matchStatus))
					{
		 				for(i =0 ;i< orderFields.length ; i++)
		 				{
		 					var tempOrd:String = orderFields[i];
		 					var tempExe:String = executionFields[i];
		 					if(XenosStringUtils.equals(dataField, tempOrd) || 
		 					   XenosStringUtils.equals(dataField, tempExe))
		 					{
		 						if((XenosStringUtils.isBlank(data[tempOrd]) && XenosStringUtils.equals(tempExe, "executionPrincipalAmount"))){
		 							setStyle("color", BLK_COLOR);
			      				}
			      				else if((XenosStringUtils.isBlank(data[tempOrd]) && XenosStringUtils.equals(tempExe, "executionNumberOfUnits"))){
			      					setStyle("color", BLK_COLOR);
			      				}
			      				else
			      				{
			      					/*START : Do not differentiate between 5000 and 5000.00*/
			      					if(XenosStringUtils.equals(tempExe, "orderPrincipalAmount") 
		 								|| XenosStringUtils.equals(tempExe, "executionPrincipalAmount")){
		 								var orderAmountNumber:Number = Number(data["orderPrincipalAmount"]);//picking raw data from the XML returned i.e data without commas
		 								var exeAmountNumber:Number = Number(data["executionPrincipalAmount"]);//picking raw data from the XML returned i.e data without commas
		 								if(orderAmountNumber == exeAmountNumber){
		 									setStyle("color", BLK_COLOR);
		 								}else{ 
		 									setStyle("color", RED_COLOR);
		 								}
		 							}
			      					/*END : Do not differentiate between 5000 and 5000.00*/
			      					
			      					else{
				      					if(!XenosStringUtils.equals(data[tempOrd], data[tempExe]))
				 						{
					         			 	setStyle("color", RED_COLOR);
				         				}else
				         				{
				         					setStyle("color", BLK_COLOR);
				         				}
				         			}
			      			    }
		 					}
	         				
		 				}
		 			}
		 			else // i.e. unpaired record
		 			{
		 				if(XenosStringUtils.equals(dataField, "orderStatus") || 
		 					   XenosStringUtils.equals(dataField, "executionStatus"))// ie. STATUS field
		 				{
		 					if(XenosStringUtils.equals(data["orderStatus"], "CANCEL") || 
		 					   XenosStringUtils.equals(data["executionStatus"], "CANCEL")){// color red : only for cancel STATUS
		 						 setStyle("color", RED_COLOR);  
		 					}
		 					else{// else color black for other STATUS
		 						setStyle("color", BLK_COLOR);
		 					}
		 						
		 				}
		 				else{// other fields of unpaired records except STATUS
		 					if(!XenosStringUtils.equals(dataField, orderReferenceNo)
     						&& !XenosStringUtils.equals(dataField, executionReferenceNo)){
		         				setStyle("color", BLK_COLOR);
		         			}
		     			}
		     			
	         			
			 		}
			 		/* Start: executionNumericStatus should always be displayed in red*/
			 		if(XenosStringUtils.equals(dataField, executionNumericStatus)){
			 			 setStyle("color", RED_COLOR);  
			 		}
			 		/* End: executionNumericStatus should always be displayed in red*/
			 		
			 		
			 		var specialUnmatchFlagTemp:String = String(data["specialUnmatchFlag"]);
			 		if(XenosStringUtils.equals(specialUnmatchFlagTemp, yesFlag)){
			 			if(XenosStringUtils.equals(dataField, "executionPrincipalAmount") || 
			 			   XenosStringUtils.equals(dataField, "executionNumberOfUnits")){
			 			   		setStyle("color", RED_COLOR);  
			 			   }	
			 		}
	   			}
   			}
		}// End Function
		private function setVisibleProp(dataFieldValue:String):void{
			var visibleFlag : Boolean = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			buttonMode = visibleFlag;
			useHandCursor = visibleFlag;
			mouseChildren = !visibleFlag;
			if(visibleFlag){
				setStyle("color",0x007ac8);
				setStyle("textDecoration","underline");
				if(XenosStringUtils.equals(orderReferenceNo,dataFieldValue)){
					addEventListener(MouseEvent.CLICK, handleMouseClickOrder);
				}
				if(XenosStringUtils.equals(executionReferenceNo,dataFieldValue)){
					addEventListener(MouseEvent.CLICK, handleMouseClickExecution);
				}
				
			}
			else{
				if(hasEventListener(MouseEvent.CLICK)){
					if(XenosStringUtils.equals(orderReferenceNo,dataFieldValue)){
						removeEventListener(MouseEvent.CLICK,handleMouseClickOrder);
					}
					if(XenosStringUtils.equals(executionReferenceNo,dataFieldValue)){
						removeEventListener(MouseEvent.CLICK,handleMouseClickExecution);
					}
				}
				setStyle("color",BLK_COLOR);
				setStyle("textDecoration","normal");
			}
			
		}
		public function handleMouseClickOrder(event:MouseEvent):void {			
			var ordPkStr : String = data.orderPk;
			var ordRefNoStr : String = data.orderReferenceNo;
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showOrderSummary(ordPkStr,ordRefNoStr,parentApp);
		}
		public function handleMouseClickExecution(event:MouseEvent):void {			
			var executionPkStr : String = data.executionPk;
			var executionRefNoStr : String = data.executionReferenceNo;
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showExecutionSummary(executionPkStr,executionRefNoStr,parentApp);
		}
	}
}