<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%-- Validación de Seguridad: Solo estudiantes autenticados --%>
<c:if test="${empty sessionScope.usuario or sessionScope.rol ne 'ESTUDIANTE'}">
    <c:redirect url="/error/acceso_denegado.jsp"/>
</c:if>
<%-- Si se entra directo al JSP sin pasar por el Servlet, redirigir al controlador MVC --%>
<c:if test="${salasDisponibles == null}">
    <c:redirect url="/EstudianteServlet?action=nueva_reserva"/>
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nueva Reserva | Sistema de Reservas UTP</title>
    
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
                        <a class="nav-link nav-link-custom" href="${pageContext.request.contextPath}/EstudianteServlet?action=mis_reservas">
                            <i class="bi bi-calendar2-check me-1"></i> Mis Reservas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom active" href="${pageContext.request.contextPath}/EstudianteServlet?action=nueva_reserva">
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

        <!-- BREADCRUMB -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-2" style="font-size: 0.85rem;">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/EstudianteServlet?action=dashboard">Portal</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/EstudianteServlet?action=mis_reservas">Mis Reservas</a></li>
                <li class="breadcrumb-item active" aria-current="page">Nueva Reserva</li>
            </ol>
        </nav>

        <div class="row g-4">
            
            <!-- COLUMNA IZQUIERDA: FORMULARIO DE RESERVA -->
            <div class="col-12 col-lg-8">
                
                <!-- ALERTA DE ERROR DE VALIDACIÓN -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        <c:out value="${error}"/>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <div class="card border-0 shadow-sm" style="border-radius: 16px; overflow: hidden;">
                    <div class="card-header bg-white border-bottom p-4">
                        <div class="d-flex align-items-center gap-3">
                            <div class="stat-icon blue" style="width: 44px; height: 44px; border-radius: 10px;">
                                <i class="bi bi-calendar-plus-fill"></i>
                            </div>
                            <div>
                                <h4 class="fw-bold text-dark mb-0">Agendar Espacio de Estudio</h4>
                                <small class="text-muted">
                                    Elige el cubículo, la fecha y el horario académico deseado.
                                </small>
                            </div>
                        </div>
                    </div>

                    <div class="card-body p-4 p-md-5">
                        <form action="${pageContext.request.contextPath}/EstudianteServlet" method="POST" autocomplete="off">
                            <input type="hidden" name="action" value="guardar_reserva">

                            <div class="row g-3">
                                
                                <!-- 1. Selector de Sala -->
                                <div class="col-12">
                                    <label for="idSala" class="form-label fw-bold" style="font-size: 0.88rem;">
                                        Selecciona la Sala o Cubículo <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-select" id="idSala" name="idSala" required>
                                        <option value="" disabled ${idSalaSeleccionada == 0 ? 'selected' : ''}>-- Elige un cubículo disponible --</option>
                                        <c:forEach items="${salasDisponibles}" var="s">
                                            <option value="${s.idSala}" ${s.idSala == idSalaSeleccionada ? 'selected' : ''}>
                                                <c:out value="${s.codigoSala}"/> &bull; Aforo: <c:out value="${s.capacidad}"/> personas &bull; <c:out value="${s.esSilenciosa == 1 ? 'Silenciosa' : 'Grupal'}"/> &bull; <c:out value="${s.ubicacion}"/>
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="form-text">Solo se muestran los cubículos habilitados en el campus.</div>
                                </div>

                                <!-- 2. Fecha de Reserva -->
                                <div class="col-12 col-md-6">
                                    <label for="fechaReserva" class="form-label fw-bold" style="font-size: 0.88rem;">
                                        Fecha de Reserva <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-calendar-event"></i></span>
                                        <input type="date" 
                                               class="form-control border-start-0" 
                                               id="fechaReserva" 
                                               name="fechaReserva" 
                                               min="${fechaMinima}" 
                                               max="${fechaMaxima}" 
                                               value="${not empty param.fechaReserva ? param.fechaReserva : fechaMinima}" 
                                               required>
                                    </div>
                                    <div class="form-text">Rango permitido: desde hoy hasta <c:out value="${fechaMaxima}"/>.</div>
                                </div>

                                <!-- 3. Cantidad de Integrantes -->
                                <div class="col-12 col-md-6">
                                    <label for="numIntegrantes" class="form-label fw-bold" style="font-size: 0.88rem;">
                                        Número de Integrantes <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-people"></i></span>
                                        <input type="number" 
                                               class="form-control border-start-0" 
                                               id="numIntegrantes" 
                                               name="numIntegrantes" 
                                               min="1" 
                                               max="12" 
                                               value="${not empty param.numIntegrantes ? param.numIntegrantes : 2}" 
                                               required>
                                    </div>
                                    <div class="form-text">No debe superar la capacidad de la sala elegida.</div>
                                </div>

                                <!-- 4. Rango de Horario (Inicio y Fin) -->
                                <div class="col-12 col-md-6">
                                    <label for="horaInicio" class="form-label fw-bold" style="font-size: 0.88rem;">
                                        Hora de Inicio <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-select" id="horaInicio" name="horaInicio" required>
                                        <option value="08:00">08:00 AM</option>
                                        <option value="09:00">09:00 AM</option>
                                        <option value="10:00" selected>10:00 AM</option>
                                        <option value="11:00">11:00 AM</option>
                                        <option value="12:00">12:00 PM</option>
                                        <option value="13:00">01:00 PM</option>
                                        <option value="14:00">02:00 PM</option>
                                        <option value="15:00">03:00 PM</option>
                                        <option value="16:00">04:00 PM</option>
                                        <option value="17:00">05:00 PM</option>
                                        <option value="18:00">06:00 PM</option>
                                        <option value="19:00">07:00 PM</option>
                                        <option value="20:00">08:00 PM</option>
                                    </select>
                                </div>

                                <div class="col-12 col-md-6">
                                    <label for="horaFin" class="form-label fw-bold" style="font-size: 0.88rem;">
                                        Hora de Fin <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-select" id="horaFin" name="horaFin" required>
                                        <option value="09:00">09:00 AM</option>
                                        <option value="10:00">10:00 AM</option>
                                        <option value="11:00">11:00 AM</option>
                                        <option value="12:00" selected>12:00 PM</option>
                                        <option value="13:00">01:00 PM</option>
                                        <option value="14:00">02:00 PM</option>
                                        <option value="15:00">03:00 PM</option>
                                        <option value="16:00">04:00 PM</option>
                                        <option value="17:00">05:00 PM</option>
                                        <option value="18:00">06:00 PM</option>
                                        <option value="19:00">07:00 PM</option>
                                        <option value="20:00">08:00 PM</option>
                                        <option value="21:00">09:00 PM</option>
                                        <option value="22:00">10:00 PM</option>
                                    </select>
                                </div>

                                <!-- 5. Motivo de Estudio -->
                                <div class="col-12">
                                    <label for="motivo" class="form-label fw-bold" style="font-size: 0.88rem;">
                                        Motivo / Tema de Estudio
                                    </label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="motivo" 
                                           name="motivo" 
                                           maxlength="200" 
                                           value="${not empty param.motivo ? param.motivo : ''}"
                                           placeholder="Ej. Proyecto Integrador de Sistemas, Repaso de Examen, Tesis">
                                    <div class="form-text">Opcional: ayuda a categorizar el uso de los cubículos.</div>
                                </div>

                            </div>

                            <!-- BOTONES DE ACCIÓN -->
                            <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                                <a href="${pageContext.request.contextPath}/EstudianteServlet?action=dashboard" class="btn btn-outline-secondary">
                                    <i class="bi bi-x-circle me-1"></i> Cancelar
                                </a>
                                <button type="submit" class="btn btn-utp px-4">
                                    <i class="bi bi-calendar-check-fill me-1"></i> Confirmar Reserva
                                </button>
                            </div>

                        </form>
                    </div>
                </div>

            </div>

            <!-- COLUMNA DERECHA: POLÍTICAS Y BENEFICIOS DEL ESTUDIANTE -->
            <div class="col-12 col-lg-4">
                
                <!-- Tarjeta de Beneficios por Jerarquía -->
                <div class="card border-0 shadow-sm mb-4" style="border-radius: 16px;">
                    <div class="card-body p-4">
                        <div class="d-flex align-items-center gap-2 mb-3">
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle p-2">
                                <i class="bi bi-award-fill fs-5"></i>
                            </span>
                            <div>
                                <h6 class="fw-bold mb-0 text-dark">Tu Jerarquía Universitaria</h6>
                                <small class="text-muted"><c:out value="${sessionScope.tipoEstudiante}"/></small>
                            </div>
                        </div>

                        <ul class="list-unstyled mb-0 d-flex flex-column gap-3" style="font-size: 0.9rem;">
                            <li class="d-flex align-items-center gap-2">
                                <i class="bi bi-clock-history text-primary fs-5"></i>
                                <div>
                                    <span class="fw-semibold">Cupo Máximo Diario:</span>
                                    <span class="text-dark d-block"><c:out value="${sessionScope.horasMaxDia}"/> horas por día</span>
                                </div>
                            </li>
                            <li class="d-flex align-items-center gap-2">
                                <i class="bi bi-calendar-range text-primary fs-5"></i>
                                <div>
                                    <span class="fw-semibold">Anticipación Permitida:</span>
                                    <span class="text-dark d-block">Hasta <c:out value="${sessionScope.diasAnticipacion}"/> días antes</span>
                                </div>
                            </li>
                            <li class="d-flex align-items-center gap-2">
                                <i class="bi bi-shield-check text-success fs-5"></i>
                                <div>
                                    <span class="fw-semibold">Prioridad de Turno:</span>
                                    <span class="text-dark d-block">Nivel <c:out value="${sessionScope.nivelPrioridad}"/></span>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Tarjeta de Reglas de Biblioteca -->
                <div class="card border-0 shadow-sm" style="border-radius: 16px; background-color: #f8fafc; border: 1px dashed #cbd5e1 !important;">
                    <div class="card-body p-4">
                        <h6 class="fw-bold text-dark mb-3">
                            <i class="bi bi-info-circle-fill text-primary me-2"></i>Reglas de Uso de Cubículos
                        </h6>
                        <ul class="text-secondary ps-3 mb-0" style="font-size: 0.85rem; line-height: 1.6;">
                            <li>Presentarse dentro de los <strong>primeros 15 minutos</strong> para el registro presencial con el Encargado.</li>
                            <li>No exceder el aforo máximo indicado para la sala.</li>
                            <li>En salas silenciosas se exige uso de auriculares y prohibición de debate en voz alta.</li>
                            <li>La cancelación voluntaria debe hacerse con al menos 1 hora de anticipación.</li>
                        </ul>
                    </div>
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
