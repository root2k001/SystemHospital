<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="js/assets.js" type="text/javascript"></script>
<link rel="stylesheet" href="css/Login.css">
<title>SystemHospital | Acceso</title>
</head>
<body>

	<div id="registro-contenedor">
			<form id="formulario-Log">
				<p>Acceso al Sistema</p>
			    
			    <div class="content-divs">
			        <label>Correo Electrónico</label>
			        <input class="inputs" type="email" id="correo-txt" placeholder="usuario@hospital.com" />
			    </div>
			     
			    <div class="content-divs">
			        <label>Contraseña</label>
			        <input class="inputs" type="password" id="contrasena-txt" placeholder="••••••••"/>
			    </div>
			    
			    <button id="btnlogin" type="submit">Iniciar Sesión</button>
			    
			    <div class="btn-registrar">
						¿No tienes una cuenta? <a href="Register.jsp" id="btnProcesar">Regístrate aquí</a>
                </div>
			</form>
	</div>

	<jsp:include page="items/mensaje_respuesta.jsp"></jsp:include>

</body>
</html>