<!-- ediprj.jsp -->
<%@ page language="java" contentType="text/html;charset=UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, java.util.List,
								java.util.Enumeration"  %>
								
<%@page import="org.cnio.appform.entity.AbstractItem,
								org.cnio.appform.entity.Text, org.cnio.appform.entity.Question, 
								org.cnio.appform.entity.Project, org.cnio.appform.entity.Section,
								org.cnio.appform.entity.Interview, 
								org.cnio.appform.entity.AnswerItem,
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController,
								org.cnio.appform.util.IntrvController" %>	
<%
// This one is commented if the hibSes is defined in center.jsp and
// this file is include using the include directive rather than include action
//	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	String prjId = request.getParameter ("frmid");
	Project s = null;
	if (prjId != null) {
		Integer intSecId = Integer.decode (prjId);
		s = (Project)hibSes.get(Project.class, intSecId);
	}
//	hibSes.close ();
	pageContext.setAttribute ("theId", prjId);
	if (s != null)
		pageContext.setAttribute("project", s);
	
//	hibSes.close();
%>
<c:set var="prjName" value=""/>
<c:set var="prjDesc" value=""/>
<c:set var="theId" value=""/>
<c:if test="${not empty section}">
	<c:set var="prjName" value="${project.name}"/>
	<c:set var="prjDesc" value="${project.description}"/>
	<c:set var="theId" value="${project.id}"/>
</c:if>

<!-- **************** START CONTENT AREA (REGION b)**************** -->		 
<div id='regionAdmB'>

<h3>Project Edition</h3>
<form id="formSecs" name="formSecs" xaction="saveitem.jsp" method="post">
<table cellpadding="5" cellspacing="1" border="1" width="550">
	<tr><td valign="top" align="left">
	<span>Project name:&nbsp;</span>
	<input type="hidden" name="frmid" value="${project.id}"/>
	<input type="hidden" name="t" value="${param.t}"/>
	<input type="hidden" name="op" value="${param.op}"/>
	<input type="text" name="frmName" id="frmName" value="${project.name}" 
				maxlength="128" size="32"/>
	</td></tr>
	<tr><td valign="top" align="left"><span>Project description:</span><br/>
	<textarea name="frmDesc" id="frmDesc" cols="45" rows="3">${project.description}</textarea>
	</td></tr>
	<tr><td>
	<span id="frmPrjTitle">Project code:</span>
	<input type="text" name="frmPrjCode" id="frmPrjCode" maxlength="3"	size="5"
		value="${project.projectCode}"/>
	</td></tr>
	<tr><td align="right">
		<input type="button" name="btnOk" value=" Ok " 
					onclick="prjFormCtrl.chkNewPrj (this.form);"/>&nbsp;
		<input type="button" name="btnCancel" value = " Cancel " 
					onclick="prjFormCtrl.onCancelEdit (this.form);"/>
	</td></tr>
</table>
</form>
</div> <!-- regionB -->
<!-- ****************** END CONTENT AREA (REGION B) ***************** -->