package com.github.sweetwater {
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * @author sweetwater
 */
public class Game extends EventDispatcher {
  private static var _instance:Game;

  public static function get instance():Game {
    return _instance;
  }

  public static function initialize(stage:Stage):void {
    _instance = new Game(stage);
  }

  private var _tempBox:TempBox;
  private var _elements:Array;
  private var _elementBelt:ElementBelt;
  private var _eventDispatcher:EventDispatcher;

  public function Game(stage:Stage) {
    _tempBox = new TempBox();
    stage.addChild(_tempBox);

    _elements = new Array();
    for (var i:int = 0; i < 10; ++i) {
      var element:Element = new Element("A");
      _elements.push(element);
      stage.addChild(element);
    }

    _elementBelt = new ElementBelt(this);
    _elementBelt.initialize(_elements);

    _eventDispatcher = new EventDispatcher();

    stage.addEventListener(Event.ENTER_FRAME, function(event:Event):void {
      dispatchEvent(new Event("updateFrame"));
    });
  }

  public function execute(command:Command):void {
    switch (command.type) {
      case "pushRequest":
        executePushRequest();
        break;
      case "popRequest":
        break;
      case "push":
        executePush(command);
        break;
      case "pop":
        executePop(command);
        break;
    }
  }

  private function executePushRequest():void {
  }

  public function executePush(command:Command):void {
    var index:int = parseInt(command.arg);
    var element:Element = _elementBelt.remove(index);
    _tempBox.push(element);
  }

  public function executePop(command:Command):void {
    var index:int = parseInt(command.arg);
    var element:Element = _tempBox.pop();
    _elementBelt.insert(index, element);
  }
}
}
