<%-- 
    Document   : index
    Created on : 15.12.2014, 13:52:36
    Author     : cmu
--%>

<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%!public class Kunde {

        String url = "jdbc:hsqldb:file:F:\\netbeans\\hsqlTestDB";
        String user = "hsqldb";
        String password = "hsqldb";

        Connection connection = null;
        PreparedStatement selectKunden = null;
        ResultSet resultSet = null;

        public Kunde() {

            try {
                Class.forName("org.hsqldb.jdbcDriver");
                connection = DriverManager.getConnection(url, user, password);

                selectKunden = connection
                        .prepareStatement("SELECT * FROM Lieferant");

            } catch (SQLException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException x) {
                x.printStackTrace();
            }
        }

        public ResultSet getKunden(String suchWert, String suchWert2) {

            try {

                if (suchWert == null) {
                    suchWert = "";
                }
                if (suchWert2 == null) {
                    suchWert2 = "";
                }

                selectKunden = connection
                        .prepareStatement("SELECT * FROM Lieferant WHERE lf_ID LIKE '%"
                                + suchWert
                                + "%' AND Firma LIKE '%"
                                + suchWert2
                                + "%'");

                resultSet = selectKunden.executeQuery();

            } catch (SQLException e) {
                e.printStackTrace();
            }

            return resultSet;
        }

    }%>
<%
    Kunde kunde = new Kunde();

    ResultSet kunden = kunde.getKunden(request
            .getParameter("TabellenFilter"), request.getParameter("TabellenFilter2"));
    ResultSetMetaData rsmd = null;

    rsmd = kunden.getMetaData();

    int numberOfColumns = 0;
    numberOfColumns = rsmd.getColumnCount();
%>

<div id="content-container">
    <nav>
        <ul>
            <li class="title"><a id="1" href="#1"><span>Home</span> </a> <!-- the reason we use #1 is so that it will be the first child -->
                <ul>
                    <li><a href="#">Home</a></li>
                    <li><a href="https://www.google.de/?gws_rd=ssl">Google</a></li>
                </ul>
            </li>
            <li class="title"><a id="2" href="#2"><span>Informationen</span>
                </a>
                <ul>
                    <li><a href="#">Info</a></li>
                    <li><a href="XML.jsp">XML-Informationen</a></li>
                </ul>
            <li class="bottom"><ul></ul></li>
            </li>
        </ul>
    </nav>
    <div id="content-container2">
        <div id="content-container3">
            <div id="content">
                <h2>Ausgabe der Lieferanten- und Produktdatenbank</h2>
                <FORM ACTION="index.jsp" METHOD="POST">
                    Filter LF_ID / Firma:
                    <INPUT TYPE="TEXT" NAME="TabellenFilter">
                    Filter Firma: <input type="text" name="TabellenFilter2">
                    <BR>
                    <INPUT TYPE="SUBMIT" value="Suche...">
                </FORM>
                <br>
                <table border="1">

                    <tr>
                        <%
                            try {
                                for (int i = 1; i <= numberOfColumns; i++) {
                                    // Spalte überspringen, wenn i = ID Spalte.
                                    if ("lf_ID".equalsIgnoreCase(rsmd.getColumnLabel(i)) || "Pass".equalsIgnoreCase(rsmd.getColumnLabel(i))) {
                                        i++;
                                    }
                                    if (i > numberOfColumns ) {
                                        break;
                                    }

                        %>
                        <th><%=rsmd.getColumnLabel(i)%></th>
                            <%
                                }
                            %>
                    </tr>
                    <%
                        while (kunden.next()) {
                    %>


                    <%
                        String backgroundColor;

                        if (kunden.getInt("Pass") == 0) {
                            backgroundColor = "#00FF00";
                        } else {
                            backgroundColor = "#FF0000";
                        }
                    %>
                    <tr bgcolor="<%=backgroundColor%>">
                        <%
                            for (int i = 1; i <= numberOfColumns; i++) {
                                // Spalte überspringen, wenn i = ID Spalte.
                                if ("lf_ID".equalsIgnoreCase(rsmd.getColumnLabel(i)) || "Pass".equalsIgnoreCase(rsmd.getColumnLabel(i))) {
                                    i++;
                                }
                                if (i > numberOfColumns ) {
                                        break;
                                    }

                                if (i != numberOfColumns) {
                        %>



                        <td><%=kunden.getString(i)%></td>


                        <%
                        } else {
                        %>
                        <td><a href="XML.jsp?xml=<%=kunden.getString("lf_ID")%>">Detailed
                                Logfile</a>
                        </td>
                    </tr>

                    <%
                                    }
                                }
                            }
                        } catch (SQLException e) {

                        }
                    %>
                </table>
            </div>
        </div>
    </div>
    <div id="footer-container">
        <div id="footer">Copyright © IBM Deutschland Research &
            Development GmbH, 2014</div>
    </div>
</div>
