<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Usuario" %>
<%
    Usuario _sidebarUser = (Usuario) session.getAttribute("usuarioLogeado");
    if (_sidebarUser == null) { response.sendRedirect("Login.jsp"); return; }
    String _sNombre   = _sidebarUser.getNombre()   != null ? _sidebarUser.getNombre()   : "";
    String _sApellido = _sidebarUser.getApellido() != null ? _sidebarUser.getApellido() : "";
    String _sCorreo   = _sidebarUser.getCorreo()   != null ? _sidebarUser.getCorreo()   : "";
    String _sFoto     = _sidebarUser.getFotoPerfil();
    String _sInitials = "";
    if (!_sNombre.isEmpty())   _sInitials += _sNombre.substring(0,1).toUpperCase();
    if (!_sApellido.isEmpty()) _sInitials += _sApellido.substring(0,1).toUpperCase();
    /* currentPage should be set by the parent JSP before including this file */
    String _activePage = (String) request.getAttribute("currentPage");
    if (_activePage == null) _activePage = "";
%>
<aside class="sidebar collapsed" id="sidebar">
    <div class="sidebar-brand">
        <div class="sidebar-logo">
            <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
        </div>
        <div class="sidebar-brand-text">
            <span class="sidebar-name">Hospira</span>
            <span class="sidebar-tagline">Premium</span>
        </div>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-section-label">Principal</div>
        <a href="GestionPacientes.jsp" class="nav-item <%="_activePage".equals("activePage") ? "" : "" %> <%= "dashboard".equals(_activePage) ? "active" : "" %>" data-tooltip="Panel Principal">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/></svg>
            <span>Panel Principal</span>
        </a>
        <a href="MisCitas.jsp" class="nav-item <%= "citas".equals(_activePage) ? "active" : "" %>" data-tooltip="Mis Citas">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
            <span>Mis Citas</span>
        </a>
        <a href="Pacientes.jsp" class="nav-item <%= "pacientes".equals(_activePage) ? "active" : "" %>" data-tooltip="Pacientes">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
            <span>Pacientes</span>
        </a>

        <div class="nav-section-label">Servicios</div>
        <a href="AgendarCita.jsp" class="nav-item <%= "agendar".equals(_activePage) ? "active" : "" %>" data-tooltip="Agendar Cita">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="M12 5v14"/></svg>
            <span>Agendar Cita</span>
        </a>
    </nav>

    <!-- USER CARD (bottom) -->
    <div class="sidebar-footer">
        <div class="sidebar-user-card" id="sidebar-user-card" onclick="openPerfilPopup()" title="Editar perfil">
            <div class="suc-avatar" id="suc-avatar">
                <% if (_sFoto != null && !_sFoto.isEmpty()) { %>
                    <img src="<%= _sFoto %>" alt="foto" class="suc-avatar-img" />
                <% } else { %>
                    <span class="suc-initials"><%= _sInitials %></span>
                <% } %>
            </div>
            <div class="suc-info">
                <span class="suc-name"><%= _sNombre %> <%= _sApellido %></span>
                <span class="suc-role">Titular</span>
            </div>
            <svg class="suc-arrow" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>
        </div>
        <button type="button" id="btn-cerrar-sesion" class="sidebar-logout" data-tooltip="Cerrar Sesión" onclick="cerrarSesion()">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" x2="9" y1="12" y2="12"/></svg>
            <span>Cerrar Sesi&#243;n</span>
        </button>
    </div>
</aside>

<!-- =================== PERFIL POPUP =================== -->
<div class="perfil-popup-overlay" id="perfil-popup-overlay" onclick="if(event.target===this)closePerfilPopup()">
    <div class="perfil-popup-card" id="perfil-popup-card">
        <button class="perfil-popup-close" onclick="closePerfilPopup()">&#10005;</button>
        <h2 class="perfil-popup-title">Editar Perfil</h2>

        <!-- Avatar con cámara -->
        <div class="perfil-avatar-wrap" onclick="document.getElementById('fotoInput').click()">
            <div class="perfil-avatar-circle" id="popup-avatar-circle">
                <% if (_sFoto != null && !_sFoto.isEmpty()) { %>
                    <img src="<%= _sFoto %>" alt="foto" id="popup-avatar-img" class="popup-avatar-img" />
                <% } else { %>
                    <span class="popup-initials" id="popup-initials"><%= _sInitials %></span>
                <% } %>
            </div>
            <div class="perfil-camera-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3z"/><circle cx="12" cy="13" r="3"/></svg>
            </div>
            <input type="file" id="fotoInput" accept="image/*" style="display:none" onchange="handleFotoChange(event)">
        </div>

        <form id="formPerfilPopup" onsubmit="guardarPerfil(event)">
            <div class="perfil-field-group">
                <div class="perfil-field">
                    <label>Correo</label>
                    <input type="email" id="pop-correo" value="<%= _sCorreo %>" placeholder="correo@ejemplo.com" />
                </div>
                <div class="perfil-field">
                    <label>Peso (kg)</label>
                    <input type="text" id="pop-peso" value="<%= _sidebarUser.getPeso() != null ? _sidebarUser.getPeso() : "" %>" placeholder="Ej: 70" />
                </div>
                <div class="perfil-field">
                    <label>Altura (m)</label>
                    <input type="text" id="pop-altura" value="<%= _sidebarUser.getAltura() != null ? _sidebarUser.getAltura() : "" %>" placeholder="Ej: 1.75" />
                </div>
                <div class="perfil-field">
                    <label>Tipo de Sangre</label>
                    <select id="pop-sangre">
                        <option value="">Seleccione</option>
                        <% String[] _ts = {"A+","A-","O+","O-","B+","B-","AB+","AB-"};
                           String _tsSel = _sidebarUser.getTipoDeSangre() != null ? _sidebarUser.getTipoDeSangre() : "";
                           for (String t : _ts) { %>
                            <option value="<%= t %>" <%= t.equals(_tsSel) ? "selected" : "" %>><%= t %></option>
                        <% } %>
                    </select>
                </div>
            </div>
            <div class="perfil-popup-actions">
                <button type="button" class="btn-popup-cancel" onclick="closePerfilPopup()">Cancelar</button>
                <button type="submit" class="btn-popup-save">Guardar Cambios</button>
            </div>
        </form>
    </div>
