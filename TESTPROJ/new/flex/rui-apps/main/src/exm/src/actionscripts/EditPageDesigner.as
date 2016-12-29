
// ActionScript file for Dynamically generate the View for the XmlMessage
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.formatters.XenosNumberFormatter;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.core.validators.XenosNumberValidator;
import com.nri.rui.exm.ExmConstraints;
import com.nri.rui.ref.popupImpl.ExtAccountPopUpHbox;
import com.nri.rui.ref.popupImpl.ExtInstrumentPopUpHbox;

import mx.collections.ArrayCollection;
import mx.containers.HBox;
import mx.containers.Panel;
import mx.controls.Label;
import mx.controls.TextInput;
import mx.events.ValidationResultEvent;
import mx.core.UIComponent;



[Bindable]
public var currentPanel : Panel = new Panel();
[Bindable]
public var intendentSize : int = 50;
[Bindable]
public var intendentLavel : int = 0; 
[Bindable]
 private var queryResult:ArrayCollection= new ArrayCollection();
 
 public var conformMessageIds : Array;
 
 public var accountTagValueLabelObj:ArrayCollection = new ArrayCollection();
 
 public var accountCodeTypeTagValueLabelObj:ArrayCollection = new ArrayCollection();
 
 public var prefixTagValueLabelObj:ArrayCollection = new ArrayCollection();
 
 public var accountPopupObj :ArrayCollection =new ArrayCollection();
 
 public var instrumentTagValueLabelObj:ArrayCollection = new ArrayCollection();
 
 public var instrumentCodeTypeTagValueLabelObj:ArrayCollection = new ArrayCollection();
 
 public var instrumentPopupObj :ArrayCollection =new ArrayCollection();
 
 public var instrumentTagDisplayValLblObj:ArrayCollection = new ArrayCollection();
 
 public var principalAmountTagValueLabelObj:ArrayCollection = new ArrayCollection();
 
 public var principalAmount:Array = new Array();
 
 public var principalAmountTextInputObj:ArrayCollection = new ArrayCollection();
 
 public var quantityTagValueLabelObj:ArrayCollection = new ArrayCollection();
 
 public var quantity:Array = new Array();
 
 public var quantityTextInputObj:ArrayCollection = new ArrayCollection();
 
 public var inputPriceTagValueLabelObj:ArrayCollection = new ArrayCollection();
 
 public var inputPrice:Array = new Array();
 
 public var inputPriceTextInputObj:ArrayCollection = new ArrayCollection();
 
 public var EditableTRD01:int = new int();
 
 
 public var accPos :Array = new Array();
 private var noOfAccountNoRecord:int = 0;
 private var accArrIndex:int = 0;
 private var noOfSecurityRecord:int = 0;
 private var secArrIndex:int = 0;
 
 public var accountCode :Array = new Array();
 
 public var secPos :Array = new Array();
 
 public var securityCode :Array = new Array();
 
 private var color:Array=new Array();
 
 
 public function displayXml() : void {

     //Alert.show("Message Information :: " + resultObj.toString());
     var messageBlockList :XMLList = resultObj.children();
       
       for each (var mesagePartInfo :XML in messageBlockList) {
            //Alert.show("Message Block Name :: " + mesagePartInfo.name());
            
            if (mesagePartInfo.name().toString() == "Header") {
                currentPanel = this.Header;
                //Alert.show("Message Block Name :: " + mesagePartInfo.name());
            }
            if (mesagePartInfo.name().toString() == "Body") {
                currentPanel = this.Body;
                //Alert.show("Message Block Name :: " + mesagePartInfo.name());
            }
            if (mesagePartInfo.name().toString() == "Footer") {
                currentPanel = this.Footer;
                //Alert.show("Message Block Name :: " + mesagePartInfo.name());
            }
            
            showXml(mesagePartInfo);
            
       }
     
 }
            
