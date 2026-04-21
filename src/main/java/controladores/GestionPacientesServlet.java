package controladores;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Paciente;
import models.PacienteDao;
import models.Usuario;
import models.UsuariosDao;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

/**
 * Servlet implementation class GestionPacientesServlet
 */
@WebServlet("/GestionPacientesServlet")
public class GestionPacientesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GestionPacientesServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	//parametro accion doget obtiene los datos de la BD   registrados de la tabla pacientes 
	String accion = request.getParameter("accion");
	
	response.setContentType("application/json");
	response.setCharacterEncoding("UTF-8");
	HttpSession session = request.getSession(false); // obtiene la sesion actual , si no existe   devuele null
    PrintWriter out = response.getWriter();// objeto de tipo printwriter  que permite enviar respuesta al cliente 
    response.setStatus(HttpServletResponse.SC_OK); // Código 200
    Gson gson = new Gson();
    

		//manejando estado de la sesion
    Usuario sesionUsuario = (Usuario) session.getAttribute("usuarioLogeado");// OBTIENES  UN ATRIBUTO DE LA SESION INICIADA 

    
    //  validacion si la sesion obtenida es null 
    if (sesionUsuario == null) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // Código 401  al logear usuario  mandando un error de autentificacion 
        out.print(gson.toJson(Collections.singletonMap("error", "Usuario no autenticado.")));   
        return; 
    }

		
		int idUsuario=  sesionUsuario.getId();


		// aca vamos a obtener la lista de pacientes de PACDAO 
		List<Map<String,Object>>listaPacientes;
		
		try {
			
			listaPacientes= PacienteDao.obtenerTodosLosPacientes(idUsuario);
			// devolvemos la repsuesta al fetch
            out.print(gson.toJson(listaPacientes));
            out.flush();
            System.out.println(listaPacientes);
            
			
	}
	catch(Exception e) {
		
		 response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
         out.print(gson.toJson(Collections.singletonMap("error", "Error interno al obtener pacientes: " + e.getMessage())));
         e.printStackTrace();
		
	}
	
	
	
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
	JsonObject jsonObject = null;

        
        try {
        	  jsonObject = JsonParser.parseReader(request.getReader()).getAsJsonObject();
              String accion = jsonObject.get("accion").getAsString();
        	switch(accion) {
        	case "registrar":
                System.out.println(">>> ACCION: registrar recibida");
                regPaciente(jsonObject,request, response);
                break;
        	case "eliminar":
                EliminarPac(jsonObject, request, response);     
                break;
        	case "editar" :
                EditarPac(jsonObject, request, response);     
        		break;
        	default:
        	    JsonObject err = new JsonObject();
			    err.addProperty("estado", false);
			    err.addProperty("mensaje", "Acción no reconocida");
			    response.setContentType("application/json");
			    response.setCharacterEncoding("UTF-8");
			    response.getWriter().write(err.toString());
			    break;
        	}
        } catch(Exception e) {
            e.printStackTrace();
            JsonObject err = new JsonObject();
		    err.addProperty("estado", false);
		    err.addProperty("mensaje", "Error interno al procesar los datos de pacientes.");
		    response.setContentType("application/json");
		    response.setCharacterEncoding("UTF-8");
		    response.getWriter().write(err.toString());
        }
		
		
		
		
		
	}

	

	private void EditarPac(JsonObject jsonObject, HttpServletRequest request, HttpServletResponse response) throws IOException {
	    JsonObject json = new JsonObject();
	    PacienteDao editPac = new PacienteDao();
	    HttpSession session = request.getSession(false);
	    Usuario sesionUsuario = (Usuario) session.getAttribute("usuarioLogeado");
	    int idUsuario = sesionUsuario.getId();
	    
		try {
			String DNIPaciente = jsonObject.get("DNI").getAsString();
			String parentesco = jsonObject.get("parentesco").getAsString();
			String correo = jsonObject.get("correo").getAsString();
			String fechaNac = jsonObject.get("fechaNac").getAsString();
			String telefono = jsonObject.get("telefono").getAsString();
			String direccion = jsonObject.get("direccion").getAsString();
			
			System.out.println("=== EDITANDO PACIENTE ===");
			System.out.println("DNI: " + DNIPaciente);
			System.out.println("Parentesco: " + parentesco);
			System.out.println("Correo: " + correo);
			System.out.println("Fecha: " + fechaNac);
			System.out.println("Telefono: " + telefono);
			System.out.println("Direccion: " + direccion);
			
			 Paciente paciente = new Paciente();
			 paciente.setDni(DNIPaciente);
			 paciente.setParentesco(parentesco);
			 paciente.setCorreo(correo);
			 paciente.setFecha(fechaNac);
			 paciente.setTelefono(telefono);
			 paciente.setDireccion(direccion);
			 
			 boolean actualizado = editPac.editarPaciente(paciente, idUsuario);
			 System.out.println("Resultado UPDATE: " + actualizado);
	            
			 if (actualizado) {
				 json.addProperty("estado", true);
				 json.addProperty("mensaje", "Paciente actualizado exitosamente.");
			 } else {
				 json.addProperty("estado", false);
				 json.addProperty("mensaje", "No se encontró el paciente o no se actualizó.");
			 }
		} catch(Exception e) {
			System.out.println("ERROR en EditarPac: " + e.getMessage());
			e.printStackTrace();
			json.addProperty("estado", false);
			json.addProperty("mensaje", "Error procesando edición de paciente: " + e.getMessage());
		}
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(json.toString());
	}

