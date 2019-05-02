---
title: "Dashboard"
linkTitle: "Dashboard"
weight: 1
---

<style>
  table td:first-child {
    min-width: 12rem;
  }
  img.img_large {
    max-width: 45rem !important;
  }
  img.img_medium {
    max-width: 35rem !important;
  }
  img.img_small {
    max-width: 25rem !important;
  }
  img.img_mini {
    max-width: 2rem !important;
  }
  span.resize-wrapper {
    position: relative;
    top: 8px;
    left: 4px;
  }
  span.resize-icon::after {
    content: "";
    position: absolute;
    width: 8px;
    height: 8px;
    border-right: 3px solid black;
    border-bottom: 3px solid black;
  }
</style>

### Overview

The Dashboard is your configurable landing page where insights into the collective status of your container image environment can be displayed through various widgets. Utilizing the Enterprise Reporting Service, the widgets are hydrated with metrics which are generated and updated on a cycle, the duration of which is determined by application configuration.

**Note:** Because the reporting data cycle is configurable, the results shown in this view may not precisely reflect actual analysis output at any given time.

For more information on how to modify this cycle or the Reporting Service in general, please refer to the [Reporting Service](/docs/overview/reports).

The following sections in this document describe how to add widgets to the dashboard and how to customize the dashboard layout to your preference.

### Widgets

<div>
  <img class="img_small" src="/WidgetVulnerabilities.png" />
  <img class="img_small" src="/WidgetPolicyEvaluations.png" />
</div>

#### Adding a Widget

To add a new widget, click the **Add New Widget** button present in the Dashboard view. Or, if no widgets are defined, click the **Let's add one!** button shown.

<img class="img_medium" src="/DashboardAddWidget.png" />

Upon doing so, a modal will appear with several properties described below:


|    Property          |    Description     |
|----------------------|--------------------|
| Name                 | The name shown within the Widget's header. |
| Mode                 | 'Compact' a widget to keep data easily digestable at a glance. 'Expand' to view how your data has evolved over a configurable time period. |
| Collection           | The collection of tags you're interested in. Toggle to view metrics for all tags - including historical ones. |
| Time Series Settings | The time period you wish to view metrics for within the expanded mode. |
| Type                 | The category of information such as 'Vulnerabilities' or 'Policy Evaluations' which denotes what metrics are capable of being shown. |
| Metrics              | The list of metrics available based on Type. |

Once you enter the required properties and click **OK**, the widget will be created and any metrics needed to hydrate your Dashboard will be fetched and updated.

**Note:** All fields except *Type* are editable by clicking the <i class="fas fa-edit my-2"></i> button shown on the top right of the header when hovering over a widget.

#### Viewing Results

The [Reporting Service](/docs/overview/reports) at its core aggregates data on resources across accounts and generates metrics. These metrics, in turn, fuel the Dashboard's mission to provide actionable items straight to the user - that's you!

Leverage these results to dive into the exact reason for a failed policy evaluation or the cause and fix of a critical vulnerability.

##### Vulnerabilities

Vulnerabilities are grouped and colored by severity. *Critical*, *High*, and *Medium* vulnerabilities are included by default but you can toggle which ones are relevant to your interests by clicking the <i class="fas fa-edit my-2"></i> button.

Clicking one of these metrics navigates you to a view (shown below) where you can browse the filtered set of vulnerabilities matching that severity.

<img class="img_large" src="/DashboardTagsByVulnerability.png" />

For more info on a particular vulnerability, click on its corresponding button visible in the **Links** column. To view the exact tags affected, drill down to a specific repository by expanding the arrows (<i class="fas fa-caret-right mx-1"></i>).

View that tag's in-depth analysis by clicking on the value within its **Image Digest** column.

##### Policy Evaluations

Policy Evaluations are grouped by their evaluation outcome such as *Pass* or *Fail* and can be further filtered by the reason for that result. All reasons are included by default but as with other widget properties, they can be edited by clicking the <i class="fas fa-edit my-2"></i> button.

Clicking one of these results navigates you to a view (shown below) where you can browse the affected and filtered set of tags.

<img class="img_large" src="/DashboardPolicyEvaluationsByTag.png" />

Dig down to a specific tag by expanding the arrow (<i class="fas fa-caret-right mx-1"></i>) shown on the left side of the row.

Navigate using the **Image Digest** value to view even more info such as the specific policy being triggered and what exactly is triggering it. If you're interested in viewing the contents of your policy bundle, click on the **Policy Bundle ID** value.

### Dashboard Configuration

After populating your Dashboard with various widgets, you can easily modify the layout by using some methods explained below:

<i class="fas fa-arrows-alt mr-2"></i>Click this icon shown in the top right or the header of a widget to **Drag and Drop** it into a new location.

<p>
<span class="resize-wrapper"><span class="resize-icon"></span></span><span class="ml-4">Shown in the bottom right of a widget, click and hold this icon to <strong>Resize</strong> it.</span></p>

<i class="fas fa-expand mr-2"></i>Click this icon shown in the top right of a widget to **Expand** it and include a graphical representation of how your data has evolved over a time period of your choice.

<i class="fas fa-compress mr-2"></i>Click this icon shown in the top right of a widget to **Compact** it into an easily digestable view of the metrics you're interested in.

<i class="fas fa-trash mr-2"></i>Click this icon shown in the top right of a widget to **Delete** it from the dashboard.