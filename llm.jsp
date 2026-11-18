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
String apiKey = getServletContext().getInitParameter("OPENAI_API_KEY");

if (apiKey == null || apiKey.isEmpty()) { %>

    <p align="center">Chat desabilitado. <%=apiKey%> </p>
    
<% } else {

    //String perguntaUsuario = request.getParameter("pergunta");
    String perguntaUsuario = "o que fazer hoje?";

    if (perguntaUsuario != null && !perguntaUsuario.trim().isEmpty()) {
        try {
            // 1. Montar o JSON de requisição para a OpenAI
            JSONObject jsonBody = new JSONObject();
            jsonBody.put("model", "gpt-4o-mini");

            // Força a API a retornar um JSON válido (JSON Mode)
            JSONObject responseFormat = new JSONObject();
            responseFormat.put("type", "json_object");
            jsonBody.put("response_format", responseFormat);

            JSONArray messages = new JSONArray();
                
            // Instrução do sistema (obrigatório mencionar "JSON" quando usar json_object)
            JSONObject systemMessage = new JSONObject();
            systemMessage.put("role", "system");
            systemMessage.put("content", "Você é um assistente útil. Responda sempre em formato JSON contendo as chaves 'resumo' e 'topicos' (uma lista de strings).");
            messages.put(systemMessage);

            // Mensagem do usuário
            JSONObject userMessage = new JSONObject();
            userMessage.put("role", "user");
            userMessage.put("content", perguntaUsuario);
            messages.put(userMessage);

            jsonBody.put("messages", messages);

            //String pergunta = (String) request.getParameter("perguntaHTML");

            // Configuração da requisição em JSON (Responses API / Chat Completions) e esse é o endpoint.

            //String jsonBody = "{'model': 'gpt-4o','messages': [{'role': 'user', 'content': 'Qual o dia hoje?''}]}";

            // Cria o cliente e a requisição HTTP
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest requestJSON = HttpRequest.newBuilder()
                .uri(URI.create("https://api.openai.com/v1/chat/completions"))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + apiKey)
                .POST(HttpRequest.BodyPublishers.ofString(jsonBody.toString()))
                .build();

            // Envia e imprime a resposta
            HttpResponse<String> responseJSON = client.send(requestJSON, HttpResponse.BodyHandlers.ofString());

            String resposta = responseJSON.body().toString();
    
            out.println(resposta);

            // 1. Converte a String em um JSONObject
            //JSONObject rootObject = new JSONObject(resposta);

            // 2. Acessa o array "choices" e pega o primeiro item (índice 0)
            //JSONArray choicesArray = rootObject.getJSONArray("choices");
            //JSONObject firstChoice = choicesArray.getJSONObject(0);

            // 3. Acessa o objeto "message" e extrai a string "content"
            //JSONObject messageObject = firstChoice.getJSONObject("message");
            //String conteudo = messageObject.getString("content");
    
            //out.println(conteudo);

        } catch (Exception e) { %>
       
        <p align="center">Erro no acesso a IA...</p>
        
<%      } 
    } else { %> 

        <p align="center">Acesse com uma pergunta</p>

<% } 
} %>

</body>
</html>

