package com.github.sweetwater.View
{

import com.github.sweetwater.Element;
import com.github.sweetwater.Game2;
import com.github.sweetwater.controller.WorkViewController;
import com.github.sweetwater.event.GameEvent;
import com.github.sweetwater.model.ElementBelt2;
import com.github.sweetwater.model.SelectPosition;
import com.github.sweetwater.utility.TextDrawer;
import com.github.sweetwater.utility.Utils;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class WorkView extends Sprite
{
  private var viewWidth:Number = 800;
  private var viewHeight:Number = 300;
  private var boxY:Number = 200;
  private var boxWidth:Number = 30;
  private var boxHeight:Number = 30;
  private var spaceWidth:Number = 20;
  private var selectFrameThick:Number = 3;

  private var bitmapBG:uint = 0x00FFFF;

  private var _game:Game2;
  private var _viewport:Number;
  private var _viewportMask:Shape;
  private var _selectPosition:SelectPosition;
  private var _boxTable:Object;
  private var _boxes:Array;
  private var _boxesWidth:Number;
  private var _workViewController:WorkViewController;

  public function get boxes() : Array {
    return _boxes;
  }

  public function WorkView(game:Game2)
  {
    _game = game;

    _viewportMask = new Shape();
    this.mask = _viewportMask;

    _selectPosition = SelectPosition.None;
    _workViewController = new WorkViewController(this);

    _game.addEventListener("Elements_initializeEvent", onElements_initialize);
    _game.addEventListener("ElementBelt_initializeEvent", onElementBelt_initialize);

    _game.addEventListener("ScrollPosition_initializeEvent", onScrollPosition_initialize);
    _game.addEventListener("ScrollPosition_updateEvent", onScrollPosition_update);

    _game.addEventListener("SelectPosition_initializeEvent", onSelectPosition_initialize);
    _game.addEventListener("SelectPosition_selectEvent", onSelectPosition_select);

    _game.addEventListener("Game_redrawEvent", draw);
  }

  private function setBoxTable(elements:Array):void {
    _boxTable = new Object();
    for (var i:int = 0; i < elements.length; i++) {
      var object:Object = new Object();
      object.value = elements[i].value;
      object.draw = new Rectangle(0, 0, boxWidth, boxHeight);
      object.collision = new Rectangle(0, 0, boxWidth, boxHeight);

      var key:Object = elements[i].value;
      _boxTable[key] = object;
    }
  }

  private function setBoxes(elements:Array):void {
    _boxes = new Array();
    for (var i:int = 0; i < elements.length; i++) {
      var key:Object = elements[i].value;
      var object:Object = _boxTable[key];
      _boxes.push(object);
    }
    fixDrawPosition();
    fixCollisionPosition();
  }

  private function setViewPort(scroll:Number):void {
    _viewport = scroll * _boxesWidth;
    fixDrawPosition();
    fixCollisionPosition();
  }

  private function setSelectPosition(position:SelectPosition):void {
    _selectPosition = position;
  }

  private function get boxesBaseX():Number {
    var centerX:Number = viewWidth / 2;
    var baseX:Number = centerX - _viewport;
    return baseX;
  }

  public function get boxesWidth():Number {
    return _boxesWidth;
  }

  private function fixDrawPosition() : void {
    var baseX:Number = boxesBaseX;
    for (var i:int = 0; i < _boxes.length; i++) {
      var x:Number = baseX + i * (boxWidth + spaceWidth);
      var y:Number = boxY;
      var drawBox:Rectangle = _boxes[i].draw;
      drawBox.x = x;
      drawBox.y = y;
    }
    _boxesWidth = (boxWidth + spaceWidth) * _boxes.length;
  }

  private function fixCollisionPosition() : void {
    var baseX:Number = boxesBaseX;
    for (var i:int = 0; i < _boxes.length; i++) {
      var x:Number = baseX + i * (boxWidth + spaceWidth);
      var y:Number = boxY;
      var collisionBox:Rectangle = _boxes[i].collision;
      collisionBox.x = x;
      collisionBox.y = y;
    }
  }

  private function onElements_initialize(event:GameEvent):void {
    setBoxTable(event.arg.elements);
  }

  private function onElementBelt_initialize(event:GameEvent):void {
    setBoxes(event.arg.elementBelt.elements);
  }

  private function onScrollPosition_initialize(event:GameEvent):void {
    setViewPort(event.arg.position);
  }

  private function onScrollPosition_update(event:GameEvent):void {
    setViewPort(event.arg.position);
    draw();
  }

  private function onSelectPosition_initialize(event:GameEvent):void {
    setSelectPosition(event.arg.position);
  }

  private function onSelectPosition_select(event:GameEvent):void {
    setSelectPosition(event.arg.position);
    draw();
  }

  private function ElementBelt_update(event:GameEvent):void {
    // TODO ベルトの描画を更新する
    var elementBelt:ElementBelt2 = event.arg.elementBelt;
    for (var i:int = 0; i < _boxes.length; i++) {
      _boxes[i].value = elementBelt.elements[i].value;
    }
    draw();
  }

  private function SelectIndex_change(event:Event):void {
    // TODO 選択中のやつの描画を更新する
    draw();
  }

  private function draw(event:GameEvent = null):void {
    // マスクの描画
    var maskG:Graphics = _viewportMask.graphics;
    maskG.clear();
    maskG.lineStyle(2, viewFrameColor, 1.0);
    maskG.beginFill(0xFFFFFF);
    maskG.drawRect(0, 0, viewWidth, viewHeight);
    maskG.endFill();

    var g:Graphics = graphics;
    g.clear();

    // ビュー枠の描画
    var viewFrameColor:uint = Utils.toColor(255, 255, 127, 39);
    var viewBGColor:uint = Utils.toColor(255, 239, 228, 176);
    g.lineStyle(2, viewFrameColor, 1.0);
    g.beginFill(viewBGColor, 1.0);
    g.drawRect(0, 0, viewWidth, viewHeight);
    g.endFill();

    // エレメントの描画
    for each (var box:Object in _boxes) {
      var drawBox:Rectangle = box.draw;
      g.lineStyle(2, 0x000000, 1.0);
      g.beginFill(0x808080, 1.0);
      g.drawRect(drawBox.x, drawBox.y, drawBox.width, drawBox.height);
      g.endFill();

      TextDrawer.draw(g, box.value, drawBox.x, drawBox.y, 0xFFFFFF);
    }

    // 選択枠を表示
    switch (_selectPosition.type) {
    case SelectPosition.TYPE_ELEMENT:
      drawElementFrame(g, _selectPosition.elementNumber);
      break;
    case SelectPosition.TYPE_SPACE:
      drawSpaceFrame();
      break;
    case SelectPosition.TYPE_NONE:
      break;
    }
  }

  private function drawElementFrame(g:Graphics, elementNumber:int) : void {
    var box:Object = _boxes[elementNumber];
    var boxRect:Rectangle = box.draw;
    var frameRect:Rectangle = new Rectangle();
    frameRect.x = boxRect.x - selectFrameThick / 2;
    frameRect.y = boxRect.y - selectFrameThick / 2;
    frameRect.width = boxRect.width + selectFrameThick;
    frameRect.height = boxRect.height + selectFrameThick;

    g.lineStyle(selectFrameThick, 0xFF0000);
    g.drawRect(frameRect.x, frameRect.y, frameRect.width, frameRect.height);
  }

  private function drawSpaceFrame() : void {
  }

}
}