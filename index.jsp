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
        <title>LOGIN...</title>
        <style>
			td {
				font-size: 14pt;
			}
			input[type=text] {
 				font-size:14pt;
				color:red;
			}
      		input[type=password] {
 				font-size:14pt;
				color:red;
			}
            input[type=submit] {
                font-size:14pt;
                color:blue;
            }
		</style>
    </head>
    <body>
        <form action="login.jsp" method="post">
        <table align="center">
            <tr>
                <td>USER</td>
                <td align="right"><input type="text" size="20" name="user"/></td>
            </tr>
            <tr>
                <td>PASSWORD</td>
                <td align="right"><input type="password" size="20" name="password"/></td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" value="ENTRAR NO SISTEMA COM SESSÃO"/>
                </td>
            </tr>
        </table>
        </form>
    </body>
</html>