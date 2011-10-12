package de.letex.epub.check;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLClassLoader;
import java.sql.Array;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import net.sf.saxon.s9api.SaxonApiException;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.TableColumn;
import org.eclipse.swt.widgets.TableItem;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.widgets.Canvas;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.layout.*;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.FileDialog;
import org.eclipse.swt.browser.Browser;
import java.awt.Desktop;
import java.net.URI;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseListener;
import org.eclipse.swt.events.MouseTrackListener;
import org.eclipse.swt.events.PaintEvent;
import org.eclipse.swt.events.PaintListener;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.graphics.Cursor;
import org.eclipse.swt.widgets.Table;



public class EpubChecker {
	Button validateButton, browseButton, manageProfilesButton;
	Combo selectProfileCombo;
	Text pathToEpubText, outputText;
	Canvas outputArea, logoBox;
	Browser browser;
	Label pathLabel;
	Image leTexLogo;
	Cursor cursor;
	Table table;
	private static Vector<EpubCheckProfile> profiles = new Vector<EpubCheckProfile>();
	
		
	//private static final String TEMPDIR = System.getProperty("java.io.tmpdir");
	//private static final String[] profiles = {"EPUB", "MOBI", "IPAD"};
	
	public static void main(String[] args) {
		setProfiles();
		Display display = new Display();
		Shell shell = new EpubChecker().createShell(display);
		shell.open();
		while (!shell.isDisposed()) {
			if (!display.readAndDispatch())
				display.sleep();
		}
	}

	private static void setProfiles() {

		profiles.add(new EpubCheckProfile("EPUB", "Epubcheck 3 with version autodetection", "xproc/epub.xpl"));
		profiles.add(new EpubCheckProfile("IPAD", "Epub 2.0.1 with video, audio, fixed layout, �", "xproc/epub.xpl"));
		profiles.add(new EpubCheckProfile("MOBI", "Epub 2.0.1 with layout & font constraints", "xproc/kindle.xpl"));
	}

