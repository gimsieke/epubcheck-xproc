import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLClassLoader;
import java.sql.Array;

import net.sf.saxon.s9api.SaxonApiException;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Button;
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
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.MouseListener;
import org.eclipse.swt.events.MouseTrackListener;
import org.eclipse.swt.events.PaintEvent;
import org.eclipse.swt.events.PaintListener;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.graphics.Cursor;


public class EpubChecker {
	Button validateButton, browseButton, manageProfilesButton;
	Combo selectProfileCombo;
	Text pathToEpubText, outputText;
	Canvas outputArea, logoBox;
	Browser browser;
	Label pathLabel;
	Image leTexLogo;
	Cursor cursor;
		
	//private static final String TEMPDIR = System.getProperty("java.io.tmpdir");
	private static final String[] profiles = {"EPUB", "MOBI", "IPAD"};
	
	public static void main(String[] args) {
		Display display = new Display();
		Shell shell = new EpubChecker().createShell(display);
		shell.open();
		while (!shell.isDisposed()) {
			if (!display.readAndDispatch())
				display.sleep();
		}
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
		selectProfileCombo.setItems(profiles);
		selectProfileCombo.select(0);
		
		manageProfilesButton = new Button(shell, SWT.PUSH);
		manageProfilesButton.setText("Manage Profiles");
		manageProfilesButton.addListener(SWT.Selection, new Listener() {
		      public void handleEvent(Event e) {
		        switch (e.type) {
		        case SWT.Selection:
		          System.out.println("manageProfilesButton pressed ");
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
		          openBrowser();
		          //checkEpub(pathToEpubText.getText());
		          
		          break;
		        }
		      }


		    });
		
		outputArea = new Canvas(shell, SWT.BORDER);

		final Cursor cursor = new Cursor(display, SWT.CURSOR_HAND);
		logoBox = new Canvas(shell, SWT.NONE);
		logoBox.addPaintListener(new PaintListener() {
			public void paintControl(PaintEvent e) {
				leTexLogo = new Image(display, "Logo_Web_BGtrans_24.png");
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
	
	protected void checkEpub(String pathToEpub) {
		
		com.xmlcalabash.drivers.Main calabash = new com.xmlcalabash.drivers.Main();
		String[] args = {"-o", "result=report.html" ,"xproc/kindle.xpl" , "epubdir=../test/CSS-Compatibility-Test-Suite"};
		try {
			calabash.run(args);
		} catch (SaxonApiException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void openBrowser(){
		browser = new Browser(outputArea, SWT.NONE);
        browser.setBounds(outputArea.getClientArea());
        browser.setUrl("file://./report.html");
	}
	
	public void resizeBrowser(){
		browser.setBounds(outputArea.getClientArea());
	}
	
}