



<%@ include file="/WEB-INF/tiles/pageHeader.jsp"%>
<%@ include file="/WEB-INF/tiles/stripes.jsp"%>

<html>
<head>
<title>Application</title>
<xenos:css href="styles/xenos.css"/>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td class="003366" height="25" valign="bottom"><xenos:img srcKey="inf.image.inf.image.logotop" width="147" height="7"/></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="175" valign="bottom" class="003366"><xenos:img srcKey="inf.image.logobottom" width="147" height="18"/></td>
    <td width="314" valign="bottom" class="486D92"><xenos:img srcKey="inf.image.triangle2" width="19" height="18"/></td>
    
    <td class="486D92" align="right" valign="bottom">
	</td>
  </tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td class="bgStripes" width="100%" nowrap>&nbsp;<img srcKey="inf.image.whitespace" width="1" height="22"></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td class="head" valign="bottom" width="70%">&nbsp;&nbsp;<bean:message key="inf.label.illegalaccessdenied"/></td>
    <td align="right" width="70%"><xenos:img srcKey="inf.image.imgnomura" width="480" height="45"/></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="CECFCE">&nbsp;</td>
  </tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="9">
  <tr> 
    <td align="left"> 
      <p class="lblRed"><b><bean:message key="inf.label.illegalaccessreason1"/></b></p>
      <p class="lblRed"><b><bean:message key="inf.label.illegalaccessreason2"/></b></p>
	<xenos:image property="submit" srcKey="inf.image.button.btnclose1" srcKeyMouseOver="inf.image.button.btnclose2" srcKeyMouseOut="inf.image.button.btnclose1" border="0"  onclick="top.window.close();"/>


   </td>
  </tr>
</table>


</body>
</html>
