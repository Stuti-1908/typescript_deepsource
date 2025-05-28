/* eslint-disable max-len */
import { Then, When } from '@cucumber/cucumber';
const moment = require('moment')
import { faker } from '@faker-js/faker';

import { clearTextUsingBackspace, clickOnBackspaceKey, clickToElement, clickToElementUsingJS, doubleClickToElement, element, elementDragAndDrop, elementGetText, elementParse, elementParseAndClick, formFill, getCurrencySymbol, getElementBackgroundColor, getFormattedDate2, hitEnter, isElementDisplayed, locatorParse, mayBeElement, reload, selectFromDropdown, slowInputFilling } from '../../../../../core/func';
import { DateFormats, GeneralSettings, GenericColorCodes, PlanType, ProjectEdit, ToggleStates } from '../../../../../core/enums';
import Selectors from '../../../../../core/selectors';
import { ELEMENT_TIMEOUT, MEDIUM_PAUSE, SHORT_PAUSE, SHORT_TIMEOUT } from '../../../../../core/timeouts';
import { context } from '../../../../../utils/context';
import { GeneralSettingsDefaultValues } from '../../../../../data/generalSettings';
import DateTime from '../../../../../core/datetime';
import { projectModel } from '../../../../../models/project.model';
import { SingleProjectAllocation } from '../../../../../helpers/ProjectManagement/ProjectEdit/SingleProjectAllocation.helper';
import { ProjectGrid } from '../../../../../helpers/ProjectManagement/Grid.helper';
import { Key } from 'webdriverio'
import { assert } from 'chai';
import { waitForFileToDownload } from '../../../../../core/fileUtilities';
import * as path from 'path';
import { browser, $, expect } from '@wdio/globals';
const projectId = [];

Then(/^ui: I quick search two non generic task and verify resource is not displayed in SPA$/, async () => {
  const resource1 = context().resource1;
  const resource2 = context().resource2;
  const task1 = context().taskName1;
  const task2 = context().taskName2;

  await formFill([
    { locator: Selectors.projectManagement.sPA.txtSearch, value: null, action: 'click' },
    { locator: Selectors.projectManagement.sPA.txtSearch, value: null, action: 'clearValue' },
    { locator: Selectors.projectManagement.sPA.txtSearch, value: task1, action: 'setValue' },
  ]);

  await context().softAssert.isFalse(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, resource1), SHORT_PAUSE), `Resource: {${resource1} is displayed}`);
  await context().softAssert.isFalse(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, resource2), SHORT_PAUSE), `Resource: ${resource2} is displayed}`);
  await context().softAssert.isFalse(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, task1), SHORT_PAUSE), `Task: {${task1} is displayed}`);
  await context().softAssert.isFalse(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, task2), SHORT_PAUSE), `Task: {${task2} is displayed}`);

  await formFill([
    { locator: Selectors.projectManagement.sPA.txtSearch, value: null, action: 'click' },
    { locator: Selectors.projectManagement.sPA.txtSearch, value: null, action: 'clearValue' },
    { locator: Selectors.projectManagement.sPA.txtSearch, value: task2, action: 'setValue' },
  ]);

  await context().softAssert.isFalse(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, resource1), SHORT_PAUSE), `Resource: {${resource1} is displayed}`);
  await context().softAssert.isFalse(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, resource2), SHORT_PAUSE), `Resource: {${resource2} is displayed}`);
  await context().softAssert.isFalse(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, task1), SHORT_PAUSE), `Task: {${task1} is displayed}`);
  await context().softAssert.isFalse(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, task2), SHORT_PAUSE), `Task: {${task2} is displayed}`);

  await clickToElementUsingJS(Selectors.projectManagement.sPA.closeIconInQuickSearchField);
  await browser.pause(SHORT_PAUSE);
});

Then('ui: I validate that the added resource is in Bulk assignment', async () => {
  const { name, } = context().resourceSetup;
  const ele = locatorParse(Selectors.projectManagement.sPA.bulkAssignmentReso, name);
  await expect(await $(ele)).toBeDisplayed()
})

Then(/^ui: Quick search "(Resource|GenericTask|Non-GenericTask|Resource1|Resource2|Resource3|Task1|Task2)" and verify specific ResourceOrTask is displayed in SPA$/, async (searchEntity: string) => {
  let searchValue;
  switch (searchEntity) {
    case "Resource":
      searchValue = context().resourceSetup.name;
      break;
    case "Resource1":
      searchValue = context().resource1;
      break;
    case "Resource2":
      searchValue = context().resource2;
      break;
    case "Resource3":
      searchValue = context().resourceSetup2.name;
      break;
    case "GenericTask":
      searchValue = "Generic";
      break;
    case "Non-GenericTask":
      searchValue = context().projectSetup.taskName;
      break;
    case "Task1":
      searchValue = context().taskName1;
      break;
    case "Task2":
      searchValue = context().taskName2;
      break;
    default:
      throw new Error(`Invalid search entity:${searchValue}\nSupported Values:\n1.Resource\n2.GenericTask\n3.Non-GenericTask`);
  }
  await formFill([
    { locator: Selectors.projectManagement.sPA.txtSearch, value: null, action: 'click' },
    { locator: Selectors.projectManagement.sPA.txtSearch, value: null, action: 'clearValue' },
    { locator: Selectors.projectManagement.sPA.txtSearch, value: searchValue, action: 'setValue' },
  ]);
  await SingleProjectAllocation.expandResourceIfNotAlreadyExpanded(searchValue);
  assert.isTrue(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, searchValue), SHORT_PAUSE), `Resource/Task: {${searchValue} is not displayed}`);
});

