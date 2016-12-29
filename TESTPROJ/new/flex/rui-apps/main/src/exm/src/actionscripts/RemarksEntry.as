
// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.exm.ExmConstraints;
import com.nri.rui.exm.validators.RemarksEntryValidator;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;


[Bindable]
public var resultObj:XML;
[Bindable]
private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

[Bindable]
public var messagePkStr:String;		
[Bindable]
public var modeStr:String;	
 
private var keylist:ArrayCollection = new ArrayCollection();

private function loadInit():void{		    	
	parseUrlString(); 

    super.setXenosEntryControl(new XenosEntry());
      
    if(this.modeStr == 'edit'){
        this.dispatchEvent(new Event('amendEntryInit'));                
    }else{
        XenosAlert.error("Invalid Mode for Loading the module : [" + modeStr + "]" );
    }
}

public function parseUrlString():void {
    try {
        var obj:Object = {};
        // Remove everything before the question mark, including
        // the question mark.
        var myPattern:RegExp = /.*\?/; 
        var s:String = this.loaderInfo.url.toString();
        //XenosAlert.info("URL" + s);
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
            if (tempA[0] == "messagePk") {
                obj.messagePk = tempA[1]; //+"="+tempA[2];
            }else if (tempA[0] == "mode") {
                obj.mode = tempA[1];
            }            
        } 
        messagePkStr = obj.messagePk;
        modeStr = obj.mode;
    } catch (e:Error) {
        trace(e);
    }
   
}

override public function preAmendInit():void{     
        
    super.getInitHttpService().url = "exm/exmRemarksEntryDispatchAction.action?rnd="+Math.random();
    var reqObject:Object = new Object();
    reqObject.method="doInitRemarks";    
    reqObject.messagePk = this.messagePkStr;
    reqObject.SCREEN_KEY = 11133;
    super.getInitHttpService().request = reqObject;
}
override public function preAmendResultInit():Object{
    keylist = new ArrayCollection();   
    
    keylist.addItem("messagePk");    
    keylist.addItem("xmlMessageStr");
    keylist.addItem("userComment"); 
    keylist.addItem("assignOfficeList.assignOffice");
    keylist.addItem("assignOffice");
    keylist.addItem("assignTo");
    
    return keylist;
}
override public function postAmendResultInit(mapObj:Object): void{
    commonAmendInit(mapObj);

    app.submitButtonInstance = submit;
}
private function commonAmendInit(mapObj:Object):void{

    if(mapObj!=null){    		
    	var initcol:ArrayCollection = new ArrayCollection();
    	   		
    	errPage.clearError(super.getInitResultEvent());
    	
    	//Set the XML message for display
    	resultObj = XML(mapObj[keylist.getItemAt(1)].toString());
    	displayXml();

        //Set the assign office dropdown list 
        initcol = new ArrayCollection();
    	//initcol.addItem("");
    	for each(var item1:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
    		initcol.addItem(item1);
    	}
    	var selIndx:int = -1;
    	var defaultOffice:String = mapObj[keylist.getItemAt(4)].toString();
	    for(var i:int = 0; i<initcol.length; i++) {
        	//Get the default value object's index
            if(XenosStringUtils.equals((initcol[i]),defaultOffice)){                    
                selIndx = i;
            }                      
	    }	    	
    	this.assignOffice.dataProvider = initcol;
    	if(selIndx != -1)
    	    this.assignOffice.selectedIndex = selIndx;

      	 app.submitButtonInstance = uConfSubmit;        
    	
    	//Set the user comment
    	this.usrRemarks.text = mapObj[keylist.getItemAt(2)].toString();
    	
    	//Set the assign to
    	this.assignTo.employeeText.text = mapObj[keylist.getItemAt(5)].toString();
    	   		
	}else{
	    XenosAlert.info("Unable to load the page.");
	}
}

override public function preAmend():void {
    
    setValidator();
    
    super.getSaveHttpService().url = "exm/exmRemarksEntryDispatchAction.action?rnd="+Math.random();  
         
    var reqObj : Object = new Object();       
    
    reqObj['method'] = "submitRemarks";
    reqObj['userComment'] = this.usrRemarks.text;
    reqObj['assignOffice'] = this.assignOffice.selectedItem != null? this.assignOffice.selectedItem : ""
    reqObj['assignTo'] = this.assignTo.employeeText.text;
    reqObj['SCREEN_KEY'] = 11134;
    super.getSaveHttpService().request = reqObj; 
}

override public function preAmendResultHandler():Object{	    
    keylist = new ArrayCollection();
    keylist.addItem("userComment");     
    keylist.addItem("assignOffice");
    keylist.addItem("assignTo");
    
    return keylist;
}

