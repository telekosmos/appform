<html>
<head>
<title>Application Form Tool</title>

<!--   <link rel="stylesheet" type="text/css" 
						href="../../css/portal_style.css" id="portalCss" /> -
		<link rel="stylesheet" type="text/css" href="../css/portal_style.css" id="portalCss" />
 <link rel="stylesheet" type="text/css" href="css/portal_style.css" id="portalCss" />
   <link rel="shortcut icon" href="../img/favicon.ico"/> -->
   
<link rel="stylesheet" type="text/css" href="../css/portal_style.css"
	id="portalCss" />
<link type="text/css" href="../css/theme/ui.theme.css" rel="stylesheet" />

<script type="text/javascript" src="../js/yahoo/yahoo-dom-event.js"></script>

<script type="text/javascript" src="../js/jquery/jquery-1.3.js"></script>
<script type="text/javascript" src="../js/jquery/ui/1.5/ui.core.js"></script>
<script type="text/javascript" src="../js/jquery/ui/1.5/ui.draggable.js"></script>
<script type="text/javascript" src="../js/jquery/ui/1.5/ui.resizable.js"></script>
<script type="text/javascript" src="../js/jquery/ui/1.5/ui.dialog.js"></script>
<script type="text/javascript" src="../js/core.js"></script>

<script type="text/javascript">

/*
	BrowserDlg = function () {
	
		var dlgProps = 
			{ width: "300px",
		   	fixedcenter: true,
		   	visible: false,
		   	draggable: false,
		   	close: true,
		   	text: dlgTxt,
		   	icon: YAHOO.widget.SimpleDialog.ICON_HELP,
		   	constraintoviewport: true,
		   	buttons: [ { text:"Yes", handler:handleYes, isDefault:true },
					 				 { text:"No",  handler:handleNo } ]
		 	};
		 	
		var dlg;
		var dlgTxt = "Mozilla Firefix 2.x or higher must be used in order to use this application";
		dlgTxt += "\nDo you want to download it now?";
		
		var handleYes = function () {
			window.location.href = "http://www.mozilla.com/en-US/firefox";
		}
		
		var handleNo = function () {
			window.location.href = "http://www.google.com";
		}
		
		return {
			showDlg: function () {
				dlg = new YAHOO.widget.SimpleDialog("simpledialog1", dlgProps);
				dlg.setHeader ("Browser miscompatibility");
				dlg.render ("dlgContainer");
			}
		}
	}();
*/

	BrowserDlg = function () {
		var dlg;
		var dlgTxt = "Mozilla Firefix 2.x or higher must be used in order to use this application";
		dlgTxt += "\nDo you want to download it now?";
	
	
		return {
			showDlg: function () {
				/* initialization for the dialog itself */
				$("#dlgContainer").css("visibility", "visible");
				$(function() {
					$("#dlgContainer").dialog({
						autoOpen: true,
						buttons: {
							"Yes": function () {
								window.location.href = "http://www.mozilla.com/en-US/firefox";
								
								return false;
							},
							" No ": function () {
								window.location.href = "http://www.cnio.es";		
								return false;
							} 
						},
						draggable: false,
						modal: true,
						overlay: {
							opacity: 0.7,
							background: "black"
						},
						height: 150,
						width:360,
						resizable: false,
						title: "Browser miscompatibility"
					}); // dialog "constructor" function
					
					$("#divMsg").css("font-size", "11px");
					
				}); // function
			
			} // showDlg
		
		} // return
	}(); // BrowserDlg


	BrowserDetect.init();
	thisBrowser = BrowserDetect.getBrowser();

	if (thisBrowser.toLowerCase() != "firefox") {
//		BrowserDlg.showDlg();
	}

</script>
</head>

<body id="body">

<div id="portal-container">
<div id="sizer">
<div id="expander">
<table border="0" cellpadding="" cellspacing="5"
	id="header-container-adm">
	<tr>
		<td align="left" valign="top" id="header" width="220px"><a
			href="http://www.inab.org" target="_blank"
			style="text-decoration: none; margin-left: 20px"> <img src="../img/inblogo.jpg"
			height="110" border="0" /></a></td>
		<td align="left" valign="bottom"><a href="http://www.inab.org"
			target="_blank" style="text-decoration: none"> <span
			class="inblogo">Instituto Nacional de Bioinform&aacute;tica</span> </a></td>
	</tr>
</table>



<!-- HERE STARTS THE CENTRAL PART, BOTH THE MENU AND CONTENT AREAS -->
<div id="content-container"><!-- **************** START CONTENT AREA (REGION b)**************** -->
<div id='regionAdmB'>
<table width="100%" height="30%" cellpadding="1" cellspacing="1"
	border="0">
	<tr>
		<td align="center" valign="middle">
		<h1>Application Form Construction and Development Tool</h1>
		</td>
	</tr>
	<!-- 
           	<tr><td align="center" valign="middle" class="textRegionAdmB">
           	Build and perform interview by:<br>
           	<ul>
           	<li>Login as registered user (previous request)</li>
           	<li>Choose a project to create the new interview in</li>
           	<li>Build the interview: create sections, questions, texts</li>
           	<li>Perform the interview to the patients you choose</li>
           	</ul>
           	</td>
           	</tr>-->
</table>

</div>
<!-- regionB --> <!-- ****************** END CONTENT AREA (REGION B) ***************** -->

<!-- ****************** START MENU (LEFT) AREA (REGION A) ***************** -->
<div id='regionAdmA' align="center">

<form method="POST"	action='<%= response.encodeURL("j_security_check") %>'>
<table border="0" cellspacing="5">
	<tr>
		<td align="left">Username:</td>
	</tr>
	<tr>
		<td align="left"><input type="text" name="j_username" size="15"></td>
	</tr>
	<tr>
		<td align="left">Password:</td>
	</tr>
	<tr>
		<td align="left"><input type="password" name="j_password"
			size="15"></td>
	</tr>
	<tr align="left">
		<td><input type="submit" value="Log In">&nbsp; <input
			type="reset" value="Clear"></td>
	</tr>
	<tr>
		<td align="center">
		<a href="../getpass/index.jsp" style="font-size: 11px;color: darkblue">
		I forgot my password
		</a></td>
	</tr>
</table>
</form>

</div>
<!-- region A --> <!-- ****************** END LEFT MENU AREA (REGION A) ***************** -->


</div>
<!-- content-container --></div>
<!-- expander --></div>
<!-- sizer --></div>
<!-- portal-container -->


<!-- FOOTER AND END OF PAGE -->
<div id="footer-container-adm" class="portal-copyright-adm">Developed
at <a class="portal-copyright-adm" href="mailto:gcomesana@cnio.es">CNIO/INB</a><br />
</div>

<div id="dlgContainer" title="Browser miscompatibility" style="text-align:center;">
<b>Mozilla Firefix 2.x or higher</b> must be used in order to use this application<br>
Do you want to download it now?</div>
</body>
</html>