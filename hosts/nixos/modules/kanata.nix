{ pkgs, config, ... }: {
  services.kanata = {
    enable = true;
    keyboards.main = {
      devices = [
        "/dev/input/by-id/usb-Keebio_Quefrency_Rev._4-event-kbd"
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
  ;; tap for capslk, hold for lctl
  cap (tap-hold-press 200 5000 esc (layer-toggle esc-layer))
  ;; cap (multi esc (layer-while-held esc-layer))
  cmd (multi lmet (layer-while-held cmd-layer))

  ;; Map meta -> control 
  ca C-a
  cb C-b
  cc C-c
  cd C-d
  ce C-e
  cf C-f
  cg C-g
  ch C-h
  ci C-i
  cj C-j
  ck C-k
  cl C-l
  cm C-m
  cn C-n
  co C-o
  cp C-p
  cq C-q
  cr C-r
  cs C-s
  ct C-t
  cu C-u
  cv C-v
  cw C-w
  cx C-x
  cy C-y
  cz C-z

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
  @cap a    s    d    f    g    h    j    k    l    ;    '    ret           
  lsft z    x    c    v    b    n    m    ,    .    /    rsft                     up
  lctl lalt @cmd           spc                           ralt rmet rctl     left  down rght)
(deflayer cmd-layer
  _    _    _    _    _    _    _    _    _    _    _    _    _             _     _     _
  _    _    _    _    _    _    _    _    _    _    _    _    _    _        _     _     _
  _    @cq  @cw  @ce  @cr  @ct  @cy  @cu  @ci  @co  @cp  _    _    _        _     _     _
  _    @ca  @cs  @cd  @cf  @cg  @ch  @cj  @ck  @cl  _    _    _             
  lsft    @cz  @cx  @cc  @cv  @cb  @cn  @cm  _    _    _    _                     _
  _    _    _              _                             _    _    _        _     _     _
)
(deflayer esc-layer
  _    _    _    _     _    _    _    _    _  _    _    _    _             _     _    _
  _    _    _    _     _    _    _    _    _  _    _    _    _    _        _     _    _
  _    _    _    @jmpr _    _    _    _    _  _    _    _    _    _        _     _    _
  _    _    _    _     _    _    left down up rght _    _    _             
  _    _    @del _     _    @jmpl     ret  _    _  _    _    _                        _
  _    _    _              _                             _    _    _        _     _    _
)


	'';
    };
  };
}

