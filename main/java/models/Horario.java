package models;

public class Horario {

    private int    id;
    private int    doctorId;
    private String diaSemana;    // 'Lunes', 'Martes', etc.
    private String horaInicio;   // '08:00'
    private String horaFin;      // '08:20'
    private boolean activo;

    public Horario() {}

    public Horario(int id, int doctorId, String diaSemana,
                   String horaInicio, String horaFin, boolean activo) {
        this.id         = id;
        this.doctorId   = doctorId;
        this.diaSemana  = diaSemana;
        this.horaInicio = horaInicio;
        this.horaFin    = horaFin;
        this.activo     = activo;
    }

    // ── Getters & Setters ──────────────────────────────────────

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public String getDiaSemana() { return diaSemana; }
    public void setDiaSemana(String diaSemana) { this.diaSemana = diaSemana; }

    public String getHoraInicio() { return horaInicio; }
    public void setHoraInicio(String horaInicio) { this.horaInicio = horaInicio; }

    public String getHoraFin() { return horaFin; }
    public void setHoraFin(String horaFin) { this.horaFin = horaFin; }

    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }
}
