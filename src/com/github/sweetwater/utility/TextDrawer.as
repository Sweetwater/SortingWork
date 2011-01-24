package com.github.sweetwater.utility
{
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormat;

public class TextDrawer
{
  private static var _hashList:Object;
  private static function initialize():void {
    _hashList = new Object();
  }

  private static var boxWidth:Number = 40;
  private static var boxHeight:Number = 40;
  private static var bgColor:uint = 0xFF00FF;

  private var _textFormat:TextFormat;
  private var _textField:TextField;
  private var _bitmap:BitmapData;
  private var _matrix:Matrix;
  private var _rect:Rectangle;

  public function TextDrawer()
  {
    _textFormat = new TextFormat();
    _textFormat.font = "MS ゴシック";
    _textFormat.size = 22;
    _textFormat.leftMargin = 0;
    _textFormat.letterSpacing = -1;

    _textField = new TextField();
    _textField.antiAliasType = AntiAliasType.ADVANCED;

    _bitmap = new BitmapData(boxWidth, boxHeight, true, bgColor);
    _matrix = new Matrix();
    _matrix.identity();
    _rect = new Rectangle(0, 0, boxWidth, boxHeight);
  }

  public static function draw(g:Graphics, text:String, x:Number, y:Number, color:uint):void {
    if (_hashList == null) initialize();
    if (_hashList.hasOwnProperty(text) == false) {
      _hashList[text] = new TextDrawer();
    }
    var drawer:TextDrawer = _hashList[text];
    drawer._textFormat.color = color;
    drawer._textField.text = text;
    drawer._textField.setTextFormat(drawer._textFormat);

    drawer._bitmap.fillRect(drawer._rect, bgColor);
    drawer._bitmap.draw(drawer._textField, null, null, null, null, true);

    drawer._matrix.tx = x -3;
    drawer._matrix.ty = y;
    g.beginBitmapFill(drawer._bitmap, drawer._matrix, false, true);
    g.lineStyle();
    g.drawRect(x, y, boxWidth, boxHeight);
    g.endFill();
  }
}
}