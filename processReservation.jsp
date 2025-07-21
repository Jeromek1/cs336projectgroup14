<%@ page import="java.sql.*" %>
<%
    String transitLineName = request.getParameter("transitLineName");
    String trainID = request.getParameter("trainID");
    String originDatetime = request.getParameter("originDatetime");
    String endDatetime = request.getParameter("endDatetime");
    float totalFare = Float.parseFloat(request.getParameter("TotalFare"));


    String username = (String) session.getAttribute("user");
    String email = "NULL";
    String type = "NULL";

    float finalFare=100;
    // Calculate discount
    if (type != null) { // This condition will always be true
    switch (type.toLowerCase()) {
        case "child":
            finalFare = 0.75f * totalFare;
            break;
        case "senior":
            finalFare = 0.65f * totalFare;
            break;
        case "disabled":
            finalFare = 0.5f * totalFare;
            break;
        default:
            finalFare = totalFare;
            break;
    }
}

    String dbURL = "jdbc:mysql://localhost:3306/cs336project";
    String dbUser = "root";
    String dbPass = "YES";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        PreparedStatement ps = conn.prepareStatement(
                "SELECT email FROM Customers WHERE username = ?");
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                email = rs.getString("email");
                
            }
            PreparedStatement ps1 = conn.prepareStatement(
                    "SELECT type FROM Customers WHERE username = ?");
                ps1.setString(1, username);
                ResultSet rs2 = ps1.executeQuery();
                if (rs2.next()) {
                    type = rs2.getString("type");
                }
       
        // Insert new reservation
        String insertSQL =
          "INSERT INTO Reservation (date, username, email, Cost, type) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement pst = conn.prepareStatement(insertSQL, Statement.RETURN_GENERATED_KEYS);
        pst.setDate(1, java.sql.Date.valueOf(originDatetime.substring(0,10)));
        pst.setString(2, username);
        pst.setString(3, email);
        pst.setFloat(4, finalFare);
        pst.setString(5, type);
        pst.executeUpdate();

        // Get generated reservation number
        int affectedRows = ps.executeUpdate();

    int reservationNum = -1;

    if (affectedRows > 0) {
        ResultSet rs1 = ps.getGeneratedKeys();
        if (rs1.next()) {
            reservationNum = rs1.getInt(1);  //
        }
        rs1.close();
    }
        

        // Link reservation to train/stop/etc. (here: just link to the train and line for simplicity)
        String includesSQL =
          "INSERT INTO reservationStops (ReservationNumber, TrainID, transitLineName) VALUES (?, ?, ?)";
        PreparedStatement inc = conn.prepareStatement(includesSQL);
        inc.setInt(1, reservationNum);
        inc.setInt(2, Integer.parseInt(trainID));
        inc.setString(3, transitLineName);
        inc.executeUpdate();

        pst.close(); inc.close(); conn.close();
%>
<html>
<head><title>Reservation Success</title></head>
<body>
    <h2>Reservation Successful!</h2>
    <p>Your reservation number: <%= reservationNum %></p>
    <a href="customerReservations.jsp">View Reservations</a>
</body>
</html>
<%
    } catch(Exception e) {
        out.println("Reservation error: " + e.getMessage());
    }
%>
