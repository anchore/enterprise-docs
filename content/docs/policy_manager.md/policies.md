---
title: "Policies"
weight: 1
---

## What is a policy?

A policy is made up from a set of rules that are used to perform an evaluate a container image. These rules can include checks on security vulnerabilities, package whitelists, blacklists, configuration file contents, presence of credentials in image, manifest changes, exposed ports or any user defined checks. These policies can be deployed site wide or customized for specific images or categories of applications.

A policy can return one of two results:

**PASSED** indicating that image complies with your policy

![alt text](https://anchore.com/wp-content/uploads/2017/07/pass.png)

**FAILED** indicating that the image is out of compliance with your policy.

![alt text](https://anchore.com/wp-content/uploads/2017/07/fail.png)

### Rules

A policy is comprised of one or more rules.

Each rule is configured with a check to perform, for example ‘check if blacklisted package openssh-server present’. The author or the policy defines the action to take based on that result.


| Action        | Meaning           |
| ------------- | ------------- |
| ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096076/original/miF-aDHX0BvpikIyCXK7KOzPIT-toPiKiA?1525636485) | Critical error that should stop the deployment by failing the policy evaluation. |
| ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096073/original/VdVP1g_VGbyo9M3kR59nN-7gOB9MgL9XPA?1525636446) | OK to proceed |
| ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096069/original/hjMvsjOrgz3A9y88mRDhBujTAIJygv3P1w?1525636390) | Issue a warning |

Policy rules are made up of Gates and Triggers.
A Gate is a set of policy checks such as vulnerabilities, secret scans, licenses. 
Gates may include one or more individual checks known as triggers.

### Listing Policies

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096101/original/AiBnxZ_mUdO_lrAhFu447USwQQmYSPhe2w?1525636762)

The Policies tab shows a list of the policies defined within the selected Policy Bundle. The indicator ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096134/original/NIE5YWR9mis3yfboLibExVC1mPjEj4_L6A?1525636857) show the number of policies defined. 

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096175/original/_q57AbcrhnBB1k4i2HCcjIgt1qGyz43s2A?1525636960)

Within the Policy Name field a counter ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096186/original/lSogNhFl5Ug_G8WA1yWDDp2AewMMmxqVxg?1525637043) indicates the number of rules within the policy.

The icon indicates that the policy cannot be deleted. Policies that are included in mappings (indicated in the next field) cannot be deleted until they are removed from policy mappings.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096206/original/eAuYfBlTOMzwgw4X_wke5RjTbPc39YDp3A?1525637198)

The Tools drop down menu provides options to:

- Edit the policy
- Copy the policy
- Download the policy as a JSON document

### Adding a New Policy

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096233/original/rCre_BGRNANF2LmCIoOv1LGNYccCA6bc2Q?1525637358) The Add New Policy button is used to add a new, empty policy.

A unique name must be entered along with an optional, but recommended, description.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886024/original/vKxrJ3ExZw5FMVagBSqwRTBt-SHwmSACdw.png?1525313268)

### Editing Policies

Policies may be modified by pressing the ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096202/original/39GNwqTGa0k5v8I2DSmrQzWaxfxVbgRi5Q?1525637166) button or selecting Edit the Policy from the Tools drop down menu.

The Edit Policy Rules dialog will be displayed.

The Policy Name and Description can be updated by pressing the corresponding ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096266/original/mJKW_AYhQDI3C_HoNH481TTI1b4lqtpvKw?1525637558) button.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886018/original/ZQQLEzBIjrtQH1QCI62bqNjO6G1cMZPVrA.png?1525313233)

To add a policy rule you must first select a Gate from the dropdown list.

Each Gate represents a set of policy checks.

After selecting a gate an information indicator ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096341/original/2RaDTaW6R_vxE4ijb2plXgp_GVkWn4KNqQ?1525637999) will appear next to the Gate drop down. Hovering over the indicator will show help text.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886028/original/_OcrBJDuQ9_12Ri_DRl10P2HgKz1kYmZ3w.png?1525313295)

Once a Gate has been selected the Triggers drop down will be populated with relevant checks

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886029/original/o2ongoMB36F7m1qvxfPzOCoAl4kOhDlFOw.png?1525313321)

Triggers may have parameters some of which may be optional.

In the example below the stale feed data trigger has a single mandatory parameter: max days since sync.
After the number of days has been entered into the parameter field then you need to select the action to perform is this condition is met: ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886044/original/WRoAsA_Y2klLCqmOaQMXJgvsS48qY7HScw.png?1525313357)

Once the mandatory parameters and action has been specified the rule can be saved.

**Note:** The save button will not be enabled until all mandatory parameters have been entered.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886035/original/zqiMeC7exw3DRvgh1oMgQww_QXSLDfLR4A.png?1525313345)

The following example includes a more sophisticated policy check

The metadata gate has a single trigger that allows checks to be performed against select attributes of an image including image size, architecture and operating system distribution.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886048/original/wom5hiP9d_59pVtgsDalrLLXSm2U_R1ZdQ.png?1525313383)


The attribute field shown is a drop down that includes a number of attributes taken from image metadata. 

Including the operating system distribution, number of layers in the image and architecture of the image (AMD64, ARM, etc)

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096449/original/Fu3gokA3gExFGXLwYKMuEWgA7WnQtwQzmw?1525638712)

Once an attribute has been selected the **_check_** drop down is used to select the type of comparison.

The type of comparison varies based on the attribute. For example the numeric comparison operators such as >, <, >= would be relevant for numeric field such as size.

While other operators such as not in may be useful for querying data field such as distro

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096473/original/E29ujJGZQVJzTLxDa8FEm5TF7r8NDEMozA?1525638855)

In this example we are checking if the (operating system) distro is not rhel, centos or Oracle.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096522/original/4mv5rXln4BssmMk2f_n13F0qguCLBGu1-g?1525639042)

### Optional Parameters

If a Trigger has optional parameters then the parameter entry fields will be automatically added to the policy editor and a dialog will show the selected optional parameters.

In the example below a trigger has two optional parameters, both of which are currently displayed.

Unneeded optional parameters can be removed in one of two ways:

By pressing the x button on the optional parameters list.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886051/original/_RybKdsVwLdf7s7mdtyR4GF3F8aeAIHqfA.png?1525313396)

Or by pressing the x button within the parameter block.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096542/original/M_eSf5D5k9ll8cboj4EwAd5W2N3mKmVaYw?1525639308)

If an optional parameter needs to be re added to the rule then clicking the ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096588/original/CB2AgPrXvNlaaugy7B2e5WaNTBBSbn2MDg?1525639387) button on the Optional Parameters down button will allow selection of any optional parameters to be added.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886052/original/pVvQu1e7pKClixbpOVmPD2L07obueOQGCg.png?1525313404)

### Editing Rules

After the first rule has been added to the policy, edit policy list page will display a list of rules defined.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886076/original/GnExpp8ZishSfCfVwRWrv_Pu194jcPId5A.png?1525313474)

Unwanted rules may be deleted using the ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096727/original/slcSO056DkNcbSj1oyUC-HNFvAW5GB5Ifg?1525639561) button and rules may be edited by selecting the ![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36006096730/original/AYEKU6gTbG-i6UcDCbmSMuuVIkZeOeoF4g?1525639586) button.

![alt text](https://s3.amazonaws.com/cdn.freshdesk.com/data/helpdesk/attachments/production/36005886077/original/s7aGSwR5Pk-RZXvNl8kQYZ_pc0Ad9ZCNow.png?1525313480)

