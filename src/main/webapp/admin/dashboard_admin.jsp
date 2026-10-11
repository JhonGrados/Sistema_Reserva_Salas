<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%-- Validación de Seguridad: Solo Administradores autenticados --%>
<c:if test="${empty sessionScope.usuario or sessionScope.rol ne 'ADMINISTRADOR'}">
    <c:redirect url="/error/acceso_denegado.jsp"/>
</c:if>
<%-- Si se entra directo al JSP sin pasar por el Servlet, redirigir al controlador MVC --%>
<c:if test="${empty listaSalas}">
    <c:redirect url="/AdminServlet?action=dashboard"/>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administración | Sistema de Reservas UTP</title>
    
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
         NAVBAR ADMINISTRADOR
         =============================================================== -->
    <nav class="navbar navbar-expand-lg portal-navbar sticky-top">
        <div class="container">
            <a class="portal-brand" href="${pageContext.request.contextPath}/AdminServlet?action=dashboard">
                <img src="${pageContext.request.contextPath}/assets/img/logo-utp.png" alt="UTP Logo" onerror="this.style.display='none'">
                <span>PANEL ADMINISTRADOR</span>
            </a>

            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarAdmin">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarAdmin">
                <ul class="navbar-nav me-auto ms-lg-4 mb-2 mb-lg-0 gap-1">
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom active" href="${pageContext.request.contextPath}/AdminServlet?action=dashboard">
                            <i class="bi bi-speedometer2 me-1"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/SalaServlet?action=listar">
                            <i class="bi bi-door-open-fill me-1"></i> Gestión de Salas
                        </a>
                    </li>
                </ul>

                <!-- Perfil del Administrador -->
                <div class="d-flex align-items-center gap-3">
                    <div class="text-end d-none d-sm-block">
                        <div class="fw-bold text-dark" style="font-size: 0.9rem;">
                            <c:out value="${sessionScope.usuario.nombreCompleto}"/>
                        </div>
                        <div class="text-muted" style="font-size: 0.78rem;">
                            <span class="badge bg-danger-subtle text-danger border border-danger-subtle me-1">ADMINISTRADOR</span>
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

        <!-- MENSAJES DE ALERTA -->
        <c:if test="${not empty param.mensaje}">
            <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <c:out value="${param.mensaje}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- BANNER DE BIENVENIDA -->
        <div class="welcome-banner" style="background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 100%);">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <div class="student-badge-pill mb-2" style="background: rgba(220, 38, 38, 0.35); border-color: rgba(248, 113, 113, 0.4);">
                        <i class="bi bi-shield-check"></i>
                        <span>CONTROL CENTRAL DE RECURSOS</span>
                    </div>
                    <h2 class="fw-bold mb-2">¡Bienvenido(a), <c:out value="${sessionScope.usuario.nombre}"/>!</h2>
                    <p class="text-white-50 mb-3" style="max-width: 620px;">
                        Supervisa el estado de los cubículos de biblioteca, aforos, y atiende las operaciones de mantenimiento para el correcto funcionamiento del campus.
                    </p>
                    <div class="d-flex flex-wrap gap-2">
                        <span class="badge bg-white text-dark py-2 px-3 fw-semibold">
                            <i class="bi bi-people text-primary me-1"></i>
                            Estudiantes registrados: <c:out value="${totalEstudiantes}"/>
                        </span>
                        <span class="badge bg-white text-dark py-2 px-3 fw-semibold">
                            <i class="bi bi-calendar2-week text-primary me-1"></i>
                            Reservas registradas hoy: <c:out value="${reservasHoy}"/>
                        </span>
                    </div>
                </div>
                <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                    <div class="d-flex flex-column flex-sm-row flex-lg-column gap-2 justify-content-lg-end">
                        <a href="${pageContext.request.contextPath}/SalaServlet?action=nuevo" class="btn btn-light fw-bold px-3 py-2 shadow-sm text-primary">
                            <i class="bi bi-plus-circle-fill me-1"></i> Registrar Nueva Sala
                        </a>
                        <a href="${pageContext.request.contextPath}/SalaServlet?action=listar" class="btn btn-outline-light fw-semibold px-3 py-2">
                            <i class="bi bi-table me-1"></i> Ir a Gestión de Salas
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- TARJETAS DE MÉTRICAS GLOBALES (DESDE BD) -->
        <div class="row g-3 mb-4">
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-secondary fw-semibold" style="font-size: 0.85rem;">Total de Salas</span>
                        <div class="stat-icon blue">
                            <i class="bi bi-door-closed-fill"></i>
                        </div>
                    </div>
                    <h3 class="fw-bold mb-0 text-dark"><c:out value="${totalSalas}"/></h3>
                    <small class="text-muted">Ambientes registrados</small>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-secondary fw-semibold" style="font-size: 0.85rem;">Salas Disponibles</span>
                        <div class="stat-icon green">
                            <i class="bi bi-check-circle-fill"></i>
                        </div>
                    </div>
                    <h3 class="fw-bold mb-0 text-success"><c:out value="${salasDisponibles}"/></h3>
                    <small class="text-muted">Listas para reservar</small>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-secondary fw-semibold" style="font-size: 0.85rem;">En Mantenimiento</span>
                        <div class="stat-icon amber">
                            <i class="bi bi-tools"></i>
                        </div>
                    </div>
                    <h3 class="fw-bold mb-0 text-warning"><c:out value="${salasMantenimiento}"/></h3>
                    <small class="text-muted">Reparaciones técnicas</small>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-secondary fw-semibold" style="font-size: 0.85rem;">Inhabilitadas</span>
                        <div class="stat-icon purple" style="background-color: #fee2e2; color: #dc2626;">
                            <i class="bi bi-slash-circle-fill"></i>
                        </div>
                    </div>
                    <h3 class="fw-bold mb-0 text-danger"><c:out value="${salasInhabilitadas}"/></h3>
                    <small class="text-muted">Fuera de servicio</small>
                </div>
            </div>
        </div>

        <!-- RESUMEN DE SALAS EN EL CAMPUS -->
        <div>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold text-dark mb-0">
                    <i class="bi bi-building-gear me-2 text-primary"></i>Resumen General de Espacios
                </h5>
                <a href="${pageContext.request.contextPath}/SalaServlet?action=listar" class="btn btn-sm btn-outline-primary">
                    <i class="bi bi-sliders me-1"></i> Abrir Mantenimiento Completo
                </a>
            </div>

            <div class="custom-table-card">
                <div class="table-responsive">
                    <table class="table custom-table mb-0">
                        <thead>
                            <tr>
                                <th>Código</th>
                                <th>Aforo</th>
                                <th>Tipo de Ambiente</th>
                                <th>Ubicación</th>
                                <th>Equipamiento</th>
                                <th>Estado Actual</th>
                                <th class="text-center">Acción Rápida</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${listaSalas}" var="s">
                                <tr>
                                    <td>
                                        <span class="fw-bold text-primary">
                                            <i class="bi bi-door-closed me-1"></i><c:out value="${s.codigoSala}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <i class="bi bi-person me-1 text-muted"></i><c:out value="${s.capacidad}"/> personas
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${s.esSilenciosa == 1}">
                                                <span class="badge bg-light text-secondary border">
                                                    <i class="bi bi-volume-mute-fill text-danger me-1"></i>Silenciosa
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-light text-primary border">
                                                    <i class="bi bi-people-fill text-primary me-1"></i>Grupal
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <i class="bi bi-geo-alt me-1 text-muted"></i><c:out value="${s.ubicacion}"/>
                                    </td>
                                    <td>
                                        <small class="text-muted"><c:out value="${s.recursos}"/></small>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${s.estado eq 'DISPONIBLE'}">
                                                <span class="badge-status badge-ocupado">
                                                    <i class="bi bi-check-circle-fill"></i> DISPONIBLE
                                                </span>
                                            </c:when>
                                            <c:when test="${s.estado eq 'MANTENIMIENTO'}">
                                                <span class="badge-status" style="background-color: #fef3c7; color: #b45309; border: 1px solid #fde68a;">
                                                    <i class="bi bi-tools"></i> MANTENIMIENTO
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-status badge-cancelado">
                                                    <i class="bi bi-slash-circle"></i> INHABILITADO
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/SalaServlet?action=editar&id=${s.idSala}" class="btn btn-outline-primary btn-sm" title="Editar sala">
                                            <i class="bi bi-pencil-square me-1"></i> Editar
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </main>

    <!-- FOOTER -->
    <footer class="portal-footer">
        <div class="container text-center">
            <p class="mb-0">
                &copy; Sistema de Reserva de Salas de Estudio &bull; Panel del Administrador &bull; UTP
            </p>
        </div>
    </footer>

    <!-- Bootstrap 5.3.3 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
