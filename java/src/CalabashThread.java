import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;

import net.sf.saxon.s9api.SaxonApiException;


public class CalabashThread extends Thread {

	public CalabashThread() {
		super();
		// TODO Auto-generated constructor stub
	}

	public CalabashThread(String name) {
		super(name);
		// TODO Auto-generated constructor stub
	}


	public void run(File pathToEpub) {
		com.xmlcalabash.drivers.Main calabash = new com.xmlcalabash.drivers.Main();
		URI uritoepub = pathToEpub.toURI();
		String[] args = {"-E org.apache.xml.resolver.tools.CatalogResolver", 
				"-U org.apache.xml.resolver.tools.CatalogResolver", "-o", "result=report.html" ,"xproc/kindle.xpl" , "epubdir=" + uritoepub.getRawPath()};
		System.setProperty("file.encoding", "UTF8");
		System.setProperty("xml.catalog.files", "resolver/catalog.xml");
		System.setProperty("xml.catalog.staticCatalog", "1");
		System.setProperty("xml.catalog.verbosity", "9");
		try {
			System.out.println("Start Calabash");
			calabash.run(args);
			System.out.println("End Calabash");
		} catch (SaxonApiException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			e.printStackTrace();
		}
	}
}