Then('ui: I validate Add Assignment button is not present when project is not Checked out', async () => {
  const ele = await isElementDisplayed(Selectors.projectManagement.sPA.btnAddAssignment);
  assert.isNotTrue(ele, `The Add Assignment button is still displayed although the Project is not checked out`);
});

Then(/^ui: I validate button for specific task to show "([^"]*)" in SPA is clickable$/, async (taskToShow: string) => {
  const ele = await $(locatorParse(Selectors.projectManagement.sPA.taskToShowFilter, taskToShow)).isClickable();
  await context().softAssert.isTrue(ele, `The button for specific task to show ${taskToShow} in SPA is not clickable`);
});

Then('ui: I click on specific Assignment Attribute in SPA', async () => {
  await clickToElement(Selectors.projectManagement.sPA.ddAssignmentAttribute)
})

Then(/^ui: Click on resource or task "([^"]*)" expand icon$/, async (resourceOrTaskName: string) => {
  await elementParseAndClick(Selectors.projectManagement.sPA.expandButtonOfResourceOrTask, resourceOrTaskName);
});

Then(/^ui: Add a new task in SPA when dataset is "(Allocation|Demand)"$/, async (dataset: string) => {
  const { taskName } = context().projectSetup;
  await SingleProjectAllocation.enterTaskNameAndClickOnGreenTickMark(taskName, dataset);
});

Then(/^ui: I expand "([^"]*)" and quick search two resources|task and verify search results in SPA$/, async (resourceOrTask: string) => {
  const resource1 = context().resource1;
  const resource2 = context().resource2;
  const task1 = context().taskName1;
  const task2 = context().taskName2;

  await formFill([
    { locator: Selectors.projectManagement.sPA.txtSearch, value: null, action: 'click' },
    { locator: Selectors.projectManagement.sPA.txtSearch, value: null, action: 'clearValue' },
    { locator: Selectors.projectManagement.sPA.txtSearch, value: resource1, action: 'setValue' },
  ]);
  if (resourceOrTask.toLowerCase() == "resource") {
    await SingleProjectAllocation.expandResourceIfNotAlreadyExpanded(resource1);
  } else {
    await SingleProjectAllocation.expandResourceIfNotAlreadyExpanded(task1);
  }

  await context().softAssert.isTrue(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, resource1), SHORT_PAUSE), `Resource: {${resource1} is not displayed}`);
  await context().softAssert.isFalse(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, resource2), SHORT_PAUSE), `Resource: {${resource2} is displayed}`);
  await context().softAssert.isTrue(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, task1), SHORT_PAUSE), `Task: {${task1} is not displayed}`);
  await context().softAssert.isFalse(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, task2), SHORT_PAUSE), `Task: {${task2} is displayed}`);

  await formFill([
    { locator: Selectors.projectManagement.sPA.txtSearch, value: null, action: 'click' },
    { locator: Selectors.projectManagement.sPA.txtSearch, value: null, action: 'clearValue' },
    { locator: Selectors.projectManagement.sPA.txtSearch, value: resource2, action: 'setValue' },
  ]);
  if (resourceOrTask.toLowerCase() == "resource") {
    await SingleProjectAllocation.expandResourceIfNotAlreadyExpanded(resource2);
  } else {
    await SingleProjectAllocation.expandResourceIfNotAlreadyExpanded(task2);
  }

  await context().softAssert.isTrue(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, resource2), SHORT_PAUSE), `Resource: {${resource2} is not displayed}`);
  await context().softAssert.isFalse(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, resource1), SHORT_PAUSE), `Resource: {${resource1} is displayed}`);
  await context().softAssert.isTrue(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, task2), SHORT_PAUSE), `Task: {${task2} is not displayed}`);
  await context().softAssert.isFalse(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, task1), SHORT_PAUSE), `Task: {${task1} is displayed}`);

  await clickToElementUsingJS(Selectors.projectManagement.sPA.closeIconInQuickSearchField);
  await browser.pause(SHORT_PAUSE);

  await context().softAssert.isTrue(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, resource2), SHORT_PAUSE), `Resource: {${resource2} is displayed}`);
  await context().softAssert.isTrue(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, resource1), SHORT_PAUSE), `Resource: {${resource1} is displayed}`);
  await context().softAssert.isTrue(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, task2), SHORT_PAUSE), `Task: {${task2} is displayed}`);
  await context().softAssert.isTrue(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, task1), SHORT_PAUSE), `Task: {${task1} is displayed}`);

});