public function generateFlexView (xmlNode : XML) : void{
     
     var myHBox : HBox = new HBox();
     myHBox.percentHeight = 100;
     myHBox.percentWidth = 100;
     //myHBox.styleName="HDivideStyle";
     myHBox.setStyle("horizontalGap","0");
     myHBox.setStyle("verticalGap","0");
     
     var labelContainer : VBox = new VBox();
 		 labelContainer.percentHeight = 100;
 		 labelContainer.percentWidth = 35;
 		 labelContainer.styleName = "LabelBgColor";
 		 labelContainer.setStyle("borderStyle","solid");
 		 
      var valueContainer : VBox = new VBox();
 		 valueContainer.percentHeight = 100;
 		 valueContainer.percentWidth = 65;
 		 valueContainer.setStyle("borderStyle","solid");
     
     if (xmlNode.hasComplexContent()){
         //Alert.show("Node Type :: " + recChild.nodeKind());
         //Alert.show("Complex Node Name :: " + recChild.name());
         var myComplexLabel : Label = new Label();
         myComplexLabel.id = xmlNode.name();
         myComplexLabel.text = xmlNode.name();
         
         color[0] = 0xE3FFF5;
         labelContainer.percentWidth = 100;
         labelContainer.setStyle("backgroundColor",color[0]);
         
         
         color[0]= 0x007DFF;
         myComplexLabel.setStyle("color",color[0]);
         myComplexLabel.setStyle("fontSize","12");
         myComplexLabel.setStyle("fontFamily","Arial");
         myComplexLabel.setStyle("fontWeight","bold");
         labelContainer.addChild(myComplexLabel);
         myHBox.addChild(labelContainer);
         this.currentPanel.addChild(myHBox);
         //changePosition(myComplexLabel);
         //myComplexLabel.x = myComplexLabel.x + intendentLavel*intendentSize;    
         //myComplexLabel.move(this.myComplexLabel.x + intendentLavel*intendentSize, this.myComplexLabel.y);  
     }
     if (xmlNode.hasSimpleContent()){
 		 
 		 //Alert.show("Node Type :: " + xmlNode.nodeKind());
 		 //Alert.show("Node Name :: " + xmlNode.name());
 		 //Alert.show("Node Value :: " + xmlNode.toString());
 		 if (xmlNode.name() == "AccountNoType"){
 		     
 		     try {
 		     
 		     //Alert.show("processing Account No Type :: " + xmlNode.name());
 		     
 		     var accountNoTypeTagLabel : Label = new Label();
             //accountNoTypeTagLabel.id = xmlNode.name();
             accountNoTypeTagLabel.text = xmlNode.name();
             color[0]= 0x007DBB;
             accountNoTypeTagLabel.setStyle("color",color[0]);
             accountNoTypeTagLabel.setStyle("fontSize","12");
             accountNoTypeTagLabel.setStyle("fontFamily","Arial");
             accountNoTypeTagLabel.setStyle("fontWeight","normal");
             labelContainer.addChild(accountNoTypeTagLabel);
             myHBox.addChild(labelContainer);
             var accountNoTypeTagValueLabel : Label = new Label();
             //accountNoTypeTagLabel.id = xmlNode.toString();
             accountNoTypeTagValueLabel.text = xmlNode.toString();
             accountNoTypeTagValueLabel.selectable = true;
             //accountNoTypeTagLabel.name = "accountNoTypeValue";
             valueContainer.addChild(accountNoTypeTagValueLabel);
             myHBox.addChild(valueContainer);
                         
 		     var acctXRef:XML = xmlNode.parent();	
 		     if (acctXRef.child("Duplicate").length() == 1) {
 		        accountCodeTypeTagValueLabelObj.addItem(accountNoTypeTagValueLabel);
 		     }
 		     
             this.currentPanel.addChild(myHBox); 
 		     } catch (err:Error){
 		         XenosAlert.error("Error Account No Type :: " + err.getStackTrace());
 		     }
 		     
 		 } else if (xmlNode.name() == "Prefix"){
 		     
 		     try {
 		     
 		     //Alert.show("processing Prefix :: " + xmlNode.name());
 		     
 		     var prefixTagLabel : Label = new Label();
             //accountTagLabel.id = xmlNode.name();
             prefixTagLabel.text = xmlNode.name();
             color[0]= 0x007DBB;
             prefixTagLabel.setStyle("color",color[0]);
             prefixTagLabel.setStyle("fontSize","12");
             prefixTagLabel.setStyle("fontFamily","Arial");
             prefixTagLabel.setStyle("fontWeight","normal");
             labelContainer.addChild(prefixTagLabel);
             myHBox.addChild(labelContainer);
             var prefixTagValueLabel : Label = new Label();
             //accountTagValueLabel.id = xmlNode.toString();
             prefixTagValueLabel.text = xmlNode.toString();
             prefixTagValueLabel.selectable = true;
             //accountTagValueLabel.name = "accountValue";
             valueContainer.addChild(prefixTagValueLabel);
             myHBox.addChild(valueContainer);
                         
 		     var accXRef:XML = xmlNode.parent();	
 		     if (accXRef.child("Duplicate").length() == 1) {
 		       prefixTagValueLabelObj.addItem(prefixTagValueLabel);
 		     }
 		     
             this.currentPanel.addChild(myHBox); 
 		     } catch (err:Error){
 		         XenosAlert.error("Error prefix :: " + err.getStackTrace());
 		     }
 		     
 		 }else if (xmlNode.name() == "AccountNo"){
 		     try {
 		     
 		     var innerHbox : HBox = new HBox();
 		     innerHbox.percentHeight = 100;
 		     innerHbox.percentWidth = 100;
 		     
 		     var rightHbox : HBox = new HBox();
 		     rightHbox.percentHeight = 100;
 		     rightHbox.percentWidth = 100;
 		     
 		     var accountTagLabel : Label = new Label();
             accountTagLabel.text = xmlNode.name();
             
             color[0]= 0x007DBB;
             accountTagLabel.setStyle("color",color[0]);
             accountTagLabel.setStyle("fontSize","12");
             accountTagLabel.setStyle("fontFamily","Arial");
             accountTagLabel.setStyle("fontWeight","normal");
             innerHbox.addChild(accountTagLabel);
            // XenosAlert.info("xmlNode Name :: " + xmlNode.name());
             var accountTagValueLabel : Label = new Label();
             accountTagValueLabel.text = xmlNode.toString();
             accountTagValueLabel.selectable = true;
             rightHbox.addChild(accountTagValueLabel);
             
             labelContainer.addChild(innerHbox);
             myHBox.addChild(labelContainer);             
 		     var accountXRef:XML = xmlNode.parent();	
 		     if (accountXRef.child("Duplicate").length() == 1) {
 		         accountTagValueLabelObj.addItem(accountTagValueLabel); 		     	
 		            
	 		     var accountPopup : ExtAccountPopUpHbox = new ExtAccountPopUpHbox();
	 		     accountPopup.id = xmlNode.name();
	
	 		     if (accountPopup.accountNo != null){
	 		         accountPopup.accountNo.text = xmlNode.toString();
	 		     } else {
	 		         //Alert.show("accountPopup.accountNo :: " + accountPopup.accountNo);
	 		     }
	            // XenosAlert.info("xmlNode Name 1 :: " + xmlNode.name());
	             //XenosAlert.info("xmlNode Account No 1:: " + xmlNode.toString());
	 		     rightHbox.addChild(accountPopup);
	 			 	     	
	 		     accountPopupObj.addItem(accountPopup);
	 		     //XenosAlert.info("noOfAccountNoRecord :: " + noOfAccountNoRecord);
	 		     accPos[accArrIndex]=noOfAccountNoRecord;
	 		     accArrIndex++;
 		         //XenosAlert.info("accountPopup Duplicate :: " + accountPopup.accountNo.text);
 		     }
 		     valueContainer.addChild(rightHbox);
	 		 myHBox.addChild(valueContainer);
             this.currentPanel.addChild(myHBox); 
 		     } catch (err:Error){
 		         XenosAlert.error("Error account no :: " + err.getStackTrace());
 		     }
 		     
 		     noOfAccountNoRecord++;
 		 } else if (xmlNode.name() == "SecurityId"){
 		     
 		     try {
 		         var rightHboxVal : HBox = new HBox();
     		     rightHboxVal.percentHeight = 100;
     		     rightHboxVal.percentWidth = 100;
 		     
 			     var instrumentTagLabel : Label = new Label();
                 instrumentTagLabel.text = xmlNode.name();
                 color[0]= 0x007DBB;
                 instrumentTagLabel.setStyle("color",color[0]);
                 instrumentTagLabel.setStyle("fontSize","12");
                 instrumentTagLabel.setStyle("fontFamily","Arial");
                 instrumentTagLabel.setStyle("fontWeight","normal");
 			     labelContainer.addChild(instrumentTagLabel);
                 myHBox.addChild(labelContainer);
                 
                 var instrumentTagValueLabel : Label = new Label();
                 instrumentTagValueLabel.text = xmlNode.toString();
                 instrumentTagValueLabel.includeInLayout = false;
                 instrumentTagValueLabel.visible = false;
                 instrumentTagValueLabel.selectable = true;
                 rightHboxVal.addChild(instrumentTagValueLabel);
                 
                 var instrumentTagDisplayValueLabel : Label = new Label();
                 instrumentTagDisplayValueLabel.text = instrumentTagValueLabel.text;
                 instrumentTagDisplayValueLabel.selectable = true;
                 rightHboxVal.addChild(instrumentTagDisplayValueLabel);
                 
 			     var instrumentXRef:XML = xmlNode.parent();
 			     if (instrumentXRef.child("Duplicate").length() == 1) {
 			     	
 				     var instrumentPopup : ExtInstrumentPopUpHbox = new ExtInstrumentPopUpHbox();
 				     instrumentPopup.id = xmlNode.name();
                     if (instrumentPopup.instrumentId != null){
                         instrumentPopup.instrumentId.text = xmlNode.toString();
                     }
 				     //valueContainer.addChild(instrumentPopup);
 				     rightHboxVal.addChild(instrumentPopup);
 				     instrumentPopupObj.addItem(instrumentPopup);
 				     instrumentTagValueLabelObj.addItem(instrumentTagValueLabel);
 				     instrumentTagDisplayValLblObj.addItem(instrumentTagDisplayValueLabel);
 			     	 secPos[secArrIndex]=noOfSecurityRecord;  
 			     	 secArrIndex++;
 			     } else {
                 	//valueContainer.addChild(instrumentTagValueLabel);
 			     }
 			     valueContainer.addChild(rightHboxVal);
 			     myHBox.addChild(valueContainer);
 			     this.currentPanel.addChild(myHBox); 
 			     
 		     } catch (err : Error){
 		         XenosAlert.error("Error Security Id :: " + err.getStackTrace());
 		     }
 		     noOfSecurityRecord++;
 		 }else if (xmlNode.name() == "InstrumentCodeType"){
 		     
 		     try {
 			     
 			     var instrumentCodeTypeTagLabel : Label = new Label();
                 instrumentCodeTypeTagLabel.text = xmlNode.name();
                 color[0]= 0x007DBB;
                 instrumentCodeTypeTagLabel.setStyle("color",color[0]);
                 instrumentCodeTypeTagLabel.setStyle("fontSize","12");
                 instrumentCodeTypeTagLabel.setStyle("fontFamily","Arial");
                 instrumentCodeTypeTagLabel.setStyle("fontWeight","normal");
                 labelContainer.addChild(instrumentCodeTypeTagLabel);
                 myHBox.addChild(labelContainer);
                 
                 var instrumentCodeTypeTagValueLabel : Label = new Label();
                 instrumentCodeTypeTagValueLabel.text = xmlNode.toString();
                 instrumentCodeTypeTagValueLabel.selectable = true;
                 valueContainer.addChild(instrumentCodeTypeTagValueLabel);
                 myHBox.addChild(valueContainer);
                 
              	 var instrRef:XML = xmlNode.parent();
 			     if (instrRef.child("Duplicate").length() == 1) {
 			     	instrumentCodeTypeTagValueLabelObj.addItem(instrumentCodeTypeTagValueLabel);
 			     }

                 this.currentPanel.addChild(myHBox); 
             
 		     } catch (err : Error){
 		         XenosAlert.error("Error InstrumentCodeType :: " + err.getStackTrace());
 		     }
 		     
 		  }  else if (xmlNode.name() == "PrincipalAmount") {
 		 
 		 		 try{
 		 		 	
 		 		 	var rightHboxVal : HBox = new HBox();
     		     	rightHboxVal.percentHeight = 100;
     		     	rightHboxVal.percentWidth = 100;
 		 		 	
 		 		 	var principalAmountTagLabel : Label = new Label();
 		 		 	principalAmountTagLabel.text = xmlNode.name();
 		 		 	color[0]= 0x007DBB;
 		 		 	principalAmountTagLabel.setStyle("color",color[0]);
 		 		 	principalAmountTagLabel.setStyle("fontSize","12");
 		 		 	principalAmountTagLabel.setStyle("fontFamily","Arial");
                    principalAmountTagLabel.setStyle("fontWeight","normal");
                    labelContainer.addChild(principalAmountTagLabel);
                    myHBox.addChild(labelContainer);
                 	
                 	var principalAmountValueLabel : Label = new Label();
                 	principalAmountValueLabel.text = xmlNode.toString();
             		principalAmountValueLabel.selectable = true;
                 	
                 	var tradeData:XML = xmlNode.parent();
                 	if (tradeData.child("EditableTRD01").length() == 1){
                 		
                 	 EditableTRD01 = tradeData.child("EditableTRD01").length();
                 	
                 	 var principalAmountTextInput:TextInput = new TextInput();
                     principalAmountTextInput.text = xmlNode.toString();
                     
                    
                     principalAmountValueLabel.id = xmlNode.toString();
                 	 principalAmountValueLabel.text = principalAmountTextInput.text;
                     principalAmountValueLabel.selectable = true;
                    
 				     rightHboxVal.addChild(principalAmountTextInput);
 				     //rightHboxVal.addChild(principalAmountValueLabel);
 				     principalAmountTextInputObj.addItem(principalAmountTextInput);
 				     //principalAmountTagValueLabelObj.addItem(principalAmountValueLabel);
                 	
                 	}
                 	
                 	rightHboxVal.addChild(principalAmountValueLabel);
                 	principalAmountTagValueLabelObj.addItem(principalAmountValueLabel);
                 	valueContainer.addChild(rightHboxVal);
 			     	myHBox.addChild(valueContainer);
 			     	this.currentPanel.addChild(myHBox); 
 		 		 
 		 	 }   catch (err : Error){
 		 		 XenosAlert.error("Error PrincipalAmount :: " + err.getStackTrace());
 		 		 }
 		 
 		    }	else if (xmlNode.name() == "Quantity") {
 		 
 		 		 try{
 		 		 	
 		 		 	var rightHboxVal : HBox = new HBox();
     		     	rightHboxVal.percentHeight = 100;
     		     	rightHboxVal.percentWidth = 100;
 		 		 	
 		 		 	var quantityTagLabel : Label = new Label();
 		 		 	quantityTagLabel.text = xmlNode.name();
 		 		 	color[0]= 0x007DBB;
 		 		 	quantityTagLabel.setStyle("color",color[0]);
 		 		 	quantityTagLabel.setStyle("fontSize","12");
 		 		 	quantityTagLabel.setStyle("fontFamily","Arial");
                    quantityTagLabel.setStyle("fontWeight","normal");
                    labelContainer.addChild(quantityTagLabel);
                    myHBox.addChild(labelContainer);
                 	
                 	var quantityValueLabel : Label = new Label();
                 	quantityValueLabel.text = xmlNode.toString();
             		quantityValueLabel.selectable = true;
                 	
                 	var tradeData:XML = xmlNode.parent();
                 	if (tradeData.child("EditableTRD01").length() == 1){
                 	
                 	 var quantityTextInput:TextInput = new TextInput();
                     quantityTextInput.text = xmlNode.toString();
                     
                     quantityValueLabel.id = xmlNode.toString();
                 	 quantityValueLabel.text = quantityTextInput.text;
                     quantityValueLabel.selectable = true;
                    
 				     rightHboxVal.addChild(quantityTextInput);
 				     //rightHboxVal.addChild(quantityValueLabel);
 				     quantityTextInputObj.addItem(quantityTextInput);
 				     //quantityTagValueLabelObj.addItem(quantityValueLabel);
                 	
                 	}
                 
                 	rightHboxVal.addChild(quantityValueLabel);
             		quantityTagValueLabelObj.addItem(quantityValueLabel);
                 	valueContainer.addChild(rightHboxVal);
 			     	myHBox.addChild(valueContainer);
 			     	this.currentPanel.addChild(myHBox); 
 		 		 
 		 	 }   catch (err : Error){
 		 		 XenosAlert.error("Error Quantity :: " + err.getStackTrace());
 		 		 }
 		 
 		     } else if (xmlNode.name() == "InputPrice") {
 		 
 		 		 try{
 		 		 	
 		 		 	var rightHboxVal : HBox = new HBox();
     		     	rightHboxVal.percentHeight = 100;
     		     	rightHboxVal.percentWidth = 100;
 		 		 	
 		 		 	var inputPriceTagLabel : Label = new Label();
 		 		 	inputPriceTagLabel.text = xmlNode.name();
 		 		 	color[0]= 0x007DBB;
 		 		 	inputPriceTagLabel.setStyle("color",color[0]);
 		 		 	inputPriceTagLabel.setStyle("fontSize","12");
 		 		 	inputPriceTagLabel.setStyle("fontFamily","Arial");
                    inputPriceTagLabel.setStyle("fontWeight","normal");
                    labelContainer.addChild(inputPriceTagLabel);
                    myHBox.addChild(labelContainer);
                 	
                 	var inputPriceValueLabel : Label = new Label();
                 	inputPriceValueLabel.text = xmlNode.toString();
             		inputPriceValueLabel.selectable = true;
                 	
                 	var tradeData:XML = xmlNode.parent();
                 	if (tradeData.child("EditableTRD01").length() == 1){
                 	
                 	 var inputPriceTextInput:TextInput = new TextInput();
                     inputPriceTextInput.text = xmlNode.toString();
                     
                     inputPriceValueLabel.id = xmlNode.toString();
                 	 inputPriceValueLabel.text = inputPriceTextInput.text;
                     inputPriceValueLabel.selectable = true; 
                     
                     
                    
 				     rightHboxVal.addChild(inputPriceTextInput);
 				     //rightHboxVal.addChild(inputPriceValueLabel);
 				     inputPriceTextInputObj.addItem(inputPriceTextInput);
 				     //inputPriceTagValueLabelObj.addItem(inputPriceValueLabel);
                 	
                 	}
                 	
                 	rightHboxVal.addChild(inputPriceValueLabel);
             		inputPriceTagValueLabelObj.addItem(inputPriceValueLabel);
                 	valueContainer.addChild(rightHboxVal);
 			     	myHBox.addChild(valueContainer);
 			     	this.currentPanel.addChild(myHBox); 
 		 		 
 		 	 }   catch (err : Error){
 		 		 XenosAlert.error("Error InputPrice :: " + err.getStackTrace());
 		 		 }
 		 
 		     }   else if (xmlNode.name() == "Duplicate"){
 		     
 		     try {
 			     
 			     //No need to display this tag
             
 		     } catch (err : Error){
 		         XenosAlert.error("Error Duplicate :: " + err.getStackTrace());
 		     }
 		     
 		   }   else if (xmlNode.name() == "EditableTRD01"){
 		     
 		     try {
 			     
 			     //No need to display this tag
             
 		     } catch (err : Error){
 		         XenosAlert.error("Error EditableTRD01 :: " + err.getStackTrace());
 		     }
 		     
 		   } else {
 		     
 			 var mySimpleTagLabel : Label = new Label();
             mySimpleTagLabel.id = xmlNode.name();
             mySimpleTagLabel.text = xmlNode.name();
             
             color[0]= 0x007DBB;
             mySimpleTagLabel.setStyle("color",color[0]);
             mySimpleTagLabel.setStyle("fontSize","12");
             mySimpleTagLabel.setStyle("fontFamily","Arial");
             mySimpleTagLabel.setStyle("fontWeight","normal");
             labelContainer.addChild(mySimpleTagLabel);
             myHBox.addChild(labelContainer);
             
             var mySimpleTagValueLabel : Label = new Label();
             mySimpleTagValueLabel.id = xmlNode.toString();
             mySimpleTagValueLabel.text = xmlNode.toString();
             mySimpleTagValueLabel.maxWidth = 400;
             mySimpleTagValueLabel.toolTip = mySimpleTagValueLabel.text;
             mySimpleTagValueLabel.selectable = true; 
             
             valueContainer.addChild(mySimpleTagValueLabel);
             myHBox.addChild(valueContainer);
             this.currentPanel.addChild(myHBox);
        }    
      }
}
           
