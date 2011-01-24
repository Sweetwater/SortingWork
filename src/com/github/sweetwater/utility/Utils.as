package com.github.sweetwater.utility
{
public class Utils
{
  public static function toColor(a:int, r:int, g:int, b:int):uint {
    return  (0x000000FF & a) << 24 |
            (0x000000FF & r) << 16 |
            (0x000000FF & g) <<  8 |
            (0x000000FF & b);
  }

  public function Utils()
    {
  }
}
}