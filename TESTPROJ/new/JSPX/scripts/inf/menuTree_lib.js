//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $

// Global image variables

/*
var mBarArrowN =  new Image();
var mBarArrowH =  new Image();
var mItemArrowN =  new Image();
var mItemArrowH =  new Image();
mBarArrowN.src="<%=request.getContextPath()%>/images/menubararrowN.gif";
mBarArrowH.src="<%=request.getContextPath()%>/images/menubararrowH.gif";
mItemArrowN.src="<%=request.getContextPath()%>/images/submenuarrowN.gif";
mItemArrowH.src="<%=request.getContextPath()%>/images/submenuarrowH.gif";
*/
// other global variables 



var timeout;
var selArr = new Array();
// Util Functions to Get Actual Parent Postions LEFT & TOP
function DL_GetElementLeft(eElement)
    {
       if (!eElement && this)                    // if argument is invalid
       {                                         // (not specified, is null or is 0)
          eElement = this;                       // and function is a method
       }                                         // identify the element as the method owner

       var DL_bIE = document.all ? true : false; // initialize var to identify IE

       var nLeftPos = eElement.offsetLeft;       // initialize var to store calculations
       var eParElement = eElement.offsetParent;  // identify first offset parent element

       while (eParElement != null)
       {                                         // move up through element hierarchy

          if(DL_bIE)                             // if browser is IE, then...
          {
             if( (eParElement.tagName != "TABLE") && (eParElement.tagName != "BODY") )
             {                                   // if parent is not a table or the body, then...
                nLeftPos += eParElement.clientLeft; // append cell border width to calcs
             }
          }
          else                                   // if browser is Gecko, then...
          {
             if(eParElement.tagName == "TABLE")  // if parent is a table, then...
             {                                   // get its border as a number
                var nParBorder = parseInt(eParElement.border);
                if(isNaN(nParBorder))            // if no valid border attribute, then...
                {                                // check the table's frame attribute
                   var nParFrame = eParElement.getAttribute('frame');
                   if(nParFrame != null)         // if frame has ANY value, then...
                   {
                      nLeftPos += 1;             // append one pixel to counter
                   }
                }
                else if(nParBorder > 0)          // if a border width is specified, then...
                {
                   nLeftPos += nParBorder;       // append the border width to counter
                }
             }
          }
          nLeftPos += eParElement.offsetLeft;    // append left offset of parent
          eParElement = eParElement.offsetParent; // and move up the element hierarchy
       }                                         // until no more offset parents exist
       return nLeftPos;                          // return the number calculated
    }

    function DL_GetElementTop(eElement)
    {
       if (!eElement && this)                    // if argument is invalid
       {                                         // (not specified, is null or is 0)
          eElement = this;                       // and function is a method
       }                                         // identify the element as the method owner

       var DL_bIE = document.all ? true : false; // initialize var to identify IE

       var nTopPos = eElement.offsetTop;         // initialize var to store calculations
       var eParElement = eElement.offsetParent;  // identify first offset parent element

       while (eParElement != null)
       {                                         // move up through element hierarchy
          if(DL_bIE)                             // if browser is IE, then...
          {
             if( (eParElement.tagName != "TABLE") && (eParElement.tagName != "BODY") )
             {                                   // if parent a table cell, then...
                nTopPos += eParElement.clientTop; // append cell border width to calcs
             }
          }
          else                                   // if browser is Gecko, then...
          {
             if(eParElement.tagName == "TABLE")  // if parent is a table, then...
             {                                   // get its border as a number
                var nParBorder = parseInt(eParElement.border);
                if(isNaN(nParBorder))            // if no valid border attribute, then...
                {                                // check the table's frame attribute
                   var nParFrame = eParElement.getAttribute('frame');
                   if(nParFrame != null)         // if frame has ANY value, then...
                   {
                      nTopPos += 1;              // append one pixel to counter
                   }
                }
                else if(nParBorder > 0)          // if a border width is specified, then...
                {
                   nTopPos += nParBorder;        // append the border width to counter
                }
             }
          }

          nTopPos += eParElement.offsetTop;      // append top offset of parent
          eParElement = eParElement.offsetParent; // and move up the element hierarchy
       }                                         // until no more offset parents exist
       return nTopPos;                           // return the number calculated
    }

