//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
function loadAppCache() {
	var $cache = $('div#footer>div#xenos-cache-container>span#cache');
	if(!($cache.data('marketJson'))){
		$.getJSON(xenos.context.path+'/secure/ref/marketTreeJson.json', function(data){
							var marketObj = $.parseJSON(data.marketTreeJson.data);
							$cache.data('marketJson' , marketObj);
							xenos$Cache.put('marketJson' , marketObj);
		});
	}
	
	if(!($cache.data('instrumentJson'))){
		$.getJSON(xenos.context.path+'/secure/ref/instrumentTypeTreeJson.json', function(data){
							var instObj = $.parseJSON(data.instrumentTreeJson.data);
							$('div#footer>div#xenos-cache-container>span#cache').data('instrumentJson' , instObj);
							xenos$Cache.put('instrumentJson' , instObj);
		});
	} 
	
	if(!($cache.data('refApplicationDate'))){
		$.getJSON(xenos.context.path+'/secure/ref/applicationDateJson.json', function(data){
							var todayArr = data.refApplicationDateJson.data.split('/');
							var refApplicationDateObj = new Date(todayArr[2],(todayArr[1] - 1),todayArr[0]);
							$('div#footer>div#xenos-cache-container>span#cache').data('refApplicationDate' , refApplicationDateObj);
		});
	}
	
	/* //caching of STRATEGY code tree
	if(!($cache.data('strategyCodeTree'))){ //data not found in cache
		//make a call to get data
		$.getJSON(xenos.context.path+'/secure/ref/strategyCodeTree.json', function(data){
			//cache the data
			$cache.data('strategyCodeTree' , $.parseJSON(data.strategyCodeTreeJson.data));
		});
	}
	*/
}