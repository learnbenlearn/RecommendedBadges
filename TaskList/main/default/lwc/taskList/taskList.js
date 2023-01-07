import { LightningElement, wire, track } from 'lwc';

import { refreshApex } from '@salesforce/apex';

import getTasks from '@salesforce/apex/TaskListController.getTasks';

const SPINNER_TEXT = 'Retrieving tasks';

export default class TaskList extends LightningElement {
    displaySpinner = true;
    displayTaskList;
    noTasks;
    noTasksMessage = '<b>No tasks!</b>';
    parseTasksResponse;
    spinnerText = SPINNER_TEXT;
    @track taskList;

    @wire(getTasks)
    parseTasks(value) {
        console.log(value);
        console.log(this.parseTasksResponse);
        if(this.parseTasksResponse === value) {
            this.displaySpinner = false;
        } else {
            this.parseTasksResponse = value;
            const {error, data} = value;
    
            if(data) {
                let tasks = data;
    
                if(tasks.length > 0) {
                    this.taskList = [];
                    for(let task of tasks) {
                        this.taskList.push({
                            'Id': '/' + task.Id,
                            'Subject': task.Subject
                        });
                    }
                    this.displayTaskList = true;
                    this.noTasks = false;
                } else {
                    this.displayTaskList = false;
                    this.noTasks = true;
                }
                
                this.displaySpinner = false;
            } else if(error) {
                console.error(error);
            }
        }
    }

    async handleRefresh() {
        this.displaySpinner = true;
        await refreshApex(this.parseTasksResponse);
        this.displaySpinner = false;
    }
}