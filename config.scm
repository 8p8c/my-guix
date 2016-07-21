;; System reconfiguratin command below:
;; GUIX_PACKAGE_PATH=/home/camel/git/my-guix/packages/ guix system reconfigure --fallback /home/camel/git/my-guix/config.scm
(use-modules (gnu)
             (gnu packages admin)
             (gnu packages audacity)
             (gnu packages audio)
             (gnu packages fonts)
             (gnu packages gl)
             (gnu packages gnome)
             (gnu packages gnuzilla)
             (gnu packages guile)
             (gnu packages java)
             (gnu packages linux)
             (gnu packages ntp)
             (gnu packages pulseaudio)
             (gnu packages ruby)
             (gnu packages screen)
             (gnu packages slim)
             (gnu packages suckless)
             (gnu packages version-control)
             (gnu packages video)
             (gnu packages wget)
             (gnu packages wicd)
             (gnu packages wm)
             (gnu packages xdisorg)
             (gnu packages xorg)
             (gnu packages zip)
             (gnu services)
             (gnu services avahi)
             (gnu services dbus)
             (gnu services desktop)
             (gnu services xorg)
             (gnu system nss)
             (guix gexp)
             (guix monads)
             (guix store)
             (srfi srfi-1)
             (font-hack)
             (linux-nonfree)
             (java-certs)
             (xorg-ati))
;; (use-service-modules xorg ati avahi dbus desktop networking ssh)
;; (use-package-modules admin certs slim xorg)
(use-service-modules avahi dbus networking ssh)
(use-package-modules admin certs ntp)

(define libinput.conf "
# Use the libinput driver for all event devices
Section \"InputClass\"
	Identifier \"libinput keyboard catchall\"
	MatchIsKeyboard \"on\"
	MatchDevicePath \"/dev/input/event*\"
	Driver \"libinput\"
	Option \"XkbLayout\" \"us,ru\"
	Option \"XkbOptions\" \"grp_led:scroll,grp:caps_toggle,grp:lwin_compose\"
EndSection
")

(operating-system
  (kernel linux-nonfree)
  (firmware (cons* radeon-RS780-firmware-non-free RTL8188CE-firmware-non-free %base-firmware))
  (host-name "camelot")
  (timezone "Europe/Moscow")
  (locale "en_US.UTF-8")

  (bootloader (grub-configuration (device "/dev/sda")))
  (file-systems (cons (file-system
                        (device "root")
                        (title 'label)
                        (mount-point "/")
                        (type "ext4"))
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
             alsa-utils
             audacity
             avidemux
             evince
             font-dejavu
             font-hack
             font-inconsolata
             font-liberation
             font-terminus
             font-ubuntu
             git
             htop
             i3-wm
             icecat
             icedtea
             jack-2
             java-certs
             lm-sensors
             mesa
             mesa-utils
             nss-certs ;for HTTPS access
             pavucontrol
             perf-nonfree
             recordmydesktop
             ruby
             rxvt-unicode
             screen
             slim
             tcpdump
             vlc
             wget
             wicd
             wpa-supplicant
             xf86-input-evdev
             xf86-video-ati
             xf86-video-fbdev
             xf86-video-modesetting
             xorg-server
             xsensors
             unzip
             %base-packages))

  (services
   (cons*
    (lsh-service #:port-number 2222)
    (gnome-desktop-service)
    (xfce-desktop-service)
    (console-keymap-service "ru")
    (slim-service
     #:allow-empty-passwords? #f #:auto-login? #f
     #:startx (xorg-start-command
               #:configuration-file
               (xorg-configuration-file
                #:extra-config (list libinput.conf)
                #:drivers '("radeon" "vesa")
                #:resolutions
                '((1366 768) (1024 768)))))

    (screen-locker-service slock)
    (screen-locker-service xlockmore "xlock")
    ;; The D-Bus clique.
    (avahi-service)
    (wicd-service)
    (udisks-service)
    (upower-service)
    (colord-service)
    (geoclue-service)
    (polkit-service)
    (elogind-service)
    (dbus-service)
    (ntp-service)
    %base-services))
    ;; (remove (lambda (service)
    ;;           (eq? (service-kind service) slim-service-type))
    ;;         %desktop-services)))
  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
