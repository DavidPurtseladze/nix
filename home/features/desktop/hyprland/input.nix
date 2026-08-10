/*
  Mirrors the source repo's configs/input.conf.
*/
{
  input = {
    kb_layout = "us";
    kb_variant = "";
    kb_model = "";
    kb_rules = "";
    kb_options = "ctrl:nocaps";
    follow_mouse = 1;

    touchpad = {
      natural_scroll = true;
    };

    sensitivity = 0;
  };

  # Touchpad 3-finger workspace swipe. Off before, on to match upstream.
  gestures = {
    workspace_swipe = true;
  };
}
