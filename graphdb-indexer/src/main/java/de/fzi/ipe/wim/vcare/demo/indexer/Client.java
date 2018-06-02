package de.fzi.ipe.wim.vcare.demo.indexer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrQuery.ORDER;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.client.solrj.response.UpdateResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.apache.solr.common.SolrInputDocument;
import org.apache.solr.common.params.MapSolrParams;
import org.eclipse.rdf4j.model.Value;
import org.eclipse.rdf4j.query.BindingSet;
import org.eclipse.rdf4j.query.QueryLanguage;
import org.eclipse.rdf4j.query.TupleQuery;
import org.eclipse.rdf4j.query.TupleQueryResult;
import org.eclipse.rdf4j.repository.Repository;
import org.eclipse.rdf4j.repository.RepositoryConnection;
import org.eclipse.rdf4j.repository.sparql.SPARQLRepository;

public class Client {
	private SolrClient client;
	private final static String endpoint = "http://localhost:7200/repositories/vcare";
	private final static String query = "SELECT ?s ?p ?o WHERE {?s ?p ?o.}";
	private RepositoryConnection con;
	private Repository repo;

	public Client() {
		client = getSolrClient("http://localhost:8983/solr");
		repo = new SPARQLRepository(endpoint);
		repo.initialize();
		con = repo.getConnection();
	}

	private HttpSolrClient getSolrClient(String url) {
		HttpSolrClient hsc = new HttpSolrClient.Builder(url).build();
		return hsc;
	}

	public Map<String, Map<String, List<String>>> queryGraph() {
		Map<String, Map<String, List<String>>> values = new HashMap<String, Map<String, List<String>>>();
		TupleQuery tupleQuery = con.prepareTupleQuery(QueryLanguage.SPARQL, query);

		try (TupleQueryResult res = tupleQuery.evaluate()) {
			while (res.hasNext()) { // iterate over the result
				BindingSet bindingSet = res.next();
				Value s = bindingSet.getValue("s");
				Value p = bindingSet.getValue("p");
				Value o = bindingSet.getValue("o");
				String sub = s.stringValue().substring(s.stringValue().indexOf("#") + 1);
				String pred = p.stringValue().substring(p.stringValue().indexOf("#") + 1);
				String obj = o.stringValue().substring(o.stringValue().indexOf("#") + 1);
				System.out.println(s.stringValue() + " " + p.stringValue() + " " + o.stringValue());
				if (values.containsKey(sub)) {
					if (values.get(sub).containsKey(pred)) {
						values.get(sub).get(pred).add(obj);
					} else {
						List<String> objlist = new ArrayList<String>();
						objlist.add(obj);
						values.get(sub).put(pred, objlist);
					}
				} else {
					Map<String, List<String>> map = new HashMap<String, List<String>>();
					List<String> olist = new ArrayList<String>();
					olist.add(obj);
					map.put(pred, olist);
					values.put(sub, map);
				}
			}
		}
		return values;
	}

	public List<Document> search(int numResults, String sortField, String queryString, String core,
			List<String> fields) {
		List<Document> docs = new ArrayList<Document>();
		// final Map<String, String> queryParamMap = new HashMap<String,
		// String>();
		// queryParamMap.put("q", "*:*");
		// queryParamMap.put("fl", "id, name");
		// queryParamMap.put("sort", "id asc");
		SolrQuery query = new SolrQuery(queryString);
		for (String f : fields) {
			query.addField(f);
		}
		query.setSort(sortField, ORDER.asc);
		query.setRows(numResults);
		// MapSolrParams queryParams = new MapSolrParams(queryParamMap);

		QueryResponse response = null;
		try {
			response = client.query(core, query);
		} catch (SolrServerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		final SolrDocumentList documents = response.getResults();

		System.out.println("Found " + documents.getNumFound() + " documents");
		for (SolrDocument document : documents) {
			Document d = new Document();
			d.setId((String) document.getFirstValue("name"));
			d.setId((String) document.getFirstValue("id"));
			docs.add(d);
		}
		return docs;
	}

	public UpdateResponse indexDocument(String core, Map<String, Map<String, List<String>>> fields) {
		UpdateResponse updateResponse = null;
		for (Map.Entry<String, Map<String, List<String>>> entry : fields.entrySet()) {
			if (!entry.getKey().startsWith("node")) {
				final SolrInputDocument doc = new SolrInputDocument();
				doc.addField("doc", entry.getKey());
				for (Map.Entry<String, List<String>> keyval : entry.getValue().entrySet()) {
					if (!keyval.getKey().startsWith("node")) {
						for (String obj : keyval.getValue()) {
							if (!obj.startsWith("node"))
								doc.addField(keyval.getKey(), obj);
						}
					}

				}

				if (!doc.getFieldNames().isEmpty()) {
					try {
						client.add(core, doc);
					} catch (SolrServerException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
		}
		// Indexed documents must be committed
		try {
			updateResponse = client.commit(core);
		} catch (SolrServerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return updateResponse;
	}
}
