package de.letex.epub.check;

import java.io.File;

public class EpubCheckProfile {
	
	String name;
	String description;
	File xprocfile;
	
	
	public EpubCheckProfile(String name, String description, File xprocfile) {
		super();
		this.name = name;
		this.description = description;
		this.xprocfile = xprocfile;
	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public String getDescription() {
		return description;
	}


	public void setDescription(String description) {
		this.description = description;
	}


	public File getXprocfile() {
		return xprocfile;
	}


	public void setXprocfile(File xprocfile) {
		this.xprocfile = xprocfile;
	}
	
	
	

}
