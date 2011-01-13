package com.github.sweetwater {
import flash.display.InteractiveObject;
import flash.events.MouseEvent;
import flash.utils.getTimer;

/**
 * @author sweetwater
 */
public class LightController {
  private var _deltaY:Number = 20;
  private var _inputTime:int = 200;
  private var _isDown:Boolean;
  private var _baseY:Number;
  private var _moves:Array;

  public function LightController(target:InteractiveObject) {
    target.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    target.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    target.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
    target.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

    _isDown = false;
  }

  private function onMouseMove(event:MouseEvent):void {
    if (_isDown == false) return;

    var t:int = getTimer();
    var y:Number = event.localY - _baseY;
    _baseY = event.localY;

    var move:Object = {"t":t, "y":y};
    _moves.unshift(move);

    var time:int = getTimer() - _inputTime;
    for (var i:int = 0; i < _moves.length; i++) {
      if (_moves.t < time) {
        _moves.splice(i);
        break;
      }
    }
  }

  private function onMouseOut(event:MouseEvent):void {
    _isDown = false;
  }

  private function onMouseUp(event:MouseEvent):void {
    if (_isDown == false) return;

    var moveY:Number = 0;
    var time:int = getTimer() - _inputTime;
    for each (var i : Object in _moves) {
      if (i.t < time) break;
      moveY += i.y;
    }

    // 上向きにドラッグされた
    if (moveY < -_deltaY) {
      trace("up !!");
      SortingWork.outputText("up !!");
      Game.instance.execute(new Command("game_beltToBox"));
    }
    // 下向きにどらっぐされた
    if (moveY > _deltaY) {
      trace("down !!");
      SortingWork.outputText("down !!");
      Game.instance.execute(new Command("game_boxToBelt"));
    }
    _isDown = false;
  }

  private function onMouseDown(event:MouseEvent):void {
    _baseY = event.localY;
    _moves = new Array();
    _isDown = true;
  }
}
}
