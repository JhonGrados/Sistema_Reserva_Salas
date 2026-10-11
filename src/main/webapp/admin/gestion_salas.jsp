<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%-- Validación de Seguridad: Solo Administradores autenticados --%>
<c:if test="${empty sessionScope.usuario or sessionScope.rol ne 'ADMINISTRADOR'}">
    <c:redirect url="/error/acceso_denegado.jsp"/>
</c:if>
<%-- Si se entra directo al JSP sin pasar por el Servlet, redirigir al controlador MVC --%>
<c:if test="${listaSalas == null}">
    <c:redirect url="/SalaServlet?action=listar"/>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Salas | Sistema de Reservas UTP</title>
    
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
                        <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/AdminServlet?action=dashboard">
                            <i class="bi bi-speedometer2 me-1"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom active" href="${pageContext.request.contextPath}/SalaServlet?action=listar">
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

        <!-- CABECERA Y BOTÓN NUEVA SALA -->
        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3 mb-4">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1" style="font-size: 0.85rem;">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/AdminServlet?action=dashboard">Dashboard</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Gestión de Salas</li>
                    </ol>
                </nav>
                <h3 class="fw-bold text-dark mb-0">
                    <i class="bi bi-door-open-fill text-primary me-2"></i>Mantenimiento de Salas y Cubículos
                </h3>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/SalaServlet?action=nuevo" class="btn btn-utp fw-semibold shadow-sm">
                    <i class="bi bi-plus-lg me-1"></i> Nueva Sala
                </a>
            </div>
        </div>

        <!-- MENSAJES DE RETROALIMENTACIÓN -->
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

        <!-- TABLA DE SALAS (JSTL / EL) -->
        <div class="custom-table-card">
            <div class="table-responsive">
                <table class="table custom-table mb-0">
                    <thead>
                        <tr>
                            <th>N°</th>
                            <th>Código</th>
                            <th>Capacidad</th>
                            <th>Tipo de Ambiente</th>
                            <th>Ubicación</th>
                            <th>Equipamiento</th>
                            <th>Estado</th>
                            <th class="text-center" style="min-width: 170px;">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${listaSalas}" var="s">
                            <tr>
                                <td>
                                    <span class="text-secondary fw-semibold">#<c:out value="${s.idSala}"/></span>
                                </td>
                                <td>
                                    <span class="fw-bold text-primary">
                                        <i class="bi bi-door-closed me-1"></i><c:out value="${s.codigoSala}"/>
                                    </span>
                                </td>
                                <td>
                                    <i class="bi bi-person me-1 text-muted"></i>Hasta <c:out value="${s.capacidad}"/> personas
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
                                    <div class="btn-group" role="group">
                                        <!-- Botón Editar -->
                                        <a href="${pageContext.request.contextPath}/SalaServlet?action=editar&id=${s.idSala}" 
                                           class="btn btn-outline-primary btn-sm" 
                                           title="Editar detalles y aforo">
                                            <i class="bi bi-pencil-square me-1"></i> Editar
                                        </a>

                                        <!-- Menú desplegable para cambio de estado rápido -->
                                        <button type="button" 
                                                class="btn btn-outline-secondary btn-sm dropdown-toggle dropdown-toggle-split" 
                                                data-bs-toggle="dropdown" 
                                                aria-expanded="false"
                                                title="Cambiar estado">
                                            <span class="visually-hidden">Toggle Dropdown</span>
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0" style="font-size: 0.85rem;">
                                            <li><h6 class="dropdown-header">Cambiar Estado</h6></li>
                                            <c:if test="${s.estado ne 'DISPONIBLE'}">
                                                <li>
                                                    <a class="dropdown-item text-success" href="${pageContext.request.contextPath}/SalaServlet?action=cambiar_estado&id=${s.idSala}&estado=DISPONIBLE">
                                                        <i class="bi bi-check-circle me-2"></i> Poner DISPONIBLE
                                                    </a>
                                                </li>
                                            </c:if>
                                            <c:if test="${s.estado ne 'MANTENIMIENTO'}">
                                                <li>
                                                    <a class="dropdown-item text-warning" href="${pageContext.request.contextPath}/SalaServlet?action=cambiar_estado&id=${s.idSala}&estado=MANTENIMIENTO">
                                                        <i class="bi bi-tools me-2"></i> Enviar a MANTENIMIENTO
                                                    </a>
                                                </li>
                                            </c:if>
                                            <c:if test="${s.estado ne 'INHABILITADO'}">
                                                <li>
                                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/SalaServlet?action=cambiar_estado&id=${s.idSala}&estado=INHABILITADO">
                                                        <i class="bi bi-slash-circle me-2"></i> INHABILITAR
                                                    </a>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
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
