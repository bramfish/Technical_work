import java.sql.*;

public class DatabaseConnection {
    private Connection connection;
    private String url = "jdbc:postgresql://localhost/DataScience";
    private String user = "username";
    private String password = "password";

    public void connectToDatabase() throws SQLException {
        connection = DriverManager.getConnection(url, user, password);
        System.out.println("Connected to the PostgreSQL server successfully.");
    }

    public ResultSet readTable() throws SQLException {
        Statement statement = connection.createStatement();
        String query = "SELECT \"Algorithm Name\", \"Algorithm File Locator\" FROM Algorithm LIMIT 1000";
        ResultSet resultSet = statement.executeQuery(query);
        return resultSet;
    }

    public String searchAlgorithm(String search) throws SQLException {
        ResultSet resultSet = readTable();
        while (resultSet.next()) {
            String algorithmName = resultSet.getString("Algorithm Name");
            if (algorithmName.contains(search)) {
                String algorithmFileLocator = resultSet.getString("Algorithm File Locator");
                return algorithmFileLocator;
            }
        }
        return null;
    }
}




