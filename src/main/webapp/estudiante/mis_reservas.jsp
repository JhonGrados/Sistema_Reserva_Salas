<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%-- Validación de Seguridad: Solo estudiantes autenticados --%>
<c:if test="${empty sessionScope.usuario or sessionScope.rol ne 'ESTUDIANTE'}">
    <c:redirect url="/error/acceso_denegado.jsp"/>
</c:if>
<%-- Si se ingresa directo al JSP sin pasar por el Servlet, redirigir al controlador MVC --%>
<c:if test="${listaReservas == null}">
    <c:redirect url="/EstudianteServlet?action=mis_reservas"/>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Reservas | Sistema de Reservas UTP</title>
    
    <!-- Google Fonts: Plus Jakarta Sans -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Bootstrap 5.3.3 CSS & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Estilos generales del portal -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/portal.css">
</head>
<body>

    <!-- ===============================================================
         NAVBAR PRINCIPAL
         =============================================================== -->
    <nav class="navbar navbar-expand-lg portal-navbar sticky-top">
        <div class="container">
            <a class="portal-brand" href="${pageContext.request.contextPath}/EstudianteServlet?action=dashboard">
                <img src="${pageContext.request.contextPath}/assets/img/logo-utp.png" alt="UTP Logo" onerror="this.style.display='none'">
                <span>RESERVAS UTP</span>
            </a>

            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarPortal">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarPortal">
                <ul class="navbar-nav me-auto ms-lg-4 mb-2 mb-lg-0 gap-1">
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/EstudianteServlet?action=dashboard">
                            <i class="bi bi-grid-1x2-fill me-1"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom active" href="${pageContext.request.contextPath}/EstudianteServlet?action=mis_reservas">
                            <i class="bi bi-calendar2-check-fill me-1"></i> Mis Reservas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/EstudianteServlet?action=nueva_reserva">
                            <i class="bi bi-plus-circle-fill me-1"></i> Nueva Reserva
                        </a>
                    </li>
                </ul>

                <!-- Perfil del usuario -->
                <div class="d-flex align-items-center gap-3">
                    <div class="text-end d-none d-sm-block">
                        <div class="fw-bold text-dark" style="font-size: 0.9rem;">
                            <c:out value="${sessionScope.usuario.nombreCompleto}"/>
                        </div>
                        <div class="text-muted" style="font-size: 0.78rem;">
                            <span class="badge bg-light text-primary border me-1"><c:out value="${sessionScope.tipoEstudiante}"/></span>
                            <c:out value="${sessionScope.codigoUniversitario}"/>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/AuthServlet?action=logout" class="btn btn-outline-danger btn-sm" title="Cerrar sesión">
                        <i class="bi bi-box-arrow-right"></i>
                        <span class="d-none d-md-inline ms-1">Salir</span>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- ===============================================================
         CONTENIDO PRINCIPAL
         =============================================================== -->
    <main class="container py-4 flex-grow-1">

        <!-- CABECERA DE LA VISTA -->
        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3 mb-4">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1" style="font-size: 0.85rem;">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/EstudianteServlet?action=dashboard">Portal</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Mis Reservas</li>
                    </ol>
                </nav>
                <h3 class="fw-bold text-dark mb-0">
                    <i class="bi bi-calendar-range text-primary me-2"></i>Historial de Reservas
                </h3>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/EstudianteServlet?action=nueva_reserva" class="btn btn-utp btn-sm">
                    <i class="bi bi-plus-lg me-1"></i> Nueva Reserva
                </a>
                <a href="${pageContext.request.contextPath}/EstudianteServlet?action=dashboard" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i> Volver al Dashboard
                </a>
            </div>
        </div>

        <!-- ALERTAS DE RETROALIMENTACIÓN -->
        <c:if test="${not empty param.mensaje}">
            <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <c:out value="${param.mensaje}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <c:out value="${param.error}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- CONTENEDOR DE LA TABLA O MENSAJE VACÍO -->
        <c:choose>
            <c:when test="${not empty listaReservas and listaReservas.size() > 0}">
                <div class="custom-table-card">
                    <div class="table-responsive">
                        <table class="table custom-table mb-0">
                            <thead>
                                <tr>
                                    <th>N° Reg.</th>
                                    <th>Sala</th>
                                    <th>Fecha</th>
                                    <th>Horario</th>
                                    <th>Integrantes</th>
                                    <th>Motivo de Estudio</th>
                                    <th>Estado</th>
                                    <th class="text-center">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${listaReservas}" var="r">
                                    <tr>
                                        <td>
                                            <span class="text-secondary fw-semibold">#<c:out value="${r.idReserva}"/></span>
                                        </td>
                                        <td>
                                            <div class="fw-bold text-primary">
                                                <i class="bi bi-door-closed me-1"></i><c:out value="${r.codigoSala}"/>
                                            </div>
                                            <small class="text-muted d-block" style="font-size: 0.78rem;">
                                                <i class="bi bi-geo-alt"></i> <c:out value="${r.ubicacionSala}"/>
                                            </small>
                                        </td>
                                        <td>
                                            <span class="fw-semibold text-dark">
                                                <c:out value="${r.fechaReserva}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-dark border">
                                                <i class="bi bi-clock me-1 text-primary"></i><c:out value="${r.rangoHorario}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <i class="bi bi-people me-1 text-secondary"></i><c:out value="${r.numIntegrantes}"/>
                                        </td>
                                        <td>
                                            <span class="text-dark" style="font-size: 0.88rem;">
                                                <c:out value="${r.motivo != null and not empty r.motivo ? r.motivo : 'Estudio personal/grupal'}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.estado eq 'RESERVADO'}">
                                                    <span class="badge-status badge-reservado">
                                                        <i class="bi bi-clock-history"></i> RESERVADO
                                                    </span>
                                                </c:when>
                                                <c:when test="${r.estado eq 'OCUPADO'}">
                                                    <span class="badge-status badge-ocupado">
                                                        <i class="bi bi-broadcast"></i> EN USO
                                                    </span>
                                                </c:when>
                                                <c:when test="${r.estado eq 'FINALIZADO'}">
                                                    <span class="badge-status badge-finalizado">
                                                        <i class="bi bi-check2-all"></i> FINALIZADO
                                                    </span>
                                                </c:when>
                                                <c:when test="${r.estado eq 'CANCELADO'}">
                                                    <span class="badge-status badge-cancelado">
                                                        <i class="bi bi-x-circle"></i> CANCELADO
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary"><c:out value="${r.estado}"/></span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${r.cancelable}">
                                                    <button type="button" 
                                                            class="btn btn-outline-danger btn-sm"
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#modalCancelar"
                                                            data-id="${r.idReserva}"
                                                            data-sala="${r.codigoSala}"
                                                            data-fecha="${r.fechaReserva}"
                                                            data-horario="${r.rangoHorario}">
                                                        <i class="bi bi-trash3 me-1"></i> Cancelar
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted" style="font-size: 0.8rem;">
                                                        <i class="bi bi-dash"></i>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card border-0 shadow-sm p-5 text-center" style="border-radius: 16px; background: #ffffff;">
                    <div class="text-muted mb-3">
                        <i class="bi bi-calendar2-x display-4 text-secondary"></i>
                    </div>
                    <h5 class="fw-bold text-dark mb-2">No tienes reservas registradas</h5>
                    <p class="text-secondary mb-4" style="max-width: 500px; margin: 0 auto;">
                        Actualmente no tienes ningún turno programado ni historial previo en el sistema.
                    </p>
                    <div class="d-flex gap-2 justify-content-center">
                        <a href="${pageContext.request.contextPath}/EstudianteServlet?action=nueva_reserva" class="btn btn-utp">
                            <i class="bi bi-plus-circle-fill me-1"></i> Reservar un Cubículo
                        </a>
                        <a href="${pageContext.request.contextPath}/EstudianteServlet?action=dashboard" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i> Volver al Inicio
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

    <!-- ===============================================================
         MODAL DE CONFIRMACIÓN PARA CANCELAR RESERVA
         =============================================================== -->
    <div class="modal fade" id="modalCancelar" tabindex="-1" aria-labelledby="modalCancelarLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow" style="border-radius: 14px;">
                <div class="modal-header border-bottom-0 pb-0">
                    <h5 class="modal-title fw-bold text-dark" id="modalCancelarLabel">
                        <i class="bi bi-exclamation-triangle-fill text-warning me-2"></i> Confirmar Cancelación
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body py-4">
                    <p class="text-secondary mb-3">
                        ¿Estás seguro de que deseas anular esta reserva? El cubículo quedará disponible inmediatamente para otros compañeros.
                    </p>
                    <div class="p-3 bg-light rounded-3 border" style="font-size: 0.9rem;">
                        <div><strong>Sala:</strong> <span id="modalSalaCodigo">-</span></div>
                        <div><strong>Fecha:</strong> <span id="modalSalaFecha">-</span></div>
                        <div><strong>Horario:</strong> <span id="modalSalaHorario">-</span></div>
                    </div>
                </div>
                <div class="modal-footer border-top-0 pt-0">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Mantener Reserva</button>
                    <a id="btnConfirmarCancelar" href="#" class="btn btn-danger btn-sm">
                        <i class="bi bi-trash3 me-1"></i> Sí, Cancelar Turno
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- FOOTER -->
    <footer class="portal-footer">
        <div class="container text-center">
            <p class="mb-0">
                &copy; Sistema de Reserva de Salas de Estudio &bull; Universidad Tecnológica del Perú (UTP)
            </p>
        </div>
    </footer>

    <!-- Bootstrap 5.3.3 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Script interactivo del Modal de cancelación -->
    <script>
        const modalCancelar = document.getElementById('modalCancelar');
        if (modalCancelar) {
            modalCancelar.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;
                const id = button.getAttribute('data-id');
                const sala = button.getAttribute('data-sala');
                const fecha = button.getAttribute('data-fecha');
                const horario = button.getAttribute('data-horario');

                document.getElementById('modalSalaCodigo').textContent = sala;
                document.getElementById('modalSalaFecha').textContent = fecha;
                document.getElementById('modalSalaHorario').textContent = horario;
                
                const btnConfirmar = document.getElementById('btnConfirmarCancelar');
                btnConfirmar.href = '${pageContext.request.contextPath}/EstudianteServlet?action=cancelar&id=' + encodeURIComponent(id);
            });
        }
    </script>
</body>
</html>
