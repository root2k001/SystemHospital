<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/globals.css">
    <link rel="stylesheet" href="css/Login.css">
    <title>Hospira Premium | Acceso</title>
</head>
<body>

    <main class="page-container">
        <div class="split-layout">
            <!-- Left Side: Visual/Medical Branding -->
            <div class="visual-side">
                <div class="branding-content">
                    <div class="medical-icon animate-pulse-slow">
                        <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='60' height='60' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z'/%3E%3Cpath d='M12 5 9.04 7.96a2.17 2.17 0 0 0 0 3.08c.82.82 2.13.82 2.96 0l2.96-2.96a2.17 2.17 0 0 1 3.08 0c.82.82.82 2.13 0 2.96L12 17l-5.96-5.96'/%3E%3C/svg%3E" alt="Medical Icon" />
                    </div>
                    <h1 class="brand-title">Hospira <span>Premium</span></h1>
                    <p class="brand-tagline">Excelencia e Innovación en Gestión Hospitalaria</p>
                </div>
                <div class="bg-pattern"></div>
            </div>

            <!-- Right Side: Login Form -->
            <div class="form-side">
                <div id="registro-contenedor" class="glass animate-float-up">
                    <form id="formulario-Log">
                        <div class="form-header">
                            <h2>Iniciar Sesión</h2>
                            <p>Bienvenido al Centro de Gestión</p>
                        </div>
                        
                        <div class="content-divs">
                            <label for="correo-txt">Correo Electrónico</label>
                            <div class="input-wrapper">
                                <input class="inputs" type="email" id="correo-txt" placeholder="usuario@hospital.com" required />
                            </div>
                        </div>
                         
                        <div class="content-divs">
                            <label for="contrasena-txt">Contraseña</label>
                            <div class="input-wrapper">
                                <input class="inputs" type="password" id="contrasena-txt" placeholder="••••••••" required />
                            </div>
                        </div>
                        
                        <button id="btnlogin" type="submit" class="btn-primary">
                            <span>Ingresar al Sistema</span>
                        </button>
                        
                        <div class="btn-registrar">
                            ¿Aún no eres parte? <a href="Register.jsp" id="btnProcesar">Regístrate aquí</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="items/mensaje_respuesta.jsp"></jsp:include>

    <script src="js/assets.js" type="text/javascript" defer></script>
</body>
</html>