#!/usr/bin/perl -w

use strict;
use Fcntl;

use constant {
	STATUS_NONE => 0,
	STATUS_STOP => 1,
	STATUS_REREAD => 2,
	CDROMEJECT => 0x5309,
	CDROM_DRIVE_STATUS => 0x5326,
	CDROM_DISC_STATUS  => 0x5327,
	CDS_NO_INFO => 0,
	CDS_NO_DISC => 1,
	CDS_TRAY_OPEN => 2,
	CDS_DRIVE_NOT_READY => 3,
	CDS_DISC_OK => 4,
	CDS_AUDIO => 100,
	CDS_DATA_1 => 101,
	CDS_DATA_2 => 102,
	CDS_XA_2_1 => 103,
	CDS_XA_2_2 => 104,
	CDS_MIXED => 105
};

my ($status);

# Do a status test to see if the CD is open or closed...
		if (sysopen(CD, "/dev/cdrom", O_RDONLY | O_NONBLOCK)) {
			# Check to see if the disk is OK.
			$status = ioctl(CD, CDROM_DRIVE_STATUS, 0);
print "Current status: $status\n";
			if ($status & CDS_DISC_OK) {
				$status = ioctl(CD, CDROM_DISC_STATUS, 0);
				if ($status != CDS_AUDIO && $status != CDS_XA_2_1 && $status != CDS_XA_2_2 && $status != CDS_MIXED) {
print "CD Type: $status\n";
					# Not an audio cd.
					$status = 0;
				}
			}
			else {
				# No disc found.
				$status = 0;
			}
			close(CD);
		}

print "CD Status is: $status\n";
