package com.github.sweetwater.View
{
import com.github.sweetwater.Game;
import com.github.sweetwater.Game2;
import com.github.sweetwater.controller.ScrollViewController;
import com.github.sweetwater.event.GameEvent;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;

public class ScrollView2 extends Sprite
{
  private var viewWidth:Number = 800;
  private var viewHeight:Number = 100;

  private var frameThick:Number = 3;
  private var elementThick:Number = 2;
  private var spaceThick:Number = 1;

  private var cursorThick:Number = 4;
  private var cursorWidth:Number = 100;
  private var cursorHeight:Number = 80;

  private var _game:Game2;
  private var _elementNum:int;
  private var _cursor:Number;
  private var _barWidth:Number;
  private var _barHeight:Number;

  private var _controller:ScrollViewController;

  public function ScrollView2(game:Game2) {
    _game = game;

    _controller = new ScrollViewController(this);

    _game.addEventListener("Elements_initializeEvent", Elements_initialize);
    _game.addEventListener("Elements_updateEvent", Elements_update);

    _game.addEventListener("ScrollPosition_initializeEvent", ScrollPosition_initialize);
    _game.addEventListener("ScrollPosition_updateEvent", ScrollPosition_update);

    _game.addEventListener("Game_redrawEvent", draw);
  }

  public function get barRect():Rectangle {
    var left:Number = (viewWidth - _barWidth)/ 2;
    var top:Number = (viewHeight - _barHeight)/ 2;
    return new Rectangle(left, top, _barWidth, _barHeight);
  }

  public function get cursorRect():Rectangle {
    var base:Point = basePosition;
    var left:Number = base.x + _cursor - (cursorWidth / 2);
    var top:Number = (viewHeight - cursorHeight)/ 2;
    return new Rectangle(left, top, cursorWidth, cursorHeight);
  }

  private function get basePosition():Point {
    var baseX:Number = (viewWidth - _barWidth) / 2;
    var baseY:Number = (viewHeight - _barHeight) / 2;
    return new Point(baseX, baseY);
  }

  private function setElements(elements:Array):void {
    _elementNum = elements.length;
    var elementsWidth:Number = elementThick * _elementNum;
    var spacesWidth:Number = spaceThick * (_elementNum - 1);
    _barWidth = frameThick * 2 + elementsWidth + spacesWidth;
    _barHeight = 40;
  }
  private function setScrollPosition(scrollPosition:Number):void {
    _cursor = _barWidth * scrollPosition;
  }

  private function Elements_initialize(event:GameEvent):void {
    setElements(event.arg.elements);
  }
  private function Elements_update(event:GameEvent):void {
    setElements(event.arg.elements);
    draw();
  }

  private function ScrollPosition_initialize(event:GameEvent):void {
    setScrollPosition(event.arg.position);
  }
  private function ScrollPosition_update(event:GameEvent):void {
    setScrollPosition(event.arg.position);
    draw();
  }

  public function draw(event:GameEvent = null):void {
    var g:Graphics = this.graphics;
    g.clear();

    var base:Point = basePosition;

    // ビューのサイズの矩形を透明色で描画して
    // マウスヒットのサイズをビューサイズにする
    g.lineStyle(1, 0x000000, 0.0);
    g.beginFill(0x000000, 0.0);
    g.drawRect(0, 0, viewWidth, viewHeight);
    g.endFill();

    // バーの描画
    g.lineStyle(frameThick, 0x898989, 1.0);
    g.beginFill(0xFFFFFF, 1.0);
    g.drawRect(base.x, base.y, _barWidth, _barHeight);
    g.endFill();

    // セパレータの描画
    g.lineStyle(spaceThick, 0x898989, 1.0);
    for (var i:int = 0; i < _elementNum; i++) {
      // 線の太さの中心に描画されるため枠の太さ/2から書き始める
      var startX:Number = base.x + (frameThick/2) + elementThick;
      var lineX:Number = startX +(elementThick + spaceThick) * i;
      g.moveTo(lineX, base.y);
      g.lineTo(lineX, base.y + _barHeight);
    }

    // カーソルの描画
    var cursorRect:Rectangle = cursorRect;
    g.lineStyle(cursorThick, 0xFF0000, 1.0);
    g.drawRect(cursorRect.x, cursorRect.y, cursorRect.width, cursorRect.height);
  }
}
}