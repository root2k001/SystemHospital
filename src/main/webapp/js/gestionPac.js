document.addEventListener('DOMContentLoaded', function () {

	// ===========================
	// FUNCIONES REUTILIZABLES
	// ===========================
	
	function cerrarModal(modal) {
		modal.style.transition = 'opacity 0.4s ease';
		modal.style.opacity = 0;
		setTimeout(() => {
			modal.style.display = 'none';
		}, 400);
	}

	function showToast(type, title, message) {
        const toast = document.getElementById('etiqueta-respuesta');
        const toastIcon = document.getElementById('toast-icon-container');
        const toastTitle = document.getElementById('toast-title');
        const toastMsg = document.getElementById('toast-message');

        if (!toast) return;

        // Reset classes
        toast.className = 'hospira-toast ' + type + ' active';
        toastTitle.innerText = title;
        toastMsg.innerText = message;

        // Set Icon based on type
        if (type === 'success') {
            toastIcon.innerHTML = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>`;
        } else if (type === 'error') {
            toastIcon.innerHTML = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>`;
        } else if (type === 'warning') {
            toastIcon.innerHTML = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>`;
        }

        // Auto hide after 3.5 seconds
        setTimeout(() => {
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

		setTimeout(() => {
			modal.style.transition = 'opacity 0.4s ease';
			modal.style.opacity = 1;
		}, 10);
	}

	// ===========================
	// VARIABLES
	// ===========================

	const contenedorActualizarData = document.getElementById('contenedorActualizarData');
	const btnEditarPerfil = document.getElementById('btn_editar_usuario');
	const formActualizarDataUsuario = document.getElementById("formActualizarPerfil");
	const btnFormRegistrar = document.getElementById('miBoton');

	const ContenedorformularioReg = document.getElementById('contenedorGeneral');
	const btnCerrarFormReg = ContenedorformularioReg.querySelector('.btn-cerrar');
	const tbodyPacientes = document.querySelector('#mi_tabla_citas tbody');
	const formularioReg = document.getElementById('contenedorGeneral');
	const btnCerrarSession = document.getElementById('btn-cerrar-sesion');  

	const formularioEditarPac = document.getElementById('contenedor-formulario-edit-Pac');
	const botonEditarPac = document.getElementById("actualizarDatosPaciente");
	const formActualizarPac = document.getElementById('formActualizarPac');
	const btnCerrarEditPac = formularioEditarPac.querySelector('.btn-cerrar');

	const accion = 'obtenerDatos'
	let pacientesGlobal = [];

	function cargarPacientes() {

     fetch(`./GestionPacientesServlet?accion=${accion}`)
       .then(response => {
         if (!response.ok) throw new Error('Error al obtener pacientes');// excepcion obtenida ante la respuesta null 
         return response.json();
       })
       .then(listaPacientesData => {   //manejo de lista devuelta por el servlet 
         pacientesGlobal = listaPacientesData || [];
         tbodyPacientes.innerHTML = ''; 

         if (Array.isArray(listaPacientesData) && listaPacientesData.length > 0) {
           listaPacientesData.forEach(paciente => {
             const fila = document.createElement('tr');
             fila.innerHTML = `
               <td>${paciente.nombre}</td>
               <td>${paciente.Sexo}</td>
               <td>${paciente.Telefono}</td>
             <td>${paciente.Consulta}</td>
			 <td>${
				`
				<button class="btn-accion-pacienes btn-editar" data-dni="${paciente.DNI}" >editar</button>
				<button class="btn-accion-pacienes btn-eliminar" data-dni="${paciente.DNI}">eliminar</button>
				`			 }</td>

			 
			              `;
             
			 tbodyPacientes.appendChild(fila);
			 
			 })
		 }
		 
		 


 		 		 	
 	 })
  }
 			 		
//const formularioEditarPac = document.getElementById('contenedor-formulario-edit-Pac');
//const botonEditarPac = document.getElementById("actualizarDatosPaciente");
//const formActualizarPac = document.getElementById('formActualizarPac');

cargarPacientes();


document.addEventListener("click", function (event) {

			     const btn = event.target;

			     if (!btn.classList.contains("btn-accion-pacienes")) return;

			     const DNIPaciente = btn.dataset.dni;
			     const esEliminar = btn.classList.contains("btn-eliminar");

			 
			     if (esEliminar) {

			         const parametros = {
			             DNI: DNIPaciente,
			             accion: "eliminar"
			         };

			         enviarAlServlet(parametros, function() {
			             cargarPacientes();
			         });
			         return;
			     }

			    
			     abrirModal(formularioEditarPac);
			     
			     const pacienteEditar = pacientesGlobal.find(p => p.DNI === DNIPaciente);
			     if (pacienteEditar) {
			         let fechaFormateada = pacienteEditar.fecha || '';
			         if (fechaFormateada.length > 10) {
			             fechaFormateada = fechaFormateada.substring(0, 10);
			         }
			         
			         document.getElementById('cboParentescoPac').value = pacienteEditar.parentesco || '';
			         document.getElementById('txtCorreoPac').value = pacienteEditar.correo || '';
			         document.getElementById('txtfechaPac').value = fechaFormateada;
			         document.getElementById('txtTelefonoPac').value = pacienteEditar.Telefono || '';
			         document.getElementById('txtDireccionPac').value = pacienteEditar.Direccion || '';
			     }

			     // Guardamos el DNI en el botón guardar
			     botonEditarPac.dataset.dni = DNIPaciente;
			 });


			 
formActualizarPac.addEventListener('submit', function (event) {
			    event.preventDefault();

			     const parametros = {
			         DNI: botonEditarPac.dataset.dni,
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
			  
	function enviarAlServlet(parametros, onSuccess){
					fetch('./GestionPacientesServlet',{
						method:'POST',
						headers:
							{'Content-Type':'application/json'},
							body:JSON.stringify(parametros)
						
						
					})
					.then(response=> response.json())
					.then(data=>{
						if(data.estado){
							showToast('success', 'Operación Exitosa', data.mensaje);
							if (onSuccess) onSuccess();
						}else{
							showToast('error', 'Error en la Operación', data.mensaje);
						}

					})
					.catch(error => {
						console.error("Error en fetch:", error);
						showToast('error', 'Error del Sistema', 'Ocurrió un error al procesar la solicitud.');
					})

			
		}	  
			  
			  
			  
// ===========================
	// EVENT LISTENERS - MODALES
	// ===========================

	// Botón abrir formulario registro
	btnFormRegistrar.addEventListener('click', function () {
		if (window.getComputedStyle(ContenedorformularioReg).display === 'none') {
			abrirModal(ContenedorformularioReg);
		} else {
			cerrarModal(ContenedorformularioReg);
		}
	});

	// Botones cerrar modales
	btnCerrarFormReg.addEventListener('click', () => cerrarModal(ContenedorformularioReg));
	btnCerrarEditPac.addEventListener('click', () => cerrarModal(formularioEditarPac));

	// Abrir modal editar perfil usuario
	btnEditarPerfil.addEventListener('click', function () {
		if (window.getComputedStyle(contenedorActualizarData).display === 'none') {
			abrirModal(contenedorActualizarData);
		} else {
			cerrarModal(contenedorActualizarData);
		}
	});

	// Cerrar modal perfil usuario
	const btnCerrarActualizar = contenedorActualizarData.querySelector('.btn-cerrar');
	btnCerrarActualizar.addEventListener('click', () => cerrarModal(contenedorActualizarData));
  
  

// REGISTRAR PACIENTE 
  const formulario = document.getElementById('formulario');
  
  formulario.addEventListener('submit', function (event) {
    event.preventDefault();

    const parentesco = document.getElementById('cboParentesco').value.trim();
    const dni = document.getElementById('txtDni').value.trim();
    const sexo = document.getElementById('cboSexo').value;
    const apellidoPat = document.getElementById('txtApellidoPat').value.trim();
    const apellidoMat = document.getElementById('txtApellidoMat').value.trim();
    const nombre = document.getElementById('txtNombre').value.trim();
    const fecha = document.getElementById('txtfecha').value;
    const correo = document.getElementById('txtCorreo').value;
    const telefono = document.getElementById('txtTelefono').value.trim();
    const direccion = document.getElementById('txtDireccion').value.trim();
    const consulta = document.getElementById('txtMotivo').value.trim();

    if (!parentesco || !dni || !sexo || !apellidoPat || !apellidoMat || !nombre || !fecha || !correo || !telefono || !direccion || !consulta) {
      showToast('warning', 'Campos Incompletos', 'Completa todos los campos obligatorios antes de continuar.');
      return;
    }

    if (!/^\d{8}$/.test(dni)) {
      showToast('warning', 'DNI Inválido', 'El DNI debe contener exactamente 8 dígitos numéricos.');
      return;
    }

    if (!/^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$/.test(correo)) {
      showToast('warning', 'Correo Inválido', 'Por favor, ingresa una dirección de correo electrónico válida.');
      return;
    }

    const datos = {
      accion: "registrar",
      parentesco,
      dni,
      sexo,
      apellidoPat,
      apellidoMat,
      nombre,
      fecha,
      correo,
      telefono,
      direccion,
      consulta,
    };

    fetch('./GestionPacientesServlet', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(datos)
    })
      .then(response => response.json())  // procesa respuesta del servidor convirtiendolo a  json 
      .then(data => {

   

		  if (data.estado) {
		          showToast('success', 'Registro Exitoso', data.mensaje);
		          formularioReg.style.display = 'none';
		          cargarPacientes(); 
		        } else { // si el parametro estado entra es false
		          showToast('error', 'Error de Registro', data.mensaje); 
                }
		      })
		      .catch(error => {
		        console.error("Error en fetch:", error);
		        showToast('error', 'Error del Sistema', 'Ocurrió un error inesperado al registrar el paciente.');
		      });
		  
		});
     
		
		
		formActualizarDataUsuario.addEventListener("submit", function (event) {
		    event.preventDefault();

			const correo = document.getElementById('txtActualizarCorreo').value.trim(); 

		    const peso = document.getElementById('peso-txt').value.trim(); 
		    const altura = document.getElementById('altura-txt').value.trim(); 
			const tipoSangre = document.getElementById('sangre-txt').value.trim();
		    if (!peso || !altura || !tipoSangre || !correo ) {
		        showToast('warning', 'Campos Incompletos', 'Completa todo tu perfil médico antes de guardar cambios.');
		        return;
		    }

		    const parametros = {
		        accion: "actualizarDatos", 
				correo: correo,
		        peso: peso,
		        altura: altura,
		        tipoSangre: tipoSangre
		    };

		    const submitBtn = formActualizarDataUsuario.querySelector('button[type="submit"]');
		    const originalText = submitBtn.textContent;
		    submitBtn.textContent = "Guardando...";
		    submitBtn.disabled = true;  

		    fetch("./GestionUsuarioServlet", {
		        method: 'POST',
		        headers: { 'Content-Type': 'application/json' },
		        body: JSON.stringify(parametros)
		    })
		    .then(response => {
		        if (!response.ok) throw new Error("Error en el servidor");
		        return response.json();
		    })
.then(data => {
		        if (data.status) {
		            submitBtn.textContent = '¡Perfil Actualizado!';
		            submitBtn.style.backgroundColor = '#10b981'; // Premium success color
		            submitBtn.style.color = '#fff';
		            submitBtn.style.transition = 'all 0.3s ease';
                    showToast('success', 'Perfil Actualizado', 'Tus datos médicos se han actualizado correctamente.');
		            setTimeout(() => { 
		                submitBtn.textContent = originalText;
		                submitBtn.style.backgroundColor = '';
		                submitBtn.style.color = '';
		                submitBtn.disabled = false;
		                cerrarModal(contenedorActualizarData); 
		            }, 2000);
		        } else {
		            showToast('error', 'Error al Actualizar', data.mensaje);
		            submitBtn.textContent = originalText;
		            submitBtn.disabled = false;
		        }
		    })
		    .catch(error => {
		        console.error("Error:", error);
		        showToast('error', 'Error del Sistema', 'No se pudo contactar con el servidor. Intenta de nuevo.');
		        submitBtn.textContent = originalText;
		        submitBtn.disabled = false;
		    });
		});
		   

		 
		 
		 
		 
		btnCerrarSession.addEventListener('click',function(){
            // Use custom premium confirm pattern inside a toast style or just directly trigger if accepted
            // Since we don't have a full modal designed for confirmation, we will use a tailored UX here:
            showToast('warning', 'Cerrando Sesión...', 'Saliendo de la plataforma segura...');
            
            const parametros = {accion : "cerrarSesion"};
            
            // Adding a stylized delay to match the fade out animations
            setTimeout(() => {
                fetch("./GestionUsuarioServlet", {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(parametros )
                })
                .then(() => {
                    document.body.style.transition = 'opacity 0.6s ease';
                    document.body.style.opacity = '0';
                    setTimeout(() => {
                        window.location.href = 'Login.jsp';
                    }, 600);
                });
            }, 1200);
		})
	
		
		
  
  });