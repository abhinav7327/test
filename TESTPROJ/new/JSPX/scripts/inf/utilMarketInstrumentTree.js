//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




  var rootImg = new Image();
  var leafImg = new Image();
  rootImg.src = "../images/root.gif";
  leafImg.src = "../images/leaf.gif";
  var _target = "";
  var _root = "";

  var stgSelectedOldValues = "";

  var imgPlus= new Image();
    imgPlus.src="../images/plus.gif";
    var imgMinus= new Image();
    imgMinus.src="../images/minus.gif";
//  var imgTPlus= new Image();
//  imgTPlus.src="../images/tplus.gif";
//  var imgTMinus= new Image();
//  imgTMinus.src="../images/tminus.gif";
    var imgLeaf =  new Image();
    imgLeaf.src="../images/leaf.gif";
//  var imgNoexpand= new Image();
//  imgNoexpand.src="../images/noexpand.gif";
    
/**
  * API exposed to the outer world to 
  * Generate the instrument tree.
  */
function loadInstrument(evt) {
   
    if (window.parent.document.getElementById('instChache')){
        loadStoreInstrument(window.parent.document.getElementById('instChache'), evt);
    }else{
        try{
            loadStoreInstrument(window.parent.document.getElementById('instChache'), evt);
        }catch(error){
            alert("Opps! Problem to load Instrument Tree : " + error.description);
        }
    }
}

 /**
   * This API will load the Instrument Tree
   * for single selection first time 
   * and then store it into the chache.
   * On latter onwords it will acces the chache 
   * to render the tree.
   * Chache life time is per user until the session of the user expire
   * or the user logout or the container of the chache is Refresh
   */
function loadStoreInstrument(Obj, evt ) {

    var instContainer = document.getElementById('inst');
        if(instContainer) {
            if (Obj.innerHTML == "") {
                loadInitInstrumentTree(evt);
                Obj.innerHTML=document.getElementById('inst').innerHTML;
            } else {
                  document.getElementById('inst').innerHTML = Obj.innerHTML;
            }
        }
}
    
  /**
    * This API will load the Instrument Tree
    * For single selection
    */
    function loadInitInstrumentTree(evt)
    {
        var oContainer = document.getElementById('inst');
        if(oContainer)
        {
            for(i=0;i<instrument.length;i++){
                if(instrument[i][1]== "0" || instrument[i][1]=='null')
                {
                    var oDiv = document.createElement("DIV");   
                    oDiv.id= instrument[i][0];
                    oDiv.className="root";
                    oContainer.appendChild(oDiv);                   
                }
                else
                {
                    if(document.getElementById(instrument[i][1]))
                    {
                        var oDiv = document.createElement("DIV");   
                        oDiv.id= instrument[i][0];
                        oDiv.noWrap="true";
                        if(instrument[i][1]== 'ALL')
                        {
                            oDiv.className="childNodeLevel1";
                        }
                        else
                        {
                            oDiv.className="childNode";
                        }
                        if(evt)
                        {
                            if(!isParent(instrument[i][0],instrument)){
                                oDiv.innerHTML="<a href=\"javascript:void(0)\" title=\""+instrument[i][2]+"\""+"class=\"lnk\" onclick=\"putValue('"+ instrument[i][0] +"','"+evt+"')\"><img src=\""+imgLeaf.src+"\"  border=0>&nbsp;"+ instrument[i][0]+"&nbsp;:&nbsp;"+instrument[i][2]+"</a>";
                            }else{  
                                oDiv.innerHTML="<a href=\"javascript:void(0)\" onclick=\"showHideChildren('"+instrument[i][0]+"')\"><img src=\""+imgPlus.src+"\"  border=0 id=sign"+instrument[i][0]+"></a>&nbsp;<a href=\"javascript:void(0)\" title=\""+instrument[i][2]+"\""+"class=\"lnk\" onclick=\"putValue('"+ instrument[i][0] +"','"+evt+"')\">"+ instrument[i][0]+"&nbsp;:&nbsp;"+instrument[i][2]+"</a>";
                            }                           
                        }
                        else
                        {
                            if(!isParent(instrument[i][0],instrument)){
                                oDiv.innerHTML="<a href=\"javascript:void(0)\" title=\""+instrument[i][2]+"\""+"class=\"lnk\" onclick=\"putValue('"+ instrument[i][0] +"')\"><img src=\""+imgLeaf.src+"\"  border=0>&nbsp;"+ instrument[i][0]+"&nbsp;:&nbsp;"+instrument[i][2]+"</a>";
                            }else{      
                                oDiv.innerHTML="<a href=\"javascript:void(0)\" onclick=\"showHideChildren('"+instrument[i][0]+"')\"><img src=\""+imgPlus.src+"\"  border=0 id=sign"+instrument[i][0]+"></a>&nbsp;<a href=\"javascript:void(0)\" title=\""+instrument[i][2]+"\""+"class=\"lnk\" onclick=\"putValue('"+ instrument[i][0] +"')\">"+ instrument[i][0]+"&nbsp;:&nbsp;"+instrument[i][2]+"</a>";                               
                            }
                        }
                        document.getElementById(instrument[i][1]).appendChild(oDiv);
                    }
                }
            }
        }

    }

