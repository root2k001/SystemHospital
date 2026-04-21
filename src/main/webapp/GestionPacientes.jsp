<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="models.Usuario" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogeado");

    if (usuario == null) {
        response.sendRedirect("Login.jsp"); 
        return;
    }

    String[] tiposSangre = {"A+", "A-", "O+", "O-", "B+", "B-", "AB+", "AB-"};
    String tipoUsuario = usuario.getTipoDeSangre() != null ? usuario.getTipoDeSangre() : "";
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hospira Premium | Panel Clínico</title>
    <link rel="stylesheet" href="css/globals.css">
    <link rel="stylesheet" href="css/estilosGestionPac.css">
</head>
<body>

<!-- =================== SIDEBAR =================== -->
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="sidebar-logo">
            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='28' height='28' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z'/%3E%3C/svg%3E" alt="Logo" />
        </div>
        <div class="sidebar-brand-text">
            <span class="sidebar-name">Hospira</span>
            <span class="sidebar-tagline">Premium</span>
        </div>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-section-label">Principal</div>
        <a href="#" class="nav-item active" id="nav-dashboard" data-tooltip="Panel Principal">
            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='20' height='20' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Crect width='7' height='9' x='3' y='3' rx='1'/%3E%3Crect width='7' height='5' x='14' y='3' rx='1'/%3E%3Crect width='7' height='9' x='14' y='12' rx='1'/%3E%3Crect width='7' height='5' x='3' y='16' rx='1'/%3E%3C/svg%3E" alt="" />
            <span>Panel Principal</span>
        </a>
        <a href="#" class="nav-item" id="nav-citas" data-tooltip="Mis Citas" onclick="scrollToSection('seccion-citas')">
            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='20' height='20' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Crect width='18' height='18' x='3' y='4' rx='2' ry='2'/%3E%3Cline x1='16' x2='16' y1='2' y2='6'/%3E%3Cline x1='8' x2='8' y1='2' y2='6'/%3E%3Cline x1='3' x2='21' y1='10' y2='10'/%3E%3C/svg%3E" alt="" />
            <span>Mis Citas</span>
        </a>
        <a href="#" class="nav-item" id="nav-pacientes" data-tooltip="Pacientes" onclick="document.getElementById('miBoton').click(); return false;">
            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='20' height='20' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2'/%3E%3Ccircle cx='9' cy='7' r='4'/%3E%3Cpath d='M22 21v-2a4 4 0 0 0-3-3.87'/%3E%3Cpath d='M16 3.13a4 4 0 0 1 0 7.75'/%3E%3C/svg%3E" alt="" />
            <span>Pacientes</span>
        </a>

        <div class="nav-section-label">Perfil</div>
        <a href="#" class="nav-item" id="nav-perfil" data-tooltip="Mi Perfil" onclick="document.getElementById('btn_editar_usuario').click(); return false;">
            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='20' height='20' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2'/%3E%3Ccircle cx='12' cy='7' r='4'/%3E%3C/svg%3E" alt="" />
            <span>Mi Perfil</span>
        </a>
    </nav>

    <div class="sidebar-footer">
        <button type="button" id="btn-cerrar-sesion" class="sidebar-logout" data-tooltip="Cerrar Sesión">
            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4'/%3E%3Cpolyline points='16 17 21 12 16 7'/%3E%3Cline x1='21' x2='9' y1='12' y2='12'/%3E%3C/svg%3E" alt="" />
            <span>Cerrar Sesión</span>
        </button>
    </div>
</aside>

