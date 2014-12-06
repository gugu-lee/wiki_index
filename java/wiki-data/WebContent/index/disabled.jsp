<%@ page language="java" contentType="text/html; charset=GB18030"
	pageEncoding="GB18030"%>
<%@page
	import="java.util.*,java.sql.*,javax.sql.*,com.mysql.jdbc.Driver, wiki.index.*"%>
<%!Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;

	private void connectDB() {
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager
					.getConnection("jdbc:mysql://localhost/netspider?"
							+ "user=root&password=1234");
		} catch (SQLException ex) {
			// handle any errors
			System.out.println("SQLException: " + ex.getMessage());
			System.out.println("SQLState: " + ex.getSQLState());
			System.out.println("VendorError: " + ex.getErrorCode());
		} catch (Exception e) {

		}
	}
	private int disableCatagory(String path)
	{
		int i=0;
		try {
			stmt = conn.createStatement();
			i = stmt.executeUpdate("update page_index set disabled=1 where path like '"+path+"-%'");

			
		} catch (SQLException ex) {
			// handle any errors
			System.out.println("SQLException: " + ex.getMessage());
			System.out.println("SQLState: " + ex.getSQLState());
			System.out.println("VendorError: " + ex.getErrorCode());
		} finally {
			// it is a good idea to release
			// resources in a finally{} block
			// in reverse-order of their creation
			// if they are no-longer needed

			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException sqlEx) {
				} // ignore

				rs = null;
			}

			if (stmt != null) {
				try {
					stmt.close();
				} catch (SQLException sqlEx) {
				} // ignore

				stmt = null;
			}
		}
		return i;
	}
	private void disConnectDB() {
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
			}
		}
	}%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB18030">
<title>Insert title here</title>
</head>
<body>
<%
connectDB() ;
String path = request.getParameter("path");
int i=disableCatagory(path);
disConnectDB();
%>
path:<%=path %>.<br>
已更新数据<%=i%>条。
</body>
</html>