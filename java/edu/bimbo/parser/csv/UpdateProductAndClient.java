package edu.bimbo.parser.csv;

import java.util.Formatter;
import java.util.List;

import edu.bimbo.connector.mysql.BimboDAO;

public class UpdateProductAndClient {
	
	

	public static void main(String[] args) {
		BimboDAO dao = BimboDAO.instance;
		List<Integer>[] out = dao.getLookup("select id, producto_old from LU_Producto order by producto_old ASC;");
		List<Integer> id = out[0];
		List<Integer> oldId = out[1];
		int j = 0;
		double totalCount = id.size();
		double progress = j / totalCount;
		
		StringBuffer sb = new StringBuffer();
		Formatter formatter = new Formatter(sb);
		for(Integer i : id){
			System.out.print(String.format("[%.6f].", progress));
			if(j % 101 == 0){
				System.out.println("");
			}
			sb.setLength(0);
			formatter.format("update train_norm_3 set Producto_ID = %d where Producto_ID = %d", i, oldId.get(j));
			dao.execute(sb.toString());
			j++;
			progress = j/totalCount;
		}

	}

}
