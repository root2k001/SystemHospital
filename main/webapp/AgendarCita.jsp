<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="models.Usuario" %>
<%@ page import="dao.PacienteDao" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogeado");
    if (usuario == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    // Load patient list for this user
    List<Map<String, Object>> pacientes = null;
    try {
        pacientes = PacienteDao.obtenerTodosLosPacientes(usuario.getId());
    } catch (Exception e) {
        pacientes = new java.util.ArrayList<>();
    }

    // Build JSON for patients (excluding Titular)
    StringBuilder pacientesJson = new StringBuilder("[");
    int countFamiliares = 0;
    if (pacientes != null) {
        for (int i = 0; i < pacientes.size(); i++) {
            Map<String, Object> p = pacientes.get(i);
            String parentesco = String.valueOf(p.getOrDefault("parentesco",""));
            if ("Titular".equalsIgnoreCase(parentesco)) continue;
            
            if (countFamiliares > 0) pacientesJson.append(",");
            pacientesJson.append("{");
            pacientesJson.append("\"id\":").append(p.getOrDefault("id","0")).append(",");
            pacientesJson.append("\"nombre\":\"").append(escapeJs(String.valueOf(p.getOrDefault("nombre","")))).append("\",");
            pacientesJson.append("\"apellidoPat\":\"").append(escapeJs(String.valueOf(p.getOrDefault("apellidoPat","")))).append("\",");
            pacientesJson.append("\"apellidoMat\":\"").append(escapeJs(String.valueOf(p.getOrDefault("apellidoMat","")))).append("\",");
            pacientesJson.append("\"DNI\":\"").append(escapeJs(String.valueOf(p.getOrDefault("DNI","")))).append("\",");
            pacientesJson.append("\"correo\":\"").append(escapeJs(String.valueOf(p.getOrDefault("correo","")))).append("\",");
            pacientesJson.append("\"parentesco\":\"").append(escapeJs(parentesco)).append("\"");
            pacientesJson.append("}");
            countFamiliares++;
        }
    }
    pacientesJson.append("]");
%>
<%!
    private String escapeJs(String s) {
        if (s == null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n").replace("\r","\\r");
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hospira Premium | Agendar Cita Médica</title>
    <meta name="description" content="Reserva tu cita médica en Hospira Premium. Selecciona especialidad, médico y horario disponible.">
    <link rel="stylesheet" href="css/globals.css">
    <link rel="stylesheet" href="css/estilosGestionPac.css">
    <link rel="stylesheet" href="css/shared.css">
    <link rel="stylesheet" href="css/agendarCita.css">
</head>
<body>
<% request.setAttribute("currentPage","agendar"); %>

<%@ include file="items/sidebar.jsp" %>

<!-- =================== MAIN LAYOUT =================== -->
<div class="main-layout" id="Contenedor">

    <!-- TOP HEADER -->
    <% 
        request.setAttribute("pageTitle", "Agendar Cita Médica"); 
        request.setAttribute("pageSubtitle", "Asistente de reserva de consultas médicas");
    %>
    <%@ include file="items/topheader.jsp" %>

    <!-- WIZARD PAGE BODY -->
    <main class="wizard-page">

        <!-- Page header -->
        <div class="wizard-header">
            <h1>&#128197; Agendar Cita M&eacute;dica</h1>
            <p>Reserva una consulta con nuestros especialistas. Proceso rápido y sencillo en 5 pasos.</p>
        </div>

        <!-- ======== STEPPER ======== -->
        <div class="stepper">
            <div class="stepper-line"></div>
            <div class="stepper-line-progress" id="stepper-progress-line" style="width:0%"></div>
            <div class="stepper-steps">
                <div class="stepper-step active" id="stepper-step-1">
                    <div class="step-circle active"><span class="step-number">1</span></div>
                    <div class="step-label">&iquest;Para qui&eacute;n?</div>
                </div>
                <div class="stepper-step" id="stepper-step-2">
                    <div class="step-circle"><span class="step-number">2</span></div>
                    <div class="step-label">Especialidad</div>
                </div>
                <div class="stepper-step" id="stepper-step-3">
                    <div class="step-circle"><span class="step-number">3</span></div>
                    <div class="step-label">M&eacute;dico</div>
                </div>
                <div class="stepper-step" id="stepper-step-4">
                    <div class="step-circle"><span class="step-number">4</span></div>
                    <div class="step-label">Confirmaci&oacute;n</div>
                </div>
                <div class="stepper-step" id="stepper-step-5">
                    <div class="step-circle"><span class="step-number">5</span></div>
                    <div class="step-label">¡Listo!</div>
                </div>
            </div>
        </div>

        <!-- ======== WIZARD CARD ======== -->
        <div class="wizard-card">

            <!-- ====== STEP 1: ¿Para quién? ====== -->
            <div class="step-panel active" id="step-1">
                <div class="wizard-card-header">
                    <div class="step-indicator-badge">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        Paso 1 de 5
                    </div>
                    <h2>&iquest;Para qui&eacute;n es la cita?</h2>
                    <p>Selecciona si la consulta es para ti mismo o para un familiar o conocido registrado.</p>
                </div>
                <div class="wizard-card-body">

                    <div class="patient-type-grid">
                        <!-- Titular -->
                        <div class="patient-type-card" id="card-titular">
                            <div class="card-icon-wrap primary-bg">
                                <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                                </svg>
                            </div>
                            <h3>Para m&iacute;</h3>
                            <p>La cita es para ti como titular de la cuenta. Se usar&aacute;n tus datos de perfil.</p>
                            <span class="badge badge-primary" style="margin-top:4px;">
                                <%= usuario.getNombre() %> <%= usuario.getApellido() %>
                            </span>
                        </div>

                        <!-- Familiar -->
                        <div class="patient-type-card" id="card-familiar">
                            <div class="card-icon-wrap accent-bg">
                                <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/>
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                                </svg>
                            </div>
                            <h3>Para familiar / conocido</h3>
                            <p>Agenda la cita para alguien registrado como tu paciente en el sistema.</p>
                            <span class="badge badge-primary" style="margin-top:4px; background:var(--accent-light); color:#0E7490;">
                                <%= countFamiliares %> paciente(s) registrado(s)
                            </span>
                        </div>
                    </div>

                    <!-- Familiar selector (shown when 'familiar' is picked) -->
                    <div class="familiar-selector" id="familiar-selector">
                        <div class="familiar-selector-card">
                            <h3>
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2.5" style="flex-shrink:0"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                                Selecciona el paciente
                            </h3>
                            <div class="paciente-list" id="pacientes-list"></div>
                        </div>
                    </div>

                </div>
                <div class="wizard-card-footer">
                    <span style="font-size:0.8rem; color:var(--text-muted);">
                        &#128161; Si el familiar no est&aacute; en la lista, <a href="Pacientes.jsp" style="color:var(--primary); font-weight:600;">reg&iacute;stralo primero</a>.
                    </span>
                    <button class="btn btn-primary" id="btn-next">Continuar &rarr;</button>
                </div>
            </div>

            <!-- ====== STEP 2: ESPECIALIDAD ====== -->
            <div class="step-panel" id="step-2">
                <div class="wizard-card-header">
                    <div class="step-indicator-badge">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
                        Paso 2 de 5
                    </div>
                    <h2>Selecciona la Especialidad</h2>
                    <p>Elige la rama m&eacute;dica que mejor se adapte a tu consulta. Cada especialidad tiene m&eacute;dicos dedicados.</p>
                </div>
                <div class="wizard-card-body">
                    <div class="specialty-grid" id="specialty-grid">
                        <!-- Rendered by JS -->
                    </div>
                </div>
                <div class="wizard-card-footer">
                    <button class="btn btn-outline" id="btn-prev">← Anterior</button>
                    <button class="btn btn-primary" id="btn-next-2" onclick="
                        if(!window.STATE || !STATE.especialidadSeleccionada){ window.showWizardNotify('!','Especialidad requerida','Por favor selecciona una especialidad m\u00E9dica.'); return; }
                        window.cargarDoctores(STATE.especialidadSeleccionada);
                        window.goToStep(3);
                    ">Continuar &rarr;</button>
                </div>
            </div>

            <!-- ====== STEP 3: MÉDICO Y HORARIO ====== -->
            <div class="step-panel" id="step-3">
                <div class="wizard-card-header">
                    <div class="step-indicator-badge">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        Paso 3 de 5
                    </div>
                    <h2>Selecciona M&eacute;dico y Horario</h2>
                    <p>Elige el m&eacute;dico de tu preferencia y un horario disponible. Los horarios en rojo ya est&aacute;n reservados.</p>
                </div>
                <div class="wizard-card-body">
                    <div class="step3-layout">

                        <!-- LEFT: Doctors -->
                        <div class="doctors-panel">
                            <h3>
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2.5"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                M&eacute;dicos disponibles
                                <span class="panel-subtitle" id="doctors-specialty-label"></span>
                            </h3>
                            <div class="doctors-list" id="doctors-list">
                                <p class="text-muted" style="text-align:center;padding:24px;font-size:0.85rem;">Cargando médicos...</p>
                            </div>
                        </div>

                        <!-- RIGHT: Schedule -->
                        <div class="schedule-panel">
                            <h3>
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2.5"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
                                Horarios disponibles
                            </h3>

                            <!-- No doctor selected state -->
                            <div class="no-doctor-selected" id="no-doctor-selected">
                                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#CBD5E1" stroke-width="1.5"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
                                <p>Selecciona un m&eacute;dico para ver sus horarios disponibles.</p>
                            </div>

                            <!-- Calendar (shown when doctor is selected) -->
                            <div class="calendar-wrapper" id="calendar-wrapper" style="display:none">
                                <!-- Week navigation -->
                                <div class="week-nav">
                                    <button class="week-nav-btn" id="btn-prev-week" title="Semana anterior">‹</button>
                                    <span class="week-label" id="week-label">—</span>
                                    <button class="week-nav-btn" id="btn-next-week" title="Siguiente semana">›</button>
                                </div>

                                <!-- Day tabs -->
                                <div class="days-tabs" id="days-tabs"></div>

                                <!-- Time slots legend -->
                                <div style="display:flex; gap:12px; align-items:center; flex-wrap:wrap; margin-bottom:4px;">
                                    <span style="font-size:0.72rem; color:var(--text-muted); font-weight:600; display:flex; align-items:center; gap:4px;">
                                        <span style="width:12px;height:12px;background:var(--primary);border-radius:3px;display:inline-block;"></span> Disponible
                                    </span>
                                    <span style="font-size:0.72rem; color:var(--text-muted); font-weight:600; display:flex; align-items:center; gap:4px;">
                                        <span style="width:12px;height:12px;background:rgba(239,68,68,0.15);border-radius:3px;display:inline-block;border:1px solid rgba(239,68,68,0.3);"></span> Ocupado
                                    </span>
                                    <span style="font-size:0.72rem; color:var(--text-muted); font-weight:600; display:flex; align-items:center; gap:4px;">
                                        <span style="width:12px;height:12px;background:var(--primary);border-radius:3px;display:inline-block;box-shadow:0 0 0 2px rgba(2,132,199,0.3);"></span> Seleccionado
                                    </span>
                                </div>

                                <!-- Slots -->
                                <div class="slots-grid" id="slots-grid"></div>
                            </div>
                        </div>

                    </div>
                </div>
                <div class="wizard-card-footer">
                    <button class="btn btn-outline" onclick="window.goToStep(2,'back')">&larr; Anterior</button>
                    <button class="btn btn-primary" id="btn-next-3" onclick="
                        if(!STATE.doctorSeleccionado){ window.showWizardNotify('!','M\u00E9dico requerido','Por favor selecciona un m\u00E9dico de la lista.'); return; }
                        if(!STATE.fechaSeleccionada||!STATE.horaSeleccionada){ window.showWizardNotify('!','Horario requerido','Por favor selecciona una fecha y hora disponible.'); return; }
                        window.renderConfirmation();
                        window.goToStep(4);
                    ">Continuar a Confirmaci&oacute;n &rarr;</button>
                </div>
            </div>

            <!-- ====== STEP 4: CONFIRMACIÓN Y PAGO ====== -->
            <div class="step-panel" id="step-4">
                <div class="wizard-card-header">
                    <div class="step-indicator-badge">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                        Paso 4 de 5
                    </div>
                    <h2>Confirma tu Cita y Elige el Pago</h2>
                    <p>Revisa los detalles de tu reserva y elige tu m&eacute;todo de pago preferido.</p>
                </div>
                <div class="wizard-card-body">
                    <div class="confirmation-layout">

                        <!-- Summary -->
                        <div class="confirmation-summary">
                            <h3>
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2.5"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                                Resumen de la Cita
                            </h3>
                            <div id="confirmation-summary-rows">
                                <!-- Rendered by renderConfirmation() -->
                            </div>
                        </div>

                        <!-- Payment -->
                        <div class="payment-card">
                            <div class="payment-card-header">
                                <h3>&#128179; Pago de Consulta</h3>
                                <p>Elige tu m&eacute;todo de pago preferido</p>
                            </div>

                            <div class="price-display">
                                <div class="price-label">Total a pagar (incluye IGV 18%)</div>
                                <div class="price-amount" id="price-amount">
                                    <span class="currency">S/. </span>0.00
                                </div>
                                <div class="price-detail" id="price-detail">Calculando...</div>
                            </div>

                            <div class="payment-methods">
                                <div class="payment-method-label">M&eacute;todo de pago</div>

                                <button class="btn-pay-now" id="btn-pay-now">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5"><rect width="20" height="14" x="2" y="5" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></svg>
                                    Pagar Ahora (Online)
                                </button>

                                <div class="pay-divider">&mdash; &oacute; &mdash;</div>

                                <button class="btn-pay-later" id="btn-pay-later">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                                    Pagar el d&iacute;a de la cita
                                </button>

                                <div class="payment-badge">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                                    Reserva instantánea y segura
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <div class="wizard-card-footer">
                    <button class="btn btn-outline" onclick="window.goToStep(3,'back')">&larr; Anterior</button>
                    <span style="font-size:0.78rem; color:var(--text-muted);">Al continuar, aceptas nuestras políticas de cancelación.</span>
                </div>
            </div>

            <!-- ====== STEP 5: ÉXITO ====== -->
            <div class="step-panel" id="step-5">
                <div class="wizard-card-header" style="background:linear-gradient(135deg,rgba(16,185,129,0.06),rgba(52,211,153,0.03));">
                    <div class="step-indicator-badge" style="background:var(--success-light);color:var(--success);">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
                        &iexcl;Cita Confirmada!
                    </div>
                    <h2 style="color:var(--success);">Tu reserva fue registrada exitosamente</h2>
                    <p>Recibirás toda la información en el correo registrado en tu perfil.</p>
                </div>
                <div class="wizard-card-body">
                    <div class="success-layout">

                        <!-- Success Icon -->
                        <div class="success-icon-wrap">
                            <div class="success-rings"></div>
                            <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"
                                 style="stroke-dasharray:100; stroke-dashoffset:0;">
                                <polyline points="20 6 9 17 4 12"/>
                            </svg>
                        </div>

                        <!-- Title -->
                        <div class="success-text">
                            <h2>&iexcl;Cita Agendada! &#127881;</h2>
                            <p>Tu cita médica ha sido reservada exitosamente. Guarda tu código de reserva para cualquier consulta o cambio.</p>
                        </div>

                        <!-- Reservation Code -->
                        <div class="success-code">
                            <label>C&oacute;digo de Reserva</label>
                            <span id="success-code-val">—</span>
                        </div>

                        <!-- Details Grid -->
                        <div class="success-details-grid">
                            <div class="success-detail-card">
                                <span class="detail-icon">&#128104;&#8205;&#9877;&#65039;</span>
                                <div class="detail-label">M&eacute;dico</div>
                                <div class="detail-value" id="success-doc">&mdash;</div>
                            </div>
                            <div class="success-detail-card">
                                <span class="detail-icon">&#128197;</span>
                                <div class="detail-label">Fecha</div>
                                <div class="detail-value" id="success-fecha">&mdash;</div>
                            </div>
                            <div class="success-detail-card">
                                <span class="detail-icon">&#128336;</span>
                                <div class="detail-label">Hora</div>
                                <div class="detail-value" id="success-hora">&mdash;</div>
                            </div>
                            <div class="success-detail-card">
                                <span class="detail-icon">&#128179;</span>
                                <div class="detail-label">Estado de Pago</div>
                                <div class="detail-value" id="success-pago">&mdash;</div>
                            </div>
                            <div class="success-detail-card">
                                <span class="detail-icon">&#127973;</span>
                                <div class="detail-label">Sede</div>
                                <div class="detail-value">Hospira Premium</div>
                            </div>
                            <div class="success-detail-card">
                                <span class="detail-icon">&#128205;</span>
                                <div class="detail-label">Modalidad</div>
                                <div class="detail-value">Presencial</div>
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="success-actions">
                            <button class="btn btn-primary" id="btn-ver-factura">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" x2="8" y1="13" y2="13"/><line x1="16" x2="8" y1="17" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                                Ver Factura
                            </button>
                            <a href="AgendarCita.jsp" class="btn btn-outline">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 12h14"/><path d="M12 5v14"/></svg>
                                Nueva Cita
                            </a>
                            <a href="GestionPacientes.jsp" class="btn btn-outline">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
                                Ir al Panel
                            </a>
                        </div>

                    </div>
                </div>
            </div>

        </div><!-- /wizard-card -->
    </main><!-- /wizard-page -->
</div><!-- /main-layout -->

<!-- =================== INVOICE MODAL =================== -->
<div class="invoice-modal-overlay" id="invoice-overlay">
    <div class="invoice-modal">

        <!-- Invoice Header -->
        <div class="invoice-header">
            <div class="invoice-brand">
                <div class="invoice-brand-icon">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                </div>
                <div>
                    <div class="invoice-brand-name">Hospira Premium</div>
                    <div class="invoice-brand-sub">Centro M&eacute;dico Digital</div>
                </div>
            </div>
            <div class="invoice-num">
                <div class="num" id="inv-numero">HP-XXXXXXXX</div>
                <div class="date" id="inv-fecha-emision">&mdash;</div>
            </div>
        </div>

        <!-- Invoice Body -->
        <div class="invoice-body">

            <div class="invoice-section-title">Partes involucradas</div>
            <div class="invoice-party-grid">
                <div class="invoice-party">
                    <div class="party-role">Titular / Afiliado</div>
                    <div class="party-name" id="inv-titular-nombre">&mdash;</div>
                    <div class="party-detail" id="inv-titular-dni">DNI: &mdash;</div>
                    <div class="party-detail" id="inv-titular-email">&mdash;</div>
                </div>
                <div class="invoice-party">
                    <div class="party-role">Paciente</div>
                    <div class="party-name" id="inv-paciente-nombre">&mdash;</div>
                    <div class="party-detail" id="inv-paciente-dni">DNI: &mdash;</div>
                    <div class="party-detail" id="inv-paciente-email">&mdash;</div>
                </div>
            </div>

            <div class="invoice-section-title" style="margin-top:20px;">Detalle del servicio</div>
            <table class="invoice-table">
                <thead>
                    <tr>
                        <th>Descripci&oacute;n</th>
                        <th>M&eacute;dico</th>
                        <th>Fecha/Hora</th>
                        <th>Duraci&oacute;n</th>
                        <th style="text-align:right;">Precio</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td id="inv-servicio">&mdash;</td>
                        <td id="inv-medico">&mdash;</td>
                        <td id="inv-fecha-cita">&mdash;</td>
                        <td id="inv-duracion">&mdash;</td>
                        <td id="inv-precio-base" style="text-align:right;font-weight:600;">&mdash;</td>
                    </tr>
                    <tr>
                        <td colspan="4" style="color:var(--text-muted);font-size:0.8rem;">IGV (18%)</td>
                        <td id="inv-igv" style="text-align:right;color:var(--text-muted);font-size:0.85rem;">&mdash;</td>
                    </tr>
                </tbody>
            </table>

            <div class="invoice-total-row">
                <div class="invoice-total-label">Total Pagado</div>
                <div class="invoice-total-amount" id="inv-total">S/. 0.00</div>
            </div>

            <div class="invoice-paid-badge">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                PAGO CONFIRMADO &mdash; Hospira Premium
            </div>

            <div class="invoice-footer-note">
                Esta es una factura de demostraci&oacute;n generada por el sistema acad&eacute;mico Hospira Premium.<br>
                No tiene validez tributaria real. C&oacute;digo de reserva: <strong id="inv-codigo-footer">&mdash;</strong>
            </div>
        </div>

        <div class="invoice-actions">
            <button class="btn btn-outline btn-sm" id="btn-close-invoice">Cerrar</button>
            <button class="btn btn-primary btn-sm" id="btn-print-invoice">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect width="12" height="8" x="6" y="14"/></svg>
                Imprimir Factura
            </button>
        </div>
    </div>
</div>

<!-- =================== WIZARD NOTIFICATION MODAL =================== -->
<div class="wizard-notify-overlay" id="wizard-notify-overlay">
    <div class="wizard-notify-box">
        <span class="notify-emoji" id="notify-emoji">&#9888;</span>
        <h3 id="notify-title">Atenci&oacute;n</h3>
        <p id="notify-msg">Mensaje del sistema.</p>
        <div>
            <button class="notify-btn primary" id="notify-close">Entendido</button>
        </div>
    </div>
</div>

<!-- =================== JSP DATA INJECTION =================== -->
<script>
    // Inject JSP session data as JS variables (safe escaped)
    window.HOSPIRA_USUARIO = {
        id:       <%= usuario.getId() %>,
        nombre:   "<%= escapeJs(usuario.getNombre()) %>",
        apellido: "<%= escapeJs(usuario.getApellido()) %>",
        correo:   "<%= escapeJs(usuario.getCorreo() != null ? usuario.getCorreo() : "") %>",
        dni:      "<%= escapeJs(usuario.getDni() != null ? usuario.getDni() : "") %>",
        sexo:     "<%= escapeJs(usuario.getSexo() != null ? usuario.getSexo() : "") %>"
    };

    window.HOSPIRA_PACIENTES = <%= pacientesJson.toString() %>;

    // Also link invoice footer code field
    document.addEventListener('DOMContentLoaded', function() {
        var footerCode = document.getElementById('inv-codigo-footer');
        // Will be filled by renderInvoice()
    });
</script>

<!-- =================== SCRIPTS =================== -->
<script src="js/agendarCita.js" defer></script>

</body>
</html>
