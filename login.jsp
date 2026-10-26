<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>

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
<%
//aqui conexão com banco de dados
Connection conn = null;
Statement stmt = null;

//aqui no código é averiguado o acesso ao banco...
try {
	//aqui o uso do mysql e é praxe no java
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/enterprise", "saas", "saas");

    // UM TOKEN É GERADO ALEATÓRIO EM FUNÇÃO NO BANCO DE DADOS
    PreparedStatement ps = conn.prepareStatement("SELECT token FROM login WHERE user = ? AND password = MD5(?)");
    ps.setString(1,(String) request.getParameter("user"));
    ps.setString(2,(String) request.getParameter("password"));
    
    ResultSet rs = ps.executeQuery();
    if (rs != null && rs.next()) {
        String token = rs.getString(1);

        session.setAttribute("token",token);
        
        out.print("<p align='center'>Conectado</p>");
    } else {
        out.print("<p align='center'>TOKEN NÃO ENCONTRADO. ASSINE OU ATUALIZE O PLANO...</p>");
    }

    //aqui é acionado caso ocorra erro no acesso ao banco etc
} catch (Exception e) {	
	out.print("<h1>ERRO NO ACESSO</h1>");
    //out.print((String) e.getMessage());
	//response.sendRedirect("erro/erro.jsp");
}%>
</body>
</html>

