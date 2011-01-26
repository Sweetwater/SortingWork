package com.github.sweetwater.View
{

import com.github.sweetwater.Game2;
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
  private var boxWidth:Number = 30;
  private var boxHeight:Number = 30;
  private var spaceWidth:Number = 20;
  private var spaceHeight:Number = 30;

  private var bitmapBG:uint = 0x00FFFF;

  private var _game:Game2;
  private var _boxes:Array;

  public function WorkView(game:Game2)
  {
    _game = game;
    _game.addEventListener("ElementBelt_updateEvent", ElementBelt_update);
    _game.addEventListener("SelectIndex_changeEvent", SelectIndex_change);

    // ビューの幅から四角形の個数を計算する
    // 両端にマージンを設定する
    var mergin:Number = -20;
    var boxNum:int = (viewWidth - (mergin * 2)) / (boxWidth + spaceWidth);

    _boxes = new Array();
    for (var i:int = 0; i < boxNum; i++) {
      _boxes.push(new Object());
      _boxes[i].value = "";
      _boxes[i].draw = new Rectangle(0, 0, boxWidth, boxHeight);
      _boxes[i].collision = new Rectangle(0, 0, boxWidth, boxHeight);
    }
    fixeBoxPosition();
    draw();
  }

  public function fixeBoxPosition():void {
    var boxesWidth:Number = boxWidth * _boxes.length;
    var spacesWidth:Number = spaceWidth * (_boxes.length - 1);
    var mergin:Number = viewWidth - (boxesWidth + spacesWidth);
    var merginLeft:Number = mergin/2;
    for (var i:int = 0; i < _boxes.length; i++) {
      _boxes[i].draw.x = merginLeft + i * (boxWidth + spaceWidth);
      trace("x:" + _boxes[i].draw.x);
    }
  }

  public function ElementBelt_update(event:GameEvent):void {
    // TODO ベルトの描画を更新する
    var elementBelt:ElementBelt2 = event.arg.elementBelt;
    for (var i:int = 0; i < _boxes.length; i++) {
      _boxes[i].value = elementBelt.elements[i].value;
    }
    draw();
  }

  public function SelectIndex_change(event:Event):void {
    // TODO 選択中のやつの描画を更新する
    draw();
  }

  public function draw():void {
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

//      drawString(box, 0xFFFFFF);
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