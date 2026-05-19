package the_street.sahayog_sathi_donor.utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/sahayog_sathi";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "!@#SurangaRai28**";

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL,DB_USER,DB_PASSWORD);
    }
}
