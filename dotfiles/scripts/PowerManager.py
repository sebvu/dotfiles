import os
import sys

"""
Prints Help
"""


def help():
    print(
        """LenovoPowerManager: [options]

Options:
    --bs, --battery-saver
    --ic, --intelligent-cooling
    --ep, --extreme-performance
    """
    )


"""
Activates Intelligent Cooling
"""


def activate_ic():
    os.system("echo '\_SB.PCI0.LPC0.EC0.VPC0.DYTC 0x0012B001' > /proc/acpi/call")
    print("Activated Intelligent Cooling!")


"""
Activates Extreme Performance
"""


def activate_ep():
    os.system(
        "sudo su -c \"echo '\_SB.PCI0.LPC0.EC0.VPC0.DYTC 0x0012B001' > /proc/acpi/call\""
    )
    print("Activated Extreme Performance!")


"""
Activates Battery Saver
"""


def activate_bs():
    os.system(
        "sudo su -c \"echo '\_SB.PCI0.LPC0.EC0.VPC0.DYTC 0x0013B001' > /proc/acpi/call\""
    )
    print("Activated Battery Saver")


def main():
    if os.geteuid() != 0:
        print("This script must be run as root!")
        exit(-1)

    os.system("modprobe acpi_call")

    if sys.argv[-1] == "--ic" or sys.argv[-1] == "--intelligent-cooling":
        activate_ic()

    elif sys.argv[-1] == "--bs" or sys.argv[-1] == "--battery-saver":
        activate_bs()

    elif sys.argv[-1] == "--ep" or sys.argv[-1] == "--extreme-performance":
        activate_ep()

    else:
        help()


if __name__ == "__main__":
    main()
