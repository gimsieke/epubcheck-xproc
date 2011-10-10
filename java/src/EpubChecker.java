import java.io.File;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;

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

public class EpubChecker {
	Button validateButton, browseButton, manageProfilesButton;
	Combo selectProfileCombo;
	Text pathToEpubText, outputText;
	Canvas outputArea;
	Browser browser;
	Label pathLabel;
		
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
		          checkEpub();
		          
		          break;
		        }
		      }


		    });
		
		outputArea = new Canvas(shell, SWT.BORDER);
				
		//layouting with formlayout
		FormData data = new FormData();
		data.top = new FormAttachment(0, 0);
		data.left = new FormAttachment(0, 0);
		pathLabel.setLayoutData(data);
		
		FormData data2 = new FormData();
		data.top = new FormAttachment(0, 0);
		data2.left = new FormAttachment(pathLabel, 5);
		data2.right = new FormAttachment(80, 0);
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
		
		FormData data6 = new FormData();
		data6.top = new FormAttachment(selectProfileCombo, 10);
		data6.left = new FormAttachment(0, 0); 
		data6.right = new FormAttachment(100, 0);
		data6.bottom = new FormAttachment(90, 0);
		outputArea.setLayoutData(data6);
		
		return shell;
	}
	
	protected void checkEpub() {
		
		com.xmlcalabash.drivers.Main calabash;
		
	}

	public void openBrowser(){
		browser = new Browser(outputArea, SWT.NONE);
        browser.setBounds(outputArea.getClientArea());
        browser.setUrl("http://google.com");
	}
	
	public void resizeBrowser(){
		browser.setBounds(outputArea.getClientArea());
	}
	
}