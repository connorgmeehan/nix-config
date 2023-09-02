{ pkgs, config, ... }: {
  services.kanata = {
    enable = true;
    keyboards.main = {
      devices = [
        "/dev/input/by-id/usb-Keebio_Quefrency_Rev._4-event-kbd"
        "/dev/input/by-id/usb-CM_Storm_Side_print-event-kbd"
        "/dev/input/by-id/usb-TUCustomStation_TU42A_Keyboard_TU_CUSTOMED_KEYBOARD-event-kbd"
      ];
      config = 
        ''
(defsrc
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12           prtsc slck pause
  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc     ins   home pgup
  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \        del   end  pgdn    
  caps a    s    d    f    g    h    j    k    l    ;    '    ret           
  lsft z    x    c    v    b    n    m    ,    .    /    rsft                     up
  lctl lalt lmet           spc                           ralt rmet rctl     left  down rght
)

;; defalias is used to declare a shortcut for a more complicated action to keep
;; the deflayer declarations clean and aligned. The alignment in deflayers is not
;; necessary, but is strongly recommended for ease of understanding visually.
;;
;; Aliases are referred to by `@<alias_name>`.
(defalias
  cmd (tap-hold-press 200 5000 lmet (layer-toggle cmd-layer))

  ;; Map meta -> control 
  ca (macro C-(a))
  cb (macro C-(b))
  cc (macro C-(c))
  cd (macro C-(d))
  ce (macro C-(e))
  cf (macro C-(f))
  cg (macro C-(g))
  ch (macro C-(h))
  ci (macro C-(i))
  cj (macro C-(j))
  ck (macro C-(k))
  cl (macro C-(l))
  cm (macro C-(m))
  cn (macro C-(n))
  co (macro C-(o))
  cp (macro C-(p))
  cq (macro C-(q))
  cr (macro C-(r))
  cs (macro C-(s))
  ct (macro C-(t))
  cu (macro C-(u))
  cv (macro C-(v))
  cw (macro C-(w))
  cx (macro C-(x))
  cy (macro C-(y))
  cz (macro C-(z))
  tab (macro M-tab M-tab)
  jmpl C-left
  jmpr C-rght
  del del
)

;; The first layer defined is the layer that will be active by default when
;; kanata starts up. This layer is the standard QWERTY layout except for the
;; backtick/grave key (@grl) which is an alias for a tap-hold key.
;;
;; There are currently a maximum of 25 layers allowed.
(deflayer qwerty
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12           prtsc slck pause
  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc     ins   home pgup
  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \        del   \    pgdn    
  caps a    s    d    f    g    h    j    k    l    ;    '    ret           
  lsft z    x    c    v    b    n    m    ,    .    /    rsft                     up
  lctl lalt @cmd           spc                           ralt rmet rctl     left  down rght)
(deflayer cmd-layer
  _    _    _    _    _    _    _    _    _    _    _    _    _             _     _     _
  _    _    _    _    _    _    _    _    _    _    _    _    _    _        _     _     _
  @tab @cq  @cw  @ce  @cr  @ct  @cy  @cu  @ci  @co  @cp  _    _    _        _     _     _
  _    @ca  @cs  @cd  @cf  @cg  @ch  @cj  @ck  @cl  _    _    _             
  lsft    @cz  @cx  @cc  @cv  @cb  @cn  @cm  _    _    _    _                     _
  _    _    _              _                             _    _    _        _     _     _
)

	'';
    };
  };
}

