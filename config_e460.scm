(use-modules (gnu)
             (gnu system nss)
             (linux-nonfree)
             (xawtv))
(use-service-modules desktop)
(use-package-modules avr
                     admin
                     base
                     bootloaders
                     certs
                     compression
                     emacs
                     file
                     fonts
                     gimp
                     gnome
                     gnuzilla
                     java
                     linux
                     music
                     perl
                     php
                     pulseaudio
                     python
                     ruby
                     ssh
                     version-control
                     video
                     vpn
                     wget
                     xorg)

(operating-system
  (kernel linux-reiser4)
  (initrd (lambda (fs . args)
            (apply base-initrd fs
                   #:extra-modules '("reiser4.ko")
                   args)))
 (firmware (cons*
            firmware-nonfree
            %base-firmware))
 (host-name "camelot")
 (timezone "Europe/Moscow")
 (locale "en_US.utf8")

 (bootloader (grub-configuration (grub grub-efi)
                                 (device "/dev/sda1")))

 (mapped-devices
  (list (mapped-device
         (source (uuid "e0fe011c-7932-4645-9872-72ee47b18d89"))
         (target "luks")
         (type luks-device-mapping))))

 (file-systems (cons* (file-system
                       (device "root")
                       (title 'label)
                       (mount-point "/")
                       (type "ext4")
                       (dependencies mapped-devices))
                      (file-system
                       (device "/dev/sda1")
                       (mount-point "/boot/efi")
                       (type "vfat"))
                      %base-file-systems))

 (users (cons (user-account
               (name "camel")
               (comment "Camel")
               (group "users")
               (supplementary-groups '("wheel" "netdev"
                                       "audio" "video"))
               (home-directory "/home/camel"))
              %base-user-accounts))

 ;; This is where we specify system-wide packages.
 (packages (cons* 
                  bridge-utils
                  emacs
                  file
                  font-hack
                  gimp
                  git
                  gnome-tweak-tool
                  gvfs              ;for user mounts
                  htop
                  icecat            ;Firefox
                  icedtea
                  lsh
                  nss-certs         ;for HTTPS access
                  obs
                  openvpn
                  pavucontrol
                  perl
                  php
                  pulseaudio
                  python
                  ruby
                  sudo
                  tuxguitar
                  unzip
                  vlc
                  wget
                  which
                  xawtv
                  xfontsel
                  xlsfonts
                  zip
                  %base-packages))

 ;; Add GNOME and/or Xfce---we can choose at the log-in
 ;; screen with F1.  Use the "desktop" services, which
 ;; include the X11 log-in service, networking with Wicd,
 ;; and more.
 (services (cons* (gnome-desktop-service)
                  %desktop-services))

 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