// New Functions
    
    function showSubMenu(obj)
    {
        //alert(obj.offsetWidth);
        if(!obj)
        {
            alert(xenos.i18n.error.not_object);
            return;
        }
        // get the object id
        oid= obj.id;
        
        closeAll(obj); // close all open menus 
        
        idnum=oid.substr(1);
        showFamily(obj);        // show the menu family
        
        showSelectedHierarchy(); // highlight the hierarchy
        
        Repaint(obj); // repaint the highlighted bars to normal
        
        if( document.getElementById('s'+idnum) )
        {
            add2Array(obj.id);
            //document.getElementById('s'+idnum).style.display="block";
            document.getElementById('s'+idnum).style.visibility="visible";
            
            if(event.srcElement.offsetParent.parentNode.parentid=='x')
            {
                document.getElementById('s'+idnum).style.top=DL_GetElementTop(obj)+25;
                document.getElementById('s'+idnum).style.left=DL_GetElementLeft(obj);
            }
            else
            {
                //alert(screen.width);
                topPos = DL_GetElementTop(obj);
                leftPos = DL_GetElementLeft(obj);
                menuWidth = obj.offsetWidth;
                //alert(menuWidth);
                if(leftPos + menuWidth + menuWidth > screen.width)
                {
                    document.getElementById('s'+idnum).style.top = topPos;
                    document.getElementById('s'+idnum).style.left=leftPos - 100; ;
                    //document.getElementById('s'+idnum).style.left=DL_GetElementLeft(obj)+obj.offsetWidth-2;
                }
                else
                {
                    document.getElementById('s'+idnum).style.top = topPos;
                    document.getElementById('s'+idnum).style.left = leftPos + menuWidth + 2;
                }
            }           
        }       
        //alert(selArr.toString());
    }


    /// put to Array Stack Unique check and put 
    function add2Array(val)
    {
        for(k=0;k<selArr.length;k++)
        {
            if(selArr[k] == val)
            {
                return;
            }
        }
        selArr[selArr.length+1] = val;
    }

    /// Redraw Parent Container ]

    function Repaint(obj)
    {
        oId= obj.id;
        var oParent = obj.offsetParent.parentNode;
        var oParentID = oParent.id;
        var parentMenuId = 'm'+oParentID.substr(1);
        //alert(parentMenuId + "|"+selArr[selArr.length-1]);
        var popped= "";
        
        
        if(selArr[selArr.length-1] != parentMenuId )
        {
            popped = selArr.pop();
        }
        if( popped || parentMenuId == 'm'+_rootid)
        {
            //alert(popped);
            if (document.getElementById(popped) )
            {
                
                document.getElementById(popped).className="menubar";
                parentPopped = document.getElementById(popped).parentNode;
                if(parentPopped.children.length>= 2)
                {
                    parentPopped.children[1].className= "menubar";
                }
            }
        }
        
    }

    function showSelectedHierarchy()
    {
        // Show Selecte Chain 
        //alert(selArr.toString());
        if(selArr.length == 0 )
        {
            return;
        }
        for(k=0;k<selArr.length;k++)
        {
            if(document.getElementById(selArr[k]) )
            {
                document.getElementById(selArr[k]).className='menuhover';

                if(document.getElementById(selArr[k]).parentNode.id != 't0')
                {
                    if(document.getElementById(selArr[k]).parentNode.children.length >=2)
                    {
                        document.getElementById(selArr[k]).parentNode.children[1].className="menuhover";
                    }
                }
            }       
        }
    }
    function closeAll(obj)
    {
        oChildContainer= document.getElementById('menuchildren');
        totelem = oChildContainer.children.length;      
        for(i=0;i<totelem;i++)
        {
                //oChildContainer.children[i].style.display="none";
                oChildContainer.children[i].style.visibility ="hidden";
        }
        for(k=0;k<selArr.length;k++)
        {
            if(document.getElementById(selArr[k]) )
            {
                document.getElementById(selArr[k]).className='menubar';
                //document.getElementById(selArr[k]).childNode.className='menubar';
            }
        }


        //hilight handling, revert all highlighted bars to normal and empty stack
        if(obj)
        {
            oId= obj.id;
            var oParent = obj.offsetParent.parentNode;
            var oParentID = oParent.id;
            var parentMenuId = 'm'+oParentID.substr(1);
            if(parentMenuId == 'm'+_rootid)
            {
                for(k=0;k<selArr.length;k++)
                {
                    if(document.getElementById(selArr[k]) )
                    {
                        document.getElementById(selArr[k]).className='menubar';
                        if(document.getElementById(selArr[k]).parentNode.children.length >=2)
                        {
                            //document.getElementById(selArr[k]).parentNode.children[1].className="menubar";
                        }
                    }       
                }
                selArr = new Array();
            }
        }
        
        
        //document.getElementById(_toHide).style.visibility = "visible"; // show form 
        menuFocusHookComboShow();
    }
