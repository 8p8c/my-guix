;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015 Eric Dvorsak <eric@dvorsak.fr>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (i3)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (gnu packages linux)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system perl)
  #:use-module (gnu packages base)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages asciidoc)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages m4)
  #:use-module (gnu packages docbook)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages maths)
  #:use-module (guix download)
  #:use-module (guix git-download))

(define-public xcb-util-cursor
  (package
    (name "xcb-util-cursor")
    (version "0.1.2")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://xcb.freedesktop.org/dist/xcb-util-cursor-" version ".tar.gz"))
              (sha256
               (base32
                "0bm0mp99abdfb6v4v60hq3msvk67b2x9ml3kbx5y2g18xdhm3rdr"))))
    (build-system gnu-build-system)
    (native-inputs
     `(("m4" ,m4)
       ("pkg-config" ,pkg-config)))
    (inputs
     `(("libxcb" ,libxcb)
       ("xcb-util-renderutil" ,xcb-util-renderutil)
       ("xcb-util-image" ,xcb-util-image)))
    (home-page "http://cgit.freedesktop.org/xcb/util-cursor/")
    (synopsis "Port of libxcursor")
    (description "Port of libxcursor.")
    (license
     (non-copyleft
      "file://COPYING"
      "See COPYING in the distribution."))))


(define-public libyajl
  (package
    (name "libyajl")
    (version "2.1.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/lloyd/yajl/archive/" version ".tar.gz"))
              (sha256
               (base32
                "0nmcqpaiq4pv7dymyg3n3jsd57yhp5npxl26a1hzw3m3lmj37drz"))))
    (build-system cmake-build-system)
    (home-page "https://lloyd.github.io/yajl/")
    (synopsis "C library for parsing JSON")
    (description "Yet Another JSON Library.  YAJL is a small
event-driven (SAX-style) JSON parser written in ANSI C, and a small
validating JSON generator.")
    (license isc)))


(define-public perl-pod-simple
  (package
    (name "perl-pod-simple")
    (version "3.30_1")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://search.cpan.org/CPAN/authors/id/M/MA/MARCGREEN/Pod-Simple-"
                                  version
                                  ".tar.gz"))
              (sha256
               (base32
                "0yzy7mw2jriwcywmh38csjqrwxj207b2b7rlpvkdh1rq5828hary"))))
    (build-system perl-build-system)
    (home-page "http://search.cpan.org/~marcgreen/Pod-Simple/lib/Pod/Simple.pod")
    (synopsis "Parsing library for text in Pod format")
    (description "Pod::Simple is a Perl library for parsing text in
the Pod (plain old documentation) markup language that is typically
used for writing documentation for Perl and for Perl modules.")
    (license (package-license perl))))


(define-public libsn
  (package
    (name "libsn")
    (version "0.12")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://www.freedesktop.org/software/startup-notification/releases/startup-notification-"
                                  version
                                  ".tar.gz"))
              (sha256
               (base32
                "0jmyryrpqb35y9hd5sgxqy2z0r1snw7d3ljw0jak0n0cjdz1yf9w"))))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("libx11" ,libx11)
       ("xcb-util" ,xcb-util)))
    (build-system gnu-build-system)
    (home-page "https://wiki.freedesktop.org/www/Software/startup-notification/")
    (synopsis "Reference implementation of the startup notification protocol")
    (description "Startup-notification contains a reference
implementation of the startup notification protocol.  The reference
implementation is mostly under an X Window System style license, and
has no special dependencies.")
    (license gpl2)))


(define-public libev
  (package
    (name "libev")
    (version "4.20")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://dist.schmorp.de/libev/libev-"
                                  version
                                  ".tar.gz"))
              (sha256
               (base32
                "17j47pbkr65a18mfvy2861p5k7w4pxmdgiw723ryfqd9gx636w7q"))))
    (build-system gnu-build-system)
    (home-page "http://software.schmorp.de/pkg/libev.html")
    (synopsis "An event loop that is loosely modelled after libevent")
    (description "A full-featured and high-performance event loop that
is loosely modelled after libevent, but without its limitations and
bugs.  It is used in GNU Virtual Private Ethernet, rxvt-unicode,
auditd, the Deliantra MORPG Server and Client, and many other
programs.")
    (license
     (non-copyleft
      "file://LICENSE"
      "See LICENSE in the distribution."))))


