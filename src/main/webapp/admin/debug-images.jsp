<%@ page import="java.util.List" %>
<%@ page import="com.the_street.the_street.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Debug - Profile Images</title>
  <style>
    body { font-family: Arial; padding: 20px; background: #f4f7f6; }
    .debug-box { background: white; padding: 20px; margin: 10px 0; border-radius: 8px; }
    .debug-box h3 { color: #1f4d3a; margin-top: 0; }
    .debug-info { background: #f0f0f0; padding: 10px; border-radius: 4px; margin: 5px 0; }
    .test-img { width: 100px; height: 100px; border: 2px solid #ccc; margin: 10px 0; }
  </style>
</head>
<body>
<h1>Profile Image Debug Page</h1>
<p><a href="<%= request.getContextPath() %>/view-users">← Back to Manage Users</a></p>

<%
  List<User> users = (List<User>) request.getAttribute("users");

  if (users == null) {
%>
<div class="debug-box">
  <h3>⚠️ No users data found</h3>
  <p>Please access this page via: <code>/view-users</code> first, then navigate here.</p>
  <p>Or create a servlet that loads users and forwards to this page.</p>
</div>
<%
} else {
  for (User u : users) {
    String profileImage = u.getProfileImage();
    boolean hasImage = (profileImage != null && !profileImage.trim().isEmpty());
%>
<div class="debug-box">
  <h3>User ID: <%= u.getUserId() %> - <%= u.getFullName() %></h3>

  <div class="debug-info">
    <strong>Profile Image Path (from DB):</strong><br>
    <%= hasImage ? profileImage : "<em>NULL or EMPTY</em>" %>
  </div>

  <div class="debug-info">
    <strong>Context Path:</strong> <%= request.getContextPath() %>
  </div>

  <div class="debug-info">
    <strong>Full URL that will be used:</strong><br>
    <%= hasImage ? request.getContextPath() + "/" + profileImage : "N/A" %>
  </div>

  <% if (hasImage) { %>
  <div class="debug-info">
    <strong>Image Test:</strong><br>
    <img src="<%= request.getContextPath() %>/<%= profileImage %>"
         class="test-img"
         onerror="this.style.border='3px solid red'; this.alt='❌ IMAGE FAILED TO LOAD';">
    <br>
    <small>If you see a broken image icon or red border, the file doesn't exist at that path.</small>
  </div>
  <% } else { %>
  <div class="debug-info">
    <strong>No image uploaded for this user.</strong>
  </div>
  <% } %>
</div>
<%
    }
  }
%>

<div class="debug-box">
  <h3>📋 Troubleshooting Steps:</h3>
  <ol>
    <li><strong>Check database:</strong> Does the <code>profile_image</code> column have a value like <code>uploads/1234567890_photo.jpg</code>?</li>
    <li><strong>Check file system:</strong> Does the file exist in your deployment folder at <code>webapp/uploads/</code>?</li>
    <li><strong>Check permissions:</strong> Can the web server read files from the uploads folder?</li>
    <li><strong>Check context path:</strong> Is your app deployed at root (<code>/</code>) or a sub-path (like <code>/the_street</code>)?</li>
  </ol>
</div>

</body>
</html>
