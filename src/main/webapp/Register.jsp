<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/globals.css">
    <link rel="stylesheet" href="css/Register.css">
    <title>Hospira Premium | Registro de Paciente</title>
</head>
<body>

    <main class="page-container">
        <div id="registro-contenedor" class="glass animate-float-up">
            <header class="register-header">
                <div class="brand-badge">Hospira Premium</div>
                <h2>Registro de Nuevo Paciente</h2>
                <p>Complete la información para crear su historial clínico digital</p>
            </header>

            <form id="formulario-Register">
                <!-- Section 1: Información Personal -->
                <section class="form-section">
                    <div class="section-title">
                        <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='20' height='20' viewBox='0 0 24 24' fill='none' stroke='%230284C7' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2'/%3E%3Ccircle cx='12' cy='7' r='4'/%3E%3C/svg%3E" alt="Info" />
                        Información Personal
                    </div>
                    
                    <div class="grid-fields">
                        <div class="labelcontainer">
                            <label for="dni-txt">DNI / Documento</label>
                            <input class="inputs" type="text" id="dni-txt" placeholder="Número de Documento" required>
                        </div>

                        <div class="labelcontainer">
                            <label for="txtfecha">Fecha de Nacimiento</label>
                            <input class="inputs" id="txtfecha" type="date" name="fecha_nacimiento" required>
                        </div>

                        <div class="labelcontainer">
                            <label for="nombre-txt">Nombres</label>
                            <input class="inputs" type="text" id="nombre-txt" placeholder="Nombres Completos" required>
                        </div>

                        <div class="labelcontainer">
                            <label for="Apellido-txt">Apellidos</label>
                            <input class="inputs" type="text" id="Apellido-txt" placeholder="Apellidos Completos" required>
                        </div>

                        <div class="labelcontainer full-width">
                            <label for="Sexo-txt">Género</label>
                            <select class="inputs" id="Sexo-txt" required>
                                <option value="" disabled selected>Seleccione género</option>
                                <option value="Masculino">Masculino</option>	          
                                <option value="Femenino">Femenino</option>
                                <option value="Otro">Otro</option>
                            </select>
                        </div>
                    </div>
                </section>

                <!-- Section 2: Credenciales de Acceso -->
                <section class="form-section">
                    <div class="section-title">
                        <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='20' height='20' viewBox='0 0 24 24' fill='none' stroke='%230284C7' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Crect width='18' height='11' x='3' y='11' rx='2' ry='2'/%3E%3Cpath d='M7 11V7a5 5 0 0 1 10 0v4'/%3E%3C/svg%3E" alt="Credentials" />
                        Credenciales de Acceso
                    </div>

                    <div class="grid-fields">
                        <div class="labelcontainer">
                            <label for="correo-txt">Correo Electrónico</label>
                            <input class="inputs" type="email" id="correo-txt" placeholder="usuario@ejemplo.com" required>
                        </div>
                        
                        <div class="labelcontainer">
                            <label for="contrasena-txt">Contraseña</label>
                            <input class="inputs" type="password" id="contrasena-txt" placeholder="••••••••" required>
                        </div>
                    </div>
                </section>

                <div class="form-actions">
                    <button type="submit" class="btn-primary" id="btn-submit">
                        <span>Confirmar Registro de Paciente</span>
                    </button>
                    <div class="login-link">
                        ¿Ya tienes una cuenta? <a href="Login.jsp">Inicia sesión</a>
                    </div>
                </div>
            </form>
        </div>
    </main>

    <jsp:include page="items/mensaje_respuesta.jsp"></jsp:include>

    <script src="js/Register.js" type="text/javascript" defer></script>
</body>
</html>