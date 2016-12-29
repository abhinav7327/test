//$Id$
//$Author: projand $
//$Date: 2016-12-23 17:26:39 $

/*
 * +=======================================================================+
 * |                                                                       |
 * |          Copyright (C) 2000-2004 Nomura Securities Co., Ltd.          |
 * |                          All Rights Reserved                          |
 * |                                                                       |
 * |    This document is the sole property of Nomura Securities Co.,       |
 * |    Ltd. No part of this document may be reproduced in any form or     |
 * |    by any means - electronic, mechanical, photocopying, recording     |
 * |    or otherwise - without the prior written permission of Nomura      |
 * |    Securities Co., Ltd.                                               |
 * |                                                                       |
 * |    Unless required by applicable law or agreed to in writing,         |
 * |    software distributed under the License is distributed on an        |
 * |    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,       |
 * |    either express or implied.                                         |
 * |                                                                       |
 * +=======================================================================+
 */

 xenos.ns.views.trdCnfReadOnlyQuery.validateSubmit = function validate(){
	var alertStr = [];	
	
	var tradeDateFrom  = $('#tradeDateFrom').val();
	var tradeDateTo    = $('#tradeDateTo').val();
	var valueDateFrom  = $('#valueDateFrom').val();
	var valueDateTo    = $('#valueDateTo').val();
	var receiveDateFrom  = $('#receiveDateFrom').val();
	var receiveDateTo    = $('#receiveDateTo').val();

	
	var dateFormatValidationFails = false;
	
	if(dateFormatValidationFails==false && tradeDateFrom.length > 0 && isDateCustom(tradeDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeQuery.date_format_check , [tradeDateFrom]));
	}
	
	if(dateFormatValidationFails==false && tradeDateTo.length > 0 && isDateCustom(tradeDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeQuery.date_format_check , [tradeDateTo]));
	}
	
	if(dateFormatValidationFails==false && valueDateFrom.length>0 && isDateCustom(valueDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeQuery.date_format_check , [valueDateFrom]));
	}
	
	if(dateFormatValidationFails==false && valueDateTo.length>0 && isDateCustom(valueDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeQuery.date_format_check , [valueDateTo]));
	}
	
	if(dateFormatValidationFails==false && receiveDateFrom.length>0 && isDateCustom(receiveDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeQuery.date_format_check , [receiveDateFrom]));
	}
	
	if(dateFormatValidationFails==false && receiveDateTo.length>0 && isDateCustom(receiveDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeQuery.date_format_check , [receiveDateTo]));
	}
	
	if(dateFormatValidationFails==false){
	
		if(xenos.ns.views.trdCnfReadOnlyQuery.isValidText(tradeDateFrom) && xenos.ns.views.trdCnfReadOnlyQuery.isValidText(tradeDateTo)) {
			// Validate Trade Date From - To
			if (!isValidDateRange(tradeDateFrom, tradeDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(xenos.ns.views.trdCnfReadOnlyQuery.isValidText(valueDateFrom) && xenos.ns.views.trdCnfReadOnlyQuery.isValidText(valueDateTo)) {
			// Validate Value Date From - To
			if (!isValidDateRange(valueDateFrom, valueDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(xenos.ns.views.trdCnfReadOnlyQuery.isValidText(receiveDateFrom) && xenos.ns.views.trdCnfReadOnlyQuery.isValidText(receiveDateTo)) {
			// Validate Receive Date From - To
			if (!isValidDateRange(receiveDateFrom, receiveDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(dateFormatValidationFails) {
			alertStr.push(xenos$TRD$i18n.tradeQuery.date_from_to_check);
		}
	}		
	
	//Show the error message
	if(alertStr.length > 0){
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, alertStr, true));
		return false;
	}else{
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
	}
	return true;
 }
 
   xenos.ns.views.trdCnfReadOnlyQuery.isValidText = function(text){
	if(text!='undefined' && text!=null && $.trim(text).length > 0){
		return true;
	}
	return false;
 }
 
  xenos.ns.views.trdCnfReadOnlyQuery.formatDate = function formatCnfDate(date,id){
	if(date.length == 7){
		id.val(date.substr(0,6)+"0"+date.substr(6));
	}
 }