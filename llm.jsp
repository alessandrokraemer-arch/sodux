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
// Lê a chave da variável de ambiente OPENAI_API_KEY mas aqui dispenso e o melhor é com abordagem de banco de dados
// e armazenamento dessa chave. 
// String apiKey = System.getenv("OPENAI_API_KEY");

String apiKey = "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";
if (apiKey == null || apiKey.isEmpty()) { %>

    <p align="center">Chat desabilitado.</p>
    
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

    String resposta = responseJSON.body().toString();
    // 1. Converte a String em um JSONObject
    JSONObject rootObject = new JSONObject(resposta);

    // 2. Acessa o array "choices" e pega o primeiro item (índice 0)
    JSONArray choicesArray = rootObject.getJSONArray("choices");
    JSONObject firstChoice = choicesArray.getJSONObject(0);

    // 3. Acessa o objeto "message" e extrai a string "content"
    JSONObject messageObject = firstChoice.getJSONObject("message");
    String content = messageObject.getString("content");
%> 

<%=content%>

<% } %>

</body>
</html>

