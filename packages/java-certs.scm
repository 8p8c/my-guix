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

(define-module (java-certs)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages))


(define-public java-certs
  (package
    (name "java-certs")
    (version "1.0")
    (source
     (origin
      (method url-fetch)
      (uri "file:///home/camel/git/guix-packages/cacerts")
      (sha256
       (base32
        "1ksxkbvhx1ga6yr5l7h6yxx5kqnvk1cxbyg8d7xd55anbaq8vi6x"))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder
       (begin
         (use-modules (guix build utils))
         (let ((source (assoc-ref %build-inputs "source"))
               (certsdir (string-append %output "/etc/ssl/certs/java")))
           (mkdir-p certsdir)
           (copy-file source (string-append certsdir "/cacerts"))))))
    (native-inputs
     `(("source" ,source)))
    (home-page "")
    (synopsis "Java CA certificates from Debian")
    (description
     "This package provides certificates for Certification Authorities (CA)
taken from the NSS package and thus ultimately from the Mozilla project.")
  (license license:gpl2+)))