function showFamily(obj)
{
    var id= obj.id;
    var oParent = obj.offsetParent.parentNode;
    
    // show container of this menuItem
    var parentId= oParent.getAttribute('parentid');
    //oParent.style.display="block";
    oParent.style.visibility="visible";
    
    // show all parent menu container untill parentid== 'x'
    while( parentId!='undefined'  && parentId !='x' )
    {
        oParent = document.getElementById('s'+parentId);
        parentId= oParent.getAttribute('parentid');     
        //oParent.style.display="block";
        oParent.style.visibility="visible";
    }
}


// creation of  menu 

// Global Settings 
// Configuration Params
    var _mbarStyleNormal    = "menubar";
    var _mbarStyleHover     = "menuhover";
    var _mbarStyleSelect    = "menuselect";
    var _border             = true;
    var _borderTopStyle     = "bTop";
    var _borderLeftStyle    = "bLeft";
    var _borderRightStyle   = "bRight";
    var _borderBottomStyle  = "bBottom";
    var _wrapOption         = "nowrap";
    var _linkStyle          = "menuLink";
    var _rootid             =0;
    var _timeout            = 50;
    var _target             ="_self";


    function menuBar(id,parentid,caption)
    {
        // Associate Properties to menuBar
        this.mbarStyleNormal    = null;
        this.mbarStyleHover     = null;
        this.mbarStyleSelect    = null;
        this.border             = null;
        this.borderTopStyle     = null;
        this.borderLeftStyle    = null;
        this.borderRightStyle   = null;
        this.borderBottomStyle  = null;
        this.wrapOption         = null;
        this.linkStyle          = null;
        this.maxItem            = 10;
        this.totItem            = 0;
        this.rootID             = id;
        _rootid = this.rootID; // set menuBarID to global Rootid ie. _rootid
        //internal Properties
            this.id = id;
            this.parentid  = parentid;
            this.caption = caption;

            // Associate Methods to menuBar
            this.init = menuBarInit;
            this.addMenu = addMenu;
    }
    
    // menuBar Methods 
    // Init Method 
        
        function menuBarInit()
        {
            
            this.mbarStyleNormal    = _mbarStyleNormal;
            this.mbarStyleHover     = _mbarStyleHover;
            this.mbarStyleSelect    = _mbarStyleSelect;
            this.border             = _border;
            this.borderTopStyle     = _borderTopStyle;
            this.borderLeftStyle    = _borderLeftStyle;
            this.borderRightStyle   = _borderRightStyle;
            this.borderBottomStyle  = _borderBottomStyle;
            this.wrapOption         = _wrapOption;
            this.linkStyle          = _linkStyle;
                    
            menuRoot = document.createElement('DIV');
            menuRoot.setAttribute('id','s'+this.id);
            menuRoot.setAttribute('parentid','x');
            menuRoot.setAttribute('className','mainmenu');
            
            //menuRoot.attachEvent ('onmouseover', menuFocusHook);

            //menuRoot.attachEvent ('onmouseover', menuFocusHookComboHide);
            
            oTbl= document.createElement('TABLE');
            oTr = oTbl.insertRow();
            oTr.setAttribute("id","t0");            
            menuRoot.appendChild(oTbl);
            
            document.body.appendChild(menuRoot);
            oTbl.border=0;
            oTbl.cellPadding=0;
            oTbl.cellSpacing=1;
            oTbl.bgColor='#FFFFFF';
            
            //  Create a div with ID menu CHILDREN Container

            menuChildren = document.createElement('DIV');
            menuChildren.id='menuchildren';
            //menuChildren.attachEvent ('onfocusin', menuFocusHook);
            //menuChildren.attachEvent ('onfocusout', menuFocusHook1);
            document.body.appendChild(menuChildren);
            return;
        }


        /***********************************************
        * @name         = addMenu
        * @param        = int id
        * @param        = int parentid
        * @caption      = String caption
        * @url          = String url
        * @target       = String target
        * @return       = true if succeeds else false
        **************************************************/
        // addMenu(menuPk, parentMenuPk, menuName, menuDescription, menuURL, targetFrame, isDisable)
        function addMenu(id,parentid,caption,tooltips,url,target,disable)  
        {
            if(this.totItem <this.maxItem)
            {
                oTd = document.createElement('TD');
                oTd.setAttribute('id','m'+id);
                oTd.setAttribute('parentid','m'+parentid);
                oTd.setAttribute('className','menubar');
                oTd.attachEvent ('onmouseover', Hilite);
                oTd.attachEvent ('onmouseout', Restore);
                oTd.attachEvent ('onclick', popMenu);
                oTd.noWrap = true;
                var nhtml = "&nbsp;&nbsp;<img src=" + mBarArrowH.src + ">";
                oTd.innerText= caption;
                oTd.innerHTML = oTd.innerHTML + nhtml;
                document.getElementById('t0').appendChild(oTd);
                this.totItem ++;
            }
            return true;
        }
        
        /***********************************************
        * @name         = Hilite
        * @param        = null
        * @return       = void
        **************************************************/
        // NEW HILITE FUNCTION
        function Hilite()
        {
            if(event.srcElement.tagName == "TD")
            {
                event.srcElement.className='menuhover';
            }
            if(event.srcElement.tagName == "A" || event.srcElement.tagName == "SPAN")
            {
                event.srcElement.parentNode.className='menuhover';
            }
            // Clear Timeout For erase menu
            if(timeout)
            {
                clearTimeout(timeout);
            }
        }

        /***********************************************
        * @name         = Restore
        * @param        = null
        * @return       = void
        **************************************************/
        // NEW RESOTORE FUNCTION
        function Restore()
        {
            if(event.srcElement.tagName == "TD")
            {
                event.srcElement.className='menubar';
            }
            if(event.srcElement.tagName == "A" || event.srcElement.tagName == "SPAN")
            {
                event.srcElement.parentNode.className='menubar';
            }
            timeout = setTimeout("closeAll()",_timeout);
        }

        /***********************************************
        * @name         = menuFocusHook
        * @param        = null
        * @return       = void
        **************************************************/
        function menuFocusHook()
        {
            document.getElementById(_toHide).style.visibility= "hidden";
        }

        /***********************************************
        * @name         = menuFocusHook
        * @param        = null
        * @return       = void
        **************************************************/
        function menuFocusHook1()
        {
            closeAll();
            document.getElementById(_toHide).style.visibility = "visible";
        }

        function menuFocusHookComboHide()
        {
            if(document.forms[0])
            {
                for (fc=0;fc<document.forms[0].elements.length ;fc++ )
                {
                    if(document.forms[0].elements[fc].type=="select-one")
                    {
                        document.forms[0].elements[fc].style.visibility ="hidden";
                    }
                    if(document.forms[0].elements[fc].type=="select-multiple")
                    {
                        document.forms[0].elements[fc].style.visibility ="hidden";
                    }
                }
            }
        }

        function menuFocusHookComboShow()
        {       
            if(document.forms[0])
            {
                for (fc=0;fc<document.forms[0].elements.length ;fc++ )
                {
                    if(document.forms[0].elements[fc].type=="select-one")
                    {
                        document.forms[0].elements[fc].style.visibility ="visible";
                    }
                    if(document.forms[0].elements[fc].type=="select-multiple")
                    {
                        document.forms[0].elements[fc].style.visibility ="visible";
                    }
                    //alert(document.forms[0].elements[fc].type );
                }
            }
        }

        
        // function to show HTML
        /***********************************************
        * @name         = menuCode
        * @param        = null
        * @return       = void
        **************************************************/
        function menuCode()
        {
            document.getElementById('0').style.display="block";         
            return document.getElementById('0').innerHTML;
        }

        // Submenu Class

        /***********************************************
        * @name         = subMenu
        * @param        = int id
        * @param        = int parentid
        * @caption      = String caption
        * @url          = String url
        * @target       = String target
        * @return       = true if succeeds else false
        **************************************************/

        function subMenu(id,parentid,caption,url,target)
        {
            this.id= id;
            this.parentid= parentid;
            this.caption= caption;
            this.count=0;
            this.maxcount=10;
            this.parentTypeContains = false;
            var subMenu = document.createElement('DIV');
            subMenu.setAttribute('id','s'+this.id);
            subMenu.setAttribute('parentid',this.parentid);
            subMenu.setAttribute('className','shadow');
            //subMenu.attachEvent ('onmouseover', menuFocusHook);
            
            //subMenu.style.height = this.maxcount*25;  
            subMenu.style.width = 150;
            //subMenu.style.display = "none";
            subMenu.style.visibility  = "hidden";
            
            //subMenu.style.overflowY = "auto";
            subMenu.style.position="absolute";



            var oTbl= document.createElement('TABLE');
            var tmpId = 'tbl'+this.id;
            oTbl.id=tmpId;
            oTbl.border=0;
            oTbl.cellPadding=0;
            oTbl.cellSpacing=0;
            oTbl.width="100%";
            //oTbl.className='shadow';
            oTbl.style.tableLayout ="auto";
            subMenu.appendChild(oTbl);

            document.getElementById('menuchildren').appendChild(subMenu);
            
            // Add method to Submenu
            this.addSubMenuItem = addSubMenuItem;
        }

        /***********************************************
        * @name         = addSubMenuItem
        * @param        = int id
        * @caption      = String caption
        * @url          = String url
        * @target       = String target
        * @disable      = String disable
        * @return       = true if succeeds else false
        **************************************************/
        // addSubMenuItem(menuPk, menuName, menuDescription, menuURL, targetFrame, hasChildren, isDisable)
        function addSubMenuItem(id,caption,tooltips,url,target,haschildren,disable)  
        {
            
            var oTbl = document.getElementById('tbl'+this.id);
            var sMenuContainer = document.getElementById('s'+this.id);
            /*
            if (this.count > 10)
            {
                sMenuContainer.style.borderBottomColor ="black";
                sMenuContainer.style.borderBottomWidth =1;
                sMenuContainer.style.borderBottomStyle ="solid";
                sMenuContainer.style.scrollbarArrowColor ="#004080";
                sMenuContainer.style.scrollbarBaseColor ="#F0F8FF";
                sMenuContainer.style.height = this.maxcount*25;
            }
            */
            

            var oTr= oTbl.insertRow();
            var oTd = document.createElement('TD');
            oTd.setAttribute('id','m'+id);
            oTd.noWrap = true;
            oTd.width="100%";
            oTd.valign="middle";
            
            if (!disable || disable == null || disable == undefined)
            {
                oTd.setAttribute('className','menubar');
                oTd.attachEvent ('onmouseover', Hilite);
                oTd.attachEvent ('onmouseout', Restore);
                oTd.attachEvent ('onclick', popMenu);
            }
            else
            {
                oTd.setAttribute('className','menudisable');        
            }
        
            
            var oLnk = document.createElement('A');

            // Build Link or Only Caption 
            var linkStr = "";
            if(url=='' || url == null || url.length==1 || url=='null')
            {
                if(haschildren)
                {
                    oTd.innerHTML = "<span id='menucaption'>" +caption + "</span><img src='"+mItemArrowH.src +"' border=0>" ;
                }
                else
                {
                    oTd.innerText = caption;
                }
                
            }
            else
            {
                linkStr = "<a href='"+enterprisePath + url+ "' id='lnk' target="+_target+">"+caption+"</a>";
                oLnk.target = '_blank';
                oLnk.innerText = caption;
                oTd.innerHTML = linkStr;
            }
            oTr.appendChild(oTd);
            this.count++;
            sMenuContainer.style.height = this.count*25;
        }
    /***********************************************
        * @name         = popMenu
        * @return       = void 
        **************************************************/
    function popMenu()
    {
        event.cancelBubble = true;
        if(event.srcElement.tagName=="TD")
        {
            showSubMenu(event.srcElement);
            menuFocusHookComboHide();
        }
        if(event.srcElement.tagName=="SPAN")
        {
            showSubMenu(event.srcElement.parentNode);
            menuFocusHookComboHide();
        }
        if(event.srcElement.tagName=="A")
        {
            return true;
        }
    }


   /************************************************
    * This API Attched event handler to the requried
    * DOM element when menu is access from chache
    * @param    oElm    = The DOM element object
    **************************************************/


    function doEvenAttach(oElm) {

        if (!oElm.hasChildNodes()) {
                return;
        } else {
                if(oElm.tagName=="TD"){
                    oElm.attachEvent ('onmouseover', Hilite);
                    oElm.attachEvent ('onmouseout', Restore);
                    oElm.attachEvent ('onclick', popMenu);
                }

                var kids = oElm.childNodes;

                for (var i = 0; i < kids.length; i++) {
                    doEvenAttach(kids[i]);
                }

        }

    }