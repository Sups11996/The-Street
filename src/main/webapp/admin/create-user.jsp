<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create User – Sahayog Sathi</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <style>
        .main { padding: 28px; }

        .form-card {
            background: #FFFFFF;
            border-radius: 14px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
            padding: 32px 36px;
            max-width: 720px;
        }

        .form-card .section-label {
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: #6B7280;
            margin-bottom: 16px;
            padding-bottom: 10px;
            border-bottom: 2px solid #F3F4F6;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 6px 24px;
        }

        .form-group-full { grid-column: 1 / -1; }

        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 6px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 6px;
        }

        .form-group input,
        .form-group select {
            padding: 10px 13px;
            border: 1.5px solid #E5E7EB;
            border-radius: 8px;
            font-size: 14px;
            color: #1E1E1E;
            background: #F9FAFB;
            margin: 0;
            transition: border-color 0.2s, background 0.2s;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #1F7A5C;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(31,122,92,0.10);
        }

        /* Password wrapper */
        .password-wrapper { position: relative; }
        .password-wrapper input { padding-right: 44px; }

        .toggle-pw {
            position: absolute;
            right: 0; top: 0; bottom: 0;
            width: 42px;
            background: none;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6B7280;
            padding: 0;
            width: auto;
            padding: 0 12px;
            border-radius: 0 8px 8px 0;
            transition: color 0.15s;
        }

        .toggle-pw:hover { color: #1F7A5C; background: none; }

        .toggle-pw svg {
            width: 17px; height: 17px;
            stroke: currentColor; fill: none;
            stroke-width: 2; stroke-linecap: round; stroke-linejoin: round;
            pointer-events: none;
        }

        /* File upload */
        .file-upload-wrapper { position: relative; }
        .file-upload-wrapper input[type="file"] {
            position: absolute; inset: 0;
            opacity: 0; cursor: pointer;
            width: 100%; height: 100%; z-index: 2;
        }

        .file-upload-btn {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 13px;
            background: #F9FAFB;
            border: 1.5px dashed #D1D5DB;
            border-radius: 8px;
            cursor: pointer;
            transition: border-color 0.2s, background 0.2s;
        }

        .file-upload-btn:hover { border-color: #1F7A5C; background: #fff; }

        .file-upload-btn svg {
            width: 16px; height: 16px;
            stroke: #1F7A5C; fill: none;
            stroke-width: 2; stroke-linecap: round; stroke-linejoin: round;
            flex-shrink: 0;
        }

        .file-upload-btn span { font-size: 14px; color: #6B7280; }
        .file-name { font-size: 12px; color: #1F7A5C; margin-top: 5px; min-height: 16px; }

        /* Alert */
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .alert-error {
            background: #FEE2E2;
            color: #991B1B;
            border-left: 4px solid #EF4444;
        }

        /* Form actions */
        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 24px;
            padding-top: 20px;
            border-top: 2px solid #F3F4F6;
        }

        .btn-create {
            padding: 11px 28px;
            background: #1F7A5C;
            color: #E8F5F0;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.15s;
        }

        .btn-create:hover { background: #145A42; }

        .btn-cancel {
            padding: 11px 24px;
            background: #F3F4F6;
            color: #374151;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: background 0.15s;
        }

        .btn-cancel:hover { background: #E5E7EB; }

        /* Topbar extras */
        .topbar-right {
            display: flex; align-items: center; gap: 12px;
        }
        .topbar-avatar {
            width: 38px; height: 38px; border-radius: 50%;
            background: #1F7A5C; color: #E8F5F0;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 15px;
        }
        .topbar-greeting { display: flex; flex-direction: column; align-items: flex-end; }
        .topbar-greeting span:first-child { font-size: 14px; font-weight: 600; color: #1E1E1E; }
        .topbar-greeting span:last-child  { font-size: 12px; color: #6B7280; }
    </style>
</head>
<body>

<div class="dashboard">

    <!-- Sidebar -->
    <% request.setAttribute("activePage","users"); %>
    <jsp:include page="/admin/includes/sidebar.jsp"/>

    <!-- Main -->
    <main class="main">
        <% request.setAttribute("pageTitle","Create New User");
           request.setAttribute("pageSubtitle","Add a new user account to the system."); %>
        <jsp:include page="/admin/includes/topbar.jsp"/>

        <div class="form-card">

            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("errorMessage") %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/admin-create-user" method="post" enctype="multipart/form-data">

                <p class="section-label">Personal Information</p>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="fullName">Full Name <span style="color:#EF4444;">*</span></label>
                        <input type="text" id="fullName" name="fullName" placeholder="John Doe" required>
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone Number <span style="color:#EF4444;">*</span></label>
                        <input type="text" id="phone" name="phone" placeholder="10-digit number" required>
                    </div>

                    <div class="form-group form-group-full">
                        <label for="email">Email Address <span style="color:#EF4444;">*</span></label>
                        <input type="email" id="email" name="email" placeholder="user@example.com" required>
                    </div>

                    <div class="form-group form-group-full">
                        <label for="address">Address</label>
                        <input type="text" id="address" name="address" placeholder="City / area">
                    </div>

                    <div class="form-group">
                        <label for="profileImage">Profile Image <span style="color:#6B7280; font-weight:400;">(optional)</span></label>
                        <div class="file-upload-wrapper">
                            <input type="file" id="profileImage" name="profileImage"
                                   accept="image/png,image/jpeg,image/jpg"
                                   onchange="updateFileName(this,'imgName')">
                            <div class="file-upload-btn">
                                <svg viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                                <span>Upload photo</span>
                            </div>
                        </div>
                        <div class="file-name" id="imgName"></div>
                    </div>
                </div>

                <p class="section-label" style="margin-top:24px;">Account Settings</p>

                <div class="form-grid">
                    <div class="form-group">
                        <label for="role">Role <span style="color:#EF4444;">*</span></label>
                        <select id="role" name="role" required>
                            <option value="">-- Select role --</option>
                            <option value="ADMIN">Admin</option>
                            <option value="DONOR">Donor</option>
                            <option value="RECEIVER">Receiver</option>
                            <option value="VOLUNTEER">Volunteer</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="status">Status <span style="color:#EF4444;">*</span></label>
                        <select id="status" name="status" required>
                            <option value="ACTIVE">Active</option>
                            <option value="PENDING">Pending</option>
                            <option value="BLOCKED">Blocked</option>
                            <option value="REJECTED">Rejected</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="password">Password <span style="color:#EF4444;">*</span></label>
                        <div class="password-wrapper">
                            <input type="password" id="password" name="password"
                                   placeholder="Min. 6 characters" required>
                            <button type="button" class="toggle-pw"
                                    onclick="togglePw('password','ps1','ph1')">
                                <svg id="ps1" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                <svg id="ph1" viewBox="0 0 24 24" style="display:none;"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/><path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
                            </button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password <span style="color:#EF4444;">*</span></label>
                        <div class="password-wrapper">
                            <input type="password" id="confirmPassword" name="confirmPassword"
                                   placeholder="Repeat password" required>
                            <button type="button" class="toggle-pw"
                                    onclick="togglePw('confirmPassword','ps2','ph2')">
                                <svg id="ps2" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                <svg id="ph2" viewBox="0 0 24 24" style="display:none;"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/><path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-create">Create User</button>
                    <a href="<%= request.getContextPath() %>/view-users" class="btn-cancel">Cancel</a>
                </div>

            </form>
        </div>

    </main>
</div>

<script>
    function togglePw(fieldId, showId, hideId) {
        const input = document.getElementById(fieldId);
        const show  = document.getElementById(showId);
        const hide  = document.getElementById(hideId);
        if (input.type === 'password') {
            input.type = 'text';
            show.style.display = 'none';
            hide.style.display = 'block';
        } else {
            input.type = 'password';
            show.style.display = 'block';
            hide.style.display = 'none';
        }
    }

    function updateFileName(input, displayId) {
        const el = document.getElementById(displayId);
        el.textContent = input.files.length > 0 ? input.files[0].name : '';
    }
</script>

</body>
</html>
