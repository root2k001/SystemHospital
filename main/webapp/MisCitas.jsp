<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.Usuario" %>
<% request.setAttribute("currentPage","citas"); %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hospira Premium | Mis Citas</title>
    <link rel="stylesheet" href="css/globals.css">
    <link rel="stylesheet" href="css/estilosGestionPac.css">
    <link rel="stylesheet" href="css/shared.css">
    <link rel="stylesheet" href="css/misCitas.css">
</head>
<body>

<%@ include file="items/sidebar.jsp" %>

<div class="main-layout" id="Contenedor">

    <% 
        request.setAttribute("pageTitle", "Mis Citas"); 
        request.setAttribute("pageSubtitle", "Historial y seguimiento de todas tus consultas médicas");
        request.setAttribute("headerActionHtml", "");
    %>
    <%@ include file="items/topheader.jsp" %>

    <div class="page-body">

        <!-- FILTER BAR -->
        <div class="citas-filter-bar" id="filter-bar" style="display:flex; align-items:center; justify-content:space-between;">
            <div style="display:flex; gap:8px;">
                <button class="filter-chip active" onclick="filtrar('todas',this)">Todas</button>
                <button class="filter-chip" onclick="filtrar('reservada',this)">Reservadas</button>
                <button class="filter-chip" onclick="filtrar('completada',this)">Completadas</button>
                <button class="filter-chip" onclick="filtrar('cancelada',this)">Canceladas</button>
            </div>
            <button class="btn-primary-action" onclick="window.location.href='AgendarCita.jsp'" style="font-size:.82rem;padding:8px 16px;">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="margin-right:6px;"><path d="M5 12h14"/><path d="M12 5v14"/></svg>
                Agendar Nueva Cita
            </button>
        </div>

        <!-- CITAS TABLE -->
        <div class="citas-table-wrap" id="tabla-wrap">
            <div class="citas-loading" id="citas-loading">Cargando citas...</div>
            <table class="citas-table" id="citas-table" style="display:none">
                <thead>
                    <tr>
                        <th>Código</th>
                        <th>Fecha / Hora</th>
                        <th>Doctor</th>
                        <th>Especialidad</th>
                        <th>Paciente</th>
                        <th>Motivo</th>
                        <th>Estado</th>
                        <th>Pago</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody id="citas-tbody"></tbody>
            </table>
            <div class="citas-empty" id="citas-empty" style="display:none">
                <svg xmlns="http://www.w3.org/2000/svg" width="52" height="52" viewBox="0 0 24 24" fill="none" stroke="#475569" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
                <p>No hay citas que coincidan con el filtro</p>
                <span>Agenda una nueva cita o cambia el filtro.</span>
            </div>
        </div>

        <!-- HISTORIAL TIMELINE -->
        <div class="historial-section">
            <h2 class="historial-title">Historial Clínico Completo</h2>
            <div class="timeline" id="timeline-container">
                <div class="citas-loading">Cargando historial...</div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="items/mensaje_respuesta.jsp"></jsp:include>

