package models;

public class Usuario {

	int id ;
	String dni;
	String nombre;
    String apellido;
    String correo;
    String fechNac;

  
	String sexo;
    String contrasena;
    String tipoDeSangre;
    String altura;
    String peso;
    String fotoPerfil;

    
    
    
	public Usuario(int id, String dni, String nombre, String apellido, String correo, String fechNac, String sexo,
			String contrasena) {
		super();
		this.id = id;
		this.dni = dni;
		this.nombre = nombre;
		this.apellido = apellido;
		this.correo = correo;
		this.fechNac = fechNac;
		this.sexo = sexo;
		this.contrasena = contrasena;
	}

	public String getFechNac() {
		return fechNac;
	}

	public void setFechNac(String fechNac) {
		this.fechNac = fechNac;
	}

	public String getSexo() {
		return sexo;
	}

	public void setSexo(String sexo) {
		this.sexo = sexo;
	}

	public String getTipoDeSangre() {
		return tipoDeSangre;
	}

	public void setTipoDeSangre(String tipoDeSangre) {
		this.tipoDeSangre = tipoDeSangre;
	}

	public String getAltura() {
		return altura;
	}

	public void setAltura(String altura) {
		this.altura = altura;
	}

	public String getPeso() {
		return peso;
	}

	public void setPeso(String peso) {
		this.peso = peso;
	}



	
	  public Usuario(int id, String dni, String nombre, String apellido, String correo, String fechNac, String sexo,
			String contrasena, String tipoDeSangre, String altura, String peso) {
		super();
		this.id = id;
		this.dni = dni;
		this.nombre = nombre;
		this.apellido = apellido;
		this.correo = correo;
		this.fechNac = fechNac;
		this.sexo = sexo;
		this.contrasena = contrasena;
		this.tipoDeSangre = tipoDeSangre;
		this.altura = altura;
		this.peso = peso;
	}

	  public Usuario(String dni,String nombre, String apellido, String correo, String fechNac, String sexo, String contrasena) {
			super();
			this.dni=dni;
			this.nombre = nombre;
			this.apellido = apellido;
			this.correo = correo;
			this.fechNac = fechNac;
			this.sexo = sexo;
			this.contrasena = contrasena;
		}
	public String getDni() {
		return dni;
	}

	  public void setDni(String dni) {
		  this.dni = dni;
	  }

	public Usuario() {
		super();
	}

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getApellido() {
		return apellido;
	}
	public void setApellido(String apellido) {
		this.apellido = apellido;
	}
	public String getCorreo() {
		return correo;
	}
	public void setCorreo(String correo) {
		this.correo = correo;
	}
	public String getContrasena() {
		return contrasena;
	}
	public void setContrasena(String contrasena) {
		this.contrasena = contrasena;
	}

    public String getFotoPerfil() { return fotoPerfil; }
    public void setFotoPerfil(String fotoPerfil) { this.fotoPerfil = fotoPerfil; }
}
