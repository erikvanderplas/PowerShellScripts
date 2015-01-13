###############################################################################
#
#	Created by:		Erik van der Plas
#	Company: 		Sogeti Netherlands B.V.
#       
# 	Created on:		January 5, 2015
#
#	Version:		0.1
#
#	Office 365 Change regional settings
#
###############################################################################

Get-Mailbox | Set-MailboxRegionalConfiguration -LocalizeDefaultFolderName:$true