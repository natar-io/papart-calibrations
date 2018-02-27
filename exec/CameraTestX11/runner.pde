import java.lang.ProcessBuilder.Redirect;
import java.util.Map;

class ProgramRunner extends Thread{
    public boolean ready = false;

    String displayId = "1";
    String xvfb = "xvfb-run";
    String program = "/usr/bin/firefox";
    String windowManager = "openbox";
    
    public ProgramRunner(){
    }
    	// -n id display
	// -w delay
	//	    String args = "-s '-ac -screen 0 800x600x16' -n 1 -w 2";
    void xvfb()  throws IOException{
	//	String args = "-s \"-ac -screen 0 "+ resX + "x" + resY + "x16 \" -n "+displayId+" -w 2";
	String[] cmd = new String[]{
	    "/bin/sh",
	    "/usr/bin/xvfb-run",
	    "-s '-ac screen 0 800x600x16'",
	    "-n 1",
	    "-w 5",
	    "firefox"
	};
	println("Start xvfb");
	ProcessBuilder pb = new ProcessBuilder(cmd);
	pb.redirectOutput(Redirect.INHERIT);
	pb.redirectError(Redirect.INHERIT);
	
	Map<String, String> env = pb.environment();
	env.put("PATH", "/bin:/usr/bin");
	Process p = pb.start();
	
	println("sleep 6sec");
	try{
        Thread.sleep(6000);
	}catch(InterruptedException e){}
    }

    void wm() throws IOException{
	println("Start wm: " + windowManager);
	//	Process p2 = Runtime.getRuntime().exec(windowManager, envp);
	
	String[] cmd = new String[]{windowManager};
	
	ProcessBuilder pb = new ProcessBuilder(cmd);
	pb.redirectOutput(Redirect.INHERIT);
	pb.redirectError(Redirect.INHERIT);
	
	Map<String, String> env = pb.environment();
	env.put("PATH", "/bin:/usr/bin");
	env.put("DISPLAY", ":" + displayId);
	Process p = pb.start();

	try{
	Thread.sleep(4000);
	}catch(InterruptedException e){}
	
    }
    
    void event() throws IOException{
	println("Start eventManager.");

	String eventManager = "/usr/bin/processing-java --sketch=/home/jiii/ownCloud/sketches/redisKeyReader/ --output=/home/jiii/ownCloud/sketches/redisKeyReader/build --force --run";

	String[] cmd = new String[]{
	    "/usr/bin/processing-java",
	    "--sketch=/home/jiii/ownCloud/sketches/redisKeyReader/",
	    "--output=/home/jiii/ownCloud/sketches/redisKeyReader/build",
	    "--force",
	    "--run"
	};
	
	ProcessBuilder pb = new ProcessBuilder(cmd);
	pb.redirectOutput(Redirect.INHERIT);
	pb.redirectError(Redirect.INHERIT);
	
	Map<String, String> env = pb.environment();
	env.put("PATH", "/bin:/usr/bin");
	env.put("DISPLAY", ":" + displayId);
	Process p = pb.start();
    }

    public void run(){
	try{
	     xvfb();
	    // wm();
	    // event();
	    ready = true;
	}catch(Exception e){
	    println("Error starting process");
	    e.printStackTrace();
	}
    }
}
