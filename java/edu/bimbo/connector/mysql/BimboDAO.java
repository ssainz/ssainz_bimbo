package edu.bimbo.connector.mysql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class BimboDAO {

	private Connection conn = null;
	public static BimboDAO instance = new BimboDAO();
	
	private BimboDAO(){
		conn = null;
		 try {
		     conn =
		        DriverManager.getConnection("jdbc:mysql://localhost/bimbo?" +
		                                    "user=root&password=&rewriteBatchedStatements=true&allowMultiQueries=true");

		     
		 } catch (SQLException ex) {
		     // handle any errors
		     System.out.println("SQLException: " + ex.getMessage());
		     System.out.println("SQLState: " + ex.getSQLState());
		     System.out.println("VendorError: " + ex.getErrorCode());
		 }
	}
	
	public void execute (String cmd){
		if(conn != null && cmd != null){
			Statement stmt;
			try {
				stmt = conn.createStatement();
				stmt.execute(cmd);
				stmt.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public void close(){
		if(conn != null){
			try {
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	protected void finalize( ) throws Throwable{
		if(conn != null){
			conn.close();
		}
	}
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

	public List<String> getIndustries(String query) {
		List<String> list = null;
		if(conn != null && query != null){
			Statement stmt;
			try {
				stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery(query);
				if(rs != null){
					list = new ArrayList<>();
					while(rs.next()){
						list.add(rs.getString(0));
					}
					
				}
				stmt.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return list;
	}
	
	public List<Integer>[] getLookup(String query) {
		//String query = "select id, producto_old from LU_Producto;";
		List<Integer> id = null;
		List<Integer> oldId = null;
		if(conn != null && query != null){
			Statement stmt;
			try {
				stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery(query);
				if(rs != null){
					id = new ArrayList<>();
					oldId = new ArrayList<>();
					while(rs.next()){
						id.add(rs.getInt(1));
						oldId.add(rs.getInt(2));
					}
					
				}
				stmt.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		List<Integer>[] out = new List[2];
		out[0] = id;
		out[1] = oldId;
		return out;
	}

}