public function showXml(xmlData : XML) : void {
    //Alert.show("IN show xml");
    //Alert.show("Process Block"); 
    
    if (xmlData.hasComplexContent()){
        intendentLavel += 1;
 	    processComplexContent(xmlData);
 	    intendentLavel -= 1;
      } else {
         processSimpleContent(xmlData);
     }
    
    //Alert.show("End Process Block"); 
     
}
           
public function processComplexContent(complexRec : XML) : void {
	//noOfAccountNoRecord =0;
	//accArrIndex = 0;
    if (complexRec.hasComplexContent()){
       
        var childList :XMLList = complexRec.children();
       
        for each (var recChild :XML in childList) {
           
            if (recChild.hasComplexContent()){
                //Alert.show("Node Type :: " + recChild.nodeKind());
                //Alert.show("Complex Node Name :: " + recChild.name());
                generateFlexView(recChild);
            }
           
            showXml(recChild);
        }
 		        
    } else {
        XenosAlert.error("Not a Complex content :: - processComplexContent");
    }
}
           
           
public function processSimpleContent(simpleRec : XML) : void {
    if (simpleRec.hasSimpleContent()){
        //Alert.show("Node Type :: " + simpleRec.nodeKind());
        //Alert.show("Node Name :: " + simpleRec.name());
        //Alert.show("Node Value :: " + simpleRec.toString());
        generateFlexView(simpleRec);
    } else {
        XenosAlert.error("Not a simple content :: - processSimpleContent");
    }
}
           
