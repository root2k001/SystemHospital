package models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import configuraciones.SqlServerConexion;

public class PacienteDao {

// PENDIENTE IMPLEMENTAR
	public boolean  eliminarPaciente(String dni)
	{		
		
		boolean respuesta ;			
		PreparedStatement ps;
		
		try(Connection con = SqlServerConexion.conectar()
				
				) {
			
		

		    String sql = "DELETE FROM Pacientes WHERE dni = ?";

			
			ps = con.prepareStatement(sql);
				ps.setString(1, dni);    

		int filasAfectadas=	ps.executeUpdate();
			
			
		//retorna true 
			return  filasAfectadas>0;

			
		}
		catch(Exception e)
		{
			
			e.printStackTrace();
			return false ;
		}}	
public void agregarPaciente(Paciente paciente) {
		

	    	
	    
	    PreparedStatement ps;
	    
	    try(Connection con = SqlServerConexion.conectar()) {
	    	
		    String query = "INSERT INTO Pacientes(Nombre, Fecha, Sexo, Telefono, Direccion, Consulta, usuario_id, parentesco , dni , apellidoPat , apellidoMat , correo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

			ps = con.prepareStatement(query);
			
		    
		    ps.setString(1, paciente.getNombre());    
		    ps.setString(2, paciente.getFecha());    
		    ps.setString(3, paciente.getSexo());     
		    ps.setString(4, paciente.getTelefono()); 
		    ps.setString(5, paciente.getDireccion());
		    ps.setString(6, paciente.getConsulta()); 
		    ps.setInt(7, paciente.getusuarioId()); 
		    ps.setString(8, paciente.getParentesco()); 
		    ps.setString(9, paciente.getDni()); 
		    ps.setString(10, paciente.getApellidoPat()); 
		    ps.setString(11, paciente.getApellidoMat()); 
		    
		    ps.setString(12, paciente.getCorreo());

		    // Ejecución de la consulta SQL
		 int filasAfectadas=    ps.executeUpdate();
			
		 System.out.println("Filas insertadas: " + filasAfectadas);			
		 
		 
		 
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();

		}
}
	 
	

	 
	 public static List<Map<String, Object>>obtenerTodosLosPacientes(int idUsuario) throws SQLException {


		 //declaramos una lista en este ambito de funcion 
	        List<Map<String, Object>> listaPacientes = new ArrayList<>();

	       
		

	        String sql = "SELECT ID, Nombre, Sexo, Telefono,DNI, Consulta FROM Pacientes WHERE usuario_id = ?";
	            
	        try (
	        		Connection con = SqlServerConexion.conectar();
	        		PreparedStatement pstmt = con.prepareStatement(sql)		){          		
	        	pstmt.setInt(1, idUsuario);
	        	//retorna un resultset en formato de tabla con el executequery 
	            try (ResultSet rs = pstmt.executeQuery()) { 
	        		   while (rs.next()) {
	     	              
	   	            	Map<String, Object> paciente= new HashMap<>();
	   	            	paciente.put("id",rs.getString("ID"));
	   	            	paciente.put("nombre",rs.getString("Nombre"));
	   	            	paciente.put("Sexo",rs.getString("Sexo"));
	   	            	paciente.put("Telefono",rs.getString("Telefono"));
	   	            	paciente.put("Consulta",rs.getString("Consulta"));
	   	            	paciente.put("DNI",rs.getString("DNI"));

	   	            	
	   	            	//por cada iteracion del bucle se agrega un paciente a la lista 
						
	   	             listaPacientes.add(paciente);

	   	            	
	   	            }
	        		
	        		
				} 
	         
	            
	        }
		 // retorna la lista completa  de pacientes registrados 
	            return listaPacientes;
	           
	    }
	 
public boolean editarPaciente(Paciente paciente) throws SQLException {
		 
		 
		 PreparedStatement ps;
	    	String query = "UPDATE Pacientes SET parentesco = ?, correo = ?, fecha = ?, telefono = ?, direccion = ? WHERE dni = ?";

		    try(Connection connection = SqlServerConexion.conectar()) {
		    	
		    	ps = connection.prepareStatement(query);
		    	ps.setString(1, paciente.getParentesco());
		    	ps.setString(2, paciente.getCorreo());
		    	ps.setString(3, paciente.getFecha());
		    	ps.setString(4, paciente.getTelefono());
		    	ps.setString(5, paciente.getDireccion());
		    	ps.setString(6, paciente.getDni());
		    	
		    	int filasAfectadas = ps.executeUpdate();
		    	return filasAfectadas > 0;
		    	
		    }
	 }
	 
	 public boolean existePaciente(String dni) {
		    String sql = "SELECT COUNT(*) FROM Pacientes WHERE DNI=?";
		    
		    try (Connection con = SqlServerConexion.conectar();
		         PreparedStatement ps = con.prepareStatement(sql)) {
		        
		        ps.setString(1, dni);
		    
		        ResultSet rs = ps.executeQuery();
		        if (rs.next()) {
		            return rs.getInt(1) > 0; // true si ya existe
		        }
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		    return false;
		}

		
	
}
