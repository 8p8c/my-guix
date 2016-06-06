;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2013, 2014, 2015, 2016 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2014 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2014 Joshua Grant <tadni@riseup.net>
;;; Copyright © 2014 Alex Kost <alezost@gmail.com>
;;; Copyright © 2015 Sou Bunnbu <iyzsong@gmail.com>
;;; Copyright © 2015 Eric Dvorsak <eric@dvorsak.fr>
;;; Copyright © 2015 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2016 Nils Gillmann <niasterisk@grrlz.net>
;;; Copyright © 2016 Jookia <166291@gmail.com>
;;; Copyright © 2016 Eric Bavier <bavier@member.fsf.org>
;;; Copyright © 2016 Dmitry Nikolaev <cameltheman@gmail.com>
;;;
;;; This file is not part of GNU Guix yet. ;;FIXME
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

(define-module (font-hack)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages zip))

(define-public font-hack
  (package
    (name "font-hack")
    (version "2.020")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/chrissimpkins/Hack/releases/download/v"
                    version
                    "/Hack-v"
                    (string-replace-substring version "." "_")
                    "-ttf.zip"))
              (sha256
               (base32
                "16kkmc3psckw1b7k07ccn1gi5ymhlg9djh43nqjzg065g6p6d184"))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder (begin
                   (use-modules (guix build utils)
                                (srfi srfi-26))

                   (let ((PATH     (string-append (assoc-ref %build-inputs
                                                             "unzip")
                                                  "/bin"))
                         (font-dir (string-append %output
                                                  "/share/fonts/truetype"))
                         (doc-dir  (string-append %output "/share/doc/"
                                                  ,name "-" ,version)))
                     (setenv "PATH" PATH)
                     (system* "unzip" (assoc-ref %build-inputs "source"))

                     (mkdir-p font-dir)
                     (mkdir-p doc-dir)
                     (for-each (lambda (ttf)
                                 (copy-file ttf
                                            (string-append font-dir "/" ttf)))
                               (find-files "." "\\.ttf$"))
                     (for-each (lambda (doc)
                                 (copy-file doc
                                            (string-append doc-dir "/" doc)))
                               (find-files "." "\\.txt$"))))))
    (native-inputs `(("source" ,source)
                     ("unzip" ,unzip)))
    (home-page "https://sourcefoundry.org/hack/")
    (synopsis "A typeface designed for sourcecode.")
    (description "The Hack Font is designed for the screen.")
    (license
     (license:x11-style
      "https://github.com/chrissimpkins/Hack/blob/master/LICENSE.md"
      "Hack Open Font License v2.0"))))
