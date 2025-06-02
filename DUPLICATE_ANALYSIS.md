# Duplicate Analysis Report

This report details duplicated content found within `.feature` and `.spec.ts` files in the repository.

## 1. Duplicates in `SingleProjectAllocation.feature`

### 1.1. Duplicate Scenario Names (after normalization)

**a) Normalized Name: "Heatmap should be stay applied when using date filters"**

*   **Original 1:**
    ```gherkin
    @testId=ST-1495
    @issue=SG-12407
    @issue=SG-11809
    @8.2
    Scenario: Heatmap should be stay applied when using date filters
    ```
*   **Original 2:**
    ```gherkin
    @9.2
    @TR
    Scenario: Heatmap should be stay applied when using date filters
    ```
    *Comment: These scenarios have different tags but the same core name after normalization.*

**b) Normalized Name: "Unable to view project Financial page getting server error."**

*   **Original 1 & 2:** (These are identical including tags)
    ```gherkin
    @issue=SG-14669
    @bugT
    @9.3.0
    @owner=Devanshi
    Scenario: Unable to view project Financial page getting server error.
    ```
    *Comment: These two scenarios appear to be exact duplicates.*

### 1.2. Duplicate Scenario Content (Identical Steps)

The following scenarios were found to have the exact same set of steps:

*   **Scenario Names:**
    *   `@issue=SG-14669 @bugT @9.3.0 @owner=Devanshi Scenario: Unable to view project Financial page getting server error.`
    *   `@issue=SG-14669 @bugT @9.3.0 @owner=Devanshi Scenario: Unable to view project Financial page getting server error.`

*   **Shared Steps:**
    ```gherkin
    Given setup: Test Data "Project"
    And setup: Test Data "SoftAssert"
    And api: I create a default project for automation with date range as "current" year
    And ui: Search for Project in global search and click on it
    And ui: Click on Project navigation dropdown and select "Financials"
    Then ui: I verify client or server error warning is not displayed
    Then ui: Softassert all
    ```
    *Comment: This confirms the scenarios listed in 1.1.b are indeed content duplicates.*

## 2. Duplicates in `SingleProjectAllocation.spec.ts`

### 2.1. Duplicate Step Definition Function Bodies

The following step definitions were found to have identical function bodies after normalization (comments removed, whitespace standardized):

*   **Step Definition 1:**
    ```typescript
    Then('ui: Add new resource to the SPA', async () => { /* normalized body */ });
    ```
*   **Step Definition 2:**
    ```typescript
    Then(/^ui: Update "([^"]*)" hours for resource to project in SPA in Project mode$/, async (hoursToBeAllocated: string) => { /* normalized body */ });
    ```

*   **Shared Normalized Body (snippet provided by analysis script, full bodies were compared):**
    ```typescript
    const resourceName = context().resourceSetup.name;
    await selectFromDropdown({
        dropdownOpener: Selectors.projectManagement.sPA.ddGroupByDropdown,
        dropdownSelection: locatorParse(Selectors.projectManagement.sPA.ddGroupByOption, "Resource"),
    // ... rest of the function body
    ```
    *Comment: These two step definitions likely perform very similar or identical actions and could be a candidate for refactoring to a shared helper function.*

---
End of Report
