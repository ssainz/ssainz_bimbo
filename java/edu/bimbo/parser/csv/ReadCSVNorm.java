package edu.bimbo.parser.csv;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.Formatter;
import java.util.Map;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import edu.bimbo.connector.mysql.BimboDAO;

public class ReadCSVNorm {

	static String testTable = "test";
	static String trainTable = "train_norm_5";
	static boolean redoTable = false;
	static String dropTable = "drop table "+trainTable+";";
	static String createTable = "create table "+trainTable+" (" +
								"id int primary key auto_increment," + 
								"Semana 	int," +
								"Agencia_ID	int," +
								"Canal_ID	int," +
								"Ruta_SAK	int," +
								"Cliente_ID	int," +
								"Producto_ID	int," +
								"Venta_uni_hoy	bigint(20)," +
								"Venta_hoy	double," +
								"Dev_uni_proxima	bigint(20)," +
								"Dev_proxima 	double," +
								"Demanda_uni_equil	bigint(20)," +
								"Venta_Adjusted	double " +
								");";
	static String createIndexes = 	"ALTER TABLE "+trainTable+" ADD INDEX prodIDX (Producto_ID); " +
									"ALTER TABLE "+trainTable+" ADD INDEX clienteIDX (Cliente_ID);" +
									"ALTER TABLE "+trainTable+" ADD INDEX semanaIDX (Semana);";
	//"/Users/sergiosainz/Projects/vtech/Data Analytics/term_project/bimbo/train.csv"
	public static void main(String[] args) throws IOException {
		
		 File csvData = new File(args[0]);
		 CSVParser parser = CSVParser.parse(csvData,Charset.defaultCharset(), CSVFormat.RFC4180);
		 int MAX = 1000000000;
		 //int start = 74180464;
		 //int start = 0;
		 int start = 71505999;
		 int queriesPerBatch = 2000;
		 int i = 0;
		 int buffer = queriesPerBatch;
		 BimboDAO conn = BimboDAO.instance;
		 
		 
		 //Create table again
		 if(redoTable){
			 System.out.println("Create table ["+ trainTable+"] ...");
			 conn.execute(dropTable);
			 conn.execute(createTable);
			 conn.execute(createIndexes);
			 System.out.println("Table ["+ trainTable+"] created...");
		 }

		 //LOAD trees with data
		 LookupTreeCreator treeCreator = new LookupTreeCreator();
		 System.out.println("Loading lookups...");
		 Map<Integer, Integer> agenciaTree = treeCreator.getMap("select id, Agencia_old from LU_Agencia order by Agencia_old ASC;");
		 Map<Integer, Integer> canalTree = treeCreator.getMap("select id, Canal_old from LU_Canal order by Canal_old ASC;");
		 Map<Integer, Integer> rutaTree = treeCreator.getMap("select id, Ruta_old from LU_Ruta order by Ruta_old ASC;");
		 Map<Integer, Integer> clienteTree = treeCreator.getMap("select id, Cliente_old from LU_Cliente order by Cliente_old ASC;");
		 Map<Integer, Integer> productoTree = treeCreator.getMap("select id, Producto_old from LU_Producto order by Producto_old ASC;");
		 System.out.println("Loading lookup trees complete.");
		 //READ CSV and SAVE INTO DB
		 StringBuilder statementsBuffer = new StringBuilder();
		 Formatter formatter = new Formatter(statementsBuffer);
		 for (CSVRecord csvRecord : parser) {
			 //System.out.println(csvRecord.get(0));
			 //System.out.println(csvRecord.toString());
			 if(i > start){
				 if(i % buffer == 0 && i > 0){
					 conn.execute(statementsBuffer.toString());
					 statementsBuffer.setLength(0);
					 System.out.print(".");
				 }
				 if(i > 0){
					 genTrainStatement(formatter, csvRecord, agenciaTree, canalTree, rutaTree, clienteTree, productoTree);
				 }
				 if(i > 0 && i % (buffer * 100) == 0){
					 if(i % 100000 == 0){
						 System.out.println(String.format("Count:[%,d]", i));
					 }else{
						 System.out.println("");
					 }
				 }
			 }
			 
			 i++;
			 if(i >= MAX) break;
		 }
		 if(statementsBuffer.length() > 0 ){
			 conn.execute(statementsBuffer.toString());
		 }
		 parser.close();
		 conn.close();
	}

	private static String genStatement(CSVRecord row) {
		
		String s = String.format("insert into %s values(%s, %s, %s, %s, %s, %s, %s);\n", testTable, 
				row.get(0), row.get(1), row.get(2), row.get(3), row.get(4), row.get(5), row.get(6));
		return s;
	}
	
	private static void genTrainStatement(Formatter formatter, CSVRecord row, Map<Integer, Integer> agenciaTree, Map<Integer, Integer> canalTree, Map<Integer, Integer> rutaTree, Map<Integer, Integer> clienteTree, Map<Integer, Integer> productoTree) {
		// 0 Semana 
		// 1 Agencia
		Integer agenciaNormId = agenciaTree.get(Integer.parseInt(row.get(1)));
		// 2 Canal
		Integer canalNormId = canalTree.get(Integer.parseInt(row.get(2)));
		// 3 Ruta
		Integer rutaNormId = rutaTree.get(Integer.parseInt(row.get(3)));
		// 4 Cliente
		Integer clienteNormId = clienteTree.get(Integer.parseInt(row.get(4)));
		// 5 Producto
		Integer productoNormId = productoTree.get(Integer.parseInt(row.get(5)));
		// 7 Venta_hoy 
		Double venta_hoy = Double.parseDouble(row.get(7));
		// 9 Dev_proxima
		Double dev_proxima = Double.parseDouble(row.get(9));
		formatter.format("insert into %s (Semana, Agencia_ID, Canal_ID, Ruta_SAK, Cliente_ID, Producto_ID, Venta_uni_hoy, Venta_hoy, Dev_uni_proxima, Dev_proxima, Demanda_uni_equil, Venta_Adjusted) values(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %.3f);\n", 
				trainTable, 
				row.get(0), agenciaNormId.toString(), canalNormId.toString(), rutaNormId.toString(), clienteNormId.toString(), productoNormId.toString(), 
				row.get(6), row.get(7), row.get(8), row.get(9), row.get(10), venta_hoy - dev_proxima);
	}

}
