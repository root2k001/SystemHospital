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
	const mensajeExito = document.getElementById('mensajeExito');
	const btnCerrarSession = document.getElementById('btn-cerrar-sesion');  

	const formularioEditarPac = document.getElementById('contenedor-formulario-edit-Pac');
	const botonEditarPac = document.getElementById("actualizarDatosPaciente");
	const formActualizarPac = document.getElementById('formActualizarPac');
	const btnCerrarEditPac = formularioEditarPac.querySelector('.btn-cerrar');

	const accion = 'obtenerDatos'

	function cargarPacientes() {

     fetch(`./GestionPacientesServlet?accion=${accion}`)
       .then(response => {
         if (!response.ok) throw new Error('Error al obtener pacientes');// excepcion obtenida ante la respuesta null 
         return response.json();
       })
       .then(listaPacientesData => {   //manejo de lista devuelta por el servlet 
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

			         enviarAlServlet(parametros);
			         return;
			     }

			    
			     abrirModal(formularioEditarPac);

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
							alert(data.mensaje);
							if (onSuccess) onSuccess();
						}else{
							alert("Error : " + data.mensaje)
						}

					})
					.catch(error => {
						console.error("Error en fetch:", error);
						alert("Ocurrió un error AL REALIZAR OPERACION.");

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
      alert("Completa todos los campos antes de continuar.");
      return;
    }

    if (!/^\d{8}$/.test(dni)) {
      alert("El DNI debe tener 8 dígitos.");
      return;
    }

    if (!/^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$/.test(correo)) {
      alert("El correo electrónico no es válido.");
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
		          alert(data.mensaje); 
		          formularioReg.style.display = 'none';
		          cargarPacientes(); 
		        } else { // si el parametro estado entra es false
		          alert(data.mensaje); }
		      })
		      .catch(error => {
		        console.error("Error en fetch:", error);
		        alert("Ocurrió un error al registrar el paciente: " + error.message);
		      });
		  
		});
     
		
		
		formActualizarDataUsuario.addEventListener("submit", function (event) {
		    event.preventDefault();

			const correo = document.getElementById('txtActualizarCorreo').value.trim(); 

		    const peso = document.getElementById('peso-txt').value.trim(); 
		    const altura = document.getElementById('altura-txt').value.trim(); 
			const tipoSangre = document.getElementById('sangre-txt').value.trim();
		    if (!peso || !altura || !tipoSangre || !correo ) {
		        alert("Completa todos los campos antes de continuar.");
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
		            mensajeExito.style.display = 'block';
		            setTimeout(() => { mensajeExito.style.display = 'none'; }, 3000);
		            cerrarModal(contenedorActualizarData);
		        } else {
		            alert("Error: " + data.mensaje);
		        }
		    })
		    .catch(error => {
		        console.error("Error:", error);
		        alert("Error al actualizar: " + error.message);
		    })
		    .finally(() => {
		        submitBtn.textContent = originalText;
		        submitBtn.disabled = false;
		    });
		});
		   

		 
		 
		 
		 
		btnCerrarSession.addEventListener('click',function(){
			if(confirm("¿estas seguro de cerrar sesion?")){
				
			const parametros= {accion : "cerrarSesion"};
				
				fetch("./GestionUsuarioServlet", {
						        method: 'POST',
						        headers: { 'Content-Type': 'application/json' },
						        body: JSON.stringify(parametros )
						    })
				.then(() => {
					window.location.href = 'Login.jsp';
					});
			}
			
		})
	
		
		
  
  });