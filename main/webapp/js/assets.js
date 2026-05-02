document.addEventListener('DOMContentLoaded', function() {

    var formularioLogin = document.getElementById('formulario-Log');
    
    formularioLogin.addEventListener('submit', function(event) {
        event.preventDefault();
        
        var login = "login";
        var toast = document.getElementById('etiqueta-respuesta');
        var toastIcon = document.getElementById('toast-icon-container');
        var toastTitle = document.getElementById('toast-title');
        var toastMsg = document.getElementById('toast-message');

        var correoLog = document.getElementById('correo-txt').value;
        var contrasenaLog = document.getElementById('contrasena-txt').value;

        if (correoLog.trim() === "" || contrasenaLog.trim() === "") {
            if (toast) {
                toast.className = 'hospira-toast warning active';
                toastTitle.innerText = 'Campos Incompletos';
                toastMsg.innerText = 'Por favor, ingresa tu correo y contrase\u00f1a.';
                toastIcon.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>';
                setTimeout(function () { 
                    toast.classList.remove('active'); 
                }, 3500);
            }
            return;
        }

        var datos = {
            correo: correoLog,
            contrasena: contrasenaLog,
            accion: login,
        };

        fetch('./Autentificacion', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(datos)
        })
        .then(function (response) { return response.json(); })
        .then(function (data) {
            console.log("Respuesta del servidor", data);

            if (data.status === "success") {
                // Success State: Hospira Premium Welcome
                if (toast) {
                    toast.className = 'hospira-toast success active';
                    toastTitle.innerText = '\u00a1Bienvenido!';
                    toastMsg.innerText = data.mensaje || 'Acceso concedido correctamente.';
                    toastIcon.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>';
                    
                    setTimeout(function() {
                        window.location.href = 'GestionPacientes.jsp';
                    }, 1500);
                }
            } else {
                // Error State: Medical Alert
                if (toast) {
                    toast.className = 'hospira-toast error active';
                    toastTitle.innerText = 'Error de Acceso';
                    toastMsg.innerText = data.mensaje || 'Credenciales inv\u00e1lidas.';
                    toastIcon.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>';

                    setTimeout(function() {
                        toast.classList.remove('active');
                    }, 4000);
                }
            }
        })
        .catch(function (error) {
            console.error("Error:", error);
            if (toast) {
                toast.className = 'hospira-toast error active';
                toastTitle.innerText = 'Error del Sistema';
                toastMsg.innerText = 'No se pudo conectar con el servidor m\u00e9dico.';
                toastIcon.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>';
                setTimeout(function () { 
                    toast.classList.remove('active'); 
                }, 4000);
            }
        });
    });
});