public function displayValue() : void {
    //For account no processing
    var noOfRecords : int = accountTagValueLabelObj.length;
    var accountNoValue : Label = new Label();
    var accountPrefix : Label = new Label();
    var accountNoType : Label = new Label();
    
     var accountPopupValue : ExtAccountPopUpHbox = new ExtAccountPopUpHbox();
       
    for (var j :int = 0; j<noOfRecords; j++){
       accountNoValue =  Label ( accountTagValueLabelObj.getItemAt(j) );
       if(prefixTagValueLabelObj.length>j)
       	accountPrefix =  Label ( prefixTagValueLabelObj.getItemAt(j) );
        
       accountNoType =  Label ( accountCodeTypeTagValueLabelObj.getItemAt(j) );
       
       accountPopupValue = ExtAccountPopUpHbox (accountPopupObj.getItemAt(j));
         
       if (accountPrefix.text != ""){
           accountPopupValue.accountNo.text = accountPrefix.text + ";" + accountNoValue.text + "/" + accountNoType.text;
       } else {
           accountPopupValue.accountNo.text = accountNoValue.text + "/" + accountNoType.text;
       }
       accountPopupValue.accountNo.editable = false;
       accountNoValue.visible=true;

       populateAccountContext(accountPopupValue);
//       accountPopupValue.visible = false;//temporary heiding the popup
    }
    //For instrument processing
     
    var noOfInstRecords : int = instrumentTagValueLabelObj.length;
    var securityIdValue : Label = new Label();
    var instrumentCodeType : Label = new Label();
    var instrumentPopupValue : ExtInstrumentPopUpHbox = new ExtInstrumentPopUpHbox();
    
    for (j = 0; j<noOfInstRecords; j++){
       securityIdValue =  Label ( instrumentTagValueLabelObj.getItemAt(j) );
       instrumentCodeType =  Label ( instrumentCodeTypeTagValueLabelObj.getItemAt(j) );
       instrumentPopupValue = ExtInstrumentPopUpHbox (instrumentPopupObj.getItemAt(j));
       
       instrumentPopupValue.instrumentId.text = securityIdValue.text + "/" + instrumentCodeType.text; 
       instrumentPopupValue.instrumentId.editable = false;
       securityIdValue.visible=false;
       populateInstrumentContext(instrumentPopupValue);

          //instrumentPopupValue.enabled = false;//temporary disabling the popup

    }
}
           
