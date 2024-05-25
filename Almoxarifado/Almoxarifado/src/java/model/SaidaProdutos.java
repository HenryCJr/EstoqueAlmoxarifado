package model;
import java.sql.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import web.AppListener;

public class SaidaProdutos {
    private long rowid;
    private Date data;
    private Time horario;
    private Produtos produto;
    private String departamento;
    private Employees funcionario;
    private int quantidade;
    private String almoxarifante;
    private String descricao;

    public SaidaProdutos(long rowid, Date data, Time horario, Produtos produto, String departamento, Employees funcionario, int quantidade, String almoxarifante, String descricao) {
        this.rowid = rowid;
        this.data = data;
        this.horario = horario;
        this.produto = produto;
        this.departamento = departamento;
        this.funcionario = funcionario;
        this.quantidade = quantidade;
        this.almoxarifante = almoxarifante;
        this.descricao = descricao;
    }

    // Getters and Setters
    public long getRowid() {
        return rowid;
    }

    public void setRowid(long rowid) {
        this.rowid = rowid;
    }

    public Date getData() {
        return data;
    }

    public void setData(Date data) {
        this.data = data;
    }

    public Time getHorario() {
        return horario;
    }

    public void setHorario(Time horario) {
        this.horario = horario;
    }

    public Produtos getProduto() {
        return produto;
    }

    public void setProduto(Produtos produto) {
        this.produto = produto;
    }

    public String getDepartamento() {
        return departamento;
    }

    public void setDepartamento(String departamento) {
        this.departamento = departamento;
    }

    public Employees getFuncionario() {
        return funcionario;
    }

    public void setFuncionario(Employees funcionario) {
        this.funcionario = funcionario;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }

    public String getAlmoxarifante() {
        return almoxarifante;
    }