</div>

<script>
/* === SIDEBAR TOGGLE === */
document.addEventListener('DOMContentLoaded', function() {
    var toggleBtn = document.getElementById('sidebar-toggle');
    if (toggleBtn) {
        toggleBtn.addEventListener('click', function() {
            document.getElementById('sidebar').classList.toggle('collapsed');
        });
    }

    /* === TOOLTIPS para sidebar colapsado (position:fixed para escapar overflow:hidden) === */
    var tip = document.createElement('div');
    tip.className = 'sidebar-tooltip';
    tip.id = 'sidebar-tooltip-el';
    document.body.appendChild(tip);

    var tipTimeout;
    document.querySelectorAll('[data-tooltip]').forEach(function(el) {
        el.addEventListener('mouseenter', function(e) {
            var sidebar = document.getElementById('sidebar');
            if (!sidebar || !sidebar.classList.contains('collapsed')) return;
            clearTimeout(tipTimeout);
            var rect = el.getBoundingClientRect();
            tip.textContent = el.getAttribute('data-tooltip');
            tip.style.top = (rect.top + rect.height / 2 - 14) + 'px';
            tip.classList.add('visible');
        });
        el.addEventListener('mouseleave', function() {
            tipTimeout = setTimeout(function(){ tip.classList.remove('visible'); }, 100);
        });
    });
});

/* === CERRAR SESIÓN === */
function cerrarSesion() {
    fetch('GestionUsuarioServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ accion: 'cerrarSesion' })
    }).then(function() {
        window.location.href = 'Login.jsp';
    }).catch(function() {
        window.location.href = 'Login.jsp';
    });
}

/* === PERFIL POPUP === */
function openPerfilPopup() {
    document.getElementById('perfil-popup-overlay').classList.add('open');
}
function closePerfilPopup() {
    document.getElementById('perfil-popup-overlay').classList.remove('open');
}

var _pendingFotoBase64 = null;

function handleFotoChange(event) {
    var file = event.target.files[0];
    if (!file) return;
    var reader = new FileReader();
    reader.onload = function(e) {
        _pendingFotoBase64 = e.target.result;
        /* Actualizar preview */
        var circle = document.getElementById('popup-avatar-circle');
        circle.innerHTML = '<img src="' + _pendingFotoBase64 + '" class="popup-avatar-img" />';
    };
    reader.readAsDataURL(file);
}

function guardarPerfil(event) {
    event.preventDefault();
    var correo    = document.getElementById('pop-correo').value;
    var peso      = document.getElementById('pop-peso').value;
    var altura    = document.getElementById('pop-altura').value;
    var tipoSangre = document.getElementById('pop-sangre').value;

    var promises = [];

    /* 1. Guardar datos del perfil */
    promises.push(
        fetch('GestionUsuarioServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ accion: 'actualizarDatos', correo: correo, peso: peso, altura: altura, tipoSangre: tipoSangre })
        }).then(function(r){ return r.json(); })
    );

    /* 2. Guardar foto si hay nueva */
    if (_pendingFotoBase64) {
        promises.push(
            fetch('GestionUsuarioServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ accion: 'actualizarFoto', foto: _pendingFotoBase64 })
            }).then(function(r){ return r.json(); })
            .then(function(d) {
                if (d.status && d.foto) {
                    /* Actualizar avatar en sidebar */
                    var sucAvatar = document.getElementById('suc-avatar');
                    if (sucAvatar) sucAvatar.innerHTML = '<img src="' + d.foto + '" alt="foto" class="suc-avatar-img"/>';
                }
            })
        );
    }

    Promise.all(promises).then(function(results) {
        var first = results[0];
        closePerfilPopup();
        if (typeof mostrarToast === 'function') {
            mostrarToast(first.status ? 'success' : 'error', first.mensaje || 'Perfil actualizado.');
        } else {
            alert(first.mensaje || 'Perfil actualizado.');
        }
        if (first.status) setTimeout(function(){ location.reload(); }, 1200);
    }).catch(function(e) {
        alert('Error al guardar. Int\u00E9ntalo de nuevo.');
    });
}
</script>
