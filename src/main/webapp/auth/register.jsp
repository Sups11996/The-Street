<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Sahayog Sathi</title>
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
                url('<%= request.getContextPath() %>/images/registration%20hero.jpg')
                center center / cover no-repeat fixed;
            position: relative;
            padding: 40px 20px;
        }

        /* Dark overlay */
        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.45);
            z-index: 0;
        }

        /* Wrapper */
        .register-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            z-index: 1;
            width: 100%;
        }

        /* Brand above card */
        .brand-label {
            text-align: center;
            margin-bottom: 20px;
        }

        .brand-label h1 {
            font-size: 32px;
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

        /* Glassmorphism card */
        .auth-card {
            width: 100%;
            max-width: 560px;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            border: 1px solid rgba(255, 255, 255, 0.30);
            border-radius: 20px;
            padding: 44px 40px;
            box-shadow: 0 8px 40px rgba(0, 0, 0, 0.35);
        }

        .auth-card h2 {
            font-size: 26px;
            font-weight: 700;
            color: #E8F5F0;
            margin-bottom: 6px;
            letter-spacing: -0.3px;
            text-shadow: 0 1px 4px rgba(0,0,0,0.30);
        }

        .auth-card .subtitle {
            font-size: 14px;
            color: rgba(220, 245, 235, 0.75);
            margin-bottom: 28px;
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

        /* Two-column grid for fields */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0 20px;
        }

        .form-grid .form-group-full {
            grid-column: 1 / -1;
        }

        /* Form groups */
        .form-group {
            margin-bottom: 16px;
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

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 11px 14px;
            background: rgba(255, 255, 255, 0.82);
            border: 1px solid rgba(255, 255, 255, 0.50);
            border-radius: 10px;
            font-size: 14px;
            color: #1E1E1E;
            transition: border-color 0.2s, background 0.2s;
        }

        .form-group input::placeholder {
            color: #9CA3AF;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #1F7A5C;
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 0 0 0 3px rgba(31, 122, 92, 0.20);
        }

        /* File input — hidden, replaced with custom button */
        .file-upload-wrapper {
            position: relative;
        }

        .file-upload-wrapper input[type="file"] {
            position: absolute;
            inset: 0;
            opacity: 0;
            cursor: pointer;
            width: 100%;
            height: 100%;
            z-index: 2;
        }

        .file-upload-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            width: 100%;
            padding: 11px 14px;
            height: 43px;
            background: rgba(255, 255, 255, 0.82);
            border: 1.5px dashed rgba(31, 122, 92, 0.55);
            border-radius: 10px;
            cursor: pointer;
            transition: background 0.2s, border-color 0.2s;
        }

        .file-upload-btn:hover {
            background: rgba(255, 255, 255, 0.95);
            border-color: #1F7A5C;
        }

        .file-upload-icon {
            width: 18px;
            height: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .file-upload-icon svg {
            width: 18px;
            height: 18px;
            stroke: #1F7A5C;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .file-upload-text {
            display: flex;
            align-items: center;
        }

        .file-upload-text span:first-child {
            font-size: 14px;
            font-weight: 500;
            color: #374151;
            line-height: 1;
        }

        .file-upload-text span:last-child {
            display: none;
        }

        .file-name-display {
            font-size: 12px;
            color: #E8F5F0;
            margin-top: 5px;
            padding-left: 2px;
            min-height: 16px;
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
            margin-top: 6px;
        }

        .btn-submit:hover { background: #145A42; }
        .btn-submit:active { transform: scale(0.99); }

        /* Divider */
        .form-divider {
            border: none;
            border-top: 1px solid rgba(255, 255, 255, 0.25);
            margin: 22px 0;
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

        @media (max-width: 560px) {
            .auth-card { padding: 32px 22px; }
            .form-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<div class="register-wrapper">

    <div class="brand-label">
        <h1>Sahayog Sathi</h1>
        <p>Join the community and start making a difference</p>
    </div>

    <div class="auth-card">
        <h2>Create account</h2>
        <p class="subtitle">Fill in the details below to get started</p>

        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="message error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <% if (request.getAttribute("successMessage") != null) { %>
        <div class="message success"><%= request.getAttribute("successMessage") %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/register" method="post" enctype="multipart/form-data">

            <div class="form-grid">

                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName"
                           placeholder="John Doe" required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="text" id="phone" name="phone"
                           placeholder="+977 XXXXXXXXXX" required>
                </div>

                <div class="form-group form-group-full">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email"
                           placeholder="you@example.com" required>
                </div>

                <div class="form-group form-group-full">
                    <label for="address">Address</label>
                    <input type="text" id="address" name="address"
                           placeholder="Your city / area">
                </div>

                <div class="form-group">
                    <label for="role">Role</label>
                    <select id="role" name="role" required>
                        <option value="">-- Select role --</option>
                        <option value="DONOR">Donor</option>
                        <option value="RECEIVER">Receiver</option>
                        <option value="VOLUNTEER">Volunteer</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="profileImage">Profile Image <span style="font-weight:400;text-transform:none;font-size:11px;">(optional)</span></label>
                    <div class="file-upload-wrapper">
                        <input type="file" id="profileImage" name="profileImage"
                               accept="image/png, image/jpeg, image/jpg"
                               onchange="updateFileName(this)">
                        <div class="file-upload-btn">
                            <div class="file-upload-icon">
                                <svg viewBox="0 0 24 24">
                                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                                    <polyline points="17 8 12 3 7 8"/>
                                    <line x1="12" y1="3" x2="12" y2="15"/>
                                </svg>
                            </div>
                            <div class="file-upload-text">
                                <span>Upload photo</span>
                                <span>PNG, JPG up to 5MB</span>
                            </div>
                        </div>
                        <div class="file-name-display" id="fileNameDisplay"></div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="password-wrapper">
                        <input type="password" id="password" name="password"
                               placeholder="Min. 6 characters" required>
                        <button type="button" class="toggle-password"
                                onclick="togglePassword('password', 'icon-show-p', 'icon-hide-p')"
                                title="Show/hide password">
                            <svg id="icon-show-p" viewBox="0 0 24 24">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                <circle cx="12" cy="12" r="3"/>
                            </svg>
                            <svg id="icon-hide-p" viewBox="0 0 24 24" style="display:none;">
                                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/>
                                <path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/>
                                <line x1="1" y1="1" x2="23" y2="23"/>
                            </svg>
                        </button>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <div class="password-wrapper">
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               placeholder="Repeat password" required>
                        <button type="button" class="toggle-password"
                                onclick="togglePassword('confirmPassword', 'icon-show-cp', 'icon-hide-cp')"
                                title="Show/hide password">
                            <svg id="icon-show-cp" viewBox="0 0 24 24">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                <circle cx="12" cy="12" r="3"/>
                            </svg>
                            <svg id="icon-hide-cp" viewBox="0 0 24 24" style="display:none;">
                                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/>
                                <path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/>
                                <line x1="1" y1="1" x2="23" y2="23"/>
                            </svg>
                        </button>
                    </div>
                </div>

            </div>

            <button type="submit" class="btn-submit">Create Account</button>
        </form>

        <hr class="form-divider">

        <div class="auth-link">
            Already have an account?
            <a href="<%= request.getContextPath() %>/auth/login.jsp">Sign in</a>
        </div>
    </div>

</div>

<script>
    function togglePassword(fieldId, showIconId, hideIconId) {
        const input = document.getElementById(fieldId);
        const iconShow = document.getElementById(showIconId);
        const iconHide = document.getElementById(hideIconId);

        if (input.type === 'password') {
            input.type = 'text';
            iconShow.style.display = 'none';
            iconHide.style.display = 'block';
        } else {
            input.type = 'password';
            iconShow.style.display = 'block';
            iconHide.style.display = 'none';
        }
    }

    function updateFileName(input) {
        const display = document.getElementById('fileNameDisplay');
        if (input.files && input.files.length > 0) {
            display.textContent = input.files[0].name;
        } else {
            display.textContent = '';
        }
    }
</script>

</body>
</html>