Then(/^ui: Allocate "([^"]*)" hours for two resource task in SPA in Month mode for current year when dataset is "([^"]*)" and assignment type "([^"]*)" when Multi assignment is On$/, async (hoursToBeAllocated: string, dataset: string, assignmentType: string) => {
  context().taskName1 = projectModel().taskName;
  context().taskName2 = projectModel().taskName;
  const resources: string[] = [context().resource1, context().resource2];

  for (let i = 0; i < resources.length; i++) {
    await SingleProjectAllocation.selectSpecificDatasetIfNotSelectedAlready(dataset);

    await browser.pause(SHORT_PAUSE);//Required to open dropdown
    await clickToElement(Selectors.projectManagement.sPA.ddGroupByDropdown);
    await browser.pause(SHORT_PAUSE); //Required to open dropdown
    await clickToElement(locatorParse(Selectors.projectManagement.sPA.ddGroupByOption, "Resource"));

    if (dataset.toLowerCase() == "allocation") {
      const el1 = await element(Selectors.projectManagement.sPA.typeANewResourceInputBoxInAllocationSection)
      await el1.click()
      await slowInputFilling(Selectors.projectManagement.sPA.typeANewResourceInputBoxInAllocationSection, resources[i]);
      await browser.pause(SHORT_PAUSE);
      await hitEnter();
    } else {
      const el2 = await element(Selectors.projectManagement.sPA.typeANewResourceInputBoxInDemandSection)
      await el2.click()
      await slowInputFilling(Selectors.projectManagement.sPA.typeANewResourceInputBoxInDemandSection, resources[i]);
      await browser.pause(SHORT_PAUSE);
      await hitEnter();
    }

    await clickToElement(Selectors.common.loginName);
    await clickToElement(Selectors.common.loginName);
    if (!(await isElementDisplayed(await locatorParse('(//span[text()="{{resourceName}} Total"])[2]', resources[i])))) {
      await browser.pause(SHORT_PAUSE * 2);
      await clickToElementUsingJS(Selectors.projectManagement.sPA.expandAllIcon);
    }
    await browser.pause(SHORT_PAUSE);


    const startDate = moment().startOf('year');
    const endDate = moment().endOf('year');
    const betweenMonths = [];
    if (startDate < endDate) {
      const date = startDate.startOf('month');
      while (date < endDate.endOf('month')) {
        betweenMonths.push(date.format(DateFormats.MonthYearFormat2));
        date.add(1, 'month');
      }
    }
    const ele = await $(await locatorParse(`((//div[contains(@class,"ht_clone_inline_start ht_clone_left handsontable")]//tbody//tr//span[normalize-space(text())="{{taskName}}"])[last()]/ancestor::tr/following-sibling::tr//span)[1]`, "Generic")).getText();
    let locator = Selectors.projectManagement.sPA.allocationCellOfResourceForSpecificColumn.replace(/{{resourceName}}/ig, ele);

    switch (dataset.toLocaleLowerCase()) {
      case 'allocation':
        locator = locator.replace(/{{sectionLocator}}/ig, Selectors.projectManagement.sPA.allocationSectionGrid);
        break;
      case 'demand':
        locator = locator.replace(/{{sectionLocator}}/ig, Selectors.projectManagement.sPA.demandSectionGrid);
        break;
      default:
        throw new Error(`Invalid Dataset:${dataset}\nSupported Values:\n1.Allocation\n2.Demand`);
    }

    for (let i = 0; i < betweenMonths.length; i++) {
      await elementParseAndClick(locator, betweenMonths[i]);
      await browser.pause(SHORT_PAUSE)
      await browser.keys(hoursToBeAllocated);
    }
  }
});

