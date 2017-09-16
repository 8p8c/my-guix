(define-module (xawtv)
  #:use-module (guix licenses)
  #:use-module (gnu packages)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages image)
  #:use-module (gnu packages video)
  #:use-module (gnu packages base)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages fontutils)
  #:use-module (guix build-system gnu)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp))

(define-public xawtv
  (package
   (name "xawtv")
   (version "3.103")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://linuxtv.org/downloads/xawtv/xawtv-"
                                version ".tar.bz2"))
            (sha256
             (base32
              "0lnxr3xip80g0rz7h6n14n9d1qy0cm56h0g1hsyr982rbldskwrc"))))
   (arguments
    `(#:phases
      (modify-phases %standard-phases
                     (add-before 'configure 'pre-configure
                                 (lambda _
                                   ;; Don't change the ownership of any file at this time.
                                   (substitute* '("Makefile.in")
                                                ((" -o root") ""))
                                   (substitute* '("configure")
                                                (("/usr/lib/X11") (string-append  %output "/usr/lib/X11")))
                                   #t)))
      #:configure-flags (list "--enable-xft")
      #:tests? #f)) ;no check target
   (build-system gnu-build-system)
   (inputs
    `(("ncurses" ,ncurses)
      ("libjpeg", libjpeg)
      ("alsa-lib" ,alsa-lib)
      ("v4l-utils" ,v4l-utils)
      ("glibc" ,glibc)
      ("libx11" ,libx11)
      ("libxt" ,libxt)
      ("libxaw" ,libxaw)
      ("libxmu" ,libxmu)
      ("libxpm" ,libxpm)
      ("libxext" ,libxext)
      ("libxv" ,libxv)
      ("perl" ,perl)
      ("fontconfig" ,fontconfig)
      ("fontsproto" ,fontsproto)
      ("xproto" ,xproto)
      ("xextproto" ,xextproto)))
   (synopsis "Watch television at the PC")
   (description "Watch television or webcam at the PC")
   (home-page "https://linuxtv.org/")
   (license gpl2)))
