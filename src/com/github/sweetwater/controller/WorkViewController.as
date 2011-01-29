package com.github.sweetwater.controller
{
import com.github.sweetwater.Command;
import com.github.sweetwater.Game2;
import com.github.sweetwater.View.ScrollView2;
import com.github.sweetwater.View.WorkView;
import com.github.sweetwater.model.SelectPosition;

import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

public class WorkViewController
{
  private var releaseDistance:Number = 6;

  private var _workView:WorkView;
  private var _isCursorDrag:Boolean;
  private var _lastX:Number;
  private var _lastY:Number;

  private var _downPosition:SelectPosition;
  private var _downPoint:Point;

  public function WorkViewController(scrollView:WorkView)
  {
    _workView = scrollView;

    _downPosition = null;

    _workView.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    _workView.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
    _workView.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    _workView.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

    reset();
  }

  public function reset():void {
    _isCursorDrag = false;
  }

  private function checkHitBox(x:Number, y:Number) : Object {
    var boxes:Array = _workView.boxes;
    for each (var box:Object in boxes) {
      var collision:Rectangle = box.collision;
      var isHit:Boolean = collision.contains(x, y);
      if (isHit) return box;
    }
    return null;
  }

  private function getHitPostiion(x:Number, y:Number) : SelectPosition {
    var box:Object = checkHitBox(x, y);
    if (box == null) return SelectPosition.None;

    var boxes:Array = _workView.boxes;
    var number:int = boxes.indexOf(box);
    return SelectPosition.Element(number);
  }

  private function onMouseDown(event:MouseEvent):void {
    _isCursorDrag = true;
    _lastX = event.localX;
    _lastY = event.localY;

    _downPosition = getHitPostiion(event.localX, event.localY);
    _downPoint = new Point(event.localX, event.localY);
  }

  public function onMouseUp(event:MouseEvent):void {
    _isCursorDrag = false;

    var upPosition:SelectPosition = getHitPostiion(event.localX, event.localY);
    if (_downPosition != null && _downPosition.equals(upPosition)) {
      Game2.instance.execute(new Command("SelectPosition_selectCommand", {position:_downPosition}));
    }
  }

  public function onMouseOut(event:MouseEvent):void {
    _isCursorDrag = false;
    _downPosition = null;
  }

  public function onMouseMove(event:MouseEvent):void {
    if (_isCursorDrag != false) {
      var deltaX:Number = event.localX - _lastX;
      var moveX:Number = -deltaX / _workView.boxesWidth;
      Game2.instance.execute(new Command("ScrollPosition_moveCommand", {moveX:moveX}));
      _lastX = event.localX;
      _lastY = event.localY;
    }

    // エレメントをダウン後一定以上動いたクリック判定を無効にする
    if (_downPosition != null) {
      var offsetX:Number = event.localX - _downPoint.x;
      var offsetY:Number = event.localY - _downPoint.y;
      var distanceSq:Number = offsetX * offsetX + offsetY * offsetY;
      if (distanceSq > releaseDistance * releaseDistance) {
        _downPosition = null;
      }
    }
  }
}
}