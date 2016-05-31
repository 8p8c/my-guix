;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2012, 2013, 2014, 2015 Ludovic CourtÃ¨s <ludo@gnu.org>
;;; Copyright © 2013, 2014 Andreas Enge <andreas@enge.fr>
;;; Copyright © 2012 Nikita Karetnikov <nikita@karetnikov.org>
;;; Copyright © 2014, 2015 Mark H Weaver <mhw@netris.org>
;;; Copyright © 2015 Federico Beffa <beffa@fbengineering.ch>
;;; Copyright © 2015 Taylan Ulrich BayÄ±rlÄ±/Kammer <taylanbayirli@gmail.com>
;;; Copyright © 2015 Andy Wingo <wingo@igalia.com>
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

(define-module (linux-nonfree)
  #:use-module ((guix licenses) #:hide (zlib))
  #:use-module (gnu packages linux)
  #:use-module (guix build-system trivial)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix download))

;;; Forgive me Stallman for I have sinned.

(define-public radeon-RS780-firmware-non-free
  (package
    (name "radeon-RS780-firmware-non-free")
    (version "f6c767f398fc34a89d05d970ed04e21b781fc33f")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git")
                      (commit version)))
              (sha256
               (base32
                "1lpqigsw93xswcxw9ykxmms2smx86070mg51jqpf7n9w9h6jjs79"))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder (begin
                   (use-modules (guix build utils))
                   (let ((source (assoc-ref %build-inputs "source"))
                         (fw-dir (string-append %output "/lib/firmware/radeon/")))
                     (mkdir-p fw-dir)
                     (for-each (lambda (file)
                                 (copy-file file
                                            (string-append fw-dir "/"
                                                           (basename file))))
                               (find-files source "R600_rlc\\.bin|RS780_.*\\.bin$|LICENSE.radeon"))
                     #t))))

    (home-page "")
    (synopsis "Non-free firmware for Radeon integrated chips")
    (description "Non-free firmware for Radeon integrated chips")
    ;; FIXME: What license?
    (license (non-copyleft "http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git;a=blob_plain;f=LICENCE.radeon_firmware;hb=HEAD"))))

(define-public RTL8188CE-firmware-non-free
  (package
    (name "RTL8188CE-firmware-non-free")
    (version "f6c767f398fc34a89d05d970ed04e21b781fc33f")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git")
                      (commit version)))
              (sha256
               (base32
		"1lpqigsw93xswcxw9ykxmms2smx86070mg51jqpf7n9w9h6jjs79"))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder (begin
                   (use-modules (guix build utils))
                   (let ((source (assoc-ref %build-inputs "source"))
                         (fw-dir (string-append %output "/lib/firmware/rtlwifi/")))
                     (mkdir-p fw-dir)
                     (for-each (lambda (file)
                                 (copy-file file
                                            (string-append fw-dir "/"
                                                           (basename file))))
                               (find-files source "rtl8192.*\\.bin$|LICENCE.rtlwifi_firmware.txt"))
                     #t))))

    (home-page "")
    (synopsis "Non-free firmware for Realtek WiFi chips")
    (description "Non-free firmware for Realtek WiFi chips")
    ;; FIXME: What license?
    (license (non-copyleft "http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git;a=blob_plain;f=LICENCE.rtlwifi_firmware;hb=HEAD"))))

(define (linux-nonfree-urls version)
  "Return a list of URLs for Linux-Nonfree VERSION."
  (list (string-append
         "https://www.kernel.org/pub/linux/kernel/v4.x/"
         "linux-" version ".tar.xz")))

(define-public linux-nonfree
  (let* ((version "4.1.24"))
    (package
      (inherit linux-libre)
      (name "linux-nonfree")
      (version version)
      (source (origin
                (method url-fetch)
                (uri (linux-nonfree-urls version))
                (sha256
                 (base32
                  "1pvq082014riwn5dj8phy6pgbyy5xdxlksw6h6s3pymdjrzpphlw"))))
      (synopsis "Mainline Linux kernel, nonfree binary blobs included.")
      (description "Linux is a kernel.")
      (license gpl2)
      (home-page "http://kernel.org/"))))

(define-public perf-nonfree
  (package
    (inherit perf)
    (name "perf-nonfree")
    (version (package-version linux-nonfree))
    (source (package-source linux-nonfree))
    (license (package-license linux-nonfree))))