/*
 * This API is called by the Instrument Tree, Market Tree, Strategy Tree for single selection and 
 * Strategy Tree for multiple selection to reneder the child component of the parent element.
 *
 */
function isParent(parentID,arr)
    {
    var totchild=0;
    if(parentID=='ALL'){
        return true;
    }
    for(var j=0;j<arr.length;j++){
        if(arr[j][1]==parentID){
            totchild++;
        }
        if(totchild>1){
            break;
        }
    }
    return (totchild>0);
  }

/**
 * API exposed to the outer world to 
 * Generate the market tree.
 */
function loadMarket () {
    if (window.parent.document.getElementById('mktChache')){
        loadStoreMarket(window.parent.document.getElementById('mktChache'));
    }else{
        try{
            loadStoreMarket(window.parent.document.getElementById('mktChache'));
        }catch(error){
            alert("Opps! Problem to load Market Tree : " + error.description);
        }
    }
}

 /**
   * This API will load the Market Tree
   * for single selection first time 
   * and then store it into the chache.
   * On latter onwords it will acces the chache 
   * to render the tree.
   * Chache life time is per user until the session of the user expire
   * or the user logout or the container of the chache is Refresh
   */
function loadStoreMarket( Obj ) {

var mktContainer = document.getElementById('mkt');
    
	if(mktContainer) {
        if (Obj.innerHTML == "") {
            loadInitMarketTree();
            Obj.innerHTML=document.getElementById('mkt').innerHTML;
        } else {
				loadInitMarketTree();
                document.getElementById('mkt').innerHTML = Obj.innerHTML;
        }
    }
}

 /**
   * This API will load the Market Tree
   * For single selection
   */
