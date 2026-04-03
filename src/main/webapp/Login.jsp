<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">


<script src="js/assets.js" type="text/javascript"></script>

<link rel="stylesheet" href="css/Login.css">


<title>Insert title here</title>
</head>
<body>

		<p>HOLA PUTA </p>


	<div  id ="registro-contenedor">
	
			<form  id="formulario-Log">
				<p>Login</p>
			    <div class="content-divs" >
			        <label>correo</label>
			        <input class="inputs"	type="email" id="correo-txt" />
			    </div>
			    <br>
			     
			    <div class="content-divs" >
			        <label>contraseña</label>
			        <input class="inputs"	type="password" id="contrasena-txt"/>
			    </div>
			    <br>
			    
			    <button id="btnlogin" type="submit">Login</button>
			     <br><br>
			    
			    <div class="btn-registrar">
						<a href="Register.jsp" id="btnProcesar">Registrarse</a>
                 </div>
			</form>
	</div>

					<jsp:include page="items/mensaje_respuesta.jsp"></jsp:include>



</body>
</html>