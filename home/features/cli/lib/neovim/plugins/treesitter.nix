{
  config,
  lib,
  ...
}:
lib.mkIf config.features.cli.neovim.enable {
  programs.nixvim.plugins.treesitter = {
    enable = true;

    settings = {
      highlight.enable = true;
      indent.enable = true;
    };

    grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
      html
      css
      javascript
      typescript
      tsx
      php
      blade
      go
      rust

      lua
      vim
      vimdoc
      query
      bash
      json
      yaml
      markdown
      markdown_inline
      regex
    ];
  };
}
