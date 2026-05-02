<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogeado");
    if (usuario == null) { response.sendRedirect("Login.jsp"); return; }
    String[] tiposSangre = {"A+","A-","O+","O-","B+","B-","AB+","AB-"};
    String tipoUsuario = usuario.getTipoDeSangre() != null ? usuario.getTipoDeSangre() : "";
    request.setAttribute("currentPage", "dashboard");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hospira Premium | Panel Clínico</title>
    <link rel="stylesheet" href="css/globals.css">
    <link rel="stylesheet" href="css/estilosGestionPac.css">
    <link rel="stylesheet" href="css/shared.css">
</head>
<body>

<%@ include file="items/sidebar.jsp" %>

<!-- =================== MAIN CONTENT =================== -->
<div class="main-layout" id="Contenedor">

    <% request.setAttribute("pageTitle", "Panel Clínico"); %>
    <% request.setAttribute("pageSubtitle", "Resumen de gestión y actividad — <span id=\"fecha-actual\"></span>"); %>
    <%@ include file="items/topheader.jsp" %>

    <div class="page-body">

        <!-- STATS CARDS -->
        <section class="stats-row" aria-label="Estadísticas rápidas">
            <div class="stat-card stat-primary">
                <div class="stat-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
                </div>
                <div class="stat-info">
                    <span class="stat-label">Citas Registradas</span>
                    <span class="stat-value" id="total-citas">—</span>
                </div>
            </div>
            <div class="stat-card stat-success">
                <div class="stat-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                </div>
                <div class="stat-info">
                    <span class="stat-label">Pacientes Gestionados</span>
                    <span class="stat-value" id="total-pacientes">—</span>
                </div>
            </div>
            <div class="stat-card stat-info">
                <div class="stat-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                </div>
                <div class="stat-info">
                    <span class="stat-label">Tipo de Sangre</span>
                    <span class="stat-value stat-value-sm"><%= tipoUsuario.isEmpty() ? "—" : tipoUsuario %></span>
                </div>
            </div>
            <div class="stat-card stat-warning">
                <div class="stat-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                </div>
                <div class="stat-info">
                    <span class="stat-label">Estado del Sistema</span>
                    <span class="stat-value stat-value-sm status-active">Activo</span>
                </div>
            </div>
        </section>

        <!-- HEALTH TIPS BANNER -->
        <div class="tips-banner">
            <div class="tips-banner-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                <span>Tip de Salud</span>
            </div>
            <div class="tips-carousel tips-carousel-banner" id="tips-carousel">
                <div class="tip-slide active"><p>&#127810; El huevo y el pescado son fuentes de vitamina B, ideales para el crecimiento y la reparación tisular.</p></div>
                <div class="tip-slide"><p>&#128167; Beber al menos 8 vasos de agua al día ayuda a mantener los riñones saludables y mejora la circulación.</p></div>
                <div class="tip-slide"><p>&#127939; 30 minutos de actividad física moderada al día reduce el riesgo de enfermedades cardiovasculares en un 35%.</p></div>
                <div class="tip-slide"><p>&#128564; Dormir entre 7 y 9 horas refuerza el sistema inmune y mejora la memoria y concentración.</p></div>
            </div>
            <div class="tips-banner-controls">
                <button class="tip-btn tip-btn-banner" id="tip-prev" onclick="changeTip(-1)">&#8249;</button>
                <div class="tip-dots" id="tip-dots"></div>
                <button class="tip-btn tip-btn-banner" id="tip-next" onclick="changeTip(1)">&#8250;</button>
            </div>
        </div>

        <!-- MAIN GRID -->
        <div class="content-grid" id="ContenedorDatosUsuario">

            <!-- LEFT: Profile Card -->
            <aside class="profile-column">
                <div class="profile-card glass" id="datos">
                    <div id="cabeceraInformativa" class="profile-header-section">
                        <div class="profile-avatar-wrap" onclick="openPerfilPopup()" title="Cambiar foto" style="cursor:pointer">
                            <div class="perfil_img" id="profile-card-avatar">
                                <% String _foto = usuario.getFotoPerfil(); %>
                                <% if (_foto != null && !_foto.isEmpty()) { %>
                                    <img src="<%= _foto %>" alt="foto" style="width:60px;height:60px;border-radius:50%;object-fit:cover;" />
                                <% } else { %>
                                    <svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 24 24" fill="none"><circle cx="12" cy="8" r="4" fill="#0284C7" opacity="0.6"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7" fill="#0284C7" opacity="0.4"/></svg>
                                <% } %>
                            </div>
                            <div class="profile-status-dot"></div>
                        </div>
                        <div id="perfil-txt" class="profile-name-section">
                            <span id="sp_perfil">Mi Perfil Clínico</span>
                            <span class="profile-email"><%= usuario.getCorreo() %></span>
                            <!-- Editar Perfil unificado en sidebar user card -->
                        </div>
                    </div>
                    <div id="datosDinamicos" class="clinical-data">
                        <table id="miTablaDatos">
                            <tbody>
                                <tr><td>Nombre</td><td id="nombreVal"><%= usuario.getNombre() %></td></tr>
                                <tr><td>Apellido</td><td id="apellidoVal"><%= usuario.getApellido() %></td></tr>
                                <tr><td>Correo</td><td id="correoVal"><%= usuario.getCorreo() %></td></tr>
                                <tr><td>Género</td><td><%= usuario.getSexo() != null ? usuario.getSexo() : "—" %></td></tr>
                                <tr><td>Peso</td><td><%= (usuario.getPeso()!=null&&!usuario.getPeso().isEmpty()) ? usuario.getPeso()+" kg":"—" %></td></tr>
                                <tr><td>Altura</td><td><%= (usuario.getAltura()!=null&&!usuario.getAltura().isEmpty()) ? usuario.getAltura()+" m":"—" %></td></tr>
                                <tr><td>Tipo Sangre</td><td><span class="blood-badge"><%= (!tipoUsuario.isEmpty()) ? tipoUsuario:"—" %></span></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </aside>

            <!-- RIGHT: Patients + Activity -->
            <div class="patients-column">
                <div class="patients-action-bar">
                    <div class="action-bar-title">
                        <h2>Gestión de Pacientes</h2>
                        <span class="patients-count-badge" id="patients-count-badge">0 registros</span>
                    </div>
                    <div class="action-bar-buttons">
                        <button id="btnAgendarCita" class="btn-primary-action" onclick="window.location.href='AgendarCita.jsp'">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
                            Agendar Cita
                        </button>
                        <button id="miBoton" class="btn-primary-action">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="M12 5v14"/></svg>
                            Registrar Paciente
                        </button>
                    </div>
                </div>

                <!-- Pacientes -->
                <div class="collapsible-section" id="seccion-citas">
                    <button class="section-toggle-btn" id="toggle-citas" onclick="toggleSection('citas-body', this)">
                        <div class="section-toggle-left">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
                            <span>Pacientes Registrados</span>
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
                                <tbody></tbody>
                            </table>
                            <div class="empty-state" id="empty-citas">
                                <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#CBD5E1" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
                                <p>No hay pacientes registrados aún.</p>
                                <span>Usa el botón "Registrar Paciente" para agregar uno.</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Actividad Clínica -->
                <div class="collapsible-section">
                    <button class="section-toggle-btn section-toggle-secondary" onclick="toggleSection('history-body', this)">
                        <div class="section-toggle-left">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            <span>Actividad Clínica Reciente</span>
                        </div>
                        <span class="toggle-arrow">&#8964;</span>
                    </button>
                    <div class="section-body section-body-hidden" id="history-body">
                        <div id="actividad-clinica-container">
                            <div class="history-empty-state"><p>Cargando actividad...</p></div>
                        </div>
                        <div style="text-align:right; padding: 8px 16px;">
                            <a href="MisCitas.jsp" style="color:#0284C7; font-size:.85rem; font-family:'Inter',sans-serif;">
                                Ver todas las citas &#8594;
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal: Registrar Paciente -->
<div id="contenedorGeneral">
    <button type="button" id="cerrar-formulario" class="btn-cerrar"><span>×</span></button>
    <div id="titulo"><strong>Registrar Nuevo Paciente</strong></div>
    <div class="contenedorFormulario">
        <form id="formulario">
            <div class="labelcontainer"><label>Parentesco</label>
                <select id="cboParentesco" name="parentesco">
                    <option>Padre</option><option>Madre</option><option>Conyugue</option>
                    <option>Hermano(a)</option><option>Hijo</option><option>Otro</option>
                </select>
            </div>
            <div class="labelcontainer"><label>Número de Documento</label>
                <input id="txtDni" type="text" name="dni" placeholder="8 dígitos">
            </div>
            <div class="labelcontainer"><label>Género</label>
                <select id="cboSexo" name="genero">
                    <option>Masculino</option><option>Femenino</option><option>Otro</option>
                </select>
            </div>
            <div class="labelcontainer"><label>Apellido Paterno</label>
                <input id="txtApellidoPat" type="text" name="apellidoPat" placeholder="Apellido paterno">
            </div>
            <div class="labelcontainer"><label>Apellido Materno</label>
                <input id="txtApellidoMat" type="text" name="apellidoMat" placeholder="Apellido materno">
            </div>
            <div class="labelcontainer"><label>Nombre Completo</label>
                <input id="txtNombre" type="text" name="nombre" placeholder="Nombres">
            </div>
            <div class="labelcontainer"><label>Fecha de Nacimiento</label>
                <input id="txtfecha" type="date" name="fecha_nacimiento">
            </div>
            <div class="labelcontainer"><label>Correo Electrónico</label>
                <input id="txtCorreo" type="text" name="correo" placeholder="correo@ejemplo.com">
            </div>
            <div class="labelcontainer"><label>Teléfono</label>
                <input id="txtTelefono" type="text" name="telefono" placeholder="Número telefónico">
            </div>
            <div class="labelcontainer"><label>Dirección</label>
                <input id="txtDireccion" type="text" name="direccion" placeholder="Dirección del paciente">
            </div>
            <div class="labelcontainer"><label>Motivo de Consulta</label>
                <input id="txtMotivo" type="text" name="consulta" placeholder="Describe el motivo">
            </div>
            <div id="contenedor-boton">
                <button id="btnProcesarGestion" type="submit">Registrar Paciente</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Editar Paciente -->