private function populateAccountContext(accountPopUp : ExtAccountPopUpHbox) : void {

    var myContextList:ArrayCollection = new ArrayCollection(); 
  
    //passing account no             
    var actNoContextArray:Array = new Array();
    actNoContextArray[0]=accountPopUp.accountNo.text;
    
    myContextList.addItem(new HiddenObject("actNoContext",actNoContextArray));
    
    accountPopUp.recContextItem=myContextList;
    //accountPopUp.enabled=false;
}
           
private function populateInstrumentContext(instrumentPopUp : ExtInstrumentPopUpHbox) : void {

    var instContextList:ArrayCollection = new ArrayCollection(); 
  
    //passing account no             
    var secIDContextArray:Array = new Array();
    secIDContextArray[0]=instrumentPopUp.instrumentId.text;
    
    instContextList.addItem(new HiddenObject("instIDContext",secIDContextArray));
   
    instrumentPopUp.recContextItem=instContextList;
    //instrumentPopUp.enabled=false;
}
           
public function updateValue() : void {
   
    //For account procesing
    var noOfRecords : int = accountTagValueLabelObj.length;
    var accountNoValue : Label = new Label();
    var accountPopupValue : ExtAccountPopUpHbox = new ExtAccountPopUpHbox();
   
    for (var j :int = 0; j<noOfRecords; j++){
       accountNoValue =  Label ( accountTagValueLabelObj.getItemAt(j) );
       accountPopupValue = ExtAccountPopUpHbox (accountPopupObj.getItemAt(j));
       
       accountNoValue.text = accountPopupValue.accountNo.text;
    }
    accountNoValue.selectable = true;
   
    //For instrument processing
    var noOfInstRecords : int = instrumentTagValueLabelObj.length;
    var securityIdValue : Label = new Label();
    var instrumentPopupValue : ExtInstrumentPopUpHbox = new ExtInstrumentPopUpHbox();
    
    for (j = 0; j<noOfInstRecords; j++){
       securityIdValue =  Label ( instrumentTagValueLabelObj.getItemAt(j) );
       instrumentPopupValue = ExtInstrumentPopUpHbox (instrumentPopupObj.getItemAt(j));
       
       securityIdValue.text = instrumentPopupValue.instrumentId.text;
    }
    securityIdValue.selectable = true;
    
    var noOfPrincipalAmount:int = principalAmountTextInputObj.length;
    var noOfQuantity:int = quantityTextInputObj.length;
    var noOfInputPrice:int = inputPriceTextInputObj.length;
    //for PrincipalAmount processing
    var principalAmountInput : TextInput = new TextInput();
    var principalAmountValue : Label = new Label();
    for (var j :int = 0; j<noOfPrincipalAmount; j++) {
    principalAmountInput = TextInput(principalAmountTextInputObj.getItemAt(j));
    principalAmountValue = Label (principalAmountTagValueLabelObj.getItemAt(j));
    principalAmountValue.text = principalAmountInput.text;
    }
    
    //for quantity processing
    var quantityInput : TextInput = new TextInput();
    var quantityValue : Label = new Label();
    for (var j :int = 0; j<noOfQuantity; j++) {
    quantityInput = TextInput(quantityTextInputObj.getItemAt(j));
    quantityValue = Label (quantityTagValueLabelObj.getItemAt(j));
    quantityValue.text = quantityInput.text;
    }
    
    //for inputPrice processing
    var inputPriceInput : TextInput = new TextInput();
    var inputPriceValue : Label = new Label();
    for (var j :int = 0; j<noOfInputPrice; j++) {
    inputPriceInput = TextInput(inputPriceTextInputObj.getItemAt(j));
    inputPriceValue = Label (inputPriceTagValueLabelObj.getItemAt(j));
    inputPriceValue.text = inputPriceInput.text;
    }
    
    
}       
          
