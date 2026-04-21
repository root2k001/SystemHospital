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
	public boolean  eliminarPaciente(String dni, int usuarioId)
	{		
		
		boolean respuesta ;			
		PreparedStatement ps;
		
		try(Connection con = SqlServerConexion.conectar()
				
				) {
			
		

		    String sql = "DELETE FROM Pacientes WHERE dni = ? AND usuario_id = ?";

			
ps = con.prepareStatement(sql);
			ps.setString(1, dni);    
			ps.setInt(2, usuarioId);

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
	    	
		    String query = "INSERT INTO Pacientes \r\n"
		    		+ "    (Parentesco, DNI, Genero, ApellidoPat, ApellidoMat, Nombre, \r\n"
		    		+ "     FechaNacimiento, Correo, Telefono, Direccion, Motivo_consulta, \r\n"
		    		+ "     usuario_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

			ps = con.prepareStatement(query);
			
		    
		    ps.setString(1, paciente.getParentesco());    
		    ps.setString(2, paciente.getDni());    
		    ps.setString(3, paciente.getSexo());     
		    ps.setString(4, paciente.getApellidoPat()); 
		    ps.setString(5, paciente.getApellidoMat());
		    ps.setString(6, paciente.getNombre()); 
		    
		    ps.setString(7, paciente.getFecha()); 
		    ps.setString(8, paciente.getCorreo()); 
		    ps.setString(9, paciente.getTelefono()); 
		    ps.setString(10, paciente.getDireccion()); 
		    ps.setString(11, paciente.getConsulta()); 
		    ps.setInt(12, paciente.getusuarioId()); 
		    
		    

		    // Ejecución de la consulta SQL
		 int filasAfectadas=    ps.executeUpdate();
			
		 System.out.println(">>> INSERT: Filas insertadas: " + filasAfectadas);
		 System.out.println(">>> Paciente: " + paciente.getNombre() + " - " + paciente.getDni() + " - " + paciente.getCorreo());			
		 
		 
		 
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();

		}
}
	 
	

	 
	 public static List<Map<String, Object>>obtenerTodosLosPacientes(int idUsuario) throws SQLException {


		 //declaramos una lista en este ambito de funcion 
	        List<Map<String, Object>> listaPacientes = new ArrayList<>();

	       
		


	        String sql = "SELECT ID, Nombre, FechaNacimiento, Genero, Telefono, Direccion, Motivo_consulta, Parentesco, DNI, ApellidoPat, ApellidoMat, Correo FROM Pacientes WHERE usuario_id = ?";
	            
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
	   	            	paciente.put("fechaNac",rs.getString("FechaNacimiento"));
	   	            	paciente.put("genero",rs.getString("Genero"));
	   	            	paciente.put("telefono",rs.getString("Telefono"));
	   	            	paciente.put("direccion",rs.getString("Direccion"));
	   	            	paciente.put("motivo",rs.getString("Motivo_consulta"));
	   	            	paciente.put("parentesco",rs.getString("Parentesco"));
	   	            	paciente.put("DNI",rs.getString("DNI"));
	   	            	paciente.put("apellidoPat",rs.getString("ApellidoPat"));
	   	            	paciente.put("apellidoMat",rs.getString("ApellidoMat"));
	   	            	paciente.put("correo",rs.getString("Correo"));

	   	            	//por cada iteracion del bucle se agrega un paciente a la lista 
						
	   	             listaPacientes.add(paciente);


	   	            	
	   	            }
	        		
	        		
				} 
	         
	            
	        }
		 // retorna la lista completa  de pacientes registrados 
	            return listaPacientes;
	           
	    }
	 
public boolean editarPaciente(Paciente paciente, int usuarioId) throws SQLException {
		 
		 System.out.println(">>> DAO: editando paciente con DNI: " + paciente.getDni() + " usuarioId: " + usuarioId);
		 
		 PreparedStatement ps;
	    	String query = "UPDATE Pacientes SET Parentesco = ?, Correo = ?, FechaNacimiento = ?, Telefono = ?, Direccion = ? WHERE DNI = ? AND usuario_id = ?";

		    try(Connection connection = SqlServerConexion.conectar()) {
		    	
		    	ps = connection.prepareStatement(query);
		    	ps.setString(1, paciente.getParentesco());
		    	ps.setString(2, paciente.getCorreo());
		    	ps.setString(3, paciente.getFecha());
		    	ps.setString(4, paciente.getTelefono());
		    	ps.setString(5, paciente.getDireccion());
		    	ps.setString(6, paciente.getDni());
		    	ps.setInt(7, usuarioId);
		    	
		    	System.out.println(">>> SQL: " + query);
		    	
		    	int filasAfectadas = ps.executeUpdate();
		    	System.out.println(">>> Filas afectadas: " + filasAfectadas);
		    	return filasAfectadas > 0;
		    	
		    } catch (SQLException e) {
		    	System.out.println(">>> ERROR SQL: " + e.getMessage());
		    	throw e;
		    }
	 }
	 
public boolean existePaciente(String dni, int usuarioId) {
	    String sql = "SELECT COUNT(*) FROM Pacientes WHERE DNI=? AND usuario_id=?";
	    
	    try (Connection con = SqlServerConexion.conectar();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        
	        ps.setString(1, dni);
	        ps.setInt(2, usuarioId);
	    
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