<div id="contenedor-formulario-edit-Pac" style="display:none">
    <button type="button" id="cerrar-formulario-edit-pac" class="btn-cerrar"><span>×</span></button>
    <div id="titulo"><strong>Editar Datos Paciente</strong></div>
    <form id="formActualizarPac" method="post">
        <input type="hidden" name="accion" value="actualizarPaciente">
        <div class="labelcontainer"><label>Parentesco</label>
            <select id="cboParentescoPac" name="parentesco">
                <option>Padre</option><option>Madre</option><option>Conyugue</option>
                <option>Hermano(a)</option><option>Hijo</option><option>Otro</option>
            </select>
        </div>
        <div class="labelcontainer"><label>Correo Electrónico</label>
            <input id="txtCorreoPac" type="text" name="correo">
        </div>
        <div class="labelcontainer"><label>Fecha de Nacimiento</label>
            <input id="txtfechaPac" type="date" name="fecha_nacimiento">
        </div>
        <div class="labelcontainer"><label>Teléfono</label>
            <input id="txtTelefonoPac" type="text" name="telefono">
        </div>
        <div class="labelcontainer"><label>Dirección</label>
            <input id="txtDireccionPac" type="text" name="direccion">
        </div>
        <button type="submit" id="actualizarDatosPaciente" class="miBoton">Guardar Cambios</button>
    </form>
