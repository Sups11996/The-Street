<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String rememberedEmail = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("rememberEmail".equals(cookie.getName())) {
                rememberedEmail = cookie.getValue();
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Sahayog Sathi</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background:
                url('<%= request.getContextPath() %>/images/login%20hero.jpg')
                center center / cover no-repeat fixed;
            position: relative;
        }

        /* Dark overlay on top of image */
        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.45);
            z-index: 0;
        }

        /* Glassmorphism card */
        .auth-card {
            position: relative;
            z-index: 1;
            width: 420px;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            border: 1px solid rgba(255, 255, 255, 0.30);
            border-radius: 20px;
            padding: 44px 40px;
            box-shadow: 0 8px 40px rgba(0, 0, 0, 0.35);
        }

        .auth-card h2 {
            font-size: 28px;
            font-weight: 700;
            color: #E8F5F0;
            margin-bottom: 6px;
            letter-spacing: -0.3px;
            text-shadow: 0 1px 4px rgba(0,0,0,0.30);
        }

        .auth-card .subtitle {
            font-size: 14px;
            color: rgba(220, 245, 235, 0.75);
            margin-bottom: 30px;
            text-shadow: 0 1px 3px rgba(0,0,0,0.25);
        }

        /* Messages */
        .message {
            padding: 11px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .error {
            background: rgba(239, 68, 68, 0.20);
            border: 1px solid rgba(239, 68, 68, 0.45);
            color: #fca5a5;
        }

        .success {
            background: rgba(16, 185, 129, 0.18);
            border: 1px solid rgba(16, 185, 129, 0.40);
            color: #6ee7b7;
        }

        /* Form groups */
        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            margin-bottom: 7px;
            font-size: 12px;
            font-weight: 600;
            color: rgba(220, 245, 235, 0.85);
            letter-spacing: 0.6px;
            text-transform: uppercase;
            text-shadow: 0 1px 3px rgba(0,0,0,0.25);
        }

        .form-group input {
            width: 100%;
            padding: 12px 14px;
            background: rgba(255, 255, 255, 0.82);
            border: 1px solid rgba(255, 255, 255, 0.50);
            border-radius: 10px;
            font-size: 15px;
            color: #1E1E1E;
            transition: border-color 0.2s, background 0.2s;
        }

        .form-group input::placeholder {
            color: #9CA3AF;
        }

        .form-group input:focus {
            outline: none;
            border-color: #1F7A5C;
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 0 0 0 3px rgba(31, 122, 92, 0.20);
        }

        /* Password toggle */
        .password-wrapper {
            position: relative;
        }

        .password-wrapper input {
            padding-right: 48px;
        }

        .toggle-password {
            position: absolute;
            right: 0;
            top: 0;
            bottom: 0;
            width: 46px;
            background: none;
            border: none;
            border-radius: 0 10px 10px 0;
            cursor: pointer;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #145A42;
            transition: color 0.15s;
        }

        .toggle-password:hover {
            background: none;
            color: #0D3D2B;
        }

        /* SVG eye icons */
        .toggle-password svg {
            width: 18px;
            height: 18px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2.2;
            stroke-linecap: round;
            stroke-linejoin: round;
            pointer-events: none;
        }

        /* Remember row */
        .remember-row {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 22px;
            font-size: 14px;
            color: rgba(220, 245, 235, 0.80);
            text-shadow: 0 1px 3px rgba(0,0,0,0.25);
        }

        .remember-row input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: #1F7A5C;
            cursor: pointer;
        }

        .remember-row label {
            cursor: pointer;
        }

        /* Submit button */
        .btn-submit {
            width: 100%;
            padding: 13px;
            background: #1F7A5C;
            color: #E8F5F0;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            letter-spacing: 0.3px;
            transition: background 0.2s, transform 0.1s;
        }

        .btn-submit:hover {
            background: #145A42;
        }

        .btn-submit:active {
            transform: scale(0.99);
        }

        /* Divider */
        .form-divider {
            border: none;
            border-top: 1px solid rgba(255, 255, 255, 0.25);
            margin: 24px 0;
        }

        /* Auth link */
        .auth-link {
            text-align: center;
            font-size: 14px;
            color: rgba(220, 245, 235, 0.70);
            text-shadow: 0 1px 3px rgba(0,0,0,0.20);
        }

        .auth-link a {
            color: #A7F3D0;
            font-weight: 600;
            text-decoration: none;
        }

        .auth-link a:hover {
            color: #D1FAE5;
            text-decoration: underline;
        }

        /* Branding above card */
        .brand-label {
            position: relative;
            z-index: 1;
            text-align: center;
            margin-bottom: 20px;
        }

        .brand-label h1 {
            font-size: 24px;
            font-weight: 700;
            color: #E8F5F0;
            letter-spacing: 0.5px;
            text-shadow: 0 2px 8px rgba(0,0,0,0.40);
        }

        .brand-label p {
            font-size: 13px;
            color: rgba(200, 230, 218, 0.75);
            margin-top: 5px;
            text-shadow: 0 1px 4px rgba(0,0,0,0.35);
        }

        /* Wrapper to stack brand + card */
        .login-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        @media (max-width: 480px) {
            .auth-card {
                width: 100%;
                margin: 20px;
                padding: 34px 26px;
            }
        }
    </style>
</head>
<body>

<div class="login-wrapper">

    <div class="brand-label">
        <h1>Sahayog Sathi</h1>
        <p>Connecting communities, one act of kindness at a time</p>
    </div>

    <div class="auth-card">
        <h2>Welcome back</h2>
        <p class="subtitle">Sign in to your account to continue</p>

        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="message error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <% if (request.getAttribute("successMessage") != null) { %>
        <div class="message success"><%= request.getAttribute("successMessage") %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="post">

            <div class="form-group">
                <label for="email">Email address</label>
                <input type="email" id="email" name="email"
                       value="<%= rememberedEmail %>"
                       placeholder="you@example.com" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <div class="password-wrapper">
                    <input type="password" id="password" name="password"
                           placeholder="Enter your password" required>
                    <button type="button" class="toggle-password" id="toggleBtn"
                            onclick="togglePassword('password', this)" title="Show/hide password">
                        <!-- Eye icon (show) -->
                        <svg id="icon-show" viewBox="0 0 24 24">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                            <circle cx="12" cy="12" r="3"/>
                        </svg>
                        <!-- Eye-off icon (hide) — hidden by default -->
                        <svg id="icon-hide" viewBox="0 0 24 24" style="display:none;">
                            <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/>
                            <path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/>
                            <line x1="1" y1="1" x2="23" y2="23"/>
                        </svg>
                    </button>
                </div>
            </div>

            <div class="remember-row">
                <input type="checkbox" id="rememberMe" name="rememberMe" value="yes">
                <label for="rememberMe">Remember me</label>
            </div>

            <button type="submit" class="btn-submit">Sign In</button>
        </form>

        <hr class="form-divider">

        <div class="auth-link">
            Don't have an account?
            <a href="<%= request.getContextPath() %>/auth/register.jsp">Create one</a>
        </div>
    </div>

</div>

<script>
    function togglePassword(fieldId, btn) {
        const input = document.getElementById(fieldId);
        const iconShow = document.getElementById('icon-show');
        const iconHide = document.getElementById('icon-hide');

        if (input.type === 'password') {
            input.type = 'text';
            iconShow.style.display = 'none';
            iconHide.style.display = 'block';
            btn.title = 'Hide password';
        } else {
            input.type = 'password';
            iconShow.style.display = 'block';
            iconHide.style.display = 'none';
            btn.title = 'Show password';
        }
    }
</script>

</body>
</html>