override public function postAmendResultHandler(mapObj:Object) : void {
    if(mapObj!=null){    		
    	if(mapObj["errorFlag"].toString() == "error"){		    		
    		
    		errPage.showError(mapObj["errorMsg"]);
    		changeState(ExmConstraints.AMEND_PAGE);    		
    		
    	}else if(mapObj["errorFlag"].toString() == "noError"){    		
        	 errPage.clearError(super.getInitResultEvent());
        	 
        	 this.uRemarks.text = mapObj[keylist.getItemAt(0)].toString();
        	 this.uAssignOffice.text = mapObj[keylist.getItemAt(1)].toString();
        	 this.uAssignTo.text = mapObj[keylist.getItemAt(2)].toString();       	 
        	 
        	 
        	 changeState(ExmConstraints.AMEND_USER_CONF_PAGE);		    	 		    	 
    	}else{
    		errPage.removeError();
    		XenosAlert.info("Data Not Found");
    	}    		
	}
}
override public function preAmendConfirm():void
{
    var reqObj :Object = new Object();
    super.getConfHttpService().url = "exm/exmRemarksEntryDispatchAction.action?rnd="+Math.random();
    reqObj.method= "confirmSubmit";
    reqObj['SCREEN_KEY'] = 11135;
    super.getConfHttpService().request = reqObj;
}
override public function preConfirmAmendResultHandler():Object
{
    return preAmendResultHandler();
}
override public function postConfirmAmendResultHandler(mapObj:Object):void
{
    if(mapObj!=null){    		
    	if(mapObj["errorFlag"].toString() == "error"){
    		errPage.showError(mapObj["errorMsg"]);
    		changeState(ExmConstraints.AMEND_PAGE);
    	}else if(mapObj["errorFlag"].toString() == "noError"){    		
        	 errPage.clearError(super.getInitResultEvent());
        	 
        	 this.uRemarks.text = mapObj[keylist.getItemAt(0)].toString();
        	 this.uAssignOffice.text = mapObj[keylist.getItemAt(1)].toString();
        	 this.uAssignTo.text = mapObj[keylist.getItemAt(2)].toString();
        	 
        	 changeState(ExmConstraints.AMEND_SYS_CONF_PAGE);		    	 		    	 
    	}else{
    		errPage.removeError();
    		XenosAlert.info("Data Not Found");
    	}    		
	}
}

private function changeState(dest:String):void{
    
    if(XenosStringUtils.equals(dest, ExmConstraints.AMEND_PAGE)){        
        
        this.submit.includeInLayout = true;
        this.submit.visible = true;
        
        this.back.includeInLayout = false;
        this.back.visible = false;
        
        this.uConfSubmit.includeInLayout = false;
        this.uConfSubmit.visible = false;
        
        this.sConfSubmit.includeInLayout = false;
        this.sConfSubmit.visible = false;
        
        this.uConfLabel.includeInLayout = false;
        this.uConfLabel.visible = false;
        
        this.sConfLabel.includeInLayout = false;
        this.sConfLabel.visible = false;
        
        this.edit.includeInLayout = true;
        this.edit.visible = true;
        
        this.editConf.includeInLayout = false;
        this.editConf.visible = false;
        
        app.submitButtonInstance = submit;        
        
    }else if(XenosStringUtils.equals(dest, ExmConstraints.AMEND_USER_CONF_PAGE)){
        this.submit.includeInLayout = false;
        this.submit.visible = false;
        
        this.back.includeInLayout = true;
        this.back.visible = true;
        
        this.uConfSubmit.includeInLayout = true;
        this.uConfSubmit.visible = true;
        
        this.sConfSubmit.includeInLayout = false;
        this.sConfSubmit.visible = false;
        
        this.uConfLabel.includeInLayout = true;
        this.uConfLabel.visible = true;
        
        this.sConfLabel.includeInLayout = false;
        this.sConfLabel.visible = false;
        
        this.edit.includeInLayout = false;
        this.edit.visible = false;
        
        this.editConf.includeInLayout = true;
        this.editConf.visible = true;
        
        app.submitButtonInstance = uConfSubmit;        

    }else if(XenosStringUtils.equals(dest, ExmConstraints.AMEND_SYS_CONF_PAGE)){
        this.submit.includeInLayout = false;
        this.submit.visible = false; 
        
        this.back.includeInLayout = false;
        this.back.visible = false;
        
        this.uConfSubmit.includeInLayout = false;
        this.uConfSubmit.visible = false;
        
        this.sConfSubmit.includeInLayout = true;
        this.sConfSubmit.visible = true;
        
        this.uConfLabel.includeInLayout = false;
        this.uConfLabel.visible = false;
        
        this.sConfLabel.includeInLayout = true;
        this.sConfLabel.visible = true;
        
        this.edit.includeInLayout = false;
        this.edit.visible = false;
        
        this.editConf.includeInLayout = true;
        this.editConf.visible = true;
        
        app.submitButtonInstance = sConfSubmit;
    }    
}

private function doBack():void{    
    changeState(ExmConstraints.AMEND_PAGE);   
} 

override public function doAmendSystemConfirm(e:Event):void {
    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
}

private function setValidator():void{
			
    var validateModel:Object={
                        exmRemarksEntry:{
                             
                           userComment:this.usrRemarks.text,
                           assignTo:this.assignTo.employeeText.text
                                    
                        }
                       }; 
    super._validator = new RemarksEntryValidator();
    super._validator.source = validateModel ;
    super._validator.property = "exmRemarksEntry";
}