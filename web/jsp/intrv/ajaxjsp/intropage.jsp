<%--
This page will be the first page in the interview performance procedure in
order to set the patient code for the patient who the interview is gonna be made 
the interview to
--%>

<%@ page language="java" contentType="text/html;charset=UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="org.hibernate.Session, java.util.Collection, 
								java.util.Iterator, java.util.ArrayList, java.util.List,
								java.util.Enumeration, java.util.Calendar, java.util.Locale,
								java.util.TimeZone, java.text.DateFormat"  %>
								
<%@page import="org.apache.commons.lang.StringEscapeUtils" %>								
<%@page import="org.cnio.appform.entity.*, org.cnio.appform.util.AppUserCtrl,
								org.cnio.appform.util.IntrvFormCtrl,
								org.cnio.appform.util.HibernateUtil,
								org.cnio.appform.util.HibController,
								org.cnio.appform.entity.PerfUserHistory" %>
	
<%
// System.out.println ("intropage.jsp");

Session hibSes = HibernateUtil.getSessionFactory().openSession();
AppUserCtrl userCtrl = new AppUserCtrl (hibSes);
Integer userId = (Integer)session.getAttribute ("usrid");
AppUser appUsr = (AppUser)hibSes.get(AppUser.class, userId);


AppGroup mainGrp = userCtrl.getPrimaryActiveGroup(appUsr);
List<AppGroup> secondaryGrps = userCtrl.getSecondaryGroups(appUsr, mainGrp);
Integer numGroups = (secondaryGrps == null)? 0: secondaryGrps.size();
pageContext.setAttribute("numGroups", numGroups);

pageContext.setAttribute("mypreview", 0);
if (request.getParameter ("sim") != null) {
	pageContext.setAttribute("mypreview", 1);

}

Integer isLogged = (Integer)session.getAttribute("logged");

//if frmid and spid are present, then this is the result of an update/save of
//an item
Integer usrId = (Integer)session.getAttribute ("usrid"),
				intrvId = (Integer)session.getAttribute ("intrvId"),
				hospId = (Integer)session.getAttribute ("secondaryGrpId"),
				prjCod = (Integer)session.getAttribute ("prjid"),
				patid = (Integer)session.getAttribute("patId");

if (isLogged == null || usrId == null || intrvId == null || hospId == null) {
	String jsonMsg = "{\"res\":0,\"msg\":\"The session has expired. Log in again\"}";
	out.println(jsonMsg);
	
	return;
}
	
	usrId = (usrId == null)? 100: usrId;
	
	String itrtd="<tr><td>", etrtd="</td></tr>",
				itrtd2="<tr><td coldpan=\"2\">";
	
	List<AbstractItem> itemsSec = null;
//	Session hibSes = HibernateUtil.getSessionFactory().openSession();
	
	AppGroup hosp = (AppGroup)hibSes.get(AppGroup.class, hospId);
	AppUser user = (AppUser)hibSes.get(AppUser.class, usrId);
	Interview intrv = (Interview)hibSes.get(Interview.class, intrvId);
	Section intro = 
		HibController.SectionCtrl.getSectionsFromIntrv(hibSes, intrv).iterator().next();


	String maxLenNum = "maxlength=\"10\"", maxSizeNum="size=\"15\"",
				 maxLenLab = "maxlength=\"128\"", maxSizeLab="size=\"32\"",
				 hospCod = hosp.getCodgroup();

	out.println ("<form id=\"introForm\" name=\"introForm\">");
	out.println ("<span class=\"titleForm\">"+intro.getName()+"</span><br><br>");
	out.println ("<table>");
	out.println ("<input type=\"hidden\" name=\"secId\" value=\""+intro.getId()+"\" />");
	out.println ("<input type=\"hidden\" name=\"usrId\" value=\""+usrId+"\" />");
	out.println ("<input type=\"hidden\" name=\"intrvId\" value=\""+intrvId+"\" />");
	out.println ("<input type=\"hidden\" name=\"hospCod\" value=\""+hospCod+"\" />");
	out.println ("<input type=\"hidden\" name=\"prjCod\" value=\""+prjCod+"\" />");
	out.println ("<input type=\"hidden\" name=\"finish\" value=\"0\" />");
	out.println ("<input type=\"hidden\" name=\"currentsec\" id=\"currentsec\" value=\"0\" />");
	if (userCtrl.getPrimaryActiveGroup(user).getCodgroup() == "ES")
		out.println (itrtd + "<b>Entrevistador:</b> " + user.getFirstName() +
									" "+user.getLastName() +" ("+ user.getUsername() +")" + etrtd);
	else
		out.println (itrtd + "<b>Interviewer:</b> " + user.getFirstName() +
				" "+user.getLastName() +" ("+ user.getUsername() +")" + etrtd);
	
	
