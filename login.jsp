<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>
<%
response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

String ses = (String) session.getAttribute("autorizacao");
if ( ses != null )
    if ( !ses.equals(("descabida")) ) 
        response.sendRedirect("index.jsp");

//aqui conexão com banco de dados
Connection conn = null;
Statement stmt = null;

//aqui no código é averiguado o acesso ao banco...
try {
	//aqui o uso do mysql e é praxe no java
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/enterprise", "saas", "saas");

    // AQUI UMA AVERIGUAÇÃO MAS EM CÓDIGO ABERTO O PARA EXEMPLIFICAR E DEVA APRIMORAR QUE EM CÓDIO COMPILADO É MAIS CONDIZENTE...
    PreparedStatement psQuery = conn.prepareStatement("SELECT usuario FROM autenticacaoMais WHERE usuario = ? AND senha = MD5(?)");
    String user = (String) request.getParameter("user");
    psQuery.setString(1,user);
    psQuery.setString(2,(String) request.getParameter("password"));
    
    ResultSet rs = psQuery.executeQuery();
    if (rs != null && rs.next()) {
        String usuarioBD = rs.getString(1);

        PreparedStatement psUpdate = conn.prepareStatement("UPDATE autenticacaoMais SET tokenVigente = ?, sessaoUltima = ?, dataHoraUltimaAutorizacao = NOW() WHERE usuario = ?");
        psUpdate.setString(1,(String) session.getId());
        psUpdate.setString(2,(String) session.getId()); // ISSO AQUI É PARA UMA CONSULTA FUTURA E PODEM HAVER MAIS CAMPOS
        psUpdate.setString(3,user);
        psUpdate.executeUpdate();
        
        session.setAttribute("autorizacao", session.getId());
        session.setAttribute("usuario", usuarioBD);

        response.sendRedirect("autorizo.jsp");

    } else {
%>

<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AVERIGUAÇÃO DO ACESSO</title>
        <link rel="stylesheet" href="estilo.css">
    </head>
<body>

    <p class='aviso' style='text-align: center;'>TOKEN NÃO ENCONTRADO. ASSINE OU ATUALIZE O PLANO...</p>

</body>
</html>

<%   }

    //aqui é acionado caso ocorra erro no acesso ao banco etc
} catch (Exception e) {	
	out.print("<h1>ERRO NO ACESSO</h1>");
    //out.print((String) e.getMessage());
	//response.sendRedirect("erro/erro.jsp");
}%>