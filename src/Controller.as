package {
/**
 * @author sweetwater
 */
public class Controller {

  private var game:Game;

  public function Controller() {
  }

  public function onDrug():void {
    // TODO マウス入力が成立したら
    game.execute(new Command("pop", "0"));
    game.execute(new Command("push", "0"));
  }
}
}
