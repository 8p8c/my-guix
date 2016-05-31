;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2014 Taylan Ulrich Bayirli/Kammer <taylanbayirli@gmail.com>
;;; Copyright © 2013, 2014, 2015 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2014, 2015 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2014 Alex Kost <alezost@gmail.com>
;;; Copyright © 2015 Federico Beffa <beffa@fbengineering.ch>
;;; Copyright © 2015 Ricardo Wurmus <rekado@elephly.net>
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

(define-module (emacs-circe)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system emacs)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages lesstif)
  #:use-module (gnu packages image)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages w3m)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages acl)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages mp3)
  #:use-module (guix utils)
  #:use-module (srfi srfi-1))


(define-public emacs-circe
  (package
   (name "emacs-circe")
   (version "2.0")
   (source (origin
            (method url-fetch)
            (uri (string-append
                  "https://github.com/jorgenschaefer/circe/archive/v"
                  version ".tar.gz"))
            (sha256
             (base32
              "0pf4mqy4m55jqk8i21r5jmxr6azq9ai3j162ik0gia0xd80s0p63"))))
   (build-system emacs-build-system)
   (home-page "http://www.nongnu.org/circe/")
   (synopsis "Client for IRC in Emacs")
   (description
    "Circe is a Client for IRC in Emacs. It integrates well with the rest
of the editor, using standard Emacs key bindings and indicating
activity in channels in the status bar so it stays out of your way
unless you want to use it.
")
   (license license:gpl3+)))

(define-public emacs-async
  (package
   (name "emacs-async")
   (version "1.3")
   (source
    (origin
     (method url-fetch)
     (uri (string-append
           "https://github.com/jwiegley/emacs-async/archive/v"
           version ".tar.gz"))
     (sha256
      (base32
       "1yzasjrp6yw6l840j3ryapkyziwrq5c6np35zxgb4hhvb47qaq0x"))))
   (build-system emacs-build-system)
   (home-page "https://github.com/jwiegley/emacs-async")
   (synopsis "Asynchronous processing in Emacs")
   (description
    "Adds the ability to call asynchronous functions and process with ease.  See
the documentation for `async-start' and `async-start-process'.")
   (license license:gpl3+))
  )

(define-public emacs-helm
  (package
   (name "emacs-helm")
   (version "1.7.5")
   (source
    (origin
     (method url-fetch)
     (uri (string-append
           "https://github.com/emacs-helm/helm/archive/v" version
           ".tar.gz"))
     (sha256
      (base32
       "1hpjjl4j4zd8n19sw6j693a5pr04a1a7i3x0rhw4hgh6lvd7yxah"))))
   (build-system emacs-build-system)
   (inputs
    `(("emacs-async" ,emacs-async)))
   (home-page "https://emacs-helm.github.io/helm/")
   (synopsis
    "Helm is an Emacs incremental and narrowing framework")
   (description "Helm is incremental completion and selection narrowing framework for Emacs. It will help steer you in the right direction when you're looking for stuff in Emacs (like buffers, files, etc).")
   (license license:gpl3+)))

(define-public emacs-helm-circe
  (package
   (name "emacs-helm-circe")
   (version "0.3")
   (source
    (origin
     (method url-fetch)
     (uri (string-append
           "https://github.com/lesharris/helm-circe/archive/v"
           version ".tar.gz"))
     (sha256
      (base32
       "0ndi4g60cvwppsgcw1jgaxmwk53r6w93n7rgy204f2bwk8ahkd9s"))))
   (build-system emacs-build-system)
   (inputs
    `(("emacs-helm" ,emacs-helm)
      ("emacs-circe" ,emacs-circe)))
   (home-page
    "https://github.com/lesharris/helm-circe")
   (synopsis "Helm circe buffer management.")
   (description
    "Jump to Circe buffers easily with Helm.  A call to `helm-circe` will show a list of circe channel and server
buffers allowing you to switch channels easily as well as remove circe buffers.  Largely based on helm-mt by Didier Deshommes")
   (license license:gpl3+))
  )
