<%@ page import="java.sql.*" %>
<%
    // Get form data
    String firstname = request.getParameter("firstname");
    String lastname = request.getParameter("lastname");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String type = request.getParameter("type");

    // DB connection info
    String dbURL = "jdbc:mysql://localhost:3306/trainsystem";  // change DB name if needed
    String dbUser = "root";  // change to your DB username
    String dbPass = "password";  // change to your DB password

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // Check if username already exists
        String checkQuery = "SELECT username FROM user WHERE username = ?";
        ps = conn.prepareStatement(checkQuery);
        ps.setString(1, username);
        rs = ps.executeQuery();

        if (rs.next()) {
            // Username already exists
            request.setAttribute("errorMessage", "Username already exists. Please choose another.");
            request.getRequestDispatcher("registerNewUser.jsp").forward(request, response);
        } else {
            // Insert new user
            String insertQuery = "INSERT INTO user (firstname, lastname, username, password, type) VALUES (?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(insertQuery);
            ps.setString(1, firstname);
            ps.setString(2, lastname);
            ps.setString(3, username);
            ps.setString(4, password);
            ps.setString(5, type);

            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
                response.sendRedirect("success.jsp");
            } else {
                out.println("Error: Could not insert user.");
            }
        }
    } catch (Exception e) {
        e.printStackTrace(out);
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