	public Shell createShell(final Display display) {
		final Shell shell = new Shell(display);
		FormLayout layout = new FormLayout();
		layout.marginWidth = 5;
		layout.marginHeight = 5;
		shell.setLayout(layout);
		shell.setText("le-tex EPUB-Checker");
		shell.addListener (SWT.Resize,  new Listener () {
		    public void handleEvent (Event e) {
		      if(browser != null) resizeBrowser();
		      else if(table != null) resizeTable();
		    }
		  });
		
		pathLabel = new Label(shell, SWT.NONE);
		pathLabel.setText("Path:");
		
		pathToEpubText = new Text(shell, SWT.SINGLE | SWT.BORDER);
		
		browseButton = new Button(shell, SWT.PUSH);
		browseButton.setText("Browse...");
		browseButton.addListener(SWT.Selection, new Listener() {
		      public void handleEvent(Event e) {
		        switch (e.type) {
		        case SWT.Selection:
		        	FileDialog dlg = new FileDialog(shell, SWT.OPEN);
		            String fileName = dlg.open();
		            if (fileName != null) {
		            	pathToEpubText.setText(fileName);		            
		            }		        
		          break;
		        }
		      }
		    });
		
		selectProfileCombo = new Combo(shell, SWT.DROP_DOWN | SWT.READ_ONLY);
		String[] profilestrings = new String[profiles.size()];
		for (int i = 0; i < profiles.size();i++) {
			profilestrings[i] = profiles.elementAt(i).getName();
		}
		selectProfileCombo.setItems(profilestrings);
		selectProfileCombo.select(0);
		
		manageProfilesButton = new Button(shell, SWT.PUSH);
		manageProfilesButton.setText("Manage Profiles");
		manageProfilesButton.addListener(SWT.Selection, new Listener() {
		      public void handleEvent(Event e) {
		        switch (e.type) {
		        case SWT.Selection:
		          System.out.println("manageProfilesButton pressed ");
		          if(browser != null) closeBrowser();
		          openTable();
		          break;
		        }
		      }
		    });
				
		validateButton = new Button(shell, SWT.PUSH);
		validateButton.setText("Validate");
		validateButton.addListener(SWT.Selection, new Listener() {
		      public void handleEvent(Event e) {
		        switch (e.type) {
		        case SWT.Selection:
		          System.out.println("validateButton pressed " + selectProfileCombo.getText() + " " + pathToEpubText.getText());
		          
					try {
						File tempdir = createTempDir();
						File resultfile = new File(tempdir.getAbsolutePath() + File.separatorChar + "result.html");
						System.out.println(tempdir.getAbsolutePath());
						System.out.println(selectProfileCombo.getText());
						unzip(pathToEpubText.getText(), tempdir);
						if(table != null) closeTable();
						checkEpub(tempdir, selectProfileCombo.getText(), resultfile);
						if(browser == null) {
							openBrowser(resultfile);
						} else {
							reloadBrowser(resultfile);
						}
						System.out.println("Open Browser finished");
					} catch (IOException e1) {
						e1.printStackTrace();
					}
					
		          
		          break;
		        }
		      }


		    });
		
		outputArea = new Canvas(shell, SWT.BORDER);

		final Cursor cursor = new Cursor(display, SWT.CURSOR_HAND);
		logoBox = new Canvas(shell, SWT.NONE);
		logoBox.addPaintListener(new PaintListener() {
			public void paintControl(PaintEvent e) {
				leTexLogo = new Image(display, "logos/Logo_Web_BGtrans_24.png");
				e.gc.drawImage(leTexLogo, 0, 0);
			}
		});
		
		logoBox.addMouseListener(new MouseListener() {
			
			@Override
			public void mouseUp(MouseEvent arg0) {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void mouseDown(MouseEvent d) {
				Desktop desktop = Desktop.getDesktop();
				try {
					desktop.browse(new URI("http://www.le-tex.de"));
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (URISyntaxException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
			@Override
			public void mouseDoubleClick(MouseEvent arg0) {
				// TODO Auto-generated method stub
				
			}
		});
		
		logoBox.addMouseTrackListener(new MouseTrackListener() {
			
			@Override
			public void mouseHover(MouseEvent arg0) {
				// TODO Auto-generated method stub
				logoBox.setCursor(cursor);
			}
			
			@Override
			public void mouseExit(MouseEvent arg0) {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void mouseEnter(MouseEvent arg0) {
				// TODO Auto-generated method stub
				logoBox.setCursor(cursor);
			}
		});

		
	    
		//layouting with formlayout
		FormData data = new FormData();
		data.top = new FormAttachment(0, 0);
		data.left = new FormAttachment(0, 0);
		pathLabel.setLayoutData(data);
		
		FormData data2 = new FormData();
		data.top = new FormAttachment(0, 0);
		data2.left = new FormAttachment(pathLabel, 5);
		data2.right = new FormAttachment(70, 0);
		pathToEpubText.setLayoutData(data2);
		
		FormData data3 = new FormData();
		data3.top = new FormAttachment(0, 0);
		data3.left = new FormAttachment(pathToEpubText, 0);
		browseButton.setLayoutData(data3);
		
		FormData data4 = new FormData();
		data4.top = new FormAttachment(browseButton, 10);
		data4.left = new FormAttachment(0, 0);
		selectProfileCombo.setLayoutData(data4);
		
		FormData data5 = new FormData();
		data5.top = new FormAttachment(browseButton, 10);
		data5.left = new FormAttachment(selectProfileCombo, 0);
		manageProfilesButton.setLayoutData(data5);
		
		FormData data7 = new FormData();
		data7.top = new FormAttachment(browseButton, 10);
		data7.left = new FormAttachment(manageProfilesButton, 0);
		validateButton.setLayoutData(data7);
		
		FormData data8 = new FormData(142,58);
		data8.top = new FormAttachment(0, 0);
		data8.left = new FormAttachment(browseButton, 10);
		data8.bottom = new FormAttachment(outputArea, 0);
		logoBox.setLayoutData(data8);

		FormData data6 = new FormData();
		data6.top = new FormAttachment(selectProfileCombo, 10);
		data6.left = new FormAttachment(0, 0); 
		data6.right = new FormAttachment(100, 0);
		data6.bottom = new FormAttachment(90, 0);
		outputArea.setLayoutData(data6);
		
		return shell;
	}
	
	protected void checkEpub(File pathToEpub, String profile, File pathToReport) {


		String outputURI = pathToEpub.toURI().getPath();
		String reportURI = pathToReport.toURI().getPath();
		System.out.println(profile);
		String profilefile = findProfile(profile);
		String[] calabash_args = {"-Eorg.apache.xml.resolver.tools.CatalogResolver" ,"-Uorg.apache.xml.resolver.tools.CatalogResolver" ,"-oresult="+reportURI,profilefile,"epubdir="+ outputURI};
		for (String mystring : calabash_args) {
			System.out.println(mystring);
			
		}
		//PrintStream stdout = System.out;
		System.setProperty("xml.catalog.files", "./resolver/catalog.xml");
		com.xmlcalabash.drivers.Main main = new com.xmlcalabash.drivers.Main();
		
		//ByteArrayOutputStream byteStream = new ByteArrayOutputStream();
		//System.setOut(new PrintStream(byteStream, true));
		System.out.println("Start of Calabash execution");
		try{
		main.run(calabash_args);
		} catch(Exception e) {
			e.printStackTrace();
		}
		System.out.println("End of Calabash execution");
//		String outputResult = byteStream.toString();
//		System.setOut(stdout);

		
	}

	private String findProfile(String profilestring) {
		String profilefile = null;
		for (EpubCheckProfile profile: profiles) {
			System.out.println(profile.getName() + "-" + profilestring);
			if (profile.getName().equals(profilestring)) {
				profilefile = profile.getXprocfile();
			}
		}
		
		
		return profilefile;
	}

	public void openBrowser(File resultfile){
		browser = new Browser(outputArea, SWT.NONE);
        browser.setBounds(outputArea.getClientArea());
        browser.setUrl(resultfile.toURI().toString());
	}
	
	public void resizeBrowser(){
		browser.setBounds(outputArea.getClientArea());
	}
	
	public void reloadBrowser(File resultfile){
		if(browser.isDisposed()) {
			openBrowser(resultfile);
		} else {
			browser.setUrl(resultfile.toURI().toString());
		}
	}
	
	public void closeBrowser() {
		browser.close();
	}

	public void openTable() {
		table = new Table(outputArea, SWT.BORDER | SWT.MULTI);
		int w = outputArea.getBounds().width;
		int h = outputArea.getBounds().height;
		table.setBounds(0, 0, w, h);
		table.setLinesVisible(true);
		table.setHeaderVisible(true);
		
		String[] titles = {"Name", "Description", "ID"};
		for (int i = 0; i < titles.length; i++) {
		      TableColumn column = new TableColumn(table, SWT.NONE);
		      column.setText(titles[i]);
		    }
		
		for (int i = 0; i < profiles.size(); i++) {
		      TableItem item = new TableItem(table, SWT.NONE);
		      item.setText(0, profiles.get(i).getName());
		      item.setText(1, profiles.get(i).getDescription());
		      item.setText(2, profiles.get(i).getXprocfile());
		      }
		
		for (int i=0; i<titles.length; i++) {
		      table.getColumn(i).pack();
		    }  
	}
	
	public void closeTable() {
		table.dispose();
	}
	
	public void resizeTable(){
		table.setBounds(outputArea.getClientArea());
	}
	
	public static File createTempDir() throws IOException{
		
		
		final File temp;
		
		
		temp = File.createTempFile("temp", Long.toString(System.nanoTime()));
		
		if(!(temp.delete())){
			throw new IOException("could not delete temp file");
		}
		
		if (!(temp.mkdir())){
			throw new IOException("could not create temp directory");
		}
		
		return (temp);
		
	}
	
	public static void unzip(String zipfile, File destination){
		try {
			final int BUFFER = 2048;
			BufferedOutputStream dest = null;
			FileInputStream fis = new FileInputStream(zipfile);
			ZipInputStream zis = new ZipInputStream(new BufferedInputStream(fis));
			ZipEntry entry;
			while((entry = zis.getNextEntry()) != null) {
				System.out.println("Extracting: " + entry);
				int count;
				byte data[] = new byte[BUFFER];
				// write the files to the disk
				String entryname = entry.getName(); 
				entryname = entryname.replace('/', File.separatorChar);
				File fileentry = new File(destination.getAbsolutePath() + File.separatorChar + entryname);
				File folder = fileentry.getParentFile();
				folder.mkdirs();
				System.out.println(destination.getAbsolutePath() + File.separatorChar + entryname);
				FileOutputStream fos = new FileOutputStream(destination.getAbsolutePath() + File.separatorChar + entryname);
				dest = new BufferedOutputStream(fos, BUFFER);
				while ((count = zis.read(data, 0, BUFFER)) 
						!= -1) {
					dest.write(data, 0, count);
				}
				dest.flush();
				dest.close();
			}
			zis.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}


	
}
