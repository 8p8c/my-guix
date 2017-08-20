(use-modules (gnu)
             (gnu system nss)
             (linux-nonfree))
(use-service-modules networking ssh)
(use-package-modules admin)

(operating-system
  (kernel linux-reiser4)
  (initrd (lambda (fs . args)
            (apply base-initrd fs
                   #:extra-modules '("reiser4.ko")
                   args)))
  (firmware (cons*
             firmware-nonfree
             %base-firmware))
  (host-name "camillo")
  (timezone "Europe/Moscow")
  (locale "en_US.utf8")

  ;; Assuming /dev/sdX is the target hard disk, and "root" is
  ;; the label of the target root file system.
  (bootloader (grub-configuration (device "/dev/sdc")))
  (mapped-devices
   (list (mapped-device
          (source (uuid "LUKSUUIDHERE"))
          (target "luks")
          (type luks-device-mapping))))
  (file-systems (cons (file-system
                        (device "root")
                        (title 'label)
                        (mount-point "/")
                        (type "reiser4")
                        (dependencies mapped-devices))
                      %base-file-systems))

  ;; This is where user accounts are specified.  The "root"
  ;; account is implicit, and is initially created with the
  ;; empty password.
  (users (cons (user-account
                (name "camel")
                (comment "Camel")
                (group "users")

                ;; Adding the account to the "wheel" group
                ;; makes it a sudoer.  Adding it to "audio"
                ;; and "video" allows the user to play sound
                ;; and access the webcam.
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video"))
                (home-directory "/home/camel"))
               %base-user-accounts))

  ;; Globally-installed packages.
  (packages (cons tcpdump %base-packages))

  ;; Add services to the baseline: a DHCP client and
  ;; an SSH server.
  (services (cons* (dhcp-client-service)
                   (service openssh-service-type
                            (openssh-configuration
                              (port-number 2222)))
                   %base-services)))
