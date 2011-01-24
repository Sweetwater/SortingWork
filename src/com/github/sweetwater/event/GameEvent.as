package com.github.sweetwater.event
{
import flash.events.Event;

public class GameEvent extends Event
{
  private var _arg:Object;

  public function GameEvent(type:String, arg:Object = null) {
    super(type);
    _arg = arg;
  }

  public function get arg():Object {
    return _arg;
  }
}
}