// ActionScript file
import mx.collections.ArrayCollection;

    /**
     * Array to hold the Account based column order for query result.
     * The contents are the dataField property value of the data grod columns.
     */
    /* private const accountBasedColumns:Array = [ "accountPrefix", "accountName", "fundCode", "securityId", 
                                                "instrumentName", "baseDateDisp", "tradeDateDisp", "valueDateDisp",
                                                "description", "amountDisp", "formattedPrice", "balanceDisp", 
                                                "transactionRefNo"
                                              ]; */

    /**
     * Array to hold the Security based column order for query result.
     * The contents are the dataField property value of the data grod columns.
     */
    /* private const securityBasedColumns:Array = [ "securityId", "instrumentName","accountPrefix", "accountName",
                                                 "fundCode",  "baseDateDisp", "tradeDateDisp", "valueDateDisp",
                                                 "description", "amountDisp", "formattedPrice", "balanceDisp", 
                                                 "transactionRefNo"
                                               ]; */
    
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = SummaryResult;
	//qh.pdf.enabled = false;
	//qh.xls.enabled = false;
    } 
    
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        httpService.request = reqObj;
        httpService.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        httpService.request = reqObj;
        httpService.send();
    }
    
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "cam/camMovementQueryDispatch.action?method=generateXLS";
	var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        // set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
         try {
                navigateToURL(request,"_blank");
         } catch (e:Error) {
                // handle error here
                trace(e);
         }



       /* var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
         try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            }*/
    } 
    /**
    * This will generate the Pdf report for the entire query result set 
    * and will open in a separate window.
    */
     private function generatePdf():void {
        var url : String = "cam/camMovementQueryDispatch.action?method=generatePDF";
	var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        // set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
         try {
                navigateToURL(request,"_blank");
         } catch (e:Error) {
                // handle error here
                trace(e);
         }


        /*var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
         try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            }*/
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
     * Change the order of the result columns depending on the value of the 
     * accountBasedFlag of the result view records.
     * 
     * @param event The ResultEvent received from the server responce after the query request.
     * 
     */
    /* private function changeColumnOrder(event:ResultEvent):void{
        var resultColl:ArrayCollection = new ArrayCollection();
        var arrayColl:ArrayCollection = new ArrayCollection();
        var tempArrayColl:ArrayCollection = new ArrayCollection();
        var objResult:Object;        
        
        if (null != event) {            
            if(null != event.result.rows){
                if(event.result.rows.row != null){   
                    if(event.result.rows.row is ArrayCollection) {
                            resultColl = event.result.rows.row as ArrayCollection;
                    } else {                            
                            resultColl.addItem(event.result.rows.row);
                    }
                    
                    objResult = resultColl.getItemAt(0);
                    if(objResult != null){
                        arrayColl.source = SummaryResult.columns;
                        tempArrayColl.source = SummaryResult.columns;
                        
                        if(objResult.accountBasedFlag == true){
                            //XenosAlert.info("Account based ordering done.");
                            tempArrayColl = orderColumns(arrayColl,accountBasedColumns,tempArrayColl);
                        }else if(objResult.accountBasedFlag == false){
                            //XenosAlert.info("Security based ordering done.");                            
                            tempArrayColl = orderColumns(arrayColl,securityBasedColumns,tempArrayColl);
                        }else{
                            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cam.common.prompt.no.column.ordering'));
                        }
                        SummaryResult.columns = tempArrayColl.source;
                    }
                } 
            }
         }
    } */
    
    /**
     * This method reorders the columns based on the supplied column array. 
     * @param dgColumns      The current oredred columns.
     * @param colOrder       The column order to be done.
     * @param orderedColumns The current oredred columns which will be modified for final oredr.
     * @return               The final ordered columns.
     * 
     */
    /* private function orderColumns(dgColumns:ArrayCollection,colOrder:Array,orderedColumns:ArrayCollection):ArrayCollection{
        var dgc : DataGridColumn;
        var i:int=0;
        var j:int=0;
        
        for(i=0;i<dgColumns.length;i++){
            dgc = DataGridColumn(dgColumns.getItemAt(i));                                
            
            j=colOrder.indexOf(dgc.dataField);                                
            if(j != -1)
                orderedColumns.setItemAt(dgc,j);
        }
        return orderedColumns;
    } */