public function populateModifiedValue() : void {
    updateValue();
    
    var noOfRecords : int = accountTagValueLabelObj.length;
    var accountNoValue : Label = new Label();
   
    for (var j :int = 0; j<noOfRecords; j++){
        accountNoValue =  Label ( accountTagValueLabelObj.getItemAt(j) );
        //XenosAlert.info("account value" + accountNoValue.text);
        accountCode[j]=accountNoValue.text;
        //XenosAlert.info("account code" + accountCode[j]);
        //accPos[j]=j;
    }
   
    //For instrument processing
    var noOfInstRecords : int = instrumentTagValueLabelObj.length;
    var securityIdValue : Label = new Label();
   
    for (j = 0; j<noOfInstRecords; j++){
        securityIdValue =  Label ( instrumentTagValueLabelObj.getItemAt(j) );
        securityCode[j]=securityIdValue.text;
       // secPos[j]=j;                  
    }
    
     var noOfPrincipalAmount:int = principalAmountTagValueLabelObj.length;
     var noOfQuantity:int = quantityTagValueLabelObj.length;
     var noOfInputPrice:int = inputPriceTagValueLabelObj.length;
     
    //principlaAmount processing
     var principalAmountValue = new Label();
     for (var j :int = 0; j<noOfPrincipalAmount; j++) {
     principalAmountValue = Label(principalAmountTagValueLabelObj.getItemAt(j));
     principalAmount[j] = principalAmountValue.text;
     }
     
     //quantity processing
     var quantityValue = new Label();
     for (var j :int = 0; j<noOfQuantity; j++) {
     quantityValue = Label(quantityTagValueLabelObj.getItemAt(0));
     quantity[0] = quantityValue.text;
     }
     
     //inputPrice processing
     var inputPriceValue = new Label();
     for (var j :int = 0; j<noOfInputPrice; j++) {
     inputPriceValue = Label(inputPriceTagValueLabelObj.getItemAt(0));
     inputPrice[0] = inputPriceValue.text;
     }
}

