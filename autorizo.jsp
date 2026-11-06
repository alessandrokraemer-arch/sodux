<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>
<%
response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

Connection conn = null;
Statement stmt = null;

try {
    String ses = (String) session.getAttribute("autorizacao");
    String us = (String) session.getAttribute("usuario");
    if ( ses != null || us != null ) {
        if ( !ses.equals((String) session.getId()) || us.equals("ninguém") )
            response.sendRedirect("index.jsp");
        else {
        	Class.forName("com.mysql.cj.jdbc.Driver");
	        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/enterprise", "saas", "saas");

            PreparedStatement psQuery = conn.prepareStatement("SELECT tokenVigente FROM autenticacaoMais WHERE usuario = ?");
            psQuery.setString(1,us);
    
            ResultSet rs = psQuery.executeQuery();
            if (rs != null && rs.next()) {
                String token = rs.getString(1);
                if (token.equals(ses)) { //AUTORIZADO E APRESENTA O BLOCO AQUI ABAIXO
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

<%
    } } } } else {
        response.sendRedirect("index.jsp");
    }
} catch (Exception e) {	
	response.sendRedirect("index.jsp");
}
%>