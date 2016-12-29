
package com.nri.rui.core.utils {
	
	import flash.printing.PrintJob;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flexlib.containers.WindowShade;
	
	import mx.controls.TextArea;
	import mx.core.Container;
	import mx.managers.LayoutManager;
	import mx.printing.FlexPrintJob;
	import mx.printing.FlexPrintJobScaleType;
	
	/**
	 * Utility class to print RUI pages.
	 */
	public class PrintUtils {
		
		/**
		 * Constructor.
		 */
		public function PrintUtils() {
	    }
		
		/**
		 * It prints simple Detail pages in Xenos. Caller shoulld pass 
		 * the container containing the details that has to be printed.
		 */
		public static function printDetail(printObject:Container):void {
			var children:Array = printObject.getChildren();
			for (var i:int = 0; i < children.length; i ++) {
				if (children[i] is WindowShade) {
					children[i].opened = true;
	   	    	}
	   		}
	    	printObject.executeBindings(true);
	    	var width:Number = printObject.percentWidth;
	    	var height:Number = printObject.percentHeight;
	   		var printJob:FlexPrintJob = new FlexPrintJob();
	   		
    		if (printJob.start()) {
    			try {
    	    		printJob.addObject(printObject, FlexPrintJobScaleType.MATCH_WIDTH);
    	    		printJob.send();
    	    	} catch (error:Error) {
    	 				printObject.scaleX /= printObject.scaleX;
        				printObject.scaleY /= printObject.scaleY;
    	 			if (!isNaN(width)) {
    	 				printObject.percentWidth = width;
    	 				printObject.explicitWidth = NaN;
    	 			}
    	 			if (!isNaN(height)) {
    	 				printObject.percentHeight = height;
    	 				printObject.explicitHeight = NaN;
    	 			}
    	 			LayoutManager.getInstance().usePhasedInstantiation = false;
    	 			LayoutManager.getInstance().validateNow();
    	 		}
    		   	
    	    }
    	 
		}
		
		
		/**
		 * It prints tab based detail pages in Xenos. Caller should pass 
		 * the selected tab instance to print the content of the tab. 
		 */
		public static function printDetailTab(tab:Container):void {
	   		var printJob:FlexPrintJob = new FlexPrintJob();
			var c:Array = tab.getChildren();
	   		var c1:Container = c[0] as Container;
	   		var d:Array = c1.getChildren();
	   		var d1:Container = d[1] as Container;
	   		var e:Array = d1.getChildren();
	   		var e0:Container = e[0] as Container;
	   		var f:Array = e0.getChildren();
	   		for (var i:int = 0; i < f.length; i ++) {
	   			if (f[i] is WindowShade) {
	   				f[i].opened = true;
	   			}
	   		}
	   		c1.executeBindings(true);
	   		var width:Number = c1.percentWidth;
	    	var height:Number = c1.percentHeight;
    		if (printJob.start()) {
    			try {
    				printJob.addObject(c1, FlexPrintJobScaleType.MATCH_WIDTH);
    				printJob.send();
    			} catch (error:Error) {
    	 			c1.scaleX /= c1.scaleX;
        			c1.scaleY /= c1.scaleY;
    	 			if (!isNaN(width)) {
    	 				c1.percentWidth = width;
    	 				c1.explicitWidth = NaN;
    	 			}
    	 			if (!isNaN(height)) {
    	 				c1.percentHeight = height;
    	 				c1.explicitHeight = NaN;
    	 			}
    	 			LayoutManager.getInstance().usePhasedInstantiation = false;
    	 			LayoutManager.getInstance().validateNow();
    	 		}
    			
    		}
	    }
	    
		 /**
		 * Method to print contents of a text area
		 * One must pass the Text Area to use this method. 
		 */  
		public static function doPrintTextArea(inputTxtArea:TextArea):void {                
			var pj:PrintJob = new PrintJob();                         
			if (pj.start()){                 
				try {                                       
					var txt:TextField = new TextField();                     
					txt.multiline = true;                     
					txt.wordWrap = true;                                 
					txt.width = pj.pageWidth;                     
					txt.height = pj.pageHeight;                     
					txt.text = inputTxtArea.text;  
					txt.htmlText = inputTxtArea.htmlText;  
				    txt.background = true; 
					txt.backgroundColor = 0xFFFFFF; 
					txt.border = true;
					txt.borderColor = 0x000000;
					
					var textFormat:TextFormat = new TextFormat("Arial", 7);
					textFormat.leftMargin = 10;
					txt.setTextFormat(textFormat);     
					                                         
					var mc:TextArea = new TextArea();                     
					mc.addChild(txt);                                                           
					var complete:Boolean = false;  
					var isFirstPage:Boolean = true;
	                var secondPage:Boolean = false;
	                var multiPage:Boolean = false;
	               
	        
	                // Scroll counts starts from 1  
					while (!complete) { 
						if (!isFirstPage && txt.scrollV == txt.maxScrollV){
							 break;     
						}         
						var nextScrollIndex:uint = txt.bottomScrollV + 1;  
						// Code to add extra lines to the txt content, if this is not done then
						// the last printed page will contain repeated contents of the previous page
						if (secondPage){
	                            var linesPerPage:uint = txt.bottomScrollV - txt.scrollV + 1;
	                            var lastPageNumLines:uint = txt.numLines % linesPerPage - 1; 
	                            var extraLinesNeeded:uint;              
	                            if (lastPageNumLines == 0){ 
	                            	extraLinesNeeded = 0;
	                            }
	                            else{ 
	                            	 extraLinesNeeded = linesPerPage - lastPageNumLines;
		                           	 txt.htmlText += multipleChars("\n", extraLinesNeeded);
		                           	 secondPage = false;
		                           	 multiPage = true;                    	
	                            }  
	                    }
	                   	if (isFirstPage){
	                        isFirstPage = false;
	                        secondPage = true;
	                   	}
	                   	 // If it's not the first page, then scroll to the next page we want to print
					    else{   
	                         txt.scrollV = nextScrollIndex;                     
	                     }   
	                        // If we are at the bottom of the textfield, then set complete to true, which will end the loop
	                     if (txt.scrollV == txt.maxScrollV){
	                     	complete = true;
	                     }  
	                     // Skip the last page in case of multipage Text Fields, as this method gives a blank
	                     // text field to be printed at the end of the loop  
	                     if(multiPage&&complete){
	                    	break;
	                     }
	                     pj.addPage(mc);
	                    
					}                                
				} catch (e:Error) {                     
					trace(e);  	                     
				} 
			             
		    pj.send();             
			}         
		}
	 
		/**
		 * Method to add new lines to the last page of a text area
		 */  
		public static function multipleChars(char:String, num:int):String {
	        var n:int = num;
	        var s:String = XenosStringUtils.EMPTY_STR;
	        while (n>0) {
	          s+=char;
	          n--
	        }
	        return s;
	    }   
	}
	  
	  
	   
}