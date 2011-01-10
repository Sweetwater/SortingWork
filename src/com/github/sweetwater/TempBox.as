package com.github.sweetwater {
import flash.display.Graphics;
import flash.display.Sprite;

/**
 * @author sweetwater
 */
public class TempBox extends Sprite {

  private var _light:Light;

  public function TempBox() {
    var g:Graphics = this.graphics;
    var color:uint = 0x008080;
    g.clear();
    g.lineStyle(3, color, 1.0, true);
    g.drawRect(0, 0, 46, 46);

  	_light = new Light();
  	_light.y = 48;
  	this.addChild(_light);
  }

  public function push(element:Element):void {
  }

  public function pop():Element {
    return null;
  }
}
}