/**
 * Validates principal amount, quantity and input price
 * provided by screen user in edit screen. If one of
 * them is not numeric, show error message alert popup.
 * 
 */
private function validateTRD01():void {
	var textInput:TextInput = TextInput (inputPriceTextInputObj.getItemAt(0));
	var textStr:String = textInput.text.replace(/,+/g, "");
	if(isNaN(Number(textStr))){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('exm.editTRD01.error.field.onlyNumeric') + " InputPrice");
		throw new Error(this.parentApplication.xResourceManager.getKeyValue('exm.editTRD01.error.inputPrice.invalid'));
	}else{
		textInput.text = textStr;
	}
	textInput = TextInput (principalAmountTextInputObj.getItemAt(0));
	textStr = textInput.text.replace(/,+/g, "");
	if(isNaN(Number(textStr))){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('exm.editTRD01.error.field.onlyNumeric') + " PrincipalAmount");
		throw new Error(this.parentApplication.xResourceManager.getKeyValue('exm.editTRD01.error.principalAmount.invalid'));
	}else{
		textInput.text = textStr;
	}
	textInput = TextInput (quantityTextInputObj.getItemAt(0));
	textStr = textInput.text.replace(/,+/g, "");
	if(isNaN(Number(textStr))){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('exm.editTRD01.error.field.onlyNumeric') + " Quantity");
		throw new Error(this.parentApplication.xResourceManager.getKeyValue('exm.editTRD01.error.quantity.invalid'));
	}else{
		textInput.text = textStr;
	}
	
}

/**
 * Display the editable pages depending on the current page.
 * @param page  the target page for which the component will be displayed.
 * 
 */
