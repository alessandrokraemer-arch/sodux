<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>

<%@ page import="java.net.URI" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.http.HttpClient" %>
<%@ page import="java.net.http.HttpRequest" %>
<%@ page import="java.net.http.HttpResponse" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.charset.*" %>

<%
response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

Connection conn = null;
Statement stmt = null;

try {
    String ses = (String) session.getAttribute("autorizacao");
    String us = (String) session.getAttribute("usuario");
    if ( ses != null || us != null ) {
        if ( !ses.equals((String) session.getId()) || us.equals("ninguém") )
            response.sendRedirect("index.jsp");
        else {
        	Class.forName("com.mysql.cj.jdbc.Driver");
	        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/enterprise", "saas", "saas");

            PreparedStatement psQuery = conn.prepareStatement("SELECT tokenVigente FROM autenticacaoMais WHERE usuario = ?");
            psQuery.setString(1,us);
    
            ResultSet rs = psQuery.executeQuery();
            if (rs != null && rs.next()) {
                String token = rs.getString(1);
                if (token.equals(ses)) { //AUTORIZADO E APRESENTA O BLOCO AQUI ABAIXO
%>

                <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Chat</title>
                    <link rel="stylesheet" href="estilo.css">
                    <style>
                        body {
                            background: radial-gradient(circle at top, #0d162b 0%, #060913 70%);
                            color: #e6f1ff;
                            font-family: "Segoe UI", Roboto, monospace, sans-serif;
                            justify-content: center;
                            align-items: center;
                            min-height: 100vh;
                            padding: 6px;
                        }          
                    </style>
                </head>
                <body>

                <% 
                // Lê a chave da variável de ambiente OPENAI_API_KEY
                String apiKey = getServletContext().getInitParameter("OPENAI_API_KEY");

                if (apiKey == null || apiKey.isEmpty()) { %>

                    <p style="text-align: center;">Chat desabilitado. <%=apiKey%> </p>
                    
                <% } else {

                    String perguntaUsuario = request.getParameter("pergunta");

                    if (perguntaUsuario != null && !perguntaUsuario.trim().isEmpty()) {
                        try {
                            String jsonPayload = "";
                            String modoDemanda = "1"; // padrão
                            HttpClient client = HttpClient.newHttpClient();
                            JSONObject jsonBody = new JSONObject();
                            StringBuilder fontesHtml = new StringBuilder();
                            String conteudo = "";

                            modoDemanda = (String) request.getParameter("modo");
                            if (modoDemanda != null && !modoDemanda.trim().isEmpty()) {

                                switch (modoDemanda) {
                                    case "1": // modo com complexidade mínima
                                        jsonBody.put("model", "gpt-4o-mini");
                                        
                                        JSONArray messages = new JSONArray();

                                        JSONObject userMessage = new JSONObject();
                                        userMessage.put("role", "user");
                                        userMessage.put("content", perguntaUsuario);
                                        messages.put(userMessage);

                                        jsonBody.put("messages", messages);
                                        jsonPayload = jsonBody.toString();

                                        HttpRequest requestJSON = HttpRequest.newBuilder()
                                            .uri(URI.create("https://api.openai.com/v1/chat/completions"))
                                            .header("Content-Type", "application/json")
                                            .header("Authorization", "Bearer " + apiKey)
                                            .POST(HttpRequest.BodyPublishers.ofString(jsonPayload))
                                            .build();
            
                                        HttpResponse<String> responseJSON = client.send(requestJSON, HttpResponse.BodyHandlers.ofString());
            
                                        String resposta = responseJSON.body().toString();
            
                                        JSONObject rootObject = new JSONObject(resposta);
            
                                        JSONArray choicesArray = rootObject.getJSONArray("choices");
                                        JSONObject firstChoice = choicesArray.getJSONObject(0);
            
                                        JSONObject messageObject = firstChoice.getJSONObject("message");
                                        conteudo = messageObject.getString("content");
                                        break;

                                    case "2": // modo avançado busca web
                                        String acrescimo = "resposta com abreviação, ";
                                        jsonBody.put("model", "gpt-4o");
                                        jsonBody.put("input", acrescimo + perguntaUsuario);
                                
                                        JSONArray tools = new JSONArray();
                                        JSONObject webSearchTool = new JSONObject();
                                        webSearchTool.put("type", "web_search");
                                        tools.put(webSearchTool);
                                        jsonBody.put("tools", tools);

                                        jsonPayload = jsonBody.toString();
                                                                    
                                        HttpRequest httpRequestJSONBusca = HttpRequest.newBuilder()
                                            .uri(URI.create("https://api.openai.com/v1/responses"))
                                            .header("Content-Type", "application/json")
                                            .header("Authorization", "Bearer " + apiKey)
                                            .POST(HttpRequest.BodyPublishers.ofString(jsonPayload))
                                            .build();

                                        HttpResponse<String> httpResponseBusca = client.send(httpRequestJSONBusca, HttpResponse.BodyHandlers.ofString());

                                        HttpResponse<String> apiResponse = client.send(httpRequestJSONBusca, HttpResponse.BodyHandlers.ofString());
                                        JSONObject jsonResponse = new JSONObject(apiResponse.body());
                                        JSONArray outputs = jsonResponse.getJSONArray("output");
                                    
                                        // Percorre o array "output" para achar a mensagem e as citações
                                        for (int i = 0; i < outputs.length(); i++) {
                                            JSONObject item = outputs.getJSONObject(i);
                                            String type = item.optString("type");
                                    
                                            // Quando o item é a mensagem final do modelo
                                            if ("message".equals(type)) {
                                                JSONArray contents = item.getJSONArray("content");
                                                for (int j = 0; j < contents.length(); j++) {
                                                JSONObject contentObj = contents.getJSONObject(j);
                                                if ("output_text".equals(contentObj.optString("type"))) {
                                                        conteudo = contentObj.getString("text") + "</br>";
                                    
                                                        // Extrai as citações (url_citation) vinculadas ao texto
                                                        JSONArray annotations = contentObj.optJSONArray("annotations");
                                                        if (annotations != null) {
                                                            for (int k = 0; k < annotations.length(); k++) {
                                                                JSONObject ann = annotations.getJSONObject(k);
                                                                if ("url_citation".equals(ann.optString("type"))) {
                                                                    String title = ann.optString("title", "Fonte");
                                                                    String url = ann.optString("url");
                                                                    fontesHtml.append("<li><a href='").append(url).append("' target='_blank'>").append(title).append("</a></li>");
                                                                }
                                                            }
                                                    }
                                                    }
                                                }
                                            }

                                            conteudo = conteudo.replace("\n", "<br>");
                                            if (fontesHtml.length() > 0)
                                                conteudo = conteudo + "<p class='texto-branco'>Fontes citadas:</p><ul>"+ fontesHtml.toString() +"</ul>";
                                
                                        }
                                        break;
                                }
                            }
                %>    

                        <form action="chat.jsp" method="post">
                            <input type="submit" value="Demanda" style="width: 100%;"/>
                            <input type="text" name="pergunta" style="width: 100%;" autofocus/>
                            <p class="texto-branco">
                                <input type="radio" name="modo" value="1" checked/> Amplo
                                <input type="radio" name="modo" value="2"/> Web Complexa (demanda tempo...) 
                            </p>
                        </form>
                        
                        <p class="texto-verde-neon"><%=perguntaUsuario%></p>
                        <p class="texto-branco" style="text-align: left;"><%=conteudo%></p>


                <%      } catch (Exception e) { %>
                    
                        <p align="center">Erro no acesso a IA...<%=e.getMessage()%></p>
                        
                <%      } 
                    } else { %> 

                        <form action="chat.jsp" method="post">
                            <input type="submit" value="Demanda" style="width: 100%;"/>
                            <input type="text" name="pergunta" style="width: 100%;" autofocus/>
                            <p class="texto-branco">
                                <input type="radio" name="modo" value="1" checked/> Amplo
                                <input type="radio" name="modo" value="2"/> Web Complexa (demanda tempo...) 
                            </p>
                        </form>
                <% } 
                } %>

                </body>
                </html>

<%
    } } } } else {
        response.sendRedirect("index.jsp");
    }
} catch (Exception e) {	
	response.sendRedirect("index.jsp");
}
%>
