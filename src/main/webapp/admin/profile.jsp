<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.the_street.the_street.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User profileUser = (User) request.getAttribute("profileUser");
    String profileSuccessMsg = (String) session.getAttribute("profileSuccess");
    String profileErrorMsg   = (String) session.getAttribute("profileError");
    String pwSuccessMsg      = (String) session.getAttribute("pwSuccess");
    String pwErrorMsg        = (String) session.getAttribute("pwError");
    // Consume flash messages
    session.removeAttribute("profileSuccess");
    session.removeAttribute("profileError");
    session.removeAttribute("pwSuccess");
    session.removeAttribute("pwError");

    String memberSince = "";
    if (profileUser != null && profileUser.getCreatedAt() != null) {
        memberSince = new SimpleDateFormat("dd MMM yyyy").format(profileUser.getCreatedAt());
    }
    String avatarInitial = "A";
    if (profileUser != null && profileUser.getFullName() != null && !profileUser.getFullName().isEmpty()) {
        String[] nameParts = profileUser.getFullName().trim().split("\\s+");
        if (nameParts.length >= 2) {
            avatarInitial = String.valueOf(nameParts[0].charAt(0)).toUpperCase()
                          + String.valueOf(nameParts[nameParts.length - 1].charAt(0)).toUpperCase();
        } else {
            avatarInitial = String.valueOf(nameParts[0].charAt(0)).toUpperCase();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Settings – Sahayog Sathi</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <style>
        .main { padding: 28px; }

        /* ── Profile layout ── */
        .profile-layout {
            display: grid;
            grid-template-columns: 220px 1fr;
            gap: 24px;
            align-items: start;
        }

        /* ── Left: avatar card ── */
        .avatar-card {
            background: #FFFFFF;
            border-radius: 14px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
            padding: 28px 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 16px;
        }

        .avatar-circle {
            width: 96px;
            height: 96px;
            border-radius: 50%;
            background: #1F7A5C;
            color: #E8F5F0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            font-weight: 700;
            overflow: hidden;
            flex-shrink: 0;
        }

        .avatar-circle span {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            height: 100%;
            font-size: 30px;
            font-weight: 700;
            color: #E8F5F0;
        }

        .avatar-circle img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .avatar-name {
            font-size: 15px;
            font-weight: 700;
            color: #1E1E1E;
            text-align: center;
        }

        .avatar-role {
            font-size: 12px;
            color: #6B7280;
            text-align: center;
            margin-top: -10px;
        }

        .avatar-photo-form { width: 100%; }

        .file-upload-wrapper { position: relative; }
        .file-upload-wrapper input[type="file"] {
            position: absolute; inset: 0;
            opacity: 0; cursor: pointer;
            width: 100%; height: 100%; z-index: 2;
        }

        .file-upload-btn {
            display: flex; align-items: center; justify-content: center; gap: 8px;
            padding: 9px 12px;
            background: #F9FAFB;
            border: 1.5px dashed #D1D5DB;
            border-radius: 8px;
            cursor: pointer;
            transition: border-color 0.2s, background 0.2s;
        }

        .file-upload-btn:hover { border-color: #1F7A5C; background: #fff; }

        .file-upload-btn svg {
            width: 15px; height: 15px;
            stroke: #1F7A5C; fill: none;
            stroke-width: 2; stroke-linecap: round; stroke-linejoin: round;
            flex-shrink: 0;
        }

        .file-upload-btn span { font-size: 13px; color: #6B7280; }
        .file-name { font-size: 11px; color: #1F7A5C; margin-top: 5px; min-height: 14px; text-align: center; }

        .current-photo-path {
            font-size: 11px;
            color: #9CA3AF;
            word-break: break-all;
            text-align: center;
        }

        .btn-upload-photo {
            width: 100%;
            padding: 9px;
            background: #1F7A5C;
            color: #E8F5F0;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.15s;
            margin-top: 4px;
        }

        .btn-upload-photo:hover { background: #145A42; }

        .btn-remove-photo {
            width: 100%;
            padding: 9px;
            background: none;
            color: #DC2626;
            border: 1.5px solid #DC2626;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.15s, color 0.15s;
        }

        .btn-remove-photo:hover { background: #FEE2E2; }

        /* ── Right: form cards ── */
        .form-card {
            background: #FFFFFF;
            border-radius: 14px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
            padding: 28px 32px;
            margin-bottom: 20px;
        }

        .form-card:last-child { margin-bottom: 0; }

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

        .form-group input {
            padding: 10px 13px;
            border: 1.5px solid #E5E7EB;
            border-radius: 8px;
            font-size: 14px;
            color: #1E1E1E;
            background: #F9FAFB;
            margin: 0;
            transition: border-color 0.2s, background 0.2s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #1F7A5C;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(31,122,92,0.10);
        }

        .form-group input[readonly],
        .form-group input:disabled {
            background: #F3F4F6;
            color: #9CA3AF;
            cursor: not-allowed;
            border-color: #E5E7EB;
        }

        /* Password wrapper */
        .password-wrapper { position: relative; }
        .password-wrapper input { padding-right: 44px; }

        .toggle-pw {
            position: absolute;
            right: 0; top: 0; bottom: 0;
            background: none;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6B7280;
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

        /* Alert */
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 14px;
            margin-bottom: 18px;
        }

        .alert-error {
            background: #FEE2E2;
            color: #991B1B;
            border-left: 4px solid #EF4444;
        }

        .alert-success {
            background: #D1FAE5;
            color: #065F46;
            border-left: 4px solid #10B981;
        }

        /* Form actions */
        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 20px;
            padding-top: 18px;
            border-top: 2px solid #F3F4F6;
        }

        .btn-save {
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

        .btn-save:hover { background: #145A42; }

        /* Account info grid */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px 24px;
        }

        .info-item { display: flex; flex-direction: column; gap: 4px; }

        .info-item .info-label {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #9CA3AF;
        }

        .info-item .info-value {
            font-size: 14px;
            font-weight: 600;
            color: #1E1E1E;
        }

        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .badge-active   { background: #D1FAE5; color: #065F46; }
        .badge-pending  { background: #FEF3C7; color: #92400E; }
        .badge-blocked  { background: #FEE2E2; color: #991B1B; }
        .badge-rejected { background: #F3F4F6; color: #6B7280; }
        .badge-admin    { background: #EDE9FE; color: #5B21B6; }

        /* Topbar extras */
        .topbar-right {
            display: flex; align-items: center; gap: 12px;
        }
        .topbar-avatar {
            width: 38px; height: 38px; border-radius: 50%;
            background: #1F7A5C; color: #E8F5F0;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 15px;
            text-decoration: none;
        }
        .topbar-greeting { display: flex; flex-direction: column; align-items: flex-end; }
        .topbar-greeting span:first-child { font-size: 14px; font-weight: 600; color: #1E1E1E; }
        .topbar-greeting span:last-child  { font-size: 12px; color: #6B7280; }

        @media (max-width: 900px) {
            .profile-layout { grid-template-columns: 1fr; }
            .form-grid { grid-template-columns: 1fr; }
            .info-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<div class="dashboard">

    <!-- Sidebar -->
    <% request.setAttribute("activePage", "profile"); %>
    <jsp:include page="/admin/includes/sidebar.jsp"/>

    <!-- Main -->
    <main class="main">
        <% request.setAttribute("pageTitle", "Profile Settings");
           request.setAttribute("pageSubtitle", "Manage your account information and security."); %>
        <jsp:include page="/admin/includes/topbar.jsp"/>

        <% if (profileUser == null) { %>
        <div class="alert alert-error">Could not load profile data. Please try again.</div>
        <% } else { %>

        <div class="profile-layout">

            <!-- ── Left: Avatar + photo upload ── -->
            <div class="avatar-card">
                <div class="avatar-circle" id="avatarCircle">
                    <% if (profileUser.getProfileImage() != null && !profileUser.getProfileImage().isEmpty()) { %>
                    <img src="<%= request.getContextPath() %>/<%= profileUser.getProfileImage() %>"
                         alt="Profile photo"
                         onerror="this.style.display='none'; document.getElementById('avatarFallback').style.display='flex';">
                    <span id="avatarFallback" style="display:none;"><%= avatarInitial %></span>
                    <% } else { %>
                    <span><%= avatarInitial %></span>
                    <% } %>
                </div>

                <div class="avatar-name"><%= profileUser.getFullName() %></div>
                <div class="avatar-role"><%= profileUser.getRole() %></div>

                <form class="avatar-photo-form"
                      action="<%= request.getContextPath() %>/admin-profile"
                      method="post"
                      enctype="multipart/form-data">
                    <input type="hidden" name="action" value="updateProfile">
                    <%-- Hidden fields to keep personal info unchanged when only uploading photo --%>
                    <input type="hidden" name="fullName"  value="<%= profileUser.getFullName() %>">
                    <input type="hidden" name="phone"     value="<%= profileUser.getPhone() != null ? profileUser.getPhone() : "" %>">
                    <input type="hidden" name="address"   value="<%= profileUser.getAddress() != null ? profileUser.getAddress() : "" %>">
                    <input type="hidden" name="photoOnly" value="true">

                    <div class="file-upload-wrapper">
                        <input type="file" name="profileImage"
                               accept="image/png,image/jpeg,image/jpg"
                               onchange="updateFileName(this,'photoName')">
                        <div class="file-upload-btn">
                            <svg viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                            <span>Upload photo</span>
                        </div>
                    </div>
                    <div class="file-name" id="photoName"></div>

                    <button type="submit" class="btn-upload-photo">Save Photo</button>
                </form>

                <% if (profileUser.getProfileImage() != null && !profileUser.getProfileImage().isEmpty()) { %>
                <form action="<%= request.getContextPath() %>/admin-profile" method="post" style="width:100%;margin-top:8px;">
                    <input type="hidden" name="action" value="removePhoto">
                    <input type="hidden" name="fullName" value="<%= profileUser.getFullName() %>">
                    <input type="hidden" name="phone"    value="<%= profileUser.getPhone() != null ? profileUser.getPhone() : "" %>">
                    <input type="hidden" name="address"  value="<%= profileUser.getAddress() != null ? profileUser.getAddress() : "" %>">
                    <button type="submit" class="btn-remove-photo"
                            onclick="return confirm('Remove your profile picture?')">
                        Remove Photo
                    </button>
                </form>
                <% } %>
            </div>

            <!-- ── Right: forms ── -->
            <div>

                <!-- Personal Information -->
                <div class="form-card">
                    <% if (profileSuccessMsg != null) { %>
                    <div class="alert alert-success"><%= profileSuccessMsg %></div>
                    <% } %>
                    <% if (profileErrorMsg != null) { %>
                    <div class="alert alert-error"><%= profileErrorMsg %></div>
                    <% } %>

                    <p class="section-label">Personal Information</p>

                    <form action="<%= request.getContextPath() %>/admin-profile"
                          method="post"
                          enctype="multipart/form-data">
                        <input type="hidden" name="action" value="updateProfile">

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="fullName">Full Name <span style="color:#EF4444;">*</span></label>
                                <input type="text" id="fullName" name="fullName"
                                       value="<%= profileUser.getFullName() %>"
                                       placeholder="John Doe" required>
                            </div>

                            <div class="form-group">
                                <label for="email">Email Address</label>
                                <input type="email" id="email" name="email"
                                       value="<%= profileUser.getEmail() %>"
                                       readonly title="Email cannot be changed">
                            </div>

                            <div class="form-group">
                                <label for="phone">Phone Number <span style="color:#EF4444;">*</span></label>
                                <input type="text" id="phone" name="phone"
                                       value="<%= profileUser.getPhone() != null ? profileUser.getPhone() : "" %>"
                                       placeholder="10-digit number" required>
                            </div>

                            <div class="form-group">
                                <label for="address">Address</label>
                                <input type="text" id="address" name="address"
                                       value="<%= profileUser.getAddress() != null ? profileUser.getAddress() : "" %>"
                                       placeholder="City / area">
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn-save">Save Changes</button>
                        </div>
                    </form>
                </div>

                <!-- Change Password -->
                <div class="form-card">
                    <% if (pwSuccessMsg != null) { %>
                    <div class="alert alert-success"><%= pwSuccessMsg %></div>
                    <% } %>
                    <% if (pwErrorMsg != null) { %>
                    <div class="alert alert-error"><%= pwErrorMsg %></div>
                    <% } %>

                    <p class="section-label">Change Password</p>

                    <form action="<%= request.getContextPath() %>/admin-profile" method="post">
                        <input type="hidden" name="action" value="updatePassword">

                        <div class="form-grid">
                            <div class="form-group form-group-full">
                                <label for="currentPassword">Current Password <span style="color:#EF4444;">*</span></label>
                                <div class="password-wrapper">
                                    <input type="password" id="currentPassword" name="currentPassword"
                                           placeholder="Enter current password" required>
                                    <button type="button" class="toggle-pw"
                                            onclick="togglePw('currentPassword','cps','cph')">
                                        <svg id="cps" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                        <svg id="cph" viewBox="0 0 24 24" style="display:none;"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/><path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
                                    </button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="newPassword">New Password <span style="color:#EF4444;">*</span></label>
                                <div class="password-wrapper">
                                    <input type="password" id="newPassword" name="newPassword"
                                           placeholder="Min. 6 characters" required>
                                    <button type="button" class="toggle-pw"
                                            onclick="togglePw('newPassword','nps','nph')">
                                        <svg id="nps" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                        <svg id="nph" viewBox="0 0 24 24" style="display:none;"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/><path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
                                    </button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="confirmPassword">Confirm New Password <span style="color:#EF4444;">*</span></label>
                                <div class="password-wrapper">
                                    <input type="password" id="confirmPassword" name="confirmPassword"
                                           placeholder="Repeat new password" required>
                                    <button type="button" class="toggle-pw"
                                            onclick="togglePw('confirmPassword','fps','fph')">
                                        <svg id="fps" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                        <svg id="fph" viewBox="0 0 24 24" style="display:none;"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/><path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn-save">Update Password</button>
                        </div>
                    </form>
                </div>

                <!-- Account Info (read-only) -->
                <div class="form-card">
                    <p class="section-label">Account Info</p>
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">Role</span>
                            <%
                                String roleBadge = "badge-admin";
                                if ("DONOR".equals(profileUser.getRole()))     roleBadge = "badge-active";
                                else if ("RECEIVER".equals(profileUser.getRole())) roleBadge = "badge-pending";
                                else if ("VOLUNTEER".equals(profileUser.getRole())) roleBadge = "badge-blocked";
                            %>
                            <span class="info-value">
                                <span class="badge <%= roleBadge %>"><%= profileUser.getRole() %></span>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Status</span>
                            <%
                                String statusBadge = "badge-pending";
                                if ("ACTIVE".equals(profileUser.getStatus()))    statusBadge = "badge-active";
                                else if ("BLOCKED".equals(profileUser.getStatus()))  statusBadge = "badge-blocked";
                                else if ("REJECTED".equals(profileUser.getStatus())) statusBadge = "badge-rejected";
                            %>
                            <span class="info-value">
                                <span class="badge <%= statusBadge %>"><%= profileUser.getStatus() %></span>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Member Since</span>
                            <span class="info-value"><%= memberSince.isEmpty() ? "—" : memberSince %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">User ID</span>
                            <span class="info-value">#<%= profileUser.getUserId() %></span>
                        </div>
                    </div>
                </div>

            </div><!-- end right column -->
        </div><!-- end profile-layout -->

        <% } %>
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
