<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%
response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

String ses = (String) session.getAttribute("autorizacao");
if ( ses != null ) {
    session.setAttribute("autorizacao","descabida");
    session.setAttribute("usuario","ninguém");
}
%>

<html>
    <head>
        <title>ACESSO AO STRANGLED FIG DO ERP</title>
        <link rel="stylesheet" href="estilo.css">
    </head>
    <body>
        </br></br>
        <p style="text-align: center">Strangled Fig Pattern um novo ERP</p>
        <form action="login.jsp" method="post">
        <table class="table-login">
            <tr>
                <td>
                    <table align="center">
                        <tr>
                            <td class="texto_destaque">USUÁRIO</td>
                            <td><input type="text" size="20" name="user" autofocus/></td>
                        </tr>
                        <tr>
                            <td class="texto_destaque">SENHA</td>
                            <td><input type="password" size="20" name="password"/></td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: center;">
                                <input type="submit" value="LOGIN"/>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        </form>
    </body>
</html>