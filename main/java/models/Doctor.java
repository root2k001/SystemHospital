package models;

public class Doctor {

    private int    id;
    private String nombre;
    private String especialidad;
    private String CML;
    private String celular;
    private String correo;
    private String imagen;
    private boolean activo;
    private String bio;
    private double rating;
    private double precio;
    private String avatarEmoji;
    private int    duracionMin;

    public Doctor() {}

    public Doctor(int id, String nombre, String especialidad, String CML, String celular,
                  String correo, String imagen, boolean activo, String bio,
                  double rating, double precio, String avatarEmoji, int duracionMin) {
        this.id          = id;
        this.nombre      = nombre;
        this.especialidad = especialidad;
        this.CML         = CML;
        this.celular     = celular;
        this.correo      = correo;
        this.imagen      = imagen;
        this.activo      = activo;
        this.bio         = bio;
        this.rating      = rating;
        this.precio      = precio;
        this.avatarEmoji = avatarEmoji;
        this.duracionMin = duracionMin;
    }

    // ── Getters & Setters ──────────────────────────────────────

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getEspecialidad() { return especialidad; }
    public void setEspecialidad(String especialidad) { this.especialidad = especialidad; }

    public String getCML() { return CML; }
    public void setCML(String CML) { this.CML = CML; }

    public String getCelular() { return celular; }
    public void setCelular(String celular) { this.celular = celular; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getImagen() { return imagen; }
    public void setImagen(String imagen) { this.imagen = imagen; }

    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public double getPrecio() { return precio; }
    public void setPrecio(double precio) { this.precio = precio; }

    public String getAvatarEmoji() { return avatarEmoji; }
    public void setAvatarEmoji(String avatarEmoji) { this.avatarEmoji = avatarEmoji; }

    public int getDuracionMin() { return duracionMin; }
    public void setDuracionMin(int duracionMin) { this.duracionMin = duracionMin; }
}
