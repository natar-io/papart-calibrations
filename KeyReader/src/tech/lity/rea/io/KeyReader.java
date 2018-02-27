/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package tech.lity.rea.io;

import java.awt.event.InputEvent;
import java.util.Set;

import redis.clients.jedis.*;

import java.nio.*;
import java.io.*;
import java.awt.Robot;
import java.awt.event.KeyEvent;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author realitytech
 */
public class KeyReader {

    static final int UP = KeyEvent.VK_UP;
    static final int DOWN = KeyEvent.VK_DOWN;
    static final int LEFT = KeyEvent.VK_LEFT;
    static final int RIGHT = KeyEvent.VK_RIGHT;
    static final int CENTER = 3;

    public KeyReader(int display) {
        this.display = display;
        this.prefix = "evt:" + Integer.toString(display) + ":";
    }

    private final int display;
    private boolean debug;
    private Robot robot;
    private Jedis redis;

    private final String prefix;

    void setup() {
        try {
            robot = new Robot();
        } catch (Exception e) {
            e.printStackTrace();

        }
        connect();

        redis.del(prefix + "key:pressed");
        redis.del(prefix + "key:released");
        redis.del(prefix + "mouse:x");
        redis.del(prefix + "mouse:y");
        redis.del(prefix + "mouse:pressed");
        redis.del(prefix + "mouse:pressedButton");
    }

    boolean previousPressed = false;

    void draw() {
        keyboard();
        mouse();
    }

    void keyboard() {

        Set<String> keysPressed = redis.smembers(prefix + "key:pressed");
        Set<String> keysReleased = redis.smembers(prefix + "key:released");

        if (debug) {
            if (!keysPressed.isEmpty()) {
                for (String key : keysPressed) {
                    print(key + " ");
                }
                print("\n");
            }
            if (!keysReleased.isEmpty()) {
                print("Key Release list: ");
                for (String key : keysReleased) {
                    print(key + " ");
                }
                print("\n");
            }
        }

        for (String key : keysPressed) {
            int k = Integer.parseInt(key);
            // press
            robot.keyPress(k);
            // remove from press list 
            redis.srem(prefix + "key:pressed", key);
        }

        for (String key : keysReleased) {
            int k = Integer.parseInt(key);
            // release
            robot.keyRelease(k);
            // remove from press list 
            redis.srem(prefix + "key:released", key);
        }
    }

    void mouse() {
        String xStr = redis.get(prefix + "mouse:x");
        String yStr = redis.get(prefix + "mouse:y");
        if (xStr != null && yStr != null) {
            int x = Integer.parseInt(xStr);
            int y = Integer.parseInt(yStr);
            robot.mouseMove(x, y);
        }

        String pStr = redis.get(prefix + "mouse:pressed");
        String bStr = redis.get(prefix + "mouse:pressedButton");

        //    println("mouse: " + xStr + " " + yStr + " pressed ?: " + pStr + " " + bStr);
        if (pStr != null && bStr != null) {
            boolean pressed = Boolean.parseBoolean(pStr);
            int button = Integer.parseInt(bStr);

            if (pressed != previousPressed) {
                int mask = InputEvent.BUTTON1_MASK;
                if (button == LEFT) {
                    mask = InputEvent.BUTTON1_MASK;
                }
                if (button == RIGHT) {
                    mask = InputEvent.BUTTON2_MASK;
                }
                if (button == 3) {
                    mask = InputEvent.BUTTON3_MASK;
                }

                if (pressed) {
                    robot.mousePress(mask);
                } else {
                    robot.mouseRelease(mask);
                }

                redis.del(prefix + "mouse:Pressed");
                redis.del(prefix + "mouse:pressedButton");
                previousPressed = pressed;
            }
        }

        String wheelString = redis.get(prefix + "mouse:wheel");
        if (wheelString != null) {
            float wheel = Float.parseFloat(wheelString);
            robot.mouseWheel((int) wheel);
            redis.del(prefix + "mouse:wheel");
        }
    }

    void connect() {
        redis = new Jedis("127.0.0.1", 6379);
        // redis.auth("156;2Asatu:AUI?S2T51235AUEAIU");
    }

    static public void main(String[] passedArgs) {

        int display = 99;
//        System.out.println("args" + passedArgs.length);
//        for (String passedArg : passedArgs) {
//            System.out.println(passedArg);
//        }
        
        if (passedArgs.length > 0) {
            try {
                display = Integer.parseInt(passedArgs[0]);
            } catch (NumberFormatException nfe) {
            }
        }
        KeyReader reader = new KeyReader(display);
        reader.setup();

        while (true) {
            try {
                reader.draw();
                Thread.sleep(100);
            } catch (InterruptedException ex) {
                Logger.getLogger(KeyReader.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    private void print(String string) {
        System.out.print(string);
    }

}
