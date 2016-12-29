
 
package com.nri.rui.stl.Utility {
	
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.XenosStringUtils;
	import mx.controls.TextInput;
	import mx.core.Application;
	
	public class SettlementUtils {
		
		public function SettlementUtils() { }
		
		/*
		 * This function is called from the application.
		 */
		public static function changeNumberFormat(txtField:TextInput,strAlert:String):void {
			//XenosAlert.info(txtField.text);
			var strQty:String = txtField.text;
			
			if(!XenosStringUtils.isBlank(strQty)) {
				
				if(isNaN(new Number(strQty))) {
					if(strQty.charAt(strQty.length-1) == 'M') {
						if(isNaN(new Number(strQty.substring(0,strQty.length-1)))) {
							XenosAlert.info(Application.application.xResourceManager.getKeyValue('stl.label.utils.enter.valid')+" "+strAlert);
						} else {
							if(new Number(strQty.substring(0,strQty.length-1))>0) {
								txtField.text = calculate(strQty.substring(0,strQty.length-1),'1000000');
							} else {
								XenosAlert.info(Application.application.xResourceManager.getKeyValue('stl.label.utils.enter')
												+" "+strAlert+" "
												+Application.application.xResourceManager.getKeyValue('stl.label.utils.enter.greater.thanzero'));
							}
						}
					} else if(strQty.charAt(strQty.length-1) == 'B') {
						if(isNaN(new Number(strQty.substring(0,strQty.length-1)))) {
							XenosAlert.info(Application.application.xResourceManager.getKeyValue('stl.label.utils.enter.valid')
											+" "+strAlert);
						} else {
							if(new Number(strQty.substring(0,strQty.length-1))>0) {
								txtField.text = calculate(strQty.substring(0,strQty.length-1),'1000000000');
							} else {
								XenosAlert.info(Application.application.xResourceManager.getKeyValue('stl.label.utils.enter')
												+" "+strAlert+" "
												+Application.application.xResourceManager.getKeyValue('stl.label.utils.enter.greater.thanzero'));
							}
						}
					} else if(strQty.charAt(strQty.length-1) == 'T') {
						if(isNaN(new Number(strQty.substring(0,strQty.length-1)))) {
							XenosAlert.info(Application.application.xResourceManager.getKeyValue('stl.label.utils.enter.valid')
											+" "+strAlert);
						} else {
							if(new Number(strQty.substring(0,strQty.length-1))>0) {
								txtField.text = calculate(strQty.substring(0,strQty.length-1),'1000');
							} else {
								XenosAlert.info(Application.application.xResourceManager.getKeyValue('stl.label.utils.enter')
												+" "+strAlert+" "
												+Application.application.xResourceManager.getKeyValue('stl.label.utils.enter.greater.thanzero'));
							}
						}
					} else if(strQty.search(',') > -1) {
						
						var strReplaced:String = strQty.replace(',','');
						
						while(strReplaced.search(',') > -1) {
							strReplaced = strReplaced.replace(',','');
						}
						
						//XenosAlert.info("*** strReplaced = "+strReplaced);
						var iPointPosition:int = strReplaced.lastIndexOf('.');
						var strTruncatedQty:String = "";
						var strAfterPoint:String = "";
						//XenosAlert.info("*** iPointPosition = "+iPointPosition);
						if(iPointPosition > -1) {
							strAfterPoint = strReplaced.substring(iPointPosition,strReplaced.length);
							strTruncatedQty = strReplaced.substring(0,iPointPosition);
						} else {
							strTruncatedQty = strReplaced;
						}
						//XenosAlert.info("*** strTruncatedQty = "+strTruncatedQty);
						if(isNaN(new Number(strTruncatedQty))) {
							XenosAlert.info(Application.application.xResourceManager.getKeyValue('stl.label.utils.enter.valid')
											+" "+strAlert);
						} else {
							if(new Number(strTruncatedQty) > 0) {
								txtField.text = calculate(strTruncatedQty,null)+strAfterPoint;
							} else {
								XenosAlert.info(Application.application.xResourceManager.getKeyValue('stl.label.utils.enter')
												+" "+strAlert+" "
												+Application.application.xResourceManager.getKeyValue('stl.label.utils.enter.greater.thanzero'));
							}
						}
						
					} else {
						XenosAlert.info(Application.application.xResourceManager.getKeyValue('stl.label.utils.enter.valid')
										+" "+strAlert);
					}
				} else {
					if(new Number(strQty) > 0) {
						if(new Number(strQty) >= 1000) {
							if(strQty.search('.') > -1) {
								var iPointPosition:int = strQty.lastIndexOf('.');
								var strTruncatedQty:String = "";
								var strAfterPoint:String = "";
								
								if(iPointPosition > -1) {
									strAfterPoint = strQty.substring(iPointPosition,strQty.length);
									strTruncatedQty = strQty.substring(0,iPointPosition);
								} else {
									strTruncatedQty = strQty
								}
								
								txtField.text = calculate(strTruncatedQty,null)+strAfterPoint;
							} else {
								txtField.text = calculate(strQty,null);
							}
						}
					} else {
						XenosAlert.info(Application.application.xResourceManager.getKeyValue('stl.label.utils.enter')
										+" "+strAlert+" "
										+Application.application.xResourceManager.getKeyValue('stl.label.utils.enter.greater.thanzero'));
					}
				}
			}
		}
		/*
		 *  This function calculates and returns the formated String.
		 */
		private static function calculate(strAmount:String,strVal:String):String {
			var num:Number =  strVal!=null?
											((new Number(strAmount)) * (new Number(strVal)))
											:(new Number(strAmount));
			var strNum:String = num.toString();
			var strTemp:String = "";
				
			if((strNum.length % 3) == 0) {
				for(var i:int=0;i<strNum.length;++i) {
					if(i>0 && i%3==0) {
						strTemp=strTemp+","+strNum.charAt(i);
					} else {
						strTemp=strTemp+strNum.charAt(i);
					}
				}
				//XenosAlert.info(strNum);
			} else if((strNum.length % 3) == 1) {
				strTemp = strNum.charAt(0)+",";
				var strA:String = strNum.substr(1,strNum.length-1);
				for(var j:int=0;j<strA.length;++j) {
					if(j>0 && j%3==0) {
						strTemp=strTemp+","+strA.charAt(j);
					} else {
						strTemp=strTemp+strA.charAt(j);
					}
				}
				//XenosAlert.info("strA = "+strA);
			} else if((strNum.length % 3) == 2) {
				strTemp = strNum.substr(0,2)+",";
				var strB:String = strNum.substr(2,strNum.length-2);
				for(var k:int=0;k<strB.length;++k) {
					if(k>0 && k%3==0) {
						strTemp=strTemp+","+strB.charAt(k);
					} else {
						strTemp=strTemp+strB.charAt(k);
					}
				}
				//XenosAlert.info("strB = "+strB);
			}
			return strTemp;
		}
	}
}