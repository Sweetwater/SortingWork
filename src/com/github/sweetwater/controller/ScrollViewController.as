package com.github.sweetwater.controller
{
import com.github.sweetwater.Command;
import com.github.sweetwater.Game2;
import com.github.sweetwater.View.ScrollView2;

import flash.events.MouseEvent;
import flash.geom.Rectangle;

public class ScrollViewController
{
  private var _scrollView:ScrollView2;
  private var _isCursorDrag:Boolean;
  private var _lastX:Number;
  private var _lastY:Number;

  public function ScrollViewController(scrollView:ScrollView2)
  {
    _scrollView = scrollView;
    _scrollView.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    _scrollView.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
    _scrollView.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    _scrollView.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

    reset();
  }

  public function reset():void {
    _isCursorDrag = false;
  }

  public function onMouseDown(event:MouseEvent):void {
    var rect:Rectangle = _scrollView.cursorRect;
    _isCursorDrag = rect.contains(event.localX, event.localY);
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
    var moveX:Number = deltaX / _scrollView.barRect.width;
    Game2.instance.execute(new Command("ScrollPosition_moveCommand", {moveX:moveX}));

    _lastX = event.localX;
    _lastY = event.localY;
  }
}
}