<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Página no Encontrada | Reservas UTP</title>
    
    <!-- Google Fonts: Plus Jakarta Sans -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Bootstrap 5.3.3 CSS & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
        }
        .error-card {
            max-width: 520px;
            width: 100%;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.08);
            border: 1px solid #e2e8f0;
            padding: 2.5rem;
            text-align: center;
        }
        .error-code {
            font-size: 5rem;
            font-weight: 800;
            color: #1e3a8a;
            line-height: 1;
            margin-bottom: 1rem;
        }
        .btn-utp-primary {
            background-color: #1e3a8a;
            color: #ffffff;
            border: none;
            padding: 0.65rem 1.5rem;
            font-weight: 600;
            border-radius: 8px;
        }
        .btn-utp-primary:hover {
            background-color: #172554;
            color: #ffffff;
        }
    </style>
</head>
<body>

    <div class="error-card">
        <div class="error-code">404</div>
        <h4 class="fw-bold text-dark mb-2">Página no Encontrada</h4>
        <p class="text-secondary mb-4">
            El recurso o la URL que estás intentando consultar no existe o ha sido movido a otra ubicación dentro del portal.
        </p>

        <div class="d-flex flex-column flex-sm-row gap-2 justify-content-center">
            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-secondary">
                <i class="bi bi-box-arrow-in-left me-1"></i> Ir al Login
            </a>
            <c:if test="${not empty sessionScope.usuario}">
                <c:choose>
                    <c:when test="${sessionScope.rol eq 'ESTUDIANTE'}">
                        <a href="${pageContext.request.contextPath}/EstudianteServlet?action=dashboard" class="btn btn-utp-primary">
                            <i class="bi bi-house me-1"></i> Mi Portal
                        </a>
                    </c:when>
                    <c:when test="${sessionScope.rol eq 'ADMINISTRADOR'}">
                        <a href="${pageContext.request.contextPath}/AdminServlet?action=dashboard" class="btn btn-utp-primary">
                            <i class="bi bi-speedometer2 me-1"></i> Panel Admin
                        </a>
                    </c:when>
                </c:choose>
            </c:if>
        </div>
    </div>

</body>
</html>
