package com.utp.reservas.controller;

import com.utp.reservas.dao.SalaDAO;
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

@WebServlet(name = "SalaServlet", urlPatterns = {"/SalaServlet"})
public class SalaServlet extends HttpServlet {

    private SalaDAO salaDAO;

    @Override
    public void init() throws ServletException {
        super.init();
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

        String rol = (String) session.getAttribute("rol");
        if (rol == null || !"ADMINISTRADOR".equalsIgnoreCase(rol)) {
            response.sendRedirect("error/acceso_denegado.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "listar";
        }

        switch (action.toLowerCase()) {
            case "listar":
                listarSalas(request, response);
                break;

            case "nuevo":
                mostrarFormularioNuevo(request, response);
                break;

            case "editar":
                mostrarFormularioEditar(request, response);
                break;

            case "guardar":
                guardarSala(request, response);
                break;

            case "cambiar_estado":
                cambiarEstadoSala(request, response);
                break;

            default:
                listarSalas(request, response);
                break;
        }
    }

    private void listarSalas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Sala> listaSalas = salaDAO.listarSalas();
        request.setAttribute("listaSalas", listaSalas);
        request.getRequestDispatcher("admin/gestion_salas.jsp").forward(request, response);
    }

    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("sala", null);
        request.getRequestDispatcher("admin/formulario_sala.jsp").forward(request, response);
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int idSala = Integer.parseInt(idStr.trim());
                Sala sala = salaDAO.obtenerPorId(idSala);
                if (sala != null) {
                    request.setAttribute("sala", sala);
                    request.getRequestDispatcher("admin/formulario_sala.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                System.err.println("ID de sala inválido: " + e.getMessage());
            }
        }
        response.sendRedirect("SalaServlet?action=listar&error="
                + URLEncoder.encode("La sala solicitada no fue encontrada.", StandardCharsets.UTF_8));
    }

    private void guardarSala(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("idSala");
        String codigoSala = request.getParameter("codigoSala");
        String capacidadStr = request.getParameter("capacidad");
        String esSilenciosaStr = request.getParameter("esSilenciosa");
        String ubicacion = request.getParameter("ubicacion");
        String recursos = request.getParameter("recursos");
        String estado = request.getParameter("estado");

        int idSala = 0;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                idSala = Integer.parseInt(idStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        // Validaciones básicas de campos obligatorios
        if (codigoSala == null || codigoSala.trim().isEmpty()
                || capacidadStr == null || capacidadStr.trim().isEmpty()
                || ubicacion == null || ubicacion.trim().isEmpty()) {
            request.setAttribute("error", "Por favor completa todos los campos obligatorios.");
            Sala salaActual = armarObjetoSala(idSala, codigoSala, capacidadStr, esSilenciosaStr, ubicacion, recursos, estado);
            request.setAttribute("sala", salaActual);
            request.getRequestDispatcher("admin/formulario_sala.jsp").forward(request, response);
            return;
        }

        codigoSala = codigoSala.trim().toUpperCase();
        int capacidad = 1;
        try {
            capacidad = Integer.parseInt(capacidadStr.trim());
            if (capacidad <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            request.setAttribute("error", "La capacidad debe ser un número entero mayor a cero.");
            Sala salaActual = armarObjetoSala(idSala, codigoSala, capacidadStr, esSilenciosaStr, ubicacion, recursos, estado);
            request.setAttribute("sala", salaActual);
            request.getRequestDispatcher("admin/formulario_sala.jsp").forward(request, response);
            return;
        }

        int esSilenciosa = "1".equals(esSilenciosaStr) ? 1 : 0;
        if (estado == null || estado.trim().isEmpty()) {
            estado = "DISPONIBLE";
        }

        // Validar unicidad del código de sala en la base de datos
        if (salaDAO.existeCodigoSala(codigoSala, idSala)) {
            request.setAttribute("error", "El código de sala '" + codigoSala + "' ya existe registrado en el sistema.");
            Sala salaActual = armarObjetoSala(idSala, codigoSala, capacidadStr, esSilenciosaStr, ubicacion, recursos, estado);
            request.setAttribute("sala", salaActual);
            request.getRequestDispatcher("admin/formulario_sala.jsp").forward(request, response);
            return;
        }

        Sala sala = new Sala(idSala, codigoSala, capacidad, esSilenciosa, ubicacion.trim(), recursos != null ? recursos.trim() : "", estado.trim());

        boolean exito;
        if (idSala == 0) {
            exito = salaDAO.registrarSala(sala);
            if (exito) {
                response.sendRedirect("SalaServlet?action=listar&mensaje="
                        + URLEncoder.encode("Sala " + codigoSala + " registrada exitosamente.", StandardCharsets.UTF_8));
                return;
            }
        } else {
            exito = salaDAO.actualizarSala(sala);
            if (exito) {
                response.sendRedirect("SalaServlet?action=listar&mensaje="
                        + URLEncoder.encode("Sala " + codigoSala + " actualizada exitosamente.", StandardCharsets.UTF_8));
                return;
            }
        }

        request.setAttribute("error", "Ocurrió un error al guardar la sala en la base de datos.");
        request.setAttribute("sala", sala);
        request.getRequestDispatcher("admin/formulario_sala.jsp").forward(request, response);
    }

    private void cambiarEstadoSala(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        String nuevoEstado = request.getParameter("estado");

        if (idStr != null && nuevoEstado != null) {
            try {
                int idSala = Integer.parseInt(idStr.trim());
                boolean ok = salaDAO.cambiarEstado(idSala, nuevoEstado.trim().toUpperCase());
                if (ok) {
                    response.sendRedirect("SalaServlet?action=listar&mensaje="
                            + URLEncoder.encode("El estado de la sala fue actualizado a '" + nuevoEstado + "'.", StandardCharsets.UTF_8));
                    return;
                }
            } catch (NumberFormatException e) {
                System.err.println("ID inválido al cambiar estado: " + e.getMessage());
            }
        }
        response.sendRedirect("SalaServlet?action=listar&error="
                + URLEncoder.encode("No se pudo actualizar el estado de la sala.", StandardCharsets.UTF_8));
    }

    private Sala armarObjetoSala(int idSala, String codigo, String capStr, String esSilenciosaStr, String ubicacion, String recursos, String estado) {
        int cap = 1;
        try { cap = Integer.parseInt(capStr); } catch (Exception ignored) {}
        int silenciosa = "1".equals(esSilenciosaStr) ? 1 : 0;
        return new Sala(idSala, codigo, cap, silenciosa, ubicacion, recursos, estado);
    }
}
