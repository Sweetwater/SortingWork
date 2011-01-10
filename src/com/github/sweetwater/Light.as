package com.github.sweetwater {
import flash.display.Graphics;
import flash.display.Sprite;

/**
 * @author sweetwater
 */
public class Light extends Sprite {
  private var _controller:MouseController;

  public function Light() {
    var g:Graphics = this.graphics;
    var color:uint = 0xFFFF80;
    g.clear();
    g.beginFill(color, 0.9);
    g.lineStyle(3, color, 1.0, true);
    g.drawRect(0, 0, 46, 90);
    g.endFill();

    _controller = new MouseController(this);
  }
}
}
