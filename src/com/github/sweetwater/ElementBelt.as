package com.github.sweetwater {
import flash.display.Stage;
import flash.events.Event;

/**
 * @author sweetwater
 */
public class ElementBelt {
  private var _elements:Array;
  public function get elements():Array {
    return _elements;
  }

  private var _stage:Stage;

  public function ElementBelt(game:Game, stage:Stage) {
    _stage = stage;
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
    _elements.forEach(function(item:Element, index:int, array:Array):void {
      Object(array);
      int(index);
      _stage.addChild(item);
    });
    fixPoision();
  }

  public function fixPoision():void {
    var startX:int = 0;
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
    _stage.addChildAt(element, 0);
    fixPoision();
  }

  public function remove(index:int):Element {
    if (index < _elements.length) {
      var element:Element = _elements.splice(index, 1)[0];
      _stage.removeChild(element);
      fixPoision();
      return element;
    }
    else {
      return null;
    }
  }
}
}
