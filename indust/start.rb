# -*- coding: utf-8 -*-

require 'jruby_art'
require 'jruby_art/app'

# java_signature
require 'jruby/core_ext'

if not defined? Processing::App::SKETCH_PATH 
  Processing::App::SKETCH_PATH = __FILE__  
  Processing::App::load_library :PapARt, :javacv, :toxiclibscore, :SVGExtended, :OpenNI, :skatolo, :ColorConverter
end
  
module Papartlib
  include_package 'fr.inria.papart.procam'
  include_package 'fr.inria.papart.procam.camera'
  include_package 'fr.inria.papart.multitouch'
  include_package 'fr.inria.papart.utils'
  include_package 'import tech.lity.rea.svgextended'

  include_package 'fr.inria.papart.multitouch.tracking'
  include_package 'fr.inria.papart.multitouch.detection'
  include_package 'tech.lity.rea.colorconverter.ColorConverter'
end


#require_relative 'menu'
require 'skatolo'
require_relative 'event_method'

class Sketch < Processing::App

  attr_reader :papart, :plateau
  attr_accessor :mode
  
  def settings
    fullScreen Processing::App::P3D
#   size 800, 600, Processing::App::P3D
  end

  def setup
    @debug = false

    @mode = 1
    
    if @debug
      @papart = Papartlib::Papart.new(self)
      @papart.initDebug
    else
      @papart = Papartlib::Papart.projection(self)
      @papart.loadTouchInput().initHandDetection()
    end
    
    @plateau = Plateau.new
    
    @papart.startTracking if not @debug

    frameRate(30)

  end
  
  def draw
  end
end


class Plateau < Papartlib::TableScreen

  include EventMethod

  def initialize
    super(Processing::PVector::new(0, 0), 600, 420) # 630, 444.5)
  end

  def setup
    load_image
    create_gui    
  end
  
  def create_gui
    @skatolo = Skatolo.new(Processing.app, self)
    @skatolo.setAutoDraw false
    create_buttons
  end

  def create_buttons
    # @b1 = @skatolo.addHoverButton("button")
    #   .setPosition(30, 29)
    #   .setSize(20, 20)

    @buttons = (1..2).map do |id|
      @skatolo.addHoverButton("button" + id.to_s)
        .setPosition(50 + (id-1) * 65, 120)
        .setSize(50, 50)
        .setLabel("")
        .setColorBackground(Processing::app.color(200, 0, 0))
        .setColorActive(Processing::app.color(0, 200, 0))
    end
    @offset1 = 0
    @offset2 = 0
    @skatolo.update
  end

  def button1 ; @offset1 = Processing.app.millis;   end
  def button2 ; @offset2 = Processing.app.millis;   end
  
  def load_image
    @pieces = Processing.app.loadImage(Processing.app.sketchPath() + "/data/pieces.png")
    @pieces2 = Processing.app.loadImage(Processing.app.sketchPath() + "/data/pieces2.png")
    @mesure = Processing.app.loadImage(Processing.app.sketchPath() + "/data/mesure.png")
  end
  
  
  def drawOnPaper
    setLocation(-300, -200, 10)
    background 30

    begin

      noStroke
      highlight(100, 100, 1000)

      highlight(325, 100, 1000)
      
      highlight(100, 150, 1000)
      highlight(100, 250, 1000)
      highlight(100, 300, 1000)


      
      stroke 255
      line 125, 100, 300, 100


      
#      line 125, 200, 300, 100
      
      #      blinker(400.0, 300.0, 5000.0, @offset1, 200, 0)
 #     blinker(400.0, 300.0, 5000.0, @offset2, 100, 1)
      
    #    tint(255, 150)
    #    image @pieces, 20, 80, 150, 150
    #    translate 0, 0, 4
    # image @pieces2, 50, 100, 450, 300
    # rect(0, 0, 100, 100);
    #    image @mesure, 200, 200, 180, 60

      updateTouch
      drawTouch(20)

      Papartlib::SkatoloLink.updateTouch(touchList, @skatolo); 
      
#      @skatolo.draw getGraphics
    rescue => e
      
      puts e.to_s
    end
  end

  def highlight(px, py, blink_speed = 400.0)

    fill(Math.sin(Processing.app.millis % blink_speed.to_i / blink_speed.to_f * 3.14)  * 255)

#    puts blink_speed
#    fill(255)
    distance = 200.0
    duration = 5000.0
    
    ellipseMode Processing::Proxy::CENTER
    ellipse(px,py, 50, 50)
    fill 0
    ellipse(px,py, 40, 40)
  end
  
  def blinker(blink, distance, duration, offset = 0, y=0, bid=0)

      px = (Processing.app.millis - offset) % duration

      @buttons[bid].setPosition(px / duration * distance, y)
  end
  
end

# Processing.app.plateau.load_image

Sketch.new unless  (Processing.app != nil)