<!-- =================== MAIN CONTENT =================== -->
<div class="main-layout" id="Contenedor">

    <!-- TOP HEADER BAR -->
    <header class="top-header">
        <button class="sidebar-toggle" id="sidebar-toggle" onclick="document.getElementById('sidebar').classList.toggle('collapsed')">
            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='22' height='22' viewBox='0 0 24 24' fill='none' stroke='%230284C7' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cline x1='3' x2='21' y1='6' y2='6'/%3E%3Cline x1='3' x2='21' y1='12' y2='12'/%3E%3Cline x1='3' x2='21' y1='18' y2='18'/%3E%3C/svg%3E" alt="Menu" />
        </button>
        <div class="header-welcome">
            <h1 id="contenedorDatos">Bienvenido, <span class="highlight-name"><%= usuario.getNombre() %> <%= usuario.getApellido() %></span></h1>
            <p>Panel de Gestión Clínica — <span id="fecha-actual"></span></p>
        </div>
        <div class="header-actions">
            <button class="header-btn" id="btn_editar_usuario" title="Editar perfil">
                <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='%230284C7' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2'/%3E%3Ccircle cx='12' cy='7' r='4'/%3E%3C/svg%3E" alt="Perfil" />
            </button>
        </div>
    </header>

    <!-- PAGE BODY -->
    <div class="page-body">

        <!-- STATS CARDS ROW -->
        <section class="stats-row" aria-label="Estadísticas rápidas">
            <div class="stat-card stat-primary">
                <div class="stat-icon">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Crect width='18' height='18' x='3' y='4' rx='2' ry='2'/%3E%3Cline x1='16' x2='16' y1='2' y2='6'/%3E%3Cline x1='8' x2='8' y1='2' y2='6'/%3E%3Cline x1='3' x2='21' y1='10' y2='10'/%3E%3C/svg%3E" alt="" />
                </div>
                <div class="stat-info">
                    <span class="stat-label">Citas Registradas</span>
                    <span class="stat-value" id="total-citas">0</span>
                </div>
            </div>
            <div class="stat-card stat-success">
                <div class="stat-icon">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2'/%3E%3Ccircle cx='9' cy='7' r='4'/%3E%3Cpath d='M22 21v-2a4 4 0 0 0-3-3.87'/%3E%3Cpath d='M16 3.13a4 4 0 0 1 0 7.75'/%3E%3C/svg%3E" alt="" />
                </div>
                <div class="stat-info">
                    <span class="stat-label">Pacientes Gestionados</span>
                    <span class="stat-value" id="total-pacientes">0</span>
                </div>
            </div>
            <div class="stat-card stat-info">
                <div class="stat-icon">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z'/%3E%3C/svg%3E" alt="" />
                </div>
                <div class="stat-info">
                    <span class="stat-label">Tipo de Sangre</span>
                    <span class="stat-value stat-value-sm"><%= tipoUsuario.isEmpty() ? "—" : tipoUsuario %></span>
                </div>
            </div>
            <div class="stat-card stat-warning">
                <div class="stat-icon">
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z'/%3E%3C/svg%3E" alt="" />
                </div>
                <div class="stat-info">
                    <span class="stat-label">Estado del Sistema</span>
                    <span class="stat-value stat-value-sm status-active">Activo</span>
                </div>
            </div>
        </section>

        <!-- HEALTH TIPS BANNER (full-width between stats and main grid) -->
        <div class="tips-banner">
            <div class="tips-banner-icon">
                <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='22' height='22' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z'/%3E%3C/svg%3E" alt="">
                <span>Tip de Salud</span>
            </div>
            <div class="tips-carousel tips-carousel-banner" id="tips-carousel">
                <div class="tip-slide active">
                    <p>&#127810; El huevo y el pescado son fuentes de vitamina B, ideales para el crecimiento y la reparación tisular.</p>
                </div>
                <div class="tip-slide">
                    <p>&#128167; Beber al menos 8 vasos de agua al día ayuda a mantener los riñones saludables y mejora la circulación.</p>
                </div>
                <div class="tip-slide">
                    <p>&#127939; 30 minutos de actividad física moderada al día reduce el riesgo de enfermedades cardiovasculares en un 35%.</p>
                </div>
                <div class="tip-slide">
                    <p>&#128564; Dormir entre 7 y 9 horas refuerza el sistema inmune y mejora la memoria y concentración.</p>
                </div>
            </div>
            <div class="tips-banner-controls">
                <button class="tip-btn tip-btn-banner" id="tip-prev" onclick="changeTip(-1)">&#8249;</button>
                <div class="tip-dots" id="tip-dots"></div>
                <button class="tip-btn tip-btn-banner" id="tip-next" onclick="changeTip(1)">&#8250;</button>
            </div>
        </div>

        <!-- MAIN GRID: LEFT (profile) | RIGHT (patient table) -->
        <div class="content-grid" id="ContenedorDatosUsuario">

            <!-- LEFT COLUMN: Profile Card -->
            <aside class="profile-column">
                <div class="profile-card glass" id="datos">
                    <div id="cabeceraInformativa" class="profile-header-section">
                        <div class="profile-avatar-wrap">
                            <div class="perfil_img">
                                <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='60' height='60' viewBox='0 0 24 24' fill='%230284C7' stroke='none'%3E%3Ccircle cx='12' cy='8' r='4' fill='%230284C7' opacity='0.6'/%3E%3Cpath d='M4 20c0-4 3.6-7 8-7s8 3 8 7' fill='%230284C7' opacity='0.4'/%3E%3C/svg%3E" alt="perfil" />
                            </div>
                            <div class="profile-status-dot"></div>
                        </div>
                        <div id="perfil-txt" class="profile-name-section">
                            <span id="sp_perfil">Mi Perfil Clínico</span>
                            <span class="profile-email"><%= usuario.getCorreo() %></span>
                            <div id="botones-edicionperfil" class="profile-actions">
                                <button type="button" id="btn-edit-profile-card" class="btn-accion btn-edit-profile" onclick="document.getElementById('btn_editar_usuario').click()">
                                    ✏️ Editar Perfil
                                </button>
                            </div>
                        </div>
                    </div>

                    <div id="datosDinamicos" class="clinical-data">
                        <table id="miTablaDatos">
                            <tbody>
                                <tr>
                                    <td>Nombre</td>
                                    <td id="nombreVal"><%= usuario.getNombre() %></td>
                                </tr>
                                <tr>
                                    <td>Apellido</td>
                                    <td id="apellidoVal"><%= usuario.getApellido() %></td>
                                </tr>
                                <tr>
                                    <td>Correo</td>
                                    <td id="correoVal"><%= usuario.getCorreo() %></td>
                                </tr>
                                <tr>
                                    <td>Género</td>
                                    <td><%= usuario.getSexo() != null ? usuario.getSexo() : "—" %></td>
                                </tr>
                                <tr>
                                    <td>Peso</td>
                                    <td><%= (usuario.getPeso() != null && !usuario.getPeso().isEmpty()) ? usuario.getPeso() + " kg" : "—" %></td>
                                </tr>
                                <tr>
                                    <td>Altura</td>
                                    <td><%= (usuario.getAltura() != null && !usuario.getAltura().isEmpty()) ? usuario.getAltura() + " m" : "—" %></td>
                                </tr>
                                <tr>
                                    <td>Tipo Sangre</td>
                                    <td><span class="blood-badge"><%= (usuario.getTipoDeSangre() != null && !usuario.getTipoDeSangre().isEmpty()) ? usuario.getTipoDeSangre()+ " "  : "—"  %></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

            </aside>

            <!-- RIGHT COLUMN: Patient Table -->
            <div class="patients-column">
                <!-- Action Bar -->
                <div class="patients-action-bar">
                    <div class="action-bar-title">
                        <h2>Gestión de Pacientes</h2>
                        <span class="patients-count-badge" id="patients-count-badge">0 registros</span>
                    </div>
                    <button id="miBoton" class="btn-primary-action">
                        <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='2.5' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M5 12h14'/%3E%3Cpath d='M12 5v14'/%3E%3C/svg%3E" alt="">
                        Registrar Paciente
                    </button>
                </div>

                <!-- Section: Citas -->
                <div class="collapsible-section" id="seccion-citas">
                    <button class="section-toggle-btn" id="toggle-citas" onclick="toggleSection('citas-body', this)">
                        <div class="section-toggle-left">
                            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Crect width='18' height='18' x='3' y='4' rx='2' ry='2'/%3E%3Cline x1='16' x2='16' y1='2' y2='6'/%3E%3Cline x1='3' x2='21' y1='10' y2='10'/%3E%3C/svg%3E" alt="">
                            <span>Citas Registradas y Programadas</span>
                        </div>
                        <span class="toggle-arrow open">&#8963;</span>
                    </button>
                    <div class="section-body" id="citas-body">
                        <div id="contenedor_tablas_citas" class="table-wrapper">
                            <table id="mi_tabla_citas">
                                <thead>
                                    <tr>
                                        <th>Nombre del Paciente</th>
                                        <th>Sexo</th>
                                        <th>Teléfono</th>
                                        <th>Motivo de Consulta</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                            <div class="empty-state" id="empty-citas">
                                <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='48' height='48' viewBox='0 0 24 24' fill='none' stroke='%23CBD5E1' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'%3E%3Crect width='18' height='18' x='3' y='4' rx='2' ry='2'/%3E%3Cline x1='16' x2='16' y1='2' y2='6'/%3E%3Cline x1='3' x2='21' y1='10' y2='10'/%3E%3C/svg%3E" alt="">
                                <p>No tienes citas programadas por el momento.</p>
                                <span>Usa el botón "Registrar Paciente" para agregar uno.</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Section: History (aesthetic, no backend) -->
                <div class="collapsible-section">
                    <button class="section-toggle-btn section-toggle-secondary" onclick="toggleSection('history-body', this)">
                        <div class="section-toggle-left">
                            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Ccircle cx='12' cy='12' r='10'/%3E%3Cpolyline points='12 6 12 12 16 14'/%3E%3C/svg%3E" alt="">
                            <span>Historial de Actividad Clínica</span>
                        </div>
                        <span class="toggle-arrow">&#8964;</span>
                    </button>
                    <div class="section-body section-body-hidden" id="history-body">
                        <div class="history-empty-state">
                            <p>El historial de actividad se registrará automáticamente conforme uses el sistema.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- =================== MODALES =================== -->

