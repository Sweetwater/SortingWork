package com.github.sweetwater {

import com.github.sweetwater.View.DefragView2;
import com.github.sweetwater.View.ScrollView2;
import com.github.sweetwater.View.TempWindow2;
import com.github.sweetwater.View.WorkView;
import com.github.sweetwater.event.GameEvent;
import com.github.sweetwater.model.Element2;
import com.github.sweetwater.model.ElementBelt2;
import com.github.sweetwater.model.SelectPosition;

import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Rectangle;

import flashx.textLayout.formats.FormatValue;

/**
 * @author sweetwater
 */
public class Game2 extends EventDispatcher {

  private static var _instance:Game2;
  public static function get instance():Game2 {
    return _instance;
  }
  public static function initialize(stage:Stage):void {
    _instance = new Game2(stage);
  }

  private var _stage:Stage;
  private var _selectPosition:SelectPosition;
  private var _scrollPosition:Number;
  private var _elements:Array;
  private var _elementBelt:ElementBelt2;

  private var _tempWindow:TempWindow2;
  private var _tempBox:TempBox;
  private var _eventDispatcher:EventDispatcher;

  private var _workView:WorkView;
  private var _scrollView:ScrollView2;
  private var _defragView:DefragView2;

  public function Game2(stage:Stage) {
    _stage = stage;

    _scrollPosition = 0.5;

    _elements = Element2.CreateElements(200);
    _elementBelt = new ElementBelt2(_elements);

    _selectPosition = SelectPosition.None;
//    _elementBelt = new ElementBelt(this, stage);
//    _elementBelt.initialize(_elements);

    _tempBox = new TempBox();
    stage.addChild(_tempBox);

    new TempBoxController(_stage, _tempBox);

    _eventDispatcher = new EventDispatcher();

    stage.addEventListener(Event.ENTER_FRAME, function(event:Event):void {
      dispatchEvent(new Event("updateFrame"));
    });

    _workView = new WorkView(this);
    _stage.addChild(_workView);

    _scrollView = new ScrollView2(this);
    _scrollView.y = 350;
    _stage.addChild(_scrollView);

    _defragView = new DefragView2(this);
    _defragView.y = 500;
    _stage.addChild(_defragView);

    dispatchEvent(new GameEvent("Elements_initializeEvent", {elements:_elements}));
    dispatchEvent(new GameEvent("ElementBelt_initializeEvent", {elementBelt:_elementBelt}));
    dispatchEvent(new GameEvent("ScrollPosition_initializeEvent", {position:_scrollPosition}));
    dispatchEvent(new GameEvent("SelectPosition_initializeEvent", {position:_selectPosition}));

    dispatchEvent(new GameEvent("Game_redrawEvent"));
  }

  public function execute(command:Command):Object {
    var result:Object = null;
    switch (command.type) {
      case "ScrollPosition_moveCommand":
        execute_ScrollPosition_move(command.arg);
        break;
      case "SelectPosition_selectCommand":
        execute_SelectPosition_select(command.arg);
        break;



      case "game_beltToBox":
        execute_game_beltToBox(command.arg);
        break;
      case "game_boxToBelt":
        execute_game_boxToBelt(command.arg);
        break;
      case "tempBox_move":
        execute_tempBox_move(command.arg);
        break;
      case "tempBox_pop":
        result = execute_tempBox_pop();
        break;
      case "tempBox_push":
        execute_tempBox_push(command.arg);
        break;
      case "elementBelt_insert":
        execute_elementBelt_insert(command.arg);
        break;
      case "elementBelt_remove":
        result = execute_elementBelt_remove(command.arg);
        break;
    }
    return result;
  }

  private function execute_ScrollPosition_move(arg:Object):void {
    var moveX:Number = arg.moveX;

    _scrollPosition += moveX;
    if (_scrollPosition < 0.0) _scrollPosition = 0.0;
    if (_scrollPosition > 1.0) _scrollPosition = 1.0;

    dispatchEvent(new GameEvent("ScrollPosition_updateEvent", {position:_scrollPosition}));
  }

  private function execute_SelectPosition_select(arg:Object):void {
    var selectPosition:SelectPosition = arg.position;
    _selectPosition = selectPosition;
    dispatchEvent(new GameEvent("SelectPosition_selectEvent", {position:_selectPosition}));
  }

  private function execute_game_beltToBox(arg:Object):void {
    // TODO オブジェクトを直接指定せずIDにする
    // TODO 操作を変更する
    if (_tempBox.element != null) return;

    var target:Element = searchLightingElement();
    if (target == null) return;

    var index:int = _elementBelt.elements.indexOf(target);
    execute(new Command("elementBelt_remove", {"index":index}));
    execute(new Command("tempBox_push", {"target":target}));
  }

  private function execute_game_boxToBelt(arg:Object):void {
    var index:int = searchInsertIndex();

    if (index < 0) return;
    var element:Object = execute(new Command("tempBox_pop"));

    if (element == null) return;
    execute(new Command("elementBelt_insert", {"index":index, "target":element}));
  }

  private function execute_elementBelt_remove(arg:Object):Element2 {
    return null;//_elementBelt.remove(arg.index);
  }

  private function execute_elementBelt_insert(arg:Object):void {
    //_elementBelt.insert(arg.index, arg.target);
  }

  private function execute_tempBox_move(arg:Object):void {
    _tempBox.move(arg.moveX);
  }

  private function execute_tempBox_pop():Element {
    return _tempBox.pop();
  }

  private function execute_tempBox_push(arg:Object):void {
    _tempBox.push(arg.target);
  }

  public function searchLightingElement():Element {
    // Lightに半分以上重なっているElementを探す
    var lightBounds:Rectangle = _tempBox.light.getBounds(_stage);
    for each (var element:Element in _elementBelt.elements) {
      var bounds:Rectangle = element.getBounds(_stage);
      var interRect:Rectangle = lightBounds.intersection(bounds);
      if (interRect.width >= bounds.width / 2 ||
        interRect.height != 0) {
        return element;
      }
    }
    return null;
  }

  private function searchInsertIndex():int {
    // 左端座標を比較して挿入位置を探索する
    if (_tempBox.element == null) return -1;

    var popBounding:Rectangle = _tempBox.element.getBounds(_stage);
    for (var i:int = 0; i < _elementBelt.elements.length; i++) {
      var element:Element = _elementBelt.elements[i];
      var bounds:Rectangle = element.getBounds(_stage);
      if (bounds.x > popBounding.x) {
        return i;
      }
    }
    return _elementBelt.elements.length;
  }
}
}
