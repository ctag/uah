/*
 * Program written by Jean-Luc Burhop, Jared McArthur, and Christopher Bero
 * for Dr. Rochowiak's CS330 class in place of a final exam.
 * 
 * We aren't using a database as we decided we didn't need it for such a small example of the project
 * but we have a bit of code to support using a sqlLight database
 */
package Cartogurationatron;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StateDB {
    //This will be used to interact with the DB
    public static String StoryChainElements = "CREATE TABLE IF NOT EXISTS `Maping_SS` (\n" +
                                            "	`Genotype`	TEXT NOT NULL UNIQUE," +
                                            "	`Phenotype`	TEXT NOT NULL," +
                                            "	`StoryBlockID`	TEXT NOT NULL," +
                                            "	PRIMARY KEY(Genotype)\n" +
                                            ");"; 
    public static String StoryChainModifiers = "CREATE TABLE IF NOT EXISTS `Modifiers_SS` (\n" +
                                               " `Trait`	TEXT NOT NULL UNIQUE,\n" +
                                               " `Value`	TEXT NOT NULL,\n" +
                                               " `StoryBlockID`	TEXT NOT NULL,\n" +
                                               " `Description`	TEXT NOT NULL\n" +
                                               ");"; 
    public static void createDB()
    {
        Connection c = null;
        try {
          Class.forName("org.sqlite.JDBC");
          c = DriverManager.getConnection("jdbc:sqlite:StroryData.db");
        } catch ( Exception e ) {
          System.err.println( e.getClass().getName() + ": " + e.getMessage() );
          System.exit(0);
        }
        System.out.println("Opened database successfully");
        createTables(StoryChainElements);
        createTables(StoryChainModifiers);
        
    }/*
    public static ArrayList<String> pullTopGenoTypes(int Number, boolean onlyGeno)
    {
        
        ArrayList<String> results = new ArrayList<String>();
        try {
            Connection c = null;
            Statement stmt = null;
            Class.forName("org.sqlite.JDBC");
            c = DriverManager.getConnection("jdbc:sqlite:StroryData.db");
            c.setAutoCommit(false);
            System.out.println("Opened database successfully");

            stmt = c.createStatement();
            String sql = "SELECT * FROM Maping_SS LIMIT " + Number; 
            ResultSet rs = stmt.executeQuery(sql);
            while ( rs.next() ) 
            {
                
                String  result = rs.getString("Genotype");
                result += "" + rs.getString("StoryBlockID");
                if(!onlyGeno)
                {
                    result += "!@#$%" + rs.getString("PhenoType");
                    
                }
                results.add(result);
            }

            stmt.close();
            c.commit();
            c.close();
            return results;
        } catch ( Exception e ) {
          System.err.println( e.getClass().getName() + ": " + e.getMessage() );
          return results;
        }
    }*/
    public static ArrayList<String> pullTopGenoTypes(int Number, boolean onlyGeno)
    {
        
        ArrayList<String> results = new ArrayList<String>();
        try {
            Connection c = null;
            Statement stmt = null;
            Class.forName("org.sqlite.JDBC");
            c = DriverManager.getConnection("jdbc:sqlite:StroryData.db");
            c.setAutoCommit(false);
            System.out.println("Opened database successfully");

            stmt = c.createStatement();
            String sql = "SELECT * FROM Maping_SS;";// LIMIT " + Number + ";"; 
            ResultSet rs = stmt.executeQuery(sql);
            while ( rs.next() ) 
            {
                
                String  result = rs.getString("Genotype");
                result += "" + rs.getString("StoryBlockID");
                if(!onlyGeno)
                {
                    result += "!@#$%" + rs.getString("Phenotype");
                    
                }
                results.add(result);
            }

            stmt.close();
            c.commit();
            c.close();
            return results;
        } catch ( Exception e ) {
          System.err.println( e.getClass().getName() + " TopGeno: " + e.getMessage() );
          return results;
        }
    }
    public static String getPheno(String geno, String blockID) 
    {
        Connection c = null;
        Statement stmt = null;
        String  result = "";
        try {
            Class.forName("org.sqlite.JDBC");
            c = DriverManager.getConnection("jdbc:sqlite:StroryData.db");
            c.setAutoCommit(false);
            System.out.println("Opened database successfully");

            stmt = c.createStatement();
            String sql = "SELECT Phenotype FROM Maping_SS "
                        + "WHERE Genotype== '" + geno + "'"
                        + "AND StoryBlockID =='" + blockID + "';";
            ResultSet rs = stmt.executeQuery(sql);
            while ( rs.next() ) 
            {
                
                result = rs.getString("Phenotype");
            }

            stmt.close();
            c.commit();
            c.close();
            return result;

        } catch ( Exception e ) {
          System.err.println( e.getClass().getName() + ": " + e.getMessage() );
          return (e.getClass().getName() + ": " + e.getMessage());
        }

    }
    
    public static String instert_Modifier(String trait, String value, String blockID, String desc)
    {
        Connection c = null;
        Statement stmt = null;
        try {
            Class.forName("org.sqlite.JDBC");
            c = DriverManager.getConnection("jdbc:sqlite:StroryData.db");
            c.setAutoCommit(false);
            System.out.println("Opened database successfully");

            stmt = c.createStatement();
            String sql = "INSERT INTO Modifiers_SS (Trait, Value, StoryBlockID, Description) " +
                         "VALUES ('" + trait + "','" + value + "','" + blockID+ "','" + desc + "');"; 
            stmt.executeUpdate(sql);
            

            stmt.close();
            c.commit();
            c.close();
        } catch ( Exception e ) {
          System.err.println( e.getClass().getName() + ": " + e.getMessage() );
          return (e.getClass().getName() + ": " + e.getMessage());
        }
        System.out.println("Records created successfully");
        return ("Records created successfully");
    }
    private static void createTables(String sql)
    {
        Connection c = null;
        Statement stmt = null;
        try {
          Class.forName("org.sqlite.JDBC");
          c = DriverManager.getConnection("jdbc:sqlite:StroryData.db");
          System.out.println("Opened database successfully");

          stmt = c.createStatement();
          
          stmt.executeUpdate(sql);
          stmt.close();
          c.close();
        } catch ( Exception e ) {
          System.err.println( e.getClass().getName() + ": " + e.getMessage() );
          System.exit(0);
        }
        System.out.println("Table created successfully");
    }
}
