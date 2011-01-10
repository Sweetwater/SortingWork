package com.github.sweetwater {
import flash.text.TextField;
import flash.display.Sprite;

/**
 * @author sweetwater
 */
[SWF(width="640", height="480", backgroundColor="#FF80FF", frameRate="31")]
public class SortingWork extends Sprite {
  private var _elements:Array;
  private var _tempBox:TempBox;
  private var _light:Light;
  private var _game:Game;
  static private var _text:TextField;

  public function SortingWork() {
    Game.initialize(stage);

    _text = new TextField();
    _text.text = "test";
    addChild(_text);

    //
  // var alphabet:String = "ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ";
  //
  // _elements = new Array();
  // for (var i:int = 0; i < 10; ++i) {
  // var element:Element = new Element(alphabet.charAt(i));
  // element.x = i * 60;
  // element.y = 120;
  // _elements.push(element);
  // stage.addChild(element);
  // }
  //
  // _tempBox = new TempBox();
  // _tempBox.x = 60;
  // _tempBox.y = 20;
  // stage.addChild(_tempBox);
  //
  // _light = new Light();
  // _light.x = 60;
  // _light.y = 68;
  // stage.addChild(_light);
  //
  // stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
  }

  public static function outputText(text:String):void {
    _text.text = text;
  }
  // private function onEnterFrame(event:Event):void {
  // for each (var element:Element in _elements) {
  // element.x -= 1;
  // if (element.x < 0) {
  // element.x += 600;
  // }
  // }
  // }
}
}
