package controladores;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Consulta;
import dao.ConsultaDao;
import dao.DoctorDao;
import models.Usuario;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * CitasServlet — Maneja el catálogo de doctores/especialidades/horarios
 * y el registro de consultas (citas).
 *
 * GET  /CitasServlet?accion=especialidades
 * GET  /CitasServlet?accion=doctores&especialidad=Cardiología
 * GET  /CitasServlet?accion=horarios&doctorId=3
 * POST /CitasServlet  { accion:"reservar", ... }
 */
@WebServlet("/CitasServlet")
public class CitasServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // ================================================================
    // doGet — obtener datos del catálogo
    // ================================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        // Validar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogeado") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(gson.toJson(Collections.singletonMap("error", "Sesión no activa.")));
            return;
        }

        String accion = request.getParameter("accion");
        if (accion == null) accion = "";

        try {
            switch (accion) {

                case "especialidades": {
                    List<String> lista = DoctorDao.listarEspecialidades();
                    out.print(gson.toJson(lista));
                    break;
                }

                case "doctores": {
                    String especialidad = request.getParameter("especialidad");
                    if (especialidad == null || especialidad.trim().isEmpty()) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print(gson.toJson(Collections.singletonMap("error", "Parámetro 'especialidad' requerido.")));
                        return;
                    }
                    List<Map<String, Object>> doctores = DoctorDao.listarDoctoresPorEspecialidad(especialidad);
                    out.print(gson.toJson(doctores));
                    break;
                }

                case "horarios": {
                    String doctorIdStr = request.getParameter("doctorId");
                    if (doctorIdStr == null || doctorIdStr.trim().isEmpty()) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print(gson.toJson(Collections.singletonMap("error", "Parámetro 'doctorId' requerido.")));
                        return;
                    }
                    int doctorId = Integer.parseInt(doctorIdStr);
                    Map<String, List<String>> horarios = DoctorDao.listarHorariosPorDoctor(doctorId);
                    out.print(gson.toJson(horarios));
                    break;
                }

                case "misCitas": {
                    Usuario u = (Usuario) session.getAttribute("usuarioLogeado");
                    List<Map<String, Object>> citas = dao.ConsultaDao.listarPorUsuario(u.getId());
                    out.print(gson.toJson(citas));
                    break;
                }

                default: {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(Collections.singletonMap("error", "Acción no reconocida: " + accion)));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(Collections.singletonMap("error", "Error interno: " + e.getMessage())));
        }

        out.flush();
    }

    // ================================================================
    // doPost — registrar cita
    // ================================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        // Validar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogeado") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            jsonResponse.addProperty("estado", false);
            jsonResponse.addProperty("mensaje", "Sesión no activa. Por favor inicia sesión.");
            out.print(jsonResponse.toString());
            return;
        }

        Usuario sesionUsuario = (Usuario) session.getAttribute("usuarioLogeado");

        try {
            JsonObject body = JsonParser.parseReader(request.getReader()).getAsJsonObject();
            String accion = body.has("accion") ? body.get("accion").getAsString() : "";

            if ("reservar".equals(accion)) {
                registrarCita(body, sesionUsuario, response, out);
            } else if ("cancelarCita".equals(accion)) {
                String codigo = body.has("codigo") ? body.get("codigo").getAsString() : "";
                if (!codigo.isEmpty() && ConsultaDao.cancelarCita(codigo)) {
                    jsonResponse.addProperty("estado", true);
                    jsonResponse.addProperty("mensaje", "Cita cancelada exitosamente.");
                } else {
                    jsonResponse.addProperty("estado", false);
                    jsonResponse.addProperty("mensaje", "No se pudo cancelar la cita.");
                }
                out.print(jsonResponse.toString());
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.addProperty("estado", false);
                jsonResponse.addProperty("mensaje", "Acción POST no reconocida: " + accion);
                out.print(jsonResponse.toString());
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("estado", false);
            jsonResponse.addProperty("mensaje", "Error interno al procesar la reserva: " + e.getMessage());
            out.print(jsonResponse.toString());
        }

        out.flush();
    }

    // ================================================================
    // Lógica de registro de cita
    // ================================================================
    private void registrarCita(JsonObject body, Usuario usuario,
                               HttpServletResponse response, PrintWriter out) throws Exception {

        JsonObject jsonResponse = new JsonObject();

        // Leer datos del body
        String tipoReserva    = body.has("tipoReserva")    ? body.get("tipoReserva").getAsString()    : "titular";
        int    doctorId       = body.has("doctorId")        ? body.get("doctorId").getAsInt()           : 0;
        String fecha          = body.has("fecha")           ? body.get("fecha").getAsString()           : "";
        String hora           = body.has("hora")            ? body.get("hora").getAsString()            : "";
        String motivo         = body.has("motivo")          ? body.get("motivo").getAsString()          : "Consulta médica";
        String codigoReserva  = body.has("codigoReserva")  ? body.get("codigoReserva").getAsString()  : generarCodigo();
        String metodoPago     = body.has("metodoPago")      ? body.get("metodoPago").getAsString()      : "presencial";

        // Validaciones básicas
        if (doctorId == 0 || fecha.isEmpty() || hora.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("estado", false);
            jsonResponse.addProperty("mensaje", "Faltan datos obligatorios: doctorId, fecha, hora.");
            out.print(jsonResponse.toString());
            return;
        }

        // Verificar que el slot no esté ya ocupado en la BD
        boolean ocupado = DoctorDao.estaOcupado(doctorId, fecha, hora);
        if (ocupado) {
            jsonResponse.addProperty("estado", false);
            jsonResponse.addProperty("mensaje", "El horario seleccionado ya no está disponible. Por favor elige otro.");
            out.print(jsonResponse.toString());
            return;
        }

        // Determinar paciente_id
        int pacienteId;
        if ("titular".equals(tipoReserva)) {
            // Auto-registrar o buscar el Titular en Pacientes
            pacienteId = ConsultaDao.obtenerOCrearPacienteTitular(usuario);
            if (pacienteId < 0) {
                jsonResponse.addProperty("estado", false);
                jsonResponse.addProperty("mensaje", "No se pudo identificar el paciente titular.");
                out.print(jsonResponse.toString());
                return;
            }
        } else {
            // Para familiar: el ID del paciente viene en el body
            if (!body.has("pacienteId") || body.get("pacienteId").getAsInt() == 0) {
                jsonResponse.addProperty("estado", false);
                jsonResponse.addProperty("mensaje", "Se debe seleccionar un familiar/conocido registrado.");
                out.print(jsonResponse.toString());
                return;
            }
            pacienteId = body.get("pacienteId").getAsInt();
        }

        // Construir y registrar la consulta
        Consulta consulta = new Consulta(pacienteId, doctorId, fecha, hora,
                                         motivo, codigoReserva, metodoPago,
                                         "Reservada", tipoReserva);

        int idGenerado = ConsultaDao.registrarCita(consulta);

        if (idGenerado > 0) {
            System.out.println(">>> CITA REGISTRADA ID: " + idGenerado + " | Código: " + codigoReserva);
            jsonResponse.addProperty("estado", true);
            jsonResponse.addProperty("mensaje", "Cita registrada exitosamente.");
            jsonResponse.addProperty("codigoReserva", codigoReserva);
            jsonResponse.addProperty("citaId", idGenerado);
        } else {
            jsonResponse.addProperty("estado", false);
            jsonResponse.addProperty("mensaje", "No se pudo registrar la cita. Intenta de nuevo.");
        }

        out.print(jsonResponse.toString());
    }

    // ================================================================
    // Generador de código de reserva único
    // ================================================================
    private String generarCodigo() {
        String chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        StringBuilder sb = new StringBuilder("HP-");
        for (int i = 0; i < 8; i++) {
            sb.append(chars.charAt((int)(Math.random() * chars.length())));
        }
        return sb.toString();
    }
}
