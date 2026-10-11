<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%-- Validación de Seguridad: Solo Administradores autenticados --%>
<c:if test="${empty sessionScope.usuario or sessionScope.rol ne 'ADMINISTRADOR'}">
    <c:redirect url="/error/acceso_denegado.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${empty sala or sala.idSala == 0}">Registrar Nueva Sala | Reservas UTP</c:when>
            <c:otherwise>Editar Sala ${sala.codigoSala} | Reservas UTP</c:otherwise>
        </c:choose>
    </title>
    
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
    <main class="container py-4 flex-grow-1" style="max-width: 800px;">

        <!-- BREADCRUMB -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-2" style="font-size: 0.85rem;">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/AdminServlet?action=dashboard">Dashboard</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/SalaServlet?action=listar">Gestión de Salas</a></li>
                <li class="breadcrumb-item active" aria-current="page">
                    <c:choose>
                        <c:when test="${empty sala or sala.idSala == 0}">Nueva Sala</c:when>
                        <c:otherwise>Editar Sala</c:otherwise>
                    </c:choose>
                </li>
            </ol>
        </nav>

        <!-- ALERTA DE ERROR DE VALIDACIÓN -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <c:out value="${error}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- TARJETA DEL FORMULARIO -->
        <div class="card border-0 shadow-sm" style="border-radius: 16px; overflow: hidden;">
            <div class="card-header bg-white border-bottom p-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="stat-icon blue" style="width: 44px; height: 44px; border-radius: 10px;">
                        <i class="bi bi-pencil-square"></i>
                    </div>
                    <div>
                        <h4 class="fw-bold text-dark mb-0">
                            <c:choose>
                                <c:when test="${empty sala or sala.idSala == 0}">Registrar Nueva Sala</c:when>
                                <c:otherwise>Modificar Sala: <c:out value="${sala.codigoSala}"/></c:otherwise>
                            </c:choose>
                        </h4>
                        <small class="text-muted">
                            Ingresa los datos y especificaciones técnicas del ambiente de estudio.
                        </small>
                    </div>
                </div>
            </div>

            <div class="card-body p-4 p-md-5">
                <form action="${pageContext.request.contextPath}/SalaServlet" method="POST" autocomplete="off">
                    <input type="hidden" name="action" value="guardar">
                    <input type="hidden" name="idSala" value="${sala != null ? sala.idSala : 0}">

                    <div class="row g-3">
                        <!-- Código de Sala -->
                        <div class="col-12 col-md-6">
                            <label for="codigoSala" class="form-label fw-bold" style="font-size: 0.88rem;">
                                Código de Sala <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-door-closed"></i></span>
                                <input type="text" 
                                       class="form-control border-start-0" 
                                       id="codigoSala" 
                                       name="codigoSala" 
                                       value="${sala != null ? sala.codigoSala : ''}" 
                                       placeholder="Ej. CUB-07" 
                                       maxlength="20"
                                       required>
                            </div>
                            <div class="form-text">Debe ser un identificador único en el campus.</div>
                        </div>

                        <!-- Capacidad / Aforo -->
                        <div class="col-12 col-md-6">
                            <label for="capacidad" class="form-label fw-bold" style="font-size: 0.88rem;">
                                Capacidad Máxima (Aforo) <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-people"></i></span>
                                <input type="number" 
                                       class="form-control border-start-0" 
                                       id="capacidad" 
                                       name="capacidad" 
                                       value="${sala != null ? sala.capacidad : 4}" 
                                       min="1" 
                                       max="50" 
                                       required>
                            </div>
                            <div class="form-text">Número máximo de alumnos permitidos.</div>
                        </div>

                        <!-- Tipo de Ambiente -->
                        <div class="col-12 col-md-6">
                            <label class="form-label fw-bold d-block" style="font-size: 0.88rem;">
                                Tipo de Ambiente <span class="text-danger">*</span>
                            </label>
                            <div class="d-flex gap-3 pt-1">
                                <div class="form-check">
                                    <input class="form-check-input" 
                                           type="radio" 
                                           name="esSilenciosa" 
                                           id="tipoGrupal" 
                                           value="0" 
                                           ${sala == null or sala.esSilenciosa == 0 ? 'checked' : ''}>
                                    <label class="form-check-label" for="tipoGrupal">
                                        <i class="bi bi-people text-primary me-1"></i> Grupal / Debate
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" 
                                           type="radio" 
                                           name="esSilenciosa" 
                                           id="tipoSilenciosa" 
                                           value="1" 
                                           ${sala != null and sala.esSilenciosa == 1 ? 'checked' : ''}>
                                    <label class="form-check-label" for="tipoSilenciosa">
                                        <i class="bi bi-volume-mute-fill text-danger me-1"></i> Silenciosa
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Estado de la Sala -->
                        <div class="col-12 col-md-6">
                            <label for="estado" class="form-label fw-bold" style="font-size: 0.88rem;">
                                Estado Operativo <span class="text-danger">*</span>
                            </label>
                            <select class="form-select" id="estado" name="estado" required>
                                <option value="DISPONIBLE" ${sala == null or sala.estado eq 'DISPONIBLE' ? 'selected' : ''}>
                                    DISPONIBLE (Habilitada para reservas)
                                </option>
                                <option value="MANTENIMIENTO" ${sala != null and sala.estado eq 'MANTENIMIENTO' ? 'selected' : ''}>
                                    MANTENIMIENTO (Temporalmente fuera de servicio)
                                </option>
                                <option value="INHABILITADO" ${sala != null and sala.estado eq 'INHABILITADO' ? 'selected' : ''}>
                                    INHABILITADO (Deshabilitada)
                                </option>
                            </select>
                        </div>

                        <!-- Ubicación -->
                        <div class="col-12">
                            <label for="ubicacion" class="form-label fw-bold" style="font-size: 0.88rem;">
                                Ubicación Física en el Campus <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-geo-alt"></i></span>
                                <input type="text" 
                                       class="form-control border-start-0" 
                                       id="ubicacion" 
                                       name="ubicacion" 
                                       value="${sala != null ? sala.ubicacion : 'Piso 2 - Pabellón A'}" 
                                       placeholder="Ej. Piso 2 - Pabellón A" 
                                       maxlength="100" 
                                       required>
                            </div>
                        </div>

                        <!-- Recursos y Equipamiento -->
                        <div class="col-12">
                            <label for="recursos" class="form-label fw-bold" style="font-size: 0.88rem;">
                                Recursos y Equipamiento Incluido
                            </label>
                            <textarea class="form-control" 
                                      id="recursos" 
                                      name="recursos" 
                                      rows="2" 
                                      maxlength="255" 
                                      placeholder="Ej. Pizarra acrílica, Tomas eléctricas, Wi-Fi 6, Smart TV">${sala != null ? sala.recursos : 'Pizarra acrílica, Tomas eléctricas, Wi-Fi 6'}</textarea>
                            <div class="form-text">Detalla los implementos disponibles para los estudiantes.</div>
                        </div>
                    </div>

                    <!-- BOTONES DE ACCIÓN -->
                    <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/SalaServlet?action=listar" class="btn btn-outline-secondary">
                            <i class="bi bi-x-circle me-1"></i> Cancelar
                        </a>
                        <button type="submit" class="btn btn-utp px-4">
                            <i class="bi bi-check2-circle me-1"></i> 
                            <c:choose>
                                <c:when test="${empty sala or sala.idSala == 0}">Registrar Sala</c:when>
                                <c:otherwise>Guardar Cambios</c:otherwise>
                            </c:choose>
                        </button>
                    </div>

                </form>
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
