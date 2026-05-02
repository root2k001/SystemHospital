package models;

public class Consulta {

    private int    id;
    private int    pacienteId;
    private int    doctorId;
    private String fecha;          // 'YYYY-MM-DD'
    private String hora;           // '08:00'
    private String motivo;
    private String codigoReserva;
    private String metodoPago;     // 'inmediato' | 'presencial'
    private String estado;         // 'Reservada' | 'Completada' | 'Cancelada'
    private String tipoReserva;    // 'titular' | 'familiar'

    public Consulta() {}

    public Consulta(int pacienteId, int doctorId, String fecha, String hora,
                    String motivo, String codigoReserva, String metodoPago,
                    String estado, String tipoReserva) {
        this.pacienteId    = pacienteId;
        this.doctorId      = doctorId;
        this.fecha         = fecha;
        this.hora          = hora;
        this.motivo        = motivo;
        this.codigoReserva = codigoReserva;
        this.metodoPago    = metodoPago;
        this.estado        = estado;
        this.tipoReserva   = tipoReserva;
    }

    // ── Getters & Setters ──────────────────────────────────────

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPacienteId() { return pacienteId; }
    public void setPacienteId(int pacienteId) { this.pacienteId = pacienteId; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public String getFecha() { return fecha; }
    public void setFecha(String fecha) { this.fecha = fecha; }

    public String getHora() { return hora; }
    public void setHora(String hora) { this.hora = hora; }

    public String getMotivo() { return motivo; }
    public void setMotivo(String motivo) { this.motivo = motivo; }

    public String getCodigoReserva() { return codigoReserva; }
    public void setCodigoReserva(String codigoReserva) { this.codigoReserva = codigoReserva; }

    public String getMetodoPago() { return metodoPago; }
    public void setMetodoPago(String metodoPago) { this.metodoPago = metodoPago; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getTipoReserva() { return tipoReserva; }
    public void setTipoReserva(String tipoReserva) { this.tipoReserva = tipoReserva; }
}
