package com.utp.reservas.controller;

import com.utp.reservas.dao.ReservaDAO;
import com.utp.reservas.dao.SalaDAO;
import com.utp.reservas.dao.UsuarioDAO;
import com.utp.reservas.dto.Sala;
import com.utp.reservas.dto.Usuario;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminServlet", urlPatterns = {"/AdminServlet"})
public class AdminServlet extends HttpServlet {

    private SalaDAO salaDAO;
    private ReservaDAO reservaDAO;
    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.salaDAO = new SalaDAO();
        this.reservaDAO = new ReservaDAO();
        this.usuarioDAO = new UsuarioDAO();
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

        if (rol == null || !"ADMINISTRADOR".equalsIgnoreCase(rol)) {
            response.sendRedirect("error/acceso_denegado.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "dashboard";
        }

        if ("dashboard".equalsIgnoreCase(action)) {
            mostrarDashboard(request, response, usuario);
        } else {
            mostrarDashboard(request, response, usuario);
        }
    }

    private void mostrarDashboard(HttpServletRequest request, HttpServletResponse response, Usuario usuario)
            throws ServletException, IOException {
        int totalSalas = salaDAO.contarTotalSalas();
        int salasDisponibles = salaDAO.contarSalasPorEstado("DISPONIBLE");
        int salasMantenimiento = salaDAO.contarSalasPorEstado("MANTENIMIENTO");
        int salasInhabilitadas = salaDAO.contarSalasPorEstado("INHABILITADO");
        int reservasHoy = reservaDAO.contarReservasHoy();
        int reservasActivas = reservaDAO.contarReservasActivasGlobal();
        int totalEstudiantes = usuarioDAO.contarTotalEstudiantes();
        List<Sala> listaSalas = salaDAO.listarSalas();

        request.setAttribute("totalSalas", totalSalas);
        request.setAttribute("salasDisponibles", salasDisponibles);
        request.setAttribute("salasMantenimiento", salasMantenimiento);
        request.setAttribute("salasInhabilitadas", salasInhabilitadas);
        request.setAttribute("reservasHoy", reservasHoy);
        request.setAttribute("reservasActivas", reservasActivas);
        request.setAttribute("totalEstudiantes", totalEstudiantes);
        request.setAttribute("listaSalas", listaSalas);

        request.getRequestDispatcher("admin/dashboard_admin.jsp").forward(request, response);
    }
}
