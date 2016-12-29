//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
$('.popSubmitBtn').die();
$('.popSubmitBtn').live('click',function(e) {
		setTopMost();
		 var btn = $(e.target);
		$(e.target).attr('disabled', true);
		$('div.ui-dialog-titlebar').children('.popupFormTabErrorIco').remove();
        e.preventDefault();
        var form = $('.ui-dialog.topMost #popQueryForm');
        var commandFormId = '?commandFormId=' + $('[name=commandFormId]',form).val();
        var fragmentName = '&fragments=content';
		$.ajax({
            type: "POST",
            url: form.attr('action') + commandFormId + fragmentName,
            data: form.serialize(),
            beforeSend: function(req) {
                req.setRequestHeader("Accept", "text/html;type=ajax");
            },  
            complete : function(jqXHR) {
				btn.removeAttr('disabled');
				if(jqXHR.responseText.indexOf('errorMsg') != -1){
					var msg =[];
					$.each($(jqXHR.responseText).find('ul.errorMsg li'), function(index,value){
						msg.push($(value).text());
					});
					//xenos.postNotice(xenos.notice.type.error, msg);
					$('div.ui-dialog-titlebar').append('<span class="popupFormTabErrorIco" title="Error message">Error</span>');
					
					  // Default OnReady Handler bounded for .formTabErrorIco
					  $('.popupFormTabErrorIco').die();					  
					  $('.popupFormTabErrorIco').live('click', xenos.postNotice(xenos.notice.type.error, msg, true));
				}
				$(".ui-dialog.topMost #popUpQueryFormParent").html(jqXHR.responseText);
				if((typeof grid_result_data !== 'undefined' && grid_result_data != undefined) && (typeof $('.ui-dialog.topMost #popUpQueryResultForm').get(0) !== 'undefined'))
					$('.ui-dialog.topMost #popUpQueryResultForm .pop-xenos-grid').xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
            }
        });
	});	
	