<!-- MODAL BOLETA -->
<div id="modal-boleta" class="modal-overlay" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.5); z-index:9999; backdrop-filter:blur(4px); display:none; align-items:center; justify-content:center;">
    <div class="boleta-container floatUp" style="background:white; width:90%; max-width:500px; border-radius:16px; overflow:hidden; box-shadow:0 25px 50px -12px rgba(0,0,0,0.25); position:relative;">
        <!-- Header Decor -->
        <div style="background:linear-gradient(135deg, #0F172A 0%, #1e293b 100%); padding:24px; color:white; text-align:center;">
            <div style="display:flex; justify-content:center; margin-bottom:12px;">
                <div style="width:40px; height:40px; background:rgba(255,255,255,0.1); border-radius:10px; display:flex; align-items:center; justify-content:center;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                </div>
            </div>
            <h3 style="margin:0; font-family:'Poppins'; font-weight:600; font-size:1.25rem;">Hospira Premium</h3>
            <p style="margin:4px 0 0; opacity:0.8; font-size:0.75rem; text-transform:uppercase; letter-spacing:1px;">Comprobante de Cita Médica</p>
        </div>

        <!-- Content -->
        <div id="boleta-content" style="padding:32px; font-family:'Inter'; color:#1E293B;">
            <div style="display:flex; justify-content:space-between; margin-bottom:24px; border-bottom:1px dashed #E2E8F0; padding-bottom:16px;">
                <div>
                    <span style="display:block; font-size:0.7rem; color:#64748B; text-transform:uppercase; font-weight:700;">Código de Cita</span>
                    <strong id="b-codigo" style="font-size:1.1rem; color:#0284C7;">-</strong>
                </div>
                <div style="text-align:right;">
                    <span style="display:block; font-size:0.7rem; color:#64748B; text-transform:uppercase; font-weight:700;">Fecha de Emisión</span>
                    <span id="b-emision" style="font-size:0.85rem;">-</span>
                </div>
            </div>

            <div style="margin-bottom:20px;">
                <h4 style="margin:0 0 12px; font-size:0.8rem; color:#0284C7; text-transform:uppercase; letter-spacing:0.5px;">Detalles del Paciente</h4>
                <div style="background:#F8FAFC; padding:12px; border-radius:8px; font-size:0.9rem;">
                    <p style="margin:0 0 4px;"><strong>Nombre:</strong> <span id="b-paciente">-</span></p>
                    <p style="margin:0;"><strong>Parentesco:</strong> <span id="b-parentesco">-</span></p>
                </div>
            </div>

            <div style="margin-bottom:20px;">
                <h4 style="margin:0 0 12px; font-size:0.8rem; color:#0284C7; text-transform:uppercase; letter-spacing:0.5px;">Información Médica</h4>
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                    <div style="background:#F0F9FF; padding:12px; border-radius:8px; font-size:0.85rem;">
                        <span style="display:block; color:#0369A1; font-size:0.65rem; font-weight:700; text-transform:uppercase;">Especialista</span>
                        <span id="b-doctor" style="font-weight:600;">-</span>
                    </div>
                    <div style="background:#F0F9FF; padding:12px; border-radius:8px; font-size:0.85rem;">
                        <span style="display:block; color:#0369A1; font-size:0.65rem; font-weight:700; text-transform:uppercase;">Especialidad</span>
                        <span id="b-especialidad" style="font-weight:600;">-</span>
                    </div>
                </div>
                <div style="background:#F8FAFC; padding:12px; border-radius:8px; font-size:0.9rem; margin-top:12px;">
                    <p style="margin:0 0 4px;"><strong>Fecha de Cita:</strong> <span id="b-fecha">-</span></p>
                    <p style="margin:0;"><strong>Motivo:</strong> <span id="b-motivo">-</span></p>
                </div>
            </div>

            <div style="text-align:center; padding-top:20px; border-top:1px solid #F1F5F9;">
                <div id="b-qr" style="width:80px; height:80px; background:#F1F5F9; margin:0 auto 12px; display:flex; align-items:center; justify-content:center; border-radius:8px;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#94A3B8" stroke-width="1.5"><rect width="5" height="5" x="3" y="3" rx="1"/><rect width="5" height="5" x="16" y="3" rx="1"/><rect width="5" height="5" x="3" y="16" rx="1"/><path d="M21 16h-3a2 2 0 0 0-2 2v3"/><path d="M21 21v.01"/><path d="M12 7v3a2 2 0 0 1-2 2H7"/><path d="M3 12h.01"/><path d="M12 3h.01"/><path d="M12 16h.01"/><path d="M16 12h1"/><path d="M21 12v.01"/><path d="M12 21v-1"/></svg>
                </div>
                <p style="font-size:0.7rem; color:#94A3B8; margin:0;">Este documento es un comprobante oficial de reserva.<br>Presentar en recepción 15 minutos antes de su cita.</p>
            </div>
        </div>

        <!-- Footer Buttons -->
        <div style="padding:16px 32px 32px; display:flex; gap:12px;">
            <button onclick="cerrarBoleta()" style="flex:1; background:#F1F5F9; color:#475569; border:none; padding:12px; border-radius:8px; cursor:pointer; font-weight:600; font-size:0.9rem; transition:background 0.2s;">Cerrar</button>
            <button onclick="imprimirBoleta()" style="flex:1; background:#0284C7; color:white; border:none; padding:12px; border-radius:8px; cursor:pointer; font-weight:600; font-size:0.9rem; display:flex; align-items:center; justify-content:center; gap:8px; box-shadow:0 4px 6px -1px rgba(2, 132, 199, 0.3);">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 6 2 18 2 18 9"></polyline><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect width="12" height="8" x="6" y="14"></rect></svg>
                Imprimir
            </button>
        </div>
    </div>
