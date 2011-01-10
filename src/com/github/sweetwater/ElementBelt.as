package com.github.sweetwater {
import flash.events.Event;

/**
 * @author sweetwater
 */
public class ElementBelt {
  private var _elements:Array;

  public function ElementBelt(game:Game) {
    game.addEventListener("updateFrame", function(event:Event):void {
      updateFrame();
    });
  }

  public function updateFrame():void {
    scroll();
  }

  public function scroll():void {
    // TODO Elementをスクロールさせる
  }

  public function initialize(elements:Array):void {
    _elements = elements.slice();

    var startX:int = 60;
    var offsetX:int = 60;
    var posY:int = 60;
    _elements.forEach(function(item:Element, index:int, array:Array):void {
      Object(array);
      item.x = startX + index * offsetX;
      item.y = posY;
    });
  }

  public function insert(index:int, element:Element):void {
    _elements.splice(index, 0, element);
  }

  public function remove(index:int):Element {
    return _elements.splice(index, 1)[0];
  }
}
}
