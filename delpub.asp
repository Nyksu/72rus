<%@LANGUAGE="JAVASCRIPT"%>
<!-- #include file="inc\records.inc" -->
<!-- #include file="inc\getform.inc" -->
<!-- #include file="inc\path.inc" -->
<!-- #include file="inc\err.inc" -->

<%
// ��� ������� ��� ���... �� ������ �������� ��� � ������ ������!!
var smi_id=1
// +++  smi_id - ��� ��� � ������� SMI !!

var id=parseInt(Request("pid"))
if (isNaN(id)) {Response.Redirect("index.asp")}

var name=""
var hid=0
var retname="�������� � �������"
var sql=""
var ShowForm=true
var isok=true
var path=""
var hdd=0
var hadr=""
var nm=""
var fs= new ActiveXObject("Scripting.FileSystemObject")
var filename=""
var pic1=""
var pic2=""
var pic3=""

if (String(Session("id_mem"))=="undefined") {
	if (String(Session("id_mem_pub"))=="undefined") {
		Session("backurl")="delpub.asp?pid="+id
		Response.Redirect("logpub.asp")
	}
	if (Session("tip_mem_pub")<3) {usok=true}
	id_usr=TextFormData(Session("id_mem_pub"),"0")
} else {
	if ((Session("is_adm_mem")!=1) && (Session("is_host")!=1)) {
		sql="Select * from smi where users_id="+Session("id_mem")+"and id="+smi_id
		Records.Source=sql
		Records.Open()
		if (!Records.EOF) {
			usok=true
		}
		Records.Close()
	} else {
		usok=true
	}
}

if (!usok) {Response.Redirect("pubarea.asp")}

sql="Select t1.* from publication t1, heading t2 where t1.id="+id+" and t1.heading_id=t2.id and t2.smi_id="+smi_id
Records.Source=sql
Records.Open()
if (Records.EOF){
	Records.Close()
	Response.Redirect("pubarea.asp")
}
hid=Records("heading_id").Value
name=String(Records("NAME").Value)
Records.Close()

hdd=hid
while (hdd>0) {
	Records.Source="Select * from heading where id="+hdd
	Records.Open()
	nm=String(Records("NAME").Value)
	hadr=TextFormData(Records("URL").Value,"pubheading.asp")
	path="<a href=\""+hadr+"?hid="+hdd+"\">"+nm+"</a> | "+path
	hdd=Records("HI_ID").Value
	Records.Close()
}

filename=PubFilePath+id+".pub"
if (!fs.FileExists(filename)) { filename="" }

pic1=PubFilePath+id+".gif"
if (!fs.FileExists(pic1)) {pic1="" }
if (pic1=="") {
	pic1=PubFilePath+id+".jpg"
	if (!fs.FileExists(pic1)) { pic1="" }
}

pic2=PubFilePath+"l"+id+".gif"
if (!fs.FileExists(pic2)) {pic2="" }
if (pic2=="") {
	pic2=PubFilePath+"l"+id+".jpg"
	if (!fs.FileExists(pic2)) { pic2="" }
}

pic3=PubFilePath+"r"+id+".gif"
if (!fs.FileExists(pic3)) {pic3="" }
if (pic3=="") {
	pic3=PubFilePath+"r"+id+".jpg"
	if (!fs.FileExists(pic3)) { pic3="" }
}

if (String(Request.Form("next1")) != "undefined") {
	if (Request.Form("agr")==1) {
		sql="Delete from publication where id="+id
		Connect.BeginTrans()
		try{
			Connect.Execute(sql)
			if (filename!="") {fs.DeleteFile(filename)}
			if (pic1!="") {fs.DeleteFile(pic1)}
			if (pic2!="") {fs.DeleteFile(pic2)}
			if (pic3!="") {fs.DeleteFile(pic3)}
		}
		catch(e){
			Connect.RollbackTrans()
			isok=false
		}
		if (isok){
			Connect.CommitTrans()
			var ShowForm=false
		}
	} else {Response.Redirect("pubarea.asp")}
}

%>

<Html>
<Head>
<Title>�������� ������� <%=name%></Title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
<link rel="stylesheet" href="style.css" type="text/css">
</Head>
<BODY bgColor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0">
<table width="100%" border="1" cellspacing="1" cellpadding="0" bgcolor="#CCCCCC" bordercolor="#000000">
  <tr> 
    <td bordercolor="#CCCCCC"> 
      <p><a href="pubarea.asp"><b>������� ���������</b></a> | <a href="index.asp">������������� 
        �������</a> | <a href="bloknews.asp">����� ��������</a> </p>
    </td>
  </tr>
</table>
<h1 align="center"><font size="3">�������� ����������</font></h1>
<p>����&gt; <font color="#FF0000"><%=path%></font></p>
<% if (ShowForm) {%>
<p align="center"><b>�� ������������� ������ ������� ����������: <font color="#FF0000"><%=name%></font> ?</b></p>
<p>&nbsp;</p>
<p align="center"><b><font size="3" color="#FF0000">&nbsp;&nbsp;��������!</font></b> 
  �������� ����������!</p>
<p align="center">�������� ���������� ���������� � �� ���������� ����� �����������!</p>
<p align="center">���� �� ������ ������� ����������, �� ��������� ������ � ��������������� 
  ���� � ������� ������ &quot;����������&quot;.</p>
<form name="form1" method="post" action="delpub.asp">
  <input type="hidden" name="pid" value="<% =id %>">
  <p align="center"> 
    <input type="checkbox" name="agr" value="1">
    ��, � ���� ������� ��� ����������: (<b><font color="#FF0000" size="3"><%=name%></font></b>) !</p>
  <p align="center">&nbsp;</p>
  <p align="center"> 
    <input type="submit" name="next1" value="����������">
  </p>
</form>
<%} else {%>
<p>&nbsp;</p>
<p align="center"><font color="#FF0000"><b>������ ������!</b></font></p>
<%}%>
<p align="center"><a href="index.asp">��������� � �����������</a></p>
<p align="center"><a href="pubarea.asp">������� ���������</a></p>
</Body>
</Html>
