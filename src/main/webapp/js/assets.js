document.addEventListener('DOMContentLoaded', function() {

    const formularioLogin = document.getElementById('formulario-Log');
    
    formularioLogin.addEventListener('submit', function(event) {
        event.preventDefault();
        
        const login = "login";
        const toast = document.getElementById('etiqueta-respuesta');
        const toastIcon = document.getElementById('toast-icon-container');
        const toastTitle = document.getElementById('toast-title');
        const toastMsg = document.getElementById('toast-message');

        const correoLog = document.getElementById('correo-txt').value;
        const contrasenaLog = document.getElementById('contrasena-txt').value;

        if (correoLog.trim() === "" || contrasenaLog.trim() === "") {
            if (toast) {
                toast.className = 'hospira-toast warning active';
                toastTitle.innerText = 'Campos Incompletos';
                toastMsg.innerText = 'Por favor, ingresa tu correo y contraseña.';
                toastIcon.innerHTML = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>`;
                setTimeout(() => toast.classList.remove('active'), 3500);
            }
            return;
        }

        const datos = {
            correo: correoLog,
            contrasena: contrasenaLog,
            accion: login,
        }

        fetch('./Autentificacion', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(datos)
        })
        .then(response => response.json())
        .then(data => {
            console.log("Respuesta del servidor", data);

            if (data.status === "success") {
                // Success State: Hospira Premium Welcome
                if (toast) {
                    toast.className = 'hospira-toast success active';
                    toastTitle.innerText = '¡Bienvenido!';
                    toastMsg.innerText = data.mensaje || 'Acceso concedido correctamente.';
                    toastIcon.innerHTML = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>`;
                    
                    setTimeout(function() {
                        window.location.href = 'GestionPacientes.jsp';
                    }, 1500);
                }
            } else {
                // Error State: Medical Alert
                if (toast) {
                    toast.className = 'hospira-toast error active';
                    toastTitle.innerText = 'Error de Acceso';
                    toastMsg.innerText = data.mensaje || 'Credenciales inválidas.';
                    toastIcon.innerHTML = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>`;

                    setTimeout(function() {
                        toast.classList.remove('active');
                    }, 4000);
                }
            }
        })
        .catch(error => {
            console.error("Error:", error);
            if (toast) {
                toast.className = 'hospira-toast error active';
                toastTitle.innerText = 'Error del Sistema';
                toastMsg.innerText = 'No se pudo conectar con el servidor médico.';
                toastIcon.innerHTML = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>`;
                setTimeout(() => toast.classList.remove('active'), 4000);
            }
        });
    });
});