<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>

<%@ page import="java.net.URI" %>
<%@ page import="java.net.http.HttpClient" %>
<%@ page import="java.net.http.HttpRequest" %>
<%@ page import="java.net.http.HttpResponse" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>

<html>
<head><title>Chat IA</title></head>
<body>

<% 
// Lê a chave da variável de ambiente OPENAI_API_KEY
//String apiKey = System.getenv("OPENAI_API_KEY");
String apiKey = getServletContext().getInitParameter("OPENAI_API_KEY");

if (apiKey == null || apiKey.isEmpty()) { %>

    <p align="center">Chat desabilitado. <%=apiKey%> </p>
    
<% } else {

    //String pergunta = (String) request.getParameter("perguntaHTML");

    // Configuração da requisição em JSON (Responses API / Chat Completions) e esse é o endpoint.
    String jsonBody = "{'model': 'gpt-4o','messages': [{'role': 'user', 'content': 'Qual o dia hoje?''}]}";

    // Cria o cliente e a requisição HTTP
    HttpClient client = HttpClient.newHttpClient();
    HttpRequest requestJSON = HttpRequest.newBuilder()
        .uri(URI.create("https://api.openai.com/v1/chat/completions"))
        .header("Content-Type", "application/json")
        .header("Authorization", "Bearer " + apiKey)
        .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
        .build();

    // Envia e imprime a resposta
    HttpResponse<String> responseJSON = client.send(requestJSON, HttpResponse.BodyHandlers.ofString());

    try {
        String resposta = responseJSON.body().toString();
    
        // 1. Converte a String em um JSONObject
        //JSONObject rootObject = new JSONObject(resposta);

        // 2. Acessa o array "choices" e pega o primeiro item (índice 0)
        //JSONArray choicesArray = rootObject.getJSONArray("choices");
        //JSONObject firstChoice = choicesArray.getJSONObject(0);

        // 3. Acessa o objeto "message" e extrai a string "content"
        //JSONObject messageObject = firstChoice.getJSONObject("message");
        //String content = messageObject.getString("content");
    } catch (Exception e) { %>
       
        <p align="center">Erro no acesso a IA...</p>
        
    <% }
%> 

<%//content%>

<% } %>

</body>
</html>

