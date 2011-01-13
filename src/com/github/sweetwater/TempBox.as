package com.github.sweetwater {
import flash.display.Graphics;
import flash.display.Sprite;
import flash.text.engine.LigatureLevel;

/**
 * @author sweetwater
 */
public class TempBox extends Sprite {

  private var _light:Light = null;
  public function get light():Light {
    return _light;
  }

  private var _element:Element = null;
  public function get element():Element {
    return _element;
  }

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

  public function move(moveX:Number):void {
    this.x += moveX;
  }

  public function push(element:Element):void {
    if (_element != null) return;

    addChild(element);
    element.x = 3;
    element.y = 3;
    _element = element;
  }

  public function pop():Element {
    if (_element != null) {
      removeChild(_element);
      _element.x = this.x + 3;
      _element.y = this.y + 3;
      var returnElement:Element = _element;
      _element = null;
      return returnElement;
    }
    else {
      return null;
    }
  }
}
}