<!-- Modal: Registrar Paciente -->
<div id="contenedorGeneral">
    <button type="button" id="cerrar-formulario" class="btn-cerrar"><span>×</span></button>
    <div id="titulo"><strong>Registrar Nuevo Paciente</strong></div>
    <div class="contenedorFormulario">
        <form id="formulario">
            <div class="labelcontainer">
                <label>Parentesco</label>
                <select id="cboParentesco" name="parentesco">
                    <option>Padre</option>
                    <option>Madre</option>
                    <option>Conyugue</option>
                    <option>Hermano(a)</option>
                    <option>Hijo</option>
                    <option>Otro</option>
                </select>
            </div>
            <div class="labelcontainer">
                <label>Número de Documento</label>
                <input id="txtDni" type="text" name="dni" placeholder="8 dígitos">
            </div>
            <div class="labelcontainer">
                <label>Género</label>
                <select id="cboSexo" name="genero">
                    <option>Masculino</option>
                    <option>Femenino</option>
                    <option>Otro</option>
                </select>
            </div>
            <div class="labelcontainer">
                <label>Apellido Paterno</label>
                <input id="txtApellidoPat" type="text" name="apellidoPat" placeholder="Apellido paterno">
            </div>
            <div class="labelcontainer">
                <label>Apellido Materno</label>
                <input id="txtApellidoMat" type="text" name="apellidoMat" placeholder="Apellido materno">
            </div>
            <div class="labelcontainer">
                <label>Nombre Completo</label>
                <input id="txtNombre" type="text" name="nombre" placeholder="Nombres">
            </div>
            <div class="labelcontainer">
                <label>Fecha de Nacimiento</label>
                <input id="txtfecha" type="date" name="fecha_nacimiento">
            </div>
            <div class="labelcontainer">
                <label>Correo Electrónico</label>
                <input id="txtCorreo" type="text" name="correo" placeholder="correo@ejemplo.com">
            </div>
            <div class="labelcontainer">
                <label>Teléfono</label>
                <input id="txtTelefono" type="text" name="telefono" placeholder="Número telefónico">
            </div>
            <div class="labelcontainer">
                <label>Dirección</label>
                <input id="txtDireccion" type="text" name="direccion" placeholder="Dirección del paciente">
            </div>
            <div class="labelcontainer">
                <label>Motivo de Consulta</label>
                <input id="txtMotivo" type="text" name="consulta" placeholder="Describe el motivo">
            </div>
            <div id="contenedor-boton">
                <button id="btnProcesarGestion" type="submit">Registrar Paciente</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Actualizar Perfil Usuario -->
