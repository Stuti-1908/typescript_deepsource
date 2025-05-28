Feature: Single Project Allocation

  Background: Authentication with admin account
    Given ui: I opened SG Login Page
    And ui: I attempt to login with valid credentails
    Then ui: I validate for successful login
    And ui: Click on username and select Profile
    And ui: Create a token for "1" "Hours"
    And ui: I navigate to "Dashboard"

  @testId=ST-1421
  @issue=SG-9476
  @issue=SG-14544
  @9.3.0
  Scenario: SPA - custom time range filter in options (Case1)
    Given setup: Test Data "Project"
    Given setup: Test Data "SoftAssert"
    And setup: Test Data "Resource"
    And api: I create a default resource for automation with default rate as "100"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it

    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    #3. Must be possible to leave the start date or end date blank.
    And ui: Click on Options button in SPA
    And ui: Clear dates of Date Range Filter in Grid options of SPA
    Then ui: Verify dates of Date Range Filter in Grid options of SPA are empty

    #1. Must not be possible to set a start date later than the end date.
    And ui: Enter start date as "last" of the month "Aug" of current year in Grid options of SPA
    And ui: Enter end date as "first" of the month "Aug" of current year in Grid options of SPA
    Then ui: Verify end date is "last" of the month "Aug" of current year in Grid options of SPA

    #2. Must not be possible to set the end date earlier than the start date.
    And ui: Clear dates of Date Range Filter in Grid options of SPA
    And ui: Enter start date as "first" of the month "Mar" of current year in Grid options of SPA
    And ui: Enter end date as "last" of the month "Jan" of current year in Grid options of SPA
    Then ui: Verify end date is "first" of the month "Mar" of current year in Grid options of SPA

    #4. Must limit the user to enter dates in the new date filter within the date range of the project
    And ui: Clear dates of Date Range Filter in Grid options of SPA
    And ui: Enter start date as "first" of the month "Mar" of previous year in Grid options of SPA
    And ui: Enter end date as "first" of the month "Mar" of next year in Grid options of SPA

    Then ui: Verify start date is "first" of the month "Jan" of current year in Grid options of SPA
    Then ui: Verify end date is "last" of the month "Dec" of current year in Grid options of SPA

    #5. The date range entered in the Grid Options must not change the project's actual date.
    And ui: Close Options section in SPA
    Given ui: Click on Checkout button in SPA and wait for Release button
    And ui: Click on Options button in SPA
    And ui: I turn on total column option turn "Off"
    And ui: Enter start date as "first" of the month "Jun" of current year in Grid options of SPA
    And ui: Enter end date as "last" of the month "Nov" of current year in Grid options of SPA
    And ui: Close Options section in SPA
    And ui: I click on specific unit "Story Points" in SPA

    Then ui: Verify if column number "1" has the title:"Jun 25" in SPA when dataset is "Allocation"
    Then ui: Verify if resource has "0" hours in cell number:"1" in SPA when dataset is "Allocation"

    Then ui: Verify if column number "2" has the title:"Jul 25" in SPA when dataset is "Allocation"
    Then ui: Verify if resource has "0" hours in cell number:"2" in SPA when dataset is "Allocation"

    And ui: I select specific date mode "Year" in SPA
    Then ui: Verify if column number "1" has the title:"2025" in SPA when dataset is "Allocation"
    Then ui: Verify if resource has "0" hours in cell number:"1" in SPA when dataset is "Allocation"

    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    Then ui: Verify project allocation dates are set to current year
    Then ui: Softassert all

  @testId=ST-1423
  @issue=SG-9476
  @owner=Ram
  Scenario: SG-9476 - SPA - custom time range filter in options (Case2)
    Given setup: Test Data "Project"
    And setup: Test Data "Resource"
    And setup: Test Data "SoftAssert"

    When ui: Click on "Resource Management" tile in homepage
    And ui: I create a new Resource
    And ui: Click on User Identity section in Resource Attributes and Identity
    And ui: Enter default rate as "50" in Resource Attributes and Identity
    And ui: Click on Save button in Resource Attributes and Identity and wait for it to be clickable

    And ui: Quick navigate to "Project Management"
    And ui: Create a new Regular Project and set year as:"2023" for allocations
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Add recently created resource in SPA when dataset is "Allocation"
    And ui: Allocate "100" hours for existing resource to project in SPA in Month mode for year:"2023" when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    #1. Periods displayed on the SPA grid must be based on the Grid options date range value set.
    And ui: Click on Options button in SPA
    And ui: Clear dates of Date Range Filter in Grid options of SPA
    And ui: Enter start date as "13.05.2023" in Grid options of SPA
    And ui: Enter end date as "24.11.2023" in Grid options of SPA
    And ui: Close Options section in SPA

    When ui: I select specific date mode "Project" in SPA
    And ui: Unselect Columns if any in SPA
    Then ui: Verify if column number "1" has the title:"13 May 23 - 24 Nov 23" in SPA
    Then ui: Verify if resource has "638.34" hours in cell number:"1" in SPA when dataset is "Allocation"

    When ui: I select specific date mode "Quarter" in SPA
    Then ui: Verify if column number "1" has the title:"Q2 23" in SPA
    Then ui: Verify if resource has "156.52" hours in cell number:"1" in SPA when dataset is "Allocation"
    Then ui: Verify if column number "2" has the title:"Q3 23" in SPA
    Then ui: Verify if resource has "300" hours in cell number:"2" in SPA when dataset is "Allocation"
    Then ui: Verify if column number "3" has the title:"Q4 23" in SPA
    Then ui: Verify if resource has "181.82" hours in cell number:"3" in SPA when dataset is "Allocation"

    When ui: I select specific date mode "Month" in SPA
    Then ui: Verify if column number "1" has the title:"May 23" in SPA
    Then ui: Verify if resource has "56.52" hours in cell number:"1" in SPA when dataset is "Allocation"
    Then ui: Verify if column number "2" has the title:"Jun 23" in SPA
    Then ui: Verify if resource has "100" hours in cell number:"2" in SPA when dataset is "Allocation"
    Then ui: Verify if column number "3" has the title:"Jul 23" in SPA
    Then ui: Verify if resource has "100" hours in cell number:"3" in SPA when dataset is "Allocation"
    Then ui: Verify if column number "4" has the title:"Aug 23" in SPA
    Then ui: Verify if resource has "100" hours in cell number:"4" in SPA when dataset is "Allocation"
    Then ui: Verify if column number "5" has the title:"Sep 23" in SPA
    Then ui: Verify if resource has "100" hours in cell number:"5" in SPA when dataset is "Allocation"
    Then ui: Verify if column number "6" has the title:"Oct 23" in SPA
    Then ui: Verify if resource has "100" hours in cell number:"6" in SPA when dataset is "Allocation"
    Then ui: Verify if column number "7" has the title:"Nov 23" in SPA
    Then ui: Verify if resource has "81.82" hours in cell number:"7" in SPA when dataset is "Allocation"

  @testId=ST-1434
  Scenario: SG-10957 Add advance date picker for Resource NA
    Given setup: Test Data "SoftAssert"
    Given ui: Quick navigate to "Resource Management"
    When setup: Test Data "Resource"
    And ui: I create a new Resource with email, username, password
    And I stored resource in context array at index "0"
    And ui: Quick navigate to "Resource Management"
    And setup: Test Data "Resource"
    And ui: I create a new Resource with email, username, password
    And I stored resource in context array at index "1"
    And setup: Test Data "Project"
    And ui: I click on logo to navigate to homepage
    And ui: I navigate to "Project" "Management"
    And ui: Clear filters if any in PM Grid
    And ui: Ungroup groups if any in PM Grid
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on Add Assignment when dataset is "Allocation"
    And ui: I validate Bulk Assignment Dialog Open
    And ui: I click on "Bulk" section in add assignment in SPA
    And ui: I search for the previously created "Resource", select and add to project
    Then ui: I verify each "Resource" is assigned to project

  @testId=ST-1472
  @issue=SG-11612
  Scenario: SG-11612 - PM - SPA: Incorrect date range is displayed in Gantt tab column header and tooltip
    Given ui: Quick navigate to "Resource Management"
    When setup: Test Data "Resource"
    And setup: Test Data "Project"
    And setup: Test Data "SoftAssert"
    And ui: I create a new Resource
    And ui: Quick navigate to "Project Management"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate specific "0,100,100,100,100,100,100,100,100,100,100,0" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: I click on specific unit "Gantt" in SPA
    Then ui: Verify current year column headers are displayed in Gantt tab of SPA
    Then ui: Verify current year start "1" and end "10" date is displayed in Gantt bar tooltip in Gantt tab
    Then ui: Softassert all

  @testId=ST-1473
  @issue=SG-11519
  Scenario: SG-11519 - PM - SPA - cannot have one blank start or end date in UI on Save
    Given ui: Quick navigate to "Resource Management"
    When setup: Test Data "Resource"
    And setup: Test Data "Project"
    And ui: I create a new Resource
    And ui: Quick navigate to "Project Management"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I enter specific end date "Empty" in SPA
    And ui: Click on Save and Check In button in SPA
    Then ui: I verify specific confirmation warning "Please correct selected date range. You can either remove all dates or add missing one" is displayed
    And ui: Click on "Ok" button in confirmation modal
    And ui: I enter specific end date "Today" in SPA
    Then ui: I verify specific confirmation warning "Please shift allocation/demand data to altering dates. Alternatively, shift entire project . Changing dates will result in data loss." is displayed
    And ui: Click on "Approve" button in confirmation modal
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    Then ui: Verify if resource has "100" hours for specific cell "Jan 25" in SPA when dataset is "Allocation"

  @testId=ST-1495
  @issue=SG-12407
  @issue=SG-11809
  @8.2
  Scenario: Heatmap should be stay applied when using date filters
    Given setup: Test Data "Project"
    And setup: Test Data "Resource"
    And setup: Test Data "SoftAssert"

    When ui: Click on "Resource Management" tile in homepage
    And ui: I create a new Resource
    And ui: Click on User Identity section in Resource Attributes and Identity
    And ui: Click on Save button in Resource Attributes and Identity and wait for it to be clickable

    And ui: Quick navigate to "Project Management"
    And ui: Create a new Regular Project and set year as:"2024" for allocations
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Allocate specific "0,5,10,20,0,5,10,20,0,5,10,20" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"

    And ui: Click on Options button in SPA
    And ui: I click on specific heatmap toggle "Resource" in SPA grid options dialog
    And ui: I toggle overlay heatmap for rows option to "On" in SPA grid options dialogs
    And ui: I toggle overlay heatmap for groups option to "On" in SPA grid options dialogs
    And ui: Clear dates of Date Range Filter in Grid options of SPA
    And ui: Enter start date as "13.05.2024" in Grid options of SPA
    And ui: Close Options section in SPA
    And ui: I verify client or server error warning is not displayed
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    Then ui: Verify if column "May 24" of recently added resource has heatmap color as:"#acf395" in SPA when dataset is:"Allocation"
    Then ui: Verify if column "Jun 24" of recently added resource has heatmap color as:"#acf395" in SPA when dataset is:"Allocation"
    Then ui: Verify if column "Jul 24" of recently added resource has heatmap color as:"#ffffb7" in SPA when dataset is:"Allocation"
    Then ui: Verify if column "Aug 24" of recently added resource has heatmap color as:"#FFAD91" in SPA when dataset is:"Allocation"
    Then ui: Verify if column "Sep 24" of recently added resource has heatmap color as:"#acf395" in SPA when dataset is:"Allocation"
    Then ui: Verify if column "Oct 24" of recently added resource has heatmap color as:"#acf395" in SPA when dataset is:"Allocation"
    Then ui: Verify if column "Nov 24" of recently added resource has heatmap color as:"#ffffb7" in SPA when dataset is:"Allocation"
    Then ui: Verify if column "Dec 24" of recently added resource has heatmap color as:"#FFAD91" in SPA when dataset is:"Allocation"
    Then ui: I verify client or server error warning is not displayed

    Then ui: Softassert all

  @testId=ST-1505
  @issue=SG-11616
  Scenario: SG-11616 : Unable to do Search on Project Allocation page.
    Given ui: Quick navigate to "Resource Management"
    When setup: Test Data "Resource"
    And setup: Test Data "Project"
    And ui: I create a new Resource
    And ui: Quick navigate to "Project Management"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    Then ui: I verify quick search option is displayed
    And ui: I click on group by dropdown and select "Task" in SPA
    Then ui: Quick search "GenericTask" and verify specific ResourceOrTask is displayed in SPA
    And ui: I click on group by dropdown and select "Resource" in SPA
    Then ui: Quick search "Resource" and verify specific ResourceOrTask is displayed in SPA
    And ui: Click on Checkout button in SPA and wait for Release button
    Then ui: I verify quick search option is displayed
    And ui: I click on group by dropdown and select "Task" in SPA
    Then ui: Quick search "GenericTask" and verify specific ResourceOrTask is displayed in SPA
    And ui: I click on group by dropdown and select "Resource" in SPA
    Then ui: Quick search "Resource" and verify specific ResourceOrTask is displayed in SPA
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

  @testId=ST-1512
  @issue=SG-11764
  Scenario: SG-11764 - SPA - moving attribute columns and then clicking on Insert Columns causes error
    Given ui: Quick navigate to "Resource Management"
    When setup: Test Data "Resource"
    And setup: Test Data "Project"
    And ui: I create a new Resource
    And ui: Quick navigate to "Project Management"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Unselect all and Select specific attributes "Global Role,Is Enabled,Resource Managers,Timesheet Approver" in SPA
    And ui: I dragdrop from column header "Timesheet Approver" to column header "Global Role" in SPA
    And ui: Click on Insert columns dropdown in SPA
    Then ui: I verify client or server error warning is not displayed
    And ui: Click on Insert columns dropdown in SPA
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: I dragdrop from column header "Global Role" to column header "Resource Managers" in SPA
    And ui: Click on Insert columns dropdown in SPA
    Then ui: I verify client or server error warning is not displayed

  @testId=ST-1524
  @issue=SG-11783
  Scenario: SPA - Validate that the heatmap and task options are clickable
    Given setup: Test Data "SoftAssert"
    And ui: Quick navigate to "Resource Management"
    When setup: Test Data "Resource"
    And ui: I create a new Resource with email, username, password
    And setup: Test Data "Project"
    And ui: Quick navigate to "Project Management"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Insert columns dropdown in SPA
    And ui: I uncheck and select attributes "Project Owner,Resource Managers,Project Hierarchy" in groupby dropdown
    And ui: Click on Insert columns dropdown in SPA
    And ui: Unselect all and Select specific attributes "Global Role,Is Enabled,Resource Managers,Timesheet Approver" in SPA
    And ui: I dragdrop from column header "Is Enabled" to column header "Global Role" in SPA
    And ui: I dragdrop from column header "Global Role" to column header "Resource Managers" in SPA
    And ui: I dragdrop from column header "Timesheet Approver" to column header "Is Enabled" in SPA
    And ui: I click on options dropdown in SPA
    Then ui: I validate button for specific heatmap toggle "Off" in SPA is clickable
    And ui: I validate button for specific heatmap toggle "Resource" in SPA is clickable
    And ui: I validate button for specific heatmap toggle "Resource request" in SPA is clickable
    And ui: I validate button for specific task to show "Non-Generic" in SPA is clickable
    And ui: I validate button for specific task to show "Generic" in SPA is clickable
    And ui: I validate button for specific task to show "All" in SPA is clickable
    Then ui: Softassert all

  @testId=ST-1529
  @issue=SG-11533
  Scenario: Project Management: Bulk resource assignment is allowed without project checkout
    Given setup: Test Data "Project"
    And setup: Test Data "Resource"
    When ui: Quick navigate to "Resource Management"
    And ui: I create a new Resource
    And ui: I click on logo to navigate to homepage
    And ui: I navigate to "Project" "Management"
    And ui: Clear filters if any in PM Grid
    And ui: Ungroup groups if any in PM Grid
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    Then ui: I validate Add Assignment button is not present when project is not Checked out
    And ui: I search for recently created resource in quick search and try to add it
    And ui: I validate that the resource is not added in SPA

  @issue=SG-11454
  @testId=ST-1560
  Scenario: SG-9476 - SPA - custom time range filter in options (Case1)
    Given setup: Test Data "Project"
    Given setup: Test Data "SoftAssert"

    When ui: Click on "Project Management" tile in homepage
    And ui: Click on Create Project button in PM grid and select Regular Project if required
    And ui: Enter Project name in project creation page
    And ui: Enter current year as date for the project in SPA
    And ui: Click on End date inputbox in SPA
    And ui: Press Right arrow key "10" number of times
    And ui: Press Backspace Key
    And ui: Enter text:"4" in currently selected textbox
    And ui: Enter resource name as:"Administrator" in SPA and press Enter key
    And ui: SoftAssert if warning:"You have already the resource 'Administrator'" is not displayed
    And ui: Wait for warning to disappear
    And ui: Click on Create button in project creation page
    And ui: Softassert if client or server error is not displayed

    Then ui: Softassert all

  @testId=ST-2031
  @issue=SG-12118
  @owner=Rinkesh
  @9.0
  Scenario: SG-12118 - SPA - Validate copy allocation to demand for seven days work week
    Given setup: Test Data "Resource"
    And setup: Test Data "SoftAssert"
    And ui: I navigate to "Admin" "Settings"
    And ui: Click on General Settings tile
    And ui: Click on "Global" tab in General Settings
    And ui: I toggle Working Weekends to "On" in General settings global tab
    And ui: Click on Save button in General Settings and wait for Save button to be clickable again
    And ui: Quick navigate to "Resource Management"
    And ui: I create a new Resource with email, username, password
    And setup: Test Data "Project"
    And ui: Quick navigate to "Project Management"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Day" in SPA
    And ui: Allocate "2" hours for resource to project in SPA in Day mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: Click on Checkout button in SPA and wait for Release button
    When ui: I copy allocation to demand
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Click on dataset dropdown and select "Demand" in SPA
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Day" in SPA
    And ui: Validate "2" hours for resource to project in SPA in Day mode for seven days work week in SPA when dataset is "Allocation"
    And ui: I update allocation to "4" hours for resoure to project in SPA in Day mode for seven days work week
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I copy demand to allocation
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Click on dataset dropdown and select "Allocation" in SPA
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Day" in SPA
    Then ui: Validate "4" hours for resource to project in SPA in Day mode for seven days work week in SPA when dataset is "Allocation"
    Then ui: Softassert all

  @testId=ST-2119
  @issue=SG-12496
  @issue=SG-12892
  @issue=SG-14740
  @issue=SG-14578
  @issue=SG-16015
  @9.2
  @9.3.0
  @10.0.0
  @bugT
  Scenario: Check Exceeded capacity warning in SPA.
    Given ui: Quick navigate to "Resource Management"
    When setup: Test Data "Resource"
    When setup: Test Data "SoftAssert"
    And ui: I create a new Resource with email, username, password

    Given ui: Quick navigate to "Admin Settings"
    And ui: Click on General Settings tile
    And ui: I toggle Multi Assignment to "Off" in General settings global tab
    And ui: Click on Save button in General Settings and wait for Save button to be clickable again
    And ui: Wait for 1 second
    And ui: Check fiscal month and fiscal quarter
    And ui: Click on "Unit Settings" tab in General Settings
    And ui: I select current dominant unit "Time" in general settings unit settings tab
    And ui: Click on Save button in General Settings and click on Save Settings button if displayed

    Given ui: Quick navigate to "Admin Settings"
    When ui: I navigate to specific tile "Fiscal Period Management" in admin settings
    And ui: I create fiscal period for "current" year in fiscal period management
    And ui: I click on save button in fiscal period management
    And ui: Wait for 4 seconds

    Given ui: I navigate to "Dashboard"
    When ui: Click on "Admin Settings" tile in homepage
    When ui: I navigate to "Financial" "Categories"
    And ui: I click on create new financial category
    And ui: I enter a name for Financial Category with "Positve" and type as "Default"
    And ui: I click on Save button in the financial category create model

    And ui: Quick navigate to "Project Management"
    And setup: Test Data "Project"
    And ui: Create a new Regular Project and set year as:"2025" for allocations
    And ui: Click on Project navigation dropdown and select "Financials"
    And ui: Click on Checkout button in Financials and wait for Release button
    And ui: I select recently created financial category
    And ui: Select Date mode as:"Month" in Financials if not already selected
    And ui: I allocate "100" hours to the financial category for each months
    And ui: Select Date mode as:"Quarter" in Financials if not already selected
    And ui: Click on Include labor costs toggle turn "On"
    And ui: Click on Save and Check In button in Financials and wait for Checkout button
    And ui: Click on Project navigation dropdown and select "Allocations"
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Unselect Columns if any in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Enter start date as "first" of the month "Nov" of previous year in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA for cellhead:"Nov 24" when dataset is "Allocation"
    Then ui: I verify Warning icon must be displayed beside the resource name for "None"
    And ui: I click on specific unit "Cost" in SPA
    Then ui: I verify Warning icon must be displayed beside the resource name for "Cost"
    And ui: I click on specific unit "FTE" in SPA
    Then ui: I verify Warning icon must be displayed beside the resource name for "FTE"
    And ui: I click on specific unit "FTE %" in SPA
    Then ui: I verify Warning icon must be displayed beside the resource name for "FTE %"
    And ui: I click on specific unit "Manday" in SPA
    Then ui: I verify Warning icon must be displayed beside the resource name for "Manday"
    And ui: I click on specific unit "Gantt" in SPA
    Then ui: I verify Warning icon must be displayed beside the resource name for "Gantt"
    And ui: I click on specific unit "Time" in SPA
    When ui: I select specific date mode "Day" in SPA
    Then ui: I verify Warning icon must be displayed beside the resource name for "Day"
    When ui: I select specific date mode "Week" in SPA
    Then ui: I verify Warning icon must be displayed beside the resource name for "Week"
    When ui: I select specific date mode "Quarter" in SPA
    Then ui: I verify Warning icon must be displayed beside the resource name for "Quarter"
    When ui: I select specific date mode "Year" in SPA
    Then ui: I verify Warning icon must be displayed beside the resource name for "Year"
    When ui: I select specific date mode "Project" in SPA
    Then ui: I verify Warning icon must be displayed beside the resource name for "Project"
    When ui: I select specific date mode "Fiscal Month" in SPA
    Then ui: I verify Warning icon must be displayed beside the resource name for "Fiscal Month"
    When ui: I select specific date mode "Fiscal Quarter" in SPA
    Then ui: I verify Warning icon must be displayed beside the resource name for "Fiscal Quarter"
    When ui: I select specific date mode "Day" in SPA
    And ui: I click on warning icon showing beside Resource
    Then ui: Verify that warning alert has the exceeded capacity Time and FTE Values
    Then ui: Softassert all

  @testId=ST-2154
  @issue=SG-12718
  @9.1
  Scenario: Verify Enable/disable the 'Selection' Project Attribute on the PM Attributes Page
    Given setup: Test Data "Project"
    And setup: Test Data "Resource"
    And setup: Test Data "SoftAssert"
    And setup: Test Data setup for Attribute of type:"Selection" with "4" number of selection values, "1" number of default values and create default values:"true"

    When ui: Click on "Admin Settings" tile in homepage
    And ui: Click on "Attribute Management" tile in Admin settings
    And ui: Create an Attribute using model data in "Project" tab of Attribute Management
    And ui: I search for the newly created attribute and click on edit button
    And ui: I "disable" number "1" option from the list of options for the newly created attribute
    And ui: Verify if the disabled option number "1" went to last place and got StrikeThrough
    And ui: I click on save button in edit attribute section
    And ui: I navigate to Attribute Layout tab
    And ui: I navigate to "Project" section in Attribute Layout tab
    And ui: Add recently created CF to "Required Fields" section of Attribute Layout
    And ui: I click on save button in attribute layout tab

    # Validate disabled option on PM Attributes
    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Resource" "Management"
    And ui: I create a new Resource with email, username, password
    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Project" "Management"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: Click on Project navigation dropdown and select "Attributes"
    And ui: I validate that the newly created attribute has option "1" as "disabled"

    And ui: I navigate to "Dashboard"
    When ui: Click on "Admin Settings" tile in homepage
    And ui: Click on "Attribute Management" tile in Admin settings
    And ui: I navigate to "Project" section in Attribute Layout tab
    And ui: I search for the newly created attribute and click on edit button
    And ui: I "enable" number "last" option from the list of options for the newly created attribute
    And ui: I click on save button in edit attribute section

    # Validate enabled option on PM Attributes
    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Project" "Management"
    And ui: Search for recently created project in PM Grid
    And ui: I click on the project
    And ui: Click on Project navigation dropdown and select "Attributes"
    And ui: I validate that the newly created attribute has option "1" as "enabled"
    Then ui: Softassert all

  @testId=ST-2157
  @issue=SG-12718
  @issue=SG-945
  @9.2
  @9.1
  Scenario: Verify Enable/disable the 'Selection' Project Attribute on the PM Kanban Board
    Given setup: Test Data "Project"
    And setup: Test Data "Resource"
    And setup: Test Data "Kanban"
    And setup: Test Data "SoftAssert"
    And setup: Test Data setup for Attribute of type:"Selection" with "4" number of selection values, "1" number of default values and create default values:"true"

    When ui: Click on "Admin Settings" tile in homepage
    And ui: Click on "Attribute Management" tile in Admin settings
    And ui: Create an Attribute using model data in "Project" tab of Attribute Management
    And ui: I search for the newly created attribute and click on edit button
    And ui: I "disable" number "1" option from the list of options for the newly created attribute
    And ui: Verify if the disabled option number "1" went to last place and got StrikeThrough
    And ui: I click on save button in edit attribute section
    Then ui: I verify client or server error warning is not displayed
    And ui: I navigate to Attribute Layout tab
    And ui: I navigate to "Project" section in Attribute Layout tab
    And ui: Add recently created CF to "Required Fields" section of Attribute Layout
    And ui: I click on save button in attribute layout tab

    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Resource" "Management"
    And ui: I create a new Resource with email, username, password
    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Project" "Management"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    #Create  kanban board and validate disabled option on PM Kanban Board
    And ui: Quick navigate to "Project Management"
    And ui: Click on "Kanban" tab in Project Management
    And ui: Create a new Kanban board with Column attribute as:"Dataset Preference" and Swimlanes as:"Allocation"
    And ui: Quick navigate to "Project Management"
    And ui: Click on "Kanban" tab in Project Management
    And ui: I click on board settings and select newly created board in kanban tab
    And ui: Search for recently created project in Kanban section of PM
    And ui: Double click on recently created project in Kanban section of PM
    And ui: I validate that the newly created attribute has option "1" as "disabled"

    And ui: I navigate to "Dashboard"
    When ui: Click on "Admin Settings" tile in homepage
    And ui: Click on "Attribute Management" tile in Admin settings
    And ui: I navigate to "Project" section in Attribute Layout tab
    And ui: I search for the newly created attribute and click on edit button
    And ui: I "enable" number "last" option from the list of options for the newly created attribute
    And ui: I click on save button in edit attribute section

    # Validate enabled option on Kanban
    And ui: Quick navigate to "Project Management"
    And ui: Click on "Kanban" tab in Project Management
    And ui: I click on board settings and select newly created board in kanban tab
    And ui: Search for recently created project in Kanban section of PM
    And ui: Double click on recently created project in Kanban section of PM
    And ui: I validate that the newly created attribute has option "1" as "enabled"
    Then ui: Softassert all

  @testId=ST-2155
  @issue=SG-12718
  @issue=SG-1175
  @9.1
  Scenario: Verify enable/disable the Multi-selection assignment attribute in PM Attributes
    Given setup: Test Data "Project"
    And setup: Test Data "Resource"
    And setup: Test Data "SoftAssert"
    And setup: Test Data setup for Attribute of type:"Multi-Selection" with "4" number of selection values, "1" number of default values and create default values:"true"

    When ui: Click on "Admin Settings" tile in homepage
    And ui: Click on "Attribute Management" tile in Admin settings
    And ui: Create an Attribute using model data in "Project" tab of Attribute Management
    And ui: I search for the newly created attribute and click on edit button
    And ui: I "disable" number "1" option from the list of options for the newly created attribute
    And ui: Verify if the disabled option number "1" went to last place and got StrikeThrough
    And ui: I click on save button in edit attribute section
    And ui: I navigate to Attribute Layout tab
    And ui: I navigate to "Project" section in Attribute Layout tab
    And ui: Add recently created CF to "Required Fields" section of Attribute Layout
    And ui: I click on save button in attribute layout tab

    # Validate disabled option on PM Attributes
    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Resource" "Management"
    And ui: I create a new Resource with email, username, password
    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Project" "Management"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: Click on Project navigation dropdown and select "Attributes"
    And ui: I validate that the newly created attribute has option "1" as "disabled"
    Then ui: I verify client or server error warning is not displayed

    And ui: I navigate to "Dashboard"
    When ui: Click on "Admin Settings" tile in homepage
    And ui: Click on "Attribute Management" tile in Admin settings
    And ui: I navigate to "Project" section in Attribute Layout tab
    And ui: I search for the newly created attribute and click on edit button
    And ui: I "enable" number "last" option from the list of options for the newly created attribute
    And ui: I click on save button in edit attribute section

    # Validate enabled option on PM Attributes
    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Project" "Management"
    And ui: Search for recently created project in PM Grid
    And ui: I click on the project
    And ui: Click on Project navigation dropdown and select "Attributes"
    And ui: I validate that the newly created attribute has option "1" as "enabled"

  @testId=ST-2159
  @issue=SG-12718
  @9.1
  Scenario: Verify enable/disable the Multi-selection assignment attribute in PM Kanban
    Given setup: Test Data "Project"
    And setup: Test Data "Resource"
    And setup: Test Data "Kanban"
    And setup: Test Data "SoftAssert"
    And setup: Test Data setup for Attribute of type:"Multi-Selection" with "4" number of selection values, "1" number of default values and create default values:"true"

    When ui: Click on "Admin Settings" tile in homepage
    And ui: Click on "Attribute Management" tile in Admin settings
    And ui: Create an Attribute using model data in "Project" tab of Attribute Management
    And ui: I search for the newly created attribute and click on edit button
    And ui: I "disable" number "1" option from the list of options for the newly created attribute
    And ui: Verify if the disabled option number "1" went to last place and got StrikeThrough
    And ui: I click on save button in edit attribute section
    And ui: I navigate to Attribute Layout tab
    And ui: I navigate to "Project" section in Attribute Layout tab
    And ui: Add recently created CF to "Required Fields" section of Attribute Layout
    And ui: I click on save button in attribute layout tab

    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Resource" "Management"
    And ui: I create a new Resource with email, username, password
    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Project" "Management"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    #Create  kanban board and validate disabled option on PM Kanban Board
    And ui: Quick navigate to "Project Management"
    And ui: Click on "Kanban" tab in Project Management
    And ui: Create a new Kanban board with Column attribute as:"Dataset Preference" and Swimlanes as:"Allocation"
    And ui: Quick navigate to "Project Management"
    And ui: Click on "Kanban" tab in Project Management
    And ui: I click on board settings and select newly created board in kanban tab
    And ui: Search for recently created project in Kanban section of PM
    And ui: Double click on recently created project in Kanban section of PM
    And ui: I validate that the newly created attribute has option "1" as "disabled"

    And ui: I navigate to "Dashboard"
    When ui: Click on "Admin Settings" tile in homepage
    And ui: Click on "Attribute Management" tile in Admin settings
    And ui: I navigate to "Project" section in Attribute Layout tab
    And ui: I search for the newly created attribute and click on edit button
    And ui: I "enable" number "last" option from the list of options for the newly created attribute
    And ui: I click on save button in edit attribute section

    # Validate enabled option on Kanban
    And ui: Quick navigate to "Project Management"
    And ui: Click on "Kanban" tab in Project Management
    And ui: I click on board settings and select newly created board in kanban tab
    And ui: Search for recently created project in Kanban section of PM
    And ui: Double click on recently created project in Kanban section of PM
    And ui: I validate that the newly created attribute has option "1" as "enabled"
    Then ui: Softassert all

  @testId=ST-2156
  @issue=SG-12718
  @9.1
  Scenario: Verify enable/disable the Selection assignment attribute in SPA
    Given setup: Test Data "Project"
    And setup: Test Data "Resource"
    And setup: Test Data "SoftAssert"
    And setup: Test Data setup for Attribute of type:"Selection" with "4" number of selection values, "1" number of default values and create default values:"true"
    When ui: Click on "Admin Settings" tile in homepage
    And ui: Click on "Attribute Management" tile in Admin settings
    And ui: Create an Attribute using model data in "Assignment" tab of Attribute Management
    And ui: I search for the newly created attribute and click on edit button
    And ui: I "disable" number "1" option from the list of options for the newly created attribute
    And ui: Verify if the disabled option number "1" went to last place and got StrikeThrough
    And ui: I click on save button in edit attribute section
    And ui: Add recently created CF to "Required Fields" section of Attribute Layout
    And ui: I click on save button in attribute layout tab

    # Validate disabled option on SPA
    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Resource" "Management"
    And ui: I create a new Resource with email, username, password
    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Project" "Management"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Unselect all and Select specific assignment attributes in SPA
    And ui: I click on specific Assignment Attribute in SPA
    And ui: I validate that the newly created attribute has option "1" as "disabled" on SPA
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: I navigate to "Dashboard"
    When ui: Click on "Admin Settings" tile in homepage
    And ui: Click on "Attribute Management" tile in Admin settings
    And ui: I navigate to "Assignment" section in Attribute Layout tab
    And ui: I search for the newly created attribute and click on edit button
    And ui: I "enable" number "last" option from the list of options for the newly created attribute
    And ui: I click on save button in edit attribute section

    # Validate enabled option on SPA
    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Project" "Management"
    And ui: Search for recently created project in PM Grid
    And ui: I click on the project
    Given ui: Click on Checkout button in SPA and wait for Release button
    And ui: Click on resource expand icon
    And ui: I click on specific Assignment Attribute in SPA
    And ui: I validate that the newly created attribute has option "1" as "enabled" on SPA
    Then ui: Softassert all

  @testId=ST-2158
  @issue=SG-12718
  @9.1
  Scenario: Verify enable/disable the Multi-Selection assignment attribute in SPA
    Given setup: Test Data "Project"
    And setup: Test Data "Resource"
    And setup: Test Data "SoftAssert"
    And setup: Test Data setup for Attribute of type:"Multi-Selection" with "4" number of selection values, "1" number of default values and create default values:"true"
    When ui: Click on "Admin Settings" tile in homepage
    And ui: Click on "Attribute Management" tile in Admin settings
    And ui: Create an Attribute using model data in "Assignment" tab of Attribute Management
    And ui: I search for the newly created attribute and click on edit button
    And ui: I "disable" number "1" option from the list of options for the newly created attribute
    And ui: Verify if the disabled option number "1" went to last place and got StrikeThrough
    And ui: I click on save button in edit attribute section
    And ui: Add recently created CF to "Required Fields" section of Attribute Layout
    And ui: I click on save button in attribute layout tab

    # Validate disabled option on SPA
    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Resource" "Management"
    And ui: I create a new Resource with email, username, password
    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Project" "Management"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Unselect all and Select specific assignment attributes in SPA
    And ui: I double click on specific Assignment Attribute in SPA
    And ui: I validate that the newly created attribute has option "1" as "disabled" on SPA
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    And ui: I navigate to "Dashboard"
    When ui: Click on "Admin Settings" tile in homepage
    And ui: Click on "Attribute Management" tile in Admin settings
    And ui: I navigate to "Assignment" section in Attribute Layout tab
    And ui: I search for the newly created attribute and click on edit button
    And ui: I "enable" number "last" option from the list of options for the newly created attribute
    And ui: I click on save button in edit attribute section

    # Validate enabled option on SPA
    And ui: I navigate to "Dashboard"
    And ui: I navigate to "Project" "Management"
    And ui: Search for recently created project in PM Grid
    And ui: I click on the project
    Given ui: Click on Checkout button in SPA and wait for Release button
    And ui: Unselect all and Select specific assignment attributes in SPA
    And ui: Click on resource expand icon
    And ui: I double click on specific Assignment Attribute in SPA
    And ui: I validate that the newly created attribute has option "1" as "enabled" on SPA
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    Then ui: Softassert all

  @testId=ST-2139
  @issue=SG-12498
  @9.1
  Scenario: Check Year mode in SPA
    Given setup: Test Data "Project"
    And setup: Test Data "Resource"
    And setup: Test Data "SoftAssert"
    When ui: I navigate to "Admin" "Settings"
    And ui: Click on General Settings tile
    And ui: Click on "Global" tab in General Settings
    And ui: I validate if mode of entry "Year" is "enabled"
    And ui: Quick navigate to "Resource Management"
    And ui: I create a new Resource with email, username, password
    And ui: Quick navigate to "Project Management"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Enter Start date as "01.01.2024" and End date as "31.12.2024" in SPA
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Year" in SPA
    And ui: Allocate "1200" hours for resource to project in SPA in Year mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: I select specific date mode "Month" in SPA
    And ui: Validate "105.34,96.18,96.18,100.76,105.34,91.6,105.34,100.76,96.18,105.34,96.18,100.76" hours for resource to project in SPA in "Month" mode for current year
    And ui: I select specific date mode "Year" in SPA
    And ui: Validate "1200" hours for resource to project in SPA in "Year" mode for current year
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    And ui: Remove a directory as:"ST-2139_Downloads" in projects's root directory
    And ui: Create a new directory as:"ST-2139_Downloads" in projects's root directory
    And ui: Set downloads directory as:"ST-2139_Downloads" in projects's root directory

    And ui: I click on export button in SPA
    Then ui: Softassert if SPA file got downloaded in directory:"ST-2139_Downloads" under project's root directory

    And ui: I switch to Project Option "Snapshots"
    And ui: I create project snapshot from project option
    And ui: I validate snapshot is created
    And ui: Click on Project navigation dropdown and select "Allocations"
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Year" in SPA
    And ui: Validate "1200" hours for resource to project in SPA in "Year" mode for current year
    And ui: I select specific date mode "Month" in SPA
    And ui: Validate "105.34,96.18,96.18,100.76,105.34,91.6,105.34,100.76,96.18,105.34,96.18,100.76" hours for resource to project in SPA in "Month" mode for current year
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    Then ui: Softassert all

  @9.2
  @TR
  Scenario: Team Resource - Resource Replace
    Given setup: Test Data "SoftAssert"
    Given ui: Quick navigate to "Resource Management"
    When setup: Test Data "Resource"
    And ui: I create two resource with username, password and Administrator global role

    And setup: Test Data "Team Resource"
    And ui: I create two team resource
    And ui: Wait for 4 seconds
    And ui: Quick navigate to "Resource Management"
    And ui: I search for Team Resource "1" in the global search and click on it
    And ui: Click on Resource navigation button and select "Team Capacity"
    And ui: Search for recently created resource "1" in RM Grid for inclusion
    And ui: I select the resource "1" in Team Capacity
    And ui: I enter current year in start and End date in BPAFG
    Then ui: I update the Team resource

    # # Add Story Point to the Team Resource 1
    # And ui: I click on "Story points" tab under Team Resource
    # And ui: Allocate "100" story points for Team Resource in TR Capacity in Month mode for current year
    # And ui: Validate "184,160,168,176,176,168,184,168,176,184,160,184" story costs for Team Resource in TR Capacity in Month mode for current year

    And ui: Quick navigate to "Resource Management"
    And ui: I search for Team Resource "2" in the global search and click on it
    And ui: Click on Resource navigation button and select "Team Capacity"
    And ui: Search for recently created resource "2" in RM Grid for inclusion
    And ui: I select the resource "2" in Team Capacity
    And ui: I enter current year in start and End date in BPAFG
    Then ui: I update the Team resource

  @9.2
  @TR
  Scenario: Team Resource - Project Update SPA
    Given setup: Test Data "SoftAssert"
    Given ui: Quick navigate to "Resource Management"
    When setup: Test Data "Resource"
    And ui: I create two resource with username, password and Administrator global role

    And setup: Test Data "Team Resource"
    And ui: I create two team resource
    And ui: Wait for 4 seconds
    And ui: Quick navigate to "Resource Management"
    And ui: I search for Team Resource "1" in the global search and click on it
    And ui: Click on Resource navigation button and select "Team Capacity"
    And ui: Search for recently created resource "1" in RM Grid for inclusion
    And ui: I select the resource "1" in Team Capacity
    And ui: I enter current year in start and End date in BPAFG

    # Add Story Point to the Team Resource 1
    Then ui: I click on "Story points" tab under Team Resource
    And ui: Allocate "100" story points for Team Resource "1" in TR Capacity in Month mode for current year
    And ui: Validate "184,160,168,176,176,168,184,168,176,184,160,184" story costs for Team Resource in TR Capacity in Month mode for current year
    And ui: I update the Team resource

    And ui: Quick navigate to "Resource Management"
    And ui: I search for Team Resource "2" in the global search and click on it
    And ui: Click on Resource navigation button and select "Team Capacity"
    And ui: Search for recently created resource "2" in RM Grid for inclusion
    And ui: I select the resource "2" in Team Capacity
    And ui: I enter current year in start and End date in BPAFG
    Then ui: I update the Team resource

    And setup: Test Data "Project"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "FTE" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "2" hours for Team Resource "1" to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: I click on specific unit "Story Points" in SPA

    And ui: Validate "200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200" for Team Resource "1" to project in SPA in "Month" mode for current year
    And ui: I select specific date mode "Year" in SPA
    And ui: Validate "2400" for Team Resource "1" to project in SPA in "Year" mode for current year
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA

    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Wait for 1 second
    And ui: I click on meat ball icon for team resource "1" and select "Resource Replace" option
    And ui: I search for Team Resource "2" in the PM or RM tab
    And ui: I select the newly created "2" team resource in resource replace
    Then ui: I click on Replace Resource with redistribute and verify resource is replaced
    Then ui: Softassert all

  @9.2
  @TR
  Scenario: Team Resource - Check Story points capacity warning in SPA.
    Given ui: Quick navigate to "Resource Management"
    When setup: Test Data "Resource"
    When setup: Test Data "SoftAssert"
    And ui: I create a new Resource with email, username, password

    And ui: I navigate to "Dashboard"
    When ui: I navigate to "Resource" "Management"
    And setup: Test Data "Team Resource"
    And ui: I create a new team resource
    And ui: Click on Resource navigation button and select "Team Capacity"
    And ui: I enter current year in start and End date in BPAFG
    And ui: Search for recently created "resource" in RM Grid
    And ui: I select the "resource" in Team Capacity
    And ui: I click on Save button for Team Resource

    Given ui: Quick navigate to "Admin Settings"
    And ui: Click on General Settings tile
    And ui: I toggle Multi Assignment to "Off" in General settings global tab
    And ui: Click on Save button in General Settings and wait for Save button to be clickable again
    And ui: Wait for 1 second
    And ui: Check fiscal month and fiscal quarter
    And ui: Click on Save button in General Settings and click on Save Settings button if displayed

    Given ui: Quick navigate to "Admin Settings"
    When ui: I navigate to specific tile "Fiscal Period Management" in admin settings
    And ui: I create fiscal period for "current" year in fiscal period management
    And ui: I click on save button in fiscal period management
    And ui: Wait for 4 seconds

    Given ui: I navigate to "Dashboard"
    When ui: Click on "Admin Settings" tile in homepage
    When ui: I navigate to "Financial" "Categories"
    And ui: I click on create new financial category
    And ui: I enter a name for Financial Category with "Positve" and type as "Default"
    And ui: I click on Save button in the financial category create model

    And ui: Quick navigate to "Project Management"
    And setup: Test Data "Project"
    And ui: Create a new Regular Project and set year as:"2025" for allocations
    And ui: Click on Project navigation dropdown and select "Financials"
    And ui: Click on Checkout button in Financials and wait for Release button
    And ui: I select recently created financial category
    And ui: Select Date mode as:"Month" in Financials if not already selected
    And ui: I allocate "100" hours to the financial category for each months
    And ui: Select Date mode as:"Quarter" in Financials if not already selected
    And ui: Click on Include labor costs toggle turn "On"
    And ui: Click on Save and Check In button in Financials and wait for Checkout button
    And ui: Click on Project navigation dropdown and select "Allocations"
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Unselect Columns if any in SPA
    And ui: Allocate "100" hours for team resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Enter start date as "first" of the month "Nov" of previous year in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA for cellhead:"Nov 24" when dataset is "Allocation"
    # yet to add the logic of validaitng it across different date modes and units

  @issue=ST-2480
  @9.2.1
  Scenario: SPA - Copy Allocation to Demand
    Given setup: Test Data "Resource"
    And setup: Test Data "SoftAssert"
    And ui: I navigate to "Admin" "Settings"
    And ui: Click on General Settings tile
    And ui: Click on "Global" tab in General Settings
    And ui: I toggle Working Weekends to "On" in General settings global tab
    And ui: Click on Save button in General Settings and wait for Save button to be clickable again
    And ui: Quick navigate to "Resource Management"
    And ui: I create a new Resource with email, username, password
    And setup: Test Data "Project"
    And ui: Quick navigate to "Project Management"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Day" in SPA
    And ui: Allocate "2" hours for resource to project in SPA in Day mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: Click on Checkout button in SPA and wait for Release button
    When ui: I copy allocation to demand
    And ui: Verify if resource has "2" hours in cell number:"4" in SPA when dataset is "Allocation"
    And ui: Click on dataset dropdown and select "Demand" in SPA
    And ui: Select Assignment Type as:"Planned" in SPA if not already selected
    And ui: I select specific date mode "Day" in SPA
    And ui: Verify if resource has "2" hours in cell number:"4" in SPA when dataset is "Demand"
    And ui: Allocate "8" hours for resource to project in SPA in Day mode for current year when dataset is "Demand" and assignment type "Planned"
    And ui: Click on dataset dropdown and select "Allocation" in SPA
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Day" in SPA
    Then ui: Validate "2" hours for resource to project in SPA in Day mode for seven days work week in SPA when dataset is "Allocation"
    Then ui: Softassert all

  @9.2
  @TR
  Scenario: Heatmap should be stay applied when using date filters
    Given setup: Test Data "Project"
    When setup: Test Data "Resource"
    And setup: Test Data "SoftAssert"
    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    Given ui: Quick navigate to "Resource Management"
    And setup: Test Data "Team Resource"
    And ui: I create a new team resource
    And ui: Click on Resource navigation button and select "Team Capacity"
    And ui: I enter current year in start and End date in BPAFG
    And ui: Search for recently created "resource" in RM Grid
    And ui: I select the "resource" in Team Capacity
    Then ui: I update the Team resource

    And ui: Quick navigate to "Project Management"
    And ui: Create a new Regular Project and set year as:"2025" for allocations
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate specific "0,5,10,20,0,5,10,20,0,5,10,20" hours for team resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"

    And ui: Click on Options button in SPA
    And ui: I click on specific heatmap toggle "Resource" in SPA grid options dialog
    And ui: I toggle overlay heatmap for rows option to "On" in SPA grid options dialogs
    And ui: I toggle overlay heatmap for groups option to "On" in SPA grid options dialogs
    And ui: Clear dates of Date Range Filter in Grid options of SPA
    And ui: Enter start date as "13.05.2025" in Grid options of SPA
    And ui: Close Options section in SPA
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA

    Then ui: Verify if column "May 25" of recently added team resource has heatmap color as:"#acf395" in SPA when dataset is:"Allocation"
    Then ui: Verify if column "Jun 25" of recently added team resource has heatmap color as:"#acf395" in SPA when dataset is:"Allocation"
    Then ui: Verify if column "Jul 25" of recently added team resource has heatmap color as:"#ffffb7" in SPA when dataset is:"Allocation"
    Then ui: Verify if column "Aug 25" of recently added team resource has heatmap color as:"#FFAD91" in SPA when dataset is:"Allocation"
    Then ui: Verify if column "Sep 25" of recently added team resource has heatmap color as:"#acf395" in SPA when dataset is:"Allocation"
    Then ui: Verify if column "Oct 25" of recently added team resource has heatmap color as:"#acf395" in SPA when dataset is:"Allocation"
    Then ui: Verify if column "Nov 25" of recently added team resource has heatmap color as:"#ffffb7" in SPA when dataset is:"Allocation"
    Then ui: Verify if column "Dec 25" of recently added team resource has heatmap color as:"#FFAD91" in SPA when dataset is:"Allocation"


    #  Add all modes and granularities for TR story points in SPA
    #  Add logic for heatmap validation in Reosurce Request from SPA
    #  Delete a Team resource in SPA and check capacity in NA under CPA
    #  Check for Total row in SPA for TR for all modes

  @issue=SG-14398
  @9.2.1
  Scenario: SPA- when viewing non generic tasks only, grouping by task, and using Add Assignment and then enter assignment attributes, none are saved
    When setup: Test Data "Resource"
    And setup: Test Data "SoftAssert"
    And setup: Test Data "Project"
    Given setup: Test Data setup for Attribute of type:"String" with "0" number of selection values, "0" number of default values and create default values:"true"

    When ui: Quick navigate to "Admin Settings"
    And ui: Click on "Attribute Management" tile in Admin settings

    And ui: Create Rich text type attributes in "Assignment" tab with default values and add them to "Required Fields" section

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Click on Group By dropdown in SPA and select "Task"
    
    And ui: I click on options dropdown in SPA
    And ui: Click on option: "Non-Generic" in Tasks to Show in Grid Options of SPA
    Then ui: I verify client or server error warning is not displayed
    And ui: Press Escape Key

    And ui: Add a new task in SPA when dataset is "Allocation"

    And ui: Select attributes created earlier in SPA
    
    And ui: I click on Add Assignment when dataset is "Allocation"
    And ui: I validate Bulk Assignment Dialog Open
    And ui: I click on "Bulk" section in add assignment in SPA
    And ui: I search for the previously created resource and task, and add to project
    And ui: I change recently created rich text attribute value in SPA
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    And ui: I verify that attribute value is changed after saving

    Then ui: Softassert all

  @issue=SG-14449
  @9.2.1
  Scenario:Date range filters not working at Project > Allocation page.
    Given setup: Test Data "Project"
    And setup: Test Data "Resource"
    And setup: Test Data "Project"
    And ui: Quick navigate to "Project Management"
    When ui: Create a new Regular Project with current year as date for allocations
    And ui: Click on Options button in SPA
    And ui: I will set date filter to "+6 Months"
    And ui: Enter current year as date for the project in SPA
    And ui: I open Bulk assignment popup
  
  @issue=SG-14488
  @9.2.1
  Scenario: Getting error when change date range , goto Gantt tab and change end date of project.
    Given setup: Test Data "Project"
    And setup: Test Data "Resource"
    And setup: Test Data "Project"
    And ui: Quick navigate to "Project Management"
    When ui: Create a new Regular Project with current year as date for allocations
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Click on Options button in SPA
    And ui: I will set date filter to "+6 Months"
    And ui: Close Options section in SPA
    And ui: I click on specific unit "Gantt" in SPA
    And ui: Enter Start date as "01.03.2024" and End date as "31.03.2024" in SPA
    Then ui: I verify client or server error warning is not displayed

  @issue=SG-14722
  @issue=SG-14780
  @issue=SG-14397
  @bugT
  @9.2.1
  @9.3.0
  @owner=Devanshi
  Scenario: SPA - when filtering by date in SPA via Options, FTE totals are off
    Given setup: Test Data "Resource"
    And setup: Test Data "SoftAssert"
    And setup: Test Data "Project"

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"
    And ui: Turn "On" Is demand planning resource toggle button in Resource Capacity tab
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on Add Assignment when dataset is "Allocation"
    And ui: I click on "Bulk" section in add assignment in SPA
    And ui: I click on filters in add assignment
    And ui: I click on Choose filters
    And ui: I select filter "Demand Planning" in add assignment
    And ui: I click on "is true" as filter in add assignment
    And ui: I validate that recently created resource is visible in add assignment tab
    And ui: I select recently created resource and click on add button
    And ui: I verify that added demand planned resource is visible in project allocation

    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Enter Start date as "01.01.2024" and End date as "31.12.2030" in SPA
    And ui: I click on specific unit "FTE" in SPA
    And ui: Click on Options button in SPA
    And ui: Click on option: "All" in Tasks to Show in Grid Options of SPA
    And ui: I will set date filter to "+6 Months"
    And ui: Press Escape Key
    And ui: I validate that total row cells has some value in SPA in "6" cells for current year when dataset is "Allocation"

    And ui: I select specific date mode "Week" in SPA
    And ui: I validate that total row cells has some value in SPA in "16" cells for current year when dataset is "Allocation"

    And ui: Click on Options button in SPA
    And ui: I will set date filter to "+3 Months"
    And ui: Press Escape Key
    And ui: I select specific date mode "Month" in SPA
    And ui: I validate that total row cells has some value in SPA in "3" cells for current year when dataset is "Allocation"

    And ui: I select specific date mode "Week" in SPA
    And ui: I validate that total row cells has some value in SPA in "10" cells for current year when dataset is "Allocation"

    And ui: Softassert all

  @issue=SG-14655
  @bugT
  @9.3.0
  @owner=Devanshi
  Scenario: Getting server error when do bulk assignment with new manually created task at SPA
    Given setup: Test Data "Resource"
    And setup: Test Data "SoftAssert"
    And setup: Test Data "Project"
    And api: I create a default resource for automation with default rate as "100"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Click on Group By dropdown in SPA and select "Task"    
    And ui: I click on options dropdown in SPA
    And ui: Click on option: "All" in Tasks to Show in Grid Options of SPA
    And ui: Press Escape Key
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Add a new task in SPA when dataset is "Allocation"
    And ui: Allocate "100" hours for resource task in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    Then setup: Test Data "Resource"
    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on Add Assignment when dataset is "Allocation"
    And ui: I validate Bulk Assignment Dialog Open
    And ui: I click on "Bulk" section in add assignment in SPA
    And ui: I search for the previously created resource and task, and add to project
    Then ui: I verify client or server error warning is not displayed 
    Then ui: Softassert all

  @issue=SG-14669
  @bugT
  @9.3.0
  @owner=Devanshi
  Scenario: Unable to view project Financial page getting server error.
    Given setup: Test Data "Project"
    And setup: Test Data "SoftAssert"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Project navigation dropdown and select "Financials"
    Then ui: I verify client or server error warning is not displayed 
    Then ui: Softassert all
    
  @issue=SG-14897
  @bugT
  @9.3.0
  @owner=Devanshi
  Scenario: The redistribute function is not working properly in resource replace.
    Given setup: Test Data "Resource"
    Given setup: Test Data "Resource2"
    And setup: Test Data "SoftAssert"
    And setup: Test Data "Project"
    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"
    And ui: Quick navigate to "Resource Management"
    And ui: Create a new Resource with email, username, password with model: "Resource2"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"

    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    #Resource Replace
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Click on Group By dropdown in SPA and select "Resource"
    And ui: I click on meat ball icon for "resource" on index "2" and select "Resource Replace" option
    And ui: I search and select resource2 in resource replace
    And ui: I click on Replace Resource with redistribute
    And ui: I verity that resource is replaced with resource2 in SPA
    Then ui: Verify if resource2 has "100" hours for every month of current year in SPA when dataset is "Allocation"
    Then ui: I verify client or server error warning is not displayed
    
    Then ui: Softassert all
  
  @issue=SG-15182
  @bugT
  @9.3.0
  @owner=Devanshi
  Scenario: SPA - when dominant unit is FTE, and enter 1 FTE, heatmap is incorrect
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "SoftAssert"
    Given ui: Quick navigate to "Admin Settings"
    And ui: Click on General Settings tile
    And ui: I toggle Multi Assignment to "Off" in General settings global tab
    And ui: Click on Save button in General Settings and wait for Save button to be clickable again
    And ui: Click on "Unit Settings" tab in General Settings
    And ui: I select current dominant unit "FTE" in general settings unit settings tab
    And ui: Click on Save button in General Settings and click on Save Settings button if displayed
    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "FTE" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "1" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Click on Insert columns dropdown in SPA
    And ui: I uncheck all attribute in insert columns dropdown in BPAFG
    And ui: Click on Insert columns dropdown in SPA
    And ui: Click on Options button in SPA
    And ui: I click on specific heatmap toggle "Resource" in SPA grid options dialog
    And ui: I toggle overlay heatmap for rows option to "On" in SPA grid options dialogs
    And ui: I toggle overlay heatmap for groups option to "On" in SPA grid options dialogs
    And ui: Press Escape Key

    And ui: Clear quick search in SPA
    And ui: I select specific date mode "Month" in SPA
    Then ui: I select specific unit "FTE,FTE %" and verify specific cell "1" heatmap color "#FFAD91" in SPA for current year when dataset is "Allocation"
    Then ui: I select specific unit "FTE,FTE %" and verify specific cell "2" heatmap color "#FFAD91" in SPA for current year when dataset is "Allocation"
    Then ui: I select specific unit "FTE,FTE %" and verify specific cell "3" heatmap color "#FFAD91" in SPA for current year when dataset is "Allocation"
    Then ui: I select specific unit "FTE,FTE %" and verify specific cell "4" heatmap color "#FFAD91" in SPA for current year when dataset is "Allocation"
    Then ui: I select specific unit "FTE,FTE %" and verify specific cell "5" heatmap color "#FFAD91" in SPA for current year when dataset is "Allocation"
    Then ui: I select specific unit "FTE,FTE %" and verify specific cell "6" heatmap color "#FFAD91" in SPA for current year when dataset is "Allocation"
    
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    Then ui: Quick navigate to "Admin Settings"
    And ui: Click on General Settings tile
    And ui: I toggle Multi Assignment to "Off" in General settings global tab
    And ui: Click on Save button in General Settings and wait for Save button to be clickable again
    And ui: Click on "Unit Settings" tab in General Settings
    And ui: I select current dominant unit "Time" in general settings unit settings tab
    And ui: Click on Save button in General Settings and click on Save Settings button if displayed

    Then ui: Softassert all

  @issue=SG-15550
  @issue=SG-15441
  @bugT
  @9.3.1
  @owner=Devanshi
  Scenario: Project > SPA : Getting an error when adding a new assignment in the Demand tab after copying the allocation to the demand
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "Resource2"
    Given setup: Test Data "SoftAssert"

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And ui: Quick navigate to "Resource Management"
    And ui: Create a new Resource with email, username, password with model: "Resource2"

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource task in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    And ui: Click on Checkout button in SPA and wait for Release button
    When ui: I copy allocation to demand
    And ui: Click on dataset dropdown and select "Demand" in SPA
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: I click on Add Assignment when dataset is "Demand"
    And ui: I validate Bulk Assignment Dialog Open
    And ui: I click on "Single" section in add assignment in SPA
    And ui: I search for the previously created "Resource3" and "Non-GenericTask", select and add to project
    And ui: Verify if resource2 has "0" hours for every month of current year in SPA when dataset is "Demand"
    Then ui: I verify client or server error warning is not displayed

    Then ui: Softassert all
  
  @issue=SG-14669
  @bugT
  @9.3.0
  @owner=Devanshi
  Scenario: Unable to view project Financial page getting server error.
    Given setup: Test Data "Project"
    And setup: Test Data "SoftAssert"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Project navigation dropdown and select "Financials"
    Then ui: I verify client or server error warning is not displayed 
    Then ui: Softassert all
  
  @issue=SG-15548
  @issue=SG-15540
  @bugT
  @9.3.1
  Scenario: Project > SPA : Getting an error when trying to clear the allocation for a newly added resource in the 'group by task' configuration
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "Resource2"
    Given setup: Test Data "SoftAssert"
    And api: I create a default resource for automation with default rate as "100"

    And ui: Quick navigate to "Project Management"
    And ui: Clear filters if any in PM Grid
    And ui: Ungroup groups if any in PM Grid
    And ui: Create a new Regular Project and set current year as date for allocations
    Then ui: I verify client or server error warning is not displayed
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on group by dropdown and select "Resource" in SPA
    And ui: Add recently created resource in SPA when dataset is "Allocation"
    And ui: I click on group by dropdown and select "Task" in SPA
    And ui: I click on expand all icon in SPA
    Then ui: I verify client or server error warning is not displayed
    And ui: I click on meat ball icon for "resource" on index "2" and select "Clear" option
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    Then ui: I verify client or server error warning is not displayed
    Then ui: Softassert all
  
  @issue=SG-15542
  @bugT
  @9.3.1
  Scenario: Project > SPA : Unable to delete the newly added single assignment task
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "Resource2"
    Given setup: Test Data "SoftAssert"
    And api: I create a default resource for automation with default rate as "100"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on group by dropdown and select "Resource" in SPA
    And ui: Click on dataset dropdown and select "Allocation" in SPA
    And ui: I click on Add Assignment when dataset is "Allocation"
    And ui: I validate Bulk Assignment Dialog Open

    And ui: I click on "Single" section in add assignment in SPA
    And ui: I add a new task and select recently created reource for single task in add assignment in SPA
    And ui: I click on group by dropdown and select "Task" in SPA
    And ui: I click on meat ball icon for "non-generictask" on index "2" and select "Delete" option
    Then ui: I verify client or server error warning is not displayed

    Then ui: Softassert all
  
  @issue=SG-15536
  @bugT
  @9.3.1
  Scenario: Project >SPA : Getting an error when checking out a project, expanding resources, and then going to the Gantt tab
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "SoftAssert"

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button  

    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on expand all icon in SPA
    And ui: I click on specific unit "Gantt" in SPA
    And ui: I hover on gantt bar for recently created resource in SPA

    Then ui: I verify client or server error warning is not displayed

    Then ui: Softassert all
  
  @issue=SG-15624
  @bugT
  @9.3.1
  Scenario: Project > SPA : Getting an error when trying to delete a task after adding it through bulk assignment
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "SoftAssert"
    
    When ui: Quick navigate to "Resource Management"
    And ui: I create two resource with username, password and Administrator global role
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Click on Group By dropdown in SPA and select "Task"    
    And ui: I click on options dropdown in SPA
    And ui: Click on option: "All" in Tasks to Show in Grid Options of SPA
    And ui: Press Escape Key
    And ui: Add a new task in SPA when dataset is "Allocation"
    And ui: I click on Add Assignment when dataset is "Allocation"
    And ui: I validate Bulk Assignment Dialog Open
    And ui: I click on "Bulk" section in add assignment in SPA
    And ui: I search for the previously created "Resource1", select and add to project
    And ui: I click on Add Assignment when dataset is "Allocation"
    And ui: I validate Bulk Assignment Dialog Open
    And ui: I click on "Bulk" section in add assignment in SPA
    And ui: I search for the previously created "Resource2", select and add to project
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: Click on Checkout button in SPA and wait for Release button
    Then ui: I verify quick search option is displayed
    And ui: I click on group by dropdown and select "Task" in SPA
    Then ui: Quick search "Non-GenericTask" and verify specific ResourceOrTask is displayed in SPA
    And ui: I click on meat ball icon for "non-generictask" on index "2" and select "Delete" option
    Then ui: I verify client or server error warning is not displayed

    Then ui: Softassert all
  
  @issue=SG-15501
  @issue=SG-15378
  @issue=SG-15373
  @issue=SG-15766
  @bugT
  @9.3.1
  Scenario: Project > SPA : An error occurs when the user copies allocation to a demand for a manually added task and then navigates to the demand tab during project creation process.
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "SoftAssert"
    And api: I create a default resource for automation with default rate as "100"
    
    When ui: Quick navigate to "Project Management"
    And ui: I create a new Project without click on create button
    And ui: Add recently created resource in SPA when dataset is "Allocation"
    Then ui: I verify client or server error warning is not displayed
    And ui: I click on meat ball icon for "resource" on index "2" and validate that "Resource Replace" option is not displayed
    And ui: Click on dataset dropdown and select "Allocation" in SPA
    And ui: I click on meat ball icon for "resource" on index "2" and select "Delete" option
    
    And ui: I click on Add Assignment when dataset is "Allocation"
    And ui: I validate Bulk Assignment Dialog Open
    And ui: I click on "Single" section in add assignment in SPA
    And ui: I enter value as "8" hours in add assignment SPA
    And ui: I add a new task and select recently created reource for single task in add assignment in SPA
    Then ui: Quick search "Resource" and verify specific ResourceOrTask is displayed in SPA

    When ui: I copy allocation to demand
    And ui: Click on dataset dropdown and select "Demand" in SPA
    Then ui: I verify client or server error warning is not displayed

    Then ui: Softassert all
  
  @issue=SG-15618
  @bugT
  @9.3.1
  Scenario: Project > SPA : An error occurs when performing a resource replacement in the group by > task
    Given setup: Test Data "Resource"
    Given setup: Test Data "Resource2"
    And setup: Test Data "SoftAssert"
    And setup: Test Data "Project"

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And ui: Quick navigate to "Resource Management"
    And ui: Create a new Resource with email, username, password with model: "Resource2"

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    #Resource Replace
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Click on Group By dropdown in SPA and select "Task" 
    And ui: I click on meat ball icon for "resource" on index "2" and select "Resource Replace" option
    And ui: I search and select resource2 in resource replace
    And ui: I click on Replace Resource with redistribute
    Then ui: Verify if resource2 has "100" hours for every month of current year in SPA when dataset is "Allocation"
    Then ui: I verify client or server error warning is not displayed
    
    Then ui: Softassert all

  @issue=SG-15310
  @bugT
  @9.3.1
  Scenario: Project > SPA : Copying allocation to demand (or vice versa) is not working.
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "Resource2"
    Given setup: Test Data "SoftAssert"

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And ui: Quick navigate to "Resource Management"
    And ui: Create a new Resource with email, username, password with model: "Resource2"

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    And ui: Click on Checkout button in SPA and wait for Release button
    When ui: I copy allocation to demand
    And ui: Click on dataset dropdown and select "Demand" in SPA
    And ui: Click on Group By dropdown in SPA and select "Resource"
    And ui: Verify if resource has "100" hours for specific cell "Jan 25" in SPA when dataset is "Demand"
    
    And ui: Softassert all

  @issue=SG-15299
  @bugT
  @9.3.1
  Scenario: The Delete button for resources is not available in SPA.
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "Resource2"
    Given setup: Test Data "SoftAssert"

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And ui: Quick navigate to "Resource Management"
    And ui: Create a new Resource with email, username, password with model: "Resource2"

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource task in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on meat ball icon for "resource" on index "2" and select "Delete" option
    Then ui: I verify client or server error warning is not displayed

    And ui: Softassert all
  
  @issue=SG-15167
  @issue=SG-15666
  @issue=SG-15750
  @issue=SG-15786
  @9.3.1
  Scenario: SPA: Create new assignment
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "SoftAssert"
    And ui: Quick navigate to "Admin Settings"
    And ui: Click on General Settings tile
    And ui: Click on "Global" tab in General Settings
    And ui: I toggle Working Weekends to "On" in General settings global tab
    And ui: Click on Save button in General Settings and wait for Save button to be clickable again

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Enter Start date as "01.01.2024" and End date as "31.12.2030" in SPA
    And ui: Click on dataset dropdown and select "Allocation" in SPA
    And ui: I click on Add Assignment when dataset is "Allocation"
    And ui: I validate Bulk Assignment Dialog Open
    And ui: I click on "Single" section in add assignment in SPA
    And ui: I verify "start date" is "01.01.2024" in BPAFG
    And ui: I verify "end date" is "31.12.2030" in BPAFG
    Then ui: I verify all quick filter options are displayed in RM netavailability tab
    Then ui: I click on individual quick filter options and validate resource created using model, start date and end date in SPA or BPAFG
    And ui: I click on specific unit "Cost" in Add Assignment SPA
    And ui: I click on specific unit "FTE" in Add Assignment SPA
    And ui: I click on specific unit "FTE %" in Add Assignment SPA
    And ui: I click on specific unit "Manday" in Add Assignment SPA
    And ui: I click on specific unit "Time" in Add Assignment SPA

    And ui: I turn "Off" apply to weekends button in Add Assignemnt In SPA
    And ui: I enter value as "8" hours in add assignment SPA

    And ui: I add a new task and select recently created reource for single task in add assignment in SPA
    Then ui: Quick search "Resource" and verify specific ResourceOrTask is displayed in SPA

    And ui: I click on Add Assignment when dataset is "Allocation"
    And ui: I validate Bulk Assignment Dialog Open
    And ui: I click on "Single" section in add assignment in SPA
    
    And ui: I validate that recently created resource is visible in add assignment tab
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    And ui: Quick navigate to "Admin Settings"
    And ui: Click on General Settings tile
    And ui: Click on "Global" tab in General Settings
    And ui: I toggle Working Weekends to "Off" in General settings global tab
    And ui: Click on Save button in General Settings and wait for Save button to be clickable again

    And ui: Softassert all
  
  @issue=SG-15152
  @9.3.1
  Scenario: Add Fiscal Year to SPA
    Given ui: Quick navigate to "Resource Management"
    When setup: Test Data "Resource"
    When setup: Test Data "SoftAssert"
    And setup: Test Data "Project"
    And ui: I create a new Resource with email, username, password

    Given ui: Quick navigate to "Admin Settings"
    When ui: I navigate to specific tile "Fiscal Period Management" in admin settings
    And ui: I create fiscal period for "current" year in fiscal period management
    And ui: I click on save button in fiscal period management
    And ui: Wait for 4 seconds

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    When ui: I select specific date mode "Fiscal Month" in SPA
    When ui: I select specific date mode "Fiscal Quarter" in SPA
    When ui: I select specific date mode "Fiscal Year" in SPA
    Then ui: Softassert all

  @issue=SG-15442
  @9.3.1
  Scenario: SPA : Getting an error when adding a new assignment with the selected cost unit.
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "Resource2"
    Given setup: Test Data "SoftAssert"

    And ui: Quick navigate to "Admin Settings"
    And ui: Click on General Settings tile
    And ui: Click on "Global" tab in General Settings
    And ui: I toggle Working Weekends to "On" in General settings global tab
    And ui: Click on Save button in General Settings and wait for Save button to be clickable again

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And ui: Quick navigate to "Resource Management"
    And ui: Create a new Resource with email, username, password with model: "Resource2"

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Enter Start date as "01.01.2024" and End date as "31.12.2030" in SPA
    And ui: I click on Add Assignment when dataset is "Allocation"
    And ui: I click on "Single" section in add assignment in SPA
    Then ui: I verify all quick filter options are displayed in RM netavailability tab
    Then ui: I click on individual quick filter options and validate resource created using model, start date and end date in SPA or BPAFG
    And ui: I click on specific unit "Cost" in Add Assignment SPA

    And ui: I turn "On" apply to weekends button in Add Assignemnt In SPA

    And ui: I add a new task and select recently created reource for single task in add assignment in SPA
    Then ui: I verify client or server error warning is not displayed
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    And ui: Quick navigate to "Admin Settings"
    And ui: Click on General Settings tile
    And ui: Click on "Global" tab in General Settings
    And ui: I toggle Working Weekends to "Off" in General settings global tab
    And ui: Click on Save button in General Settings and wait for Save button to be clickable again
    Then ui: Softassert all

  @issue=SG-15467
  @9.3.1
  Scenario: Create New Project > SPA : An error occurs when performing a 'Group by' task after copying the demand to allocation
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "Resource2"
    Given setup: Test Data "SoftAssert"

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And ui: Quick navigate to "Resource Management"
    And ui: Create a new Resource with email, username, password with model: "Resource2"

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Enter Start date as "01.01.2024" and End date as "31.12.2030" in SPA
    And ui: I click on Add Assignment when dataset is "Allocation"
    And ui: I validate Bulk Assignment Dialog Open
    And ui: I click on "Single" section in add assignment in SPA
    Then ui: I verify all quick filter options are displayed in RM netavailability tab
    Then ui: I click on individual quick filter options and validate resource created using model, start date and end date in SPA or BPAFG
    And ui: I click on specific unit "Time" in Add Assignment SPA

    And ui: I add a new task and select recently created reource for single task in add assignment in SPA
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I copy allocation to demand 
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Click on dataset dropdown and select "Allocation" in SPA
    And ui: I click on group by dropdown and select "Resource" in SPA
    Then ui: I verify client or server error warning is not displayed
    Then ui: Softassert all
  
  @issue=SG-15727
  @issue=SG-15667
  @issue=SG-15691
  @9.3.1
  Scenario: SPA > Assignment options > Current task name field
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "SoftAssert"

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on group by dropdown and select "Resource" in SPA
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Click on resource expand icon
    And ui: I click on meat ball icon for "resource" on index "2" and select "Assignment Options" option
    And ui: I validate that assignment options menu opened
    And ui: I validate that task name is required field in assignment in SPA
    And ui: I click on "Clone" tab in assignment options
    And ui: I validate that current assignment start date is:"01.01.2025" in assignment options
    And ui: I add a new task with same resource in assignment options
    And ui: I click on Apply button In Assignment options
    Then ui: Quick search "Non-GenericTask" and verify specific ResourceOrTask is displayed in SPA
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    And ui: Softassert all
  
  @issue=SG-15698
  @issue=SG-15691
  @9.3.1
  Scenario: Spa > Assignments Option > Shift should move allocation on the next working day if weekend selected as new start date
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "SoftAssert"
    And ui: Quick navigate to "Admin Settings"
    And ui: Click on General Settings tile
    And ui: Click on "Global" tab in General Settings
    And ui: I toggle Working Weekends to "Off" in General settings global tab
    And ui: Click on Save button in General Settings and wait for Save button to be clickable again
    And ui: Click on "Unit Settings" tab in General Settings
    And ui: I select current dominant unit "Time" in general settings unit settings tab
    And ui: Click on Save button in General Settings and wait for Save button to be clickable again

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Enter Start date as "01.04.2025" and End date as "16.04.2025" in SPA
    And ui: I click on group by dropdown and select "Resource" in SPA
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "160" hours for resource to project in SPA for cellhead:"Apr 25" when dataset is "Allocation"
    And ui: I select specific date mode "Day" in SPA
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Click on resource expand icon
    And ui: I click on meat ball icon for "resource" on index "2" and select "Assignment Options" option
    And ui: I validate that assignment options menu opened
    And ui: I validate that task name is required field in assignment in SPA
    And ui: I click on "Shift" tab in assignment options
    And ui: I enter new assignment start date is:"05.04.2025" in assignment options
    And ui: I click on Apply button In Assignment options
    And ui: Click on Save and Check In button in SPA and wait for Checkout button

    And ui: Verify if resource has "0" hours for specific cell "05 Apr 25" in SPA when dataset is "Allocation"
    And ui: Verify if resource has "0" hours for specific cell "06 Apr 25" in SPA when dataset is "Allocation"
    And ui: Verify if resource has "13.33" hours for specific cell "07 Apr 25" in SPA when dataset is "Allocation"

    And ui: Softassert all
  
  @issue=SG-15710
  @9.3.1
  Scenario: Project > SPA : The single assignment added is not showing if assignment is added after applying the manual date range filter
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "SoftAssert"

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Enter Start date as "01.03.2025" and End date as "30.04.2025" in SPA
    And ui: Click on dataset dropdown and select "Allocation" in SPA

    And ui: Click on Options button in SPA
    And ui: I turn on total column option turn "On"
    And ui: Enter start date as "first" of the month "Apr" of current year in Grid options of SPA
    And ui: Enter end date as "last" of the month "Apr" of current year in Grid options of SPA
    And ui: Press Escape Key

    And ui: I click on Add Assignment when dataset is "Allocation"
    And ui: I click on "Single" section in add assignment in SPA
    And ui: Enter Start date as "01.03.2025" and End date as "31.03.2025" in BPAFG
    And ui: I enter value as "80" hours in add assignment SPA
    And ui: I add a new task and select recently created reource for single task in add assignment in SPA

    And ui: Click on Options button in SPA
    And ui: Enter start date as "" in Grid options of SPA
    And ui: Enter end date as "" in Grid options of SPA
    And ui: Press Escape Key

    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: I select specific date mode "Month" in SPA
    And ui: I click on specific unit "Time" in SPA
    And ui: Verify if resource has "80" hours for specific cell "Total" in SPA when dataset is "Allocation"

    Then ui: Softassert all
  
  @issue=SG-15888
  @9.3.1
  Scenario: Project >> SPA >> Add Assignment. When adding an already assigned generic task, a server error occurs
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "SoftAssert"

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Click on dataset dropdown and select "Allocation" in SPA
    
    And ui: Click on Options button in SPA
    And ui: I turn on total column option turn "On"
    And ui: Press Escape Key

    And ui: I click on Add Assignment when dataset is "Allocation"
    And ui: I click on "Single" section in add assignment in SPA
    And ui: I enter value as "80" hours in add assignment SPA
    And ui: I add recently created "Resource" by selecting Generic task in Add Assignment

    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: I select specific date mode "Month" in SPA
    And ui: I click on specific unit "Time" in SPA
    And ui: Verify if resource has "80" hours for specific cell "Total" in SPA when dataset is "Allocation"

    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on Add Assignment when dataset is "Allocation"
    And ui: I click on "Single" section in add assignment in SPA
    And ui: I validate that already added "GenericTask" task cannot be selected for "Resource" in Add Assignemnt in SPA

    Then ui: Softassert all

  @issue=SG-15656
  @9.3.1
  Scenario: Project > SPA : An unauthorized user is able to access all resources from the single/bulk assignment popup.
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "SoftAssert"

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: Enter Start date as "01.03.2025" and End date as "30.04.2025" in SPA
    And ui: Click on dataset dropdown and select "Allocation" in SPA

    And ui: Click on dataset dropdown and select "Demand" in SPA
    And ui: I click on Add Assignment when dataset is "Demand"
    And ui: I validate Bulk Assignment Dialog Open
    And ui: I click on "Single" section in add assignment in SPA
    And ui: I add a new task and select recently created reource for single task in add assignment in SPA
    And ui: Click on Save and Check In button in SPA and wait for Checkout button
    And ui: Click on Checkout button in SPA and wait for Release button
    
    And ui: I click on Add Assignment when dataset is "Demand"
    And ui: I validate Bulk Assignment Dialog Open
    And ui: I click on "Single" section in add assignment in SPA
    Then ui: I verify all quick filter options are displayed in RM netavailability tab
    And ui: I click on "Bulk" section in add assignment in SPA
    Then ui: I verify quick search option is displayed

    Then ui: Softassert all

  @issue=SG-15788
  @9.3.1
  Scenario: SPA > Clone Assignment > Can create a second generic task for a resource
    Given setup: Test Data "SoftAssert"
    Given setup: Test Data "Project"
    Given setup: Test Data "Resource"
    Given setup: Test Data "Resource2"

    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And api: I create a default resource2 for automation with default rate as "100"
    And ui: I search for resource2 in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"

    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on group by dropdown and select "Resource" in SPA
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: I click on meat ball icon for "resource" on index "2" and select "Assignment Options" option
    And ui: I validate that assignment options menu opened
    And ui: I click on "Clone" tab in assignment options
    And ui: I toggle Change resource to "On" in Assignment operation in SPA
    And ui: I search "resource2" and select for resource field on assignment options in "resource1" 
    And ui: I select "Generic" task name in assignment options in SPA
    And ui: I toggle Change resource to "Off" in Assignment operation in SPA
    And ui: Wait for 4 seconds
    And ui: I validate task name or apply button in Assignment operation in SPA
    Then ui: Softassert all
  
  @issue=SG-14887
  @bugT
  @9.3.0
  Scenario: Date Quick Filter Should Not Be Clickable Before Checkout
    Given setup: Test Data "Project"
    Given setup: Test Data "SoftAssert"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Options button in SPA
    Then ui: I Validate That Date Quick Filter Should Not Be Clickable Before Checkout

  @issue=SG-14990
  @bugT
  @9.3.0
  Scenario: Unable to add allocation when enable threshold for Net Capacity.
    Given ui: I navigate to "Admin" "Settings"
    And ui: Click on General Settings tile
		And ui: Click on "Unit Settings" tab in General Settings
    Then ui: Wait for 4 seconds
		And ui: I turn "Allocation" threshold turn "ON" and use "Net Capacity" as threshold
    Then ui: Click on Save button in General Settings and wait for Save button to be clickable again 
    Then ui: Wait for 4 seconds
    
    And setup: Test Data "SoftAssert"
    And setup: Test Data "Project"
    And setup: Test Data "Resource"
    And api: I create a default resource for automation with default rate as "100"
    And ui: I search for resource in global search and click on it
    And ui: Click on Resource navigation button and select "Capacity"
    And ui: turn on has capacity toggle "On"
    And ui: I enter and save resource current year start and end date in capacity tab
    And setup: Test Data "Project"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Checkout button in SPA and wait for Release button
    And ui: I click on specific unit "Time" in SPA
    And ui: I select specific date mode "Month" in SPA
    And ui: Allocate "100" hours for resource to project in SPA in Month mode for current year when dataset is "Allocation" and assignment type "Planned"
    And ui: I validate that total capacity exceed warning is displayed
    Then ui: Click on Save and Check In button in SPA and wait for Checkout button

  # @issue=SG-14955
  # @bugT
  # @9.3.0
  # Scenario: PM - Build Team - Not Able to delete the resources when more than 4 are added unless and until we expand 
  #   Given setup: Test Data "SoftAssert"
  #   When setup: Test Data "Project"
  #   And setup: Test Data "Resource"
  #   And api: I create "4" default resources for automation with default rate as "1"
  #   And ui: I search for resource in global search and click on it
  #   # And api: I create a default resource for automation with default rate as "100"
  #   And api: I create a default project for automation with date range as "current" year
  #   And ui: Search for Project in global search and click on it
  #   And ui: Wait for 4 seconds
  #   And ui: Click on Project navigation dropdown and select "Build Team"
  #   And ui: Wait for 4 seconds
  #   And ui: Add recently created "resource" to build team
  #   And ui: Click on save button in Build Team and wait for it to be clickable
  #   And setup: Test Data "Resource"
  #   And api: I create a default resource for automation with default rate as "100"
  #   And ui: Wait for 4 seconds
  #   And ui: Wait for 4 seconds
  #   And ui: Wait for 4 seconds
  #   And ui: Wait for 4 seconds
  #   And ui: Wait for 4 seconds
  #   And ui: Add recently created "resource" to build team
  #   And ui: Click on save button in Build Team and wait for it to be clickable