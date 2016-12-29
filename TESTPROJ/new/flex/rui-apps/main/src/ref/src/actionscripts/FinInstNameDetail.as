// ActionScript file

    import com.nri.rui.core.controls.XenosAlert;
    import mx.collections.XMLListCollection;
    import mx.managers.PopUpManager;
    import mx.rpc.events.ResultEvent;
    
    [Bindable]
    private var queryNameResult:XML= new XML();
    
    [Bindable]
    private var finInstNameDetail:XMLListCollection= new XMLListCollection();
    
    public function submitNameDetailQuery():void{
    	
    	if(DgDetails.visible==false){
    	    finInstNameDetailRequest.send();
    		DgDetails.visible=true;
    	}else{
    		DgDetails.visible=false;    		
    	}
    }
    
    	   
     /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    public function LoadNameDetailsResultPage(event:ResultEvent):void {
    	//var xmlData:XML = new XML();
    	if (null != event) {            
            if(null == event.result){
                //queryResult.removeAll(); // clear previous data if any as there is no result now.
            	if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
            	  //  errPage.clearError(event); //clears the errors if any
            		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            	} else { // Must be error
            		//errPage.displayError(event);	
            	}            	
            }else {
            
             	queryNameResult = XML(event.result);
             	//trace("queryNameDetails : "+ queryNameResult.toXMLString());
	           // finInstNameDetail = queryNameResult.finInstNameCrossRefs.finInstNameCrossRef as XMLListCollection; 
	           
	            if(queryNameResult.child("finInstNameCrossRefs").length() > 0){
	               	   var finInstNameCrossRefs:XML = XML(queryNameResult.finInstNameCrossRefs);
	               	 
	               	   if(finInstNameCrossRefs.child("finInstNameCrossRef").length() > 0){	 
			               for each(var fnameXRef : XML in finInstNameCrossRefs.finInstNameCrossRef){
			               		finInstNameDetail.addItem(fnameXRef);
			               }
	               	   }
		           }
	            //trace(finInstNameDetail.length); 
            } 
        }else {
            //queryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
    }
    
    /**
   * @return charsetCode
   */
   private function displayCharsetCode( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='charsetCode').value;
      		}
   /**
   * @return shortName
   */ 
   private function displayShortName( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='shortName').value;
      		}
   /**
   * @return officialName1
   */
   private function displayOfficialName1( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='officialName1').value;
      		}
   /**
   * @return officialName2
   */ 
   
   private function displayOfficialName2( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='officialName2').value;
      		}      		
   /**
   * @return officialName3
   */
   private function displayOfficialName3( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='officialName3').value;
      		}
   /**
   * @return officialName4
   */ 
   private function displayOfficialName4( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='officialName4').value;
      		}