function loadInitMarketTree() { 
    var oContainer = document.getElementById('mkt');
    if(oContainer)
    {
        for (i=0;i<market.length;i++)
        {
            if(market[i][1]== "0" || market[i][1]=='null')
            {
                var oDiv = document.createElement("DIV");   
                oDiv.id= market[i][0];
                oDiv.className="root";
                oContainer.appendChild(oDiv);
            }
            else
            {
                if(document.getElementById(market[i][1]))
                {
                    var oDiv = document.createElement("DIV");   
                    oDiv.id= market[i][0];
                    
                    if(market[i][1]=="1") 
                    {
                        oDiv.className="childNodeLevel1";
                    }
                    else
                    {
                        oDiv.className="childNode";
                    }
                    if(!isParent(market[i][0],market)){
                        oDiv.innerHTML="<a href=\"javascript:void(0)\" class=\"lnk\" title=\""+market[i][3]+"\""+"onclick=\"putValue('"+ market[i][2] +"')\"> <img src=\""+imgLeaf.src+"\"  border=0>&nbsp;"+ market[i][2]+"</a>";
                    }else{
                        oDiv.innerHTML="<a href=\"javascript:void(0)\" onclick=\"showHideChildren('"+market[i][0]+"')\"><img src=\""+imgPlus.src+"\"  border=0 id=sign"+market[i][0]+"></a>&nbsp;<a href=\"javascript:void(0)\" class=\"lnk\" title=\""+market[i][3]+"\""+"onclick=\"putValue('"+ market[i][2] +"')\">"+ market[i][2]+"</a>";
                    }
					//alert('***:'+oDiv.innerHTML);
                    document.getElementById(market[i][1]).appendChild(oDiv);
                }
            }
        }// end for
    }// if ocontainer
  }

    /**
      * Loading the strategy tree for single selection 
      * It generates the html at the runtime which is render 
      * into the browser.
      *
      */

    function loadStrategy()
    {
        var oContainer = document.getElementById('stg');
        
        if(oContainer)
        {   
            var root_pk = null;
            for (i=0;i<strategy.length;i++)
            {
                
                if(strategy[i][1]== "0" || strategy[i][1]=='null')
                {
                    var oDiv = document.createElement("DIV");   
                    oDiv.id = strategy[i][0];
                    root_pk = strategy[i][0];
                    oDiv.className ="root";
                    oContainer.appendChild(oDiv);   
                }
                else
                {
                    if(document.getElementById(strategy[i][1]))
                    {   
                        var oDiv = document.createElement("DIV");   
                        oDiv.id= strategy[i][0];
                        if(strategy[i][1] == root_pk)
                        {   
                            oDiv.className="childNodeLevel1";
                        }
                        else
                        {
                            oDiv.className="childNode";
                        }
                        if(strategy[i][4] == 'NORMAL') {
                            if(!isParent(strategy[i][0],strategy)){
                                // case of leaf node
                                oDiv.innerHTML="<a href=\"javascript:void(0)\" class=\"lnk\" title=\""+strategy[i][3]+"\""+"onclick=\"putValue('"+ strategy[i][2] +"')\"> <img src=\""+imgLeaf.src+"\"  border=0>&nbsp;"+ strategy[i][2]+"</a>";
                            }else{
                                // case of non leaf node
                                oDiv.innerHTML="<a href=\"#\" onclick=\"showHideChildren('"+strategy[i][0]+"')\"><img src=\""+imgPlus.src+"\"  border=0 id=sign"+strategy[i][0]+"></a>&nbsp;<a href=\"javascript:void(0)\" class=\"lnk\" title=\""+strategy[i][3]+"\""+"onclick=\"putValue('"+ strategy[i][2] +"')\">"+ strategy[i][2]+"</a>";
                            }
                        } else {
                            if(!isParent(strategy[i][0],strategy)){
                                // case of leaf node
                                oDiv.innerHTML="<a href=\"javascript:void(0)\" class=\"cancelink\" title=\""+strategy[i][3]+"\""+"onMouseDown=\"alert('Selected Strategy Code is Cancel')\""+"onclick=\"putValue('"+ strategy[i][2] +"')\"> <img src=\""+imgLeaf.src+"\"  border=0>&nbsp;"+ strategy[i][2]+"</a>";
                            }else{
                                // case of non leaf node
                                oDiv.innerHTML="<a href=\"#\" onclick=\"showHideChildren('"+strategy[i][0]+"')\"><img src=\""+imgPlus.src+"\"  border=0 id=sign"+strategy[i][0]+"></a>&nbsp;<a href=\"javascript:void(0)\" class=\"cancelink\" title=\""+strategy[i][3]+"\""+"onMouseDown=\"alert('Selected Strategy Code is Cancel')\""+"onclick=\"putValue('"+ strategy[i][2] +"')\">"+ strategy[i][2]+"</a>";
                            }
                        }
                        document.getElementById(strategy[i][1]).appendChild(oDiv);
                    }
                }
            }// end for
        }// if ocontainer
    }

  /**
    * Loading the strategy tree for multiple selection 
    * It generates the html at the runtime which is render 
    * into the browser.
    */

  function loadStrategyMultiCheck()
    {
        var oContainer = document.getElementById('stg');
        
        if(oContainer)
        {   
            var root_pk = null;
            for (i=0;i<strategy.length;i++)
            {
                
                if(strategy[i][1]== "0" || strategy[i][1]=='null')
                {
                    var oDiv = document.createElement("DIV");   
                    oDiv.id = strategy[i][0];
                    root_pk = strategy[i][0];
                    oDiv.className ="root";
                    oContainer.appendChild(oDiv);   
                }
                else
                {
                    if(document.getElementById(strategy[i][1]))
                    {   
                        var oDiv = document.createElement("DIV");   
                        oDiv.id= strategy[i][0];
                        if(strategy[i][1] == root_pk)
                        {   
                            oDiv.className="childNodeLevel1";
                        }
                        else
                        {
                            oDiv.className="childNode";
                        }
                        if(!isParent(strategy[i][0],strategy)){
                            //case of leaf node
                            oDiv.innerHTML="<a href=\"javascript:void(0)\" class=\"lnk\" title=\""+strategy[i][3]+"\""+"onclick=\"putMultiValue('"+ strategy[i][2] +"')\"> <img src=\""+imgLeaf.src+"\"  border=0>&nbsp;<input type=\"checkbox\" value=\"" + strategy[i][2] + "\" id=\"" + strategy[i][2] + "\">" + strategy[i][2]+"</a>";
                        }else{
                            //case of non leaf node
                            oDiv.innerHTML="<a href=\"#\" onclick=\"showHideChildren('"+strategy[i][0]+"')\"><img src=\""+imgPlus.src+"\"  border=0 id=sign"+strategy[i][0]+"></a>&nbsp;<a href=\"javascript:void(0)\" class=\"lnk\" title=\""+strategy[i][3]+"\""+"onclick=\"putMultiValue('"+ strategy[i][2] +"')\"><input type=\"checkbox\" value=\"" + strategy[i][2] + "\" id=\"" + strategy[i][2] + "\">" + strategy[i][2]+"</a>";
                        }
                        document.getElementById(strategy[i][1]).appendChild(oDiv);
                    }
                }
            }// end for
        }// if ocontainer
    }

    /**
      * This API will show or hide the tree component when + or - image is clicked.
      * Used by Instrumnent, Market, Startegy single and multipi
      */
  function showHideChildren(id)
  {   
    var styleState="plus"; 
    for (var k = 2 ; k<document.getElementById(id).children.length ;k++ )
    {       
        if (document.getElementById(id).children[k].style.display=="none" || document.getElementById(id).children[k].style.display.length==0)
        {
            document.getElementById(id).children[k].style.display="block";          
            styleState="plus";
        }
        else
        {
            document.getElementById(id).children[k].style.display="none";
            styleState="minus";
        }
    }
    
    if(styleState=="plus"){
        document.getElementById('sign'+id).src = imgMinus.src;
    }else{
        document.getElementById('sign'+id).src = imgPlus.src;
    }
  }

  /**
    * This API wil show the tree popup.
    * Used by Instrumnent, Market, Startegy single and multipile.
    */
  function showPop(rootID,fldID)
  {     
        if (document.getElementById(fldID).disabled)
        {
            return;
        }
        _target = fldID;

        if(_root){
            if (_root != rootID)
            {
                //close the other tree component since we are going to open 
                //another tree component
                document.getElementById(_root).style.display="none";
            }
        }
        
        _root = rootID;
        obj=document.getElementById(rootID);
        //document.getElementById(rootID).style.posLeft = window.event.x - 145;
        //document.getElementById(rootID).style.posTop = window.event.y + 10 ;
        var scrollTop = document.body.scrollTop;
        var scrollLeft = document.body.scrollLeft;
        
        document.getElementById(rootID).style.posLeft = (window.event.x - scrollLeft) - 145;
        document.getElementById(rootID).style.posTop = (window.event.y+ scrollTop) + 10 ;
        
        menuFocusHookComboHide();
        document.getElementById(rootID).style.display="block";

        if (_root == "stg")
        {
            // This is exclusively for strategy multipile selection
            var textValue = document.getElementById(_target).value;
            var selectedValues = textValue.split(",");
            
            //remove the olds selected check boxs
             for (var noOfSelection=0; noOfSelection<stgSelectedOldValues.length;noOfSelection++ )
            {
                if ((document.getElementById(stgSelectedOldValues[noOfSelection]) != null)
                    && (document.getElementById(stgSelectedOldValues[noOfSelection]) != ""))
                {
                    document.getElementById(stgSelectedOldValues[noOfSelection]).checked = false;
                }
            }

            
            // reselect the check box depending upon the existing value
            
            for (var noOfSelection=0; noOfSelection<selectedValues.length;noOfSelection++ )
            {
                if ((document.getElementById(selectedValues[noOfSelection]) != null)
                    && (document.getElementById(selectedValues[noOfSelection]) != ""))
                {
                    document.getElementById(selectedValues[noOfSelection]).checked = true;
                }
            }

            stgSelectedOldValues = textValue.split(",");
        }
        

  }

  // Putting single selected value from tree
  // Used by Instrumnent, Market, Startegy single selection

  function putValue(value,evt)
  {
    document.getElementById(_target).value = value;
    if(evt){
        document.getElementById(_target).select();
        document.getElementById(_target).focus();       
    }
    document.getElementById(_root).style.display= "none";
    if(evt){
        document.getElementById(_target).fireEvent(evt);
    }
  }

  /**
    * Putting multiple selected value from tree
    * Used by Startegy multiple selection.
    * @param strategyCode the strategy code
    */

  function putMultiValue(strategyCode)
  {

    var selValue = document.getElementById(strategyCode).checked;
    var textValue = document.getElementById(_target).value;
    if (!selValue)
    {
       // removeing the text
        if (textValue != '' || textValue != null) {
            unSelValue = ',' + strategyCode
            if (textValue.indexOf(unSelValue) != -1)
            {
                //remove the last when more than one
                textValue = textValue.replace(unSelValue, "");
            } else {
                unSelValue = strategyCode + ',';
                if (textValue.indexOf(unSelValue) != -1)
                {
                    //remove the non last when more than one
                    textValue = textValue.replace(unSelValue, "");
                } else {
                    //remove the sigle when only one is there
                    textValue = textValue.replace(strategyCode, "");
                }
            }
            document.getElementById(_target).value = textValue;
        }
    } else {

        if (textValue == '' || textValue == null)
        {
            //single node selection
            document.getElementById(_target).value = strategyCode;
        } else {
            //multiple node selection
            // This is exclusively for strategy multipile selection
            var textValue = document.getElementById(_target).value;
            var selectedValues = textValue.split(",");
            
            //donot allow adding multiple same value
             for (var noOfSelection=0; noOfSelection<selectedValues.length;noOfSelection++ )
            {
                if ((document.getElementById(selectedValues[noOfSelection]) != null)
                    && (document.getElementById(selectedValues[noOfSelection]) != ""))
                {
                    if (document.getElementById(selectedValues[noOfSelection]).value == strategyCode)
                    {
                        return;
                    }
                }
            }
            
            document.getElementById(_target).value = document.getElementById(_target).value + "," + strategyCode;
        }       
    }
    
  }
  
  // Clearing Field
  // Used by Instrumnent, Market and Strategy single selection

  function clearField(fldID)
  {
    document.getElementById(fldID).value="";
  }



