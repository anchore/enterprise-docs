---
title: "Testing Policies"
weight: 1
---

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006095330/original/5lnqztjcJyeP7WGXbn00sINHitE0zDgRFw?1525632821)

The Test Policy feature allows you to perform a test evaluation on an image to verify the mapping, policies and whitelists used to evaluate an image.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886419/original/YAuhg3RhjPAp0BlFgtXMAiz5T_DPZZee8Q.png?1525314362)

To test an image you should enter the name of the image, optionally including the registry if the image is not stored on docker.io

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886426/original/fAS6helgNNn6SwRwRkF98ItfVgue3Xw3wA.png?1525314369)

In the example below an evaluate was requested for library/debian:latest because no registry was specified the default, docker.io registry was used.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886434/original/GdQAaGFnZOE0JfVMC6W3X1z2nxZI-lHDLA.png?1525314377)


Here we can see that the image was evaluated against the mapping named ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006095391/original/D99GC9Q7GVt-7VfoNHAwx2NgIAVk2IowBQ?1525633094) and  the evaluate failed (the final action was ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006095388/original/EQfkVWEQvV62Ii_4A52yl3Mem9a375caGg?1525633060)

In the subsequent table a list of any policy checks that produced a Stop or Warning action will be displayed. In this example above, the image had a single high severity vulnerability that caused the evaluation to be failed.

The following example include a more complex evaluation report.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006095462/original/JuoMA7TB83yZJQ58VO8rjlxl8RZg6ouP1Q?1525633259)

The image was evaluating using the mapping named ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006095470/original/8rHnWD_2Sglxhhkuz56hLsC0eypnjIzhGA?1525633330) and the evaluation **failed** as the image was found in a blacklist. ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006095501/original/wATUyA-4H5-2O0atVFg4tJrp3dwnjn1cFQ?1525633383)

The next line explains that the image had been **blacklisted** by the **No centos** blacklist rule, however if the image was not blacklisted it would only have produced a **warning** instead of a failure. 

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006095507/original/kH9vYcfB9XvzTmX8RmUP8KPIA2HLHbH9XA?1525633407])

The subsequent table lists the policy checks that resulted in any Warning or Stop (failure) checks.

The policy checks are performed on images already analyzed and recorded in the Anchore Engine. If an image has been added to the engine but has not yet completed analysis then the system will display the following error: 

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886440/original/Xv18S1de1TcHbyIFrjK3c2WNAdfiDL5QYw.png?1525314385)

If the evaluation test is re-run after a few minutes the image will likely have completed analysis and a policy evaluation result will be returned.

If the image specified has not been analyzed by the Anchore Engine and has not been submitted for analysis then the following error message will be displayed.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886444/original/g5aOZEnz1zzn8Ot9G8l4ZoU5Mt1UAFmG-g.png?1525314400)

