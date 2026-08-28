{...}: {
  programs.git.includes = [
    {
      condition = "gitdir:~/Documents/Projects/WebIntelligence/";
      contents.user.email = "d.phurtseladze@webintelligence.de";
    }
    {
      condition = "gitdir:~/Documents/Projects/Worklink/";
      contents.user.email = "dpurtseladze@digitech.marketing";
    }
    {
      condition = "gitdir:~/Documents/Projects/OpenSource/";
      contents.user.email = "dphurtseladze@gmail.com";
    }
    {
      condition = "gitdir:~/Documents/Projects/Personal/";
      contents.user.email = "dphurtseladze@gmail.com";
    }
  ];
}