//clear all feild value of strategy that were selecled from tree.
// Used by Strategy multiple selection

function clearStrategyField(fldID){

    document.getElementById(fldID).value="";

    for (i=0;i<strategy.length;i++)
    {
        if(strategy[i][1]== "0" || strategy[i][1]=='null')
        {
        
        }
        else
        {
            if(document.getElementById(strategy[i][1]))
            { 
                if(!isParent(strategy[i][0],strategy)){
                  document.getElementById(strategy[i][2]).checked=false;
                }else{
                  document.getElementById(strategy[i][2]).checked=false;        
                    hideChildren(strategy[i][0]);
                }
            }
        }

    }// end for

}
 
//hide child component when collapsing tree 
// call from clearStrategyField used by strategy multiple selection

function hideChildren(id)
  {      
      var styleState="plus"; 
       for (var k = 2 ; k<document.getElementById(id).children.length ;k++ )
       {                       
             if (document.getElementById(id).children[k].style.display !="none" || document.getElementById(id).children[k].style.display.length !=0)
             {
                document.getElementById(id).children[k].style.display="none";
                styleState="minus";
             }
       }

       if(styleState=="minus"){
          document.getElementById('sign'+id).src = imgPlus.src;
       }
  }



/**
  * The fnDetermine function determines where the mouse was clicked.
  * In case of Instrument, Market, Startegy (Single and Multiple)
  * The component receives the event and does not disappear until event is not 
  * generated from any other component.
  */

