package controladores;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Usuario;
import models.UsuariosDao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import configuraciones.SqlServerConexion;

/**
 * Servlet implementation class Autentificacion
 */
@WebServlet("/Autentificacion")
public class Autentificacion extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Autentificacion() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	   
		//objeto de tipo jsonObject
		JsonObject datosJsonRecuperados = null;

        
        try {

			//parseo del json obtenido con la lectura si en el cuerpo de la solicitud http no es json lanza una excepcion 
			// getAsJsonObject() => excepcion is null
        	  datosJsonRecuperados = JsonParser.parseReader(request.getReader()).getAsJsonObject();
              String accion = datosJsonRecuperados.get("accion").getAsString();
        	

        	
        	
        	
              System.out.println(" JSON recibido  del js : " + datosJsonRecuperados);

              
              switch(accion) {
        	case "login":
                autentificacionLog(datosJsonRecuperados,request, response);
                	break ;
                	
        	case "registrar":
                registrarCliente(datosJsonRecuperados, request, response);    
                break;
        	
        	}
        	
        	
        }catch(Exception e) {
        	
            e.printStackTrace();

        }
        
			
	
		
	}
    private void registrarCliente(JsonObject datosJson, HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        UsuariosDao usersDao = new UsuariosDao();
        JsonObject jsonResponse = new JsonObject();
        Gson gson = new Gson();

        String dni = null;
        String sexo = null;
        
        String fechNac= null;
        String correo = null;
        String  nombre= null;
        String apellido = null;
        String contrasena= null;
     
		    try {

				// recuperamos  los datos de  del objeto de tipo  jsonObject(datosjson)
		       dni = datosJson.get("dni").getAsString();
		    	correo = datosJson.get("correo").getAsString();
		    	sexo= datosJson.get("genero").getAsString();

		        nombre = datosJson.get("nombre").getAsString();
		        apellido = datosJson.get("apellido").getAsString(); 
		        contrasena = datosJson.get("contrasena").getAsString();
		        fechNac= datosJson.get("fechaNac").getAsString();

		    } catch (Exception e) {
				// si no recupera datos  lanzamos una exepcion  e imprimimos en consola
		        System.out.println("Error al leer el JSON: " + e.getMessage());


				//objeto jsonResponse que es un objeto de tipo JsonObject que almacena la respuesta del servlet 
				
		        jsonResponse.addProperty("estado", false);  //este objeto jsonResponse  se le agrega propiedades   y si falla es false  
		        jsonResponse.addProperty("mensaje", "Error al procesar los datos JSON.");  // se le agrega un mensaje como propiedad a manera de respuesta al cliente 
		        response.setContentType("application/json");// deifinimos el contenido json 
		        response.setCharacterEncoding("UTF-8");
		        response.getWriter().write(jsonResponse.toString());  
		        return;
		    }
/*
si la validacion es "ok "
instanciamos un objeto de tipo Usuairo  con los datos obtenidos del 
request JsonObject
*/
		    Usuario usuarioReg = new Usuario(dni,nombre, apellido, correo,  fechNac, sexo, contrasena);
		    	try {
		    		// hacemos un try al registro 
		    	 if(usersDao.registrarUsuario(usuarioReg)!= null)  {
		    		 jsonResponse.addProperty("estado", true); // agregamos propuedades is es true 
				        jsonResponse.addProperty("mensaje", "Usuario registrado correctamente.");

		    		 
		    	 }   else {
		    		 
		    		 jsonResponse.addProperty("estado", false);
				        jsonResponse.addProperty("mensaje", "el usuario ya existe  " );
		    		 
		    	 }
		    		
		    	
		    			
		        
		    } catch (Exception e) {

				// la excepcion se lanza si el registro te lanza un false 
		        e.printStackTrace();
		        jsonResponse.addProperty("estado", false);
		        jsonResponse.addProperty("mensaje", "Error al registrar usuario: " + e.getMessage());
		    }
// se valida el try y responde el servlet  
		    response.setContentType("application/json");
		    response.setCharacterEncoding("UTF-8");
		    response.getWriter().write(jsonResponse.toString());

		
		
		
		
	}

	private void autentificacionLog(JsonObject jsonObject, HttpServletRequest request, HttpServletResponse response) throws IOException {
	   
		Gson gson = new Gson();
	    JsonObject datos = new JsonObject();
//		if(misesionactiva == null) {   		
					
			
				    try {
				        String correo = jsonObject.get("correo").getAsString();
				        String contrasena = jsonObject.get("contrasena").getAsString();
			
				        
				        
				        Usuario usuario = new UsuariosDao().autenticar(correo, contrasena);
			
				        if (usuario != null) {
				        	 HttpSession oldSession = request.getSession(false);
				        	 if (oldSession != null) {
				        		 oldSession.invalidate();
				        	 }
				        	 HttpSession session = request.getSession(true);
				        	 
				        	    session.setAttribute("usuarioLogeado", usuario);
				        	    System.out.println("Usuario guardado en sesión: " + usuario.getCorreo());
			
				        	
				        	datos.addProperty("status", "success");
				           datos.addProperty("mensaje", "validacion Correcta");
				        } else {
				            datos.addProperty("status", "errorVALIDACION");
				            datos.addProperty("mensaje", "Credenciales Incorrectas");
				        }
			
				    } catch (Exception e) {
				        datos.addProperty("status", "error");
				        datos.addProperty("mensaje", "Error procesando la solicitud: " + e.getMessage());
				        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
				    }
			
				    response.setContentType("application/json");
				    response.setCharacterEncoding("UTF-8");
				    response.getWriter().write(gson.toJson(datos));
				}


}