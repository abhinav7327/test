//$Id$
//$Author: himanshum $
//$Date: 2016-12-27 19:21:25 $

			 var xenos$Handler$InstrumentTabLoad = xenos$Handler$function({
				get : {
					requestType : xenos$Handler$default.requestType.asynchronous,
					target : '#content'
				},
				settings : {
					beforeSend : function(request) {
						request.setRequestHeader('Accept', 'text/html;type=ajax');
						
					},
					type: 'POST'
				}
			});
			
			 var form =$('#commandForm');
			 function loadTab(e) {
				 	$('#instrumentTypeFlag').val(true);
					var requestUrl = xenos.context.path + "/secure/ref/instrument/entry/loadTab?commandFormId=" + $('[name=commandFormId]').val()+"&fragments=content";
					xenos$Handler$InstrumentTabLoad.generic(e, { requestUri: requestUrl,
                                                        settings: {data : form.serialize()},
                                                        onHtmlContent :  function(e, options, $target, content) {
															xenos.ns.views.instrumentEntryAmend.showNext();
															$target.html(content);
                                                        }
                                                     }
                                        );
			}
			
	 		xenos.ns.views.instrumentEntryAmend.showNext = function (){
				if($("#actionType").val() == "ENTRY" || $("#actionType").val() == "entry"){
					$("#formActionArea > div > div > .wizNext > .inputBtnStyle").css('display','block');
				}
			}
			
			xenos.ns.views.instrumentEntryAmend.formatDate = function(target){
				var value=target.value;
				if(value.length == 7){
					$("#"+target.id).val(value.substr(0,6)+"0"+value.substr(6));
				}
			}
			
			xenos.ns.views.instrumentEntryAmend.formatDate1 = function(value){
				if(value.length == 7){
					$("#"+target.id).val(value.substr(0,6)+"0"+value.substr(6));
				}
			}

			 xenos.ns.views.instrumentEntryAmend.addDayToDate = function(inputDate){
				 
					xenos.ns.views.instrumentEntryAmend.formatDate1(inputDate);
					if(VALIDATOR.isNullValue( $("#nextCouponDateId").val())){
						xenos.ns.views.instrumentEntryAmend.dateCalcHelper(inputDate);
					}
					
				}
				
				Date.prototype.toInputFormat = function() {
				   var yyyy = this.getFullYear().toString();
				   var mm = (this.getMonth()+1).toString(); // getMonth() is zero-based
				   var dd  = this.getDate().toString();
				   return yyyy + (mm[1]?mm:"0"+mm[0]) + (dd[1]?dd:"0"+dd[0]); // padding
				};	
				
				
				xenos.ns.views.instrumentEntryAmend.dateCalcHelper = function(inputDate1){
					//var inputDate1 = inDate1.value;
					var dateYear = inputDate1.substring(0,4); 
					var dateMonth = parseInt(inputDate1.substring(4,6),10)-1;
					var dateDay = inputDate1.substring(6);
					var days = "";
					var date = new Date(dateYear,dateMonth.toString(),dateDay);
					var day = $("#fixedCouponDaysId").val(); 
					if(day != '' && day != undefined && day!=null){
						days = parseInt(day, 10);
					}
					  
					if(!isNaN(date.getTime()) && (days != '' && days != undefined && days!=null)){
						date.setDate(date.getDate() + days);
						$("#nextCouponDateId").val(date.toInputFormat());
					}
				}
				
				
				xenos.ns.views.instrumentEntryAmend.addDays = function(target){
						
					var validationMessages = [];
					formatQuantity($('#fixedCouponDaysId'),5,0,validationMessages,$('#fixedCouponDaysId').parent().parent().find('label').text());
					
					if ( validationMessages.length >0){
						xenos.utils.displayGrowlMessage(xenos.notice.type.error, validationMessages);
						 return false;
					}else{
						$('.formHeader').find('.formTabErrorIco').css('display', 'none');
						
						
						if((target != "" && target != null && target != undefined) && VALIDATOR.isNullValue( $("#nextCouponDateId").val() ) ){
							if($("#prevCouponDateId").val() != "" && $("#prevCouponDateId").val() != null && $("#prevCouponDateId").val() != undefined){
								xenos.ns.views.instrumentEntryAmend.dateCalcHelper($("#prevCouponDateId").val());
							}
						}
					} 
					return true;
				}
				
				
				xenos.ns.views.instrumentEntryAmend.getMonth = function(target){
					
					var month = new Array();
					month[0] = "January";
					month[1] = "February";
					month[2] = "March";
					month[3] = "April";
					month[4] = "May";
					month[5] = "June";
					month[6] = "July";
					month[7] = "August";
					month[8] = "September";
					month[9] = "October";
					month[10] = "November";
					month[11] = "December";
					
					return month[target-1];
					
				}
				
				
				xenos.ns.views.instrumentEntryAmend.getDayByMonth = function(target){
					var result =[ {1 : 31}, {2 : 28},{3 : 31}, {4 : 30},{5 : 31}, {6 : 30},{7 : 31}, {8 : 31},{9 : 30}, {10 : 31},{11 : 30}, {12 : 31} ];
					return result[target-1][target];
				}
			