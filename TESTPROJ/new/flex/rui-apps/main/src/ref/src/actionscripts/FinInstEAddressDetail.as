// ActionScript file
		import com.nri.rui.core.controls.XenosAlert;
		
		import mx.collections.XMLListCollection;
		import mx.controls.dataGridClasses.DataGridColumn;
		import mx.managers.PopUpManager;
		import mx.rpc.events.ResultEvent;
		import mx.utils.ObjectUtil;


 // ActionScript file for FinInstEaddress Query
 
 			[Bindable]
    		private var finInstDeliveryEAddressRule:XMLListCollection = new XMLListCollection();
    		
    		[Bindable]
    		private var finInstElectronicAddress:XMLListCollection = new XMLListCollection();
    		
    		/* [Bindable]
            private var queryResult:XML= new XML(); */
 			
			private function submitRequest():void{
			 // XenosAlert.info("In  submitRequest");	
			  var requestObj :Object = populateRequestParams();
	     	
	     	  eaddressQueryRequest.request = requestObj; 
	     	  
	    	  eaddressQueryRequest.send();
		      PopUpManager.centerPopUp(this);
			  //XenosAlert.info("In  submitRequest end");	
			}
		
		/**
	    * This method will populate the request parameters for the
	    * submitQuery call and bind the parameters with the HTTPService
	    * object.
	    */
	    private function populateRequestParams():Object {
	    	
			//XenosAlert.info("In  populateRequestParams");	
	    	var reqObj : Object = new Object();
	     	reqObj.method = "finInstEAddressDetailView";
	     	return reqObj;
	    }
	    
	    private function LoadResultPage(event:ResultEvent):void{
	    	
			 // XenosAlert.info("In  LoadResultPage");	
	    	//var xmlData:XML = new XML();
	    	var queryResult:XML = XML(event.result);
    		if (null != event) {        
    		
			    //XenosAlert.info("In  event"+event);	    
            if(null == event.result){
			    //XenosAlert.info("In  event.result"+event.result);	    
                //queryResult.removeAll(); // clear previous data if any as there is no result now.
            	if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
            	  //  errPage.clearError(event); //clears the errors if any
            		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            	} else { // Must be error
            		//errPage.displayError(event);	
            	}            	
            }else {            
			  //  XenosAlert.info("In  queryResult start");	
             	//queryResult = event.result as XML;
             	
             	
			    //XenosAlert.info("In  queryResult end" + event.result.toString());
			    if(!queryResult){			    	
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    }else{
			       //finInstDeliveryEAddressRule = queryResult.deliveryEAddressRules.deliveryEAddressRule as XMLListCollection;
	             
	               if(queryResult.child("deliveryEAddressRules").length() > 0){
	               	   var deliveryEAddressRules:XML = XML(queryResult.deliveryEAddressRules);
	               	 
	               	   if(deliveryEAddressRules.child("deliveryEAddressRule").length() > 0){	 
			               for each(var delEAddr : XML in deliveryEAddressRules.deliveryEAddressRule){
			               		finInstDeliveryEAddressRule.addItem(delEAddr);
			               }
	               	   }
		           }
	               //finInstElectronicAddress = queryResult.electronicAddresses.electronicAddress as XMLListCollection;
			    
	              if(queryResult.child("electronicAddresses").length() > 0){
	               	
	               	   var 	electronicAddresses:XML = XML(queryResult.electronicAddresses);
	               	   
	               	   if(electronicAddresses.child("electronicAddress").length() > 0){	 
			               for each(var delEAddrRule : XML in electronicAddresses.electronicAddress){
			               		finInstElectronicAddress.addItem(delEAddrRule);
			               }
	               	   }
		           }		
			    }
            } 
        }else {
            //queryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
	    }
	    
	    
 /**
   * @return reportId
   */
   private function displayReportId( row:Object, column:DataGridColumn):String {
         		return row.(@key=='reportId').value;
      		}
   /**
   * @return reportGroupId
   */ 
   private function displayReportGroupId( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='reportGroupId').value;
      		}
   /**
   * @return addressId
   */
   private function displayAddressId( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='addressId').value;
      		}
   /**
   * @return addressType
   */ 
   
   private function displayAddressType( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='addressType').value;
      		}      		
   /**
   * @return autoManualFeedFlagExp
   */
   private function displayAutoManualFeedFlagExp( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='autoManualFeedFlagExp').value;
      		}
   /**
   * @return phone
   */ 
   private function displayPhone( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='phone').value;
      		}
      		
   /**
   * @return mobile
   */ 
   private function displayMobile( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='mobile').value;
      		}
	/**
   * @return fax
   */ 
   private function displayFax( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='fax').value;
      		}
      		      			
	/**
   * @return tlxCountryCode
   */ 
   private function displayTlxCountryCode( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='tlxCountryCode').value;
      		}
	/**
   * @return email
   */ 
   private function displayEmail( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='email').value;
      		}    
      		
	 /**
   * @return tlxDial
   */ 
   private function displayTlxDial( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='tlxDial').value;
      		}
	/**
   * @return swiftCode
   */ 
   private function displaySwiftCode( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='swiftCode').value;
      		}
      		      			
	/**
   * @return answerBack
   */ 
   private function displayAnswerBack( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='answerBack').value;
      		}
	/**
   * @return recipientName
   */ 
   private function displayRecipientName( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='recipientName').value;
      		} 
	   		      			
	/**
   * @return oasysCode
   */ 
   private function displayOasysCode( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='oasysCode').value;
      		}
	/**
   * @return attention
   */ 
   private function displayAttention( row:Object, column:DataGridColumn ):String {
         		return row.(@key=='attention').value;
      		}       		     		      		      			
      		  		      		      			