</div>

<style>
@media print {
    body * { visibility: hidden; }
    #modal-boleta, #modal-boleta * { visibility: visible; }
    #modal-boleta { position: absolute !important; left: 0 !important; top: 0 !important; background: white !important; display: flex !important; width: 100% !important; height: auto !important; }
    #modal-boleta .modal-overlay { background: white !important; backdrop-filter: none !important; }
    .boleta-container { box-shadow: none !important; border: 1px solid #E2E8F0 !important; width: 100% !important; max-width: 100% !important; margin: 0 !important; }
    button { display: none !important; }
}
</style>


<script>
var _todasCitas = [];

document.addEventListener('DOMContentLoaded', function() {
    cargarCitas();
});

function cargarCitas() {
    fetch('CitasServlet?accion=misCitas')
        .then(r => r.json())
        .then(data => {
            _todasCitas = Array.isArray(data) ? data : [];
            renderTabla(_todasCitas);
            renderTimeline(_todasCitas);
        })
        .catch(function(e) {
            document.getElementById('citas-loading').textContent = 'Error al cargar las citas.';
        });
}

function renderTabla(citas) {
    var loading = document.getElementById('citas-loading');
    var table   = document.getElementById('citas-table');
    var empty   = document.getElementById('citas-empty');
    var tbody   = document.getElementById('citas-tbody');

    loading.style.display = 'none';

    if (!citas || citas.length === 0) {
        table.style.display = 'none';
        empty.style.display = 'block';
        return;
    }

    table.style.display = 'table';
    empty.style.display = 'none';

    var badgeMap = { 'reservada':'badge-reservada', 'completada':'badge-completada', 'cancelada':'badge-cancelada' };
    var pagoMap  = { 'inmediato':'badge-inmediato', 'diferido':'badge-diferido' };

    tbody.innerHTML = citas.map(function(c) {
        var estadoBadge = badgeMap[(c.estado||'').toLowerCase()] || '';
        var pagoBadge   = pagoMap[(c.metodoPago||'').toLowerCase()] || '';
        var accionHTML = '<div style="display:flex; gap:4px; align-items:center;">';
        if ((c.estado||'').toLowerCase() === 'reservada') {
            accionHTML += '<button class="btn-cancelar" onclick="cancelarCita(\'' + c.codigo + '\')" style="background-color: #EF4444; color: white; border: none; padding: 4px 8px; border-radius: 4px; cursor: pointer; font-size: 0.75rem;">Cancelar</button>';
        } else if ((c.estado||'').toLowerCase() === 'cancelada') {
            accionHTML += '<span style="color:#94A3B8; font-size:0.75rem; margin-right:4px;">N/A</span>';
        }

        if ((c.estado||'').toLowerCase() !== 'cancelada') {
            accionHTML += '<button onclick="descargarBoleta(\'' + c.codigo + '\')" class="btn-action-view" style="background: rgba(2, 132, 199, 0.1); color: #0284C7; border: 1px solid rgba(2, 132, 199, 0.2); padding: 4px 10px; border-radius: 6px; cursor: pointer; font-size: 0.75rem; display:flex; align-items:center; gap:6px; font-weight:500; transition:all 0.2s;" title="Descargar Boleta de Cita">' +
                '<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg> Boleta</button>';
        }
        accionHTML += '</div>';
        return '<tr>' +
            '<td><span class="codigo-tag">' + (c.codigo||'—') + '</span></td>' +
            '<td>' + (c.fecha||'—') + '<br><small style="color:#64748B">' + (c.hora||'') + '</small></td>' +
            '<td>Dr. ' + (c.doctorNombre||'—') + '</td>' +
            '<td>' + (c.especialidad||'—') + '</td>' +
            '<td>' + (c.pacNombre||'') + ' ' + (c.pacApellido||'') + '<br><small style="color:#64748B">' + (c.parentesco||'') + '</small></td>' +
            '<td>' + (c.motivo||'—') + '</td>' +
            '<td><span class="badge ' + estadoBadge + '">' + (c.estado||'—') + '</span></td>' +
            '<td><span class="badge ' + pagoBadge + '">' + (c.metodoPago||'—') + '</span></td>' +
            '<td>' + accionHTML + '</td>' +
            '</tr>';
    }).join('');
}

function cancelarCita(codigo) {
    if (!confirm('¿Estás seguro de que deseas cancelar la cita ' + codigo + '?')) return;
    
    fetch('CitasServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ accion: 'cancelarCita', codigo: codigo })
    })
    .then(r => r.json())
    .then(res => {
        if (res.estado) {
            mostrarMensaje(res.mensaje, 'exito');
            cargarCitas(); // Recargar la lista
        } else {
            mostrarMensaje(res.mensaje || 'Error al cancelar la cita.', 'error');
        }
    })
    .catch(e => mostrarMensaje('Error de red al cancelar.', 'error'));
}