Then(/^ui: Allocate random hours for two resource task in SPA in Month mode for current year when dataset is "([^"]*)" and assignment type "([^"]*)"$/, async (dataset: string, assignmentType: string) => {
  context().taskName1 = projectModel().taskName;
  context().taskName2 = projectModel().taskName;
  const resources: string[] = [context().resource1, context().resource2];
  const task: string[] = [context().taskName1, context().taskName2];
  const twoDigitValue = faker.string.numeric(2);
  const threeDigitValue = faker.string.numeric(4);
  const values: string[] = [twoDigitValue, threeDigitValue];

  for (let i = 0; i < resources.length; i++) {
    const hours = values[i];
    await SingleProjectAllocation.selectSpecificDatasetIfNotSelectedAlready(dataset);
    await SingleProjectAllocation.selectSpecificAssignmentTypeIfNotSelectedAlready(assignmentType);

    await browser.pause(SHORT_PAUSE);//Required to open dropdown
    await clickToElement(Selectors.projectManagement.sPA.ddGroupByDropdown);
    await browser.pause(SHORT_PAUSE); //Required to open dropdown
    await clickToElement(locatorParse(Selectors.projectManagement.sPA.ddGroupByOption, "Resource"));

    if (dataset.toLowerCase() == "allocation") {
      const el1 = await element(Selectors.projectManagement.sPA.typeANewResourceInputBoxInAllocationSection)
      await el1.click()
      await slowInputFilling(Selectors.projectManagement.sPA.typeANewResourceInputBoxInAllocationSection, resources[i]);
      await browser.pause(SHORT_PAUSE);
      await hitEnter();
    } else {
      const el2 = await element(Selectors.projectManagement.sPA.typeANewResourceInputBoxInDemandSection)
      await el2.click()
      await slowInputFilling(Selectors.projectManagement.sPA.typeANewResourceInputBoxInDemandSection, resources[i]);
      await browser.pause(SHORT_PAUSE);
      await hitEnter();
    }

    await clickToElement(Selectors.common.loginName);
    await clickToElement(Selectors.common.loginName);
    await SingleProjectAllocation.expandResourceIfNotAlreadyExpanded(resources[i]);
    await browser.pause(SHORT_PAUSE*2);

    if (dataset.toLowerCase() == "allocation") {
      await expect(await element(Selectors.projectManagement.sPA.typeANewTaskInputBoxInAllocationSectionForMA)).toBeClickable()
      await slowInputFilling(Selectors.projectManagement.sPA.typeANewTaskInputBoxInAllocationSectionForMA, task[i]);
      await browser.pause(SHORT_PAUSE);
      await hitEnter();
      // await clickToElement(Selectors.projectManagement.sPA.allocationSectionGrid + Selectors.projectManagement.sPA.applyTaskButton);
    } else {
      await slowInputFilling(Selectors.projectManagement.sPA.typeANewTaskInputBoxInDemandSection, task[i]);
      await browser.pause(SHORT_PAUSE);
      await hitEnter();
      // await clickToElement(Selectors.projectManagement.sPA.demandSectionGrid + Selectors.projectManagement.sPA.applyTaskButton);
    }

    const startDate = moment().startOf('year');
    const endDate = moment().endOf('year');
    const betweenMonths = [];
    if (startDate < endDate) {
      const date = startDate.startOf('month');
      while (date < endDate.endOf('month')) {
        betweenMonths.push(date.format(DateFormats.MonthYearFormat2));
        date.add(1, 'month');
      }
    }
    let locator = Selectors.projectManagement.sPA.allocationCellOfResourceForSpecificColumn.replace(/{{resourceName}}/ig, task[i]);

    switch (dataset.toLocaleLowerCase()) {
      case 'allocation':
        locator = locator.replace(/{{sectionLocator}}/ig, Selectors.projectManagement.sPA.allocationSectionGrid);
        break;
      case 'demand':
        locator = locator.replace(/{{sectionLocator}}/ig, Selectors.projectManagement.sPA.demandSectionGrid);
        break;
      default:
        throw new Error(`Invalid Dataset:${dataset}\nSupported Values:\n1.Allocation\n2.Demand`);
    }

    for (let i = 0; i < betweenMonths.length; i++) {
      await elementParseAndClick(locator, betweenMonths[i]);
      await browser.keys(hours);
    }
    await elementParseAndClick(Selectors.projectManagement.sPA.expandButtonOfResourceOrTask, resources[i]);
  }
});

Then(/^ui: Allocate "([^"]*)" hours for team resource task in SPA in Month mode for current year when dataset is "([^"]*)" and assignment type "([^"]*)"$/, async (hoursToBeAllocated: string, dataset: string, assignmentType: string) => {
  context().taskName1 = projectModel().taskName;
  const teamResourceName = context().teamResourceSetup.name
  const task = context().taskName1;

  await SingleProjectAllocation.selectSpecificDatasetIfNotSelectedAlready(dataset);
  await SingleProjectAllocation.selectSpecificAssignmentTypeIfNotSelectedAlready(assignmentType);

  await browser.pause(SHORT_PAUSE);//Required to open dropdown
  await clickToElement(Selectors.projectManagement.sPA.ddGroupByDropdown);
  await browser.pause(SHORT_PAUSE); //Required to open dropdown
  await clickToElement(locatorParse(Selectors.projectManagement.sPA.ddGroupByOption, "Resource"));

  if (dataset.toLowerCase() == "allocation") {
    const el1 = await element(Selectors.projectManagement.sPA.typeANewResourceInputBoxInAllocationSection)
    await el1.click()
    await slowInputFilling(Selectors.projectManagement.sPA.typeANewResourceInputBoxInAllocationSection, teamResourceName);
    await browser.pause(SHORT_PAUSE);
    await hitEnter();
  } else {
    const el2 = await element(Selectors.projectManagement.sPA.typeANewResourceInputBoxInDemandSection)
    await el2.click()
    await slowInputFilling(Selectors.projectManagement.sPA.typeANewResourceInputBoxInDemandSection, teamResourceName);
    await browser.pause(SHORT_PAUSE);
    await hitEnter();
  }

  await clickToElement(Selectors.common.loginName);
  await clickToElement(Selectors.common.loginName);
  await elementParseAndClick(Selectors.projectManagement.sPA.expandButtonOfResourceOrTask, teamResourceName);
  await browser.pause(SHORT_PAUSE);

  if (await isElementDisplayed(Selectors.projectManagement.sPA.resourceHaveAlready)) {
    await elementParseAndClick(Selectors.projectManagement.sPA.expandButtonOfResourceOrTask, teamResourceName);
  }

  if (dataset.toLowerCase() == "allocation") {
    await slowInputFilling(Selectors.projectManagement.sPA.typeANewTaskInputBoxInAllocationSection, task);
    await browser.pause(SHORT_PAUSE);
    await clickToElement(Selectors.projectManagement.sPA.allocationSectionGrid + Selectors.projectManagement.sPA.applyTaskButton);
  } else {
    await slowInputFilling(Selectors.projectManagement.sPA.typeANewTaskInputBoxInDemandSection, task);
    await browser.pause(SHORT_PAUSE);
    await clickToElement(Selectors.projectManagement.sPA.demandSectionGrid + Selectors.projectManagement.sPA.applyTaskButton);
  }

  const startDate = moment().startOf('year');
  const endDate = moment().endOf('year');
  const betweenMonths = [];
  if (startDate < endDate) {
    const date = startDate.startOf('month');
    while (date < endDate.endOf('month')) {
      betweenMonths.push(date.format(DateFormats.MonthYearFormat2));
      date.add(1, 'month');
    }
  }
  let locator = Selectors.projectManagement.sPA.allocationCellOfResourceForSpecificColumn.replace(/{{resourceName}}/ig, task);

  switch (dataset.toLocaleLowerCase()) {
    case 'allocation':
      locator = locator.replace(/{{sectionLocator}}/ig, Selectors.projectManagement.sPA.allocationSectionGrid);
      break;
    case 'demand':
      locator = locator.replace(/{{sectionLocator}}/ig, Selectors.projectManagement.sPA.demandSectionGrid);
      break;
    default:
      throw new Error(`Invalid Dataset:${dataset}\nSupported Values:\n1.Allocation\n2.Demand`);
  }

  for (let i = 0; i < betweenMonths.length; i++) {
    await elementParseAndClick(locator, betweenMonths[i]);
    await browser.pause(SHORT_PAUSE)
    await browser.keys(hoursToBeAllocated);
  }
  await elementParseAndClick(Selectors.projectManagement.sPA.expandButtonOfResourceOrTask, teamResourceName);
});

