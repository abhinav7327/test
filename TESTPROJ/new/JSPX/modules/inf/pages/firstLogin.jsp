


<html>
<head>
<%
	String logoutUrl = request.getContextPath() + "/logout.action?";
	
%>
<title>Xenos: Please Login</title>
<link rel="stylesheet" href="styles/xenos.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td bgcolor="#003366" height="40" colspan="2" valign="bottom">
		<img src="images/logoTop.gif"/><br>
		<img src="images/logoBottom.gif"/>
	</td>
  </tr>
  <tr>
	<td><img src="images/spacer.gif"  height="1"/></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <td bgcolor="#88B0DB">
	<table width="700" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td width="55" bgcolor="#88B0DB">&nbsp;</td>
		<td width="55" bgcolor="#A0C0E2"><img src="images/spacer.gif" width="1" height="45"/></td>
		<td width="55" bgcolor="#B8D0E9"><img src="images/spacer.gif" width="1" height="45"/></td>
		<td width="55" bgcolor="#DBE7F4"><img src="images/spacer.gif" width="1" height="45"/></td>
		<td width="480"></td>
	  </tr>
	</table>
  </td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td colspan="2" valign="bottom"><img src="images/spacer.gif"  width="7" height="1"/></td>
  </tr>
  <tr>
	<td colspan="2" valign="bottom" height="30" bgcolor="#DBE7F4"><img src="images/welcome.gif" width="334" height="17" hspace="5"/></td>
  </tr>
  <tr>
	<td colspan="2"><img src="images/spacer.gif"  width="7" height="1"/></td>
  </tr>
  <tr>
	<td colspan="2" bgcolor="#e4e4e4" align="center">

	 
	  <table width="600" border="0" cellspacing="0" cellpadding="0">
		<tr>
		  <td width="600" align="center" bgcolor="#cccccc" height="220">			
			<table width="350" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="18"><img src="images/boxLeftTop.gif" width="18" height="11"/></td>
				<td width="314" background="images/boxTop.gif"><img src="images/spacer.gif"  width="7" height="8"/></td>
				<td width="18"><img src="images/boxRightTop.gif" width="18" height="11"/></td>
			  </tr>
			</table>
			<table width="350" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="18" background="images/boxLeft.gif">&nbsp;</td>
				<td bgcolor="#E6E6E6" class="Label">&nbsp;</td>
				<td width="18" background="images/boxRight.gif">&nbsp;</td>
			  </tr>
			</table>
			<table width="350" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="18" background="images/boxLeft.gif">&nbsp;</td>
				<td width="314" bgcolor="#E6E6E6" class="Label">It seems either you have logged into the system for the first time or your password has expired. You must change your password now. Please <a href=<%=logoutUrl%>>logout</a> and log-in using RUI System to change your password.				
				</td>
				<td width="18" background="images/boxRight.gif">&nbsp;</td>
			  </tr>
			</table>
			<table width="350" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="18"><img src="images/boxLeftBottom.gif" width="18" height="11"></td>
				<td width="314" background="images/boxBottom.gif""><img src="images/spacer.gif"  width="7" height="8"/></td>
				<td width="18"><img src="images/boxRightBottom.gif" width="18" height="11"/></td>
			  </tr>
			</table>			
		  </td>
		</tr>
	  </table>
	 
	</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td colspan="2" valign="bottom"><img src="images/spacer.gif"  width="7" height="1"/></td>
  </tr>
  <tr>
	<td colspan="2" bgcolor="#b4b4b4" height="30">&nbsp;</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td bgcolor="#999999" align="center">
	  <table width="100%" border="0" cellspacing="1" cellpadding="1">
		<tr>
		  <td width="100%" align="center" class="footer">Copyright &copy; 2000-2008 Nomura Asset Management Co., Ltd. All Rights Reserved</td>
		</tr>
	  </table>
	</td>
  </tr>
</table>
</body>
</html>