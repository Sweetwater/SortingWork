package com.github.sweetwater.model
{
import com.github.sweetwater.Element;
import com.github.sweetwater.model.Element2;

public class Element2
{
  public static function CreateElements(num:int):Array {
    var elements:Array = new Array();
    for (var i:int  = 0; i < 1000; i++) {
      var value:String = i.toString();
      if (i < 10) value = "  " + value;
      if (i < 100) value = " " + value;
      var element:Element2 = new Element2(value);
      elements.push(element);
    }

    var shuffled:Array = new Array();
    for (var i2:int  = 0; i2 < num; i2++) {
      var index:int = Math.random() * elements.length;
      var element2:Element2 = elements.splice(index, 1)[0];
      shuffled.push(element2);
    }

    return shuffled;
  }

  private var _value:String;
  public function get value():String {
    return _value;
  }

  public function Element2(value:String)
  {
    _value = value;
  }

}
}