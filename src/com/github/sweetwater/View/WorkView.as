package com.github.sweetwater.View
{

import com.github.sweetwater.Game2;
import com.github.sweetwater.controller.WorkViewController;
import com.github.sweetwater.event.GameEvent;
import com.github.sweetwater.model.ElementBelt2;
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

  private var bitmapBG:uint = 0x00FFFF;

  private var _game:Game2;
  private var _viewport:Number;
  private var _viewportMask:Shape;
  private var _boxTable:Object;
  private var _boxes:Array;
  private var _boxesWidth:Number;
  private var _workViewController:WorkViewController;

  public function WorkView(game:Game2)
  {
    _game = game;

    _viewportMask = new Shape();
    this.mask = _viewportMask;

    _workViewController = new WorkViewController(this);

    _game.addEventListener("Elements_initializeEvent", onElements_initialize);
    _game.addEventListener("ElementBelt_initializeEvent", onElementBelt_initialize);

    _game.addEventListener("ScrollPosition_initializeEvent", onScrollPosition_initialize);
    _game.addEventListener("ScrollPosition_updateEvent", onScrollPosition_update);

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
      var x:Number = i * (boxWidth + spaceWidth);
      var y:Number = boxY;
      object.draw.x = x;
      object.draw.y = y;
      object.collision.x = x;
      object.collision.y = y;
      _boxes.push(object);
    }
    _boxesWidth = (boxWidth + spaceWidth) * elements.length;
  }

  private function setViewPort(scroll:Number):void {
    _viewport = scroll * _boxesWidth;
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
    var centerX:Number = viewWidth / 2;
    var startX:Number = centerX - _viewport;
    for each (var box:Object in _boxes) {
      var drawBox:Rectangle = box.draw;
      g.lineStyle(2, 0x000000, 1.0);
      g.beginFill(0x808080, 1.0);
      g.drawRect(startX + drawBox.x, drawBox.y, drawBox.width, drawBox.height);
      g.endFill();

      TextDrawer.draw(g, box.value, startX + drawBox.x, drawBox.y, 0xFFFFFF);
    }
  }

  private var shape:Shape = new Shape();
  private var bitmapData:BitmapData = new BitmapData(40, 40, true, 0x00FFFF);
  private var bitmap:Bitmap = new Bitmap(bitmapData);
  private var textField:TextField = new TextField();
  private var textFormat:TextFormat = new TextFormat();
  private var matrix:Matrix = new Matrix();
  private function drawString(box:Object, color:uint):void {
    textFormat.font = "MS ゴシック";
    textFormat.color = color;
    textFormat.size = 22;
    textFormat.indent =
    textFormat.leftMargin = 0;
    textFormat.letterSpacing = -1;

    textField.text = box.value;
    textField.setTextFormat(textFormat);
    textField.antiAliasType = flash.text.AntiAliasType.ADVANCED;
    textField.embedFonts = false;

    // TODO ビットマップデータを使いまわさないよう変更する
    box.bitmap.fillRect(new Rectangle(0, 0, boxWidth, boxHeight), 0x00FFFF);
    box.bitmap.draw(textField, null, null, null, null, true);

    var g:Graphics = graphics;
    matrix.tx = box.draw.x -3;
    matrix.ty = box.draw.y;
    g.beginBitmapFill(box.bitmap, matrix, false, true);
    g.lineStyle();
    g.drawRect(x, y, boxWidth, boxHeight);
    g.endFill();
  }
}
}