package com.github.sweetwater.controller
{
import com.github.sweetwater.Command;
import com.github.sweetwater.Game2;
import com.github.sweetwater.View.ScrollView2;
import com.github.sweetwater.View.WorkView;

import flash.events.MouseEvent;
import flash.geom.Rectangle;

public class WorkViewController
{
  private var _workView:WorkView;
  private var _isCursorDrag:Boolean;
  private var _lastX:Number;
  private var _lastY:Number;

  public function WorkViewController(scrollView:WorkView)
  {
    _workView = scrollView;
    _workView.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    _workView.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
    _workView.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    _workView.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

    reset();
  }

  public function reset():void {
    _isCursorDrag = false;
  }

  public function onMouseDown(event:MouseEvent):void {
    _isCursorDrag = true;
    _lastX = event.localX;
    _lastY = event.localY;
  }
  public function onMouseUp(event:MouseEvent):void {
    _isCursorDrag = false;
  }
  public function onMouseOut(event:MouseEvent):void {
    _isCursorDrag = false;
  }
  public function onMouseMove(event:MouseEvent):void {
    if (_isCursorDrag == false) return;

    var deltaX:Number = event.localX - _lastX;
    var moveX:Number = -deltaX / 1600;
    Game2.instance.execute(new Command("ScrollPosition_moveCommand", {moveX:moveX}));

    _lastX = event.localX;
    _lastY = event.localY;
  }
}
}