//
//
//http://blogs.sun.com/alexismp/entry/glassfish_embedded_reloaded
//
// Compile: javac -cp glassfish-embedded-nucleus.jar:glassfish-gem.jar:akuma.jar:grizzly-jruby.jar:grizzly-jruby-module.jar:. Yogo.java
// Run: java -cp glassfish-embedded-nucleus.jar:glassfish-gem.jar:akuma.jar:grizzly-jruby.jar:grizzly-jruby-module.jar:. Yogo
//
import java.io.File;
import java.io.IOException;
import java.util.Properties;
import org.glassfish.api.deployment.DeployCommandParameters;
import org.glassfish.api.embedded.ContainerBuilder;
import org.glassfish.api.embedded.EmbeddedDeployer;
import org.glassfish.api.embedded.EmbeddedContainer;
import org.glassfish.api.embedded.EmbeddedFileSystem;
import org.glassfish.api.embedded.LifecycleException;
import org.glassfish.api.embedded.Server;

import org.glassfish.scripting.gem.JRubyContainerBuilder;
import org.glassfish.scripting.gem.JRubyContainer;

public class Yogo {
    private Server server;
    private EmbeddedDeployer deployer;

    private static int port = 4200;
    private static String context = "Yogo";

    private String applicationName = null;
    private static long time2sleep = 20000;

    /**
     * @param args the command line arguments
     */
    public Yogo() {
    }

    public void start() throws IOException {
        ContainerBuilder webContainerBuilder = null;
        ContainerBuilder jrubyContainerBuilder = null;
        Server.Builder builder = new Server.Builder("Yogo");

        // get the builder for EmbeddedFileSystem
        EmbeddedFileSystem.Builder efsb = new EmbeddedFileSystem.Builder();
        EmbeddedFileSystem efs = efsb.build();
        builder.embeddedFileSystem(efs);

        // Start the embedded server (should take no more than a few
        // of seconds)
        server = builder.build();
        
        // Add a WEB container (other containers: ejb, jps, all, ...)
        webContainerBuilder = server.createConfig(ContainerBuilder.Type.web);
        server.addContainer(webContainerBuilder);
        webContainerBuilder.create(server);

        // Add a JRUBY container (other containers: ejb, jps, all, ...)
	//jrubyContainerBuilder = new JRubyContainerBuilder();
	//jrubyContainerBuilder = server.createConfig(ContainerBuilder.Type.jruby);
        //server.addContainer(jrubyContainerBuilder);
        //jrubyContainerBuilder.create(server);

        // Starts grizzly on the given port
        server.createPort(port);
    }

    public boolean deployJRuby(String name, String archiveName) {
        // Setup machinery to deploy
	// type is EmbeddedDeployer
        deployer = server.getDeployer();
        DeployCommandParameters deployParams = new DeployCommandParameters();
	// needed for undeploy
        deployParams.name = name;
        deployParams.contextroot = name;
	Properties props = new Properties();
	props.setProperty("jruby.runtime", "1");
	props.setProperty("jruby.runtime.min", "1");
	props.setProperty("jruby.runtime.max", "1");
	props.setProperty("jruby.rackEnv", "development");
	if(java.lang.System.getProperties().get("glassfish.rackupApp")!=null){
	    //this is a hack                                        
	    props.setProperty("jruby.applicationType", "config.ru");
	}

	deployParams.property = props;

        // Creates default virtual server, web listener, does the
        // deploy and returns the applicationName as a String (null
        // means something went wrong) duration depends on application
        // size and nature. Heavy lifting done here.
        File archive = new File(archiveName);
        applicationName = deployer.deploy(archive, deployParams);
        return (applicationName == null) ? false : true;
    }

    public boolean deploy(String name, String archiveName) {
        // Setup machinery to deploy
	// type is EmbeddedDeployer
        deployer = server.getDeployer();
        DeployCommandParameters deployParams = new DeployCommandParameters();
	// needed for undeploy
        deployParams.name = name;
        deployParams.contextroot = name;

        // Creates default virtual server, web listener, does the
        // deploy and returns the applicationName as a String (null
        // means something went wrong) duration depends on application
        // size and nature. Heavy lifting done here.
        File archive = new File(archiveName);
        applicationName = deployer.deploy(archive, deployParams);
        return (applicationName == null) ? false : true;
    }

    public void undeployAndStop() throws LifecycleException {
	// Could have undeploy params like cascade, ...
        deployer.undeploy(applicationName, null);
	// May take a little while to clean everything up
        server.stop();
	// need this to kill any threads left runing (see #7198)
        System.exit(0);
    }

    public static void main(String[] args) throws Exception {
        String yName = "Yogo";
        String yArchive = "yogo.war";
        String pName = "Persevere";
        String pArchive = "persevere.war";
        boolean deployed = false;
        
        Yogo myGlassFish = new Yogo();
        myGlassFish.start();
	deployed = myGlassFish.deploy(pName, pArchive);
	//deployed = myGlassFish.deployJRuby(yName, yArchive);

        while(deployed) {
            Thread.sleep(time2sleep);
        }
        
        myGlassFish.undeployAndStop();  // stops and exits the JVM
    }
}