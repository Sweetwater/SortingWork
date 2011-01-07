package {
import flash.display.Shape;
import flash.text.TextFormatAlign;
import flash.text.TextFormat;
import flash.text.TextField;
import flash.display.Graphics;
import flash.display.Sprite;

/**
 * @author sweetwater
 */
public class Element extends Sprite {
  public function Element(text:String) {
  	var shape:Shape = new Shape();
    var g:Graphics = shape.graphics;
    var color:uint = 0x8080FF;
    g.clear();
    g.beginFill(color, 1.0);
    g.lineStyle(1, color, 1.0, true);
    g.drawRect(0, 0, 40, 40);
    g.endFill();
    this.addChild(shape);

    var textField:TextField = new TextField();
    textField.x = 0;
    textField.y = 0;
    textField.width = 40;
    textField.height = 40;
    textField.selectable = false;
    var textFormat:TextFormat = textField.defaultTextFormat;
    textFormat.size = 32;
    textFormat.align = TextFormatAlign.CENTER;
    textFormat.font = "MSゴシック";
    textField.defaultTextFormat = textFormat;
    textField.text = text;
    this.addChild(textField);
  }
}
}
