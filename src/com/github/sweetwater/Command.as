package com.github.sweetwater {
/**
 * @author sweetwater
 */
public class Command {
  private var _type:String;
  private var _arg:Object;

  public function Command(type:String, arg:Object = null) {
    _type = type;
    _arg = arg;
  }

  public function get type():String {
    return _type;
  }

  public function get arg():Object {
    return _arg;
  }
}
}
