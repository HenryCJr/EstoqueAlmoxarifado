package model;

import java.sql.*;
import java.util.ArrayList;
import web.AppListener;

public class Produtos {
    private long id;
    private String nome;
    private int quantidade;
    private String tipo;
    private Date data;
    private Time horario;
    
    public static String getCreateStatement() {
        return "CREATE TABLE produtos("
                + "id_produto INTEGER PRIMARY KEY,"
                + "nome_produto VARCHAR(50) NOT NULL,"
                + "quantidade INTEGER NOT NULL,"
                + "tipo_produto VARCHAR(50) NOT NULL,"
                + "data DATE NOT NULL,"
                + "horario TIME NOT NULL"
                + ")";
    }
    
    public static ArrayList<Produtos> getProdutos() throws Exception {
        ArrayList<Produtos> list = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM produtos");
        while (rs.next()) {
            long id = rs.getLong("id_produto");
            String nome = rs.getString("nome_produto");
            int quantidade = rs.getInt("quantidade");
            String tipo = rs.getString("tipo_produto");
            Date data = rs.getDate("data");
            Time horario = rs.getTime("horario");
            list.add(new Produtos(id, nome, quantidade, tipo, data, horario));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    public static int getTotalProdutos() throws Exception {
        Connection con = AppListener.getConnection();
        String sql = "SELECT COUNT(*) AS total FROM produtos";
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
    
    public static ArrayList<Produtos> getProdutosPages(int page, int recordsPerPage) throws Exception {
        ArrayList<Produtos> list = new ArrayList<>();
        Connection con = AppListener.getConnection();

        int startIndex = (page - 1) * recordsPerPage;

        String sql = "SELECT * FROM produtos ORDER BY nome_produto LIMIT ?,?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setInt(1, startIndex);
        stmt.setInt(2, recordsPerPage);

        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            
            long id = rs.getLong("id_produto");
            String nome = rs.getString("nome_produto");
            int quantidade = rs.getInt("quantidade");
            String tipo = rs.getString("tipo_produto");
            Date data = rs.getDate("data");
            Time horario = rs.getTime("horario");
            list.add(new Produtos(id, nome, quantidade, tipo, data, horario));
        }
        rs.close();
        stmt.close();
        con.close();
        return list;
    }
    
    
    public static Produtos getProduto(long id) throws Exception {
        Produtos produto = null;
        Connection con = AppListener.getConnection();
        String sql = "SELECT * FROM produtos WHERE id_produto = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setLong(1, id);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            String nome = rs.getString("nome_produto");
            int quantidade = rs.getInt("quantidade");
            String tipo = rs.getString("tipo_produto");
            Date data = rs.getDate("data");
            Time horario = rs.getTime("horario");
            produto = new Produtos(id, nome, quantidade, tipo, data, horario);
        }
        rs.close();
        stmt.close();
        con.close();
        return produto;
    }
    
    public static void insertProduto(String nome, int quantidade, String tipo, Date data, Time horario) throws Exception {
        Connection con = AppListener.getConnection();
        String sql = "INSERT INTO produtos(nome_produto, quantidade, tipo_produto, data, horario) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, nome);
        stmt.setInt(2, quantidade);
        stmt.setString(3, tipo);
        stmt.setDate(4, data);
        stmt.setTime(5, horario);
        stmt.executeUpdate();
        stmt.close();
        con.close();
    }
    
    public static void updateProduto(long id, String nome, int quantidade, String tipo, Date data, Time horario) throws Exception {
        Connection con = AppListener.getConnection();
        String sql = "UPDATE produtos SET nome_produto=?, quantidade=?, tipo_produto=?, data=?, horario=? WHERE id_produto=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, nome);
        stmt.setInt(2, quantidade);
        stmt.setString(3, tipo);
        stmt.setDate(4, data);
        stmt.setTime(5, horario);
        stmt.setLong(6, id);
        stmt.executeUpdate();
        stmt.close();
        con.close();
    }
    
    public static void deleteProduto(long id) throws Exception {
        Connection con = AppListener.getConnection();
        String sql = "DELETE FROM produtos WHERE id_produto=?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setLong(1, id);
        stmt.execute();
        stmt.close();
        con.close();
    }
    
    public Produtos(long id, String nome, int quantidade, String tipo, Date data, Time horario) {
        this.id = id;
        this.nome = nome;
        this.quantidade = quantidade;
        this.tipo = tipo;
        this.data = data;
        this.horario = horario;
    }
    
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
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
}
