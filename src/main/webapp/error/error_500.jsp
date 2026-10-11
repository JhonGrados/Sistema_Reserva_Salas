<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Error del Servidor | Reservas UTP</title>
    
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
            color: #dc2626;
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
        <div class="error-code">500</div>
        <h4 class="fw-bold text-dark mb-2">Error Interno del Servidor</h4>
        <p class="text-secondary mb-4">
            Ocurrió un problema imprevisto al procesar tu solicitud. Por favor intenta recargar la página o comunícate con soporte de sistemas de biblioteca.
        </p>

        <div class="d-flex flex-column flex-sm-row gap-2 justify-content-center">
            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-secondary">
                <i class="bi bi-box-arrow-in-left me-1"></i> Ir al Login
            </a>
            <a href="javascript:history.back()" class="btn btn-utp-primary">
                <i class="bi bi-arrow-counterclockwise me-1"></i> Reintentar
            </a>
        </div>
    </div>

</body>
</html>