(define-public libconfuse
  (package
    (name "libconfuse")
    (version "2.7")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://savannah.nongnu.org/download/confuse/confuse-"
                                  version
                                  ".tar.gz"))
              (sha256
               (base32 "0y47r2ashz44wvnxdb18ivpmj8nxhw3y9bf7v9w0g5byhgyp89g3"))))
    (build-system gnu-build-system)
    (home-page "http://www.nongnu.org/confuse/")
    (synopsis "Configuration file parser library")
    (description "A configuration file parser library. It supports
sections and (lists of) values (strings, integers, floats, booleans or
other sections), as well as some other features (such as
single/double-quoted strings, environment variable expansion,
functions and nested include statements).  It makes it very easy to
add configuration file capability to a program using a simple API. ")
    (license isc)))


;;; undeclared libl dependency caused this error during build :

;; ld: /gnu/store/shi6xf1psgkjyfps4x2572m6qwxf4lf3-libiw-30.pre9/lib/libiw.a(iwlib.so): undefined reference to symbol 'trunc@@GLIBC_2.2.5'
;; /gnu/store/w29667jfv02s1hgmv0yp7nqyywvdv1fz-glibc-2.21/lib/libm.so.6: error adding symbols: DSO missing from command line
;; collect2: error: ld returned 1 exit status

(define-public i3status
  (package
    (name "i3status")
    (version "2.9")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://i3wm.org/i3status/i3status-" version ".tar.bz2"))
              (sha256
               (base32
                "1qwxbrga2fi5wf742hh9ajwa8b2kpzkjjnhjlz4wlpv21i80kss2"))))
    (build-system gnu-build-system)
    (arguments
     `(#:make-flags (list "CC=gcc" (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'check))))
    (inputs
     `(("openlibm" ,openlibm)
       ("libconfuse" ,libconfuse)
       ("libyajl" ,libyajl)
       ("alsa-lib" ,alsa-lib)
       ("wireless-tools" ,wireless-tools)
       ("libcap" ,libcap)
       ("asciidoc" ,asciidoc)))
    (home-page "http://i3wm.org/i3status/")
    (synopsis "Generating a status bar for i3bar, dzen2, xmobar or similar programs")
    (description "i3status is a small program for generating a status
bar for i3bar, dzen2, xmobar or similar programs.  It is designed to
be very efficient by issuing a very small number of system calls, as
one generally wants to update such a status line every second. This
ensures that even under high load, your status bar is updated
correctly.  Also, it saves a bit of energy by not hogging your CPU as
much as spawning the corresponding amount of shell commands would.")
    (license bsd-3)))


(define-public i3
  (package
    (name "i3")
    (version "4.10.3")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://i3wm.org/downloads/i3-" version ".tar.bz2"))
              (sha256
               (base32
                "1lq7h4w7m0hi31iva8g7yf1sc11ispnknxjdaj9agld4smxqb44j"))))
    (build-system gnu-build-system)
    (arguments
     `(#:make-flags (list "CC=gcc" (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (delete 'check))))
    (inputs
     `(("libxcb" ,libxcb)
       ("xcb-util" ,xcb-util)
       ("xcb-util-cursor" ,xcb-util-cursor)
       ("xcb-util-keysyms" ,xcb-util-keysyms)
       ("xcb-util-wm" ,xcb-util-wm)
       ("libxkbcommon" ,libxkbcommon)
       ("libev" ,libev)
       ("libyajl" ,libyajl)
       ("asciidoc" ,asciidoc)
       ("xmlto" ,xmlto)
       ("perl-pod-simple" ,perl-pod-simple)
       ("docbook-xml" ,docbook-xml)
       ("libx11" ,libx11)
       ("pcre" ,pcre)
       ("libsn" ,libsn)
       ("pango" ,pango)
       ("cairo" ,cairo)))
    (native-inputs
     `(("which" ,which)
       ("perl" ,perl)
       ("pkg-config" ,pkg-config)))
    (home-page "http://i3wm.org/")
    (synopsis "Improved tiling window manager")
    (description "i3 is a tiling window manager, completely written
from scratch.  The target platforms are GNU/Linux and BSD operating
systems, our code is Free and Open Source Software (FOSS) under the
BSD license.  i3 is primarily targeted at advanced users and
developers.")
    (license bsd-3)))
