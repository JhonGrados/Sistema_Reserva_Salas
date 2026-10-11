<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso al Sistema | Reservas UTP</title>
    
    <!-- Google Fonts: Plus Jakarta Sans -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Bootstrap 5.3.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Estilos personalizados -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>

    <div class="container-fluid login-wrapper p-0">
        <div class="row g-0 h-100">
            
            <!-- ===============================================================
                 COLUMNA IZQUIERDA: HERO INSTITUCIONAL (SPLIT 50%)
                 Visible solo en pantallas grandes (Desktop / Laptop)
                 =============================================================== -->
            <div class="col-lg-6 d-none d-lg-flex login-hero-side">
                <div class="hero-content">
                    <!-- Etiqueta superior institucional -->
                    <span class="hero-badge">RESERVAS UTP</span>
                    
                    <!-- Titular de impacto -->
                    <h1 class="hero-title">
                        Tu próximo espacio para crear comienza aquí.
                    </h1>
                    
                    <!-- Subtítulo institucional -->
                    <p class="hero-subtitle">
                        Encuentra y reserva salas de estudio en todo el campus de manera rápida y sencilla.
                    </p>
                </div>
            </div>

            <!-- ===============================================================
                 COLUMNA DERECHA: FORMULARIO DE ACCESO (SPLIT 50%)
                 Centrado vertical y horizontalmente, 100% responsivo
                 =============================================================== -->
            <div class="col-12 col-lg-6 login-form-side">
                
                <!-- Espaciador superior para balance estético -->
                <div class="d-none d-lg-block"></div>

                <!-- Contenedor central del Formulario (max-width: 430px) -->
                <div class="login-card-box">
                    
                    <!-- Encabezado del Formulario -->
                    <div class="text-center mb-4">
                        <h2 class="form-header-title">Acceso al Sistema</h2>
                        <p class="form-header-subtitle">Ingresa con tus credenciales institucionales</p>
                    </div>

                    <!-- Mensajes de Alerta / Error dinámicos desde el Servlet (MVC) -->
                    <% 
                        String error = (String) request.getAttribute("error");
                        if (error == null) {
                            error = request.getParameter("error");
                        }
                        if (error != null && !error.trim().isEmpty()) { 
                    %>
                        <div class="alert alert-danger d-flex align-items-center gap-2 py-2 px-3 mb-4 rounded-3 small" role="alert">
                            <i class="bi bi-exclamation-triangle-fill flex-shrink-0"></i>
                            <div><%= error %></div>
                        </div>
                    <% } %>

                    <% 
                        String mensaje = (String) request.getAttribute("mensaje");
                        if (mensaje != null && !mensaje.trim().isEmpty()) { 
                    %>
                        <div class="alert alert-success d-flex align-items-center gap-2 py-2 px-3 mb-4 rounded-3 small" role="alert">
                            <i class="bi bi-check-circle-fill flex-shrink-0"></i>
                            <div><%= mensaje %></div>
                        </div>
                    <% } %>

                    <!-- Formulario de Autenticación -->
                    <form action="${pageContext.request.contextPath}/AuthServlet" method="POST" autocomplete="on">
                        
                        <!-- Campo: Usuario / Código / Correo -->
                        <div class="mb-3">
                            <label for="codigo" class="form-label-custom">Código universitario / Correo</label>
                            <input type="text" 
                                   class="form-control form-control-custom w-100" 
                                   id="codigo" 
                                   name="codigo" 
                                   placeholder="u20240001@utp.edu.pe" 
                                   value="<%= request.getAttribute("codigoIngresado") != null ? request.getAttribute("codigoIngresado") : "" %>"
                                   required 
                                   autofocus>
                        </div>

                        <!-- Campo: Contraseña -->
                        <div class="mb-3">
                            <label for="clave" class="form-label-custom">Contraseña</label>
                            <input type="password" 
                                   class="form-control form-control-custom w-100" 
                                   id="clave" 
                                   name="clave" 
                                   placeholder="Ingresa tu contraseña" 
                                   required>
                        </div>

                        <!-- Fila de opciones: Recordar y Recuperar contraseña -->
                        <div class="d-flex justify-content-between align-items-center options-row mb-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="recordarme" name="recordarme">
                                <label class="form-check-label" for="recordarme">
                                    Recordarme
                                </label>
                            </div>
                            <div>
                                <a href="recuperar-clave.jsp" class="forgot-link">¿Olvidaste tu contraseña?</a>
                            </div>
                        </div>

                        <!-- Botón de Envío -->
                        <button type="submit" class="btn btn-login-submit w-100">
                            Ingresar &rarr;
                        </button>

                        <!-- Mensaje de Seguridad -->
                        <div class="security-note">
                            <i class="bi bi-lock-fill"></i>
                            <span>Acceso seguro con cuenta institucional</span>
                        </div>

                    </form>
                </div>

                <!-- Footer inferior: Soporte TI -->
                <div class="login-footer">
                    <span>¿Necesitas ayuda? </span>
                    <a href="mailto:soporte@utp.edu.pe">Contacta a soporte TI</a>
                </div>

            </div>
            
        </div>
    </div>

    <!-- Bootstrap 5.3.3 Bundle con Popper JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
