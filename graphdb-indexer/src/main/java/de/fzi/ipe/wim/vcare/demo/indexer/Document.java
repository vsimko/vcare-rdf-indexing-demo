package de.fzi.ipe.wim.vcare.demo.indexer;

import org.apache.solr.client.solrj.beans.Field;

public class Document {
	@Field private String id;
	@Field private String name;
	
	public Document() {}
	
	public Document(String id, String name) {
		this.id = id;
		this.name = name;
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	

}
