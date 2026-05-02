/* ============================================================
   HOSPIRA PREMIUM - AGENDAR CITA WIZARD
   js/agendarCita.js
   ============================================================ */

'use strict';

// ============================================================
// 1. DATA: Variables dinámicas — se llenan desde CitasServlet
// ============================================================

// Mapa visual: nombre de especialidad → emoji + color (solo cosmético)
var ESP_META = {
    'Medicina General': { emoji: '\uD83E\uDE7A', color: '#0284C7' },
    'Cardiolog\u00EDa':       { emoji: '\u2764\uFE0F', color: '#EF4444' },
    'Pediatr\u00EDa':         { emoji: '\uD83D\uDC76', color: '#F59E0B' },
    'Traumatolog\u00EDa':     { emoji: '\uD83E\uDDB4', color: '#8B5CF6' },
    'Dermatolog\u00EDa':      { emoji: '\u2728',       color: '#EC4899' },
    'Neurolog\u00EDa':        { emoji: '\uD83E\uDDE0', color: '#6366F1' },
    'Ginecolog\u00EDa':       { emoji: '\uD83D\uDC8A', color: '#10B981' },
    'Oftalmolog\u00EDa':      { emoji: '\uD83D\uDC41\uFE0F', color: '#22D3EE' }
};

// Arrays dinámicos (se poblan con fetch)
var ESPECIALIDADES      = [];  // [{ id: 'Cardiología', label: 'Cardiología', emoji, color }]
var DOCTORES_ACTUALES   = [];  // doctores del paso 3 (por especialidad seleccionada)


// ============================================================
// 2. STATE
// ============================================================

var STATE = {
    currentStep: 1,
    totalSteps: 5,
    tipoReserva: null,        
    pacienteSeleccionado: null, 
    especialidadSeleccionada: null,
    doctorSeleccionado: null,
    fechaSeleccionada: null,
    horaSeleccionada: null,
    metodoPago: null,
    codigoReserva: null,
    weekOffset: 0
};

// ============================================================
// 3. UTILITIES
// ============================================================
function generateCode() {
    var chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    var code = 'HP-';
    for (var i = 0; i < 8; i++) code += chars[Math.floor(Math.random() * chars.length)];
    return code;
}

function formatDate(date) {
    return date.toLocaleDateString('es-PE', { weekday: 'long', day: '2-digit', month: 'long', year: 'numeric' });
}

function formatDateShort(date) {
    return date.toLocaleDateString('es-PE', { day: '2-digit', month: '2-digit', year: 'numeric' });
}

function capitalize(str) {
    if (!str) return '';
    return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
}

function getDayName(date) {
    return date.toLocaleDateString('es-PE', { weekday: 'long' });
}

function capitalizeFirst(str) {
    if (!str) return '';
    return str.charAt(0).toUpperCase() + str.slice(1);
}

// Blocked slots storage key
var STORAGE_KEY = 'hospira_reservas_v2';

function getReservas() {
    try { return JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]'); }
    catch(e) { return []; }
}

function saveReservas(list) {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(list));
}

function estaOcupado(doctorId, fecha, hora) {
    var reservas = getReservas();
    return reservas.some(function(r) { return r.doctorId === doctorId && r.fecha === fecha && r.hora === hora; });
}

function registrarReserva(doctorId, fecha, hora, titularId, codigoReserva) {
    var reservas = getReservas();
    reservas.push({ doctorId: doctorId, fecha: fecha, hora: hora, titularId: titularId, codigoReserva: codigoReserva, timestamp: Date.now() });
    saveReservas(reservas);
}

// Get week dates starting from today + weekOffset weeks
function getWeekDates(offset) {
    if (typeof offset === 'undefined') offset = 0;
    var today = new Date();
    var startOffset = offset * 7;
    var dates = [];
    for (var i = 0; i < 7; i++) {
        var d = new Date(today);
        d.setDate(today.getDate() + startOffset + i);
        dates.push(d);
    }
    return dates;
}

// ============================================================
// 4. STEP NAVIGATION
// ============================================================
function updateStepper() {
    var steps = document.querySelectorAll('.stepper-step');
    steps.forEach(function(step, idx) {
        var num = idx + 1;
        var circle = step.querySelector('.step-circle');
        step.classList.remove('active', 'done');
        circle.classList.remove('active', 'done');
        if (num < STATE.currentStep) {
            step.classList.add('done');
            circle.classList.add('done');
        } else if (num === STATE.currentStep) {
            step.classList.add('active');
            circle.classList.add('active');
        }
    });

    var progressLine = document.getElementById('stepper-progress-line');
    if (progressLine) {
        var progressPct = ((STATE.currentStep - 1) / (STATE.totalSteps - 1)) * 100;
        progressLine.style.width = progressPct + '%';
    }
}

