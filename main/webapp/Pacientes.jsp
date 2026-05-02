<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Usuario" %>
<% request.setAttribute("currentPage","pacientes"); %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hospira Premium | Pacientes</title>
    <link rel="stylesheet" href="css/globals.css">
    <link rel="stylesheet" href="css/estilosGestionPac.css">
    <link rel="stylesheet" href="css/shared.css">
    <link rel="stylesheet" href="css/pacientes.css">
</head>
<body>

<%@ include file="items/sidebar.jsp" %>

<div class="main-layout" id="Contenedor">

    <% 
        request.setAttribute("pageTitle", "Pacientes"); 
        request.setAttribute("pageSubtitle", "Gestión completa de los pacientes registrados");
        request.setAttribute("headerActionHtml", "");
    %>
    <%@ include file="items/topheader.jsp" %>

    <div class="page-body">
        <div class="pac-header" style="display:flex; align-items:center; justify-content:space-between; margin-bottom: 20px;">
            <div>
                <h1 style="font-size:1.15rem;margin:0;">Lista de Pacientes</h1>
                <span class="pac-count" id="pac-count">0 registros</span>
            </div>
            <button class="btn-primary-action" id="miBoton" style="font-size:.82rem;padding:9px 16px;">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="margin-right:6px;"><path d="M5 12h14"/><path d="M12 5v14"/></svg>
                Registrar Paciente
            </button>
        </div>

        <div class="pac-table-wrap">
            <div class="citas-loading" id="pac-loading">Cargando pacientes...</div>
            <table class="pac-table" id="pac-table" style="display:none">
                <thead>
                    <tr>
                        <th>Nombre Completo</th>
                        <th>Parentesco</th>
                        <th>DNI</th>
                        <th>Género</th>
                        <th>Teléfono</th>
                        <th>Correo</th>
                        <th>Motivo</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody id="pac-tbody"></tbody>
            </table>
            <div class="pac-empty" id="pac-empty" style="display:none">
                <svg xmlns="http://www.w3.org/2000/svg" width="52" height="52" viewBox="0 0 24 24" fill="none" stroke="#475569" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                <p>No hay pacientes registrados</p>
                <span>Usa el botón "Registrar Paciente" para agregar uno.</span>
            </div>
        </div>
    </div>
</div>

<!-- Modal: Registrar Paciente (reutilizado de GestionPacientes) -->
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

<!-- Reutiliza el mismo gestionPac.js (maneja miBoton, cerrar-formulario, fetch pacientes, editar, eliminar) -->
<script src="js/gestionPac.js" type="text/javascript" defer></script>
<script>
    /* Override renderPacientes para usar esta tabla */
    window._pacientesPageMode = true;

    /* Cargar pacientes al iniciar */
    document.addEventListener('DOMContentLoaded', function() {
        cargarPacientesTabla();
    });

    function cargarPacientesTabla() {
        fetch('GestionPacientesServlet?accion=pacientes')
            .then(function(r){ return r.json(); })
            .then(function(data) {
                renderPacientesFullTable(data);
            }).catch(function(){ });
    }

    function renderPacientesFullTable(pacs) {
        var loading = document.getElementById('pac-loading');
        var table   = document.getElementById('pac-table');
        var empty   = document.getElementById('pac-empty');
        var tbody   = document.getElementById('pac-tbody');
        var count   = document.getElementById('pac-count');

        loading.style.display = 'none';

        if (!pacs || pacs.length === 0) {
            table.style.display = 'none';
            empty.style.display = 'block';
            count.textContent   = '0 registros';
            return;
        }

        count.textContent = pacs.length + ' registros';
        table.style.display = 'table';
        empty.style.display = 'none';

        tbody.innerHTML = pacs.map(function(p) {
            var nombre = (p.Nombre||p.nombre||'') + ' ' + (p.ApellidoPat||p.apellidoPat||'');
            var dni = (p.DNI||p.dni||'');
            return '<tr>' +
                '<td>' + nombre.trim() + '</td>' +
                '<td><span class="par-badge">' + (p.Parentesco||p.parentesco||'—') + '</span></td>' +
                '<td>' + dni + '</td>' +
                '<td>' + (p.Genero||p.genero||'—') + '</td>' +
                '<td>' + (p.Telefono||p.telefono||'—') + '</td>' +
                '<td>' + (p.Correo||p.correo||'—') + '</td>' +
                '<td>' + (p.Motivo_consulta||p.motivo||'—') + '</td>' +
                '<td>' +
                    '<button class="btn-tbl btn-tbl-edit btn-accion-pacienes btn-editar" data-dni="' + dni + '">✏️ Editar</button> ' +
                    '<button class="btn-tbl btn-tbl-del btn-accion-pacienes btn-eliminar" data-dni="' + dni + '">🗑️ Eliminar</button>' +
                '</td>' +
            '</tr>';
        }).join('');
    }
</script>
</body>
</html>
