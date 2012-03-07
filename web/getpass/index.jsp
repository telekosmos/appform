<?xml version="1.0" encoding="ISO-8859-1" ?>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>



<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Password Request Dialog</title>
<!link type="text/css" href="../css//ui.all.css" rel="stylesheet" />

<link type="text/css" 
			href="../js/yahoo/container/assets/skins/sam/container.css" rel="stylesheet" />
<!-- 
<link type="text/css" 
			href="js/yahoo/button/assets/skin/sam/button.css" rel="stylesheet" />
-->
<link type="text/css" href="../css/passwdlg.css" rel="stylesheet" />


<!-- jquery stuff -->
<script type="text/javascript" src="../js/jquery/jquery-1.3.js"></script>

<!-- container related yui files -->
<script type="text/javascript" src="../js/yahoo/yahoo-dom-event.js"></script>
<script type="text/javascript" src="../js/yahoo/connection-debug.js"></script>
<script type="text/javascript" src="../js/yahoo/json-debug.js"></script>

<script type="text/javascript" src="../js/yahoo/container/container-debug.js"></script>
<script type="text/javascript" src="../js/core.js"></script>
<script type="text/javascript" src="js/reqpassyui.js"></script>
</head>

<body onreadystatechange="onReady ('getpass');" onload="onReady('getpass');" class="yui-skin-sam">
<div id="myDlg">

<div class="hd" id="hdDlg">
Write your
registered <b>email</b> and fill the <b>captcha</b> correctly<br>
</div>

<!div id="slider">

<div class="bd" id="bdDlg" align="center">
<form id="frmPasswdReq" name="frmPasswdReq" method="post">
<table id="tablesplit" width="440" 
		style="padding-left:5px;padding-right:5px;padding-top:5px;padding-bottom:5px;">
	
	<tr>
		<td>Username:</td>
		<td align="right"><input type="text" name="frmusername" id="frmusername" /></td>
	</tr>
	<tr>
		<td>Email:</td>
		<td align="right"><input type="text" name="frmemail" id="frmemail" /></td>
	</tr>
	<tr>
		<td>Repeat email:</td>
		<td align="right"><input type="text" name="frmemailbis" id="frmemailbis" /></td>
	</tr>
	<tr>
<!-- 	<td colspan="3" style="margin-top:5px;margin-bottom:5px;
					background-image: url(../img/graypixel.gif);max-height:1px"> -->
			<td colspan="3" style="border:1px solid red;">
		</td>
	</tr>
	<!-- captcha layout -->
	<tr>
		<td rowspan="2" valign="bottom"><img id="captchaImg" src="/appform/jcaptcha"
			border="1" /></td>
		<td valign="bottom"></td>
	</tr>
	<tr>
		<td valign="bottom">
			<a href="#" onclick="passwdReq.refresh();">Refresh
		image</a><br><br>
			<input type="text" id="j_captcha_response" name="j_captcha_response" 
						value="" /><br>
		</td>
	</tr><!-- 
	<tr><td colspan="2"><div id="divMsg" class="spanfont"></div></td></tr> -->
</table>
<td colspan="2"><div id="divMsg" class="spanfont"></div>
</form>
<!/div> <!-- slider -->

</div> <!-- bd -->
</body>
</html>