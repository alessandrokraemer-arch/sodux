<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>
<%
response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

String token = (String) session.getAttribute("autorizacao");

if (token == null)
    response.sendRedirect("index.jsp");
else {
    Connection conn = null;
    Statement stmt = null;

    try {
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/enterprise", "saas", "saas");

        PreparedStatement ps = conn.prepareStatement("SELECT sessao FROM autenticacaoMais WHERE sessaoUltima");
        ps.setString(1,(String) request.getParameter("user"));
        ps.setString(2,(String) request.getParameter("password"));
    
    ResultSet rs = ps.executeQuery();
    if (rs != null && rs.next()) {
        String autorizacao = rs.getString(1);


%>

<html>
    <head>
        <title>AVERIGUAÇÃO DO ACESSO</title>
        <style>
            p {
                font-size:18pt;
            }
        </style>
    </head>
<body>