// Change by 03.09: chooose between short or long interview	

	itemsSec = HibernateUtil.getContainers4Section (hibSes, intro);
//	Object[] theItems = itemsSec.toArray();

// First, lets check whether or not we have some text items before...
// Still keep the first question for the patcode
	int countItems = 0;
	for (AbstractItem ait: itemsSec) {
		if (ait instanceof Text) {
			out.println (itrtd+"<br><b>"+
					StringEscapeUtils.escapeHtml(ait.getContent())+"</b>"+etrtd);
			countItems++;
		}
		else
			break; // leave the loop after getting first non-text item
	}
	for (int i=0; i<countItems; i++)
		itemsSec.remove(0);
	

// After text items to introduce the interview, we have to set the textarea
// if the interview was chosen to be short
  out.print (itrtd);
	String shrtPerf = (String)session.getAttribute("shrtPerf"); // request.getParameter("short");
	if (shrtPerf != null) {
		IntrvFormCtrl intrvCtrl = new IntrvFormCtrl (hibSes);
		PerfUserHistory puh = intrvCtrl.getPerformanceFromIntrv(patid, intrvId);

		String msgEn = "A SHORT interview performance was chosen this time. This decision has ";
		msgEn += "to be justified. The next text is the justification for this ";
		msgEn += "interview last time it was performed. Just keep this text or ";
		msgEn += "edit it to justify the short performance this time";
		String msgEs = "Se ha elegido realizar una entrevista corta. Esta decisión ";
		msgEs += "tiene que ser justificada. El siguiente texto es la justificación ";
		msgEs += "para esta entrevista la última vez que fue realizada. Tan solo ";
		msgEs += "mantiene este texto o edítalo para justificar la entrevista ";
		msgEs += "corta esta vez";
		
		Integer grpId = (Integer)session.getAttribute("primaryGrpId");
		AppGroup grp = 	(AppGroup)hibSes.get(AppGroup.class, grpId);
		
		if (grp.getCodgroup().toUpperCase() == "ES")
			out.print(msgEs);
		else
			out.print(msgEn);
		
		out.println("<br>");
		String txtJustify = "<br><textarea id=\""+IntrvFormCtrl.JUSTIFICATION_NAME+
				"\" name=\""+IntrvFormCtrl.JUSTIFICATION_NAME+"\"";
		txtJustify += " rows=\"5\" cols=\"50\" wrap=\"soft\">";
		txtJustify += puh == null? "": puh.getJustification();
		txtJustify += "</textarea>";
		
		out.print (txtJustify);
	}
	
	out.print (etrtd);
	
	String inputName = "";
	List<AnswerItem> cai = null;
	int contCai = 1;
