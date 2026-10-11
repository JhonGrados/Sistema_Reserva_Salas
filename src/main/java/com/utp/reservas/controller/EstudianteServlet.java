package com.utp.reservas.controller;

import com.utp.reservas.dao.ReservaDAO;
import com.utp.reservas.dao.SalaDAO;
import com.utp.reservas.dto.Reserva;
import com.utp.reservas.dto.Sala;
import com.utp.reservas.dto.Usuario;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "EstudianteServlet", urlPatterns = {"/EstudianteServlet"})
public class EstudianteServlet extends HttpServlet {

    private ReservaDAO reservaDAO;
    private SalaDAO salaDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.reservaDAO = new ReservaDAO();
        this.salaDAO = new SalaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarPeticion(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarPeticion(request, response);
    }

    private void procesarPeticion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp?error=" + URLEncoder.encode("Debes iniciar sesión para ingresar.", StandardCharsets.UTF_8));
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String rol = (String) session.getAttribute("rol");

        if (rol == null || !"ESTUDIANTE".equalsIgnoreCase(rol)) {
            response.sendRedirect("error/acceso_denegado.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "dashboard";
        }

        switch (action.toLowerCase()) {
            case "dashboard":
                mostrarDashboard(request, response, usuario);
                break;

            case "mis_reservas":
                mostrarMisReservas(request, response, usuario);
                break;

            case "nueva_reserva":
                mostrarFormularioNuevaReserva(request, response, usuario);
                break;

            case "guardar_reserva":
                guardarReserva(request, response, usuario);
                break;

            case "cancelar":
                cancelarReserva(request, response, usuario);
                break;

            default:
                mostrarDashboard(request, response, usuario);
                break;
        }
    }

    private void mostrarDashboard(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        int idUsuario = usuario.getIdUsuario();

        Reserva proximaReserva = reservaDAO.obtenerProximaReserva(idUsuario);
        int totalReservas = reservaDAO.contarTotalReservas(idUsuario);
        int reservasActivas = reservaDAO.contarReservasActivas(idUsuario);
        int horasHoy = reservaDAO.obtenerHorasReservadasHoy(idUsuario);
        List<Sala> salasDisponibles = salaDAO.listarSalasDisponibles();

        request.setAttribute("proximaReserva", proximaReserva);
        request.setAttribute("totalReservas", totalReservas);
        request.setAttribute("reservasActivas", reservasActivas);
        request.setAttribute("horasHoy", horasHoy);
        request.setAttribute("salasDisponibles", salasDisponibles);

        request.getRequestDispatcher("estudiante/dashboard_estudiante.jsp").forward(request, response);
    }

    private void mostrarMisReservas(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        int idUsuario = usuario.getIdUsuario();

        List<Reserva> listaReservas = reservaDAO.listarPorUsuario(idUsuario);
        request.setAttribute("listaReservas", listaReservas);

        request.getRequestDispatcher("estudiante/mis_reservas.jsp").forward(request, response);
    }

