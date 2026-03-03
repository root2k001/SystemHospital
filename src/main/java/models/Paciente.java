package models;

public class Paciente {

	
	int id ;
	String  parentesco;
	 String dni;
	String  sexo;
	String  apellidoPat;
	String  apellidoMat;
	String nombre;
    String fecha;
    String correo;
    String telefono;
    String direccion;
    String consulta;
     int usuarioId; 
    
     public Paciente() {
 		super();
 	}
 	
 	public Paciente(int id, String parentesco, String dni, String sexo, String apellidoPat, String apellidoMat,
 			String nombre, String fecha, String correo, String telefono, String direccion, String consulta,
 			int usuarioId) {
 		super();
 		this.id = id;
 		this.parentesco = parentesco;
 		this.dni = dni;
 		this.sexo = sexo;
 		this.apellidoPat = apellidoPat;
 		this.apellidoMat = apellidoMat;
 		this.nombre = nombre;
 		this.fecha = fecha;
 		this.correo = correo;
 		this.telefono = telefono;
 		this.direccion = direccion;
 		this.consulta = consulta;
 		this.usuarioId = usuarioId;
 	}
 	

	public String getParentesco() {
		return parentesco;
	}

	 public void setParentesco(String parentesco) {
		 this.parentesco = parentesco;
	 }

	 public String getDni() {
		 return dni;
	 }

	 public void setDni(String dni) {
		 this.dni = dni;
	 }

	 public String getApellidoPat() {
		 return apellidoPat;
	 }

	 public void setApellidoPat(String apellidoPat) {
		 this.apellidoPat = apellidoPat;
	 }

	 public String getApellidoMat() {
		 return apellidoMat;
	 }

	 public void setApellidoMat(String apellidoMat) {
		 this.apellidoMat = apellidoMat;
	 }

	 public String getCorreo() {
		 return correo;
	 }

	 public void setCorreo(String correo) {
		 this.correo = correo;
	 }

	 public int getUsuarioId() {
		 return usuarioId;
	 }

	 public void setUsuarioId(int usuarioId) {
		 this.usuarioId = usuarioId;
	 }


	
	


	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getSexo() {
		return sexo;
	}
	public void setSexo(String sexo) {
		this.sexo = sexo;
	}
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getConsulta() {
		return consulta;
	}
	public void setConsulta(String consulta) {
		this.consulta = consulta;
	}
	public int getusuarioId() {
		return usuarioId;
	}
	public void setusuarioId(int usuarioId) {
		this.usuarioId = usuarioId;
	}

	
	
	
	
	
	
	
	
	
	
}
