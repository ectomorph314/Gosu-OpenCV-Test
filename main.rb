#!/usr/bin/env ruby
require 'gosu'
require 'opencv'

require_relative 'lib/zorder'

class Game < Gosu::Window
  include OpenCV

  def initialize
    @capture = CvCapture.open
    screen_width = @capture.width.to_i
    screen_height = @capture.height.to_i
    super(screen_width, screen_height, true)
    self.caption = 'Gosu/OpenCV Test'
    @x = 0
    @y = 0
    @theta = 0
  end

  def update
    CvHaarClassifierCascade.load('lib/haarcascade_frontalface_alt2.xml').detect_objects(@capture.query.flip(:x), scale_factor: 2).each do |rect|
      old = CvRect.new(@x, @y, 0, 0)
      @x = rect.center.x
      @y = rect.center.y
      dx = @x - old.center.x
      dy = @y - old.center.y
      if !dx.between?(-1, 1) && !dy.between?(-1, 1)
        @theta = Math.atan2(dy, dx).radians_to_gosu
      end
    end
  end

  def draw
    Gosu::Image.new(self, 'img/SSAG_beetle_logo_by_shiroikuro.jpg', false).draw_rot(@x, @y, ZOrder::PLAYER, @theta, 0.5, 0.5, 0.25, 0.25)
    # http://opengameart.org/content/ssag-beetle-eye
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

Game.new.show