    private void mostrarFormularioNuevaReserva(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        List<Sala> salasDisponibles = salaDAO.listarSalasDisponibles();
        
        int diasAnticipacion = usuario.getDiasAnticipacion() != null ? usuario.getDiasAnticipacion() : 3;
        LocalDate hoy = LocalDate.now();
        LocalDate maxFecha = hoy.plusDays(diasAnticipacion);

        String idSalaStr = request.getParameter("idSala");
        int idSalaSeleccionada = 0;
        if (idSalaStr != null && !idSalaStr.trim().isEmpty()) {
            try {
                idSalaSeleccionada = Integer.parseInt(idSalaStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        request.setAttribute("salasDisponibles", salasDisponibles);
        request.setAttribute("idSalaSeleccionada", idSalaSeleccionada);
        request.setAttribute("fechaMinima", hoy.toString());
        request.setAttribute("fechaMaxima", maxFecha.toString());

        request.getRequestDispatcher("estudiante/nueva_reserva.jsp").forward(request, response);
    }

    private void guardarReserva(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        String idSalaStr = request.getParameter("idSala");
        String fechaStr = request.getParameter("fechaReserva");
        String horaInicioStr = request.getParameter("horaInicio");
        String horaFinStr = request.getParameter("horaFin");
        String numIntegrantesStr = request.getParameter("numIntegrantes");
        String motivo = request.getParameter("motivo");

        int diasAnticipacion = usuario.getDiasAnticipacion() != null ? usuario.getDiasAnticipacion() : 3;
        int horasMaxDia = usuario.getHorasMaxDia() != null ? usuario.getHorasMaxDia() : 2;

        LocalDate hoy = LocalDate.now();
        LocalDate maxFecha = hoy.plusDays(diasAnticipacion);

        // Validación de campos requeridos
        if (idSalaStr == null || idSalaStr.trim().isEmpty()
                || fechaStr == null || fechaStr.trim().isEmpty()
                || horaInicioStr == null || horaInicioStr.trim().isEmpty()
                || horaFinStr == null || horaFinStr.trim().isEmpty()
                || numIntegrantesStr == null || numIntegrantesStr.trim().isEmpty()) {
            reenviarFormularioConError(request, response, usuario, "Por favor completa todos los campos del formulario.");
            return;
        }

        int idSala;
        int numIntegrantes;
        try {
            idSala = Integer.parseInt(idSalaStr.trim());
            numIntegrantes = Integer.parseInt(numIntegrantesStr.trim());
            if (numIntegrantes <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            reenviarFormularioConError(request, response, usuario, "La cantidad de integrantes debe ser un número entero mayor a cero.");
            return;
        }

        // Validar que la sala exista y aforo
        Sala sala = salaDAO.obtenerPorId(idSala);
        if (sala == null || !"DISPONIBLE".equalsIgnoreCase(sala.getEstado())) {
            reenviarFormularioConError(request, response, usuario, "La sala seleccionada no se encuentra disponible actualmente.");
            return;
        }

        if (numIntegrantes > sala.getCapacidad()) {
            reenviarFormularioConError(request, response, usuario, 
                    "El número de integrantes (" + numIntegrantes + ") supera la capacidad máxima de la sala (" + sala.getCapacidad() + " personas).");
            return;
        }

        // Validar fecha dentro del rango de anticipación
        Date fechaReserva;
        try {
            LocalDate fechaLocal = LocalDate.parse(fechaStr.trim());
            if (fechaLocal.isBefore(hoy)) {
                reenviarFormularioConError(request, response, usuario, "No puedes agendar reservas en fechas pasadas.");
                return;
            }
            if (fechaLocal.isAfter(maxFecha)) {
                reenviarFormularioConError(request, response, usuario, 
                        "Según tu categoría solo puedes reservar con hasta " + diasAnticipacion + " días de anticipación (hasta " + maxFecha + ").");
                return;
            }
            fechaReserva = Date.valueOf(fechaLocal);
        } catch (Exception e) {
            reenviarFormularioConError(request, response, usuario, "Formato de fecha inválido.");
            return;
        }

        // Validar horas y duración
        Time horaInicio;
        Time horaFin;
        try {
            String iniFormato = horaInicioStr.trim().length() == 5 ? horaInicioStr.trim() + ":00" : horaInicioStr.trim();
            String finFormato = horaFinStr.trim().length() == 5 ? horaFinStr.trim() + ":00" : horaFinStr.trim();
            horaInicio = Time.valueOf(iniFormato);
            horaFin = Time.valueOf(finFormato);
        } catch (Exception e) {
            reenviarFormularioConError(request, response, usuario, "Formato de hora incorrecto. Utiliza formato de 24 horas (HH:mm).");
            return;
        }

        if (!horaFin.after(horaInicio)) {
            reenviarFormularioConError(request, response, usuario, "La hora de finalización debe ser posterior a la hora de inicio.");
            return;
        }

        long diffMs = horaFin.getTime() - horaInicio.getTime();
        double duracionHoras = diffMs / (1000.0 * 60 * 60);

        if (duracionHoras <= 0 || duracionHoras > horasMaxDia) {
            reenviarFormularioConError(request, response, usuario, 
                    "La duración (" + (int)Math.ceil(duracionHoras) + " hrs) excede el máximo permitido por turno de tu categoría (" + horasMaxDia + " hrs).");
            return;
        }

        // Validar cupo diario acumulado
        int horasYaReservadas = reservaDAO.obtenerHorasReservadasPorFecha(usuario.getIdUsuario(), fechaReserva);
        if ((horasYaReservadas + duracionHoras) > horasMaxDia) {
            reenviarFormularioConError(request, response, usuario, 
                    "Superas el cupo máximo diario de tu modalidad (" + horasMaxDia + " hrs). Ya cuentas con " + horasYaReservadas + " hrs registradas para esta fecha.");
            return;
        }

        // Validar no solapamiento de la sala
        if (reservaDAO.existeSolapamiento(idSala, fechaReserva, horaInicio, horaFin)) {
            reenviarFormularioConError(request, response, usuario, 
                    "La sala " + sala.getCodigoSala() + " ya cuenta con una reserva en ese horario. Por favor elige otro bloque u otro cubículo.");
            return;
        }

        // Crear objeto Reserva y registrar
        Reserva nuevaReserva = new Reserva();
        nuevaReserva.setIdUsuario(usuario.getIdUsuario());
        nuevaReserva.setIdSala(idSala);
        nuevaReserva.setFechaReserva(fechaReserva);
        nuevaReserva.setHoraInicio(horaInicio);
        nuevaReserva.setHoraFin(horaFin);
        nuevaReserva.setNumIntegrantes(numIntegrantes);
        nuevaReserva.setMotivo(motivo != null && !motivo.trim().isEmpty() ? motivo.trim() : "Sesión de estudio académico");

        boolean exito = reservaDAO.registrarReserva(nuevaReserva);
        if (exito) {
            response.sendRedirect("EstudianteServlet?action=mis_reservas&mensaje="
                    + URLEncoder.encode("¡Reserva para la sala " + sala.getCodigoSala() + " programada exitosamente!", StandardCharsets.UTF_8));
        } else {
            reenviarFormularioConError(request, response, usuario, "Ocurrió un error al guardar la reserva en la base de datos.");
        }
    }

    private void reenviarFormularioConError(HttpServletRequest request, HttpServletResponse response, Usuario usuario, String mensajeError)
            throws ServletException, IOException {
        List<Sala> salasDisponibles = salaDAO.listarSalasDisponibles();
        int diasAnticipacion = usuario.getDiasAnticipacion() != null ? usuario.getDiasAnticipacion() : 3;
        LocalDate hoy = LocalDate.now();
        LocalDate maxFecha = hoy.plusDays(diasAnticipacion);

        request.setAttribute("error", mensajeError);
        request.setAttribute("salasDisponibles", salasDisponibles);
        request.setAttribute("fechaMinima", hoy.toString());
        request.setAttribute("fechaMaxima", maxFecha.toString());

        String idSalaStr = request.getParameter("idSala");
        int idSalaSeleccionada = 0;
        try { if (idSalaStr != null) idSalaSeleccionada = Integer.parseInt(idSalaStr); } catch (Exception ignored) {}
        request.setAttribute("idSalaSeleccionada", idSalaSeleccionada);

        request.getRequestDispatcher("estudiante/nueva_reserva.jsp").forward(request, response);
    }

    private void cancelarReserva(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws IOException {
        String idReservaStr = request.getParameter("id");
        if (idReservaStr != null && !idReservaStr.trim().isEmpty()) {
            try {
                int idReserva = Integer.parseInt(idReservaStr.trim());
                boolean cancelada = reservaDAO.cancelarReserva(idReserva, usuario.getIdUsuario());

                if (cancelada) {
                    response.sendRedirect("EstudianteServlet?action=mis_reservas&mensaje="
                            + URLEncoder.encode("La reserva #" + idReserva + " fue cancelada correctamente.", StandardCharsets.UTF_8));
                    return;
                } else {
                    response.sendRedirect("EstudianteServlet?action=mis_reservas&error="
                            + URLEncoder.encode("No se pudo cancelar la reserva. Solo reservas pendientes pueden ser canceladas.", StandardCharsets.UTF_8));
                    return;
                }
            } catch (NumberFormatException e) {
                System.err.println("ID de reserva inválido: " + e.getMessage());
            }
        }
        response.sendRedirect("EstudianteServlet?action=mis_reservas&error="
                + URLEncoder.encode("Identificador de reserva no válido.", StandardCharsets.UTF_8));
    }
}