// Textboxes for the rest of Introduction sections ///////////////////////////
	for (AbstractItem ai: itemsSec) {
//		AbstractItem place = (AbstractItem)theItems[1];
		if (ai instanceof Text)
			out.println (itrtd+"<br><b>"+
					StringEscapeUtils.escapeHtml(ai.getContent())+"</b>"+etrtd);
		
		else {
			cai = HibernateUtil.getAnswerTypes4Question (hibSes, ai);
			
	//		if (cai.size() > 1) // question with several answers
			out.println (itrtd+StringEscapeUtils.escapeHtml(ai.getContent())+etrtd);
	
			String numQuestion = "1";
			contCai = 1;
			out.println(itrtd);
			List<QuestionsAnsItems> lQai = 
				HibController.ItemManager.getPatterns(hibSes, (Question)ai);
			for (AnswerItem ansi : cai) {
				
				inputName = "q"+ai.getId();
				if (ansi instanceof AnswerType) { // simple answer (label, number)
					AnswerType anst = (AnswerType)ansi;
					String maxLen = "maxlength=\"", maxSize="size=\"";			
					if (ansi.getName().equalsIgnoreCase("number") || 
							ansi.getName().equalsIgnoreCase("decimal")) {
						maxLen+="10\"";
						maxSize+="12\"";
					}
					else {
						maxLen+="128\"";
						maxSize+="32\"";
					}
					
					String[] ranges = {"-", "-", "-"};
					if (ansi.getName().equalsIgnoreCase("number") ||
							ansi.getName().equalsIgnoreCase("decimal")) {
						String pattern = lQai.remove(0).getPattern();
							
						if (pattern != null && pattern.length()>0)
							ranges = pattern.split(";");
					}	
						
					inputName += "-1-"+ contCai;
					out.println("&nbsp;<input type=\"text\" name=\"" + inputName + "\" "+maxLen+" "+maxSize+
							" onblur=\"intrvFormCtrl.chk" + ansi.getName()
							+ "(this, '"+ranges[0]+"', '"+ranges[1]+"', '"+ranges[2]+"')\"/>");
				} 
				else if (ansi instanceof EnumType) {
					String sel = "selected=\"selected\"";
					List<EnumItem> ceni = HibController.EnumTypeCtrl
							.getEnumItems(hibSes, (EnumType) ansi);

					String selName = "q" + ai.getId() + "-" + numQuestion + "-" + 
									contCai, htmlPiece;
					
					htmlPiece = "&nbsp;<select name=\"" + selName +"\" "+
							"id=\"" + selName + "\" style=\"width:200px;\"" ;
					
					htmlPiece += "onfocus=\"intrvFormCtrl.onfocus(this.name)\">";
					
					out.println(htmlPiece);
					
					out.println("<option value=\""+
										org.cnio.appform.util.RenderEng.MISSING_ANSWER+"\"> </option>");
					for (EnumItem eni : ceni) {
						if (eni.getValue().equalsIgnoreCase(""))
							out.println("<option value=\""
									+ eni.getValue()
									+ "\" "
									+ sel
									+ " >"
									+ StringEscapeUtils.escapeHtml(eni
											.getName()) + "</option>");
						else
							out.println("<option value=\""
									+ eni.getValue()
									+ "\">"
									+ StringEscapeUtils.escapeHtml(eni
											.getName()) + "</option>");
					}
					out.println("</select>");
					
					
/****************************					
					List<EnumItem> ceni = 
						HibController.EnumTypeCtrl.getEnumItems(hibSes, (EnumType) ansi);
					out.println("&nbsp;<select name=\"q" + ai.getId() + "-"
							+ ansi.getAnswerOrder() + "\" style=\"width:200px;\">");
					for (EnumItem eni : ceni) {
						out.println("<option value='" + eni.getValue() + "'>"
								+ StringEscapeUtils.escapeHtml(eni.getName()) + "</option>");
					}
					out.print("</select>");
*****************************/
				} 
				else {
					out.println("ERROR: Not implemented case -&gt: "
							+ StringEscapeUtils.escapeHtml(ansi.getName()) + "<br>");
				}
				
				if (contCai < cai.size()) {
					out.print ("&nbsp;-&nbsp;");
					contCai++;
				}
				else
					out.println (etrtd);
			} // end of num of answers loop
			
			out.println();
		}
		
	}
	

%>