<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>
<%
response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

String ses = (String) session.getAttribute("autorizacao");
if ( ses != null )
    if ( !ses.equals((String) session.getId()) )
        response.sendRedirect("index.jsp");
%>

<html>
    <head>
        <title>AQUI, DENTRO DO SISTEMA</title>
        <style>
            p {
                font-size:18pt;
            }
        </style>
    </head>
<body>
<p>AUTORIZADO NESTA PÁGINA.</p>
</body>
</html>