let 
  ayu-mirage = {
      slug = "ayu-mirage";
      scheme = "Ayu Mirage";
      author = "unknown";
      base00 = "#191e2a";
      base08 = "#686868";
      base01 = "#ed8274";
      base09 = "#f28779";
      base02 = "#a6cc70";
      base0A = "#bae67e";
      base03 = "#fad07b";
      base0B = "#ffd580";
      base04 = "#6dcbfa";
      base0C = "#73d0ff";
      base05 = "#cfbafa";
      base0D = "#d4bfff";
      base06 = "#90e1c6";
      base0E = "#95e6cb";
      base07 = "#c7c7c7";
      base0F = "#ffffff";
    };
  kanagawa = {
    slug = "kanagawa-edit";
    scheme = "Kanagawa (Edited)";
    author = "unknown";
    base00 = "1F1F28"; #1F1F28
    base01 = "98BB6C"; #D8616A
    base02 = "98BB6C"; #98BB6C
    base03 = "98BB6C"; #FF8700
    base04 = "98BB6C"; #7E9CD8
    base05 = "9C86BF"; #9C86BF
    base06 = "76d4d6"; #76d4d6
    base07 = "b3b9c5"; #b3b9c5
    base08 = "777c85"; #777c85
    base09 = "f2777a"; #f2777a
    base0A = "92d192"; #92d192
    base0B = "ffeea6"; #ffeea6
    base0C = "76d4d6"; #76d4d6
    base0D = "e1a6f2"; #e1a6f2
    base0E = "76d4d6"; #76d4d6
    base0F = "ffffff"; #ffffff

  };
in
{
  config.scheme = ayu-mirage;
}
