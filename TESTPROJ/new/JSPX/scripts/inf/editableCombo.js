//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




function showEditableComboList(containerID)
{
	if(document.getElementById(containerID))
	{
		document.getElementById(containerID).style.display="block";
	}
}



  function showEditableComboList(fldID)
  {		if (document.getElementById(fldID).disabled)
		{
			return;
		}
		var _target = fldID;
		var _container = fldID+'container';
		obj=document.getElementById(_container);
		document.getElementById(_container).style.posLeft = window.event.x - 145;
		document.getElementById(_container).style.posTop = window.event.y + 10 ;
		var scrollTop = document.body.scrollTop;
		var scrollLeft = document.body.scrollLeft;
		
		document.getElementById(_container).style.posLeft = (window.event.x - scrollLeft) - 155;
		document.getElementById(_container).style.posTop = (window.event.y+ scrollTop) + 10 ;
		document.getElementById(_container).style.width=obj.width;
		menuFocusHookComboHide();
		document.getElementById(_container).style.display="block";

  }
  function putValue2Combo(_targetfld,value)
  {
	document.getElementById(_targetfld).value = value;
	document.getElementById(_targetfld).select();
	document.getElementById(_targetfld).focus();	
	document.getElementById(_targetfld+'container').style.display= "none";
	
  }

