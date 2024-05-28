package web;

import java.io.FileWriter;
import model.Produtos;
import web.AppListener;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;

public class CsvGenerator {

     public static ArrayList<Produtos> getProdutos(String tipoFiltro) throws Exception {
        ArrayList<Produtos> list = new ArrayList<>();
        Connection con = AppListener.getConnection();
        Statement stmt = con.createStatement();
        String query = "SELECT * FROM produtos";
        if (tipoFiltro != null && !tipoFiltro.isEmpty()) {
            query += " WHERE tipo_produto = '" + tipoFiltro + "'";
        }
        ResultSet rs = stmt.executeQuery(query);
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

    public static void generateCsvFile(String filePath, String tipoFiltro) throws Exception {
        ArrayList<Produtos> list = getProdutos(tipoFiltro);

        try (FileWriter csvWriter = new FileWriter(filePath)) {
            // Cabeçalho do CSV sem data e horário
            csvWriter.append("ID Produto;Nome Produto;Quantidade;Tipo Produto\n");

            for (Produtos p : list) {
                csvWriter.append(p.getId() + ";");
                csvWriter.append(p.getNome() + ";");
                csvWriter.append(p.getQuantidade() + ";");
                csvWriter.append(p.getTipo() + "\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
