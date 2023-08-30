import java.sql.*;

public class DatabaseConnection {
    private Connection conn;

    // Method to connect to the PostGres database "DataScience"
    public void connectToDatabase() {
        try {
            String url = "jdbc:postgresql://localhost/DataScience";
            String user = "username";
            String password = "password";
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connected to the PostgreSQL server successfully.");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    // Method to read the table "Algorithm" and fetch the first 1000 rows and return Algorithm Name, Algorithm File Locator fields.
    public ResultSet readTable() {
        ResultSet rs = null;
        try {
            Statement stmt = conn.createStatement();
            String query = "SELECT \"Algorithm Name\", \"Algorithm File Locator\" FROM Algorithm LIMIT 1000";
            rs = stmt.executeQuery(query);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return rs;
    }

    // Method to search for the string "Sequencetial Patterns" in Algorithm Name field and return the Algorithm File Locator filed data.
    public String searchAlgorithmName(ResultSet rs) {
        String fileLocator = null;
        try {
            while (rs.next()) {
                String algorithmName = rs.getString("Algorithm Name");
                if (algorithmName != null && algorithmName.contains("Sequential Patterns")) {
                    fileLocator = rs.getString("Algorithm File Locator");
                    break;
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        logger.info("File locator for Sequential Patterns is: " + fileLocator);
        return fileLocator;
    }
}
