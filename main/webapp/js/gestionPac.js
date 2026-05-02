document.addEventListener('DOMContentLoaded', function () {

	// ===========================
	// FUNCIONES REUTILIZABLES
	// ===========================
	
	function cerrarModal(modal) {
		modal.style.transition = 'opacity 0.4s ease';
		modal.style.opacity = 0;
		setTimeout(function () {
			modal.style.display = 'none';
		}, 400);
	}

	function showToast(type, title, message) {
        var toast = document.getElementById('etiqueta-respuesta');
        var toastIcon = document.getElementById('toast-icon-container');
        var toastTitle = document.getElementById('toast-title');
        var toastMsg = document.getElementById('toast-message');

        if (!toast) return;

        toast.className = 'hospira-toast ' + type + ' active';
        toastTitle.innerText = title;
        toastMsg.innerText = message;

        if (type === 'success') {
            toastIcon.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>';
        } else if (type === 'error') {
            toastIcon.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>';
        } else if (type === 'warning') {
            toastIcon.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>';
        }

        setTimeout(function () {
            toast.classList.remove('active');
        }, 3500);
    }

	function abrirModal(modal) {
		modal.style.display = 'block';
		modal.style.position = 'fixed';
		modal.style.top = '50%';
		modal.style.left = '50%';
		modal.style.transform = 'translate(-50%, -50%)';
		modal.style.opacity = '0';

		setTimeout(function() {
			modal.style.transition = 'opacity 0.4s ease';
			modal.style.opacity = 1;
		}, 10);
	}

	// ===========================
	// VARIABLES
	// ===========================

	var contenedorActualizarData = document.getElementById('contenedorActualizarData');
	var btnEditarPerfil = document.getElementById('btn_editar_usuario');
	var formActualizarDataUsuario = document.getElementById("formActualizarPerfil");
	var btnFormRegistrar = document.getElementById('miBoton');

	var ContenedorformularioReg = document.getElementById('contenedorGeneral');
	var btnCerrarFormReg = ContenedorformularioReg ? ContenedorformularioReg.querySelector('.btn-cerrar') : null;
	var tbodyPacientes = document.querySelector('#mi_tabla_citas tbody');
	var formularioReg = document.getElementById('contenedorGeneral');
	var btnCerrarSession = document.getElementById('btn-cerrar-sesion');

	var formularioEditarPac = document.getElementById('contenedor-formulario-edit-Pac');
	var botonEditarPac = document.getElementById("actualizarDatosPaciente");
	var formActualizarPac = document.getElementById('formActualizarPac');
	var btnCerrarEditPac = formularioEditarPac ? formularioEditarPac.querySelector('.btn-cerrar') : null;

	var accion = 'pacientes';
	var pacientesGlobal = [];

	// ===========================
	// CARGAR PACIENTES
	// ===========================
	function cargarPacientes() {
        fetch('./GestionPacientesServlet?accion=' + accion)
          .then(function (response) {
            if (!response.ok) throw new Error('Error al obtener pacientes');
            return response.json();
          })
          .then(function (listaPacientesData) {
            pacientesGlobal = listaPacientesData || [];

            // Modo Pacientes.jsp: tabla completa dedicada
            if (window._pacientesPageMode && typeof window.renderPacientesFullTable === 'function') {
                window.renderPacientesFullTable(pacientesGlobal);
                return;
            }

            // Modo GestionPacientes.jsp: tabla del dashboard
            if (tbodyPacientes) tbodyPacientes.innerHTML = '';

            if (tbodyPacientes && Array.isArray(listaPacientesData) && listaPacientesData.length > 0) {
              listaPacientesData.forEach(function (paciente) {
                var fila = document.createElement('tr');
                var dni = paciente.DNI || paciente.dni || '';
                fila.innerHTML =
                  '<td>' + (paciente.nombre || '') + '</td>' +
                  '<td>' + (paciente.genero || '') + '</td>' +
                  '<td>' + (paciente.telefono || '') + '</td>' +
                  '<td>' + (paciente.motivo || '') + '</td>' +
                  '<td>' +
                    '<button class="btn-accion-pacienes btn-editar" data-dni="' + dni + '">editar</button>' +
                    '<button class="btn-accion-pacienes btn-eliminar" data-dni="' + dni + '">eliminar</button>' +
                  '</td>';
                tbodyPacientes.appendChild(fila);
              });
            }
          })
          .catch(function(err) { console.error(err); });
    }

	cargarPacientes();

	// ===========================
	// ENVIAR AL SERVLET (scope correcto: DOMContentLoaded, accesible desde todos los handlers)
	// ===========================
	function enviarAlServlet(parametros, onSuccess) {
		fetch('./GestionPacientesServlet', {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify(parametros)
		})
		.then(function (response) { return response.json(); })
		.then(function (data) {
			if (data.estado) {
				showToast('success', 'Operaci\u00f3n Exitosa', data.mensaje);
				if (onSuccess) onSuccess();
			} else {
				showToast('error', 'Error en la Operaci\u00f3n', data.mensaje);
			}
		})
		.catch(function (error) {
			console.error("Error en fetch:", error);
			showToast('error', 'Error del Sistema', 'Ocurri\u00f3 un error al procesar la solicitud.');
		});
	}

	// ===========================
	// CLICK DELEGADO — BOTONES PACIENTE (editar / eliminar)
	// ===========================
	document.addEventListener("click", function (event) {
		var btn = event.target;

		if (!btn.classList.contains("btn-accion-pacienes")) return;

		var DNIPaciente = btn.dataset.dni;
		console.log("DNI del botón:", DNIPaciente);
		var esEliminar = btn.classList.contains("btn-eliminar");

		if (esEliminar) {
			var parametros = {
				DNI: DNIPaciente,
				accion: "eliminar"
			};
			enviarAlServlet(parametros, function() {
				cargarPacientes();
			});
			return;
		}

		// Abrir modal editar y pre-rellenar datos
		abrirModal(formularioEditarPac);

		var pacienteEditar = pacientesGlobal.filter(function(p) {
			return (p.DNI || p.dni) === DNIPaciente;
		})[0];

		if (pacienteEditar) {
			var fechaFormateada = pacienteEditar.fechaNac || '';
			if (fechaFormateada.length > 10) {
				fechaFormateada = fechaFormateada.substring(0, 10);
			}
			document.getElementById('cboParentescoPac').value = pacienteEditar.parentesco || '';
			document.getElementById('txtCorreoPac').value = pacienteEditar.correo || '';
			document.getElementById('txtfechaPac').value = fechaFormateada;
			document.getElementById('txtTelefonoPac').value = pacienteEditar.telefono || '';
			document.getElementById('txtDireccionPac').value = pacienteEditar.direccion || '';
		}

		// Guardar DNI en el botón submit para usarlo en el envío
		if (botonEditarPac) botonEditarPac.dataset.dni = DNIPaciente;
	});

	// ===========================
	// SUBMIT EDITAR PACIENTE (registrado una sola vez)
	// ===========================
	if (formActualizarPac) {
		formActualizarPac.addEventListener('submit', function (event) {
			event.preventDefault();
			var parametros = {
				DNI: botonEditarPac ? botonEditarPac.dataset.dni : '',
				parentesco: document.getElementById('cboParentescoPac').value.trim(),
				correo: document.getElementById('txtCorreoPac').value.trim(),
				fechaNac: document.getElementById('txtfechaPac').value,
				telefono: document.getElementById('txtTelefonoPac').value.trim(),
				direccion: document.getElementById('txtDireccionPac').value.trim(),
				accion: "editar"
			};
			enviarAlServlet(parametros, function() {
				cerrarModal(formularioEditarPac);
				cargarPacientes();
			});
		});
	}

	// ===========================
	// EVENT LISTENERS — MODALES
	// ===========================

	if (btnFormRegistrar) {
		btnFormRegistrar.addEventListener('click', function () {
			if (window.getComputedStyle(ContenedorformularioReg).display === 'none') {
				abrirModal(ContenedorformularioReg);
			} else {
				cerrarModal(ContenedorformularioReg);
			}
		});
	}

	if (btnCerrarFormReg) {
		btnCerrarFormReg.addEventListener('click', function () { cerrarModal(ContenedorformularioReg); });
	}

	if (btnCerrarEditPac) {
		btnCerrarEditPac.addEventListener('click', function () { cerrarModal(formularioEditarPac); });
	}

	if (btnEditarPerfil) {
		btnEditarPerfil.addEventListener('click', function () {
			if (window.getComputedStyle(contenedorActualizarData).display === 'none') {
				abrirModal(contenedorActualizarData);
			} else {
				cerrarModal(contenedorActualizarData);
			}
		});
	}

	if (contenedorActualizarData) {
		var btnCerrarActualizar = contenedorActualizarData.querySelector('.btn-cerrar');
		if (btnCerrarActualizar) {
			btnCerrarActualizar.addEventListener('click', function () { cerrarModal(contenedorActualizarData); });
		}
	}

	// ===========================
	// REGISTRAR PACIENTE
	// ===========================
	var formulario = document.getElementById('formulario');

	if (formulario) {
		formulario.addEventListener('submit', function (event) {
			event.preventDefault();

			var parentesco = document.getElementById('cboParentesco').value.trim();
			var dni = document.getElementById('txtDni').value.trim();
			var sexo = document.getElementById('cboSexo').value;
			var apellidoPat = document.getElementById('txtApellidoPat').value.trim();
			var apellidoMat = document.getElementById('txtApellidoMat').value.trim();
			var nombre = document.getElementById('txtNombre').value.trim();
			var fecha = document.getElementById('txtfecha').value;
			var correo = document.getElementById('txtCorreo').value;
			var telefono = document.getElementById('txtTelefono').value.trim();
			var direccion = document.getElementById('txtDireccion').value.trim();
			var consulta = document.getElementById('txtMotivo').value.trim();

			if (!parentesco || !dni || !sexo || !apellidoPat || !apellidoMat || !nombre || !fecha || !correo || !telefono || !direccion || !consulta) {
				showToast('warning', 'Campos Incompletos', 'Completa todos los campos obligatorios antes de continuar.');
				return;
			}

			if (!/^\d{8}$/.test(dni)) {
				showToast('warning', 'DNI Inv\u00e1lido', 'El DNI debe contener exactamente 8 d\u00edgitos num\u00e9ricos.');
				return;
			}

			if (!/^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$/.test(correo)) {
				showToast('warning', 'Correo Inv\u00e1lido', 'Por favor, ingresa una direcci\u00f3n de correo electr\u00f3nico v\u00e1lida.');
				return;
			}

			var datos = {
				accion: "registrar",
				parentesco: parentesco,
				dni: dni,
				sexo: sexo,
				apellidoPat: apellidoPat,
				apellidoMat: apellidoMat,
				nombre: nombre,
				fecha: fecha,
				correo: correo,
				telefono: telefono,
				direccion: direccion,
				consulta: consulta
			};

			fetch('./GestionPacientesServlet', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify(datos)
			})
			.then(function (response) { return response.json(); })
			.then(function (data) {
				if (data.estado) {
					showToast('success', 'Registro Exitoso', data.mensaje);
					formularioReg.style.display = 'none';
					cargarPacientes();
				} else {
					showToast('error', 'Error de Registro', data.mensaje);
				}
			})
			.catch(function (error) {
				console.error("Error en fetch:", error);
				showToast('error', 'Error del Sistema', 'Ocurri\u00f3 un error inesperado al registrar el paciente.');
			});
		});
	}

	// ===========================
	// ACTUALIZAR DATOS USUARIO (perfil médico)
	// ===========================
	if (formActualizarDataUsuario) {
		formActualizarDataUsuario.addEventListener("submit", function (event) {
			event.preventDefault();

			var correo = document.getElementById('txtActualizarCorreo') ? document.getElementById('txtActualizarCorreo').value.trim() : '';
			var peso = document.getElementById('peso-txt') ? document.getElementById('peso-txt').value.trim() : '';
			var altura = document.getElementById('altura-txt') ? document.getElementById('altura-txt').value.trim() : '';
			var tipoSangre = document.getElementById('sangre-txt') ? document.getElementById('sangre-txt').value.trim() : '';

			if (!peso || !altura || !tipoSangre || !correo) {
				showToast('warning', 'Campos Incompletos', 'Completa todo tu perfil m\u00e9dico antes de guardar cambios.');
				return;
			}

			var parametros = {
				accion: "actualizarDatos",
				correo: correo,
				peso: peso,
				altura: altura,
				tipoSangre: tipoSangre
			};

			var submitBtn = formActualizarDataUsuario.querySelector('button[type="submit"]');
			var originalText = submitBtn ? submitBtn.textContent : '';
			if (submitBtn) { submitBtn.textContent = "Guardando..."; submitBtn.disabled = true; }

			fetch("./GestionUsuarioServlet", {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify(parametros)
			})
			.then(function (response) {
				if (!response.ok) throw new Error("Error en el servidor");
				return response.json();
			})
			.then(function (data) {
				if (data.status) {
					if (submitBtn) {
						submitBtn.textContent = '\u00a1Perfil Actualizado!';
						submitBtn.style.backgroundColor = '#10b981';
						submitBtn.style.color = '#fff';
						submitBtn.style.transition = 'all 0.3s ease';
					}
					showToast('success', 'Perfil Actualizado', 'Tus datos m\u00e9dicos se han actualizado correctamente.');
					setTimeout(function () {
						if (submitBtn) {
							submitBtn.textContent = originalText;
							submitBtn.style.backgroundColor = '';
							submitBtn.style.color = '';
							submitBtn.disabled = false;
						}
						cerrarModal(contenedorActualizarData);
					}, 2000);
				} else {
					showToast('error', 'Error al Actualizar', data.mensaje);
					if (submitBtn) { submitBtn.textContent = originalText; submitBtn.disabled = false; }
				}
			})
			.catch(function (error) {
				console.error("Error:", error);
				showToast('error', 'Error del Sistema', 'No se pudo contactar con el servidor. Intenta de nuevo.');
				if (submitBtn) { submitBtn.textContent = originalText; submitBtn.disabled = false; }
			});
		});
	}

	// ===========================
	// CERRAR SESIÓN
	// ===========================
	if (btnCerrarSession) {
		btnCerrarSession.addEventListener('click', function() {
			showToast('warning', 'Cerrando Sesi\u00f3n...', 'Saliendo de la plataforma segura...');
			var parametros = { accion: "cerrarSesion" };
			setTimeout(function () {
				fetch("./GestionUsuarioServlet", {
					method: 'POST',
					headers: { 'Content-Type': 'application/json' },
					body: JSON.stringify(parametros)
				})
				.then(function () {
					document.body.style.transition = 'opacity 0.6s ease';
					document.body.style.opacity = '0';
					setTimeout(function () {
						window.location.href = 'Login.jsp';
					}, 600);
				});
			}, 1200);
		});
	}

});