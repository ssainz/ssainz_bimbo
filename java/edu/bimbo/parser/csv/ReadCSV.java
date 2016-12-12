package edu.bimbo.parser.csv;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.Formatter;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import edu.bimbo.connector.mysql.BimboDAO;

public class ReadCSV {

	static String testTable = "test";
	static String trainTable = "trainv2";
	public static void main(String[] args) throws IOException {
		 File csvData = new File(args[0]);
		 CSVParser parser = CSVParser.parse(csvData,Charset.defaultCharset(), CSVFormat.RFC4180);
		 int MAX = 1000000000;
		 int queriesPerBatch = 2000;
		 int i = 0;
		 int buffer = queriesPerBatch;
		 BimboDAO conn = BimboDAO.instance;
		 StringBuilder statementsBuffer = new StringBuilder();
		 Formatter formatter = new Formatter(statementsBuffer);
		 for (CSVRecord csvRecord : parser) {
			 //System.out.println(csvRecord.get(0));
			 //System.out.println(csvRecord.toString());
			 if(i % buffer == 0 && i > 0){
				 conn.execute(statementsBuffer.toString());
				 statementsBuffer.setLength(0);
				 System.out.print(".");
			 }
			 if(i > 0){
				 genTrainStatement(formatter, csvRecord);
			 }
			 if(i > 0 && i % (buffer * 100) == 0){
				 System.out.println("");
			 }
			 i++;
			 //if(i >= MAX) break;
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
	
	private static void genTrainStatement(Formatter formatter, CSVRecord row) {
		formatter.format("insert into %s values(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);\n", trainTable, 
				row.get(0), row.get(1), row.get(2), row.get(3), row.get(4), row.get(5), 
				row.get(6), row.get(7), row.get(8), row.get(9), row.get(10));
	}

}
