<%@page import="java.net.URLDecoder"%>
<%@page import="java.sql.Connection"%>
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
			conn = DriverManager.getConnection("jdbc:mysql://localhost/netspider?"
					+ "user=root&password=1234");
		} catch (SQLException ex) {
			// handle any errors
			System.out.println("SQLException: " + ex.getMessage());
			System.out.println("SQLState: " + ex.getSQLState());
			System.out.println("VendorError: " + ex.getErrorCode());
		} catch(Exception e)
		{
			
		}
	}

	private void disConnectDB() {
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
			}
		}
	}

	private void output(Hashtable parentHt, int parentId,
			JspWriter out) {
		Hashtable ht;
		ArrayDeque list = new ArrayDeque();

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery("SELECT * from page_index where parent_Id="
					+ parentId+" and disabled=0");

			while (rs.next()) {
				ht = new Hashtable();
				ht.put("index_id", rs.getInt("index_id"));
				ht.put("title", rs.getString("title"));
				ht.put("parent_id", rs.getInt("parent_id"));
				ht.put("sub_catagory_count", rs.getInt("sub_category_count"));
				ht.put("path", rs.getString("path"));
				ht.put("rel_id", rs.getInt("rel_id"));
				list.push(ht);
			}
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
		if (parentHt != null){
			
			try{
				System.out.println(URLDecoder.decode((String)parentHt.get("title"),"utf-8"));
			if (list.isEmpty()) {
				out.println("<li><a href=\"./\">" + URLDecoder.decode((String)parentHt.get("title"),"utf-8")
						+ "</a></li>");
				return;
			}
			out.println("<li><input type=\"checkbox\" checked=\"checked\" id=\"item-"
					+ parentHt.get("index_id")
					+ "\" /><label for=\"item-"
					+ parentHt.get("index_id")
					+ "\">"
					+  URLDecoder.decode((String)parentHt.get("title"),"utf-8")
					+ "&nbsp;<a href=\"disabled.jsp?path="+parentHt.get("path")+"\" target=\"_blank\">½ûÓÃ</a></label>");
			out.println("<ul>");
			}catch(Exception e)
			{}
		}
		Hashtable curHt;
		boolean isEmpty=true;
		if (list.size()>0){
			isEmpty=false;
		}
		while (list.size()>0){
			curHt=(Hashtable)list.pop();
			output(curHt,(int)curHt.get("index_id"),out);
		}
		if (!isEmpty){
		try{
			out.println("</ul>\n</li>");
			}catch(Exception e){}
		}
	}
	%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB18030">
<title>Insert title here</title>
<link rel="stylesheet" href="tree.css" />

</head>

<body>
<div class="css-treeview">

<ul>
	<%
		connectDB();
	output(null,0,out);
		disConnectDB();
	%>
</ul>
</div>

</body>
</html>