<div id="contenedorActualizarData">
    <button type="button" id="cerrar-formulario" class="btn-cerrar"><span>×</span></button>
    <h1 class="text-left" id="actperfil">Actualiza tu Perfil Clínico</h1>
    <form id="formActualizarPerfil" method="post">
        <input type="hidden" name="accion" value="actualizarPerfil">
        <div class="labelcontainer">
            <label>Género</label>
            <input type="text" id="txtSexoActualizar" value="<%= usuario.getSexo() %>" disabled>
        </div>
        <div class="labelcontainer">
            <label>Correo</label>
            <input type="text" id="txtActualizarCorreo" value="<%= usuario.getCorreo() %>">
        </div>
        <div class="labelcontainer">
            <label>Peso (kg)</label>
            <input type="text" name="peso" id="peso-txt" value="<%= (usuario.getPeso() != null) ? usuario.getPeso() : "" %>" placeholder="Ej: 75">
        </div>
        <div class="labelcontainer">
            <label>Altura (m)</label>
            <input type="text" name="altura" id="altura-txt" value="<%= (usuario.getAltura() != null) ? usuario.getAltura() : "" %>" placeholder="Ej: 1.75">
        </div>
        <div class="labelcontainer">
            <label>Tipo de Sangre</label>
            <select name="tipoSangre" id="sangre-txt">
                <option id="cbotipodeSangre" value="">Seleccione</option>
                <% for (String tipo : tiposSangre) { %>
                    <option value="<%= tipo %>" <%= tipo.equals(tipoUsuario) ? "selected" : "" %>><%= tipo %></option>
                <% } %>
            </select>
        </div>
        <button type="submit" id="actualizarDatosUsuario" class="miBoton">Guardar Cambios</button>
    </form>
