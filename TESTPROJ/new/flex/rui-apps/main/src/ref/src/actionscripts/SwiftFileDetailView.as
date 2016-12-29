
// ActionScript file

 // ActionScript file for Trade Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.startup.XenosApplication;
    
    import flash.net.FileReference;
        
    import flash.printing.PrintJob;
    import flash.text.TextField;
    
    import mx.collections.ArrayCollection;
    import mx.controls.TextArea;
    [Bindable]
    //private var initColl:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var queryResult:XML= new XML();    
    private var initCompFlg : Boolean = false;
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);    
    [Bindable]
    public var messageContent:String;
    private var messageType:String;
    private var receiveDate:String;
    private var messageId:String;
    	   
    // Parse url        
    public function parseUrlString():void {
        try {
            // Remove everything before the question mark, including
            // the question mark.
            var myPattern:RegExp = /.*\?/; 
            var dataObj2:Object = this.parentDocument.data;
            var s:String = this.loaderInfo.url.toString();
            s = s.replace(myPattern, "");
            // Create an Array of name=value Strings.
            var params:Array = s.split("&"); 
             // Print the params that are in the Array.
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
            //messageContent = dataObj2.toString();
            messageContent = dataObj2.swiftMessage.toString();
            messageType = dataObj2.messageType.toString();
            receiveDate = dataObj2.receivedDateStr.toString();
            messageId = dataObj2.id.toString();
            
        } catch (e:Error) {
            trace(e);
        }
    }
    
    public function saveSwift():void {
            fileDownload.downloadUrl = "ref/swiftMsgQueryDispatch.action?method=getMessageContent";
            fileDownload.downloadUrl += "&id=" + messageId;
            fileDownload.downloadFileName = messageType + "_" + receiveDate + ".txt";
            fileDownload.startDownload();
    }
