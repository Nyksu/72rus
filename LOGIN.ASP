<%@LANGUAGE="JAVASCRIPT"%>
<!-- #include file="inc\records.inc" -->
<!-- #include file="inc\getform.inc" -->
<!-- #include file="inc\err.inc" -->

<%
var ErrorMsg=""

if (String(Session("backurl"))=="undefined"){Session("backurl")="index.html"}

isFirst=String(Request.Form("login"))=="undefined"
if(!isFirst){	Pass=TextFormData(Request.Form("pass"),"")
	Nik=TextFormData(Request.Form("nik"),"")

	Nik=Nik.replace("/*","")
	Nik=Nik.replace("'","")
	Pass=Pass.replace("/*","")
	Pass=Pass.replace("'","")
	Records.Source="Select * from USERS where PSW='"+Pass+"' and LOGNAME='"+Nik+"'"
	Records.Open()
	if (Records.EOF){ErrorMsg+="�������� '������ ��� ���������'.<br>"}
	else { if (Records("STATE").Value==1){
		Session("id_mem")=String(Records("ID").Value)
		Session("name_mem")=String(Records("FIO").Value)
		Session("nik_mem")=String(Records("LOGNAME").Value)
		Session("state_mem")=String(Records("STATE").Value)
		Session("is_adm_mem")=String(Records("ADM").Value)
		Session("email_mem")=String(Records("EMAIL").Value)
		} else {
		Session("id_mem")="undefined"
		Session("name_mem")="undefined"
		Session("is_adm_mem")="undefined"
		Session("cataloghost")="undefined"
		ErrorMsg+="�������� '������ ��� ���������'.<br>"
		}
	}
	Records.Close()
	if (ErrorMsg==""){
		Records.Source="Select * from catalog where id="+catalog
    	Records.Open()
   		if (Records.EOF){
			Records.Close()
			Response.Redirect("index.asp")
   		}
   		if (Session("id_mem")==Records("USERS_ID").Value) {Session("cataloghost")=catalog}
   		Records.Close()
		Response.Redirect(Session("backurl"))
	}
}

%>

<html>
<head>
<title>��������������</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
</head>

<body bgcolor="#FFFFFF" text="#000000">

 <p><br>
  </p>
  <p align="center"><%if(ErrorMsg!=""){%> </p>
  <center>
    <h2> 
      <p> <font color="#FF3300" size="2"><b>������!</b></font> <br>
        <%=ErrorMsg%></p>
    </h2>
  </center>
  <%}%>
  <p>&nbsp;</p> 
  <form name="form1" method="post" action="login.asp">
   <table width="100%" border="0" cellspacing="4" cellpadding="0"> 
      <tr valign="middle"> 
        <td width="50%" align="right"> 
          <p><b>��������� (�����)</b></p>
        </td>
        <td width="50%"> 
          <input type="text" name="nik" value="<%=isFirst?"":Request.Form("nik")%>" size="20" maxlength="20">
          * </td>
      </tr>
      <tr valign="middle"> 
        <td width="50%" align="right"> 
          <p><b>������</b></p>
        </td>
        <td width="50%"> 
          <input type="password" name="pass" size="20" maxlength="20">
          * </td>
      </tr> 
    </table>
    <p align="center"> 
      <input type="submit" name="login" value="����">
    </p>
    <hr size="1">
    <p align="center"><b>* - ������������ ����</b></p>
    <p align="center">&nbsp;</p>
  </form>
  

</body>
</html>
