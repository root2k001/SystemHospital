<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="js/Register.js" type="text/javascript"></script>
<link rel="stylesheet" href="css/Register.css">
<title>SystemHospital | Registro</title>
</head>
<body>

<form id="formulario-Register">
		
		<div class="labelcontainer">
			<label>DNI:</label>
			<input class="inputs" type="text" id="dni-txt" placeholder="Número de Documento" required>
		</div>

		<div class="labelcontainer">
			<label>Nombres:</label>
			<input class="inputs" type="text" id="nombre-txt" placeholder="Nombres Completos" required>
		</div>

		<div class="labelcontainer">
			<label>Apellidos:</label>
			<input class="inputs" type="text" id="Apellido-txt" placeholder="Apellidos Completos" required>
		</div>

		<div class="labelcontainer">
			<label for="sexo">Género:</label>
			<select class="inputs" id="Sexo-txt" required>
					<option value="" disabled selected>Seleccione</option>
					<option value="Masculino">Masculino</option>	          
					<option value="Femenino">Femenino</option>
			</select>
		</div>

    	<div class="labelcontainer">
			<label>Fecha de Nacimiento:</label>
			<input class="inputs" id="txtfecha" type="date" name="fecha_nacimiento" required>
       </div>

		<div class="labelcontainer">
			<label>Correo Electrónico:</label>
			<input class="inputs" type="email" id="correo-txt" placeholder="usuario@hospital.com" required>
		</div>
		
		<div class="labelcontainer">
			<label>Contraseña:</label>
			<input class="inputs" type="password" id="contrasena-txt" placeholder="••••••••" required>
		</div>

		<button type="submit" class="buttons" id="btn-submit">Registrar Paciente</button>

</form>
<jsp:include page="items/mensaje_respuesta.jsp"></jsp:include>

</body>
</html>