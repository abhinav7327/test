
// ActionScript file for Dynamically generate the View for the XmlMessage
import com.nri.rui.core.controls.XenosAlert;

import mx.containers.HBox;
import mx.containers.Panel;
import mx.controls.Label;


[Bindable]
public var currentPanel : Panel = new Panel();
[Bindable]
public var intendentSize : int = 50;
[Bindable]
public var intendentLavel : int = 0; 

 
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