When(/^ui: Allocate "([^"]*)" hours for Team Resource "(1|2)" to project in SPA in Month mode for current year when dataset is "([^"]*)" and assignment type "([^"]*)"$/, async (hoursToBeAllocated: string, tr: string, dataset: string, assignmentType: string) => {
  let username;
  switch (tr) {
    case '1':
      username = context().teamresource1;
      break;
    case '2':
      username = context().teamresource2;
      break;
  }
  await SingleProjectAllocation.selectSpecificDatasetIfNotSelectedAlready(dataset);
  await SingleProjectAllocation.selectSpecificAssignmentTypeIfNotSelectedAlready(assignmentType);

  await browser.pause(SHORT_PAUSE);//Required to open dropdown
  await clickToElement(Selectors.projectManagement.sPA.ddGroupByDropdown);
  await browser.pause(SHORT_PAUSE); //Required to open dropdown
  await clickToElement(locatorParse(Selectors.projectManagement.sPA.ddGroupByOption, "Resource"));

  if (dataset.toLowerCase() == "allocation") {
    await formFill([
      { locator: Selectors.projectManagement.sPA.typeANewResourceInputBoxInAllocationSection, value: null, action: 'click' },
      { locator: Selectors.projectManagement.sPA.typeANewResourceInputBoxInAllocationSection, value: null, action: 'clearValue' },
      { locator: Selectors.projectManagement.sPA.typeANewResourceInputBoxInAllocationSection, value: username, action: 'setValue' },
    ]);
    await browser.pause(SHORT_PAUSE);
    await hitEnter();
  } else {
    await formFill([
      { locator: Selectors.projectManagement.sPA.typeANewResourceInputBoxInDemandSection, value: null, action: 'click' },
      { locator: Selectors.projectManagement.sPA.typeANewResourceInputBoxInDemandSection, value: null, action: 'clearValue' },
      { locator: Selectors.projectManagement.sPA.typeANewResourceInputBoxInDemandSection, value: username, action: 'setValue' },
    ]);
    await browser.pause(SHORT_PAUSE);
    await hitEnter();
  }

  const startDate = moment().startOf('year');
  const endDate = moment().endOf('year');
  const betweenMonths = [];
  if (startDate < endDate) {
    const date = startDate.startOf('month');
    while (date < endDate.endOf('month')) {
      betweenMonths.push(date.format(DateFormats.MonthYearFormat2));
      date.add(1, 'month');
    }
  }
  let locator = Selectors.projectManagement.sPA.allocationCellOfResourceForSpecificColumn.replace(/{{resourceName}}/ig, username);

  switch (dataset.toLocaleLowerCase()) {
    case 'allocation':
      locator = locator.replace(/{{sectionLocator}}/ig, Selectors.projectManagement.sPA.allocationSectionGrid);
      break;
    case 'demand':
      locator = locator.replace(/{{sectionLocator}}/ig, Selectors.projectManagement.sPA.demandSectionGrid);
      break;
    default:
      throw new Error(`Invalid Dataset:${dataset}\nSupported Values:\n1.Allocation\n2.Demand`);
  }

  await elementParseAndClick(Selectors.projectManagement.sPA.expandButtonOfResourceOrTask, username);
  for (let i = 0; i < betweenMonths.length; i++) {
    await elementParseAndClick(locator, betweenMonths[i]);
    await browser.pause(SHORT_PAUSE)
    await browser.keys(hoursToBeAllocated);

  }
});

