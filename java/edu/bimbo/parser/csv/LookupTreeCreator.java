package edu.bimbo.parser.csv;

import java.util.Formatter;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import edu.bimbo.connector.mysql.BimboDAO;

public class LookupTreeCreator {

	public Map<Integer, Integer> getMap(String query){
		BimboDAO dao = BimboDAO.instance;
		List<Integer>[] out = dao.getLookup(query);
		List<Integer> id = out[0];
		List<Integer> oldId = out[1];
		
		Map<Integer, Integer> tree = new TreeMap<>();
		int j = 0;
		for(Integer i : id){
			tree.put(oldId.get(j), i);
			j++;
		}
		return tree;
	}
}