</div>

<jsp:include page="items/mensaje_respuesta.jsp"></jsp:include>

<script src="js/gestionPac.js" type="text/javascript" defer></script>
<script>
    document.getElementById('fecha-actual').textContent =
        new Date().toLocaleDateString('es-PE',{weekday:'long',year:'numeric',month:'long',day:'numeric'});

    // Tips carousel
    let currentTip = 0;
    const tips = document.querySelectorAll('.tip-slide');
    const dotsContainer = document.getElementById('tip-dots');
    tips.forEach((_,i)=>{ const d=document.createElement('span'); d.className='tip-dot'+(i===0?' active':''); d.onclick=()=>goToTip(i); dotsContainer.appendChild(d); });
    function goToTip(i){ tips[currentTip].classList.remove('active'); dotsContainer.children[currentTip].classList.remove('active'); currentTip=(i+tips.length)%tips.length; tips[currentTip].classList.add('active'); dotsContainer.children[currentTip].classList.add('active'); }
    function changeTip(d){ goToTip(currentTip+d); }
    setInterval(()=>changeTip(1),6000);

    // Collapsible
    function toggleSection(id,btn){ const b=document.getElementById(id); const a=btn.querySelector('.toggle-arrow'); if(b.classList.contains('section-body-hidden')){ b.classList.remove('section-body-hidden'); if(a){a.classList.add('open');a.innerHTML='&#8963;';} }else{ b.classList.add('section-body-hidden'); if(a){a.classList.remove('open');a.innerHTML='&#8964;';} } }
    function scrollToSection(id){ document.getElementById(id).scrollIntoView({behavior:'smooth'}); }

    // Load stats from backend
    fetch('GestionPacientesServlet?accion=stats')
        .then(r=>r.json())
        .then(d=>{
            document.getElementById('total-citas').textContent = d.totalCitas ?? 0;
            document.getElementById('total-pacientes').textContent = d.totalPacientes ?? 0;
        }).catch(()=>{});

    // Load actividad clinica (last 3 citas)
    fetch('CitasServlet?accion=misCitas')
        .then(r=>r.json())
        .then(citas=>{
            const c = document.getElementById('actividad-clinica-container');
            if(!Array.isArray(citas) || citas.length===0){ 
                c.innerHTML='<div class="history-empty-state"><p>No hay actividad clínica registrada aún.</p></div>'; 
                return; 
            }
            
            const badgeMap = {'reservada':'badge-reservada','completada':'badge-completada','cancelada':'badge-cancelada'};
            c.innerHTML = citas.slice(0,3).map((x, i)=> {
                const motive = (x.motivo && x.motivo !== "false") ? x.motivo : 'Consulta Médica';
                const doc = (x.doctorNombre && x.doctorNombre !== "false") ? x.doctorNombre : '—';
                const esp = (x.especialidad && x.especialidad !== "false") ? x.especialidad : '';
                const date = (x.fecha && x.fecha !== "false") ? x.fecha : '—';
                const pName = (x.pacNombre && x.pacNombre !== "false") ? x.pacNombre : '';
                const pSur = (x.pacApellido && x.pacApellido !== "false") ? x.pacApellido : '';
                const pRel = (x.parentesco && x.parentesco !== "false") ? x.parentesco : '—';
                const status = (x.estado && x.estado !== "false") ? x.estado : '—';

                return '<div class="activity-item floatUp" style="animation-delay: ' + (0.1 * i) + 's">' +
                    '<div class="activity-dot"></div>' +
                    '<div class="activity-info">' +
                        '<span class="activity-title">' + motive + '</span>' +
                        '<span class="activity-meta">Dr. ' + doc + ' &middot; ' + esp + ' &middot; ' + date + '</span>' +
                        '<span class="activity-patient">Paciente: ' + pName + ' ' + pSur + ' (' + pRel + ')</span>' +
                    '</div>' +
                    '<span class="badge ' + (badgeMap[status.toLowerCase()]||'') + '">' + status + '</span>' +
                '</div>';
            }).join('');
        }).catch(()=>{});

    // Update patient counter from table
    const observer=new MutationObserver(()=>{
        const count=document.querySelectorAll('#mi_tabla_citas tbody tr').length;
        document.getElementById('patients-count-badge').textContent=count+' registros';
        const e=document.getElementById('empty-citas');
        if(e) e.style.display=count>0?'none':'flex';
    });
    const tbody=document.querySelector('#mi_tabla_citas tbody');
    if(tbody) observer.observe(tbody,{childList:true});
</script>
</body>
</html>
