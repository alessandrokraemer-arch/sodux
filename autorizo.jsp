<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>

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

                    PreparedStatement psQueryExtract = conn.prepareStatement("SELECT empresa, saldo, CONCAT('R$ ', FORMAT(saldo,2,'de_DE')) AS saldoReais FROM Fato_Saldo_da_Loja WHERE calendarioFK = YEAR(CURDATE()) ORDER BY empresa ASC", ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsExtract = psQueryExtract.executeQuery();
%>

<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>STRANGLED FIG ERP</title>
        <link rel="stylesheet" href="estilo.css">
        <!-- aqui abaixo para o gráfico ...-->
        <style>
            * { box-sizing: border-box; margin: 0; padding: 0; }
            body {
              background: radial-gradient(circle at top, #0d162b 0%, #060913 70%);
              color: #e6f1ff;
              font-family: "Segoe UI", Roboto, monospace, sans-serif;
              display: flex;
              justify-content: center;
              align-items: center;
              min-height: 100vh;
              padding: 24px;
            }
            .panel {
              width: 100%;
              max-width: 920px;
              background:  #000000;
              border: 1px solid rgba(0, 245, 212, 0.25);
              border-radius: 16px;
              padding: 24px;
              box-shadow: 0 0 40px rgba(0, 245, 212, 0.08), inset 0 0 20px rgba(0, 187, 249, 0.05);
              backdrop-filter: blur(10px);
            }
        
            .header {
              display: flex;
              justify-content: space-between;
              align-items: baseline;
              margin-bottom: 18px;
              border-bottom: 1px solid rgba(255, 255, 255, 0.08);
              padding-bottom: 12px;
            }
            .title {
              color: #e6f1ff;
              font-size: 16px;
              font-weight: bold;
              font-family: Arial, sans-serif;
              letter-spacing: 1.5px;
            }
            .subtitle {
              font-size: 0.8rem;
              color: #e6f1ff;
            }
            canvas {
              width: 100%;
              height: 440px;
              display: block;
            }
            .styled-table {
                border-collapse: collapse;
                margin: 25px 0;
                font-size: 0.9em;
                font-family: sans-serif;
                min-width: 400px;
                box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
                margin-right: 0;
                margin-left: auto;
            }

            .styled-table thead tr {
                background-color:dodgerblue;
                color:black;
                text-align: left;
            }

            .styled-table th,
            .styled-table td {
                padding: 12px 8px;
                color:black;
                font-weight: bold;
            }

            .styled-table tbody tr {
                border-bottom: 1px solid #dddddd;
            }

            .styled-table tbody tr:nth-of-type(even) {
                background-color: #f3f3f3;
            }

            .styled-table tbody tr:last-of-type {
                border-bottom: 2px solid dodgerblue;
            }

            .styled-table tbody tr.active-row {
                font-weight: bold;
            }
          </style>
    </head>
<body>

    <div class='container'>

        <aside class="lado-esquerdo">
            <iframe src='chat.jsp'></iframe>
        </aside>

        <main class="lado-direito">
              <div class="panel">
                <p style="text-align: center; color: #e6f1ff; font-size: 16px; font-weight: bold;">
                    Strangled Fig ERP Extração de Receita </br> Ano 2026 (Datamart: Fato Saldo da Loja)
                </p>
                <canvas id="waterfallCanvas"></canvas>
              </div>
            
              <script>
                <!-- aqui deva ser ajustado o pos ou neg pois o banco de dados por sinal +- e não por nome-->
                const data = [ <% while (rsExtract.next()) {
                    out.print("{ label: \""+rsExtract.getString("empresa")+"\", value: "+ rsExtract.getFloat("saldo") +", type: \"pos\" },");
                  } out.print("{ label: 'Total Final', value: 0, type: 'total' }"); %>
                ];
            
                // Calcula início, fim e acumulado de cada barra
                let running = 0;
                const bars = data.map((item) => {
                  if (item.type === "total") {
                    const start = 0;
                    const end = running;
                    return { ...item, start, end, displayValue: end };
                  }
                  const start = running;
                  const end = running + item.value;
                  running = end;
                  return { ...item, start, end, displayValue: item.value };
                });
            
                const canvas = document.getElementById("waterfallCanvas");
                const ctx = canvas.getContext("2d");
            
                function resizeAndDraw() {
                  const dpr = window.devicePixelRatio || 1;
                  const rect = canvas.getBoundingClientRect();
                  canvas.width = rect.width * dpr;
                  canvas.height = rect.height * dpr;
                  ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
                  draw(rect.width, rect.height);
                }
            
                function getColor(type) {
                  if (type === "pos") return { fill: "rgba(0, 245, 212, 0.25)", stroke: "#00f5d4", glow: "#00f5d4" };
                  if (type === "neg") return { fill: "rgba(255, 42, 109, 0.25)", stroke: "#ff2a6d", glow: "#ff2a6d" };
                  return { fill: "rgba(0, 187, 249, 0.28)", stroke: "#00bbf9", glow: "#00bbf9" };
                }
            
                function draw(width, height) {
                  ctx.clearRect(0, 0, width, height);
            
                  const pad = { top: 36, right: 28, bottom: 54, left: 64 };
                  const plotW = width - pad.left - pad.right;
                  const plotH = height - pad.top - pad.bottom;
            
                  const allVals = bars.flatMap(b => [b.start, b.end, 0]);
                  const minVal = Math.min(0, ...allVals);
                  const maxVal = Math.max(...allVals) * 1.15;
            
                  const yScale = (val) =>
                    pad.top + plotH - ((val - minVal) / (maxVal - minVal || 1)) * plotH;
            
                  // Linhas de grade horizontais
                  const ticks = 10;
                  ctx.font = "12px monospace";
                  ctx.textAlign = "right";
                  ctx.textBaseline = "middle";
            
                  for (let i = 0; i <= ticks; i++) {
                    const val = minVal + ((maxVal - minVal) / ticks) * i;
                    const y = yScale(val);
            
                    ctx.strokeStyle = "rgba(136, 153, 184, 0.14)";
                    ctx.lineWidth = 1;
                    ctx.beginPath();
                    ctx.moveTo(pad.left, y);
                    ctx.lineTo(width - pad.right, y);
                    ctx.stroke();
            
                    ctx.fillStyle = "#8899b8";
                    ctx.fillText(Math.round(val), pad.left - 10, y);
                  }
            
                  const step = plotW / bars.length;
                  const barW = Math.min(68, step * 0.52);
            
                  bars.forEach((bar, idx) => {
                    const cx = pad.left + step * idx + step / 2;
                    const x = cx - barW / 2;
                    const y1 = yScale(bar.start);
                    const y2 = yScale(bar.end);
                    const topY = Math.min(y1, y2);
                    const barH = Math.max(4, Math.abs(y2 - y1));
                    const palette = getColor(bar.type);
            
                    // Linha conectora pontilhada até a próxima barra
                    if (idx < bars.length - 1) {
                      const nextCx = pad.left + step * (idx + 1) + step / 2;
                      const nextX = nextCx - barW / 2;
                      ctx.save();
                      ctx.setLineDash([4, 5]);
                      ctx.strokeStyle = "rgba(230, 241, 255, 0.25)";
                      ctx.beginPath();
                      ctx.moveTo(x + barW, y2);
                      ctx.lineTo(nextX, y2);
                      ctx.stroke();
                      ctx.restore();
                    }
            
                    // Barra com efeito neon
                    ctx.save();
                    ctx.shadowColor = palette.glow;
                    ctx.shadowBlur = 14;
                    ctx.fillStyle = palette.fill;
                    ctx.strokeStyle = palette.stroke;
                    ctx.lineWidth = 1.8;
                    ctx.beginPath();
                    ctx.roundRect(x, topY, barW, barH, 4);
                    ctx.fill();
                    ctx.stroke();
                    ctx.restore();
            
                    // Valor acima/abaixo da barra
                    ctx.font = "bold 12px monospace";
                    ctx.textAlign = "center";
                    ctx.fillStyle = palette.stroke;
                    const prefix = bar.type === "pos" && bar.displayValue > 0 ? "+" : "";
                    const labelY = bar.end >= bar.start ? topY - 10 : topY + barH + 14;
                    ctx.fillText(`${prefix}${bar.displayValue}`, cx, labelY);
            
                    // Rótulo do eixo X
                    ctx.font = "12px sans-serif";
                    ctx.fillStyle = "#cbd5e1";
                    ctx.fillText(bar.label, cx, height - pad.bottom + 22);
                  });
                }
            
                window.addEventListener("resize", resizeAndDraw);
                resizeAndDraw();
              </script>

              <table class="styled-table">
                <tr style="background-color: black;">
                  <td style="text-align: center; color: #dddddd;">Filial</td>
                  <td style="text-align: left; color: #dddddd;">Valor em desconfiança</td>
                </tr>

                <% 
                String strEmpresa = "";
                float valorTotalizado = 0;
                float fltCorrente = 0;
                
                Locale br = Locale.of("pt","BR");
                NumberFormat moeda = NumberFormat.getCurrencyInstance(br);

                rsExtract.beforeFirst(); 
                while (rsExtract.next()) { 
                  strEmpresa = rsExtract.getString("empresa");
                  fltCorrente = rsExtract.getFloat("saldo");
                  valorTotalizado = valorTotalizado + fltCorrente; %>

                <tr>
                  <td style="text-align: left;"><%=strEmpresa%></td>
                  <td style="text-align: left;"><%=rsExtract.getString("saldoReais")%></td>
                </tr>

                <% } 
                rs.close();
                rsExtract.close();
                %>

                <tr class="active-row">
                  <td style="text-align: right; color: dodgerblue; font-size: 16pt;">Totalizado</td>
                  <td style="text-align: left; color: dodgerblue; font-size: 16pt;"><%=moeda.format(valorTotalizado)%></td>
                </tr>
              </table>        
        </main>
    </div>

</body>
</html>

<%                        
                }
            }
        }
    } else {
        response.sendRedirect("index.jsp");
    }
} catch (Exception e) {	
	    response.sendRedirect("index.jsp");
}
%>