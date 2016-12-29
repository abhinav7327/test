//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




function keyWhat(e){
    if (navigator.appName == 'Microsoft Internet Explorer') {

            //For shift, ctrl and alt keys                
            if (event.ctrlLeft || event.ctrlKey) {

                if(event.keyCode == 78){
                    alert("Opening New Window is not permitted.");
                    return false;
                }
                if(event.keyCode == 82){
		    return false;
                } 
                if(event.keyCode == 84){
		    return false;
                } 
		if(event.keyCode == 116){
		    event.keyCode = 505;
		}
		if(event.keyCode == 505){
		    return false;
		}               

            } else if (event.shiftLeft || event.shiftKey) {

                if(event.keyCode == 116){
                    event.keyCode = 505;
                }
                if(event.keyCode == 505){
                    return false;
                }

            } else if(event.altLeft || event.altKey){                
                    return false;

            } else if(event.keyCode == 16 ||event.keyCode == 17  ||event.keyCode == 18 || event.keyCode == 8){ 
                if(event.srcElement.type == "text" 
                    || event.srcElement.type =="textarea" 
                    || event.srcElement.type =="password"){
                    return true;
                } else  {
                        alert("You Can't use ctrl,shift or alt keys on page");
                        return false;
                }
            } else if(event.keyCode == 116){
                event.keyCode = 505;
            }
            
            if(event.keyCode == 505){
                return false;
            }
        }
}//end of function

document.onkeydown=keyWhat;
document.oncontextmenu = function(){return false};
window.focus();


function printWindow(){
   bV = parseInt(navigator.appVersion)
   if (bV >= 4) window.print()
}