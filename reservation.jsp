<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Get reservation details from the schedule selected
    String transitLineName = request.getParameter("transitLineName");
    String trainID = request.getParameter("trainID");
    String originDatetime = request.getParameter("originDatetime");
    String endDatetime = request.getParameter("endDatetime");
    String totalFare = request.getParameter("TotalFare");

    // Assume user is logged in with session attribute "username" and "email"
    String username = (String) session.getAttribute("user");
    String email = (String) session.getAttribute("email");
    if (username == null && email == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<head><title>Make Reservation</title></head>
<body>
    <h2>Reservation for Line: <%= transitLineName %> (Train <%= trainID %>)</h2>
    <form action="processReservation.jsp" method="post">
        <input type="hidden" name="transitLineName" value="<%= transitLineName %>">
        <input type="hidden" name="trainID" value="<%= trainID %>">
        <input type="hidden" name="originDatetime" value="<%= originDatetime %>">
        <input type="hidden" name="endDatetime" value="<%= endDatetime %>">
        <input type="hidden" name="TotalFare" value="<%= totalFare %>">

        Passenger Type:
        <select name="type" required>
            <option value="adult">Adult (full price)</option>
            <option value="child">Child (50% off)</option>
            <option value="senior">Senior (30% off)</option>
            <option value="disabled">Disabled (30% off)</option>
        </select><br>
        <input type="submit" value="Confirm Reservation">
    </form>
</body>
</html>
