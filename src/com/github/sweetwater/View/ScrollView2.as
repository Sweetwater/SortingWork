package com.github.sweetwater.View
{
import com.github.sweetwater.Game2;
import com.github.sweetwater.event.GameEvent;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;

public class ScrollView2 extends Sprite
{
  private var frameThick:Number = 3;
  private var elementThick:Number = 2;
  private var spaceThick:Number = 1;

  private var _game:Game2;
  private var _barWidth:Number;
  private var _barHeight:Number;

  public function ScrollView2(game:Game2) {
    _game = game;
    _game.addEventListener("Elements_update", Elements_update);
  }

  public function Elements_update(evnet:GameEvent):void {
    var elements:Array = evnet.arg.elements;
    var elementsWidth:Number = elementThick * elements.length;
    var spacesWidth:Number = spaceThick * (elements.length - 1);
    _barWidth = frameThick * 2 + elementsWidth + spacesWidth;
    _barHeight = 20;
    draw();
  }

  public function draw():void {
    var g:Graphics = this.graphics;

    // バーの描画
    g.lineStyle(2, 0x898989, 1.0);
    g.beginFill(0xFFFFFF, 1.0);
    g.drawRect(0, 0, _barWidth, _barHeight);
    g.endFill();
  }
}
}