Then(/^ui: Allocate "([^"]*)" hours for resource task in SPA in Month mode for current year when dataset is "([^"]*)" and assignment type "([^"]*)"$/, async (hoursToBeAllocated: string, dataset: string, assignmentType: string) => {
  const { taskName } = context().projectSetup;
  const resourceName = context().resourceSetup.name

  await SingleProjectAllocation.selectSpecificDatasetIfNotSelectedAlready(dataset);
  await SingleProjectAllocation.selectSpecificAssignmentTypeIfNotSelectedAlready(assignmentType);

  await browser.pause(SHORT_PAUSE);//Required to open dropdown
  await clickToElement(Selectors.projectManagement.sPA.ddGroupByDropdown);
  await browser.pause(SHORT_PAUSE); //Required to open dropdown
  await clickToElement(locatorParse(Selectors.projectManagement.sPA.ddGroupByOption, "Resource"));

  if (dataset.toLowerCase() == "allocation") {
    const el1 = await element(Selectors.projectManagement.sPA.typeANewResourceInputBoxInAllocationSection)
    await el1.click()
    await slowInputFilling(Selectors.projectManagement.sPA.typeANewResourceInputBoxInAllocationSection, resourceName);
    await browser.pause(SHORT_PAUSE);
    await hitEnter();
  } else {
    const el2 = await element(Selectors.projectManagement.sPA.typeANewResourceInputBoxInDemandSection)
    await el2.click()
    await slowInputFilling(Selectors.projectManagement.sPA.typeANewResourceInputBoxInDemandSection, resourceName);
    await browser.pause(SHORT_PAUSE);
    await hitEnter();
  }

  await clickToElement(Selectors.common.loginName);
  await clickToElement(Selectors.common.loginName);
  await elementParseAndClick(Selectors.projectManagement.sPA.expandButtonOfResourceOrTask, resourceName);
  await browser.pause(SHORT_PAUSE);

  if (await isElementDisplayed(Selectors.projectManagement.sPA.resourceHaveAlready)) {
    await elementParseAndClick(Selectors.projectManagement.sPA.expandButtonOfResourceOrTask, resourceName);
  }

  if (dataset.toLowerCase() == "allocation") {
    await slowInputFilling(Selectors.projectManagement.sPA.typeANewTaskInputBoxInAllocationSection, taskName);
    await browser.pause(SHORT_PAUSE);
    await clickToElement(Selectors.projectManagement.sPA.allocationSectionGrid + Selectors.projectManagement.sPA.applyTaskButton);
  } else {
    await slowInputFilling(Selectors.projectManagement.sPA.typeANewTaskInputBoxInDemandSection, taskName);
    await browser.pause(SHORT_PAUSE);
    await clickToElement(Selectors.projectManagement.sPA.demandSectionGrid + Selectors.projectManagement.sPA.applyTaskButton);
  }

  const startDate = moment().startOf('year');
  const endDate = moment().endOf('year');
  const betweenMonths = [];
  if (startDate < endDate) {
    const date = startDate.startOf('month');
    while (date < endDate.endOf('month')) {
      betweenMonths.push(date.format(DateFormats.MonthYearFormat2));
      date.add(1, 'month');
    }
  }
  let locator = Selectors.projectManagement.sPA.allocationCellOfResourceForSpecificColumn.replace(/{{resourceName}}/ig, taskName);

  switch (dataset.toLocaleLowerCase()) {
    case 'allocation':
      locator = locator.replace(/{{sectionLocator}}/ig, Selectors.projectManagement.sPA.allocationSectionGrid);
      break;
    case 'demand':
      locator = locator.replace(/{{sectionLocator}}/ig, Selectors.projectManagement.sPA.demandSectionGrid);
      break;
    default:
      throw new Error(`Invalid Dataset:${dataset}\nSupported Values:\n1.Allocation\n2.Demand`);
  }
  await SingleProjectAllocation.unselectColumnsIfAny();
  for (let i = 0; i < betweenMonths.length; i++) {
    await elementParseAndClick(locator, betweenMonths[i]);
    await browser.pause(SHORT_PAUSE)
    await browser.keys(hoursToBeAllocated);
  }
  await elementParseAndClick(Selectors.projectManagement.sPA.expandButtonOfResourceOrTask, resourceName);
});

Then(/^ui: Add a new "(Task1|Task2|Generic)" in SPA when dataset is "(Allocation|Demand)"$/, async (taskType:string,dataset: string) => {
  let taskName;
  switch (taskType) {
    case "Task1":
      context().taskName1 = projectModel().taskName;
      taskName = context().taskName1
      break;
    case "Task2":
      context().taskName2 = projectModel().taskName;
      taskName = context().taskName2
      break;
    case "Generic":
      taskName = "Generic"
      break;
    default:
      break;
  }
  await SingleProjectAllocation.enterTaskNameAndClickOnGreenTickMark(taskName, dataset);
});

Then(/^ui: I add a new Assignament with same resource in assignment options$/, async () => {
  const sameTask = await elementGetText(Selectors.projectManagement.sPA.getTaskName) 
  await slowInputFilling(Selectors.projectManagement.sPA.taskAddInputAssignmentOptions , sameTask);
  await hitEnter()
});

Then(/^ui: I validate that only task cannot be added in project without selecting resource$/, async() => {
  const searchTask = context().projectSetup.taskName;
	await clickToElement(`//label[text()="${searchTask}"]`);
  const isClickable = await (await $(Selectors.projectManagement.sPA.btnAddBulkAssignment)).isClickable();
  await context().softAssert.isFalse(isClickable, 'Only Task Can be added in project')
});

Then(/^ui: I click on "(Single|Bulk)" section in add assignment in SPA$/, async(sectionName:string) => {
	await elementParseAndClick(Selectors.projectManagement.sPA.tabSwitchInAddAssignment , sectionName)
});

