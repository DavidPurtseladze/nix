/*
  Mirrors the source repo's configs/UserAnimations.conf.
*/
{
  animations = {
    enabled = true;
    bezier = [
      "myBezier, 0.05, 0.9, 0.1, 1.05"
      "been, 0.24, 0.9, 0.25, 0.91"
      "been2, 0, .94, .5, .99"
      "menu_decel, 0.1, 1, 0, 1"
      "linear, 0.0, 0.0, 1.0, 1.0"
      "wind, 0.05, 0.9, 0.1, 1.05"
      "winIn, 0.1, 1.1, 0.1, 1.1"
      "winOut, 0.3, -0.3, 0, 1"
      "slow, 0, 0.85, 0.3, 1"
      "overshot, 0.7, 0.6, 0.1, 1.1"
      "bounce, 1.1, 1.6, 0.1, 0.85"
    ];
    animation = [
      "windowsIn, 1, 5, slow, popin"
      "windowsOut, 1, 7, been, popin 70%"
      "windowsMove, 1, 5, wind, slide"
      "border, 1, 1, linear"
      "fade, 1, 5, overshot"
      "workspaces, 1, 5, wind"
      "windows, 1, 5, bounce, popin"
    ];
  };
}
