<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%-- Validación de Seguridad: Solo estudiantes autenticados --%>
<c:if test="${empty sessionScope.usuario or sessionScope.rol ne 'ESTUDIANTE'}">
    <c:redirect url="/error/acceso_denegado.jsp"/>
</c:if>
<%-- Si se ingresa directo al JSP sin pasar por el Servlet, redirigir al controlador MVC --%>
<c:if test="${empty salasDisponibles}">
    <c:redirect url="/EstudianteServlet?action=dashboard"/>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portal del Estudiante | Sistema de Reservas UTP</title>
    
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
                        <a class="nav-link nav-link-custom active" href="${pageContext.request.contextPath}/EstudianteServlet?action=dashboard">
                            <i class="bi bi-grid-1x2-fill me-1"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/EstudianteServlet?action=mis_reservas">
                            <i class="bi bi-calendar2-check me-1"></i> Mis Reservas
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

        <!-- Mensajes del sistema (si hubiera redirección con feedback) -->
        <c:if test="${not empty param.mensaje}">
            <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <c:out value="${param.mensaje}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- BANNER DE BIENVENIDA -->
        <div class="welcome-banner">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <div class="student-badge-pill mb-2">
                        <i class="bi bi-mortarboard-fill"></i>
                        <span>MODALIDAD: <c:out value="${sessionScope.tipoEstudiante}"/></span>
                    </div>
                    <h2 class="fw-bold mb-2">¡Hola, <c:out value="${sessionScope.usuario.nombre}"/>!</h2>
                    <p class="text-white-50 mb-3" style="max-width: 600px;">
                        Bienvenido a tu panel de autoservicio de salas de estudio de la Biblioteca Central. Consulta tus cupos y próximas reservas.
                    </p>
                    <div class="d-flex flex-wrap gap-2">
                        <span class="badge bg-white text-dark py-2 px-3 fw-semibold">
                            <i class="bi bi-clock-history text-primary me-1"></i>
                            Cupo: Máx. <c:out value="${sessionScope.horasMaxDia}"/> horas/día
                        </span>
                        <span class="badge bg-white text-dark py-2 px-3 fw-semibold">
                            <i class="bi bi-calendar-event text-primary me-1"></i>
                            Anticipación: Hasta <c:out value="${sessionScope.diasAnticipacion}"/> días
                        </span>
                    </div>
                </div>
                <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                    <div class="d-flex flex-column flex-sm-row flex-lg-column gap-2 justify-content-lg-end">
                        <a href="${pageContext.request.contextPath}/EstudianteServlet?action=nueva_reserva" class="btn btn-light fw-bold px-3 py-2 shadow-sm text-primary">
                            <i class="bi bi-plus-circle-fill me-1"></i> Reservar Cubículo
                        </a>
                        <a href="${pageContext.request.contextPath}/EstudianteServlet?action=mis_reservas" class="btn btn-outline-light fw-semibold px-3 py-2">
                            <i class="bi bi-calendar2-check-fill me-1"></i> Ver Mis Reservas
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- TARJETAS DE MÉTRICAS -->
        <div class="row g-3 mb-4">
            <div class="col-12 col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-secondary fw-semibold" style="font-size: 0.85rem;">Horas Hoy</span>
                        <div class="stat-icon blue">
                            <i class="bi bi-hourglass-split"></i>
                        </div>
                    </div>
                    <h3 class="fw-bold mb-0 text-dark">
                        <c:out value="${horasHoy}"/> / <c:out value="${sessionScope.horasMaxDia}"/> <span class="fs-6 fw-normal text-muted">hrs</span>
                    </h3>
                    <small class="text-muted">Consumo diario registrado</small>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-secondary fw-semibold" style="font-size: 0.85rem;">Reservas Activas</span>
                        <div class="stat-icon green">
                            <i class="bi bi-check2-circle"></i>
                        </div>
                    </div>
                    <h3 class="fw-bold mb-0 text-dark"><c:out value="${reservasActivas}"/></h3>
                    <small class="text-muted">Turnos pendientes/en curso</small>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-secondary fw-semibold" style="font-size: 0.85rem;">Historial Total</span>
                        <div class="stat-icon purple">
                            <i class="bi bi-journal-bookmark"></i>
                        </div>
                    </div>
                    <h3 class="fw-bold mb-0 text-dark"><c:out value="${totalReservas}"/></h3>
                    <small class="text-muted">Total de solicitudes</small>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-secondary fw-semibold" style="font-size: 0.85rem;">Estado de Matrícula</span>
                        <div class="stat-icon amber">
                            <i class="bi bi-person-check-fill"></i>
                        </div>
                    </div>
                    <h5 class="fw-bold mb-0 text-success mt-1">HABILITADO</h5>
                    <small class="text-muted">Sin sanciones en biblioteca</small>
                </div>
            </div>
        </div>

        <!-- PRÓXIMA RESERVA DESTACADA -->
        <div class="mb-4">
            <h5 class="fw-bold text-dark mb-3">
                <i class="bi bi-pin-angle-fill text-primary me-2"></i>Próxima Reserva Programada
            </h5>

            <c:choose>
                <c:when test="${not empty proximaReserva}">
                    <div class="next-booking-card">
                        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                            <div>
                                <div class="d-flex align-items-center gap-2 mb-2">
                                    <span class="badge bg-primary fs-6 px-3 py-1">
                                        <i class="bi bi-door-closed me-1"></i> <c:out value="${proximaReserva.codigoSala}"/>
                                    </span>
                                    <c:choose>
                                        <c:when test="${proximaReserva.estado eq 'OCUPADO'}">
                                            <span class="badge-status badge-ocupado"><i class="bi bi-broadcast"></i> EN USO (Check-in activo)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-status badge-reservado"><i class="bi bi-clock"></i> RESERVADO</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <h6 class="fw-bold text-dark mb-1">
                                    <c:out value="${proximaReserva.motivo != null and not empty proximaReserva.motivo ? proximaReserva.motivo : 'Sesión de Estudio'}"/>
                                </h6>
                                <p class="text-muted mb-0" style="font-size: 0.9rem;">
                                    <i class="bi bi-geo-alt me-1 text-danger"></i> <c:out value="${proximaReserva.ubicacionSala}"/> &bull;
                                    <i class="bi bi-calendar3 me-1 text-primary"></i> <c:out value="${proximaReserva.fechaReserva}"/> &bull;
                                    <i class="bi bi-clock me-1 text-success"></i> <c:out value="${proximaReserva.rangoHorario}"/> &bull;
                                    <i class="bi bi-people me-1"></i> <c:out value="${proximaReserva.numIntegrantes}"/> integrante(s)
                                </p>
                            </div>
                            <div class="text-md-end">
                                <a href="${pageContext.request.contextPath}/EstudianteServlet?action=mis_reservas" class="btn btn-outline-primary btn-sm">
                                    <i class="bi bi-eye me-1"></i> Gestionar en Mis Reservas
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card border-0 shadow-sm p-4 text-center" style="border-radius: 14px; background: #ffffff;">
                        <div class="text-muted mb-2">
                            <i class="bi bi-calendar-x display-6 text-secondary"></i>
                        </div>
                        <h6 class="fw-bold text-dark mb-1">No tienes reservas programadas para hoy</h6>
                        <p class="text-muted mb-3" style="font-size: 0.9rem;">
                            Encuentra cubículos disponibles para hoy o fechas próximas en la lista inferior.
                        </p>
                        <div>
                            <a href="${pageContext.request.contextPath}/EstudianteServlet?action=nueva_reserva" class="btn btn-utp btn-sm">
                                <i class="bi bi-calendar-plus me-1"></i> Reservar un Cubículo Ahora
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- SALAS DE ESTUDIO DISPONIBLES EN EL CAMPUS -->
        <div>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold text-dark mb-0">
                    <i class="bi bi-building me-2 text-primary"></i>Salas y Cubículos del Campus
                </h5>
                <span class="badge bg-secondary-subtle text-secondary border">
                    <c:out value="${salasDisponibles.size()}"/> salas operativas
                </span>
            </div>

            <div class="custom-table-card">
                <div class="table-responsive">
                    <table class="table custom-table mb-0">
                        <thead>
                            <tr>
                                <th>Código</th>
                                <th>Tipo de Ambiente</th>
                                <th>Capacidad</th>
                                <th>Ubicación</th>
                                <th>Equipamiento</th>
                                <th>Estado</th>
                                <th class="text-center">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${salasDisponibles}" var="s">
                                <tr>
                                    <td>
                                        <span class="fw-bold text-primary">
                                            <i class="bi bi-door-closed me-1"></i><c:out value="${s.codigoSala}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${s.esSilenciosa == 1}">
                                                <span class="badge bg-light text-secondary border">
                                                    <i class="bi bi-volume-mute-fill text-danger me-1"></i>Silenciosa / Individual
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-light text-primary border">
                                                    <i class="bi bi-people-fill text-primary me-1"></i>Grupal / Debate
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <i class="bi bi-person me-1 text-muted"></i>Hasta <c:out value="${s.capacidad}"/> personas
                                    </td>
                                    <td>
                                        <i class="bi bi-geo-alt me-1 text-muted"></i><c:out value="${s.ubicacion}"/>
                                    </td>
                                    <td>
                                        <small class="text-muted"><c:out value="${s.recursos}"/></small>
                                    </td>
                                    <td>
                                        <span class="badge-status badge-ocupado">
                                            <i class="bi bi-check-circle-fill"></i> <c:out value="${s.estado}"/>
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/EstudianteServlet?action=nueva_reserva&idSala=${s.idSala}" class="btn btn-outline-primary btn-sm">
                                            <i class="bi bi-calendar-plus me-1"></i> Reservar
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
                &copy; Sistema de Reserva de Salas de Estudio &bull; Universidad Tecnológica del Perú (UTP)
            </p>
        </div>
    </footer>

    <!-- Bootstrap 5.3.3 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
