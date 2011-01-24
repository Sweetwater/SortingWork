package com.github.sweetwater.View
{
import com.github.sweetwater.Game2;

import flash.display.Graphics;
import flash.display.Sprite;

public class DefragView2 extends Sprite
{
  private var frameThick:Number = 1;
  private var elementThick:Number = 2;
  private var rowNum:int = 80;
  private var viewWidth:Number = 800;
  private var viewHeight:Number = (frameThick + elementThick) * rowNum + frameThick;

  private var _game:Game2;

  public function DefragView2(game:Game2)
  {
    _game = game;
    draw();
  }

  public function draw():void {
    var g:Graphics = this.graphics;

    var frameColor:uint = 0x898989;
    var elementColor:uint = 0xFFFFFF;
    var rowHeight:Number = frameThick + elementThick;
    for (var i:int = 0; i < rowNum; i++) {
      var rowY:Number = i * rowHeight;

      g.lineStyle(frameThick, frameColor, 1.0);
      g.moveTo(0, rowY);
      g.lineTo(viewWidth, rowY);

      g.lineStyle(elementThick, elementColor, 1.0);
      g.moveTo(0, rowY + elementThick);
      g.lineTo(viewWidth, rowY + elementThick);
    }
    var rowY2:Number = (rowNum - 1) * rowHeight;
    g.moveTo(0, rowY2);
    g.lineTo(viewWidth, rowY2);
  }
}
}