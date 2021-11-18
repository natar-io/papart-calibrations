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
    super(Processing::PVector::new(200, 0), 200, 200) # 630, 444.5)
  end

  def settings
    setDrawAroundPaper
  end
  
  def setup
    # load_image
    # create_gui    
  end
  
  # def create_gui
  #   @skatolo = Skatolo.new(Processing.app, self)
  #   @skatolo.setAutoDraw false
  # end

  # def create_buttons
  #   # @b1 = @skatolo.addHoverButton("button")
  #   #   .setPosition(30, 29)
  #   #   .setSize(20, 20)
  #   @buttons = (1..2).map do |id|
  #     @skatolo.addHoverButton("button" + id.to_s)
  #       .setPosition(50 + (id-1) * 65, 120)
  #       .setSize(50, 50)
  #       .setLabel("")
  #       .setColorBackground(Processing::app.color(200, 0, 0))
  #       .setColorActive(Processing::app.color(0, 200, 0))
  #   end
  #   @offset1 = 0
  #   @offset2 = 0
  #   @skatolo.update
  # end
      
  def drawAroundPaper
    begin
      background 150
      setLocation(0, 0, 0)
      translate(0, 200, 0)
      # fill(255)
      # stroke(255, 0,0)
      # rect(0, 0, 120, 160)

      ## floor level
      translate(-380, -170, -10)
      draw_floor

      ## border level
      translate(0,0,-10)
      draw_border

      ## floor level
      translate(0, 0 ,10)
      @box_w = 95
      draw_box(400 - @box_w - 5, 5, 60)
      
    # fill(100)
      # ellipse(Processing::app.mouseX - 400, Processing::app.mouseY, 20, 20)
#      ellipse(-50, 250, 200, 200) 
      
    rescue => e
      puts e.to_s
    end
  end

  def draw_box(px, py, h)
    pushMatrix

    translate(px, py, 0)
    fill(150, 20, 80)
    strokeWeight 2
    stroke(255, 0, 255)
    translate(@box_w/2, @box_w/2, -h/2)
#    translate(0,0, -h/2)
    box(95, 95, h);
    popMatrix
  end
  
  
## 400 extérieur
## 5mm border
# 390 intérieur
# 2 cm hauteur
# 1 cm hauteur intérieur

  def draw_border
    noFill
    # w = Processing::app.mouseX / 10
    # strokeWeight w
    strokeWeight 10
    stroke 255, 0, 0
    rect 0,0, 400, 400
  end
  
  def draw_floor
    fill(0, 180, 98)
    noStroke
    rect 0,10, 400-5, 400-5
  end
  
  
  def drawOnPaper
#    setLocation(-300, -200, 10)
    background 255
  # updateTouch
  # drawTouch(20)
  # Papartlib::SkatoloLink.updateTouch(touchList, @skatolo); 
  #  @skatolo.draw getGraphics
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