private function displayFor(page:String):void {
    //Account Processing -- at present non editable
    var noOfRecords : int = accountTagValueLabelObj.length;
    var accountNoValue : Label = new Label();
    var accountPopupValue : ExtAccountPopUpHbox = new ExtAccountPopUpHbox();
   
    for (var j :int = 0; j<noOfRecords; j++){
       accountNoValue =  Label ( accountTagValueLabelObj.getItemAt(j) );
       accountPopupValue = ExtAccountPopUpHbox (accountPopupObj.getItemAt(j));
       
        if(XenosStringUtils.equals(page, ExmConstraints.AMEND_PAGE)){
            accountNoValue.includeInLayout= false;            
            accountNoValue.visible = false;
            
            accountPopupValue.visible = true;
        }else if(XenosStringUtils.equals(page, ExmConstraints.AMEND_USER_CONF_PAGE) || ExmConstraints.AMEND_SYS_CONF_PAGE){
            accountNoValue.includeInLayout= true;            
            accountNoValue.visible = true;
            accountPopupValue.visible = false;
        }       
    }

    //For instrument processing Applicable only when there is at least one editable field
    var noOfInstRecords : int = instrumentTagValueLabelObj.length;
    var securityIdDisplayValue : Label = new Label();
    var instrumentPopupValue : ExtInstrumentPopUpHbox = new ExtInstrumentPopUpHbox();
    
    for (j = 0; j<noOfInstRecords; j++){
       securityIdDisplayValue =  Label ( instrumentTagDisplayValLblObj.getItemAt(j) );
       instrumentPopupValue = ExtInstrumentPopUpHbox (instrumentPopupObj.getItemAt(j));
//       XenosAlert.info("securityIdValue : " + securityIdDisplayValue.text);
        if(XenosStringUtils.equals(page, ExmConstraints.AMEND_PAGE)){
            securityIdDisplayValue.includeInLayout = false;
            securityIdDisplayValue.visible = false;
            
            instrumentPopupValue.visible = true;            
        }else if(XenosStringUtils.equals(page, ExmConstraints.AMEND_USER_CONF_PAGE) || ExmConstraints.AMEND_SYS_CONF_PAGE){
//            securityIdValue.text = instrumentPopupValue.instrumentId.text;
            securityIdDisplayValue.includeInLayout = true;
            securityIdDisplayValue.visible = true;
            instrumentPopupValue.visible = false;
        }                     
    }  
    
    var noOfPrincipalAmount:int = principalAmountTextInputObj.length;
    var noOfQuantity:int = quantityTextInputObj.length;
    var noOfInputPrice:int = inputPriceTextInputObj.length;
    
    //for principalAmount processing
    var principalAmountTagValue:Label = new Label();
    var principalAmountInputText :TextInput = new TextInput();
    
    for (var j :int = 0; j<noOfPrincipalAmount; j++) {
    principalAmountTagValue = Label (principalAmountTagValueLabelObj.getItemAt(j));
    principalAmountInputText = TextInput (principalAmountTextInputObj.getItemAt(j));
    
    if(XenosStringUtils.equals(page,ExmConstraints.AMEND_PAGE)){
    	principalAmountTagValue.includeInLayout = false;
    	principalAmountTagValue.visible = false;
    	principalAmountTagValue.includeInLayout =true;
    	principalAmountInputText.visible = true;
    }else if (XenosStringUtils.equals(page, ExmConstraints.AMEND_USER_CONF_PAGE) || ExmConstraints.AMEND_SYS_CONF_PAGE){
    	principalAmountTagValue.includeInLayout = true;
    	principalAmountTagValue.visible = true;
    	principalAmountInputText.includeInLayout = false;
    	principalAmountInputText.visible = false;
    }
    }
    //for quantity processing	
    var quantityTagValue:Label = new Label();
    var quantityInputText :TextInput = new TextInput();
    for (var j :int = 0; j<noOfQuantity; j++) {
    quantityTagValue = Label (quantityTagValueLabelObj.getItemAt(j));
    quantityInputText = TextInput (quantityTextInputObj.getItemAt(j));
    
    if(XenosStringUtils.equals(page,ExmConstraints.AMEND_PAGE)){
    	quantityTagValue.includeInLayout = false;
    	quantityTagValue.visible = false;
    	quantityTagValue.includeInLayout =true;
    	quantityInputText.visible = true;
    }else if (XenosStringUtils.equals(page, ExmConstraints.AMEND_USER_CONF_PAGE) || ExmConstraints.AMEND_SYS_CONF_PAGE){
    	quantityTagValue.includeInLayout = true;
    	quantityTagValue.visible = true;
    	quantityInputText.includeInLayout = false;
    	quantityInputText.visible = false;	
    }
    }
    
    //for inputPrice processing
    var inputPriceTagValue:Label = new Label();
    var inputPriceInputText :TextInput = new TextInput();
    for (var j :int = 0; j<noOfInputPrice; j++) {
    inputPriceTagValue = Label (inputPriceTagValueLabelObj.getItemAt(j));
    inputPriceInputText = TextInput (inputPriceTextInputObj.getItemAt(j));
    
    if(XenosStringUtils.equals(page,ExmConstraints.AMEND_PAGE)){
    	inputPriceTagValue.includeInLayout = false;
    	inputPriceTagValue.visible = false;
    	inputPriceTagValue.includeInLayout =true;
    	inputPriceInputText.visible = true;
    }else if (XenosStringUtils.equals(page, ExmConstraints.AMEND_USER_CONF_PAGE) || ExmConstraints.AMEND_SYS_CONF_PAGE){
    	inputPriceTagValue.includeInLayout = true;
    	inputPriceTagValue.visible = true;
    	inputPriceInputText.includeInLayout = false;
    	inputPriceInputText.visible = false;	
    }
    }
    
    
}