function fnDetermine(objID)
{

 _treeObjId = objID;
_containerName ='gCalendar';
_montyhListContainerName ='gMonthList';

    // Calendar Object
    objCalMain = document.getElementById(_containerName);
    //Monthlist Object
    objCalMonthList = document.getElementById(_montyhListContainerName);
    
    oWorkItem=event.srcElement;
    //alert(oWorkItem.parentElement.tagName);
    oWorkItemID=oWorkItem.id;
    var obj=document.getElementById(objID);
  
    if(!obj){
        return;
    }
    var parent=oWorkItem.parentElement.id;
    
    if((oWorkItem.tagName=="IMG")||(oWorkItem.parentElement.tagName=="BODY") 
        || (oWorkItem.tagName=="INPUT") || (oWorkItem.id=="calcmlist") )
    {
        
        if(obj.style.display=="block" )
        {
            document.body.setCapture();
    
            if (oWorkItem.tagName=="DIV" || oWorkItem.parentElement.tagName=="DIV")
            {

            }
            else
            {
                document.body.releaseCapture();
            }
            return false;
        }
        else
        {
            // close calendar if open unconditionally
        objCalMain.style.display=="none";
        objCalMonthList.style.display=="none";
        }
    }
    else
    {
        document.body.releaseCapture();
        //menuFocusHookComboShow();
        obj.style.display="none";       
        closeCalendar();
    }
}
