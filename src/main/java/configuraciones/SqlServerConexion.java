package configuraciones;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class SqlServerConexion {
	
	public static void main(String[] args ) {
		
		Connection con = conectar();
		
		if(con!=null) {
			System.out.println("conexion exitosa");
		}else {System.out.println("No conectado ");
		}
		
		
	}
	
		
	public static Connection conectar() {
	    Connection con = null;

	    String urlConexion ="jdbc:sqlserver://localhost:1433;"
	            + "databaseName=proyecto;"
	            + "encrypt=true;"
	            + "trustServerCertificate=true;";

	    try {
	        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

	        con = DriverManager.getConnection(urlConexion, "sa", "123456");
			
			
			
		}catch (ClassNotFoundException e) {
			
			System.out.println("mensaje de eror"+ e.getMessage());
		
	} catch (SQLException e) {

			System.out.println("mensaje de error "+ e.getMessage());
			
		}
		
		return con;
	}

}