function renderTimeline(citas) {
    var container = document.getElementById('timeline-container');
    if (!citas || citas.length === 0) {
        container.innerHTML = '<div class="citas-empty" style="border:none"><p>No hay historial clínico disponible.</p></div>';
        return;
    }
    container.innerHTML = citas.map(function(c) {
        return '<div class="timeline-item">' +
            '<div class="timeline-content">' +
                '<div class="timeline-header">' +
                    '<span class="timeline-codigo">' + (c.codigo||'—') + '</span>' +
                    '<span class="timeline-fecha">' + (c.fecha||'—') + ' ' + (c.hora||'') + '</span>' +
                '</div>' +
                '<div class="timeline-motivo">' + (c.motivo||'Consulta Médica') + '</div>' +
                '<div class="timeline-meta">' +
                    'Dr. ' + (c.doctorNombre||'—') + ' · ' + (c.especialidad||'') +
                    ' | Paciente: ' + (c.pacNombre||'') + ' ' + (c.pacApellido||'') +
                    ' · Pago: ' + (c.metodoPago||'—') +
                '</div>' +
            '</div>' +
        '</div>';
    }).join('');
}

function filtrar(estado, btn) {
    document.querySelectorAll('.filter-chip').forEach(function(c){ c.classList.remove('active'); });
    btn.classList.add('active');

    var filtrado = estado === 'todas'
        ? _todasCitas
        : _todasCitas.filter(function(c){ return (c.estado||'').toLowerCase() === estado; });

    document.getElementById('citas-loading').style.display = 'none';
    renderTabla(filtrado);
}

function descargarBoleta(codigo) {
    const cita = _todasCitas.find(c => c.codigo === codigo);
    if (!cita) {
        mostrarMensaje('No se encontró información para esta cita.', 'error');
        return;
    }

    // Llenar campos de la boleta
    document.getElementById('b-codigo').textContent = cita.codigo || '—';
    document.getElementById('b-emision').textContent = new Date().toLocaleDateString('es-PE', { day:'2-digit', month:'2-digit', year:'numeric', hour:'2-digit', minute:'2-digit' });
    document.getElementById('b-paciente').textContent = (cita.pacNombre || '') + ' ' + (cita.pacApellido || '');
    document.getElementById('b-parentesco').textContent = cita.parentesco || '—';
    document.getElementById('b-doctor').textContent = 'Dr. ' + (cita.doctorNombre || '—');
    document.getElementById('b-especialidad').textContent = cita.especialidad || '—';
    document.getElementById('b-fecha').textContent = (cita.fecha || '—') + ' a las ' + (cita.hora || '');
    document.getElementById('b-motivo').textContent = cita.motivo || '—';

    // Mostrar modal
    const modal = document.getElementById('modal-boleta');
    modal.style.display = 'flex';
    document.body.style.overflow = 'hidden';
}

function cerrarBoleta() {
    document.getElementById('modal-boleta').style.display = 'none';
    document.body.style.overflow = 'auto';
}

function imprimirBoleta() {
    window.print();
}

</script>
</body>
</html>
