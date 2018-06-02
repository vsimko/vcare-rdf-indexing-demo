package de.fzi.ipe.wim.vcare.demo.indexer;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.solr.client.solrj.response.UpdateResponse;

public class Indexer {
	public static void main(String[]args) {
		final Client client = new Client();
		Map<String, Map<String, List<String>>>properties = client.queryGraph();
		UpdateResponse resp = client.indexDocument("knowledgegraph", properties);
		System.out.println("Status-Code: "+resp.getStatus());
	}
	
	

}
