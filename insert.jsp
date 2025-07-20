<%@ page import="java.sql.*" %>
<%
String firstname = request.getParameter("firstname");
String lastname = request.getParameter("lastname");
String username = request.getParameter("username");
String password = request.getParameter("password");
String type = request.getParameter("type");

Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/cs336project", "root", "YES");

Statement st = con.createStatement();

// check if username already exists
ResultSet rs = st.executeQuery("SELECT * FROM user WHERE username='" + username + "'");

if (rs.next()) {
    // username exists
%>
    <p style="color:red;">Error: Username <%= username %> already exists. Please choose another one.</p>
    <a href="registerNewUser.jsp">Go back to Register</a>
<%
} else {
    // username is unique, insert the new user
    String sql = "INSERT INTO user (firstname, lastname, username, password, type) VALUES (?, ?, ?, ?, ?)";
    PreparedStatement ps = con.prepareStatement(sql);
    ps.setString(1, firstname);
    ps.setString(2, lastname);
    ps.setString(3, username);
    ps.setString(4, password);
    ps.setString(5, type);

    int rows = ps.executeUpdate();

    if (rows > 0) {
%>
        <p>Registration successful! Welcome, <%= username %>.</p>
        <a href="login.jsp">Go to Login</a>
<%
    } else {
%>
        <p style="color:red;">An error occurred while creating your account. Please try again.</p>
        <a href="registerNewUser.jsp">Go back to Register</a>
<%
    }
    ps.close();
}
st.close();
con.close();
%>