function goToStep(step, direction) {
    if (direction === undefined) direction = 'forward';
    var current = document.querySelector('.step-panel.active');
    if (current) current.classList.remove('active', 'slide-back');

    var next = document.getElementById('step-' + step);
    if (next) {
        if (direction === 'back') next.classList.add('slide-back');
        next.classList.add('active');
    }
    STATE.currentStep = step;
    updateStepper();

    var btnPrev = document.getElementById('btn-prev');
    var btnNext = document.getElementById('btn-next');
    if (btnPrev) btnPrev.style.display = step > 1 && step < 5 ? 'inline-flex' : 'none';
    if (btnNext) {
        if (step < 4) {
            btnNext.style.display = 'inline-flex';
            btnNext.textContent = step === 3 ? 'Continuar a Confirmaci\u00F3n >' : 'Continuar >';
        } else {
            btnNext.style.display = 'none';
        }
    }

    var wizardCard = document.querySelector('.wizard-card');
    if (wizardCard && wizardCard.scrollIntoView) {
        wizardCard.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
}

function nextStep() {
    if (!validateStep(STATE.currentStep)) return;
    if (STATE.currentStep < STATE.totalSteps) goToStep(STATE.currentStep + 1);
}

function prevStep() {
    if (STATE.currentStep > 1) goToStep(STATE.currentStep - 1, 'back');
}

function validateStep(step) {
    switch(step) {
        case 1:
            if (!STATE.tipoReserva) {
                showWizardNotify('!', 'Selecci\u00F3n requerida', 'Por favor selecciona para qui\u00E9n es la cita: para ti o para un familiar.');
                return false;
            }
            if (STATE.tipoReserva === 'familiar' && !STATE.pacienteSeleccionado) {
                showWizardNotify('\uD83D\uDC65', 'Selecciona un paciente', 'Por favor selecciona el familiar o conocido para quien es la cita.');
                return false;
            }
            return true;
        case 2:
            if (!STATE.especialidadSeleccionada) {
                showWizardNotify('\uD83C\uDFE5', 'Especialidad requerida', 'Por favor selecciona la especialidad m\u00E9dica que necesitas.');
                return false;
            }
            return true;
        case 3:
            if (!STATE.doctorSeleccionado) {
                showWizardNotify('\uD83D\uDC68\u200D\u2695\uFE0F', 'M\u00E9dico requerido', 'Por favor selecciona un m\u00E9dico de la lista.');
                return false;
            }
            if (!STATE.fechaSeleccionada || !STATE.horaSeleccionada) {
                showWizardNotify('\uD83D\uDCC5', 'Horario requerido', 'Por favor selecciona una fecha y hora disponible para tu cita.');
                return false;
            }
            return true;
        default: return true;
    }
}

// ============================================================
// 5. STEP 1 — PARA QUIÉN
// ============================================================
function selectTipo(tipo) {
    STATE.tipoReserva = tipo;
    document.querySelectorAll('.patient-type-card').forEach(function(c) { c.classList.remove('selected'); });
    var card = document.getElementById('card-' + tipo);
    if (card) card.classList.add('selected');

    var familiarSel = document.getElementById('familiar-selector');
    if (tipo === 'familiar') {
        if (familiarSel) familiarSel.classList.add('show');
        renderPacientesList();
        STATE.pacienteSeleccionado = null;
    } else {
        if (familiarSel) familiarSel.classList.remove('show');
        STATE.pacienteSeleccionado = null;
    }
}

function renderPacientesList() {
    var list = document.getElementById('pacientes-list');
    if (!list) return;

    // Try to get patients from window variable injected by JSP
    var rawPacientes = window.HOSPIRA_PACIENTES || [];
    // Filter out the 'Titular' account if it's for a family member
    var pacientes = rawPacientes.filter(function(p) {
        return (p.parentesco || '').toLowerCase() !== 'titular';
    });
    
    list.innerHTML = '';

    if (pacientes.length === 0) {
        list.innerHTML = '<div class="no-pacientes floatUp">' +
            '<p style="color: #64748B; margin-bottom: 1rem;">No tienes pacientes registrados aún.</p>' +
            '<a href="GestionPacientes.jsp" class="btn-primary" style="text-decoration:none; display:inline-block; padding: 8px 16px; font-size: 0.875rem;">' +
            'Ir a Gestión de Pacientes</a>' +
        '</div>';
        return;
    }

    pacientes.forEach(function(p, idx) {
        var initials = ((p.nombre || ' ').charAt(0) + (p.apellidoPat || ' ').charAt(0)).toUpperCase();
        var item = document.createElement('div');
        item.className = 'paciente-item';
        item.setAttribute('data-idx', idx);
        var pDni = p.DNI || p.dni || '-';
        item.innerHTML = '\n' +
'            <div class="paciente-avatar">' + initials + '</div>\n' +
'            <div class="paciente-info">\n' +
'                <div class="pac-name">' + p.nombre + ' ' + (p.apellidoPat || '') + ' ' + (p.apellidoMat || '') + '</div>\n' +
'                <div class="pac-meta">' + (p.parentesco || 'Familiar') + ' - DNI: ' + pDni + '</div>\n' +
'            </div>\n' +
'            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#0284C7" stroke-width="2.5"><polyline points="9 18 15 12 9 6"></polyline></svg>\n' +
'        ';
        item.addEventListener('click', function() { selectPaciente(p, item); });
        list.appendChild(item);
    });
}

function selectPaciente(paciente, el) {
    document.querySelectorAll('.paciente-item').forEach(function(i) { i.classList.remove('selected'); });
    el.classList.add('selected');
    STATE.pacienteSeleccionado = paciente;
}

// ============================================================
// 6. STEP 2 — ESPECIALIDADES (dinámico desde BD)
// ============================================================

// Carga especialidades desde CitasServlet y renderiza el grid
function cargarEspecialidades() {
    var grid = document.getElementById('specialty-grid');
    if (!grid) return;
    grid.innerHTML = '<p style="text-align:center;color:var(--text-muted);padding:24px;">Cargando especialidades...</p>';

    fetch('CitasServlet?accion=especialidades')
        .then(function(res) {
            if (!res.ok) throw new Error('HTTP ' + res.status);
            return res.json();
        })
        .then(function(data) {
            // data = ["Cardiología", "Pediatría", ...]
            ESPECIALIDADES = [];
            data.forEach(function(nombre) {
                var meta = ESP_META[nombre] || { emoji: '\uD83C\uDFE5', color: '#0284C7' };
                ESPECIALIDADES.push({ id: nombre, label: nombre, emoji: meta.emoji, color: meta.color });
            });
            renderEspecialidades();
        })
        .catch(function(err) {
            console.error('Error cargando especialidades:', err);
            grid.innerHTML = '<p style="color:#ef4444;text-align:center;padding:24px;">Error al cargar especialidades. Recarga la página.</p>';
        });
}

function renderEspecialidades() {
    var grid = document.getElementById('specialty-grid');
    if (!grid) return;
    grid.innerHTML = '';

    if (ESPECIALIDADES.length === 0) {
        grid.innerHTML = '<p style="text-align:center;color:var(--text-muted);padding:24px;">No hay especialidades disponibles.</p>';
        return;
    }

    ESPECIALIDADES.forEach(function(esp) {
        var card = document.createElement('div');
        card.className = 'specialty-card';
        card.id = 'esp-' + esp.id.replace(/\s/g, '_');
        card.innerHTML = '\n' +
'            <div class="specialty-icon" style="background:' + esp.color + '18;">' + esp.emoji + '</div>\n' +
'            <h4>' + esp.label + '</h4>\n' +
'            <span class="doc-count">Ver m\u00E9dicos</span>\n' +
'        ';
        card.addEventListener('click', function() { selectEspecialidad(esp.id, card); });
        grid.appendChild(card);
    });
}

function selectEspecialidad(id, card) {
    document.querySelectorAll('.specialty-card').forEach(function(c) { c.classList.remove('selected'); });
    card.classList.add('selected');
    STATE.especialidadSeleccionada = id;
    STATE.doctorSeleccionado = null;
    STATE.fechaSeleccionada = null;
    STATE.horaSeleccionada = null;
    cargarDoctores(id);
}

// ============================================================
// 7. STEP 3 — MÉDICO Y HORARIO (dinámico desde BD)
// ============================================================

// Carga doctores de la especialidad seleccionada y renderiza
function cargarDoctores(especialidad) {
    var list = document.getElementById('doctors-list');
    if (!list) return;
    list.innerHTML = '<p style="text-align:center;color:var(--text-muted);padding:24px;">Cargando m\u00E9dicos...</p>';

    fetch('CitasServlet?accion=doctores&especialidad=' + encodeURIComponent(especialidad))
        .then(function(res) {
            if (!res.ok) throw new Error('HTTP ' + res.status);
            return res.json();
        })
        .then(function(data) {
            // data = [{ id, nombre, especialidad, bio, rating, precio, avatarEmoji, duracion }]
            DOCTORES_ACTUALES = data;
            renderDoctors();
        })
        .catch(function(err) {
            console.error('Error cargando doctores:', err);
            list.innerHTML = '<p style="color:#ef4444;text-align:center;padding:24px;">Error al cargar m\u00E9dicos. Intenta de nuevo.</p>';
        });
}

function renderDoctors() {
    var list = document.getElementById('doctors-list');
    if (!list) return;
    list.innerHTML = '';

    var labelEl = document.getElementById('doctors-specialty-label');
    if (labelEl) labelEl.textContent = STATE.especialidadSeleccionada ? '- ' + STATE.especialidadSeleccionada : '';

    if (DOCTORES_ACTUALES.length === 0) {
        list.innerHTML = '<p class="text-muted" style="text-align:center;padding:24px;">No hay m\u00E9dicos disponibles para esta especialidad.</p>';
        return;
    }

    DOCTORES_ACTUALES.forEach(function(doc) {
        var starsCount = Math.round(doc.rating);
        var starsStr = '';
        for(var j=0; j<starsCount; j++) starsStr += '\u2605';
        var card = document.createElement('div');
        card.className = 'doctor-card';
        card.id = 'doc-card-' + doc.id;

        card.innerHTML = '\n' +
'            <div class="doctor-avatar">' + (doc.avatarEmoji || '\uD83D\uDC68\u200D\u2695\uFE0F') + '</div>\n' +
'            <div class="doctor-info">\n' +
'                <div class="doctor-name">' + doc.nombre + '</div>\n' +
'                <div class="doctor-specialty">' + doc.especialidad + '</div>\n' +
'                <div class="doctor-meta">\n' +
'                    <span class="doctor-rating">' + starsStr + ' ' + doc.rating + '</span>\n' +
'                    <span class="doctor-duration">- ' + (doc.duracion || 20) + ' min</span>\n' +
'                </div>\n' +
'                <div style="font-size:0.72rem;color:var(--text-muted);margin-top:4px;">' + (doc.bio || '') + '</div>\n' +
'            </div>\n' +
'            <div class="doctor-price">S/ ' + doc.precio + '</div>\n' +
'        ';
        card.addEventListener('click', function() { selectDoctor(doc, card); });
        list.appendChild(card);
    });
}

function selectDoctor(doc, card) {
    document.querySelectorAll('.doctor-card').forEach(function(c) { c.classList.remove('selected'); });
    card.classList.add('selected');
    STATE.doctorSeleccionado = doc;
    STATE.doctorSeleccionado.horarios = {};  // se llenarán con el fetch
    STATE.fechaSeleccionada = null;
    STATE.horaSeleccionada = null;
    STATE.weekOffset = 0;

    // Cargar horarios desde la BD
    cargarHorarios(doc.id);
}

// Carga horarios del doctor desde CitasServlet y renderiza el calendario
function cargarHorarios(doctorId) {
    var wrapper = document.getElementById('calendar-wrapper');
    var slotsGrid = document.getElementById('slots-grid');
    if (slotsGrid) slotsGrid.innerHTML = '<p style="text-align:center;color:var(--text-muted);font-size:0.85rem;">Cargando horarios...</p>';

    fetch('CitasServlet?accion=horarios&doctorId=' + doctorId)
        .then(function(res) {
            if (!res.ok) throw new Error('HTTP ' + res.status);
            return res.json();
        })
        .then(function(horarios) {
            // horarios = { "Lunes": ["08:00","08:30",...], "Martes": [...], ... }
            if (STATE.doctorSeleccionado && STATE.doctorSeleccionado.id === doctorId) {
                STATE.doctorSeleccionado.horarios = horarios;
                renderCalendar();
            }
        })
        .catch(function(err) {
            console.error('Error cargando horarios:', err);
            if (slotsGrid) slotsGrid.innerHTML = '<p style="color:#ef4444;text-align:center;">Error al cargar horarios.</p>';
        });
}

// Calendar rendering
function renderCalendar() {
    var wrapper = document.getElementById('calendar-wrapper');
    var noDoc = document.getElementById('no-doctor-selected');
    if (!wrapper || !noDoc) return;

    if (!STATE.doctorSeleccionado) {
        wrapper.style.display = 'none';
        noDoc.style.display = 'flex';
        return;
    }
    wrapper.style.display = 'flex';
    noDoc.style.display = 'none';

    var weekDates = getWeekDates(STATE.weekOffset);
    var startDate = weekDates[0];
    var endDate = weekDates[6];

    // Week label
    var weekLabel = document.getElementById('week-label');
    if (weekLabel) {
        weekLabel.textContent = formatDateShort(startDate) + ' - ' + formatDateShort(endDate);
    }

    // Day tabs \u2014 only show days the doctor works
    var daysTabs = document.getElementById('days-tabs');
    daysTabs.innerHTML = '';

    var espDaysOrder = ['Lunes','Martes','Mi\u00E9rcoles','Jueves','Viernes','S\u00E1bado','Domingo'];
    var docHorarios = STATE.doctorSeleccionado.horarios;

    // Map weekdates to day names
    var dayNames = { 0:'Domingo',1:'Lunes',2:'Martes',3:'Mi\u00E9rcoles',4:'Jueves',5:'Viernes',6:'S\u00E1bado' };
    var firstAvailableTab = null;

    weekDates.forEach(function(date) {
        var dayName = dayNames[date.getDay()];
        if (!docHorarios[dayName]) return; 

        var tab = document.createElement('div');
        tab.className = 'day-tab';
        tab.setAttribute('data-day', dayName);
        tab.setAttribute('data-date', date.toISOString().split('T')[0]);
        tab.innerHTML = '\n' +
'            <span class="day-name">' + dayName.substring(0,3) + '</span>\n' +
'            <span class="day-num">' + date.getDate() + '</span>\n' +
'        ';
        tab.addEventListener('click', function() { selectDayTab(tab, dayName, date); });
        daysTabs.appendChild(tab);
        if (!firstAvailableTab) firstAvailableTab = { tab: tab, dayName: dayName, date: date };
    });

    if (daysTabs.innerHTML === '') {
        daysTabs.innerHTML = '<p class="text-muted" style="font-size:0.8rem;padding:8px;">No hay días disponibles esta semana.</p>';
        document.getElementById('slots-grid').innerHTML = '';
    } else if (firstAvailableTab) {
        selectDayTab(firstAvailableTab.tab, firstAvailableTab.dayName, firstAvailableTab.date);
    }
}

function selectDayTab(tab, dayName, date) {
    document.querySelectorAll('.day-tab').forEach(function(t) { t.classList.remove('active'); });
    tab.classList.add('active');
    STATE.horaSeleccionada = null;
    renderSlots(dayName, date);
}

function renderSlots(dayName, date) {
    var grid = document.getElementById('slots-grid');
    if (!grid || !STATE.doctorSeleccionado) return;
    grid.innerHTML = '';

    var horas = STATE.doctorSeleccionado.horarios[dayName] || [];
    var dateStr = date.toISOString().split('T')[0];
    STATE.fechaSeleccionada = date;

    if (horas.length === 0) {
        grid.innerHTML = '<div class="no-slots">Sin horarios este día.</div>';
        return;
    }

    horas.forEach(function(hora) {
        var occupied = estaOcupado(STATE.doctorSeleccionado.id, dateStr, hora);
        var btn = document.createElement('button');
        btn.className = 'slot-btn' + (occupied ? ' occupied' : '');
        btn.textContent = hora;
        btn.disabled = occupied;
        if (!occupied) {
            btn.addEventListener('click', function() {
                document.querySelectorAll('.slot-btn').forEach(function(b) { b.classList.remove('selected'); });
                btn.classList.add('selected');
                STATE.horaSeleccionada = hora;
            });
        }
        grid.appendChild(btn);
    });
}

function changeWeek(dir) {
    var newOffset = STATE.weekOffset + dir;
    if (newOffset < 0) return; // no past weeks
    STATE.weekOffset = newOffset;
    STATE.fechaSeleccionada = null;
    STATE.horaSeleccionada = null;
    renderCalendar();
}

// ============================================================
// 8. STEP 4 — CONFIRMACIÓN
// ============================================================
function renderConfirmation() {
    var esp = null;
    for (var i = 0; i < ESPECIALIDADES.length; i++) {
        if (ESPECIALIDADES[i].id === STATE.especialidadSeleccionada) {
            esp = ESPECIALIDADES[i];
            break;
        }
    }
    var doc = STATE.doctorSeleccionado;
    var usuario = window.HOSPIRA_USUARIO || {};

    // Determine patient name
    var pacNombre, pacDNI, pacEmail;
    if (STATE.tipoReserva === 'titular') {
        pacNombre = (usuario.nombre || '') + ' ' + (usuario.apellido || '');
        pacDNI    = usuario.dni || '\u2014';
        pacEmail  = usuario.correo || '\u2014';
    } else {
        var p = STATE.pacienteSeleccionado || {};
        pacNombre = (p.nombre || '') + ' ' + (p.apellidoPat || '') + ' ' + (p.apellidoMat || '');
        pacDNI    = p.DNI || p.dni || '\u2014';
        pacEmail  = p.correo || '\u2014';
    }

    var fechaFmt = STATE.fechaSeleccionada ? formatDate(STATE.fechaSeleccionada) : '\u2014';
    var precio = doc ? doc.precio : 0;
    var igv = Math.round(precio * 0.18 * 100) / 100;
    var total = precio + igv;

    // Summary rows
    var summaryData = [
        { icon: '\uD83C\uDFE5', label: 'Tipo de Atenci\u00F3n', value: STATE.tipoReserva === 'titular' ? 'Para el Titular' : 'Para Familiar/Conocido' },
        { icon: '\uD83D\uDC64', label: 'Paciente', value: pacNombre.trim() || '\u2014' },
        { icon: '\uD83E\uDE7A', label: 'Especialidad', value: (esp ? esp.label : '\u2014') },
        { icon: '\uD83D\uDC68\u200D\u2695\uFE0F', label: 'M\u00E9dico', value: (doc ? doc.nombre : '\u2014') },
        { icon: '\uD83D\uDCC5', label: 'Fecha', value: capitalizeFirst(fechaFmt) },
        { icon: '\uD83D\uDD50', label: 'Hora', value: STATE.horaSeleccionada || '\u2014' },
        { icon: '\u23F1\uFE0F', label: 'Duraci\u00F3n estimada', value: doc ? doc.duracion + ' minutos' : '\u2014' },
    ];

    var summaryContainer = document.getElementById('confirmation-summary-rows');
    if (summaryContainer) {
        summaryContainer.innerHTML = summaryData.map(function(row) {
            return '\n' +
'            <div class="summary-row">\n' +
'                <div class="summary-icon">' + row.icon + '</div>\n' +
'                <div class="summary-content">\n' +
'                    <div class="summary-label">' + row.label + '</div>\n' +
'                    <div class="summary-value">' + row.value + '</div>\n' +
'                </div>\n' +
'            </div>\n' +
'        ';
        }).join('');
    }

    // Price display
    var priceDisplay = document.getElementById('price-amount');
    if (priceDisplay) priceDisplay.innerHTML = '<span class="currency">S/. </span>' + total.toFixed(2);
    var priceDetail = document.getElementById('price-detail');
    if (priceDetail) priceDetail.textContent = 'Consulta S/. ' + precio.toFixed(2) + ' + IGV S/. ' + igv.toFixed(2);
}

// ============================================================
// 9. PAYMENT ACTIONS
// ============================================================
function pagarAhora() {
    STATE.metodoPago = 'inmediato';
    processReservation();
}

function pagarDia() {
    STATE.metodoPago = 'presencial';
    processReservation();
}

function processReservation() {
    var doc = STATE.doctorSeleccionado;
    var usuario = window.HOSPIRA_USUARIO || {};
    var dateStr = STATE.fechaSeleccionada ? STATE.fechaSeleccionada.toISOString().split('T')[0] : '';
    STATE.codigoReserva = generateCode();

    // Deshabilitar botones de pago mientras se procesa
    var btnNow   = document.getElementById('btn-pay-now');
    var btnLater = document.getElementById('btn-pay-later');
    if (btnNow)   { btnNow.disabled = true;   btnNow.textContent   = 'Procesando...'; }
    if (btnLater) { btnLater.disabled = true;  btnLater.textContent = 'Procesando...'; }

    // Construir payload para enviar a CitasServlet
    var payload = {
        accion:        'reservar',
        tipoReserva:   STATE.tipoReserva   || 'titular',
        doctorId:      doc ? doc.id         : 0,
        fecha:         dateStr,
        hora:          STATE.horaSeleccionada || '',
        motivo:        'Consulta m\u00E9dica - ' + (STATE.especialidadSeleccionada || ''),
        codigoReserva: STATE.codigoReserva,
        metodoPago:    STATE.metodoPago    || 'presencial',
        pacienteId:    STATE.pacienteSeleccionado ? (STATE.pacienteSeleccionado.id || 0) : 0
    };

    fetch('CitasServlet', {
        method:  'POST',
        headers: { 'Content-Type': 'application/json' },
        body:    JSON.stringify(payload)
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        // Re-habilitar botones
        if (btnNow)   { btnNow.disabled   = false; btnNow.textContent   = 'Pagar ahora'; }
        if (btnLater) { btnLater.disabled  = false; btnLater.textContent = 'Pagar en consulta'; }

        if (data.estado) {
            // Usar el código de la BD si fue generado allí
            if (data.codigoReserva) STATE.codigoReserva = data.codigoReserva;

            // Guardar en localStorage como respaldo visual (no fuente de verdad)
            registrarReserva(doc.id, dateStr, STATE.horaSeleccionada, usuario.id || 'guest', STATE.codigoReserva);

            renderSuccess();
            goToStep(5);

            if (STATE.metodoPago === 'inmediato') {
                setTimeout(function() { openInvoice(); }, 700);
            }
        } else {
            showWizardNotify('\u26A0\uFE0F', 'No se pudo confirmar', data.mensaje || 'Ocurri\u00F3 un error al registrar tu cita.');
            // Re-habilitar botones
            if (btnNow)   { btnNow.disabled   = false; btnNow.textContent   = 'Pagar ahora'; }
            if (btnLater) { btnLater.disabled  = false; btnLater.textContent = 'Pagar en consulta'; }
        }
    })
    .catch(function(err) {
        console.error('Error al registrar cita:', err);
        if (btnNow)   { btnNow.disabled   = false; btnNow.textContent   = 'Pagar ahora'; }
        if (btnLater) { btnLater.disabled  = false; btnLater.textContent = 'Pagar en consulta'; }
        showWizardNotify('\u26A0\uFE0F', 'Error de conexi\u00F3n', 'No se pudo conectar con el servidor. Verifica tu conexi\u00F3n.');
    });
}

// ============================================================
// 10. STEP 5 — SUCCESS
// ============================================================
function renderSuccess() {
    var doc = STATE.doctorSeleccionado;
    var esp = null;
    for(var m=0; m<ESPECIALIDADES.length; m++) { if(ESPECIALIDADES[m].id === STATE.especialidadSeleccionada) { esp = ESPECIALIDADES[m]; break; } }
    var usuario = window.HOSPIRA_USUARIO || {};

    var codeEl = document.getElementById('success-code-val');
    if (codeEl) codeEl.textContent = STATE.codigoReserva;

    var detailDoc   = document.getElementById('success-doc');
    var detailFecha = document.getElementById('success-fecha');
    var detailHora  = document.getElementById('success-hora');
    var detailPago  = document.getElementById('success-pago');

    if (detailDoc)   detailDoc.textContent   = doc ? doc.nombre : '\u2014';
    if (detailFecha) detailFecha.textContent = STATE.fechaSeleccionada ? formatDateShort(STATE.fechaSeleccionada) : '\u2014';
    if (detailHora)  detailHora.textContent  = STATE.horaSeleccionada || '\u2014';
    if (detailPago) {
        if (STATE.metodoPago === 'inmediato') {
            detailPago.textContent = '\u2705 Pagado';
            detailPago.style.color = 'var(--success)';
        } else {
            detailPago.textContent = '\uD83D\uDCB5 Pago en cita';
            detailPago.style.color = 'var(--warning)';
        }
    }

    var btnFactura = document.getElementById('btn-ver-factura');
    if (btnFactura) {
        btnFactura.style.display = STATE.metodoPago === 'inmediato' ? 'inline-flex' : 'none';
    }
}

// ============================================================
// 11. INVOICE
// ============================================================
function openInvoice() {
    renderInvoice();
    var overlay = document.getElementById('invoice-overlay');
    if (overlay) overlay.classList.add('open');
}

function closeInvoice() {
    var overlay = document.getElementById('invoice-overlay');
    if (overlay) overlay.classList.remove('open');
}

function renderInvoice() {
    var doc  = STATE.doctorSeleccionado;
    var esp = null;
    for(var n=0; n<ESPECIALIDADES.length; n++) { if(ESPECIALIDADES[n].id === STATE.especialidadSeleccionada) { esp = ESPECIALIDADES[n]; break; } }
    var usuario = window.HOSPIRA_USUARIO || {};

    var pacNombre, pacDNI, pacEmail, pacParentesco;
    if (STATE.tipoReserva === 'titular') {
        pacNombre = (usuario.nombre || '') + ' ' + (usuario.apellido || '');
        pacDNI    = usuario.dni || '\u2014';
        pacEmail  = usuario.correo || '\u2014';
        pacParentesco = 'Titular';
    } else {
        var p = STATE.pacienteSeleccionado || {};
        pacNombre = (p.nombre || '') + ' ' + (p.apellidoPat || '') + ' ' + (p.apellidoMat || '');
        pacDNI    = p.DNI || p.dni || '\u2014';
        pacEmail  = p.correo || '\u2014';
        pacParentesco = p.parentesco || 'Familiar';
    }

    var precio = doc ? doc.precio : 0;
    var igv = Math.round(precio * 0.18 * 100) / 100;
    var total = precio + igv;
    var now = new Date();
    var fechaEmision = now.toLocaleDateString('es-PE', { day:'2-digit', month:'2-digit', year:'numeric' });
    var horaEmision  = now.toLocaleTimeString('es-PE', { hour:'2-digit', minute:'2-digit' });

    var setEl = function(id, val) { var el = document.getElementById(id); if (el) el.innerHTML = val; };

    setEl('inv-numero', STATE.codigoReserva || '\u2014');
    setEl('inv-fecha-emision', fechaEmision + ' ' + horaEmision);

    setEl('inv-titular-nombre', (usuario.nombre || '') + ' ' + (usuario.apellido || '') || '\u2014');
    setEl('inv-titular-dni', 'DNI: ' + (usuario.dni || '\u2014'));
    setEl('inv-titular-email', usuario.correo || '\u2014');

    setEl('inv-paciente-nombre', pacNombre.trim() || '\u2014');
    setEl('inv-paciente-dni', 'DNI: ' + pacDNI + ' - ' + pacParentesco);
    setEl('inv-paciente-email', pacEmail);

    setEl('inv-servicio', (esp ? esp.label : '') + ' \u2014 Consulta M\u00E9dica');
    setEl('inv-medico', doc ? doc.nombre : '\u2014');
    setEl('inv-fecha-cita', STATE.fechaSeleccionada ? formatDateShort(STATE.fechaSeleccionada) + ' a las ' + STATE.horaSeleccionada : '\u2014');
    setEl('inv-duracion', (doc ? doc.duracion : '\u2014') + ' minutos');
    setEl('inv-precio-base', 'S/. ' + precio.toFixed(2));
    setEl('inv-igv', 'S/. ' + igv.toFixed(2));
    setEl('inv-total', 'S/. ' + total.toFixed(2));
}

function printInvoice() {
    window.print();
}

// ============================================================
// 12. WIZARD NOTIFICATION (diferente al sistema de toast existente)
// ============================================================
function showWizardNotify(emoji, title, message, onClose) {
    var overlay = document.getElementById('wizard-notify-overlay');
    var emojiEl = document.getElementById('notify-emoji');
    var titleEl = document.getElementById('notify-title');
    var msgEl   = document.getElementById('notify-msg');

    if (emojiEl)  emojiEl.textContent = emoji;
    if (titleEl)  titleEl.textContent = title;
    if (msgEl)    msgEl.textContent = message;

    if (overlay) overlay.classList.add('open');

    // Store callback
    overlay._onClose = onClose || null;
}

function closeWizardNotify() {
    var overlay = document.getElementById('wizard-notify-overlay');
    if (overlay) {
        overlay.classList.remove('open');
        if (typeof overlay._onClose === 'function') overlay._onClose();
    }
}

// ============================================================
// 13. INIT
// ============================================================
document.addEventListener('DOMContentLoaded', function() {

    // Cargar especialidades dinámicamente desde la BD
    cargarEspecialidades();

    // Step 3 — when this step becomes active, render doctors
    // (handled via goToStep calls + validateStep)

    // Nota: El sidebar toggle ya es manejado por sidebar.jsp — no duplicar listener aquí.

    // Stepper initial state
    updateStepper();

    // Navigation buttons
    var btnPrev = document.getElementById('btn-prev');
    var btnNext = document.getElementById('btn-next');
    if (btnPrev) btnPrev.addEventListener('click', prevStep);
    if (btnNext) btnNext.addEventListener('click', function() {
        if (STATE.currentStep === 3 && validateStep(3)) {
            renderConfirmation();
        }
        nextStep();
    });

    // Patient type cards
    var cardTitular  = document.getElementById('card-titular');
    var cardFamiliar = document.getElementById('card-familiar');
    if (cardTitular)  cardTitular.addEventListener('click',  function() { selectTipo('titular'); });
    if (cardFamiliar) cardFamiliar.addEventListener('click', function() { selectTipo('familiar'); });

    // Week nav
    var btnPrevWeek = document.getElementById('btn-prev-week');
    var btnNextWeek = document.getElementById('btn-next-week');
    if (btnPrevWeek) btnPrevWeek.addEventListener('click', function() { changeWeek(-1); });
    if (btnNextWeek) btnNextWeek.addEventListener('click', function() { changeWeek(1); });

    // Pay buttons
    var btnPayNow   = document.getElementById('btn-pay-now');
    var btnPayLater = document.getElementById('btn-pay-later');
    if (btnPayNow)   btnPayNow.addEventListener('click', pagarAhora);
    if (btnPayLater) btnPayLater.addEventListener('click', pagarDia);

    // Invoice
    var btnVerFactura  = document.getElementById('btn-ver-factura');
    var btnCloseInv    = document.getElementById('btn-close-invoice');
    var btnPrintInv    = document.getElementById('btn-print-invoice');
    if (btnVerFactura) btnVerFactura.addEventListener('click', openInvoice);
    if (btnCloseInv)   btnCloseInv.addEventListener('click', closeInvoice);
    if (btnPrintInv)   btnPrintInv.addEventListener('click', printInvoice);

    // Close invoice on overlay click
    var invoiceOverlay = document.getElementById('invoice-overlay');
    if (invoiceOverlay) {
        invoiceOverlay.addEventListener('click', function(e) { if (e.target === invoiceOverlay) closeInvoice(); });
    }

    // Wizard notify close
    var notifyClose  = document.getElementById('notify-close');
    var notifyOverlay = document.getElementById('wizard-notify-overlay');
    if (notifyClose)  notifyClose.addEventListener('click', closeWizardNotify);
    if (notifyOverlay) notifyOverlay.addEventListener('click', function(e) { if (e.target === notifyOverlay) closeWizardNotify(); });

    // Logout button
    var btnLogout = document.getElementById('btn-cerrar-sesion');
    if (btnLogout) {
        btnLogout.addEventListener('click', function() {
            showWizardNotify('\uD83D\uDC4B', 'Cerrando sesi\u00F3n', '\u00BFEst\u00E1s seguro que deseas salir del sistema?');
            // Override close to redirect
            var overlay = document.getElementById('wizard-notify-overlay');
            if (overlay) overlay._onClose = function() { window.location.href = 'Login.jsp'; };
        });
    }

    // When step 3 is reached, render doctors list
    // We intercept nextStep for step 2:
    var origNext = window.nextStep;
    // Already handled inline

    // Initial hide of btn-prev
    var btnPrevEl = document.getElementById('btn-prev');
    if (btnPrevEl) btnPrevEl.style.display = 'none';

    // Show year in footer if any
    var yearEl = document.getElementById('current-year');
    if (yearEl) yearEl.textContent = new Date().getFullYear();
});

// Expose functions and state to global for inline onclick handlers in JSP
window.STATE               = STATE;
window.nextStep            = nextStep;
window.prevStep            = prevStep;
window.goToStep            = goToStep;
window.selectTipo          = selectTipo;
window.changeWeek          = changeWeek;
window.openInvoice         = openInvoice;
window.closeInvoice        = closeInvoice;
window.printInvoice        = printInvoice;
window.closeWizardNotify   = closeWizardNotify;
window.showWizardNotify    = showWizardNotify;
window.renderConfirmation  = renderConfirmation;
// Dynamic data loaders (called from JSP inline onclick)
window.cargarEspecialidades = cargarEspecialidades;
window.cargarDoctores       = cargarDoctores;
window.cargarHorarios       = cargarHorarios;
window.renderDoctors        = renderDoctors;
