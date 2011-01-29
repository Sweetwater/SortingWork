package com.github.sweetwater.model
{
import flash.geom.Point;

public class SelectPosition
{
  public static function Element(number:int) : SelectPosition {
    var position:SelectPosition = new SelectPosition();
    position._elementNumber = number;
    position._type = TYPE_ELEMENT;
    return position;
  }

  public static function Space(left:int, right:int) : SelectPosition {
    var position:SelectPosition = new SelectPosition();
    position._leftNumber = left;
    position._rightNumber = right;
    position._type = TYPE_SPACE;
    return position;
  }

  public static var _none:SelectPosition;
  public static function get None() : SelectPosition {
    if (_none == null) _none = new SelectPosition();
    return _none;
  }

  public static const TYPE_ELEMENT:int = 0;
  public static const TYPE_SPACE:int = 1;
  public static const TYPE_NONE:int = 2;

  private var _type:int;
  private var _elementNumber:int;
  private var _leftNumber:int;
  private var _rightNumber:int;

  public function SelectPosition()
  {
    _type = TYPE_NONE;
    _elementNumber = -1;
    _leftNumber = -1;
    _rightNumber = -1;
  }

  public function get type() : int {
    return _type;
  }

  public function get elementNumber() : int {
    return _elementNumber;
  }

  public function get leftNumber() : int {
    return _leftNumber;
  }

  public function get rightNumber() : int {
    return _rightNumber;
  }

  public function isElement() : Boolean {
    return _type == TYPE_ELEMENT;
  }

  public function isSpace() : Boolean {
    return _type == TYPE_SPACE;
  }

  public function isNone() : Boolean {
    return _type == TYPE_NONE;
  }

  public function hasLeftNumber(): Boolean {
    return _leftNumber > 0;
  }

  public function hasRightNumber() : Boolean {
    return _rightNumber > 0;
  }

  public function equals(position:SelectPosition) : Boolean {
    if (this.type != position.type) return false;
    switch (this.type) {
    case TYPE_ELEMENT:
      return (this.elementNumber == position.elementNumber);

    case TYPE_SPACE:
      var equalLeft:Boolean = (this.leftNumber == position.leftNumber);
      var equalRight:Boolean = (this.rightNumber == position.rightNumber);
      return (equalLeft && equalRight);

    case TYPE_NONE:
      return (this == position);
    }
    return false;
  }

}
}



