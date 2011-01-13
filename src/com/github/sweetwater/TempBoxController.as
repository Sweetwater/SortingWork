package com.github.sweetwater {
import flash.display.InteractiveObject;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.utils.getTimer;

/**
 * @author sweetwater
 */
public class TempBoxController {
  private var _stage:Stage;
  private var _tempBox:TempBox;

  private var _isDown:Boolean;
  private var _baseX:Number;

  public function TempBoxController(stage:Stage, tempBox:TempBox) {
    _stage = stage;
    _tempBox = tempBox;
    _stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//    _stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
//    _stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//    _stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

//    _isDown = false;
  }

  private function onMouseMove(event:MouseEvent):void {
//    if (_isDown == false) return;

    var moveX:Number = event.stageX - _tempBox.x - _tempBox.width / 2;
    Game.instance.execute(new Command("tempBox_move", {"moveX":moveX}));
//    _baseX = event.stageX;

//    if (event.stageY < 0 || event.stageY > _tempBox.getBounds(_stage).bottom) {
//      _isDown = false;
//    }
  }

//  private function onMouseOut(event:MouseEvent):void {
//    _isDown = false;
//  }

//  private function onMouseUp(event:MouseEvent):void {
//    _isDown = false;
//  }

//  private function onMouseDown(event:MouseEvent):void {
//    var bounds:Rectangle = _tempBox.getBounds(_stage);
//    if (bounds.contains(event.stageX, event.stageY) == false) {
//      return;
//    }
//    _baseX = event.stageX;
//    _isDown = true;
//  }
}
}
