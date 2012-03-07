<!-- editsec.jsp?t=sec&op=new/upd&spid=intrId/frmid=secId, for update -->
<%@page language="java" contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, 
								java.util.Enumeration, java.util.List,
								org.json.simple.*"  %>
								
<%@page import="org.cnio.appform.entity.*, 
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController,
								org.cnio.appform.util.AppUserCtrl" %>
								
<%
// This one is commented if the hibSes is defined in center.jsp and
// this file is include using the include directive rather than include action
//	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	String secId = request.getParameter ("frmid");
	Section s = null;
	if (secId != null) {
		Integer intSecId = Integer.decode (secId);
		s = (Section)hibSes.get(Section.class, intSecId);
	}
//	hibSes.close ();
	if (s != null)
		pageContext.setAttribute("section", s);
	
	pageContext.setAttribute("interview", null);
	String intrId = request.getParameter("spid");
	if (intrId != null) {
		Interview intr = (Interview)hibSes.get(Interview.class, Integer.decode(intrId));
		pageContext.setAttribute ("interview", intr);
	}
	
//	hibSes.close();
%>
<c:set var="secName" value=""/>
<c:set var="secDesc" value=""/>
<c:set var="theId" value=""/>
<c:if test="${not empty section}">
	<c:set var="secName" value="${section.name}"/>
	<c:set var="secDesc" value="${section.description}"/>
	<c:set var="theId" value="${section.id}"/>
</c:if>

<!-- **************** START CONTENT AREA (REGION b)**************** -->		 
<div id='regionAdmB'>

<h3>Section Edition 
<c:if test="${not empty interview}"> - Interview '${interview.name}'</c:if></h3>
<form id="formSecs" name="formSecs" xaction="saveitem.jsp" method="post">
<table cellpadding="5" cellspacing="1" border="1" width="550">
	<tr><td valign="top" align="left">
	<span>Section name:&nbsp;</span>
	<input type="hidden" name="frmid" value="${theId}"/>
	<input type="hidden" name="t" value="${param.t}"/>
	<input type="hidden" name="op" value="${param.op}"/>
	<input type="hidden" name="spid" value="${param.spid}"/>
	<input type="text" name="frmName" id="frmName" value="${secName}" 
				maxlength="128" size="32"/>
	</td></tr>
	<tr><td valign="top" align="left"><span>Section description:</span><br/>
	<textarea name="frmDesc" id="frmDesc" cols="45" rows="3">${secDesc}</textarea>
	</td></tr>
	<tr><td align="right">
		<input type="button" name="btnOk" value=" Ok " 
					onclick="secFormCtrl.chkNewSec (this.form);"/>&nbsp;
		<input type="button" name="btnCancel" value = " Cancel " 
					onclick="secFormCtrl.onCancelEdit (this.form);"/>
	</td></tr>
</table>
</form>
</div> <!-- regionB -->
<!-- ****************** END CONTENT AREA (REGION B) ***************** -->