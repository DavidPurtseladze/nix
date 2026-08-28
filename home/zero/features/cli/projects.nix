{lib, ...}: {
  home.activation.createProjectDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $VERBOSE_ARG \
      "$HOME/Documents/Projects/WebIntelligence" \
      "$HOME/Documents/Projects/Worklink" \
      "$HOME/Documents/Projects/OpenSource" \
      "$HOME/Documents/Projects/Personal"
  '';
}
