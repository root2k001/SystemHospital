document.addEventListener('DOMContentLoaded', function () {

    const formularioRegister = document.getElementById('formulario-Register');

    formularioRegister.addEventListener('submit', function (e) {
        e.preventDefault();

        const registrar = "registrar";
        const toast = document.getElementById('etiqueta-respuesta');
        const toastIcon = document.getElementById('toast-icon-container');
        const toastTitle = document.getElementById('toast-title');
        const toastMsg = document.getElementById('toast-message');

        const datos = {
            dni: document.getElementById('dni-txt').value,
            nombre: document.getElementById('nombre-txt').value,
            apellido: document.getElementById('Apellido-txt').value,
            genero: document.getElementById('Sexo-txt').value,
            fechaNac: document.getElementById('txtfecha').value,
            correo: document.getElementById('correo-txt').value,
            contrasena: document.getElementById('contrasena-txt').value,
            accion: registrar,
        };

        if (!datos.dni || !datos.genero || !datos.apellido || !datos.nombre || !datos.fechaNac || !datos.correo || !datos.contrasena) {
            if (toast) {
                toast.className = 'hospira-toast warning active';
                toastTitle.innerText = 'Campos Incompletos';
                toastMsg.innerText = 'Completa todos los campos antes de continuar.';
                toastIcon.innerHTML = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>`;
                setTimeout(() => toast.classList.remove('active'), 3500);
            }
            return;
        }

        fetch('./Autentificacion', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(datos)
        })
        .then(response => response.json())
        .then(resultado => {
            if (resultado.estado) {
                console.log(resultado.mensaje);
                if (toast) {
                    toast.className = 'hospira-toast success active';
                    toastTitle.innerText = 'Registro Exitoso';
                    toastMsg.innerText = resultado.mensaje || 'Cuenta creada correctamente.';
                    toastIcon.innerHTML = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>`;

                    setTimeout(function () {
                        window.location.href = 'Login.jsp';
                    }, 2000);
                }
            } else {
                console.log("Error: " + resultado.mensaje);
                if (toast) {
                    toast.className = 'hospira-toast error active';
                    toastTitle.innerText = 'Error en Registro';
                    toastMsg.innerText = resultado.mensaje || 'No se pudo completar el registro.';
                    toastIcon.innerHTML = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>`;

                    setTimeout(function () {
                        toast.classList.remove('active');
                    }, 5000);
                }
            }
        })
        .catch(error => {
            console.error('Error en el registro:', error);
            if (toast) {
                toast.className = 'hospira-toast error active';
                document.getElementById('toast-title').innerText = 'Error de Conexión';
                document.getElementById('toast-message').innerText = 'Hubo un fallo al contactar al servidor médico.';
                document.getElementById('toast-icon-container').innerHTML = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>`;
                setTimeout(() => toast.classList.remove('active'), 5000);
            }
        });
    });
});