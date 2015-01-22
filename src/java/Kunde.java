
import java.sql.*;

public class Kunde {

    String url = "jdbc:hsqldb:file:F:\\netbeans\\hsqlTestDB";
    String user = "hsqldb";
    String password = "hsqldb";

    Connection connection = null;
    PreparedStatement selectKunden = null;
    ResultSet resultSet = null;

    public Kunde() {

        try {

            connection = DriverManager.getConnection(url, user, password);

            selectKunden = connection
                    .prepareStatement("SELECT * FROM Lieferant");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ResultSet getKunden(String suchWert) {

        try {
            selectKunden = connection.prepareStatement(
                    "SELECT * FROM Lieferant WHERE lf_ID LIKE '%" + suchWert + "%' OR Firma LIKE '%" + suchWert + "%'");

            resultSet = selectKunden.executeQuery();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return resultSet;
    }

    public static void main(String[] args) {
        Kunde kunde = new Kunde();
        ResultSet rs = kunde.getKunden("huhu");

        
    }

}