    public void setAlmoxarifante(String almoxarifante) {
        this.almoxarifante = almoxarifante;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    // Método para criar a tabela no banco de dados
    public static String getCreateStatement() {
        return "CREATE TABLE saida_produtos ("
                + "rowid INTEGER PRIMARY KEY AUTOINCREMENT,"
                + "data DATE NOT NULL,"
                + "horario TIME NOT NULL,"
                + "produto_id INTEGER NOT NULL,"
                + "departamento VARCHAR(255) NOT NULL,"
                + "funcionario_id INTEGER NOT NULL,"
                + "quantidade INTEGER NOT NULL,"
                + "almoxarifante VARCHAR(255) NOT NULL,"
                + "descricao TEXT,"
                + "FOREIGN KEY (produto_id) REFERENCES produtos(id),"
                + "FOREIGN KEY (funcionario_id) REFERENCES employees(id)"
                + ")";
    }

    // Método para obter todas as saídas de produtos
    public static ArrayList<SaidaProdutos> getSaidaProdutos() throws Exception {
        ArrayList<SaidaProdutos> list = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement stmt = con.createStatement();
        String query = "SELECT sp.*, p.*, e.* FROM saida_produtos sp "
                + "LEFT JOIN produtos p ON sp.produto_id = p.id_produto "
                + "LEFT JOIN employees e ON sp.funcionario_id = e.rowid";
        ResultSet rs = stmt.executeQuery(query);

        while (rs.next()) {
            long rowId = rs.getLong("rowid");
            Date data = rs.getDate("data");
            Time horario = rs.getTime("horario");
            Produtos produto = new Produtos(rs.getLong("id_produto"), rs.getString("nome_produto"), rs.getInt("quantidade"), rs.getString("tipo_produto"), rs.getDate("data"), rs.getTime("horario"));
            String departamento = rs.getString("departamento");
            Employees funcionario = new Employees(rs.getLong("cd_employee"), rs.getString("nm_employee"), rs.getString("nm_type"));
            int quantidade = rs.getInt("quantidade");
            String almoxarifante = rs.getString("almoxarifante");
            String descricao = rs.getString("descricao");
            list.add(new SaidaProdutos(rowId, data, horario, produto, departamento, funcionario, quantidade, almoxarifante, descricao));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static int getTotalSaidas() throws Exception {
        Connection con = AppListener.getConnection();
        String sql = "SELECT COUNT(*) AS total, sp.*, p.*, e.* FROM saida_produtos sp "
                + "LEFT JOIN produtos p ON sp.produto_id = p.id_produto "
                + "LEFT JOIN employees e ON sp.funcionario_id = e.rowid";
        PreparedStatement stmt = con.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();
        int total = 0;
        if (rs.next()) {
            total = rs.getInt("total");
        }
        rs.close();
        stmt.close();
        con.close();
        return total;
    }
    
    public static ArrayList<SaidaProdutos> getSaidasPages(int page, int recordsPerPage) throws Exception {
        ArrayList<SaidaProdutos> list = new ArrayList<>();
        Connection con = AppListener.getConnection();

        int startIndex = (page - 1) * recordsPerPage;
        String sql = "SELECT sp.*, p.*, e.* FROM saida_produtos sp "
                + "LEFT JOIN produtos p ON sp.produto_id = p.id_produto "
                + "LEFT JOIN employees e ON sp.funcionario_id = e.rowid "
                + "ORDER BY data LIMIT ?,?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, startIndex);
        stmt.setInt(2, recordsPerPage);

        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            
            long rowId = rs.getLong("rowid");
            Date data = rs.getDate("data");
            Time horario = rs.getTime("horario");
            Produtos produto = new Produtos(rs.getLong("id_produto"), rs.getString("nome_produto"), rs.getInt("quantidade"), rs.getString("tipo_produto"), rs.getDate("data"), rs.getTime("horario"));
            String departamento = rs.getString("departamento");
            Employees funcionario = new Employees(rs.getLong("cd_employee"), rs.getString("nm_employee"), rs.getString("nm_type"));
            int quantidade = rs.getInt("quantidade");
            String almoxarifante = rs.getString("almoxarifante");
            String descricao = rs.getString("descricao");
            list.add(new SaidaProdutos(rowId, data, horario, produto, departamento, funcionario, quantidade, almoxarifante, descricao));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    

    // Método para inserir uma nova saída de produto
    public static void insertSaidaProduto(Date data, Time horario, Produtos produto, String departamento, Employees funcionario, int quantidade, String almoxarifante, String descricao) throws Exception {
        Connection con = AppListener.getConnection();
        String sql = "INSERT INTO saida_produtos (data, horario, produto_id, departamento, funcionario_id, quantidade, almoxarifante, descricao) VALUES (?,?,?,?,?,?,?,?)";

        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setDate(1, data);
        stmt.setTime(2, horario);
        stmt.setLong(3, produto.getId());
        stmt.setString(4, departamento);
        stmt.setLong(5, funcionario.getRowid());
        stmt.setInt(6, quantidade);
        stmt.setString(7, almoxarifante);
        stmt.setString(8, descricao);

        stmt.execute();
        stmt.close();
        con.close();
    }
    public static void updateSaidaProduto(long id, Date data, Time horario, Produtos produto, String departamento, Employees funcionario, int quantidade, String almoxarifante, String descricao) throws Exception {
    Connection con = AppListener.getConnection();
    String sql = "UPDATE saida_produtos SET data=?, horario=?, produto_id=?, departamento=?, funcionario_id=?, quantidade=?, almoxarifante=?, descricao=? WHERE rowid=?";
    PreparedStatement stmt = con.prepareStatement(sql);
    stmt.setDate(1, data);
    stmt.setTime(2,horario);
    stmt.setLong(3, produto.getId());
    stmt.setString(4, departamento);
    stmt.setLong(5, funcionario.getRowid());
    stmt.setInt(6, quantidade);
    stmt.setString(7, almoxarifante);
    stmt.setString(8, descricao);
    stmt.setLong(9, id);

    stmt.executeUpdate();
    stmt.close();
    con.close();
}

    // Método para excluir uma saída de produto
    public static void deleteSaidaProduto(long id) throws Exception {
        Connection con = AppListener.getConnection();
        String sql = "DELETE FROM saida_produtos WHERE rowid = ?";
        PreparedStatement stmt = con.prepareStatement(sql);

        stmt.setLong(1, id);
        stmt.execute();
        stmt.close();
        con.close();
    }
}