Then(/^ui: I validate that assignment options menu opened$/, async() => {
  const name = context().resourceSetup.name
  await context().softAssert.isTrue(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.assignmentOptionTitle, name) , SHORT_PAUSE*2), `Assignment Option title for Resource:${name} is not displayed`);
});

Then(/^ui: I validate that task name is required field in assignment in SPA$/, async() => {
  await context().softAssert.isTrue(await isElementDisplayed(Selectors.projectManagement.sPA.requiredTaskName, SHORT_PAUSE*2), `Required Sign for task name is not displayed`);
});

Then(/^ui: I enter new assignment start date is:"([^"]*)" in assignment options$/, async(dateToBeEntered:string) => {
	await formFill([
    { locator: Selectors.projectManagement.sPA.newAssignmentStartdate, value: null, action: 'clearValue' },
    { locator: Selectors.projectManagement.sPA.newAssignmentStartdate, value: dateToBeEntered, action: 'setValue' },
  ]);
  await hitEnter();
});

Then(/^ui: I click on specific unit "([^"]*)" in Add Assignment SPA$/, async (unitToBeVerified: string) => {
  switch (unitToBeVerified) {
    case GeneralSettings.Units.Time:
    case GeneralSettings.Units.FTE:
    case GeneralSettings.Units.Cost:
    case GeneralSettings.Units.Gantt:
    case GeneralSettings.Units.Manday:
    case GeneralSettings.Units.StoryPoints:
      await elementParseAndClick(Selectors.projectManagement.sPA.specificUnitTabLabelInAddAssignment, unitToBeVerified);
      await browser.pause(SHORT_PAUSE)
      break;
    case GeneralSettings.Units.FTEPercent:
      await clickToElement(Selectors.projectManagement.sPA.ftePercentTabLabelInAddAssignment);
      break;
    default: throw Error(`Incorrect unit:{${unitToBeVerified}}\nSupported values (Case sensitive):${Object.values(GeneralSettings.Units)}`);
  }
});

Then(/^ui: I turn "([^"]*)" apply to weekends button in Add Assignemnt In SPA$/, async(toggleType:string) => {
	const applyToWeekendsBtn = element(Selectors.projectManagement.sPA.applyToWeekendsBtnInAddAssignmentInput);
  const isSelected = await (await applyToWeekendsBtn).isSelected();
  if (!isSelected && toggleType.toLowerCase() === "on") {
    await clickToElement(Selectors.projectManagement.sPA.applyToWeekendsBtnInAddAssignment);
  } else if (isSelected && toggleType.toLowerCase() === "off") {
    await clickToElement(Selectors.projectManagement.sPA.applyToWeekendsBtnInAddAssignment);
  }
});

Then(/^ui: I validate that current assignment start date is:"([^"]*)" in assignment options$/, async(datetoBeVerify:string) => {
	await context().softAssert.equal(await elementGetText(Selectors.projectManagement.sPA.currentAssignmentStartDate), datetoBeVerify, "Start date is not same for assignemt options")
});

Then(/^ui: I click on "(Clone|Shift)" tab in assignment options$/, async(tabToBeClicked:string) => {
	await elementParseAndClick(Selectors.projectManagement.sPA.assignmentOptionTabSwitch, tabToBeClicked);
});

Then(/^ui: I enter value as "([^"]*)" hours in add assignment SPA$/, async(valueToBeEntered:string) => {
	await slowInputFilling(Selectors.projectManagement.sPA.enterValueInputAddAssignment, valueToBeEntered)
});

Then('ui: I click on Replace Resource and verify task is replaced', async () => {
  await clickToElement(Selectors.projectManagement.sPA.resourceReplace.replaceAction)
  await clickToElement(Selectors.projectManagement.sPA.resourceReplace.btnReplace)
  await browser.pause(SHORT_PAUSE*2);
  await context().softAssert.isFalse(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, context().projectSetup.taskName), SHORT_PAUSE), `Resource: ${context().projectSetup.taskName} is displayed after resource replace`);
  await context().softAssert.isTrue(await isElementDisplayed(locatorParse(Selectors.projectManagement.sPA.specificResourceOrTask, 'Administrator'), SHORT_PAUSE), `Resource: 'Administrator' is not displayed after resource replace`);
});

// Then(/^ui: Click on Add Assignment button and "([^"]*)" resource with "([^"]*)" task in SPA$/, async (perform: string,taskType: string) => {
//   let { resourceSetup: {name}, projectSetup: {taskName} } = context()
//   taskName = taskType != "Generic"? taskName :"Generic"
//   await clickToElement(Selectors.projectManagement.sPA.addAssignment.addAssignmentButton);
//   await browser.pause(SHORT_PAUSE / 2)
//   await slowInputFilling(Selectors.projectManagement.sPA.addAssignment.searchTask,taskName)
//   taskType != "Generic" && await clickToElement(Selectors.projectManagement.sPA.buttonAddTask);
//   await hitEnter();
//   await slowInputFilling(Selectors.bulkProjectAllocationFlatgrid.searchPlaceholderResourceReplace, name)
//   await clickToElement(locatorParse(Selectors.projectManagement.sPA.resourceNameInAddAssignment,name))
//   if (perform == "add") {
//     await clickToElement(Selectors.projectManagement.sPA.btnAddBulkAssignment)
//   } else if (perform == "validate"){
//     await slowInputFilling(Selectors.projectManagement.sPA.addAssignment.searchTask,taskName)
//     const actualTaskName = await elementGetValue(Selectors.projectManagement.sPA.addAssignment.searchTask)
//     await context().softAssert.equal(actualTaskName, taskName, `Actual Task Value: ${actualTaskName} Expected Task Value: ${taskName} in SPA in Add Assignment Option`)
//   }
// });

