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
  #:use-module (gnu packages compression)
  #:use-module (guix build-system trivial)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp))

;;; Forgive me mr. Stallman for I have sinned.

(define-public firmware-nonfree
  (package
    (name "firmware-nonfree")
    (version "7d2c913dcd1be083350d97a8cb1eba24cfacbc8a")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url
"https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git")
                    (commit version)))
              (sha256
               (base32
                "1xwzsfa4x43z6s3284hmwgpxbvr15gg89bdanhg7i2xcll4xspxp"))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
                 #:builder (begin
                             (use-modules (guix build utils))
                             (let ((source (assoc-ref %build-inputs "source"))
                                   (fw-dir (string-append %output "/lib/firmware/")))
                               (mkdir-p fw-dir)
                               (copy-recursively source fw-dir)
                               #t))))
    (home-page "https://kernel.org/")
    (synopsis "Non-free firmware")
    (description "Non-free firmware")
    ;; FIXME: What license?
    (license non-copyleft)))


(define (linux-nonfree-urls version)
  "Return a list of URLs for Linux-Nonfree VERSION."
  (list (string-append
         "https://www.kernel.org/pub/linux/kernel/v4.x/"
         "linux-" version ".tar.xz")))


(define-public linux-nonfree
  (let* ((version "4.6"))
    (package
      (inherit linux-libre)
      (name "linux-nonfree")
      (version version)
      (source (origin
                (method url-fetch)
                (uri (linux-nonfree-urls version))
                (sha256
                 (base32
                  "0rnq4lnz1qsx86msd9pj5cx8v97yim9l14ifyac7gllabb6p2dx9"))))
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


(define-public linux-reiser4
  (let* ((version "4.11.12"))
    (package
      (inherit linux-libre)
      (name "linux-reiser4")
      (version version)
      (source (origin
                (method url-fetch)
                (uri (linux-nonfree-urls version))
                (sha256
                 (base32
                  "14k10g9w8dp3lmw1qjns395a2fcaq2iw1jijss5npxllh3hx8drf"))
                (patches (list (computed-file "reiser4-for-4.11.0.patch"
                                              (let ((compressed (origin (method url-fetch)
                                                                        (uri "https://downloads.sourceforge.net/project/reiser4/reiser4-for-linux-4.x/reiser4-for-4.11.0.patch.gz")
                                                                        (sha256 (base32 "1qc421bqassrxv7z5pzsnwsf9d5pz0azm96rykxh02xlrf8ig3hc")))))
                                                #~(system
                                                   (string-append #+(file-append gzip "/bin/gunzip")
                                                                  " < " #$compressed
                                                                  " > " #$output))))
                               (origin
                                (method url-fetch)
                                (uri "https://raw.githubusercontent.com/8p8c/my-guix/master/linux-reiser4enabled.patch")
                                (sha256
                                 (base32
                                  "0lcq896a3is3ycr0ajnx95m5z8qyjs29876yz6qm64z369di1wb5")))))))
      (synopsis "Linux with Reiser4 patch.")
      (description "Linux-Reiser4 is a kernel that supports Reiser4 FS.")
      (license gpl2)
      (home-page "https://reiser4.wiki.kernel.org/index.php/Main_Page"))))
