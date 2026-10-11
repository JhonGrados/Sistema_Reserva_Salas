package com.utp.reservas.controller;

import com.utp.reservas.dao.UsuarioDAO;
import com.utp.reservas.dto.Usuario;
import java.io.IOException;
import java.net.URLEncoder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AuthServlet", urlPatterns = { "/AuthServlet" })
public class AuthServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equalsIgnoreCase(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("login.jsp?mensaje=" + URLEncoder.encode("Sesión cerrada correctamente.", "UTF-8"));
            return;
        }
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String codigo = request.getParameter("codigo");
        String clave = request.getParameter("clave");
        String recordarme = request.getParameter("recordarme");

        if (codigo == null || codigo.trim().isEmpty() || clave == null || clave.trim().isEmpty()) {
            request.setAttribute("error", "Por favor, ingresa tu código universitario/correo y contraseña.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        Usuario usuario = usuarioDAO.validarUsuario(codigo.trim(), clave.trim());

        if (usuario != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("usuario", usuario);
            session.setAttribute("usuarioLogueado", usuario.getNombreCompleto());
            session.setAttribute("idUsuario", usuario.getIdUsuario());
            session.setAttribute("codigoUniversitario", usuario.getCodigoUniversitario());
            session.setAttribute("rol", usuario.getNombreRol());
            session.setAttribute("tipoEstudiante", usuario.getNombreTipoEstudiante());
            session.setAttribute("nivelPrioridad", usuario.getNivelPrioridad());
            session.setAttribute("horasMaxDia", usuario.getHorasMaxDia());
            session.setAttribute("diasAnticipacion", usuario.getDiasAnticipacion());

            if ("ESTUDIANTE".equalsIgnoreCase(usuario.getNombreRol())) {
                response.sendRedirect("EstudianteServlet?action=dashboard");
                return;
            } else if ("ADMINISTRADOR".equalsIgnoreCase(usuario.getNombreRol())) {
                response.sendRedirect("AdminServlet?action=dashboard");
                return;
            }

            String rolInfo = usuario.getNombreTipoEstudiante() != null
                    ? usuario.getNombreRol() + " - " + usuario.getNombreTipoEstudiante()
                    : usuario.getNombreRol();

            String mensajeExito = "¡Bienvenido(a), " + usuario.getNombre() + " (" + rolInfo + ")!";
            response.sendRedirect("login.jsp?mensaje=" + URLEncoder.encode(mensajeExito, "UTF-8"));
        } else {
            request.setAttribute("error", "Código institucional/correo o contraseña incorrectos.");
            request.setAttribute("codigoIngresado", codigo);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