</div>

<!-- Modal: Editar Datos de Paciente -->
<div id="contenedor-formulario-edit-Pac" style="display: none">
    <button type="button" id="cerrar-formulario-edit-pac" class="btn-cerrar"><span>×</span></button>
    <div id="titulo"><strong>Editar Datos Paciente</strong></div>
    <form id="formActualizarPac" method="post">
        <input type="hidden" name="accion" value="actualizarPaciente">
        <div class="labelcontainer">
            <label>Parentesco</label>
            <select id="cboParentescoPac" name="parentesco">
                <option>Padre</option>
                <option>Madre</option>
                <option>Conyugue</option>
                <option>Hermano(a)</option>
                <option>Hijo</option>
                <option>Otro</option>
            </select>
        </div>
        <div class="labelcontainer">
            <label>Correo Electrónico</label>
            <input id="txtCorreoPac" type="text" name="correo">
        </div>
        <div class="labelcontainer">
            <label>Fecha de Nacimiento</label>
            <input id="txtfechaPac" type="date" name="fecha_nacimiento">
        </div>
        <div class="labelcontainer">
            <label>Teléfono</label>
            <input id="txtTelefonoPac" type="text" name="telefono">
        </div>
        <div class="labelcontainer">
            <label>Dirección</label>
            <input id="txtDireccionPac" type="text" name="direccion">
        </div>
        <button type="submit" id="actualizarDatosPaciente" class="miBoton">Guardar Cambios</button>
    </form>
</div>

<!-- Toast notification system -->
<jsp:include page="items/mensaje_respuesta.jsp"></jsp:include>

<script src="js/gestionPac.js" type="text/javascript" defer></script>
<script>
    // Date display
    document.getElementById('fecha-actual').textContent = new Date().toLocaleDateString('es-PE', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });

    // Health tips carousel
    let currentTip = 0;
    const tips = document.querySelectorAll('.tip-slide');
    const dotsContainer = document.getElementById('tip-dots');

    tips.forEach((_, i) => {
        const dot = document.createElement('span');
        dot.className = 'tip-dot' + (i === 0 ? ' active' : '');
        dot.onclick = () => goToTip(i);
        dotsContainer.appendChild(dot);
    });

    function goToTip(index) {
        tips[currentTip].classList.remove('active');
        dotsContainer.children[currentTip].classList.remove('active');
        currentTip = (index + tips.length) % tips.length;
        tips[currentTip].classList.add('active');
        dotsContainer.children[currentTip].classList.add('active');
    }

    function changeTip(dir) { goToTip(currentTip + dir); }
    setInterval(() => changeTip(1), 6000);

    // Collapsible sections
    function toggleSection(id, btn) {
        const body = document.getElementById(id);
        const arrow = btn.querySelector('.toggle-arrow');
        if (body.classList.contains('section-body-hidden')) {
            body.classList.remove('section-body-hidden');
            if (arrow) { arrow.classList.add('open'); arrow.innerHTML = '&#8963;'; }
        } else {
            body.classList.add('section-body-hidden');
            if (arrow) { arrow.classList.remove('open'); arrow.innerHTML = '&#8964;'; }
        }
    }

    function scrollToSection(id) {
        document.getElementById(id).scrollIntoView({ behavior: 'smooth' });
    }

    // Update stat counters when table loads
    const observer = new MutationObserver(function() {
        const rows = document.querySelectorAll('#mi_tabla_citas tbody tr');
        const count = rows.length;
        document.getElementById('total-citas').textContent = count;
        document.getElementById('total-pacientes').textContent = count;
        document.getElementById('patients-count-badge').textContent = count + ' registros';
        const emptyState = document.getElementById('empty-citas');
        if (emptyState) emptyState.style.display = count > 0 ? 'none' : 'flex';
    });
    const tbody = document.querySelector('#mi_tabla_citas tbody');
    if (tbody) observer.observe(tbody, { childList: true });
</script>
</body>
</html>
