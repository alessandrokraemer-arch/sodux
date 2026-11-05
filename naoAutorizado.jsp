<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>
<%
response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

String ses = session.getAttribute("autorizacao");
if ( !ses.equals((String) session.getId()) )
    response.sendRedirect("naoAutorizado.jsp");
%>