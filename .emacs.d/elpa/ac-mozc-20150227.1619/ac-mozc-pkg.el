;; -*- no-byte-compile: t; lexical-binding: nil -*-
(define-package "ac-mozc" "20150227.1619"
  "Auto-complete sources for Japanese input using Mozc."
  '((cl-lib        "0.5")
    (auto-complete "1.4")
    (mozc          "0"))
  :url "https://github.com/igjit/ac-mozc"
  :commit "4c6c8be4701010d9362184437c0f783e0335c631"
  :revdesc "4c6c8be47010"
  :authors '(("igjit" . "igjit1@gmail.com"))
  :maintainers '(("igjit" . "igjit1@gmail.com")))
