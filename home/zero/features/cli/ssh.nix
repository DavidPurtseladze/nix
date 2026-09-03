{...}: {
  programs.ssh.settings = {
    "github.com" = {
      IdentitiesOnly = true;
      IdentityFile = "~/.ssh/zero";
    };
    "github.com-webintelligence" = {
      HostName = "github.com";
      User = "git";
      IdentitiesOnly = true;
      IdentityFile = "~/.ssh/webintelligence";
    };
    "github.com-worklink" = {
      HostName = "github.com";
      User = "git";
      IdentitiesOnly = true;
      IdentityFile = "~/.ssh/worklink";
    };
    "bitbucket.org" = {
      User = "git";
      IdentitiesOnly = true;
      IdentityFile = "~/.ssh/webintelligence";
    };
  };
}
