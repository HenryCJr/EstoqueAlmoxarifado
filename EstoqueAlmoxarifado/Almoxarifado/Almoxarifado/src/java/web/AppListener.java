package web;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.Date;
import model.Users;
import model.Employees;
import model.Produtos;
import model.SaidaProdutos;

@WebListener
public class AppListener implements ServletContextListener {

    public static final String CLASS_NAME = "org.sqlite.JDBC";
    public static final String URL = "jdbc:sqlite:almoxarifado.db";
    public static String initializeLog = "";
    public static Exception exception = null;

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContextListener.super.contextDestroyed(sce);
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContextListener.super.contextInitialized(sce);
        try {
            Connection c = AppListener.getConnection();
            Statement s = c.createStatement();
            s.execute("PRAGMA encoding = 'UTF-8'");
            
//            s.execute(Employees.getCreateStatement());
//          s.execute("DELETE FROM subjects");
//          s.execute("DROP TABLE IF EXISTS users");
//          s.execute("DROP TABLE IF EXISTS employees");
//          s.execute("DROP TABLE saida_produtos");
//s.execute(Produtos.getCreateStatement());
            

            initializeLog += new Date() + ": Initializing database creation;";
            s.execute(Users.getCreateStatement());
            if (Users.getUsersAll().isEmpty()) {
                Users.insertUser("admin", "Administrador", "ADMIN", "1234");
            }    

            s.execute(Employees.getCreateStatement());
                                                                                    
            s.execute(Produtos.getCreateStatement());
            
            s.execute(SaidaProdutos.getCreateStatement());

        } catch (Exception ex) {
            
        }
    }

    public static String getMd5Hash(String text) throws NoSuchAlgorithmException {
        MessageDigest m = MessageDigest.getInstance("MD5");
        m.update(text.getBytes(), 0, text.length());
        return new BigInteger(1, m.digest()).toString();
    }

    public static Connection getConnection() throws Exception {
        Class.forName(CLASS_NAME);
        return DriverManager.getConnection(URL);
    }

}
