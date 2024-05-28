package web;
import jakarta.servlet.annotation.WebServlet;

import java.io.FileWriter;
import jakarta.servlet.ServletException;
import java.sql.Time;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.json.JSONObject;
import model.Users;
import model.Produtos;
import model.SaidaProdutos;
import java.time.LocalDate;
import java.time.LocalTime;
import model.Employees;
import org.json.JSONArray;

@WebServlet(name = "ApiServlet", urlPatterns = {"/api/*"})
public class ApiServlet extends HttpServlet {

    public JSONObject getJSONBODY(BufferedReader reader) throws IOException {
        StringBuilder buffer = new StringBuilder();
        String line = null;
        while ((line = reader.readLine()) != null) {
            buffer.append(line);
        }
        return new JSONObject(buffer.toString());
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        JSONObject file = new JSONObject();

        try {
            if (request.getRequestURI().endsWith("/api/session")) {
                processSession(file, request, response);
            } else if (request.getRequestURI().endsWith("/api/users")) {
                processUsers(file, request, response);
            } else if (request.getRequestURI().endsWith("/api/employees")) {
                processEmployees(file, request, response);
            } else if (request.getRequestURI().endsWith("/api/produtos")) {
                processProdutos(file, request, response);
            } else if (request.getRequestURI().endsWith("/api/saida_produtos")) {
                processSaidaProdutos(file, request, response);
            } else if (request.getRequestURI().endsWith("/api/csv")) {
                processCsvGeneration(request, response, file);
            }
            

        } catch (Exception ex) {
            response.sendError(500, "Internal Error: " + ex.getLocalizedMessage());
        }
        response.getWriter().print(file.toString());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

    private void processSession(JSONObject file, HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (request.getMethod().toLowerCase().equals("put")) {
            JSONObject body = getJSONBODY(request.getReader());
            String login = body.getString("login");
            String password = body.getString("password");
            Users u = Users.getUser(login, password);
            if (u == null) {
                response.sendError(403, "Login or password incorrect");
            } else {
                // Setando a sessão do usuario
                request.getSession().setAttribute("users", u);
                file.put("id", u.getRowid());
                file.put("login", u.getLogin());
                file.put("name", u.getName());
                file.put("role", u.getRole());
                file.put("passwordHash", u.getPasswordHash());
                file.put("message", "Logged in");
            }
        } else if (request.getMethod().toLowerCase().equals("delete")) {
            // Removendo a sessão do usuario
            request.getSession().removeAttribute("users");
            file.put("message", "Logged out");
        } else if (request.getMethod().toLowerCase().equals("get")) {
            // Verificando se existe sessão do usuario
            if (request.getSession().getAttribute("users") == null) {
                response.sendError(403, "No Session");
            } else {
                // Se houver resgata os atributos
                Users u = (Users) request.getSession().getAttribute("users");
                file.put("id", u.getRowid());
                file.put("login", u.getLogin());
                file.put("name", u.getName());
                file.put("role", u.getRole());
                file.put("passwordHash", u.getPasswordHash());
            }
        } else {
            response.sendError(405, "Method not allowed");
        }
    }

    private void processUsers(JSONObject file, HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (request.getSession().getAttribute("users") == null) {
            response.sendError(401, "Unauthorized: No session");
        } else if (!((Users) request.getSession().getAttribute("users")).getRole().equals("ADMIN")) {
            response.sendError(401, "Unauthorized: Only admin can manage users");
        } else if (request.getMethod().toLowerCase().equals("get")) {
            int page = Integer.parseInt(request.getParameter("page"));
            int itemPage = 5;
            file.put("list", new JSONArray(Users.getUsers(page, itemPage)));
            file.put("total", Users.getTotalUsers());
        } else if (request.getMethod().toLowerCase().equals("post")) {
            JSONObject body = getJSONBODY(request.getReader());
            String login = body.getString("login");
            String name = body.getString("name");
            String role = body.getString("role");
            String password = body.getString("password");
            Users.insertUser(login, name, role, password);
        } else if (request.getMethod().toLowerCase().equals("put")) {
            JSONObject body = getJSONBODY(request.getReader());
            String login = body.getString("login");
            String name = body.getString("name");
            String role = body.getString("role");
            String password = body.getString("password");
            Long id = Long.parseLong(request.getParameter("id"));
            Users.updateUser(id ,login, name, role, password);
        } else if (request.getMethod().toLowerCase().equals("delete")) {
            Long id = Long.parseLong(request.getParameter("id"));
            Users.deleteUser(id);
        } else {
            response.sendError(405, "Method not allowed");
        }
    }

    private void processEmployees(JSONObject file, HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (request.getSession().getAttribute("users") == null) {
            response.sendError(401, "Unauthorized: No session");
        } else if (request.getMethod().toLowerCase().equals("get")) {
             String pageParam = request.getParameter("page");
            if (pageParam == null) {
                file.put("list", new JSONArray(Employees.getEmployees()));
            } else {
                int page = Integer.parseInt(pageParam);
                int itemsPerPage = 5;
                file.put("list", new JSONArray(Employees.getEmployeesPages(page, itemsPerPage)));
                file.put("total", Employees.getTotalEmployees());
            }
        } else if (request.getMethod().toLowerCase().equals("post")) {
            JSONObject body = getJSONBODY(request.getReader());
            String name = body.getString("name");
            String type = body.getString("type");
            Employees.insertEmployee(name, type);
        } else if (request.getMethod().toLowerCase().equals("put")) {
            JSONObject body = getJSONBODY(request.getReader());
            String name = body.getString("name");
            String type = body.getString("type");
            Long id = Long.parseLong(request.getParameter("id"));
            Employees.updateEmployee(id, name, type);
        } else if (request.getMethod().toLowerCase().equals("delete")) {
            Long id = Long.parseLong(request.getParameter("id"));
            Employees.deleteEmployee(id);
        } else {
            response.sendError(405, "Method not allowed");
        }
    }

    private void processProdutos(JSONObject file, HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (request.getSession().getAttribute("users") == null) {
            response.sendError(401, "Unauthorized: No session");
        } else if (request.getMethod().equalsIgnoreCase("GET")) {
            String pageParam = request.getParameter("page");
            String totParam = request.getParameter("tot");
            String filtro = request.getParameter("filtro");
            String src = request.getParameter("search");
            if (pageParam == null && totParam == null && filtro == null && src == null) {
                file.put("list", new JSONArray(Produtos.getProdutos()));
            } else if(totParam != null){
                file.put("total", Produtos.getTotalProdutos());
            }else if(filtro != null){
                   file.put("total", Produtos.getTotalProdutosFiltrados(filtro));
            } else if(pageParam != null){
                int page = Integer.parseInt(pageParam);
                int itemsPerPage = 5;
                file.put("list", new JSONArray(Produtos.getProdutosPages(page, itemsPerPage)));
                file.put("total", Produtos.getTotalProdutos());
            }else if(src != null){
                
                file.put("list", new JSONArray(Produtos.getProdutosPesquisa(src)));
                
            } else{
                response.sendError(407, "Sem Parâmetros Funcionais");
            }            
        } else if (request.getMethod().equalsIgnoreCase("POST")) {
            JSONObject body = getJSONBODY(request.getReader());
            String nome = body.getString("nome");
            int quantidade = body.getInt("quantidade");
            String tipo = body.getString("tipo");

            String dataString = body.getString("data");
            String horarioString = body.getString("horario");

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");

            Date dataUt = dateFormat.parse(dataString);
            java.sql.Date data = new java.sql.Date(dataUt.getTime());
            Date horario = timeFormat.parse(horarioString);

            Time horarioTime = new Time(horario.getTime());

            Produtos.insertProduto(nome, quantidade, tipo, data, horarioTime);
        } else if (request.getMethod().equalsIgnoreCase("PUT")) {
            JSONObject body = getJSONBODY(request.getReader());
            long id = body.getLong("id");
            String nome = body.getString("nome");
            int quantidade = body.getInt("quantidade");
            String tipo = body.getString("tipo");
            String dataString = body.getString("data");
            String horarioString = body.getString("horario");
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            Date dataUt = dateFormat.parse(dataString);
            java.sql.Date data = new java.sql.Date(dataUt.getTime());
            Date horario = timeFormat.parse(horarioString);
            Time horarioTime = new Time(horario.getTime());
            Produtos.updateProduto(id, nome, quantidade, tipo, data, horarioTime);
        } else if (request.getMethod().equalsIgnoreCase("DELETE")) {
            long id = Long.parseLong(request.getParameter("id"));
            Produtos.deleteProduto(id);
        } else {
            response.sendError(405, "Method not allowed");
        }
    }
    
    private void processSaidaProdutos(JSONObject file, HttpServletRequest request, HttpServletResponse response) throws Exception {
    if (request.getSession().getAttribute("users") == null) {
        response.sendError(401, "Unauthorized: No session");
    } else if (request.getMethod().equalsIgnoreCase("GET")) {
        
        String pageParam = request.getParameter("page");
            if (pageParam == null) {
                file.put("list", new JSONArray(SaidaProdutos.getSaidaProdutos()));
            } else {
                int page = Integer.parseInt(pageParam);
                int itemsPerPage = 5;
                file.put("list", new JSONArray(SaidaProdutos.getSaidasPages(page, itemsPerPage)));
                file.put("total", SaidaProdutos.getTotalSaidas());
            }
    } else if (request.getMethod().equalsIgnoreCase("POST")) {
        JSONObject body = getJSONBODY(request.getReader());
        String dataString = body.getString("data");
            String horarioString = body.getString("horario");

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");

            Date dataUt = dateFormat.parse(dataString);
            java.sql.Date data = new java.sql.Date(dataUt.getTime());
            Date horario = timeFormat.parse(horarioString);

            Time horarioTime = new Time(horario.getTime());
        Produtos produto = Produtos.getProduto(body.getLong("produto_id"));
        String departamento = body.getString("departamento");
        Employees funcionario = Employees.getEmployee(body.getLong("funcionario_id"));
        int quantidade = body.getInt("quantidade");
        String almoxarifante = body.getString("almoxarifante");
        String descricao = body.optString("descricao");

        SaidaProdutos.insertSaidaProduto(data, horarioTime, produto, departamento, funcionario, quantidade, almoxarifante, descricao);
    } else if (request.getMethod().equalsIgnoreCase("PUT")) {
        JSONObject body = getJSONBODY(request.getReader());
        long id = body.getLong("rowid");
        String dataString = body.getString("data");
            String horarioString = body.getString("horario");
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            Date dataUt = dateFormat.parse(dataString);
            java.sql.Date data = new java.sql.Date(dataUt.getTime());
            Date horario = timeFormat.parse(horarioString);
            Time horarioTime = new Time(horario.getTime());
        Produtos produto = Produtos.getProduto(body.getLong("produto_id"));
        String departamento = body.getString("departamento");
        Employees funcionario = Employees.getEmployee(body.getLong("funcionario_id"));
        int quantidade = body.getInt("quantidade");
        String almoxarifante = body.getString("almoxarifante");
        String descricao = body.optString("descricao");

        SaidaProdutos.updateSaidaProduto(id, data, horarioTime, produto, departamento, funcionario, quantidade, almoxarifante, descricao);
    } else if (request.getMethod().equalsIgnoreCase("DELETE")) {
        long id = Long.parseLong(request.getParameter("rowid"));
        SaidaProdutos.deleteSaidaProduto(id);
    } else {
        response.sendError(405, "Method not allowed");
    }
}    
    private void processCsvGeneration(HttpServletRequest request, HttpServletResponse response, JSONObject jsonResponse) throws IOException, ServletException {
    if (request.getMethod().equalsIgnoreCase("GET")) {
        String filtro = request.getParameter("tipoFiltro");
        String filePath = "EstoqueCompleto.csv"; // Caminho padrão para o arquivo CSV

        

        try {
            if (filtro != null && !filtro.isEmpty()) {
            // Gerar o arquivo CSV com base no filtro selecionado
            if (filtro.equalsIgnoreCase("DISPONIVEL")) {
                filePath = "EstoqueDisponivel.csv";
            } else if (filtro.equalsIgnoreCase("NO ARMAZEM")) {
                filePath = "EstoqueNoArmazem.csv";
            }
             else if (filtro.equalsIgnoreCase("ESGOTADO")) {
                filePath = "ProdutosEsgotados.csv";
            }
        }
            // Chama a função para gerar o arquivo CSV com base no caminho do arquivo
            CsvGenerator.generateCsvFile(filePath, filtro);

            // Define o tipo de conteúdo e o cabeçalho para download
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filePath + "\"");

            // Envia o arquivo CSV gerado como resposta
            java.nio.file.Path csvFile = java.nio.file.Paths.get(filePath);
            java.nio.file.Files.copy(csvFile, response.getOutputStream());
            response.getOutputStream().flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    } else {
        response.sendError(405, "Method not allowed");
    }
}
}
