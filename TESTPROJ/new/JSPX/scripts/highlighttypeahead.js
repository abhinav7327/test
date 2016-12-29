//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 
        function doHighlightTreeData(typed,display){
				var arr = typed.split(" ");
				var regExArr = [];
				for(var i=0;i<arr.length;i++) {
					var regexp =arr[i];
					if(regexp){
						regexp = regexp.replace(/\*/g,"");
						var regEx = new RegExp(regexp,'i');
						regExArr.push(regEx);
					}
				}
				if(typed) {
					var f_display = display;
					for(var j=0; j<regExArr.length; j++){
						f_display = f_display.replace(regExArr[j], '<u>'+f_display.match(regExArr[j])+'</u>');
					}
					return f_display;
				}
				else return display;
			}