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

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

/**
 * Servlet implementation class ActualizarPerfilServlet
 */
@WebServlet("/GestionUsuarioServlet")
public class GestionUsuarioServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GestionUsuarioServlet() {
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
		JsonObject JsonObject= null;
		try {
			//lectura del json object enviado por el fetch 
			JsonObject = JsonParser.parseReader(request.getReader()).getAsJsonObject();
			String accion = JsonObject.get("accion").getAsString();
			
			switch(accion) {
			case "actualizarDatos":
        		actualizarDatos(JsonObject,request, response);
        		break;	
			case "cerrarSesion"	:
				cerrarSesion(JsonObject, request, response);
				break;
			default:
			    JsonObject err = new JsonObject();
			    err.addProperty("status", false);
			    err.addProperty("mensaje", "Acción no reconocida");
			    response.setContentType("application/json");
			    response.setCharacterEncoding("UTF-8");
			    response.getWriter().write(err.toString());
			    break;
			}
		}
		catch(Exception e) {
			e.printStackTrace();
			JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("status", false);
            jsonResponse.addProperty("mensaje", "Error interno en el servidor gestionando usuario");
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(jsonResponse.toString());
		}
	}

	private void cerrarSesion(JsonObject jsonObject, HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session =request.getSession(false);
		if(session != null) {
			session.invalidate();
		}
		JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("status", true);
        jsonResponse.addProperty("mensaje", "Sesión cerrada correctamente");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResponse.toString());
	}

	private void actualizarDatos(JsonObject jsonObject, HttpServletRequest request, HttpServletResponse response) throws IOException {
		  
		HttpSession session = request.getSession();
		JsonObject jsonResponse= new JsonObject();

		Usuario usuario = (Usuario) session.getAttribute("usuarioLogeado");
		
		String altura= null;
		String peso= null;
		String tipoSangre= null;
		String Correo = null;
		if(usuario == null) {
			System.out.println("usuario deslogeado, vuelve a iniciar sesion ");
			jsonResponse.addProperty("status", false);
			jsonResponse.addProperty("mensaje", "usuario expiro vuelve a iniciar sesion");
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(jsonResponse.toString());
			return;
		}

		try {
			Correo = jsonObject.get("correo").getAsString();
			altura = jsonObject.get("altura").getAsString();
			peso = jsonObject.get("peso").getAsString();
			tipoSangre = jsonObject.get("tipoSangre").getAsString();

			if (UsuariosDao.existeOtroUsuarioConCorreo(usuario.getId(), Correo)) {
			    jsonResponse.addProperty("status", false);
			    jsonResponse.addProperty("mensaje", "Ya existe otro usuario utilizando ese correo.");
			    response.setContentType("application/json");
			    response.setCharacterEncoding("UTF-8");
			    response.getWriter().write(jsonResponse.toString());
			    return;
			}

			boolean datosActualizados = UsuariosDao.actualizarPerfil(usuario.getId(), altura, peso, tipoSangre, Correo);

			if (datosActualizados) {
				usuario.setCorreo(Correo);
				usuario.setAltura(altura);
				usuario.setPeso(peso);
				usuario.setTipoDeSangre(tipoSangre);
				session.setAttribute("usuarioLogeado", usuario);
				
				jsonResponse.addProperty("status", true);
				jsonResponse.addProperty("mensaje", "Datos actualizados, por favor inicie sesion nuevamente si cambio su correo.");
				// If email changed, we successfully updated it.
			} else {
				jsonResponse.addProperty("status", false);
				jsonResponse.addProperty("mensaje", " no se actualizaron los datos ");
			}
		}
		
		catch(Exception e) {
			System.out.println("erro al leer el json " + e.getMessage());
			jsonResponse.addProperty("status", false);
			jsonResponse.addProperty("mensaje", "error al procesar los datos enviados al servlet");
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

