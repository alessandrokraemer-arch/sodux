<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>
<%
response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);
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
<%
//aqui conexão com banco de dados
Connection conn = null;
Statement stmt = null;

//aqui no código é averiguado o acesso ao banco...
try {
	//aqui o uso do mysql e é praxe no java
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/enterprise", "saas", "saas");

    // AQUI UMA AVERIGUAÇÃO MAS EM CÓDIGO ABERTO O PARA EXEMPLIFICAR E DEVA APRIMORAR QUE EM CÓDIO COMPILADO É MAIS CONDIZENTE...
    PreparedStatement ps = conn.prepareStatement("SELECT tokenVigente FROM autenticacaoMais WHERE usuario = ? AND senha = MD5(?)");
    String user = (String) request.getParameter("user");
    ps.setString(1,user);
    ps.setString(2,(String) request.getParameter("password"));
    
    ResultSet rs = ps.executeQuery();
    if (rs != null && rs.next()) {
        String autorizacao = rs.getString(1);

        PreparedStatement ps = conn.prepareStatement("UPDATE autenticacaoMais SET tokenVigente = ?, sessaoUltima = ?, dataHoraUltimaAutorizacao = NOW() WHERE usuario = ?");
        ps.setString(1,(String) session.getId());
        ps.setString(2,(String) session.getId());
        ps.setString(3,user);
        ps.executeUpdate();
        
        session.setAttribute("autorizacao", autorizacao);
        
        out.print("<p align='center'>AUTORIZADO <a href='autorizo.jsp'>ACESSE MAIS</a></p>");
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