private void EliminarPac(JsonObject jsonObject, HttpServletRequest request, HttpServletResponse response) throws IOException {
				
	    PrintWriter out = response.getWriter();
	    PacienteDao PacienteDao = new PacienteDao();
	    JsonObject json = new JsonObject();
	    HttpSession session = request.getSession(false);
	    Usuario sesionUsuario = (Usuario) session.getAttribute("usuarioLogeado");
	    int idUsuario = sesionUsuario.getId();

		String DNIPaciente= null;
		
		try {
			DNIPaciente = jsonObject.get("DNI").getAsString();

			boolean  pacEliminado=	PacienteDao.eliminarPaciente(DNIPaciente, idUsuario);
			String mensje="paciente eliminado correctamente";
			

			json.addProperty("estado", pacEliminado);	
			json.addProperty("mensaje", mensje);	
			
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			out.print(json);
	        out.flush();			
		}catch(Exception e) {
			
			System.out.println("Error al leer el JSON: " + e.getMessage());
			json.addProperty("estado", false);
			json.addProperty("mensaje", "Error al procesar los datos json");
	    	response.setContentType("application/json");
	    	response.setCharacterEncoding("UTF-8");
	    	out.print(json);
            out.flush();
	    	return;
			
		}
		
		
		
	}

	private void regPaciente(JsonObject datosJson, HttpServletRequest request, HttpServletResponse response) throws IOException {

		
		PacienteDao pacienteReg = new PacienteDao();
				JsonObject jsonResponse= new JsonObject();
				HttpSession session = request.getSession(false);

			    Usuario sesionUsuario = (Usuario) session.getAttribute("usuarioLogeado");
				int idUsuario=  sesionUsuario.getId();

			    
			String parentesco=null;

			String dni=null;

			String sexo=null;

			String apellidoPat=null;
			String apellidoMat=null;
			
			String 	nombre=null;
			String fecha=null;
			String correo=null;
			String telefono=null;
			String 	direccion= null;
			String 	consulta= null;

				    try {
				        // Usar datosJson directamente
				    	parentesco = datosJson.get("parentesco").getAsString();
				    	dni = datosJson.get("dni").getAsString();
				    	sexo = datosJson.get("sexo").getAsString(); 

				    	apellidoPat = datosJson.get("apellidoPat").getAsString(); 
				    	apellidoMat = datosJson.get("apellidoMat").getAsString(); 
				    	
				    	nombre = datosJson.get("nombre").getAsString();
				    	fecha = datosJson.get("fecha").getAsString();
				    	correo= datosJson.get("correo").getAsString();	

				    	telefono = datosJson.get("telefono").getAsString();	
				    	direccion = datosJson.get("direccion").getAsString();	
				    	consulta = datosJson.get("consulta").getAsString();	
				    	boolean existe = pacienteReg.existePaciente(dni, idUsuario);
				        if (existe) {
				            jsonResponse.addProperty("estado", false);
				            jsonResponse.addProperty("mensaje", "Ya existe un paciente con esos datos.");
				        } else {
// PRIMER Y ÚNICO REGISTRO
System.out.println("=== REGISTRANDO PACIENTE ===");
		            System.out.println("ID Usuario desde sesión: " + idUsuario);
		            System.out.println("DNI: " + dni);
		            System.out.println("Nombre: " + nombre);
		            System.out.println("Parentesco: " + parentesco);
		            System.out.println("Correo: " + correo);
		            
		    Paciente paciente = new Paciente(0, parentesco, dni, sexo, apellidoPat, apellidoMat, nombre, fecha, correo, telefono, direccion, consulta, idUsuario);
		            System.out.println("Paciente usuarioId asignado: " + paciente.getusuarioId());
		            
		            System.out.println("Llamando a agregarPaciente...");
		            pacienteReg.agregarPaciente(paciente);
		            System.out.println("Paciente registrado.");
				            jsonResponse.addProperty("estado", true);
				            jsonResponse.addProperty("mensaje", "Paciente registrado con éxito.");
				        }

				
				    	// Si hubo un error en el JSON, el flujo sale aquí.
				    }catch(Exception e) {
				    	
				        System.out.println("Error al leer el JSON: " + e.getMessage());
				        jsonResponse.addProperty("estado", false);
				        jsonResponse.addProperty("mensaje", "Error al procesar los datos json");
				    	response.setContentType("application/json");
				    	response.setCharacterEncoding("UTF-8");
				        response.getWriter().write(jsonResponse.toString());
				    	return;
				    }
				        
				    	
				    response.setContentType("application/json");
				    response.setCharacterEncoding("UTF-8");
				    response.getWriter().write(jsonResponse.toString());
    	
				    	
				    
		
		
		
	}

}
