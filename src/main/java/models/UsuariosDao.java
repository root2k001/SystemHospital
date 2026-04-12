package models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;

import configuraciones.SqlServerConexion;

public class UsuariosDao {
	
	
	

	public Usuario registrarUsuario(Usuario usuario) {
	    String sql = "INSERT INTO Usuarios(nombre, apellido, correo, contrasena, DNI, FechaNacimiento, genero) VALUES (?, ?, ?, ?, ?, ?, ?)";
	    // Validacion de usuario por base de datos (Optimizado)
	    if (existeUsuario(usuario.getDni(), usuario.getCorreo())) {
	    	System.out.println("usuario o correo ya registrado ");
	    	return null;
	    }
	  
	    
	    try (Connection con = SqlServerConexion.conectar();
	         PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

	       
	    	
	    	ps.setString(1, usuario.getNombre());
	        ps.setString(2, usuario.getApellido());
	        ps.setString(3, usuario.getCorreo());
	        ps.setString(4, usuario.getContrasena());
	        ps.setString(5, usuario.getDni());
	        ps.setString(6, usuario.getFechNac());
	        ps.setString(7, usuario.getSexo());

	        
	        
	        
	        int filasAfectadas = ps.executeUpdate();
	        System.out.println("Filas afectadas: " + filasAfectadas);

	        
	        
	        if (filasAfectadas > 0) {
	        	
	            ResultSet rs = ps.getGeneratedKeys();
	            
	            
	            

	            if (rs.next()) {
	            
	            	
	            	
	                int idGenerado = rs.getInt(1);//recupera el valor de la columna designada
	                
	             
	            	
	                
	                usuario.setId(idGenerado);
	               
	                System.out.println("Usuario registrado con ID: " + idGenerado);
	            }
	            return usuario; 
	        } 
	    } catch (Exception e) {
	        e.printStackTrace();
	        
	    }

	    return null;
	}

	
	
	
	public Usuario autenticar(String correo, String contrasena) {
		String QUERY = "SELECT ID, nombre, apellido, correo, DNI, FechaNacimiento, genero, Altura, peso ,Tipo_de_Sangre FROM Usuarios WHERE correo=? AND contrasena=?";
	    
	    try (Connection con = SqlServerConexion.conectar();
	         PreparedStatement ps = con.prepareStatement(QUERY)) {

	        ps.setString(1, correo);
	        ps.setString(2, contrasena);
	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {
	            Usuario u = new Usuario();
             

	            u.setId(rs.getInt("ID"));
	            u.setNombre(rs.getString("nombre"));
	            u.setApellido(rs.getString("apellido"));
	            u.setCorreo(rs.getString("correo"));
	            u.setDni(rs.getString("DNI"));
	            u.setFechNac(rs.getString("FechaNacimiento"));	            
	            u.setSexo(rs.getString("genero"));
	            u.setAltura(String.valueOf( rs.getDouble("Altura")));
	            u.setPeso(String.valueOf( rs.getDouble("peso")));
	            u.setTipoDeSangre("Tipo_de_Sangre");
	            return u;
	        }

	    } catch (SQLException e) {
	        System.out.println("Error autenticando usuario: " + e.getMessage());
	        // Aquí podrías registrar en logs, o hasta guardar en una tabla de errores si es necesario
	    }

	    return null;
	}
	
	// METODO QUE DEVUELVE LA TABLA COMPLETA A LA VISTA 
	
	public List<Usuario> tablaCompleta() {
		String sql= "SELECT*FROM Usuarios";
		List<Usuario> listaUsuarios = new ArrayList<>();

	    try (Connection con = SqlServerConexion.conectar();
	         PreparedStatement ps = con.prepareStatement(sql);
	    		ResultSet rs = ps.executeQuery();){

	    	while(rs.next()) {
	    		
	    		Usuario u= new Usuario();
	    		u.setNombre(rs.getString("nombre"));
	    		u.setApellido(rs.getString("apellido"));
	    		u.setCorreo(rs.getString("correo"));
	    		u.setContrasena(rs.getString("contrasena"));
	    		u.setDni(rs.getString("DNI"));
	    		u.setFechNac(rs.getString("FechaNacimiento"));
	    		u.setSexo(rs.getString("genero"));
	    		
	    		listaUsuarios.add(u);
	    	
	    	}
	    	
	    	
	    	
	    	
	    } catch (Exception e) {
			// TODO: handle exception
		}

    	return listaUsuarios;

		
	}
	
	public boolean existeUsuario(String dni, String correo) {
	    String sql = "SELECT COUNT(*) FROM Usuarios WHERE DNI = ? OR Correo = ?";
	    try (Connection con = SqlServerConexion.conectar();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        ps.setString(1, dni);
	        ps.setString(2, correo);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            return rs.getInt(1) > 0;
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}

	
	
	 public static boolean actualizarPerfil(int idUsuario, String altura, String peso, String tipoSangre, String Correo) {
	        String SQL_UPDATE = "UPDATE Usuarios SET Altura = ?, peso = ?, Tipo_de_sangre = ?, correo=? WHERE ID = ?";

	        try (Connection con = SqlServerConexion.conectar();
	             PreparedStatement ps = con.prepareStatement(SQL_UPDATE)) {

	            ps.setString(1, altura);
	            ps.setString(2, peso);
	            ps.setString(3, tipoSangre);
	            ps.setString(4, Correo);
	            ps.setInt(5, idUsuario);

	            

	            int filasAfectadas = ps.executeUpdate();

	            return filasAfectadas > 0; // true si se actualizó correctamente

	        } catch (SQLException e) {
	            System.out.println("Error actualizando perfil: " + e.getMessage());
	            return false;
	        }
	    }
	
	 
	 //METODO PARA VALIDAR CORREOS IGUALES DEL USUARIO DIFIERE A EXISTE USUARIO QUE ES PARA REGISTROS 
	 public static boolean existeOtroUsuarioConCorreo(int idUsuario, String correo) {
	        String sql = "SELECT COUNT(*) FROM Usuarios WHERE Correo = ? AND ID != ?";
	        try (Connection con = SqlServerConexion.conectar();
	             PreparedStatement ps = con.prepareStatement(sql)) {
	            ps.setString(1, correo);
	            ps.setInt(2, idUsuario);
	            ResultSet rs = ps.executeQuery();
	            if (rs.next()) {
	                return rs.getInt(1) > 0;
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return false;
	    }
	
	}
