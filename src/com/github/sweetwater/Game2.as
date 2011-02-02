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
  private var _eventDispatcher:EventDispatcher;

  private var _workView:WorkView;
  private var _scrollView:ScrollView2;
  private var _defragView:DefragView2;

  public function Game2(stage:Stage) {
    _stage = stage;

    _scrollPosition = 0.5;

//    _elements = Element2.CreateElements(10, 1000);
    _elements = Element2.CreateElements(10, 10);
    _elementBelt = new ElementBelt2(_elements);

    _selectPosition = SelectPosition.None;
//    _elementBelt = new ElementBelt(this, stage);
//    _elementBelt.initialize(_elements);

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
      case "ElementBelt_swapCommand":
        execute_ElementBelt_swap(command.arg);
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

    // TODO : スワップかどうかの判定をコントローラに出す

    if (_selectPosition.isNone()) {
      // 選択しているものがないなら選択する
      _selectPosition = selectPosition;
      dispatchEvent(new GameEvent("SelectPosition_selectEvent", {position:_selectPosition}));
    }
    else if (_selectPosition.equals(selectPosition)) {
      // 同じものを選択したら選択を解除する
      _selectPosition = SelectPosition.None;
      dispatchEvent(new GameEvent("SelectPosition_selectEvent", {position:_selectPosition}));
    }
    else {
      // 違うものを選択したら場所を入れ替える
      execute(new Command("ElementBelt_swapCommand", {select1:_selectPosition, select2:selectPosition}));

      _selectPosition = SelectPosition.None;
      dispatchEvent(new GameEvent("SelectPosition_selectEvent", {position:_selectPosition}));
    }
  }

  private function execute_ElementBelt_swap(arg:Object):void {
    var select1:SelectPosition = arg.select1;
    var select2:SelectPosition = arg.select2;

    if (select1.isNone()) return;
    if (select2.isNone()) return;

    if (select1.isElement() && select2.isElement()) {
      // エレメント同士ならエレメントの入れ替え
      swapElement(select1, select2);
    }
    else if (select1.isSpace() && select2.isElement()) {
      // 片方がスペースならスペースに挿入
      insertElement(select1, select2);
    }
    else if (select1.isElement() && select2.isSpace()) {
      // 片方がスペースならスペースに挿入
      insertElement(select2, select1);
    }
  }

  private function swapElement(select1:SelectPosition, select2:SelectPosition) : void {
    var number1:int = select1.elementNumber;
    var number2:int = select2.elementNumber;

    var element1:Element2 = _elementBelt.elements[number1];
    var element2:Element2 = _elementBelt.elements[number2];
    _elementBelt.elements[number1] = element2;
    _elementBelt.elements[number2] = element1;

    dispatchEvent(new GameEvent("ElementBelt_swapEvent", {elementBelt:_elementBelt}));
  }

  private function insertElement(selectSpace:SelectPosition, selectElement:SelectPosition) :void {
    var elementNumber:int = selectElement.elementNumber;
    var element:Element2 = _elementBelt.elements[elementNumber];
    if (selectSpace.hasRightNumber()) {
      var insertNumber:int = selectSpace.rightNumber;
      if (elementNumber < insertNumber) {
        _elementBelt.elements.splice(insertNumber, 0, element);
        _elementBelt.elements.splice(elementNumber, 1);
      }
      else {
        _elementBelt.elements.splice(elementNumber, 1);
        _elementBelt.elements.splice(insertNumber, 0, element);
      }
    }
    else {
      _elementBelt.elements.splice(elementNumber, 1);
      _elementBelt.elements.push(element);
    }

    dispatchEvent(new GameEvent("ElementBelt_swapEvent", {elementBelt:_elementBelt}));
  }
}
}