// Then(/^ui: I validate "([^"]*)" assignament under a generic task inn SPA$/, async (expectedCount: string) => {
//   const { taskName } = context().projectSetup
//   const genericCount = await elementArray(locatorParse(Selectors.projectManagement.sPA.countGeneric,taskName));
//   await context().softAssert.equal(genericCount.length,expectedCount,`Actual Count: ${genericCount} or Expected Count: ${expectedCount} of Generic Assignment`);
// });

Then(/^ui: I verify label for "([^"]*)" task is visible in SPA$/, async(labelName : string) => {
  if (labelName.toLowerCase() == 'all'){
  await context().softAssert.isFalse(await isElementDisplayed(locatorParse(Selectors.common.nameFind3 , labelName)), `${labelName} is not visible`);
  } else {
  await context().softAssert.isTrue(await isElementDisplayed(locatorParse(Selectors.common.nameFind3 , labelName)), `${labelName} is not visible`);
  }
});

Then(/^ui: I validate Current task name should be show right "([^"]*)"$/, async (type: string) => {
	let taskName;
  switch (type) {
    case "resource":
      taskName = "Generic"
      break;
    case "task":
      taskName = await context().projectSetup.taskName
      break;
  }
  const actualText = await elementGetText(Selectors.projectManagement.sPA.getTaskName) 
  await context().softAssert.equal(actualText, taskName, `Actual Value: ${actualText} or Expected value: ${taskName} does  not match in Assignment options`)
});

Then(/^ui: Allocate "([^"]*)" hours for resource task to project in SPA in Month mode for current year when dataset is "([^"]*)"$/,async (hoursToBeAllocated: string, dataset: string) => {
  const resourceName = context().projectSetup.taskName;

  const startDate = moment().startOf('year');
  const endDate = moment().endOf('year');
  const betweenMonths = [];
  if (startDate < endDate) {
    const date = startDate.startOf('month');
    while (date < endDate.endOf('month')) {
      betweenMonths.push(date.format(DateFormats.MonthYearFormat2));
      date.add(1, 'month');
    }
  }
  let locator = Selectors.projectManagement.sPA.allocationCellOfResourceForSpecificColumn.replace(/{{resourceName}}/ig, resourceName);

  switch (dataset.toLocaleLowerCase()) {
    case 'allocation':
      locator = locator.replace(/{{sectionLocator}}/ig, Selectors.projectManagement.sPA.allocationSectionGrid);
      break;
    case 'demand':
      locator = locator.replace(/{{sectionLocator}}/ig, Selectors.projectManagement.sPA.demandSectionGrid);
      break;
    default:
      throw new Error(`Invalid Dataset:${dataset}\nSupported Values:\n1.Allocation\n2.Demand`);
  }
  for (let i = 0; i < betweenMonths.length; i++) {
    await elementParseAndClick(locator, betweenMonths[i]);
    await browser.pause(SHORT_PAUSE)
    await browser.keys(hoursToBeAllocated);
    await hitEnter()
  }
});

Then(/^ui: Validate "([^"]*)" hours for assignment at "([^"]*)" index to project in SPA in "([^"]*)" mode for current year$/, async (hoursToBeAllocated: string, indexValue: string, modeOfEntry: string) => {
  const resourceName = 'Assignment #';
  let dataArray:string | string[] = hoursToBeAllocated.split(',');
  let finalDataArray
  if(dataArray.length >= 2){
    finalDataArray = dataArray.map(element => element.replace(/[.\s]+/g, ""));
  } else{
    dataArray = dataArray[0]
  }

  const startDate = moment().startOf('year');
  const endDate = moment().endOf('year');
  const numberOfColumns = [];
  if (modeOfEntry == 'Year') {
    let date = startDate.clone(); // Use clone() to avoid modifying startDate directly
    while (date.isSameOrBefore(endDate, 'year')) {
      numberOfColumns.push(date.year());
      date.add(1, 'year');
    }
  } else if (modeOfEntry == 'Month') {
    if (startDate < endDate) {
      const date = startDate.startOf('month');
      while (date < endDate.endOf('month')) {
        numberOfColumns.push(date.format(DateFormats.MonthYearFormat2));
        date.add(1, 'month');
      }
    }
  }

  let locator = Selectors.projectManagement.sPA.allocationCellOfResourceAssignmentForSpecificColumn.replace(/{{resourceName}}/ig, resourceName);
  locator = locator.replace(/{{sectionLocator}}/ig, Selectors.projectManagement.sPA.allocationSectionGrid);
  locator = locator.replace(/{{index}}/ig, indexValue);

  for (let i = 0; i < numberOfColumns.length; i++) {
    const ele = await $(await locatorParse(locator, numberOfColumns[i])).getText();
    const value = await ele.replace(/[.,\s]+/g, "");
    await context().softAssert.equal(value, !finalDataArray ? dataArray : finalDataArray[i], `Column: ${numberOfColumns[i]} donot contain the updated value in SPA`);
  };

});