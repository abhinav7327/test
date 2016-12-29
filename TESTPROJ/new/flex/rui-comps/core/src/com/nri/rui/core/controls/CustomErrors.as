/*

$LastChangedDate$
$Author: anubhavg $
*/


 
package com.nri.rui.core.controls
{
	import mx.controls.TextArea;
	import mx.rpc.events.ResultEvent;
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	/**
	 * This class can be used to display errors from any module.
	 * Usage: 
	 * 		<cntrls:CustomErrors id="errPage" backgroundColor="0xCCCCCC" width="80%" height="5%" 
	 * 		        color="#FF0000" includeInLayout="false" borderStyle="none"/>
	 * 
	 * 		cntrls is the name space to locate this class from SWC.
	 * 		backgroundColor, width, height may vary but other should same to retain its puspose.
	 * 
	 */
	public class CustomErrors extends TextArea
	{
		private var errors:ArrayCollection;
		public function CustomErrors()
		{
			super();		
			this.wordWrap=true;			
			//this.includeInLayout=false;
			this.editable=false;						
		}
		/**
		 * This method will be used to display errors.
		 * 
		 */
		public function displayError(event:ResultEvent):void {
            text = "";
            this.includeInLayout=true;
		    if(event != null){
			    if(event.result.XenosErrors.error is ArrayCollection){
					errors = event.result.XenosErrors.error;
			    } else {
					errors = new ArrayCollection();
				errors.addItem(event.result.XenosErrors.error);
			    }

			    var i:int=0;			   
			    if (errors != null) {
				  for (i=0; i<errors.length ;i++) {
				    text = text +"\n"+ StringUtil.trim(errors[i]);
				  }			       	  
			    }
		    }		    
		}
		/**
		 * This method will be used to clear errors.
		 * 
		 */
		public function clearError(event:ResultEvent):void { 
		    text = "";
		    this.includeInLayout=false;		    
		}	
	}
}